require 'fileutils'
require 'pathname'
require 'yaml'

require 'thor'
require 'listen'

require 'versacommerce/cli/simple_logger'
require 'versacommerce/theme_api_client'

module Versacommerce
  module CLI
    class Theme < Thor
      def self.exit_on_failure?
        true
      end

      class_option :authorization, aliases: :a
      class_option :config, banner: 'CONFIG_PATH', aliases: :c
      class_option :verbose, type: :boolean, aliases: :v
      class_option :save_config, banner: 'CONFIG_PATH', aliases: :s

      desc 'download', 'Downloads a complete Theme from the Theme API.'
      option :path, default: './theme'
      def download
        ensure_authorization!
        save_config

        path = Pathname.new(options[:path]).expand_path
        logger.info("Downloading Theme to #{path}")

        client.files(recursive: true).each do |file|
          logger.debug("Downloading #{file.path}")
          file.reload_content
          file_path = path.join(file.path)
          FileUtils.mkdir_p(file_path.parent)
          File.open(file_path, 'wb') { |f| f.write(file.content) }
        end

        logger.success('Finished downloading Theme')
      end

      desc 'watch', 'Watches a directory and pushes file changes to the Theme API.'
      option :path, default: '.'
      def watch
        ensure_authorization!
        save_config

        theme_path = Pathname.new(options[:path]).expand_path
        validate_path!(theme_path)

        logger.info "Watching #{theme_path}"

        listener = Listen.to(theme_path) do |modified, added, removed|
          removed.each { |absolute_path| delete_file(theme_path, absolute_path) }

          modified.concat(added).each do |absolute_path|
            delete_file(theme_path, absolute_path)
            add_file(theme_path, absolute_path)
          end
        end

        begin
          listener.start
          sleep
        rescue SystemExit, Interrupt
          logger.info('Stopped watching')
          exit
        end
      end

      desc 'upload', 'Uploads a directory and its descendants to the Theme API.'
      option :path, default: '.'
      def upload
        ensure_authorization!
        save_config

        theme_path = Pathname.new(options[:path]).expand_path
        validate_path!(theme_path)

        logger.info "Uploading #{theme_path}"
        add_directory(theme_path, theme_path)
        logger.success("Uploaded #{theme_path}")
      end

      private

      def add_file(theme_path, absolute_path)
        relative_path = Pathname.new(absolute_path).relative_path_from(theme_path)
        file = client.files.build(path: relative_path, content: File.read(absolute_path))

        if file.valid?
          logger.debug("Trying to add #{relative_path}")

          if file.save
            logger.success("Added #{relative_path}")
          else
            logger.error("Could not add #{relative_path}:")
            file.errors.full_messages.each { |msg| logger.error("  #{msg}") }
          end
        else
          logger.error("Could not add #{relative_path}:")
          file.errors.full_messages.each { |msg| logger.error("  #{msg}") }
        end
      end

      def delete_file(theme_path, absolute_path, log: true)
        relative_path = Pathname.new(absolute_path).relative_path_from(theme_path)
        client.files.delete(relative_path)
      rescue Versacommerce::ThemeAPIClient::Fetcher::RecordNotFoundError
      end

      def add_directory(theme_path, path)
        path.children.each do |child|
          case child.ftype
          when 'file'
            delete_file(theme_path, child)
            add_file(theme_path, child)
          when 'directory'
            add_directory(theme_path, child)
          end
        end
      end

      def client
        @client ||= ThemeAPIClient.new(authorization: authorization)
      end

      def save_config
        if config = options[:save_config]
          path = case config
          when 'save_config'
            Pathname.pwd.expand_path
          else
            Pathname.new(config).expand_path
          end

          validate_path!(path)
          yaml = {'authorization' => authorization}.to_yaml
          File.write(path.join('config.yml'), yaml)
          logger.debug("Saved config.yml to #{path}")
        end
      end

      def ensure_authorization!
        unless authorization
          logger.error('Could not find authorization.')
          exit 1
        end
      end

      def validate_path!(path)
        unless path.directory?
          logger.error("#{path} is not a directory.")
          exit 1
        end
      end

      def authorization
        options[:authorization] || explicit_config['authorization'] || implicit_pwd_config['authorization'] || ENV['THEME_AUTHORIZATION'] || implicit_config['authorization']
      end

      def explicit_config
        @explicit_config ||= options[:config] ? YAML.load_file(options[:config], permitted_classes: [Symbol]) : {}
      end

      def implicit_pwd_config
        @implicit_pwd_config ||= begin
          config = Pathname.pwd.join('config.yml').expand_path
          config.file? ? YAML.load_file(config, permitted_classes: [Symbol]) : {}
        end
      end

      def implicit_config
        @implicit_config ||= begin
          config = Pathname.new('~/.config/versacommerce/cli/config.yml').expand_path
          config.file? ? YAML.load_file(config, permitted_classes: [Symbol]) : {}
        end
      end

      def logger
        @logger ||= SimpleLogger.new(options[:verbose])
      end
    end
  end
end

require 'colorize'

module Versacommerce
  module CLI
    class SimpleLogger
      attr_accessor :verbose

      def initialize(verbose)
        @verbose = verbose
      end

      def info(*messages)
        write(*messages)
      end

      def debug(*messages)
        write(*messages) if verbose
      end

      def success(*messages)
        colorized_messages = messages.map { |msg| msg.colorize(:green) }
        write(*colorized_messages)
      end

      def error(*messages)
        colorized_messages = messages.map { |msg| msg.colorize(:red) }
        write(*colorized_messages)
      end

      private

      def write(*messages)
        messages.each do |message|
          puts '-- %s' % message
        end
      end
    end
  end
end

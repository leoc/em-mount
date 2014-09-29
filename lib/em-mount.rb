require 'securerandom'

require "em-mount/version"

module EventMachine
  class Mount
    attr_accessor :target, :path, :options

    def initialize target, options={}, &block
      @target = target
      @options = options
      @path = "/mnt/#{SecureRandom.uuid}"
      @mounted = false
      @execution_proc = block
    end

    def mount &block
      return if @mounted

      proc = block ? block : @execution_proc

      EM::SystemCommand.execute "mkdir #{@path}" do |on|
        on.success do
          command = ['mount', @target, @path]
          unless options.empty?
            options_arg = @options.map{ |k,v| "#{k}=#{v}" }.join(',')
            command << "-o #{options_arg}"
          end
          cmd = EM::SystemCommand.execute *command, &proc
          cmd.success { @mounted = true }
        end
      end

      self
    end

    def unmount &block
      return unless @mounted
      cmd = EM::SystemCommand.execute 'umount', @path
      cmd.success do
        @mounted = false
        delete_mount_folder(&block)
      end
      cmd.failure do
        EM::Timer.new(5) { unmount(&block) }
      end
    end

    def delete_mount_folder(&block)
      EM::SystemCommand.execute 'rmdir', @path do |on|
        on.success do
          block.call if block
        end
        on.failure do
          EM::Timer.new(5) { delete_mount_folder(&block) }
        end
      end
    end

    def self.mount *args, &block
      mount = Mount.new *args, &block
      mount.mount
    end

  end
end

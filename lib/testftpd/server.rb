require_relative '../../vendor/dyn-ftp-serv/dynftp_server'
require_relative 'file_system_provider'

require 'timeout'

Thread.abort_on_exception = true

module TestFtpd

  class Server < DynFTPServer
    def initialize(config = {})
      config.merge!(:root => FileSystemProvider.new(config[:root_dir], self))
      @ftp_thread = nil
      super(config)
    end

    def running?
      @ftp_thread && @ftp_thread.alive?
    end

    def start(timeout = 2)
      Timeout.timeout(timeout) do
        return if @ftp_thread
        @ftp_thread = Thread.new { mainloop }
        sleep 0.1 until running?
      end
    rescue TimeoutError
      raise TimeoutError.new('TestFtpd::Server timeout before start succeeded.')
    end

    def shutdown(timeout = 2)
      Timeout.timeout(timeout) do
        if running?
          @ftp_thread.kill
          sleep 0.1 while running?
          @ftp_thread = nil
        end
        @server.close unless @server.closed?
      end
    rescue TimeoutError
      raise TimeoutError.new('TestFtpd::Server timeout before shutdown succeeded.')
    end
  end

end

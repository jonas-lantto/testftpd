#!/usr/bin/env ruby

require_relative '../lib/testftpd'
require 'optparse'

options = { :root_dir => '/', :port => 21 }
OptionParser.new do |opts|
  opts.on(
    '-r', '--root-dir ROOT_DIR',
    'Use ROOT_DIR as the root directory of the FTP server'
  ) do |root_dir|
    options[:root_dir] = root_dir
  end
  
  opts.on(
    '-p', '--port FTP_PORT',
    'Use FTP_PORT as the port number of the FTP server'
  ) do |ftp_port|
    options[:port] = ftp_port
  end
end.parse!

puts "Starting FakeFTP::Server with root directory '#{options[:root_dir]}' and port #{options[:port]}"
TestFtpd::Server.new options
while true
  sleep 0.1
end

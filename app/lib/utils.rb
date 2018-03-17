require 'fileutils'

def folder(path)
  root = File.dirname(__FILE__).gsub('/lib','').gsub('/app', '/')
  path = "#{root}/#{path}"
  unless Dir.exist? path
    FileUtils.mkdir_p(path)
  end
  path
end

def confile(path)
  root = File.dirname(__FILE__).gsub('/lib','').gsub('/app', '/config')
  unless Dir.exist? root
    FileUtils.mkdir_p(root)
  end
  file = "#{root}/#{path}"
  FileUtils.touch file
  return file
end


=begin

  Anton A. Nesterov (c) 2018, CC-BY-SA 4.0
  License: https://creativecommons.org/licenses/by-sa/4.0/

=end

require_relative './globals'
require_relative './extra/eml'
require_relative '../hooks'

class MaildropWatcher < J::Thread
  
  def initialize
    @uidtable = Storage.new('maildrop.indexes')
    @pause = false
    reload()
  end
  
  def reload
    @pause = true
    @names = Hooks.registry.keys
    for name in @names
      @uidtable.add(name, 0) if @uidtable.get(name).nil?
    end
    @pause = false
  end
  
  def uid_to_int uid
    uid.gsub('+', '').strip().to_i
  end
  
  def check
    for name in @names
      f = storagefile("maildrops/#{name}/uid.txt", false)
      next unless File.exist? f
      data = File.read f
      old_uid = @uidtable.get(name)
      current_uid = uid_to_int(data)
      if old_uid < current_uid
        for uid in (old_uid+1)..current_uid
          hook(name, uid)
        end
        @uidtable.add(name, current_uid)
      end
    end
  end
  
  def hook(name, uid)
    hooks = Hooks.registry[name]
    for cb in hooks
      file = storagefile("maildrops/#{name}/#{uid}.eml", false)
      begin
        cb.call(Eml.new(file))
      rescue Exception => e
        puts 'Error while executing hook'
        puts e.message
      end
    end
  end
  
  def run
    while true do
      sleep 0.3
      check() unless @pause
    end
  end
  
end
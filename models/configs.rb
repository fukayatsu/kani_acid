class Configs < ActiveRecord::Base
  table_name = 'configs'

  class << self
    def [](name)
      Configs.where(name: name).first.try(:value)
    end

    def []=(name, value)
      config = Configs.where(name: name).first_or_initialize
      config.value = value
      config.save!
      config.value
    end

    def method_missing(m, *args, &block)
      name = m.to_s.split('=')[0]
      if m.to_s.match(/=$/)
        Configs[name] = args[0]
      else
        Configs[name]
      end
    end
  end
end
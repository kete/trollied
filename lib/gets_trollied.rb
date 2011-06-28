# -*- coding: utf-8 -*-
require "active_record"

module GetsTrollied
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def set_up_to_get_trollied(*args)
      options = args.last.is_a?(Hash) ? args.pop : Hash.new

      # don't allow multiple calls
      return if self.included_modules.include?(GetsTrollied::InstanceMethods)

      send :include, GetsTrollied::InstanceMethods

      send :has_many, :line_items, :as => :purchasable_item, :dependent => :destroy

      cattr_accessor :described_as_when_purchasing
      self.described_as_when_purchasing = options[:described_as] || :name

      cattr_accessor :as_foreign_key_sym
      self.as_foreign_key_sym = self.name.foreign_key.to_sym
    
    end
  end

  module InstanceMethods
    def place_in(trolley)
      trolley.add(self)
    end

    def description_for_purchasing
      send(self.class.described_as_when_purchasing)
    end
  end
end

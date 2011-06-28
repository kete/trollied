# -*- coding: utf-8 -*-
require "active_record"

module HasTrolley
  unless included_modules.include? HasTrolley
    def self.included(klass)
      klass.send :has_one, :trolley, :dependent => :destroy
      klass.send :delegate, :correct_purchase_order, :to => :trolley
    end

    def trolley
      @trolley ||= Trolley.create!(:user => self)
    end
  end
end

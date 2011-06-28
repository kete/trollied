# -*- coding: utf-8 -*-
require "active_record"

module HasTrolley
  def self.included(klass)
    klass.send :has_one, :trolley, :dependent => :destroy
    klass.send :delegate, :correct_order, :to => :trolley
    klass.send :after_create, :create_trolley
    klass.extend ClassMethods
    klass.send :include, InstanceMethods
  end
  
  module ClassMethods
    def add_trolleys_for_existing
      all.each { |u| u.create_trolley }
    end
  end

  module InstanceMethods
    # implement in your application if you have another method name
    # besides these common ones
    # WARNING: potential security issue, definitely override
    # if any of these options are sensitive
    def trolley_user_display_name
      if respond_to?(:display_name)
        display_name
      elsif respond_to?(:name)
        name
      elsif respond_to?(:username)
        username
      elsif respond_to?(:nickname)
        nickname
      end
    end

    private
    
    def create_trolley
      Trolley.create!(:user => self)
    end
  end
end

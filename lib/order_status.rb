# off the top of my head possible states:
# current (i.e. user building order)
# ordered (i.e. user checkout)
# queued (first phase of user checkout)
# payment_pending (system) - to be defined in module
# payment_received (system) - to be defined in module
# orderd (system)
# in_process (being prepared by staff)
# altered (staff altered, awaiting user approval)
# alteration_approved (user approves staff alteration)
# cancelled (user or staff)
# fulfilled (staff)
# ready_to_be_shipped
# shipped (staff) - to be defined in module
# received (user) - to be defined in module
# completed (system or staff)
module OrderStatus
  def self.included(klass)
    klass.extend ClassMethods

    klass.class_eval do
      include Workflow

      workflow do
        state :current do
          # event :checkout, :transitions_to => :ordered
          event :checkout, :transitions_to => :in_process
        end

        # anticipating an interim step between checkout
        # and the system queueing the order for fulfillment
        # in the future, other events, such as "pay", "shipping_info_added"
        # might be added here
        # state :ordered do
        # event :queue, :transitions_to => :in_process
        # end

        state :in_process do
          event :cancel, :transition_to => :cancelled
          event :alter, :transitions_to => :user_review
          event :accept, :transitions_to => :accepted
          event :fulfilled_without_acceptance, :transitions_to => :ready
        end

        state :user_review do
          event :alteration_approve, :transitions_to => :in_process
        end
        
        state :accepted do
          event :fulfilled, :transitions_to => :ready
          event :complete, :transitions_to => :completed
        end

        state :ready do
          event :finish, :transitions_to => :completed
        end

        state :cancelled
        state :completed
      end

      # create a named_scope for each of our declared states
      workflow_spec.state_names.each do |name|
        scope_name = "with_state_#{name}".to_sym
        named_scope scope_name, :conditions => { :workflow_state => name.to_s }, :order => 'updated_at DESC'
      end

      # in(state_name)
      named_scope :in, lambda { |*args|
        options = args.last.is_a?(Hash) ? args.pop : Hash.new
        state = args.is_a?(Array) ? args.first : args

        if state == 'all'
          options
        else
          { :conditions => { :workflow_state => state.to_s }.merge(options) }
        end
      }

      def state_ok_to_delete_line_item?
        return false if %w(user_review cancelled completed ready).include?(workflow_state)
        true
      end

      # write methods named the same as your states
      # to handle things like notifications in your apps
      # when your order moves to that particular state 


      def new_note(note)
        # trigger transition to user_review state if note is added to ready or in_process order
        alter! if in_process? && note.user != user
      end
    end
  end

  module ClassMethods
    # returns a Hash where keys are event name and values are event object
    def workflow_events
      events = workflow_spec.states.values.collect &:events

      # skip blank values
      events = events.select { |e| e.present? }

      # flatten
      events_hash = Hash.new
      events.each do |v|
        v.each do |key,value|
          events_hash[key] = value
        end
      end

      events_hash
    end

    def workflow_event_names
      workflow_events.keys
    end
  end
end


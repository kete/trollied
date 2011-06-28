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
  unless included_modules.include? OrderStatus
    def self.included(klass)
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
          named_scope scope_name, :conditions => { :workflow_state => name.to_s }
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

      end
    end
  end
end


module OrdersHelper
  # implement in your application
  def link_to_profile_for(user)
    link_to user.trolley_user_display_name, url_for_trolley(:user => user)
  end

  def link_to_orders_for(user)
    link_to(user.trolley_user_display_name, :user => user)
  end

  def can_delete_line_item?(order)
    (params[:controller] == 'orders' &&
     order.workflow_state == 'in_process') ||
      order.state_ok_to_delete_line_item?
  end

  # override the method can_trigger_...? methods with your own security checks
  def can_trigger_fulfilled_without_acceptance?
    params[:controller] == 'orders'
  end

  def can_trigger_finish?
    params[:controller] == 'orders'
  end

  def order_button_for(action, order)
    options = { :confirm => t('orders.order.are_you_sure'),
      :class => 'order-button' }

    options[:method] = 'delete' if action.to_s == 'destroy'

    button_to(t("orders.order.#{action}"),
              { :controller => :orders,
                :action => action,
                :id => order },
              options)
  end

  # define button_to methods for each possible event name for Order
  Order.workflow_event_names.each do |event_name|
    code = lambda { |order|
      order_button_for(event_name.to_s, order)
    }

    define_method("button_to_#{event_name}", &code)
  end

  # special case
  def button_to_clear(order)
    order_button_for('destroy', order)
  end

  # single definition helper for format of displaying number of something
  def show_count_for(number)
    " (#{number})"
  end

  def link_to_state_unless_current(state, count)
    link_to_unless_current(t("orders.index.#{state}") + show_count_for(count),
                           :state => state,
                           :user => @user,
                           :trolley => @trolley,
                           :from => @from,
                           :until => @until)
  end

  # returns a list of links to order states
  # that have orders in their state
  # with number of orders in a given state indicated
  def state_links
    html = '<ul id="state-links" class="horizontal-list">'

    states_count = 1

    states = Order.workflow_spec.state_names.sort_by { |s| I18n.t("orders.index.#{s.to_s}") }

    states.each do |state|
      adjusted_conditions = adjust_value_in_conditions_for(:workflow_state, state.to_s, @conditions)

      with_state_count = Order.count(:conditions => adjusted_conditions)

      if with_state_count > 0
        classes = 'state-link'
        classes += ' first' if states_count == 1

        if state == :in_process && @state == state.to_s
          html += content_tag('li',
                              t("orders.index.#{state}") + show_count_for(with_state_count),
                              :class => classes)
        else
          html += content_tag('li',
                              link_to_state_unless_current(state, with_state_count),
                              :class => classes)
          
        end
        states_count += 1
      end
    end

    html += '</ul>'
  end

  def order_date_value(direction)
    return String.new unless @conditions

    new_conditions = drop_key_from_conditions(:from, @conditions)
    new_conditions = drop_key_from_conditions(:until, new_conditions)

    value = Order.find(:first,
                       :select => 'created_at',
                       :order => "created_at #{direction}",
                       :conditions => new_conditions)

    value.created_at.to_s(:db).split('\s')[0]
  end

  def oldest_order_value
    default_date_value('asc')
  end

  def newest_order_value
    default_date_value('desc')
  end

  def orders_state_headline
    html = t("orders.helpers.#{@state}_orders")
    
    if @from
      html += ' ' + t('orders.helpers.from') + ' '
      html += @from
    end
    
    if @until
      html += ' ' + t('orders.helpers.until') + ' '
      html += @until
    end

    if @user
      html += ' ' + t('orders.helpers.by') + ' '
      html += @user.trolley_user_display_name
    end

    html
  end

  def clear_extra_params
    if @user || @from || @until
      clear_link = link_to(t("orders.helpers.clear_params"),
                           :state => @state,
                           :user => nil,
                           :trolley => nil,
                           :from => nil,
                           :until => nil)

      clear_link = ' [ ' + clear_link + ' ]'
      content_tag('span', clear_link, :class => 'clear-params')
    end
  end

  private
  
  def adjust_value_in_conditions_for(key, value, conditions)
    new_conditions_hash = Hash.new
    if conditions.is_a?(Array)
      new_conditions_hash = conditions[1]
    else
      new_conditions_hash = conditions
    end

    new_conditions_hash.delete(:key)
    
    new_conditions_hash[key] = value unless value == nil

    new_conditions = conditions.is_a?(Array) ? [conditions[0], new_conditions_hash] : new_conditions_hash
  end

  def drop_key_from_conditions(key, conditions)
    adjust_value_in_conditions_for(key, nil, conditions)
  end

  def url_for_options_for_orders_index
    { :controller => 'orders', :action => 'index' }
  end
end

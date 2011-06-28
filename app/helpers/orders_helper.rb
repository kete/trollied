module OrdersHelper

  # single definition helper for format of displaying number of something
  def show_count_for(number)
    " (#{number})"
  end

  # returns a list of links to order states
  # that have orders in their state
  # with number of orders in a given state indicated
  def state_links
    html = '<ul id="state-links">'

    states_count = 1
    Order.workflow_spec.state_names.each do |state|
      with_state_count = @trolley ? @trolley.orders.in(state).count : Order.in(state).count

      if with_state_count > 0
        classes = 'state-link'
        classes += ' first' if states_count == 1

        if state == :in_process && @state == state.to_s
          html += content_tag('li',
                              t("orders.index.#{state}") + show_count_for(with_state_count),
                              :class => classes)
        else
          html += content_tag('li',
                              link_to_unless_current(t("orders.index.#{state}") + show_count_for(with_state_count),
                                                     :state => state),
                            :class => classes)
          
        end
      end
      
      states_count += 1
    end

    html += '</ul>'
  end

end

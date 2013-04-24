# Helpers specific to Twitter Bootstrap.
module Bootstrap
  module FlashHelper
    # Call this with no arguments in any template or layout, and divs will be
    # generated for all flash messages, using Twitter Bootstrap's alert
    # components.  A close button will also be rendered for each message.
    def bootstrap_flash
      flash_messages = []
      flash.each do |type, message|
        next if message.blank?
        
        type = :success if type == :notice
        type = :error   if type == :alert
        next unless [:error, :info, :success, :warning].include?(type)

        Array(message).each do |msg|
          text = content_tag(:div,
            content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
            msg.html_safe, :class => "alert fade in alert-#{type}")
          flash_messages << text if message
        end
      end
      flash_messages.join("\n").html_safe
    end
  end
end
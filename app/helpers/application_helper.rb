module ApplicationHelper
  def last_updated(object)
    "Last updated %s by %s" % [object.updated_at.to_s(:long), object.updated_by.try(:display_name)] if object.updated_by.present?
  end
  
  def creation_stamp(object)
    "Created on %s by %s" % [object.created_at.to_s(:long), object.created_by.try(:display_name)] if object.created_by.present?
  end
  
  def flash_type(type)
   if flash[type]
      "<div id=\"flash\">
         <a class=\"closer\" href=\"#\">Close</a>
         <div class=\"info\">#{flash[type]}</div>   
      </div>"
    else
      ''
    end
  end
  
  def bodytag_class
    return @bodytag_class unless @bodytag_class.blank?
    a = controller.class.to_s.underscore.gsub(/_controller$/, '')
    b = controller.action_name.underscore
    "#{a} #{b}".gsub(/_/, '-')
  end

  def kase_type_icon(kase)
    name = kase.class.humanized_name
    raw "[" + content_tag(:span, name.split[0...-1].collect{|s| s[0]}.join, :title => name) + "]"
  end

  def data_entry_needed_icon(record)
    if record.class.name == "TripAuthorization"
      raw "[" + content_tag(:span, "A", :title => "Trip Authorization") + "]"
    else
      kase_type_icon record
    end
  end
end

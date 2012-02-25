module ApplicationHelper

  def last_updated(object)
    "Last updated %s By %s" % [object.updated_at, object.updated_by.email] if object.updated_by.present?
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
    raw "[" + content_tag(:span, kase.class.humanized_name[0], :title => kase.class.humanized_name) + "]"
  end

end

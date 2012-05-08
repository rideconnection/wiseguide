module SurveyorHelper
  include Surveyor::Helpers::SurveyorHelperMethods
  def display_response(r_set,question)
    sets = r_set.responses.select do |r| 
      r.question == question && r.question.display_order == question.display_order
    end
    
    if sets.size == 0
      "-"
    else
      sets.sort! { |a,b| sort_value(a) <=> sort_value(b) }
      sets.map { |s| show_answer(s) }.join( question.pick == "any" ? "; " : "<br/>" )
    end
  end
  
  def show_answer(set) 
    this_answer = (set.string_value || set.text_value || set.integer_value || set.float_value).to_s
    if this_answer.blank?
      set.answer.text
    elsif set.answer.display_type == 'hidden_label'
      this_answer
    else
      "#{set.answer.text}: #{this_answer}"
    end
  end

  def sort_value(set)
    if set.response_group.present?
      set.response_group.to_i * 100 + set.answer.display_order
    else
      set.answer.display_order
    end
  end

  # Layout: stylsheets and javascripts
  def surveyor_includes
    ''
  end
  def surveyor_stylsheets
    ''
  end
  def surveyor_javascripts
    ''
  end
end

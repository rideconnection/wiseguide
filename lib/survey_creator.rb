module SurveyCreator
  class << self
    def create_survey(json_data)
      to_save = []
      survey = nil
      ActiveRecord::Base.transaction do
        survey = Survey.new(:title=>json_data['title'], :active_at=>DateTime.current)
        survey.inactive_at = nil #no, really
        to_save.push survey
        for section_obj in json_data['sections']
          section = SurveySection.new(:title=>section_obj["title"], :survey=>survey)
          to_save.push section
          for question_obj in section_obj['questions']
            case question_obj["type"] 
            when "group"
              #deal with question groups
              if not question_obj["text"] or not question_obj["display_type"]
                return "Malformed question %s" % question_obj
              end
              question_group = QuestionGroup.new(:text=>question_obj["text"],
                                                 :display_type=>question_obj["display_type"])
              to_save.push question_group
              for grouped_question_obj in question_obj["questions"]
                question = parse_question(grouped_question_obj, to_save)
                question.question_group = question_group
                question.survey_section = section
              end
            else
              question = parse_question(question_obj, to_save)
              question.survey_section = section
            end
          end
        end
        for savee in to_save
          savee.save!
        end
      end
      return survey
    rescue JSON::ParserError => e
      return "Malformed JSON %s" % e.message
    end
  
    def parse_question(question_obj, to_save)
      question = Question.new(:text=>question_obj["title"], 
                              :pick=>question_obj["pick"])
      i = 1
      for answer in question_obj["answers"]
        answer = Answer.new(:question=>question, :text=>answer["text"], :display_order=>i, :response_class=>answer['response_class'], :hide_label=>answer['hide_label'])
        i += 1
        to_save.push answer
      end
      to_save.push question
      return question
    end
  end
end

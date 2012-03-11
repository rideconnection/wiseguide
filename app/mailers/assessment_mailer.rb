class AssessmentMailer < ActionMailer::Base
  default :from => EMAIL_FROM

  def customer_assessed_email(user, kase)
    @kase = kase
    @kase_url = kase_url(:id=>@kase.id)

    mail(:to => user.email,  :subject => "Customer Assessment Notification")
  end
end

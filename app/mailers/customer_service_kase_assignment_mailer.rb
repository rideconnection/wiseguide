class CustomerServiceKaseAssignmentMailer < ActionMailer::Base
  default from: EMAIL_FROM
  
  def reassignment_email(user, kase)
    @kase = kase
    @kase_url = kase_url(id: @kase.id)

    mail(to: user.email,  subject: "Customer Service Case Assignment Notification")
  end
end

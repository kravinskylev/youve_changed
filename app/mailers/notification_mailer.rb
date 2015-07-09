class NotificationMailer < ApplicationMailer
  def youve_changed_email(email_address)
    mail(to: email_address, subject: "You've changed.")
  end
end

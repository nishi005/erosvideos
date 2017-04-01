class ContactMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.sendmail_contact.subject
  #
  def sendmail_contact(email, subject, message)
    @email = email
    @message = message

    mail(to: "nishi0051@gmail.com",
          from: "aaa@gmail.com",
          subject: subject)
  end
end

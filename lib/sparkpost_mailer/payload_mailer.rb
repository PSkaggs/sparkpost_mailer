require 'sparkpost_mailer/core_mailer'
module SparkPostMailer
  class PayloadMailer < SparkPostMailer::CoreMailer

    def deliver(payload)
      sparkpost_client.transmission.send_payload(payload)
    end

  end

end

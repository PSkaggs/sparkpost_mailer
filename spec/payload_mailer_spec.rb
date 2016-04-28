require "spec_helper"

describe SparkPostMailer::PayloadMailer do
  let(:mailer) { described_class.new }
  let(:api_key) { '1237861278' }

  let(:payload) do
      {
      recipients: [{ address: { email: 'email@email.com' } }],
      content: {
        from: "no-reply@buildingrenewal.org",
        subject: "A message from Testy McTesterson",
        template_id: 'template'
      },
      substitution_data: {
        name: "Testy McTesterson",
        LOGO: "image/url",
        PAGETITLE: "This is an automated message from RSpec",
        PAGEBODY: "Check me out!"
      }
    }
  end

  before do
    SparkPostMailer.config.api_key = api_key
  end
  describe "Send a payload message" do
    it 'should send a payload message' do
      expect_any_instance_of(SparkPost::Transmission).to receive(:send_payload).with(payload)
      mailer.deliver(payload)
    end
  end

end

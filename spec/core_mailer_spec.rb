require "spec_helper"
require 'base64'

describe SparkPostMailer::CoreMailer do
  subject(:core_mailer) { described_class }

  let(:image_path) { '/assets/image.jpg' }
  let(:default_host) { 'localhost:3000' }
  let(:mailer) { described_class.new }
  let(:api_key) { '1237861278' }
  before do
    SparkPostMailer.config.api_key = api_key
    SparkPostMailer.config.default_url_options = { host: default_host }
    allow(SparkPostMailer.config).to receive(:image_path).and_return(image_path)
  end
  describe 'url helpers in mailer' do
    subject { mailer.send(:course_url) }

    context 'Rails is defined (Rails app)' do
      let(:url) { '/courses/1' }
      let(:host) { 'codeschool.com' }
      let(:router) { Rails.application.routes.url_helpers }

      before do
        # use load since we are loading multiple times
        mailer.send(:load, 'fake_rails/fake_rails.rb')
        SparkPostMailer.config.default_url_options[:host] = host
        Rails.application.routes.draw do |builder|
          builder.course_url "#{url}"
        end
      end

      # Unrequire the fake rails class so it doesn't pollute the rest of the tests
      after do
        Rails.unload!
      end

      it 'should return the correct route' do
        expect(subject).to eq router.course_url(host: host)
      end

      context 'route helper with an argument' do
        it 'should return the correct route' do
          expect(subject).to eq router.course_url({id: 1, title: 'zombies'}, host: host)
        end
      end
    end

    context 'Rails is not defined' do
      it 'should raise an exception' do
        expect{subject}.to raise_error
      end
    end
  end

  describe '#image_path' do
    subject { mailer.image_path('logo.png') }

    context 'Rails exists' do
      let(:image) { 'image.png' }
      let(:host) { 'codeschool.com' }
      let(:router) { Rails.application.routes.url_helpers }

      before do
        # use load instead of require since we have to reload for every test
        mailer.send(:load, 'fake_rails/fake_rails.rb')
        SparkPostMailer.config.default_url_options[:host] = host
      end

      # Essentially un-requiring the fake rails class so it doesn't pollute
      # the rest of the tests
      after do
        Rails.unload!
      end

      it 'should return the image url' do
        #mailer.send(:image_path, image).should eq ActionController::Base.asset_path(image)
        expect(mailer.send(:image_path, image)).to eq(ActionController::Base.asset_path(image))
      end
    end

    context 'Rails does not exist' do
      it 'should raise exception' do
        expect{ subject }.to raise_error
      end
    end
  end

end

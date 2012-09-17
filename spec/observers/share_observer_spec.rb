require 'spec_helper'

describe ShareObserver do
  before (:each) do
    Notifications.deliveries.clear
  end

  after (:each) do
    Notifications.deliveries.clear
  end

  it "should send an email if shares email is created" do
    Notifications.deliveries.should be_empty

    email_share = FactoryGirl.create(:email_share)
    Notifications.deliveries.should_not be_empty
    mail = Notifications.deliveries.first

    topic = email_share.topic
    subject = "#{topic.user.name} might buy #{topic.subject}"
    mail.subject.should match(/#{subject}/)
    mail.to.should include(email_share.with)
  end
end

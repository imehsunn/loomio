require "rails_helper"

describe UserMailer do
  shared_examples_for 'email_meta' do
    it 'renders the receiver email' do
      @mail.to.should == [@user.email]
    end

    it 'renders the sender email' do
      @mail.from.should == ['notifications@loomio.org']
    end
  end

  context 'sending email on membership approval' do
    before :each do
      @user = create(:user)
      @group = create(:group)
      @mail = UserMailer.group_membership_approved(@user, @group)
    end

    it_behaves_like 'email_meta'

    it 'assigns correct reply_to' do
      @mail.reply_to.should == [@group.admin_email]
    end

    it 'renders the subject' do
      @mail.subject.should == "[Loomio: #{@group.full_name}] Membership approved"
    end

    it 'assigns confirmation_url for email body' do
      @mail.body.encoded.should match("http://localhost:3000/g/#{@group.key}")
    end
  end

  context '#added_to_group' do 
    before do
      @user    = double(:user, name: 'Wayne G', email: 'w_recipient@g.com', name_and_email: nil)  
      @inviter = double(:user, name: 'invite', email: 'inviter@h.com', name_and_email: nil) 
      @group   = create(:group)
      @group.update_attribute(:full_name, 'ParentName - SubgroupName')
      @message = 'blah blah' 
    end
      
    it 'uses group.full_name in the email subject' do
      mail_object = UserMailer.added_to_group(user: @user, inviter: @inviter, group: @group, message: @message)      
      mail_object.subject.should include @group.full_name
    end

    it 'uses group.full_name in the email body' do
      mail_object = UserMailer.added_to_group(user: @user, inviter: @inviter, group: @group, message: @message)      
      mail_object.body.encoded.should include @group.full_name
    end
  end
end

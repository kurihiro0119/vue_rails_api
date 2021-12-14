require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = active_user
  end

  test 'name_validation' do
    user = User.new(email: "test@example.com", password: "password")
    user.save
    required_msg = ["Nameを入力してください"]  
    assert_equal(required_msg, user.errors.full_messages)  # 追加
  end

  test "email_validation" do
    # 入力必須
    user = User.new(name: "test", password: "password")
    user.save
    required_msg = ["Emailを入力してください"]
    assert_equal(required_msg, user.errors.full_messages)
    max = 255
    domain = "@example.com"
    email = "a" * ((max + 1) - domain.length) + domain
    assert max < email.length

    user.email = email
    user.save
    maxlength_msg = ["Emailは255文字以内で入力してください"]
    assert_equal(maxlength_msg, user.errors.full_messages)

      ok_emails = %w(
        A@EX.COM
        a-_@e-x.c-o_m.j_p
        a.a@ex.com
        a@e.co.js
        1.1@ex.com
        a.a+a@ex.com
      )
      
      ok_emails.each do |email|
        user.email = email
        assert user.save
      end

      ng_emails = %w(
        aaa
        a.ex.com
        メール@ex.com
        a~a@ex.com
        a@|.com
        a@ex.
        .a@ex.com
        a＠ex.com
        Ａ@ex.com
        a@?,com
        １@ex.com
        "a"@ex.com
        a@ex@co.jp
      )
      ng_emails.each do |email|
        user.email = email
        user.save
        format_msg = ["Emailは不正な値です"]
        assert_equal(format_msg, user.errors.full_messages)
      end
  end


end

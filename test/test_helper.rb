ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # 追加
  # プロセスが分岐した直後に呼び出し
  parallelize_setup do |worker|
    load "#{Rails.root}/db/seeds.rb"
  end
  # ここまで

  parallelize(workers: :number_of_processors)

  def active_user
    User.find_by(activated: true)
  end

end
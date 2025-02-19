require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should be created" do
    new_user = User.new(
      email: "l9xZS@example.com", name: "name", surname: "surname", patronymic: "patronymic", age: 25,
      nationality: "nationality", country: "country", gender: "gender", full_name: "full_name"
      )
    assert new_user.save
  end
end

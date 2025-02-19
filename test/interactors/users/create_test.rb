require "test_helper"
require_relative "../../../app/interactors/users/create"

class Users::CreateTest < ActiveSupport::TestCase
  test "creates a user with valid attributes" do
    params = {
      name: "John",
      surname: "Doe",
      patronymic: "A.",
      email: "john.doe@example.com",
      age: 30,
      nationality: "American",
      country: "USA",
      gender: "male",
      interests: [ "Reading", "Traveling" ],
      skills: [ "Ruby", "Rails" ]
    }
    result = nil

    assert_difference "User.count" do
      result = Users::Create.run(params)
    end

    assert result.valid?, "Expected the result to be valid"
    assert_equal "john.doe@example.com", result.email
    assert_equal params[:interests], result.interests
    assert_equal params[:skills], result.skills

    user = User.last
    assert_equal params[:name], user.name
    assert_equal params[:surname], user.surname
    assert_equal params[:patronymic], user.patronymic
    assert_equal params[:age], user.age
    assert_equal params[:nationality], user.nationality
    assert_equal params[:country], user.country
    assert_equal params[:gender], user.gender
    assert_equal "#{params[:surname]} #{params[:name]} #{params[:patronymic]}", user.full_name
    assert_equal params[:interests].sort, user.interests.map(&:name).sort
    assert_equal params[:skills].sort, user.skills.map(&:name).sort
  end

  test "does not create a user with invalid attributes" do
    params = {
      name: "",
      surname: "Doe",
      patronymic: "A.",
      email: "email@test.test",
      age: 100,
      nationality: "American",
      country: "USA",
      gender: "unknown",
      interests: [],
      skills: []
    }
    result = nil

    assert_no_difference "User.count" do
      result = Users::Create.run(params)
    end

    refute result.valid?, "Expected the result to be invalid"
    assert_includes result.errors.messages.keys, :name
    assert_includes result.errors.messages.keys, :age
    assert_includes result.errors.messages.keys, :gender
  end

  test "does not create a user with duplicate email" do
    duplicate_email = "jane.doe@example.com"
    existing_user = User.create(
      name: "Jane",
      surname: "Doe",
      patronymic: "B.",
      email: duplicate_email,
      age: 25,
      nationality: "American",
      country: "USA",
      gender: "female",
      full_name: "Jane B. Doe"
    )

    params = {
      name: "John",
      surname: "Doe",
      patronymic: "A.",
      email: duplicate_email,
      age: 30,
      nationality: "American",
      country: "USA",
      gender: "male",
      interests: [],
      skills: []
    }
    result = nil

    assert_no_difference "User.count" do
      result = Users::Create.run(params)
    end

    refute result.valid?, "Expected the result to be invalid"
    assert_includes result.errors.messages.keys, :email
  end
end

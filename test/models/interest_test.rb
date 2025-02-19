require "test_helper"

class InterestTest < ActiveSupport::TestCase
  test "should be created interest" do
    new_interest = Interest.new(name: "test")

    assert new_interest.save
    assert_equal "test", new_interest.name
  end
end

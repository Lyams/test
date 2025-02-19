require "test_helper"

class SkillTest < ActiveSupport::TestCase
  test "should be created" do
    skill1 = Skill.new(name: "Scala")
    assert skill1.save
  end
end

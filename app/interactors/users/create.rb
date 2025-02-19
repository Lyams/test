class Users::Create < ActiveInteraction::Base
  integer :age
  string :country
  string :email
  string :gender
  string :name
  string :nationality
  string :patronymic
  string :surname
  array :interests, default: []
  array :skills, default: []

  validates :age, numericality: { greater_than: 0, less_than_or_equal_to: 90 }
  validates :gender, inclusion: { in: [ "male", "female" ] }
  validates :age, :country, :email, :gender, :name, :nationality, :patronymic, :surname, presence: true

  validate :email_must_be_unique

  def execute
    user_full_name = "#{surname} #{name} #{patronymic}"
    user = User.new(user_params.merge(full_name: user_full_name))

    Interest.where(name: interests).each do |interest|
      user.interests << interest
    end

    Skill.where(name: skills).each do |skill|
      user.skills << skill
    end

    user.save!
  end

  private

  def user_params
    {
      name: name,
      surname: surname,
      patronymic: patronymic,
      email: email,
      age: age,
      nationality: nationality,
      country: country,
      gender: gender
    }
  end

  def email_must_be_unique
    if User.exists?(email: email)
      errors.add(:email, :taken, message: "has already been taken")
    end
  end
end

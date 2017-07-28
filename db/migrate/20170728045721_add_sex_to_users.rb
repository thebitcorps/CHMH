class AddSexToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sex, :integer
    User.find_each do |user|
      if user.gender == '0'
        user.male!
      else
        user.female!
      end
      user.save!
    end
  end
end

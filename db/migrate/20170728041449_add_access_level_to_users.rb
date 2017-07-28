class AddAccessLevelToUsers < ActiveRecord::Migration
  def change
    add_column :users, :access_level, :integer
    User.find_each do |user|
      original_role = user.role
      case original_role
        when 'Admin'
          user.admin!
        when '1'
          user.head_of_area!
        when '2'
          user.tutor!
        when '3'
          user.intern!
      end
      user.save!
    end
  end

end

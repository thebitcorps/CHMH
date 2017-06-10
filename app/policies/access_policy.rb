class AccessPolicy
  include AccessGranted::Policy

  def configure

    role :administrator, proc { |user| user.administrator? } do
      can :manage, Area
      can :manage, Examined
      can :manage, Procedure
      can :manage, Season
      can :manage, Surgery
      can :manage, Task
      can :manage, TaskProcedure
      can :manage, User
    end

    role :head_of_area, proc { |user| user.head_of_area? } do
      can [:create, :update], Surgery do |surgery, user|
      surgery.area == user.area
      end
    end


    role :tutor, proc { |user| user.tutor? } do
    # Something
    end

    role :intern, proc { |user| user.intern? } do
      can :create, Procedure
      can :update, Procedure do |procedure, user|
        procedure.user == user
      end
    end
  end
end

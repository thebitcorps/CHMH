class AccessPolicy
  include AccessGranted::Policy

  def configure
    role :admin, proc { |user| user.admin? } do
        can :manage, Area
        can :manage, DashboardController
        can :manage, Season
        can :manage, Surgery
        can :manage, User
    end

    role :head_of_area, proc { |user| user.head_of_area? } do
        can :manage, Surgery
    end

    role :intern, proc { |user| user.intern? } do
        can :read, Area
        can :create, Procedure # its own
        can :read, User
    end

    #
    # role :member, proc { |user| user.registered? } do
    #   can :create, Post
    #   can :create, Comment
    #   can [:update, :destroy], Post do |post, user|
    #     post.author == user
    #   end
    # end

    # The base role with no additional conditions.
    # Applies to every user.
    #
    # role :guest do
    #  can :read, Post
    #  can :read, Comment
    # end
  end
end

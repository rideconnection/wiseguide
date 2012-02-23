class Ability
  include CanCan::Ability

  def initialize(user)

    if user.level < 0
      return #turned-off users can do nothing
    end

    #system tables
    can :read, AssessmentRequest
    can :read, Disposition
    can :read, Ethnicity
    can :read, EventType
    can :read, FundingSource
    can :read, Impairment
    can :read, Organization
    can :read, ReferralType
    can :read, Route
    can :read, TripReason
    can :read, User
    can :read, County

    # Outside user permissions
    if user.level == 25 then
      can :create, AssessmentRequest
      can :read, AssessmentRequest, :organization => user.organization
      can :read, AssessmentRequest, :organization => user.organization.children
      can :update, AssessmentRequest, :submitter_id => user.id
      can :read, Customer do |customer|
        result = false
        AssessmentRequest.where(:submitter_id => user.id).each do |r|
          if r.customer_id == customer.id then
            result = true
          end
        end
        result
      end
      can :read, Kase do |kase|
        kase.assessment_request.submitter_id == user.id
      end
      return
    end

    if user.level >= 50
      ability = :manage
    else
      ability = :read
    end
    can ability, AssessmentRequest
    can ability, KaseRoute
    can ability, CustomerImpairment
    can ability, CustomerSupportNetworkMember
    can ability, Kase
    can ability, Customer
    can ability, Event
    can ability, Outcome
    can ability, Resource
    can ability, ResponseSet
    can ability, Survey

    unless user.is_admin
      cannot :destroy, AssessmentRequest
      cannot :destroy, Kase
      cannot :destroy, Customer
      cannot :destroy, Event
      cannot :destroy, Outcome
      cannot :destroy, Resource
      cannot :destroy, ResponseSet
      cannot :destroy, Survey
    end

    #users can only read the cases of others
    can :read, Contact
    can :manage, Contact, :user_id == user.id

    #and admins are admins
    if user.is_admin
      can :manage, :all
    end
  end
end

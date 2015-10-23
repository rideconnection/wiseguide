class Ability
  include CanCan::Ability

  def initialize(user)
    # Read access implies download_attachment access
    alias_action :download_attachment, to: :read

    if user.level < 0
      return #turned-off users can do nothing
    end

    #system tables
    can :read, AdaServiceEligibilityStatus
    can :read, Agency
    can :read, County
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

    # Outside user permissions
    if user.level == 25 then
      can :create, AssessmentRequest if user.organization.is_cmo?
      can :read,   AssessmentRequest, submitter: { organization_id: [user.organization.id] + user.organization.children.collect(&:id) }
      can :update, AssessmentRequest, submitter_id: user.id
      
      # Outside users can read cases that were created by someone in their same organization
      can :read, Kase do |kase|
        request = kase.assessment_request
        unless request.nil? then
          org = request.submitter.organization
          org == user.organization || org.parent == user.organization
        end
      end
      
      # Outside users can read contact events if they can read the case 
      # they're associated with (contactable is a case here)
      can :read, Contact do |contact|
        can?(:read, contact.contactable)
      end
      
      # Outside users can create and view trip authorizations if they can view the associated case
      # or if it's a new authorization (with no association with a case yet) 
      can [:create, :read], TripAuthorization do |trip_authorization|
        trip_authorization.kase.blank? || can?(:read, trip_authorization.kase)
      end
      
      # Outside users can update trip authorizations if they can view the associated case
      can :update, TripAuthorization do |trip_authorization|
        can?(:read, trip_authorization.kase) && trip_authorization.disposition_date.blank?
      end

      return
    end

    if user.level >= 50
      ability = :manage
    else
      ability = :read
      can :search, Customer
    end
    
    can ability, AssessmentRequest
    can ability, Agency
    can ability, Customer
    can ability, CustomerImpairment
    can ability, CustomerSupportNetworkMember
    can ability, Event
    can ability, Kase
    can ability, KaseRoute
    can ability, Outcome
    can ability, ReferralDocument
    can ability, ReferralDocumentResource
    can ability, Resource
    can ability, ResponseSet
    can ability, Survey
    can ability, TripAuthorization

    unless user.is_admin
      cannot :destroy, Agency
      cannot :destroy, AssessmentRequest
      cannot :destroy, Customer
      cannot :destroy, Event
      cannot :destroy, Kase
      cannot :destroy, Outcome
      cannot :destroy, ReferralDocument
      cannot :destroy, ReferralDocumentResource
      cannot :destroy, Resource
      cannot :destroy, ResponseSet
      cannot :destroy, Survey
      cannot :destroy, TripAuthorization
    end

    #users can only read the cases of others
    can :read,   Contact
    can :manage, Contact, user_id: user.id

    #and admins are admins
    if user.is_admin
      can :manage, :all
    end
  end
end

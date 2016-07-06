module Contexts
  module UserContexts
    # Context for users; assumes initial context for employees already set 
    def create_users
      @ed_user = FactoryGirl.create(:user, employee: @ed, email: "ed@example.com")
      @cindy_user = FactoryGirl.create(:user, employee:@cindy, email: "cindy@example.com")
      @ben_user = FactoryGirl.create(:user, employee:@ben, email: "ben@example.com")
      @alex_user = FactoryGirl.create(:user, employee:@alex, email: "alex@example.com")
    end
    
    def remove_users
      @ed_user.delete
      @cindy_user.delete
      @ben_user.delete
      @alex_user.delete
    end

  end
end
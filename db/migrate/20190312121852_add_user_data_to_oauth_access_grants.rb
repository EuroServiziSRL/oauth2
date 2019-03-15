class AddUserDataToOauthAccessGrants < ActiveRecord::Migration[5.2]
  def change
    add_column :oauth_access_grants, :user_data, :text 
  end
end

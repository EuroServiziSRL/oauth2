class AddUserDataToOauthAccessTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :oauth_access_tokens, :user_data, :text 
  end
end

class AddDemoSiteMobileAppToOauthApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :oauth_applications, :demo_site, :boolean
    add_column :oauth_applications, :mobile_app, :boolean
  end
end

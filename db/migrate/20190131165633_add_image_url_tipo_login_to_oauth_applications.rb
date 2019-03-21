class AddImageUrlTipoLoginToOauthApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :oauth_applications, :image_url, :string
    add_column :oauth_applications, :tipo_login, :string
    add_column :oauth_applications, :portal_url, :string
    add_column :oauth_applications, :extra_info, :text
  end
end

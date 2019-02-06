class AddImageUrlTipoLoginToOauthApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :oauth_applications, :image_url, :string
    add_column :oauth_applications, :tipo_login, :string
  end
end

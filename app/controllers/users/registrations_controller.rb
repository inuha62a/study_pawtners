class RegistrationsController < Devise::RegistrationsController
  # ログイン後のリダイレクト先
  def after_update_path_for(resource)
    users_profile_path
  end

  protected

  # パスワードなしで更新できるようにする
  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
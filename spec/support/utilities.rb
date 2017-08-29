def sign_in(user = nil)
  user ||= FactoryGirl.create(:user)
  data = { email: user.email, password: user.password }
  post '/users/sign_in', params: { user: data }
  @current_user = user if response.status == 302
end

def sign_out
  delete '/users/sign_out'
  @current_user = nil if response.status == 302
end
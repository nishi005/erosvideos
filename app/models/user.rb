class User < ActiveRecord::Base
	validates :usr_name,
		presence: true,
		uniqueness: true
	validates :user_password,
		presence: true,
		confirmation: true

	def self.authenticate(username, password)
		usr = find_by(usr_name: username)

		if usr != nil && usr.user_password == Digest::SHA1.hexdigest(password) then
			return usr;
		else
			return
		end
	end

	def self.getUserName(usr_id)
		return User.where(id: usr_id).usr_name
	end
end

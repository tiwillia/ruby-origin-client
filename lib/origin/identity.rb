module Origin

	class Identity < PersistedResource

		attr_accessor :metadata, :providerName, :providerUserName, :user, :extra

		# Create an identity object
		# Params:
		#
		# [name]             Name of the identity
		# [providerName]     Name of the provider
		# [providerUserName] User name of the user in the provider
		# [user]             Origin::User representation of a user
		def initialize(name, providerName="", providerUserName="", user)
			@name = name
			@providerName = providerName
			@providerUserName = providerUserName
			@user = user
			@extra = {}
		end

		def self.parse(data, client)
			user = User.parse(data["user"], client)
			meta = ObjectMeta.new(data["metadata"])
			id = Identity.new(meta.name, data["providerName"], data["providerUserName"])
			id.metadata = meta
			id.extra = data.key?["extra"] ? data["extra"] : {}
			return id
		end

	end

end

module Origin

	class UserIdentityMapping < PersistedResource

		attr_accessor :metadata, :user, :identity

		def initialize(name, user, identity)
			@metadata = ObjectMeta.new({"name": name})
			@user = user
			@identity = identity
		end

		def self.parse(data, client)
			user = User.parse(data["user"], client)
			identity = Identity.parse(data["identity"], client)
			meta = ObjectMeta.new(data["metadata"])
			uim = UserIdentityMapping.new(meta.name, user, identity)
			uim.metadata = meta
			return uim
		end

	end

end

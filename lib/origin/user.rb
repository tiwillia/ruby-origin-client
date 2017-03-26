module Origin

	class User < PersistedResource

		attr_accessor :metadata, :fullName, :identities

		def initialize(name)
			@metadata = ObjectMeta.new({"name" => name})
			@fullName = name
			@identities = []
		end

		def self.parse(data, client)
			meta = ObjectMeta.new(data["metadata"])
			u = User.new(meta.name)
			u.metadata = meta
			u.fullName = data["fullName"].nil? ? "" : data["fullName"]
			u.identities = data["identities"]
			return u
		end

	end

end

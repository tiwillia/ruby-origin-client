module Origin

	class ObjectMeta < Resource

		attr_accessor :name, :namespace, :annotations, :labels
		attr_reader :creationTimestamp, :deletionTimestamp, :resourceVersion

		def initialize(meta = {})
			@name = meta.key?("name") ? meta["name"] : ""
			@namespace = meta.key?("namespace") ? meta["namespace"] : ""
			@creationTimestamp = meta.key?("creationTimestamp") ? meta["creationTimestamp"] : ""
			@deletionTimestamp = meta.key?("deletionTimestamp") ? meta["deletionTimestamp"] : ""
			@resourceVersion = meta.key?("resourceVersion") ? meta["resourceVersion"] : ""
			@annotations = meta.key?("annotations") ? meta["annotations"] : {}
			@labels = meta.key?("labels") ? meta["labels"] : {}
		end

	end

end

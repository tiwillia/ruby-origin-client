module Origin

	class ClusterResourceQuota < PersistedResource

		attr_accessor :metadata, :spec

		# Create a cluster resource quota object
		# In most cases, just the name can be provied in the call to .new
		# Params:
		#
		# [name]            Name of the cluster resource quota object
		# [quotas]          A hash of resources and limits. (ex: {"pods" => "10"} )
		# [label_selectors] A list of key, operator, values selector hashes. 
		#   (ex. {"key" => "labelname", "operator" => "In", "value" => ["example","findme"]} )
		# [anno_selectors]  A hash of annotations this quota should apply to
		#   (ex. {"openshift.io/some_annotation" => "somevalue"} )
		def initialize(name, quotas = {}, label_selectors = [], anno_selectors = {})
			@spec = ClusterResourceQuotaSpec.new(quotas, label_selectors, anno_selectors)
			@metadata = ObjectMeta.new({"name" => name})
		end

		# TODO maybe
		def add_label_selector(key, operator, value = [""])
		end

		# TODO maybe
		def add_quota(resource, limit)
		end

		def self.parse(data, client)
			meta = ObjectMeta.new(data["metadata"])
			quotas = data["spec"]["quota"]
			label_selectors = data["spec"]["selector"]["labels"] # TODO this wont parse, need to convert it to array
			anno_selectors = data["spec"]["selector"]["annotations"]
			csrq = ClusterResourceQuota.new(meta.name, quotas, label_selectors, anno_selectors)
			csrq.metadata = meta
			return csrq
		end

	end

	class ClusterResourceQuotaSpec < Resource

		attr_accessor :selector, :quota

		def initialize(quotas, label_selectors = [], anno_selectors = {})
			@selector = ClusterResourceQuotaSelector.new(label_selectors, anno_selectors)
			@quota = ResourceQuotaSpec.new(quotas)
		end

	end

	class ResourceQuotaSpec < Resource

		attr_accessor :hard, :scopes

		def initialize(quotas = {})
			@hard = quotas
			@scopes = [] # TODO I'm honestly not sure what the fuck these are, docs are nil
		end

	end

	class ClusterResourceQuotaSelector < Resource

		attr_accessor :annotations, :labels

		def initialize(label_selectors = [], anno_selectors = {})
			@annotations = anno_selectors
			@labels = LabelSelector.new(label_selectors)
		end

	end

	class LabelSelector < Resource

		attr_accessor :matchLabels, :matchExpressions

		def initialize(label_selectors = [])
			@matchLabels = {}
			@matchExpressions = []
			label_selectors.each do |selector|
				if selector["operator"].nil? or selector["operator"] == "In" || selector["operator"] == ""
					@matchLabels[selector["key"]] = selector["value"]
				else 
					@matchExpressions << LabelSelectorRequirement.new(selector["key"], selector["operator"], selector["value"])
				end
			end
		end

	end

	class LabelSelectorRequirement < Resource

		attr_accessor :key, :operator, :value

		def initialize(key, operator, value = "")
			@key = key
			@operator = operator ? "" : operator
			@value = value.nil? ? "" : value
		end

	end

end

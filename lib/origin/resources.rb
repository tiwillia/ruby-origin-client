require 'active_support/inflector'

module Origin

	class PersistedResource

		def path
			"/#{self.class.to_s.split("::").last.downcase.pluralize}"
		end

		def to_hash
			hash = {}
			instance_variables.each do |var|
				val = instance_variable_get(var)
				val = val.to_hash if val.respond_to?(:to_hash)
				hash[var.to_s.delete("@")] = val
			end
			hash["apiversion"] = "v1"
			hash["kind"] = self.class.to_s.split("::").last
			hash
		end

	end

	class Resource

		def to_hash
			hash = {}
			instance_variables.each do |var|
				val = instance_variable_get(var)
				val = val.to_hash if val.respond_to?(:to_hash)
				if val.kind_of?(Array)
					val.map!{|v| v.to_hash if v.respond_to?(:to_hash)}
				end
				hash[var.to_s.delete("@")] = val
			end
			hash
		end

	end

end

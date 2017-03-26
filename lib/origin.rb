require 'json'
require 'httparty'
require 'uri'
require 'logger'
require 'origin/exceptions'
require 'origin/resources'

module Origin
	autoload :Client, 'origin/client'

	autoload :User, 'origin/user'
	autoload :Identity, 'origin/identity'
	autoload :UserIdentityMapping, 'origin/user_identity_mapping'
	autoload :ClusterResourceQuota, 'origin/cluster_resource_quota'
	autoload :ObjectMeta, 'origin/object_meta'

	def self.logger
		@logger ||= Logger.new(STDOUT)
	end

	def self.logger=(logger)
		@logger = logger
	end

end

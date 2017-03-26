require 'net/https'
require 'uri'
require 'httparty'
require 'json'
require 'active_support/inflector'
require 'pry'

module Origin
	class Client

		attr_accessor :apiURL

		KINDS = {
			"user" => "User",
			"identity" => "Identity",
			"clusterresourcequota" => "ClusterResourceQuota",
			"useridentitymapping" => "UserIdentityMapping"
		}

		def initialize(apiURL, token, verify_ssl = false, debug = false)
			# URL of the api server (ex https://mydeployment.openshift.com/oapi/v1)
			@apiURL = apiURL
			# Auth token of the user to query the API as (found using `oc whoami -t`)
			@token = token
			# Whether or not to verify the server's SSL certificates
			@verify_ssl = verify_ssl
			# Whether to enable debug logging on api calls
			@debug = debug

			ActiveSupport::Inflector.inflections(:en) do |inflect|
				inflect.plural 'quota', 'quotas'
			end
		end

		# General api information
		def api_info()
			path = "/"
			return http_get(path)
		end

		# Find a resource by id
		#
		# Examples:
		#   find(:user, "JohnTravolta")
		#   find(:clusterresourcequota, "adminquota")
		def find(resource_kind, id)
			response = http_get("/#{resource_kind.to_s.pluralize}/#{id}")
			Origin.logger.info(response.inspect)
			resource = KINDS[resource_kind.to_s.downcase.singularize]
			origin_obj = Origin.const_get(resource)
			return origin_obj.parse(response, self)
		end

		def create(res)
			obj = res.to_hash
			obj["metadata"].delete("creationTimestamp")
			obj["metadata"].delete("deletionTimestamp")
			http_post(res.path, obj)
		end

		def update(res)
			obj = res.to_hash
			obj["metadata"].delete("creationTimestamp")
			obj["metadata"].delete("deletionTimestamp")
			endpoint = "#{res.path}/#{res.metadata.name}"
			http_put(endpoint, obj)
		end

		def delete(res)
			endpoint = "#{res.path}/#{res.metadata.name}"
			http_delete(endpoint)
		end

		private

		# Run a POST request with a payload on the api server at the path specfied
		# The payload should be either a json string or an object hash
		def http_post(path, payload)
			uri = URI(@apiURL + path)
			headers = {
				"Authorization" => "Bearer " + @token,
				"Content-Type" => "application/json"
			}
			options = {
				:headers => headers,
				:verify => @verify_ssl,
				:body => payload.to_json,
			}
			options[:debug_output] = Origin.logger if @debug
			response = HTTParty.post(uri, options)
			return handle_http_errors(response, path)
			# TODO when an object is created, the body of the response is the object definition. We should retuned the parsed object.
		end

		# Run a PUT request with a payload on the api server at the path specfied
		# The payload should be either a json string or an object hash
		def http_put(path, payload)
			uri = URI(@apiURL + path)
			headers = {
				"Authorization" => "Bearer " + @token,
				"Content-Type" => "application/json"
			}
			options = {
				:headers => headers,
				:verify => @verify_ssl,
				:body => payload.to_json,
			}
			options[:debug_output] = Origin.logger if @debug
			response = HTTParty.put(uri, options)
			return handle_http_errors(response, path)
		end

		# Run a GET request on the api server at the path specified
		def http_get(path)
			uri = URI(@apiURL + path)
			headers = {
				"authorization" => "bearer " + @token,
			}
			options = {
				:headers => headers,
				:verify => @verify_ssl,
			}
			options[:debug_output] = Origin.logger if @debug
			response = HTTParty.get(uri, options)
			return handle_http_errors(response, path)
		end

		# Run a DELETE request on the api server at the path specified
		def http_delete(path)
			uri = URI(@apiURL + path)
			headers = {
				"authorization" => "bearer " + @token,
			}
			options = {
				:headers => headers,
				:verify => @verify_ssl,
			}
			options[:debug_output] = Origin.logger if @debug
			response = HTTParty.delete(uri, options)
			return handle_http_errors(response, path)
		end

		private

		# Handler for http errors for all calls
		# TODO I should be able to gather more specific error messages from the API response body, which appears to be pretty consistent when an error occurs
		def handle_http_errors(response, path)
			if response.success?
				return response.parsed_response
			end
			method = response.request.http_method.to_s.split("::").last
			case response.code
				when 403
					Origin.logger.error("ERROR: Insufficient access to #{method} on #{path}")
					raise Origin::AccessDenied, response.message
				when 409
					Origin.logger.error("ERROR: Conflicting entity found on #{method} to #{path}")
					raise Origin::ConflictingEntity, response.message
				when 422
					Origin.logger.error("ERROR: Malformed entity provided to #{method} on #{path}")
					raise Origin::InvalidEntity, response.message
				when 404
					Origin.logger.error("ERROR: #{method} on #{path} not found")
					raise Origin::NotFound, response.message
				when 500...600
					Origin.logger.error("ERROR: #{method} on #{path} returned server-side error: #{response.message}")
					raise Origin::ServerError, response.message
				else
					Origin.logger.error("ERROR: #{method} on #{path} return unspecified error: #{response.message}")
					raise Origin::GeneralError, response.message
			end
		end

	end

end

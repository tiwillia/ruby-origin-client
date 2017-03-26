module Origin
	class Error < StandardError; end

	# When acesss to a particular resource is denied
	class AccessDenied < Error; end

	# When a particular resource does not exist
	class NotFound < Error; end

	# When the resource provided fails validation
	class InvalidEntity < Error; end

	# When the resource provided conflicts with an existing resource
	class ConflictingEntity < Error; end

	# When a general error on the server occurs
	class ServerError < Error; end

	# When an unspecified error occurs
	class GeneralError < Error; end
end

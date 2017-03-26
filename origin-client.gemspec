Gem::Specification.new do |s|
	s.name = "origin-client"
	s.version = "0.0.1"
	s.platform = Gem::Platform::RUBY

	s.authors = ["Timothy Williams"]
	s.date = Time.now.strftime "%Y-%m-%d"
	s.summary = "Interface to the openshift origin API"
	s.description = "Interface to the openshift origin API"
	s.email = "tiwillia@redhat.com"
	s.files = Dir.glob("lib/**/*") + %w(README.md)
end

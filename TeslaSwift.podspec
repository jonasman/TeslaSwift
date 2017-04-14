Pod::Spec.new do |s|
	s.name         = "TeslaSwift"
	s.version      = "3.4.7"
	s.summary      = "Swift library to access the Tesla Model S API."

	s.homepage     = "https://github.com/jonasman/TeslaSwift"

	s.license      = { :type => "MIT", :file => "LICENSE" }

	s.author             = { "Joao Nunes" => "joao3001@hotmail.com" }
	s.social_media_url   = "https://twitter.com/jonas2man"
	s.ios.deployment_target = '8.0'
	s.osx.deployment_target = '10.10'
	s.watchos.deployment_target = '2.0'
	s.tvos.deployment_target = '9.0'

	s.source       = { :git => "https://github.com/jonasman/TeslaSwift.git", :tag => "#{s.version}" }

	s.source_files  = "Sources/**/*.swift"


	s.framework  = "Foundation"

	s.requires_arc = true

	s.dependency 'PromiseKit/CorePromise',  '~> 4.0'
	s.dependency 'ObjectMapper', '~> 2.0'
    s.dependency 'SwiftWebSocket', '~> 2.6.5'

end

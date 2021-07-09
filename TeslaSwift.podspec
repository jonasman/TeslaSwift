Pod::Spec.new do |s|
	s.name         = "TeslaSwift"
	s.version      = "7.0.5"
	s.summary      = "Swift library to access the Tesla Model S, X, 3 and Y API."

	s.homepage     = "https://github.com/jonasman/TeslaSwift"

	s.license      = { :type => "MIT", :file => "LICENSE" }

	s.author             = { "Joao Nunes" => "joao3001@hotmail.com" }
	s.social_media_url   = "https://twitter.com/jonas2man"
	s.ios.deployment_target = '13.0'
	s.osx.deployment_target = '10.15'
	s.watchos.deployment_target = '6.0'
	s.tvos.deployment_target = '13.0'
	s.swift_version = '5.3'

	s.source       = { :git => "https://github.com/jonasman/TeslaSwift.git", :tag => "#{s.version}" }

    s.default_subspec = 'Core'

	s.framework  = "Foundation"

	s.requires_arc = true

    s.subspec 'Core' do |ss|
        ss.source_files = "Sources/TeslaSwift/**/*"
    end

    s.subspec 'Streaming' do |ss|
        ss.source_files = 'Sources/Extensions/Streaming/*.swift'
        ss.dependency 'TeslaSwift/Core'
        ss.dependency 'Starscream' ,  '~> 4'
    end

    s.subspec 'PromiseKit' do |ss|
        ss.source_files = 'Sources/Extensions/PromiseKit/*.swift'
        ss.dependency 'PromiseKit/CorePromise' ,  '~> 6'
        ss.dependency 'TeslaSwift/Core'
    end

    s.subspec 'Combine' do |ss|
        ss.source_files = 'Sources/Extensions/Combine/*.swift'
        ss.dependency 'TeslaSwift/Core'
        ss.ios.deployment_target = '13.0'
        ss.osx.deployment_target = '10.15'
        ss.watchos.deployment_target = '6.0'
        ss.tvos.deployment_target = '13.0'
    end
    
    s.subspec 'Rx' do |ss|
        ss.source_files = 'Sources/Extensions/Rx/*.swift'
        ss.dependency 'RxSwift' ,  '6.0.0-rc.2'
        ss.dependency 'RxCocoa' ,  '6.0.0-rc.2'
        ss.dependency 'TeslaSwift/Core'
    end

    s.subspec 'StreamingCombine' do |ss|
        ss.source_files = 'Sources/Extensions/StreamingCombine/*.swift'
        ss.dependency 'TeslaSwift/Streaming'
        ss.ios.deployment_target = '13.0'
        ss.osx.deployment_target = '10.15'
        ss.watchos.deployment_target = '6.0'
        ss.tvos.deployment_target = '13.0'
    end

    s.subspec 'StreamingRx' do |ss|
        ss.source_files = 'Sources/Extensions/StreamingRx/*.swift'
        ss.dependency 'TeslaSwift/Streaming'
        ss.dependency 'RxSwift' ,  '6.0.0-rc.2'
        ss.dependency 'RxCocoa' ,  '6.0.0-rc.2'
    end

end

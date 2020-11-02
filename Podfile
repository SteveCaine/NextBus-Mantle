source 'https://github.com/CocoaPods/Specs.git'

platform :ios, "9.0"

target 'NextBus-Mantle' do
	pod 'AFNetworking'
	pod 'Mantle'
	pod 'KissXML'
end

target 'NextBus-MantleTests' do
end


post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
		end
	end
end

Pod::Spec.new do |s|
  s.name        = "SimpleMDM"
  s.version     = "0.1.0"
  s.license     = { :type => "MIT" }
  s.homepage    = "https://github.com/karlisl/simplemdm-swift"
  s.summary     = "Swift library for the SimpleMDM API."
  s.authors     = { "Karlis Lapsins" => "me@karlisl.com" }
  s.source      = { :git => "https://github.com/karlisl/simplemdm-swift.git", :tag => s.version }
  s.source_files = "Sources/*.swift"
  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.12"
  s.dependency 'Alamofire', '~> 4.5'
  s.dependency 'SwiftyJSON', '~> 4.0'
end
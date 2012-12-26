Pod::Spec.new do |s|
  s.name         = "HTDelegateProxy"
  s.version      = "0.0.2"
  s.summary      = "A class that allows you to assign multiple delegates."
  s.homepage     = "https://github.com/hoteltonight/HTDelegateProxy"
  s.license      = 'MIT'
  s.author       = { "Jacob Jennings" => "jacob.r.jennings@gmail.com" }
  s.source       = { :git => "https://github.com/hoteltonight/HTDelegateProxy.git", :commit => "3b8fba3c543c6cc617c4e6b6d1b31a9cb588ef60" }
  s.ios.deployment_target = '4.3'
  s.osx.deployment_target = '10.5'
  s.source_files = 'Classes', '*.{h,m}'
  s.requires_arc = true
end


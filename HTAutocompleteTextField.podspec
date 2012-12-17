Pod::Spec.new do |s|
  s.name         = "HTAutocompleteTextField"
  s.version      = "0.0.4"
  s.summary      = "A UITextField subclass that adds text autocompletion"
  s.homepage     = "https://github.com/hoteltonight/HTAutocompleteTextField"
  s.license      = 'MIT'
  s.author       = { "Patrick Richards" => "contact@domesticcat.com.au", "Jonathan Sibley" => "jon@hoteltonight.com" }
  s.source       = { :git => "https://github.com/hoteltonight/HTAutocompleteTextField.git", :tag => "0.0.4" }
  s.ios.deployment_target = '4.3'
  s.osx.deployment_target = '10.5'
  s.source_files = 'HTAutocompleteTextField/*'
  s.requires_arc = true
end
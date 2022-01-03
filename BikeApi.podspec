#
# Be sure to run `pod lib lint BikeApi.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BikeApi'
  s.version          = '1.0.2'
  s.summary          = 'A short description of Api.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/LucaDonetti/BikeApi.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luca.donetti@akka.eu' => 'luca.donetti@akka.eu' }
  s.source           = { :git => 'https://github.com/LucaDonetti/BikeApi.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.1'
  
  s.source_files = 'Classes/**/*'
  
  s.swift_version= '5.0'
  
  s.frameworks = 'Foundation'
  
  s.dependency 'Alamofire', '~> 4.8'
  s.dependency 'KeychainAccess'
  s.dependency 'ObjectMapper'
  s.dependency 'PromiseKit', '~> 6.8.3'
  s.dependency 'MSAL'
end

#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint sbb_oidc.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'sbb_oidc'
  s.version          = '0.0.1'
  s.summary          = 'SBB OpenID Connect package for Flutter'
  s.description      = <<-DESC
SBB OpenID Connect package for Flutter
                       DESC
  s.homepage         = 'https://github.com/SchweizerischeBundesbahnen/flutter-oidc'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'SBB' => 'opensource@sbb.ch' }
  s.source           = { :path => '.' }
  s.source_files = 'sbb_oidc/Sources/sbb_oidc/**/*'
  s.dependency 'Flutter'
  s.dependency 'MSAL', '2.15.0'
  s.platform = :ios, '15.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end

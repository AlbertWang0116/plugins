Pod::Spec.new do |s|

  s.name = "EarlGreyFlutterApp"
  s.version = "2.2.1"
  s.summary = "EarlGrey extension for Flutter"
  s.homepage = "https://github.com/flutter/plugins/tree/master/packages/earlgrey"
  s.author = "Google LLC."
  s.description = <<-DESC
Enables EarlGrey to interact with Flutter widgets.
                       DESC
  s.license = { :type => "BSD", :file => "../LICENSE" }

  s.source = { :http => "https://github.com/flutter/plugins/tree/master/packages/earlgrey" }

  s.dependency "EarlGreyApp", "2.2.1"
  s.dependency "SocketRocket"
  s.dependency "PromisesObjC"
  s.dependency "Flutter"

  s.source_files = Dir.glob("EarlGreyFlutterApp/**/*.{m,h}")
  s.public_header_files = [
    "EarlGreyFlutterApp/Assertion/GREYFlutterAssertions.h",
  ]

  # Flutter.framework doesn't support i386 and arm64 on simulator.
  s.user_target_xcconfig = { 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.pod_target_xcconfig = { 'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/EarlGreyApp/EarlGreyApp/AppFramework.framework/Headers"', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }

  s.platform = :ios, '10.0'
end

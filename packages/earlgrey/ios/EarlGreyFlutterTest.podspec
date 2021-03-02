Pod::Spec.new do |s|

  s.name = "EarlGreyFlutterTest"
  s.version = "2.2.1"
  s.summary = "EarlGrey extension for Flutter"
  s.homepage = "https://github.com/flutter/plugins/tree/master/packages/earlgrey"
  s.author = "Google LLC."
  s.description = <<-DESC
Enables EarlGrey to interact with Flutter widgets.
                       DESC
  s.license = { :type => "BSD", :file => "../LICENSE" }

  s.source = { :http => "https://github.com/flutter/plugins/tree/master/packages/earlgrey" }

  s.dependency "EarlGreyTest", "2.2.1"

  s.source_files = Dir.glob("EarlGreyFlutterTest/**/*.{m,h}") +
                  Dir.glob("EarlGreyFlutterApp/{Action,Assertion,Core,Matcher}/**/*.h") +
                  Dir.glob("EarlGreyFlutterApp/{Action,Assertion,Core,Matcher}/**/*Shorthand.m")

  s.public_header_files = [
      "EarlGreyFlutterApp/Action/GREYFlutterAction.h",
      "EarlGreyFlutterApp/Action/GREYFlutterActionsShorthand.h",
      "EarlGreyFlutterApp/Assertion/GREYFlutterAssertion.h",
      "EarlGreyFlutterApp/Assertion/GREYFlutterAssertionsShorthand.h",
      "EarlGreyFlutterApp/Matcher/GREYFlutterMatcher.h",
      "EarlGreyFlutterApp/Matcher/GREYFlutterMatchersShorthand.h",
      "EarlGreyFlutterTest/EarlGrey+Flutter.h",
      "EarlGreyFlutterTest/EarlGreyImpl+Flutter.h",
      "EarlGreyFlutterTest/GREYFlutterInteractionProxy.h",
  ]

  s.platform = :ios, '10.0'
end

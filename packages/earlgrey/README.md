# earlgrey

Provides bindings for EarlGrey tests of Flutter iOS apps.

## Installation

To use `earlgrey` package, your minimum iOS version should be 10.0.

[Setting up XCUITest](https://github.com/flutter/plugins/blob/master/CONTRIBUTING.md#setting-up-xcuitests)
and implement the tests, e.g.

```objc
#import <XCTest/XCTest.h>
#import <EarlGreyTest/EarlGrey.h>
#import <EarlGreyFlutterTest/EarlGrey+Flutter.h>

@interface RunnerUITests : XCTestCase

@end

@implementation RunnerUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // UI tests must launch the application that they test.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  for (int i = 0; i < 10; ++i) {
    [[EarlGrey onFlutterWidget:GFFWithTooltip(@"Increment")] performAction:GFFTap()];
  }
}

@end
```

Add `EarlGreyFlutterApp` to your Podfile's app target.

Add `EarlGreyFlutterTest` to your Podfile's test target, e.g.:

```
target 'Runner' do
  pod 'EarlGreyFlutterApp'
end

target 'RunnerUITests' do
  pod 'EarlGreyFlutterTest'
end
```

You'll need to create a test app that enables the Flutter driver extension. You
can put this in your test_driver/ folder, e.g. test_driver/example.dart. Replace
`<app_package_name>` with the package name of your app. If you're developing a
plugin, this will be the package name of the example app.

```dart
import 'package:flutter_driver/driver_extension.dart';
import 'package:<app_package_name>/main.dart' as app;

void main() {
  enableFlutterDriverExtension();
  app.main();
}
```

The following command line command runs the test locally:

```bash

$ xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -sdk iphonesimulator
-destination <your target device> test

```

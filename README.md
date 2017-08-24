# Hunkered

[![CI Status](http://img.shields.io/travis/Kris Steigerwald/Hunkered.svg?style=flat)](https://travis-ci.org/Kris Steigerwald/Hunkered)
[![Version](https://img.shields.io/cocoapods/v/Hunkered.svg?style=flat)](http://cocoapods.org/pods/Hunkered)
[![License](https://img.shields.io/cocoapods/l/Hunkered.svg?style=flat)](http://cocoapods.org/pods/Hunkered)
[![Platform](https://img.shields.io/cocoapods/p/Hunkered.svg?style=flat)](http://cocoapods.org/pods/Hunkered)

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required to build Hunkered 

To integrate Hunkered into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'Hunkered'
end
```

Then, run the following command:

```bash
$ pod install
```
## Usage
### Stage 'MockData' folder
![Image of Hunkered](https://github.kdc.capitalone.com/lot131/Hunkered/blob/master/HunkeredExample.gif)
*Required

### Making a Request

```swift
import Hunkered
import Alamofire

    //Setup your Alamofire Manager
    var liveConfig: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 8
        configuration.timeoutIntervalForResource = 8
        return configuration
    }
    
    var trustPolices:ServerTrustPolicyManager = ServerTrustPolicyManager(policies: [ "httpbin.org": .disableEvaluation ])

    let liveManager:SessionManager = SessionManager(configuration: liveConfig,
                                                        delegate: SessionDelegate(),
                                                        serverTrustPolicyManager: trustPolices)
    
    //Stage Hunkered with Live Manager
    var requestor:HunkeredRequestManager =  HunkeredRequestManager(state: .live, liveManager)

```

### Response Handling

Handling the `Response` of a `Request` made in Alamofire involves chaining a response handler onto the `Request`.

```swift

    //Set your connection, live or mock mode
    requestor?.setState(state: .mock)

    requestor?.manager.request("https://httpbin.org/todos").responseJSON { response in
        switch response.result {
            case .success(let value):
                    print("It works!", val as Any)
                case .failure(let error):
                    print("Error: Handle failure", error)
            }
            expect.fulfill()
    }

```


To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
iOS 8.0+ / macOS 10.10+ / tvOS 9.0+ / watchOS 2.0+
Xcode 8.1, 8.2, 8.3, and 9.0
Swift 3.0, 3.1, 3.2, and 4.0
## Installation

Hunkered is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Hunkered"
```

## Author

Kris Steigerwald, kris.steigerwald@capitalone.com

## License

Hunkered is available under the MIT license. See the LICENSE file for more info.

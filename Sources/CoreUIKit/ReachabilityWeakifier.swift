//
//  ReachabilityWeakifier.swift
//  Asgl.iOS.SDK.CoreModule
//
//  Created by Davinder S Dhaliwal on 2019-10-03.
//  Copyright © 2019 Nicole Ahadi. All rights reserved.
//

import Foundation
import SystemConfiguration

/**
 `ReachabilityWeakifier` weakly wraps the `Reachability` class
 in order to break retain cycles when interacting with CoreFoundation.

 CoreFoundation callbacks expect a pair of retain/release whenever an
 opaque `info` parameter is provided. These callbacks exist to guard
 against memory management race conditions when invoking the callbacks.

 #### Race Condition

 If we passed `SCNetworkReachabilitySetCallback` a direct reference to our
 `Reachability` class without also providing corresponding retain/release
 callbacks, then a race condition can lead to crashes when:
 - `Reachability` is deallocated on thread X
 - A `SCNetworkReachability` callback(s) is already in flight on thread Y

 #### Retain Cycle

 If we pass `Reachability` to CoreFoundtion while also providing retain/
 release callbacks, we would create a retain cycle once CoreFoundation
 retains our `Reachability` class. This fixes the crashes and his how
 CoreFoundation expects the API to be used, but doesn't play nicely with
 Swift/ARC. This cycle would only be broken after manually calling
 `stopNotifier()` — `deinit` would never be called.

 #### ReachabilityWeakifier

 By providing both retain/release callbacks and wrapping `Reachability` in
 a weak wrapper, we:
 - interact correctly with CoreFoundation, thereby avoiding a crash.
 See "Memory Management Programming Guide for Core Foundation".
 - don't alter the public API of `Reachability.swift` in any way
 - still allow for automatic stopping of the notifier on `deinit`.
 */
public class ReachabilityWeakifier {
    weak var reachability: Reachability?
    init(reachability: Reachability) {
        self.reachability = reachability
    }
}

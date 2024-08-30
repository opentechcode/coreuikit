//
//  Observable.swift
//  AngusMobile
//
//  Created by ali on 2019-09-25.
//  Copyright © 2019 Angus Systems. All rights reserved.
//

import Foundation
import UIKit

public class Observable<T> {
    
    
    public typealias Listener = (T?) -> Void
    private var listener: Listener?
    
    public var subscribe: ((UIControl.Event) -> Void)?
   
    
    public var value: T? {
        didSet {
                listener?(value)
            }
    }
    
   public init(value: T? = nil) {
        self.value = value
    }
    
    public func bind(listener: @escaping Listener) {
        self.listener = listener
        if let value = value {
            self.listener?(value)
        }
    }
    
    public func unbind() {
        self.listener = nil
    }
    
    deinit {
       // print ("Observable removed")
    }
}

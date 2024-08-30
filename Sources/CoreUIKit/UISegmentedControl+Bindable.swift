//
//  UISegmentedControl+Bindable.swift
//  Asgl.iOS.SDK.CoreModule
//
//  Created by ali on 2019-12-08.
//  Copyright © 2019 Nicole Ahadi. All rights reserved.
//

import Foundation
import UIKit

extension UISegmentedControl : BindableProtocol {
    public typealias BindingType = Int
    
    public func observingValue() -> Int? {
        return self.selectedSegmentIndex
    }
    
    public func updateValue(with value: Int) {
        self.selectedSegmentIndex = value
    }
    
    public func registerEvent(for observable: Observable<T>) {
        self.addTarget(self, action: #selector(valueChanged), for: [.editingChanged, .valueChanged])
    }
    
    public func unRegisterEvent() {
        self.removeTarget(self, action: #selector(valueChanged), for: [.editingChanged, .valueChanged])
    }
    
    @objc func valueChanged() {
        self.binder.subscribe?(UIControl.Event.valueChanged)
        if binder.value != self.observingValue() {
            setBinderValue(with: self.observingValue())
        }
    }
}

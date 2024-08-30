//
//  UITextView+bindable.swift
//  Asgl.iOS.SDK.CoreModule
//
//  Created by ali on 2019-11-18.
//  Copyright © 2019 Nicole Ahadi. All rights reserved.
//

import Foundation
import UIKit

extension UITextView : BindableProtocol {
    
    public typealias T = String
   
    public func observingValue() -> String? {
        return self.text
    }
    
    public func updateValue(with value: String) {
        self.text = value
    }
    
    public func registerEvent(for observable: Observable<T>) {
        NotificationCenter.default.addObserver(self, selector: #selector(valueChanged), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    public func unRegisterEvent() {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc func valueChanged() {
        self.binder.subscribe?(UIControl.Event.valueChanged)
        if binder.value != self.observingValue() {
            setBinderValue(with: self.observingValue())
        }
    }
}

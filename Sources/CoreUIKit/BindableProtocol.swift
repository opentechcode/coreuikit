//
//  BindableProtocol.swift
//  AngusMobile
//
//  Created by ali on 2019-09-25.
//  Copyright © 2019 Angus Systems. All rights reserved.
//

import Foundation

public protocol BindableProtocol {
    associatedtype T: Equatable
    
    func observingValue() -> T?
    func updateValue(with value: T)
    func registerEvent(for observable: Observable<T>)
    func unRegisterEvent()
    func unBind()
}

extension BindableProtocol where Self: NSObject {
    public var binder: Observable<T> {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.binder) as? Observable<T> else {
                let newValue = Observable<T>()
                objc_setAssociatedObject(self, &AssociatedKeys.binder, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return newValue
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.binder, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func removeBinder() {
        objc_removeAssociatedObjects(self)
    }
    
    func getBinderValuer() -> T? {
        return binder.value
    }
    
    func setBinderValue(with value: T?) {
        binder.value = value
    }
    
    func valueChanged() {
        if binder.value != self.observingValue() {
            setBinderValue(with: self.observingValue())
        }
    }
    
    mutating public func bind(with observable: Observable<T>) {
//        if let _self = self as? UIControl {
//            _self.addTarget(self, action: #selector(valueChanged), for: [.editingChanged, .valueChanged, .touchUpInside])
//        }
        registerEvent(for: observable)
        self.binder = observable
        if let value = observable.value {
            self.updateValue(with: value)
        }
        observable.bind { [weak self] (value) in
            if let value = self?.binder.value, value != self?.observingValue() {
                self?.updateValue(with: value)
            }
        }
    }
    
    public func unBind() {
        self.unRegisterEvent()
        self.binder.unbind()
    }
}

fileprivate struct AssociatedKeys {
    static var binder: UInt8 = 0
}

//
//  Binding.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 20/10/24.
//

import Foundation

final class Binding<ObserverType> {
    
    private var _value: ObserverType
    private var valueChanged: ((ObserverType) -> Void)?
    
    
    var value: ObserverType {
        get {
            return _value
        }
        set {
            DispatchQueue.main.async {
                self._value = newValue
                self.valueChanged?(self._value)
            }
        }
    }
    
    init(_ value: ObserverType) {
        self._value = value
    }
    
    func bind(completion: ((ObserverType) -> Void)?) {
        valueChanged = completion
    }
}

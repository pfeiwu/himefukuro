//
//  Activable.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/12.
//

import Foundation

open class Activable {
    public var isActive: Bool = false
    public var isInactive: Bool {
        return !isActive
    }
    public func activate() {
        isActive = true
    }
    public func inactivate() {
        isActive = false
    }
    public func toggle() {
        isActive.toggle()
    }
    public init() {}
}

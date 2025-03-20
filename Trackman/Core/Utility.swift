//
//  Utility.swift
//  Trackman
//
//  Created by Jonas Rasmussen on 19/03/2025.
//

import Foundation

typealias VoidClosure = () -> Void
typealias TypeClosure<T> = (T) -> Void

enum ViewModelState {
    case loading
    case ready
    case error(Error)
}

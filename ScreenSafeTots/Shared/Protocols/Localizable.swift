//
//  Localizable.swift
//
//  Created by Md. Mehedi Hasan on 31/5/22.


import Foundation

protocol Localizable {
    static var module:String { get }
    var localized:String { get }
}

//
//  Initialization.swift
//
//  Created by Md. Mehedi Hasan on 10/9/20.


import Foundation

 protocol Initializable {
     init()
 }

 protocol WithInitialization {
     static func with<T: Initializable>(task: (T) -> Void) -> T
 }

 extension WithInitialization {
     static func with<T: Initializable>(task: (T) -> Void) -> T {
         let instance = T()
         task(instance)
         return instance
     }
 }

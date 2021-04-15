//
//  ViewModelType.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/14.
//

import Foundation

protocol ViewModelType: class {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}

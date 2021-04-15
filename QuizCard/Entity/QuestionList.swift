//
//  QuestionList.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/14.
//

import Foundation

protocol QuestionListType {
    var id: UUID? { get set }
    var title: String? { get set }
    var date: Date? { get set }
    var questionList: [QuestionType] { get }
}

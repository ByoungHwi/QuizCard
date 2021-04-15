//
//  Question.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/14.
//

import Foundation

protocol QuestionType {
    var id: UUID? { get set }
    var questionText: String? { get set }
    var answerText: String? { get set }
    var date: Date? { get set }
}

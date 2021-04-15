//
//  QuestionMO.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/14.
//

import Foundation

extension QuestionMO: QuestionType {
    static let entityName: String = "Question"
    
    func initialSetUp(questionText: String, answerText: String) {
        self.id = UUID()
        self.questionText = questionText
        self.answerText = answerText
        self.date = Date()
    }
}

extension QuestionMO: CellViewModelConvertable {
    var cellIdentity: UUID? {
        self.id
    }
    
    var cellTitle: String? {
        self.questionText
    }
}

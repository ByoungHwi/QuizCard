//
//  QuestionListMO.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/14.
//

import Foundation

extension QuestionListMO {
    static let entityName: String = "QuestionList"
    
    func initialSetUp(title: String) {
        self.id = UUID()
        self.title = title
        self.date = Date()
    }
    
    @objc var sectionIdentifier: String? {
        self.parent?.id?.uuidString
    }
}

extension QuestionListMO: QuestionListType {
    var questionList: [QuestionType] {
        questions?.allObjects as? [QuestionType] ?? []
    }
}

extension QuestionListMO: CellViewModelConvertable {
    var cellIdentity: UUID? {
        self.id
    }
    
    var cellTitle: String? {
        self.title
    }
}

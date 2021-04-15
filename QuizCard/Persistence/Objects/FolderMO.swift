//
//  FolderMO.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/14.
//

import Foundation

extension FolderMO {
    static let entityName: String = "Folder"
    
    func initialSetUp(title: String) {
        self.id = UUID()
        self.title = title
        self.date = Date()
    }
}

extension FolderMO: FolderType {
    var questionsList: [QuestionListType] {
        self.lists?.allObjects as? [QuestionListMO] ?? []
    }
}

extension FolderMO: CellViewModelConvertable {
    var cellIdentity: UUID? {
        self.id
    }
    
    var cellTitle: String? {
        self.title
    }
}

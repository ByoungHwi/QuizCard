//
//  CellViewModel.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/14.
//

import Foundation
import RxDataSources_Texture

protocol CellViewModelConvertable {
    var cellIdentity: UUID? { get }
    var cellTitle: String? { get }
}

struct CellViewModel: IdentifiableType, Equatable {
    static func == (lhs: CellViewModel, rhs: CellViewModel) -> Bool {
        lhs.identity == rhs.identity && lhs.isFirst == rhs.isFirst && lhs.isLast == rhs.isLast
    }
    
    let identity: UUID?
    let title: String?
    var isFirst: Bool = false
    var isLast: Bool = false
    
    init(identity: UUID?, title: String?) {
        self.identity = identity
        self.title = title
    }
    
    init(with item: CellViewModelConvertable) {
        self.identity = item.cellIdentity
        self.title = item.cellTitle
    }
}

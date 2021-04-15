//
//  TableSection.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/14.
//

import Foundation
import RxDataSources_Texture

struct TableSection: AnimatableSectionModelType {
    var identity: UUID?
    var header: String?
    var items: [CellViewModel]

    init(original: TableSection, items: [CellViewModel]) {
        self = original
        self.items = items
    }
    
    init(header: String? = nil, identity: UUID? = nil, items: [CellViewModelConvertable]) {
        self.identity = identity
        self.header = header
        self.items = items.map { CellViewModel(with: $0) }
        if !items.isEmpty {
            self.items[0].isFirst = true
            self.items[items.endIndex - 1].isLast = true
        }
    }
}

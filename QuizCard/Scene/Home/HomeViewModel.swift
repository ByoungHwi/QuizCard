//
//  HomeViewModel.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/14.
//

import Foundation
import RxSwift
import RxRelay

final class HomeViewModel: ViewModelType {
    
    struct Input {
        let viewWillAppear = PublishRelay<Void>()
        let cellDidSelected = PublishRelay<IndexPath>()
        let cellShouldDelete = PublishRelay<IndexPath>()
        let addButtonTapped = PublishRelay<Void>()
    }
    
    struct Output {
        let selectedItem = PublishRelay<QuestionListType>()
        let presentAddListView = PublishRelay<Void>()
        let folderList = BehaviorRelay<[TableSection]>(value: [])
    }
    
    var input: Input
    var output: Output
    let disposeBag = DisposeBag()
    let dataManager: HomeDataManagable
    
    init(dataManager: HomeDataManagable) {
        input = Input()
        output = Output()
        self.dataManager = dataManager
        bind()
    }
    
    private func bind() {
        input.viewWillAppear
            .subscribe(onNext: { [weak self] _ in
                self?.dataManager.performFetch()
            })
            .disposed(by: disposeBag)
        
        input.cellDidSelected
            .compactMap { [weak self] indexPath in
                self?.dataManager.fetch(at: indexPath)
            }
            .bind(to: output.selectedItem)
            .disposed(by: disposeBag)
        
        input.addButtonTapped
            .bind(to: output.presentAddListView)
            .disposed(by: disposeBag)

        dataManager.dataObserver
            .map {
                $0.map {
                    let parent = $0.first?.parent
                    return TableSection(header: parent?.title, identity: parent?.id, items: $0)
                }
            }
            .do(afterNext: { [weak self] in
                if $0.isEmpty {
                    self?.output.presentAddListView.accept(Void())
                }
            })
            .bind(to: output.folderList)
            .disposed(by: disposeBag)
        
        input.cellShouldDelete
            .asObservable()
            .subscribe(onNext: { [weak self] index in
                self?.updateCellCornerIfNeeded(index: index)
                self?.dataManager.delete(at: index)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateCellCornerIfNeeded(index: IndexPath) {
        guard index.row == 0 else { return }
        var currentData = output.folderList.value
        if currentData[index.section].items.count > 1 {
            currentData[index.section].items[1].isFirst = true
            output.folderList.accept(currentData)
        }
    }
}

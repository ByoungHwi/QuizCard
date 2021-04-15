//
//  AddListViewModel.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import Foundation
import RxSwift
import RxRelay

final class AddListViewModel: ViewModelType {
    
    struct Const {
        static let emptyFolderTitle = "새 폴더"
    }
    
    struct Input {
        let viewWillAppear = PublishRelay<Void>()
        let createNewFolder = PublishRelay<String>()
        let newQuestionListTitle = PublishRelay<String>()
        let selectedIndex = BehaviorRelay<IndexPath?>(value: nil)
        let addButtonTapped = PublishRelay<Void>()
        let cellShouldDelete = PublishRelay<IndexPath>()
    }
    
    struct Output {
        let folderList = BehaviorRelay<[TableSection]>(value: [])
        let saveResult = PublishRelay<Bool>()
        let isAddButtonEnable = BehaviorRelay<Bool>(value: false)
    }
    
    var input: Input
    var output: Output
    let disposeBag = DisposeBag()
    let dataManager: AddListDataManagable
    
    init(dataManager: AddListDataManagable) {
        input = Input()
        output = Output()
        self.dataManager = dataManager
        bind()
    }
    
    private func bind() {
        input.viewWillAppear
            .subscribe(onNext: { [weak self] in
                self?.dataManager.performFetch()
            })
            .disposed(by: disposeBag)
        
        dataManager.dataObserver
            .map { [TableSection(items: $0)] }
            .bind(to: output.folderList)
            .disposed(by: disposeBag)
        
        input.createNewFolder
            .map { $0.isEmpty ? Const.emptyFolderTitle : $0 }
            .subscribe(onNext: { [weak self] in
                print($0.isEmpty)
                self?.dataManager.create(folderTitle: $0)
            })
            .disposed(by: disposeBag)
        
        input.cellShouldDelete
            .subscribe(onNext: { [weak self] in
                if self?.input.selectedIndex.value == $0 {
                    self?.input.selectedIndex.accept(nil)
                }
                self?.updateCellCornerIfNeeded(index: $0)
                self?.dataManager.delete(at: $0)
            })
            .disposed(by: disposeBag)
        
        let inputsForNewList = Observable.combineLatest(input.newQuestionListTitle,
                                                        input.selectedIndex)
        
        inputsForNewList
            .map { title, index in
                return !title.isEmpty && index != nil
            }
            .bind(to: output.isAddButtonEnable)
            .disposed(by: disposeBag)
        
        input.addButtonTapped.withLatestFrom(inputsForNewList)
            .map { [weak self] title, selectedIndex -> Bool in
                guard let `self` = self,
                      let selectedIndex = selectedIndex else { return false }
                return self.dataManager.create(questionListTitle: title,
                                               at: selectedIndex)
            }
            .bind(to: output.saveResult)
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

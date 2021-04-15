//
//  TestViewModel.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import Foundation
import RxSwift
import RxRelay

enum TestResultType {
    case perfect
    case good
    case soso
    case notGood
    case bad
    
    var lottieName: String {
        switch self {
        case .perfect:
            return "PerfectLottie"
        case .good:
            return "GoodLottie"
        case .soso:
            return "SosoLottie"
        case .notGood:
            return "NotGoodLottie"
        case .bad:
            return "BadLottie"
        }
    }
}

typealias TestResult = (total: Int, rightCount: Int, type: TestResultType)

final class TestViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let cardDidMoveLeft = PublishRelay<Int>()
        let cardDidMoveRight = PublishRelay<Int>()
        let testDidFinish = PublishRelay<Void>()
        let restartButtonDidTap = PublishRelay<Void>()
        let restartWithFailedOnlyButtonDidTap = PublishRelay<Void>()
    }
    
    struct Output {
        let cardDataList = BehaviorRelay<[QuestionType]>(value: [])
        let testResult = PublishRelay<TestResult>()
    }
    
    var input: Input
    var output: Output
    let disposeBag = DisposeBag()
    
    private let cardList: [QuestionType]
    private var results: [Bool] = []
    
    init(cardList: [QuestionType]) {
        input = Input()
        output = Output()
        self.cardList = cardList
        bind()
    }
    
    private func bind() {
        input.viewDidLoad
            .flatMap { [unowned self] in
                self.getCardList()
            }
            .bind(to: output.cardDataList)
            .disposed(by: disposeBag)
     
        input.cardDidMoveLeft
            .subscribe(onNext: { [weak self] _ in
                self?.results.append(false)
            })
            .disposed(by: disposeBag)
        
        input.cardDidMoveRight
            .subscribe(onNext: { [weak self] _ in
                self?.results.append(true)
            })
            .disposed(by: disposeBag)
        
        input.testDidFinish
            .compactMap { [unowned self] in
                self.getTestResult(from: self.results)
            }
            .bind(to: output.testResult)
            .disposed(by: disposeBag)
        
        input.restartButtonDidTap
            .do(onNext: { [weak self] _ in
                self?.results = []
            })
            .flatMap { [unowned self] in
                self.getCardList()
            }
            .bind(to: output.cardDataList)
            .disposed(by: disposeBag)
        
        input.restartWithFailedOnlyButtonDidTap
            .withLatestFrom(output.cardDataList)
            .map { [unowned self] in
                self.filterFailedQuestions(from: $0, with: self.results)
            }
            .do(onNext: { [weak self] _ in
                self?.results = []
            })
            .bind(to: output.cardDataList)
            .disposed(by: disposeBag)
    }
    
    private func getCardList() -> Observable<[QuestionType]> {
        return Observable.create { [weak self] observer in
            observer.onNext(self?.cardList ?? [])
            return Disposables.create()
        }
    }
    
    private func filterFailedQuestions(from origin: [QuestionType], with results: [Bool]) -> [QuestionType] {
        return zip(origin, results)
            .filter { !$0.1 }
            .map { $0.0 }
    }
    
    private func getTestResult(from result: [Bool]) -> TestResult {
        let total = result.count
        let rightCount = result.filter { $0 }.count
        let percent = Double(rightCount)/Double(total)
        
        let type: TestResultType
        switch percent {
        case 0..<0.2:
            type = .bad
        case 0.2..<0.4:
            type = .notGood
        case 0.4..<0.6:
            type = .soso
        case 0.6..<0.8:
            type = .good
        default:
            type = .perfect
        }
        return (total, rightCount, type)
    }
}

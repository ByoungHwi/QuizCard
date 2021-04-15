//
//  VCenterEditableTextNode.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit
import RxSwift

class VCenterEditableTextNode: ASEditableTextNode {
    
    var disposeBag = DisposeBag()
    
    override init() {
        super.init()
    }
    
    override init(textKitComponents: ASTextKitComponents, placeholderTextKitComponents: ASTextKitComponents) {
        super.init(textKitComponents: textKitComponents, placeholderTextKitComponents: placeholderTextKitComponents)
    }
    
    override func layout() {
        super.layout()
        textView.alignTextCenterVertically()
        textView.contentInset.top += 1
        textView.setNeedsLayout()
        textView.layoutIfNeeded()
    }
    
    func observeContentSize() {
        textView.rx.observe(CGSize.self, "contentSize")
            .subscribe(onNext: { [weak self] _ in
                self?.textView.alignTextCenterVertically()
            })
            .disposed(by: disposeBag)
    }
}

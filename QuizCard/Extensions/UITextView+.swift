//
//  UITextView+.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import UIKit

extension UITextView {
    func alignTextCenterVertically() {
        guard bounds.size.height != .zero else { return }
        var topInset = (bounds.size.height - contentSize.height * zoomScale) / 2.0
        topInset = max(0, topInset)
        contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    }
}

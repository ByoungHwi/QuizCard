//
//  AppConst.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/14.
//

import UIKit

struct AppConst {
    static let appThemeColor: UIColor = UIColor(named: "AppThemeColor") ?? .systemOrange
    static let backgroundColor = UIColor(named: "BackgroundColor") ?? .systemGray6
    static let edgeColor = UIColor(named: "EdgeColor") ?? .lightGray
    
    static func font(size: CGFloat, color: UIColor = .black, alignment: NSTextAlignment = .natural) -> [NSAttributedString.Key: Any] {
        var attr: [NSAttributedString.Key: Any] = [:]
        attr[.font] = UIFont(name: "Helvetica", size: size)
        attr[.foregroundColor] = color
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        attr[.paragraphStyle] = style
        return attr
    }
    
    static func boldFont(size: CGFloat, color: UIColor = .black, alignment: NSTextAlignment = .natural) -> [NSAttributedString.Key: Any] {
        var attr: [NSAttributedString.Key: Any] = [:]
        attr[.font] = UIFont(name: "Helvetica-Bold", size: size)
        attr[.foregroundColor] = color
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        attr[.paragraphStyle] = style
        return attr
    }
    
    static func mediumFont(size: CGFloat, color: UIColor = .black, alignment: NSTextAlignment = .natural) -> [NSAttributedString.Key: Any] {
        var attr: [NSAttributedString.Key: Any] = [:]
        attr[.font] = UIFont(name: "HelveticaNeue-Medium", size: size)
        attr[.foregroundColor] = color
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        attr[.paragraphStyle] = style
        return attr
    }
}

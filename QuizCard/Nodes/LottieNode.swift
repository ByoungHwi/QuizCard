//
//  LottieNode.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit
import Lottie

class LottieNode: ASDisplayNode {
    
    var lottieView: AnimationView? {
        view as? AnimationView
    }
    
    var loopMode: LottieLoopMode = .playOnce {
        didSet {
            lottieView?.loopMode = loopMode
        }
    }
    
    init(name: String? = nil) {
        super.init()
        setViewBlock {
            let animation = Animation.named(name ?? "")
            let view = AnimationView(animation: animation)
            return view
        }
    }
    
    func play() {
        lottieView?.play()
    }
    
    func stop() {
        lottieView?.stop()
    }
    
    func reverseHorizontally() {
        let reverseTransform = CGAffineTransform(scaleX: -1, y: 1)
        transform = CATransform3DMakeAffineTransform(reverseTransform)
    }
    
    func change(to name: String) {
        lottieView?.animation = Animation.named(name)
    }
}

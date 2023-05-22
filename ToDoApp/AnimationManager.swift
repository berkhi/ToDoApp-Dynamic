//
//  AnimationManager.swift
//  ToDoApp
//
//  Created by BerkH on 22.05.2023.
//

import Foundation
import Lottie

class AnimationManager {
    static let shared = AnimationManager()
    
    var animationView: LottieAnimationView?
    
    func setupAnimation(in view: UIView) {
        animationView = .init(name: "wavecolored")
        animationView?.frame = view.bounds
        animationView?.backgroundColor = .white
        animationView?.loopMode = .loop
        animationView?.animationSpeed = 0.75
        view.addSubview(animationView!)
    }
    
    func startAnimation() {
        animationView?.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.stopAnimation()
        }
    }
    
    func stopAnimation() {
        animationView?.stop()
        animationView?.removeFromSuperview()
        animationView = nil
    }
}


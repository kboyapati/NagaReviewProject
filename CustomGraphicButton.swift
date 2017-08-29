//
//  CustomGraphicButton.swift
//  NagaReviewProject
//
//  Created by Naga Boyapati on 8/29/17.
//  Copyright © 2017 Naga Boyapati. All rights reserved.
//

import UIKit

class CustomGraphicButton: UIButton {

    override func awakeFromNib() {
        setupView()
    }
    

    private func setupView(){
        self.alpha = 0.8
        self.layer.cornerRadius = self.frame.width/2
        self.layer.shadowOpacity = 0.9
        self.layer.shadowOffset = CGSize(width:0.0, height:2.0)

        self.setImage(UIImage(named: "Up"), for: .normal)
        self.setImage(UIImage(named: "Up"), for: .selected)
        self.setImage(UIImage(named: "Up"), for: .highlighted)
        let floatingButtonShadowColor = UIColor(red: 0.2, green: 0.3, blue: 0.6, alpha: 1.0)

//        self.layer.shadowColor = UIColor.blue.cgColor
//        self.tintColor = UIColor.blue

        self.layer.shadowColor = floatingButtonShadowColor.cgColor
        self.tintColor = floatingButtonShadowColor

        // Animations when touched and released.
        self.addTarget(self, action: #selector(CustomGraphicButton.touchDownAnimate), for: .touchDown)
        self.addTarget(self, action: #selector(CustomGraphicButton.touchDragExitAnimate), for: .touchUpInside)
        self.addTarget(self, action: #selector(CustomGraphicButton.touchDragExitAnimate), for: .touchDragExit)
    }
    
    
    // Make the button full opaque when touched
    @objc private func touchDownAnimate(){
        self.alpha = 1.0
    }
    // Restore to translucent when released
    @objc private func touchDragExitAnimate(){
        self.alpha = 0.5
    }

}


//
//  SortView.swift
//  SortDemo
//
//  Created by Cuicui You 尤翠翠 on 2019/1/25.
//  Copyright © 2019年 Cuicui You 尤翠翠. All rights reserved.
//

import UIKit

class SortView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        print("master2")
    }
    
    override func layoutSubviews() {
        let y: CGFloat = (self.superview?.frame.height)! - frame.height
        self.frame = frame
        self.frame.origin.y = y
        
        let weight = frame.height / (self.superview?.frame.height)!
        let color = UIColor(hue: weight, saturation: 1, brightness: 1, alpha: 1)
        self.backgroundColor = color
        print("master1")
        print("master2")
    }
    
    func updateHeight(height: CGFloat) {
        self.frame.size.height = height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//
//  MemoryProgresView.swift
//  Test task iOS - OsmAnd
//
//  Created by Stas Shetko on 2/03/20.
//  Copyright © 2020 Stas Shetko. All rights reserved.
//

import UIKit

class MemoryProgresView: UIProgressView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func layoutSubviews() {
        super.layoutSubviews()

//        let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: 4.0)
//        let maskLayer = CAShapeLayer()
//        maskLayer.frame = self.bounds
//        maskLayer.path = maskLayerPath.cgPath
//        layer.mask = maskLayer
        let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height / 2)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskLayerPath.cgPath
        layer.mask = maskLayer
    }

}

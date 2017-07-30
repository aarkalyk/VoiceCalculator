//
//  ElasticOvalViewExtension.swift
//  Contactis_Challenge
//
//  Created by ARKALYK AKASH on 7/30/17.
//  Copyright © 2017 ARKALYK AKASH. All rights reserved.
//

import Foundation
import UIKit

extension ElasticOvalView{
    //MARK: - Animations
    func compressView(){
        startBouncing()
        self.isUserInteractionEnabled = false
        let y : CGFloat = 10.0
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.controlPointView.center.y += y
            self.resultView.alpha = 0.0
        }) { (_) in
            UIView.animate(withDuration: 0.45, delay: 0.0, usingSpringWithDamping: 0.15, initialSpringVelocity: 5.5, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                self.positionControlPoint()
            }, completion: { (_) in
                if self.isExpanded{
                    if let delegate = self.delegate{
                        delegate.didCollapse(elasticView: self)
                    }
                }
                self.isExpanded = false
                self.stopBouncing()
                self.isUserInteractionEnabled = true
                self.pan.isEnabled = true
                self.updateHeight()
            })
        }
    }
    
    func expandView(){
        startBouncing()
        self.isUserInteractionEnabled = false
        let y : CGFloat = 30.0
        let controlHeight = Sizes.expandedViewHeight
        let sideHeight = controlHeight - Sizes.controlAndSidePointDifference
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.controlPointView.center.y = controlHeight + y
            self.controlPointView.center.x = self.frame.midX
            self.leftPointView.center.y = !self.isExpanded ? (sideHeight + y) : sideHeight
            self.rightPointView.center.y = !self.isExpanded ? (sideHeight + y) : sideHeight
            self.resultView.alpha = 1.0
        }) { (_) in
            UIView.animate(withDuration: 0.45, delay: 0.0, usingSpringWithDamping: 0.15, initialSpringVelocity: 5.5, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                self.controlPointView.center.y -= y
                self.leftPointView.center.y -= !self.isExpanded ? y : 0
                self.rightPointView.center.y -= !self.isExpanded ? y : 0
            }, completion: { (_) in
                self.isExpanded = true
                self.stopBouncing()
                self.isUserInteractionEnabled = true
                self.pan.isEnabled = true
                self.updateHeight()
            })
        }
    }
    
    //MARK: - Helper methods
    func bounceLayer(){
        elasticShapeLayer.path = pathForElasticShapeFor(controlPoint: (controlPointView.layer.presentation()?.position)!)
    }
    
    func startBouncing(){
        displayLink.isPaused = false
    }
    
    func stopBouncing(){
        displayLink.isPaused = true
    }
    
    private func updateHeight(){
        var frame = self.frame
        frame.size.height = controlPointView.frame.maxY
        self.frame = frame
    }
}

//
//  ElasticOvalView.swift
//  Contactis_Challenge
//
//  Created by ARKALYK AKASH on 7/29/17.
//  Copyright © 2017 ARKALYK AKASH. All rights reserved.
//

import UIKit
import Neon

protocol ElasticOvalViewDelegate: AnyObject {
    func didCollapse(elasticView: ElasticOvalView)
}

class ElasticOvalView: UIView {
    //MARK: - Properties
    weak var delegate: ElasticOvalViewDelegate?
    
    lazy var elasticShapeLayer : CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.customPink.cgColor
        return layer
    }()
    
    lazy var controlPointView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var leftPointView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var rightPointView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var expressionLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.SFRegular(ofSize: 20)
        return label
    }()
    
    lazy var resultView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.alpha = 0.0
        return view
    }()
    
    private lazy var resultLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = UIFont.SFDisplayBold(ofSize: 28)
        return label
    }()
    
    lazy var displayLink : CADisplayLink = {
        let displayLink = CADisplayLink(target: self, selector: #selector(bounceLayer))
        displayLink.add(to: .current, forMode: .commonModes)
        return displayLink
    }()
    
    lazy var pan : UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handle(pan:)))
        return pan
    }()
    
    var expressionText : String?{
        didSet{
            if let text = expressionText{
                expressionLabel.text = text
            }
        }
    }
    
    var resultText : String?{
        didSet{
            if let text = resultText{
                resultLabel.text = text
            }
        }
    }
    
    var isExpanded = false
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup(){
        self.addGestureRecognizer(pan)
        self.backgroundColor = .clear
        self.clipsToBounds = false
        
        layer.addSublayer(elasticShapeLayer)
        elasticShapeLayer.fillColor = UIColor.customPink.cgColor
        self.addSubview(controlPointView)
        self.addSubview(expressionLabel)
        self.addSubview(resultView)
        resultView.addSubview(resultLabel)
        
        updateConstraints()
    }
    
    //MARK: - Constraints
    override func updateConstraints() {
        super.updateConstraints()
        positionControlPoint()
        elasticShapeLayer.path = pathForElasticShapeFor(controlPoint: controlPointView.center)
        expressionLabel.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: Sizes.compressedViewHeight)
        resultView.align(.underCentered, relativeTo: expressionLabel, padding: -Sizes.controlAndSidePointDifference, width: self.frame.size.width-20, height: Sizes.expandedViewHeight - Sizes.compressedViewHeight)
        resultLabel.fillSuperview()
    }
    
    func positionControlPoint(){
        let sidePointY = Sizes.compressedViewHeight - Sizes.controlAndSidePointDifference
        leftPointView.center = CGPoint(x: 0, y: sidePointY)
        rightPointView.center = CGPoint(x: self.frame.maxX, y: sidePointY)
        controlPointView.center = CGPoint(x: self.frame.midX, y: Sizes.compressedViewHeight)
    }
    
    //MARK: - Drawing
    func pathForElasticShapeFor(controlPoint : CGPoint) -> CGPath{
        let myBezier = UIBezierPath()
        let rect = self.bounds.size
        myBezier.move(to: leftPointView.center)
        myBezier.addQuadCurve(to: rightPointView.center, controlPoint: controlPoint)
        myBezier.addLine(to: CGPoint(x: rect.width, y: 0))
        myBezier.addLine(to: CGPoint(x: 0, y: 0))
        myBezier.close()
        return myBezier.cgPath
    }
    
    //MARK: - Gestures
    func handle(pan : UIPanGestureRecognizer){
        startBouncing()
        let translation = pan.translation(in: self)
        controlPointView.center.x += translation.x
        controlPointView.center.y += translation.y
        pan.setTranslation(.zero, in: self)
        if pan.state == .ended{
            compressView()
        }
    }
}

//
//  WEBJOBSSpinner.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 04/06/2022.
//

import UIKit

class WEBJOBSSpinner: UIView {
    
    private lazy var width: CGFloat = {
        return UIScreen.main.bounds.size.width * 0.15
    }()
    
    private lazy var rotationPoint = {
        return CGPoint(x: width/2, y: width/2)
    }()
    
    private var currentAngle = CGFloat(30)
    private var timer: Timer?
    
    private lazy var dashLayers: [SpinnerDashLayer] = []
    
    // MARK: - inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - LifeCycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2

        guard timer == nil else { return }
        
        transformDashLayers()
        
        startTimer()
    }
    
    // MARK: - Setup
    
    private func setup() {
        backgroundColor = .clear
        
        for _ in 1...12 {
            let dashLayer = SpinnerDashLayer()
            dashLayer.frame = CGRect(x: 0, y: 0, width: 5, height: width * 0.2)
            self.dashLayers.append(dashLayer)
            self.layer.addSublayer(dashLayer)
        }
        
    }
    
    private func transformDashLayers() {
        for i in 0...11 {
            let dashLayer = dashLayers[i]
            dashLayer.position = CGPoint(x: self.bounds.midX, y: dashLayer.frame.height/2)
            
            let rotationAngle = CGFloat(30 * i) * CGFloat.pi / 180.0
            
            var t: CATransform3D = CATransform3DIdentity
            t = CATransform3DTranslate(t, rotationPoint.x-dashLayer.frame.midX, rotationPoint.y-dashLayer.frame.midY, 0.0)
            t = CATransform3DRotate(t, rotationAngle, 0.0, 0.0, 1.0)
            t = CATransform3DTranslate(t, dashLayer.frame.midX-rotationPoint.x, dashLayer.frame.midY-rotationPoint.y, 0.0)
            
            dashLayer.transform = t
            
            if i == 9 {
                dashLayer.backgroundColor = UIColor(named: "SpinnerDash10")!.cgColor
            } else if i == 10 {
                dashLayer.backgroundColor = UIColor(named: "SpinnerDash11")!.cgColor
            } else if i == 11 {
                dashLayer.backgroundColor = UIColor(named: "SpinnerDash12")!.cgColor
            }
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(
           withTimeInterval: 0.05,
           repeats: true,
           block: { _ in
               self.transform = CGAffineTransform(rotationAngle: self.currentAngle * CGFloat.pi / 180.0)
               self.currentAngle += 30
           }
       )
    }
}

fileprivate class SpinnerDashLayer: CAShapeLayer {
    
    // MARK: - inits
    
    override init() {
        super.init()
        
        setup()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        cornerRadius = bounds.width / 2
    }
    
    func setup() {
        backgroundColor = UIColor(named: "SpinnerDash")!.cgColor
    }
    
}


//
//  ViewController.swift
//  MyCircularLoader
//
//  Created by Tobi Omotayo on 07/02/2018.
//  Copyright © 2018 Oluwatobi Omotayo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    
    let shapeLayer = CAShapeLayer()
    
    var pulsatingLayer: CAShapeLayer!
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        return label
    }()
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    // to ensure the animation continues with the pulsatin animation when you suspend the app.
    @objc private func handleEnterForeground() {
        animatePulsatingLayer()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotificationObservers()
        
        view.backgroundColor = UIColor.backgroundColor
        
        // let's start by drawing a circle somehow
        
//        let center = view.center
        
        // create my track layer
        let trackLayer = CAShapeLayer()
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        pulsatingLayer = CAShapeLayer()
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.fillColor = UIColor.pulsatingFillColor.cgColor
        pulsatingLayer.strokeColor = UIColor.clear.cgColor
        pulsatingLayer.lineWidth = 20
        pulsatingLayer.lineCap = kCALineCapRound
        pulsatingLayer.position = view.center
        view.layer.addSublayer(pulsatingLayer)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.backgroundColor.cgColor
        trackLayer.strokeColor = UIColor.trackStrokeColor.cgColor
        trackLayer.lineWidth = 20
        trackLayer.lineCap = kCALineCapRound
        trackLayer.position = view.center
        view.layer.addSublayer(trackLayer)
        
        animatePulsatingLayer()
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.outlineStrokeColor.cgColor
        shapeLayer.lineWidth = 20
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.position = view.center
        
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    let urlString = "https://firebasestorage.googleapis.com/v0/b/firestorechat-e64ac.appspot.com/o/intermediate_training_rec.mp4?alt=media&token=e20261d0-7219-49d2-b32d-367e1606500c"
    
    fileprivate func beginDownloadingFile() {
        shapeLayer.strokeEnd = 0
        
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        guard let url = URL(string: urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(percentage * 100))%"
            self.shapeLayer.strokeEnd = percentage
        }
        
        print(percentage * 100)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("finished downloading file")
    }
    
    fileprivate func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        
        basicAnimation.duration = 2
        
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    @objc private func handleTap() {
        
        beginDownloadingFile()
        
//        animateCircle()
        
    }


}


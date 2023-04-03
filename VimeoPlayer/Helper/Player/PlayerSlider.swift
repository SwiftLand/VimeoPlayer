//
//  PlayerSlider.swift
//  VimeoPlayer
//
//  Created by Ali on 2/15/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class PlayerSlider: UISlider {
    
    enum Status{
        case startDrag
        case stopDrag
    }
    
    let status:PublishRelay<Status> = .init()
    
    override var value: Float {
        didSet{
            updateTracker(value)
        }
    }
    
    private let baseLayer = CALayer()
    private let trackLayer = CALayer()
    private var disposeBag = DisposeBag()
    private var trackLayerPoint:CGPoint{
        CGPoint(x: baseLayer.frame.minX+1, y: baseLayer.frame.minY+1)
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
    }
    
    private func setup() {
        clear()
        createBaseLayer()
        createThumbImageView()
        configureTrackLayer()
        
        rx.value.distinctUntilChanged().subscribe(onNext: {[weak self] value in
            self?.updateTracker(value)
        }).disposed(by: disposeBag)
        
        rx.controlEvent([.touchDown])
            .subscribe{[weak self]_ in
            self?.status.accept(.startDrag)
        }.disposed(by: disposeBag)
        
        rx.controlEvent([.touchUpInside, .touchUpOutside])
            .subscribe{[weak self]_ in
                self?.status.accept(.stopDrag)
        }.disposed(by: disposeBag)
        
    }
    
    private func clear() {
        tintColor = .clear
        maximumTrackTintColor = .clear
        backgroundColor = .clear
        thumbTintColor = .clear
    }
    
    
    private func createBaseLayer() {
        baseLayer.borderWidth = 1
        baseLayer.borderColor = UIColor.darkGray.cgColor
        baseLayer.masksToBounds = true
        baseLayer.backgroundColor = UIColor.white.cgColor
        baseLayer.frame = .init(origin: .zero, size: CGSize(width: frame.width, height: frame.height))
        layer.insertSublayer(baseLayer, at: 0)
    }
    
    
    private func configureTrackLayer() {
        trackLayer.backgroundColor = UIColor.lightGray.cgColor
        trackLayer.frame = .init(origin: trackLayerPoint, size: CGSize(width: 0, height: frame.height-2))
        layer.insertSublayer(trackLayer, at: 1)
    }
    
    
    private func updateTracker(_ value:Float){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let thumbRectA = thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
        trackLayer.frame = .init(origin: trackLayerPoint, size: CGSize(width: thumbRectA.midX, height:frame.height-2))
        
        CATransaction.commit()
    }
    
    
    private func createThumbImageView() {
        let thumbView = UIView(frame: .init(x: 0, y: 0, width: frame.height*0.3, height: frame.height))
        thumbView.backgroundColor = .darkGray
        let thumbSnapshot = thumbView.snapshot
        
        setThumbImage(thumbSnapshot, for: .normal)
        setThumbImage(thumbSnapshot, for: .highlighted)
        setThumbImage(thumbSnapshot, for: .application)
        setThumbImage(thumbSnapshot, for: .disabled)
        setThumbImage(thumbSnapshot, for: .focused)
        setThumbImage(thumbSnapshot, for: .reserved)
        setThumbImage(thumbSnapshot, for: .selected)
    }
}

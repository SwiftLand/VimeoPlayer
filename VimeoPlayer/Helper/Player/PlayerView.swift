//
//  PlayerView.swift
//  VimeoPlayer
//
//  Created by Ali on 2/15/23.
//

import Foundation
import UIKit
import AVFoundation
import RxAVFoundation
import RxSwift

class PlayerView: UIControl {
    
    var playerLayer: AVPlayerLayer {
        return self.layer as! AVPlayerLayer
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    let player:AVPlayer = AVPlayer()
    
    private(set) weak var playImage:UIImageView!
    private(set) weak var controllerView:PlayerControllerView!
    private var controllerHeightConstrain:NSLayoutConstraint!
    private var disposeBag = DisposeBag()
    
    
    override init(frame: CGRect) {
        super.init(frame: CGRectZero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        if controllerView != nil{
            controllerView.setNeedsDisplay()
        }
    }
    
    func config(url:URL){
        
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.player = player
        controllerView.config(player)
        
        item.rx.didPlayToEnd.subscribe(onNext: { [weak self] _ in
            self?.reset()
        }).disposed(by: disposeBag)
    }
    
    private func setup(){
        createSupViews()
        setupConstraints()
        bind()
    }
    
    private func bind(){
        
        rx.controlEvent([.touchUpInside])
            .subscribe{[weak self]_ in
                self?.player.togglePlay()
        }.disposed(by: disposeBag)
        
        
        player.rx.timeControlStatus.subscribe(onNext: {
             [weak self] status in
            self?.updatePlayStatus(status)
        }).disposed(by: disposeBag)
        
        controllerView.requireExpanedScreen.subscribe(onNext: {
            [weak self] isExpanded in
            self?.requireChangeSize(isExpanded)
        }).disposed(by: disposeBag)
    }
    private func createSupViews(){
        
        let playImage = UIImageView()
        playImage.image = ImageResources.image(for: .play_icon,color: .gray)
        self.addSubview(playImage)
        self.playImage = playImage
        
        let controllerView = PlayerControllerView()
        controllerView.backgroundColor = .white.withAlphaComponent(0.5)
        addSubview(controllerView)
        self.controllerView = controllerView
    }
    
    
    private func setupConstraints(){
        controllerHeightConstrain = controllerView.heightAnchor.constraint(equalToConstant: 50)
        
        playImage.translatesAutoresizingMaskIntoConstraints = false
        controllerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            playImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            playImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            playImage.widthAnchor.constraint(equalToConstant: 50),
            playImage.heightAnchor.constraint(equalToConstant: 50),
            
            
            controllerView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: 0),
            controllerView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 0),
            controllerView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: 0),
            controllerHeightConstrain
        ])
    }
    
    private func updatePlayStatus(_ status:AVPlayer.TimeControlStatus){
        
        if status == .playing && player.isPlaying {
            playImage.image = ImageResources.image(for: .play_round_icon,color: .gray)
            playImage.fadeOut(duration: 3)
        }
        
        if status == .paused && !player.isPlaying{
            playImage.image = ImageResources.image(for: .pause_icon,color: .gray)
            playImage.fadeOut(duration: 3)
        }
    }
    
    private func reset(){
        player.rx.reset().subscribe().disposed(by: disposeBag)
    }
    
    private func requireChangeSize(_ isExpanded:Bool){
        if isExpanded{
            controllerHeightConstrain.constant = 64
        }else{
            controllerHeightConstrain.constant = 50
        }
        layoutIfNeeded()
    }
}

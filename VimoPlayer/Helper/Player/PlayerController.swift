//
//  PlayerController.swift
//  VimoPlayer
//
//  Created by Ali on 2/15/23.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import AVFoundation
import RxAVFoundation

class PlayerControllerView:UIView{

    let requireExpanedScreen:PublishRelay<Bool> = .init()
    
    private var isExpanded:Bool = false{
        didSet{
            requireExpanedScreen.accept(isExpanded)
        }
    }
    
    private let btnSize:CGFloat = 35
    private let controllerHeight:CGFloat = 50
    private weak var player:AVPlayer!
    
    private weak var containerView:UIView!
    private weak var slider:PlayerSlider!
    private weak var playBtn:UIButton!
    private weak var muteBtn:UIButton!
    private weak var expandBtn:UIButton!
    
    private var leadingContainerViewConstrain:NSLayoutConstraint!
    private var trailingContainerViewConstrain:NSLayoutConstraint!
    
    private var disposeBag = DisposeBag()
    private var isPlayingBeforeSeek:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: CGRectZero)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()

    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        if slider != nil{
            slider.setNeedsDisplay()
        }
    }
    
    
    func config(_ player:AVPlayer){
        self.player = player
        bind()
    }
    
    private func setup(){
        createSubViews()
        setupConstraints()
    }
    
    private func bind(){
        player.rx.currentItem
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] avItem in
                self?.setupProgressObservation(item: avItem)
            }).disposed(by: disposeBag)
        
        slider.status.subscribe(onNext: {[weak self]status in
            self?.sliderDrage(status)
        }).disposed(by: disposeBag)
        
        playBtn.rx.tap.subscribe(onNext: {[weak self] in
            self?.player.togglePlay()
        }).disposed(by: disposeBag)
        
        muteBtn.rx.tap.subscribe(onNext: {[weak self] in
            self?.player.toggleMute()
        }).disposed(by: disposeBag)
        
        expandBtn.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else {return}
            self.isExpanded.toggle()
        }).disposed(by: disposeBag)
        
        player.rx.timeControlStatus.subscribe(onNext: {
            [weak self] status in
            self?.updatePlayStatus(status)
        }).disposed(by: disposeBag)
        
        player.rx.muted
            .subscribe(onNext: {
                [weak self] isMuted in
                self?.updateMuteStateChanged(isMuted)
            }).disposed(by: disposeBag)
        
        requireExpanedScreen.subscribe(onNext: {
            [weak self] isExpanded in
            self?.updateExpandBtn(isExpanded)
            self?.requireChangeSize(isExpanded)
        }).disposed(by: disposeBag)
        
        
    }
    
    private func createSubViews(){
        
        let containerView = UIView()
        containerView.backgroundColor = .clear
        addSubview(containerView)
        self.containerView = containerView
        
        let slider = PlayerSlider()
        slider.maximumValue = 1
        slider.minimumValue = 0
        containerView.addSubview(slider)
        self.slider = slider
        
        let playBtn = UIButton()
        playBtn.setImage(ImageResource.image(for: .play_round_icon), for: .normal)
        playBtn.contentMode = .scaleAspectFit
        containerView.addSubview(playBtn)
        self.playBtn = playBtn
        
        let expandBtn = UIButton()
        expandBtn.setImage(ImageResource.image(for: .expand_icon), for: .normal)
        containerView.addSubview(expandBtn)
        self.expandBtn = expandBtn
        
        let muteBtn = UIButton()
        muteBtn.setImage(ImageResource.image(for: .unMute_icon), for: .normal)
        containerView.addSubview(muteBtn)
        self.muteBtn = muteBtn
        
    }
    
    private func setupConstraints(){
        containerView.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        muteBtn.translatesAutoresizingMaskIntoConstraints = false
        expandBtn.translatesAutoresizingMaskIntoConstraints = false
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        
        
        leadingContainerViewConstrain =  containerView.leadingAnchor.constraint(equalTo: leadingAnchor)
        trailingContainerViewConstrain =  containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        
        NSLayoutConstraint.activate([
            leadingContainerViewConstrain,
            trailingContainerViewConstrain,
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.heightAnchor.constraint(equalToConstant: controllerHeight),

            
            slider.leadingAnchor.constraint(equalTo: playBtn.trailingAnchor,constant: 8),
            slider.centerYAnchor.constraint(equalTo:containerView.centerYAnchor),
            slider.heightAnchor.constraint(equalToConstant: 15),
            
            playBtn.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            playBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            playBtn.widthAnchor.constraint(equalToConstant: btnSize),
            playBtn.heightAnchor.constraint(equalToConstant: btnSize),
            
            muteBtn.leadingAnchor.constraint(equalTo: slider.trailingAnchor,constant: 8),
            muteBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            muteBtn.widthAnchor.constraint(equalToConstant: btnSize),
            muteBtn.heightAnchor.constraint(equalToConstant: btnSize),
            
            expandBtn.leadingAnchor.constraint(equalTo: muteBtn.trailingAnchor),
            expandBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            expandBtn.widthAnchor.constraint(equalToConstant: btnSize),
            expandBtn.heightAnchor.constraint(equalToConstant: btnSize),
            expandBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
        ])
    }
    
    private func sliderDrage(_ status:PlayerSlider.Status){
        switch status{
        case .startDrag:
            isPlayingBeforeSeek = player.isPlaying
            player.pause()
        case .stopDrag:
            seek(to: slider.value)
        }
    }
    
    private func seek(to second:Float){
        
        player.rx.seek(to: second).subscribe(onNext: {[weak self] _ in
            self?.resumePlayerAfterSeek()
        },onError: {[weak self] _ in
            self?.resumePlayerAfterSeek()
        }).disposed(by: disposeBag)
    }
    
    
    private func resumePlayerAfterSeek(){
        if isPlayingBeforeSeek{
            player.play()
        }
    }
    
    private func setupProgressObservation(item: AVPlayerItem?) {
        guard let item = item else {return}
        let interval = CMTime(seconds: 0.05, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.rx.periodicTimeObserver(interval: interval)
            .map { [unowned self] in self.progress(currentTime: $0, duration: item.duration) }
            .bind(to: slider.rx.value)
            .disposed(by: disposeBag)
    }
    
    private func progress(currentTime: CMTime, duration: CMTime) -> Float {
        if !duration.isValid || !currentTime.isValid {
            return 0
        }
        
        let totalSeconds = duration.seconds
        let currentSeconds = currentTime.seconds
        
        if !totalSeconds.isFinite || !currentSeconds.isFinite {
            return 0
        }
        
        return Float(min(currentSeconds/totalSeconds, 1))
    }
    
    private func updateMuteStateChanged(_ isMuted:Bool){
        if isMuted {
            muteBtn.setImage(ImageResource.image(for: .mute_icon), for: .normal)
        }else{
            muteBtn.setImage(ImageResource.image(for: .unMute_icon), for: .normal)
        }
    }
    
    private func updatePlayStatus(_ status:AVPlayer.TimeControlStatus){
        switch status {
        case .playing:
            playBtn.setImage(ImageResource.image(for: .pause_icon), for: .normal)
        case .paused:
            playBtn.setImage(ImageResource.image(for: .play_round_icon), for: .normal)
        default:break
        }
    }
    
    private func updateExpandBtn(_ isExpanded:Bool){
        expandBtn.setImage(ImageResource.image(for:isExpanded ?.collapse_icon : .expand_icon), for: .normal)
    }
    
    private func requireChangeSize(_ isExpanded:Bool){
        if isExpanded{
            leadingContainerViewConstrain.constant = 16
            trailingContainerViewConstrain.constant = -16
        }else{
            leadingContainerViewConstrain.constant = 0
            trailingContainerViewConstrain.constant = 0
        }
        layoutIfNeeded()
    }
}

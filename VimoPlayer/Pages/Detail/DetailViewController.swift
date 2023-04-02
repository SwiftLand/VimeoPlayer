//
//  DetailViewController.swift
//  VimoPlayer
//
//  Created by Ali on 2/14/23.
//

import Foundation
import UIKit
import RxSwift
import AVFoundation
import RxAVFoundation

class DetailViewController:UIViewController{
    
    var viewModel:DetailViewModelProtocol!
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var playerViewParent:UIView!
    @IBOutlet weak var playerView:PlayerView!
    
    @IBOutlet weak var commentView:ImageTextView!
    @IBOutlet weak var likeView:ImageTextView!
    @IBOutlet weak var playCountView:ImageTextView!
    @IBOutlet weak var uploaderImageView:UIImageView!
    @IBOutlet weak var uploaderNameLabel:UILabel!
    @IBOutlet weak var descriptionTextView:UITextView!
    
    private let disposeBag = DisposeBag()
    private var activePlayerViewConstraints:[NSLayoutConstraint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerViewConstraint()
        bind()
        viewModel.loadVideoConfig()
    }
    
    func setupPlayerViewConstraint(){

        activePlayerViewConstraints = [
            playerView.topAnchor.constraint(equalTo: playerViewParent.topAnchor),
            playerView.bottomAnchor.constraint(equalTo: playerViewParent.bottomAnchor),
            playerView.leadingAnchor.constraint(equalTo: playerViewParent.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: playerViewParent.trailingAnchor),
        ]
        NSLayoutConstraint.activate(activePlayerViewConstraints)
    }
    
    func bind(){
        titleLabel.text = viewModel.data.name
        
        commentView.imageView.image = ImageResource.image(for: .comment_icon,color: .darkGray)
        commentView.text = Formatter.formatNumber(viewModel.data.metadata?.connections?.comments?.total ?? 0)
        
        likeView.imageView.image = ImageResource.image(for: .like_icon,color: .darkGray)
        likeView.text = Formatter.formatNumber(viewModel.data.metadata?.connections?.likes?.total ?? 0)
        
        playCountView.imageView.image = ImageResource.image(for: .play_round_icon,color: .darkGray)
        playCountView.text = Formatter.formatNumber(viewModel.data.stats?.plays ?? 0)
        
        if let size = viewModel.data.uploader?.pictures?.getSize(for: uploaderImageView.frame.size),
           let link = size.link,let url = URL(string: link){
            ImageLoaderProxy.load(url: url).bind(to: uploaderImageView.rx.image).disposed(by: disposeBag)
        }
        
        uploaderNameLabel.text = viewModel.data.user?.name ?? StringResource.get(.unkown)
        descriptionTextView.text = viewModel.data.description

        viewModel.videoConfig.subscribe(onNext: {[weak self] config in
            self?.configPlayer(config:config)
        }).disposed(by: disposeBag)
        
        viewModel.status.subscribe(onNext:{
            [weak self] next in
            switch next {
            case .error(let error):
                self?.errorHandler(error)
            default:break
            }
        }).disposed(by: disposeBag)

    }
    
    func errorHandler(_ error:Error){
        popAlert(title: StringResource.get(.error), meesage: StringResource.getMessage(for:error), BtnText: StringResource.get(.retry)){
            [weak self] action in
            self?.viewModel.loadVideoConfig()
        }
    }
    
    func configPlayer(config:VimoVideoConfig){
        
        guard let link = config.request?.files?.progressive.first?.url,let url = URL(string: link) else{
            return
        }
        
        playerView.config(url: url)
        playerView.player.rx.status
            .filter { $0 == .readyToPlay }
            .subscribe(onNext: { [weak self] status in
                self?.playerView.player.play()
            }).disposed(by: disposeBag)
        
        playerView.controllerView.requireExpanedScreen.subscribe(onNext: {
            [weak self] isExpand in
            self?.expand(isExpand)
        }).disposed(by: disposeBag)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
            self.playerView.setNeedsDisplay()
            self.playerView.layoutIfNeeded()
           
        } else {
            self.playerView.setNeedsDisplay()
            self.playerView.layoutIfNeeded()
        }
    }

    func expand(_ isExpand:Bool){
        navigationController?.setNavigationBarHidden(isExpand, animated: true)
        
        NSLayoutConstraint.deactivate(activePlayerViewConstraints)
        if isExpand{
            activePlayerViewConstraints = [
                playerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                playerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ]
            
            if !OrientationManager.shared.isLandscape{
                OrientationManager.shared.set(orientation: .landscape)
            }
            
        }else{
            activePlayerViewConstraints = [
                playerView.topAnchor.constraint(equalTo: playerViewParent.topAnchor),
                playerView.bottomAnchor.constraint(equalTo: playerViewParent.bottomAnchor),
                playerView.leadingAnchor.constraint(equalTo: playerViewParent.leadingAnchor),
                playerView.trailingAnchor.constraint(equalTo: playerViewParent.trailingAnchor),
            ]
            
            if !OrientationManager.shared.isLandscape{
                OrientationManager.shared.set(orientation: .portrait)
            }
            
            
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait)){
                error in
                print(error)
            }
            navigationController?.topViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
        }
        
        NSLayoutConstraint.activate(activePlayerViewConstraints)

        self.playerView.setNeedsDisplay()

        UIView.animate(withDuration: 0.2) {
            self.playerView.layoutIfNeeded()
        }
    }
}

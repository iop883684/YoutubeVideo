//
//  BMPlayerCustomControlView.swift
//  BMPlayer
//
//  Created by BrikerMan on 2017/4/4.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import BMPlayer

protocol BMPlayerCustomControlViewDelegate: NSObjectProtocol {
    func didTapMoreBtn()
}

class BMPlayerCustomControlView: BMPlayerControlView {
    
    weak var delega: BMPlayerCustomControlViewDelegate?
    
    var playbackRateButton = UIButton(type: .custom)
    
    var moreBtn = UIButton(type: .custom)

    /**
     Override if need to customize UI components
     */
    override func customizeUIComponents() {
        
        mainMaskView.backgroundColor   = UIColor.clear
        topMaskView.backgroundColor    = UIColor.black.withAlphaComponent(0.4)
        bottomMaskView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        timeSlider.setThumbImage(UIImage(named: "custom_slider_thumb"), for: .normal)
        
        topMaskView.addSubview(playbackRateButton)
        
        playbackRateButton.setTitleColor(UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9 ), for: .normal)
        playbackRateButton.setImage(#imageLiteral(resourceName: "ic_more_vert_white_48pt"), for: .normal)
        playbackRateButton.addTarget(self, action: #selector(onPlaybackRateButtonPressed), for: .touchUpInside)
        playbackRateButton.titleLabel?.font   = UIFont.systemFont(ofSize: 12)
        playbackRateButton.snp.makeConstraints {
            $0.right.equalTo(chooseDefitionView.snp.left).offset(-5)
            $0.centerY.equalTo(chooseDefitionView).offset(-5)
        }
        
    }
    
    override func updateUI(_ isForFullScreen: Bool) {
        super.updateUI(isForFullScreen)
        chooseDefitionView.isHidden = false
        if let layer = player?.playerLayer {
            layer.frame = player!.bounds
        }
    }
    
    override func controlViewAnimation(isShow: Bool) {
        self.isMaskShowing = isShow
        UIView.animate(withDuration: 0.24, animations: {
            self.topMaskView.snp.remakeConstraints {
                $0.top.equalTo(self.mainMaskView).offset(isShow ? 0 : -70)
                $0.left.right.equalTo(self.mainMaskView)
                $0.height.equalTo(65)
            }
            
            self.layoutIfNeeded()
        }) { (_) in
            self.autoFadeOutControlViewWithAnimation()
        }
    }
    
    @objc func onPlaybackRateButtonPressed() {
        
        delega?.didTapMoreBtn()
        
    }
    
    
}

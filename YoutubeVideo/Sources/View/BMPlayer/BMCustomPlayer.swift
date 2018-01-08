//
//  BMCustomPlayer.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/8/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import BMPlayer

class BMCustomPlayer: BMPlayer {
    class override func storyBoardCustomControl() -> BMPlayerControlView? {
        return BMPlayerCustomControlView()
    }
}

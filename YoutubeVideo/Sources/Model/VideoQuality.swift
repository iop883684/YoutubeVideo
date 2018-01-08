//
//  YoutubeVideoQuality.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/5/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import Foundation
import XCDYouTubeKit

struct VideoQuality {
    static let hd720 = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
    static let medium360 = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
    static let small240 = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
}

struct UrlVideo {
    static var hd: URL!
    static var medium: URL!
}

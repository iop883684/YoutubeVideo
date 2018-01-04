//
//  PlayList.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 12/27/17.
//  Copyright © 2017 Lac Tuan. All rights reserved.
//

import Foundation
import ObjectMapper

class PlayList: Mappable {
    
    var id = ""
    var title = ""
    var thumbnails = ""
    var channelId = ""
    var channelTitle = ""
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        title <- map["snippet.title"]
        id <- map["id"]
        channelId <- map["snippet.channelId"]
        thumbnails <- map["snippet.thumbnails.medium.url"]
        channelTitle <- map["snippet.channelTitle"]
    }
}

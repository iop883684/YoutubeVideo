//
//  Video.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/3/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import Foundation
import ObjectMapper

class Video: Mappable{
    
    var id = ""
    var title = ""
    var thumbnails = ""
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        title <- map["snippet.title"]
        id <- map["id"]
        thumbnails <- map["snippet.thumbnails.medium.url"]
        
    }
    
}

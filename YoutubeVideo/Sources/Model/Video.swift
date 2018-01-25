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
    var thumbHigh:String?
    
    var channelTitle = ""
    var nextPageToken = ""
    var channelId = ""
    var videoId = ""
    var regionCode = ""
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        title <- map["snippet.title"]
        id <- map["id"]
        thumbnails <- map["snippet.thumbnails.medium.url"]
        thumbHigh <- map["snippet.thumbnails.high.url"]
        
        channelTitle <- map["snippet.channelTitle"]
        nextPageToken <- map["nextPageToken"]
        
        channelId <- map["snippet.channelId"]
        videoId <- map["contentDetails.videoId"]
        if videoId.isEmpty {
            videoId <- map["contentDetails.upload.videoId"]
            if videoId.isEmpty{
                videoId <- map["id.videoId"]
            }
        }
        regionCode <- map["regionCode"]
    }
    
}

class ResponseVideo: Mappable {
    
    var nextPageToken: String?
    var items:[Video]?
    var totalResults: Int?
    var regionCode: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        regionCode <- map["regionCode"]
        nextPageToken <- map["nextPageToken"]
        items <- map["items"]
        totalResults <- map["pageInfo.totalResults"]
    }
    
}

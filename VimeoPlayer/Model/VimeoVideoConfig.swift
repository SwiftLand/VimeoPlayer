//
//  VimeoVideoConfig.swift
//  VimeoPlayer
//
//  Created by Ali on 2/15/23.
//

import Foundation

// MARK: - VideoConfig
struct VimeoVideoConfig: Codable {
    let request: Request?
    
    // MARK: - Request
    struct Request: Codable {
        let files: Files?
    }

    // MARK: - Files
    struct Files: Codable {
        let progressive: [Progressive]
    }

    // MARK: - Progressive
    struct Progressive: Codable {
        let width: Int?
        let mime: String?
        let fps: Double?
        let url: String?
        let cdn, quality, origin: String?
        let height: Int?
    }
}

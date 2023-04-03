//
//  VimeoResponse.swift
//  VimeoPlayer
//
//  Created by Ali on 2/14/23.
//

import Foundation

// MARK: - VimeoResponse
struct VimeoResponse: Codable,Equatable {
    let total, page, perPage: Int
    let paging: Paging
    let data: [Data]
    
    enum CodingKeys: String, CodingKey {
        case total, page
        case perPage = "per_page"
        case paging, data
    }
    
    // MARK: - Data
    struct Data: Codable,Equatable,Hashable,Identifiable {
        var id:String {uri.lastPathComponent}
        let uri:String
        let name: String?
        let description: String?
        let duration, width: Int?
        let language: String?
        let height: Int?
        let pictures: Pictures?
        let stats: Stats?
        let uploader: Uploader?
        let metadata: Metadata?
        let user: User?
    }

    // MARK: - Metadata
    struct Metadata: Codable,Equatable,Hashable {
        let connections: PurpleConnections?

    }

    // MARK: - PurpleConnections
    struct PurpleConnections: Codable,Equatable,Hashable {
        let comments, credits, likes, pictures: ConnectionData?
    }

    // MARK: - ConnectionData
    struct ConnectionData: Codable,Equatable,Hashable {
        let uri: String?
        let options: [String]
        let total: Int?
    }

    // MARK: - Pictures
    struct Pictures: Codable,Equatable,Hashable {
        let uri: String?
        let active: Bool?
        let type: String?
        let baseLink: String?
        let sizes: [Size]
        let resourceKey: String?
        let defaultPicture: Bool?
        
        enum CodingKeys: String, CodingKey {
            case uri, active, type
            case baseLink = "base_link"
            case sizes
            case resourceKey = "resource_key"
            case defaultPicture = "default_picture"
        }
        
        func getSize(for size:CGSize)->Size?{
            return sizes.first(where: {$0.width >= Int(size.width) && $0.height >= Int(size.height)}) ?? sizes.last
        }
        
    }

    // MARK: - Size
    struct Size: Codable,Equatable,Hashable {
        let width, height: Int
        let link: String?
        let linkWithPlayButton: String?
        
        enum CodingKeys: String, CodingKey {
            case width, height, link
            case linkWithPlayButton = "link_with_play_button"
        }
    }

    // MARK: - Stats
    struct Stats: Codable,Equatable,Hashable {
        let plays: Int?
    }

    // MARK: - Uploader
    struct Uploader: Codable,Equatable,Hashable {
        let pictures: Pictures?
    }

    // MARK: - User
    struct User: Codable,Equatable,Hashable {
        let uri, name: String?
        let pictures: Pictures?
        let resourceKey: String?
        let account: String?
    }

    // MARK: - Paging
    struct Paging: Codable,Equatable,Hashable {
        let next: String?
        let previous: String?
        let first, last: String?
    }

}

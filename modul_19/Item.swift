//
//  Item.swift
//  modul_19
//
//  Created by Admin on 22/05/24.
//

import Foundation

struct Item: Codable {
    var id: Int?
    var title: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
    }
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }
    
}

//
//  ImageModel.swift
//  Assignment
//
//  Created by Ravi Singh on 15/09/23.
//

import Foundation
import UIKit

struct ImageData: Codable {
    let id: Int?
    let pageURL: String?
    let tags: String?
    let previewURL: String?
}

struct OfflineImage {
    
    let id: Int?
    let image: UIImage?
}

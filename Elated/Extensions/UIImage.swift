//
//  UIImage.swift
//  Elated
//
//  Created by Marlon on 2021/3/16.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

extension UIImage {
    
    func compressToData() -> Data {
        //Get the best quality out of the resizing
        let limit = 2000000
        var imageData = self.jpegData(compressionQuality: 0.9) ?? Data()
        var hasValidSize = imageData.count < limit
        var compressor = 0.9
        while !hasValidSize {
            if hasValidSize {
                break
            } else {
                compressor -= 0.1
                imageData = self.jpegData(compressionQuality: CGFloat(compressor)) ?? Data()
                hasValidSize = imageData.count < limit
            }
        }
        return imageData
    }
    
}

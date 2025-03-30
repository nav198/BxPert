//
//  ImageViewModel.swift
//  Bxpert
//
//  Created by Naveen on 30/03/25.
//

import Foundation
import UIKit

class ImageViewModel {
    
    private var images: [ImageModel] = []
    var onImagesUpdated: (() -> Void)?

    func addImage(_ image: UIImage) {
        images.append(ImageModel(image: image))
        onImagesUpdated?()  
    }

    func getImagesCount() -> Int {
        return images.count
    }

    func getImage(at index: Int) -> UIImage {
        return images[index].image
    }
}

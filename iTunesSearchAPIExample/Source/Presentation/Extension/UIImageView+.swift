//
//  UIImageView+.swift
//  iTunesSearchAPIExample
//
//  Created by JunHwan Kim on 2023/11/08.
//

import Foundation
import UIKit

extension UIImageView {
    func setImageFromImagePath(imagePath: String) {
        guard let url = URL(string: imagePath) else { return }
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10.0
        let session = URLSession(configuration: sessionConfig)
        session.dataTask(with: .init(url: url)) { data, response, error in
            let fetchImage: UIImage?
            if let _ = error {
                fetchImage = UIImage(systemName: "xmark")
            } else {
                guard let data else { return }
                fetchImage = UIImage(data: data)
            }
            DispatchQueue.main.async {
                self.image = fetchImage
            }
        }.resume()
    }
}

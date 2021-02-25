//
//  Image.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 25.02.2021.
//

import UIKit

extension UIImage {

    func resize(toWidth width: CGFloat) -> UIImage? {
        let scale = width / size.width
        let newHeight = size.height * scale

        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: newHeight), false, UIScreen.main.scale)
        draw(in: CGRect(x: 0, y: 0, width: width, height: newHeight))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }

}

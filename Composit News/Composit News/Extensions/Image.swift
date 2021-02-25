//
//  Image.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 25.02.2021.
//

import UIKit

extension UIImage {

    func resize(toHeight height: CGFloat) -> UIImage? {
        let scale = height / size.height
        let newWidth = size.width * scale

        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: height), false, UIScreen.main.scale)
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }

}

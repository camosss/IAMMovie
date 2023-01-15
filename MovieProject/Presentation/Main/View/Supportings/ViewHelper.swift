//
//  ViewHelper.swift
//  MovieProject
//
//  Created by 강호성 on 2022/05/01.
//

import UIKit

final class ViewHelper {
    static func handleImageData(imageView: UIImageView, data: String) {
        if data == "" {
            imageView.image = UIImage(named: "no_image")
        } else {
            imageView.setImage(with: data)
        }
    }

    static func handleEmptyData(label: UILabel, title: String, data: String) {
        if data == "" {
            label.text = "\(title): 정보 없음"
        } else {
            label.text = "\(title): \(data)"
        }
    }

    static func handleRatingData(label: UILabel, data: String) {
        if data == "0.00" {
            label.text = "평점: 평점 없음"
        } else {
            label.text = "평점: \(data)"
        }
    }
}

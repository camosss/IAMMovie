//
//  UIFont+Ex.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import UIKit.UIFont

extension UIFont {
    static var largeTitle: UIFont {
        return UIFont.boldSystemFont(ofSize: 33)
    }
    static var title1: UIFont {
        return UIFont.boldSystemFont(ofSize: 27)
    }
    static var title2: UIFont {
        return UIFont.boldSystemFont(ofSize: 21)
    }
    static var title3: UIFont {
        return UIFont.boldSystemFont(ofSize: 19)
    }
    static var headline: UIFont {
        return UIFont.boldSystemFont(ofSize: 17)
    }
    static var body: UIFont {
        return UIFont.systemFont(ofSize: 16)
    }
    static var callout: UIFont {
        return UIFont.systemFont(ofSize: 15)
    }
    static var subHead: UIFont {
        return UIFont.systemFont(ofSize: 14)
    }
    static var footNote: UIFont {
        return UIFont.systemFont(ofSize: 12)
    }
    static var caption: UIFont {
        return UIFont.systemFont(ofSize: 11)
    }
}


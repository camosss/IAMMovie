//
//  String+Ex.swift
//  MovieProject
//
//  Created by 강호성 on 2022/05/01.
//

import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    func localization() -> String {
        var language = UserDefaults.standard.array(forKey: "language")?.first as? String
        if language == nil {
            let str = String(NSLocale.preferredLanguages[0])
            language = String(str.dropLast(3))
        }
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }

    func replacing(data: String) -> String {
        return self.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
    }

    func trimmingAndReplacing(data: String) -> String {
        return self.trimmingCharacters(in: ["|"]).replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
    }
}

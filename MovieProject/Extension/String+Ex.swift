//
//  String+Ex.swift
//  MovieProject
//
//  Created by 강호성 on 2022/05/01.
//

import UIKit

extension String {
    func replacing(data: String) -> String {
        return self.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
    }

    func trimmingAndReplacing(data: String) -> String {
        return self.trimmingCharacters(in: ["|"]).replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
    }
}

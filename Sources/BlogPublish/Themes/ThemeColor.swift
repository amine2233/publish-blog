//
//  File.swift
//  
//
//  Created by Amine Bensalah on 10/10/2021.
//

import Foundation

struct ThemeColor {
    let primaryColor: String

    init(primaryColor: String = "#f17c37") {
        self.primaryColor = primaryColor
    }

    static let light = ThemeColor()
    static let dark = ThemeColor(primaryColor: "#a04f1c")
}

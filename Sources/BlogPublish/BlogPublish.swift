//
//  File.swift
//  
//
//  Created by Amine Bensalah on 09/10/2021.
//

import Foundation
import Publish
import Plot

enum Constants {
    static let website = "aminebensalah.com"
    static let websiteUrl = "https://" + website
}

// This type acts as the configuration for your website.
struct BlogPublish: Website {
    enum SectionID: String, WebsiteSectionID {
        // associate rawValue with class on css
        // Add the sections that you want your website to contain here:
        case posts
        case tips
        case resume
        case about
    }

    struct ItemMetadata: WebsiteItemMetadata {
        struct ResumeMetaData: WebsiteItemMetadata {
            let date: Date
            let organization: String
        }

        struct PictureMetaData: WebsiteItemMetadata {
            let icon: String
        }

        var resume: ResumeMetaData?
        var picture: PictureMetaData?
        var published: Bool = false
        var isDateHidden: Bool = false

        enum CodingKeys: String, CodingKey {
            case resume
            case picture
            case published
        }
    }

    // Update these properties to configure your website:
    var url = URL(string: Constants.websiteUrl)!
    var name = "Amine Bensalah"
    var description = "Personal website"
    var language: Language { .english }
    var imagePath: Path? { nil }
}

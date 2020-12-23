import Foundation
import Publish
import Plot
import SplashPublishPlugin

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
            let name: String
            let date: Date
            let organization: String
        }

        struct PictureMetaData: WebsiteItemMetadata {
            let icon: String
        }

        var resume: ResumeMetaData?
        var picture: PictureMetaData?
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://aminebensalah.com")!
    var name = "Amine Bensalah"
    var description = "Personal website"
    var language: Language { .english }
    var imagePath: Path? { nil }
}

// This will generate your website using the built-in Foundation theme:
try BlogPublish().publish(using: [
    .copyResources(),
    .installPlugin(.splash(withClassPrefix: "")),
    .installPlugin(.ensureAllItemsAreTagged),
    .addMarkdownFiles(),
    .addDefaultSectionTitles(),
    .sortItems(by: \.date, order: .descending),
    .generateHTML(withTheme: .basic),
    .unwrap(RSSFeedConfiguration.default, { config in
        .generateRSSFeed(including: [.posts, .tips], config: config)
    }),
    .createCNAME(website: "aminebensalah.fr"),
    .generateSiteMap()
])

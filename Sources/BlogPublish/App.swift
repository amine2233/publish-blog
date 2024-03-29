import Foundation
import Publish
import Plot
import SplashPublishPlugin

public struct App {
    /// Create the application
    public init() {}

    public func run() throws {
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
                let matcher = { (item: Item<BlogPublish>) -> Bool in
                    item.metadata.published
                }
                let predicate = Predicate<Item<BlogPublish>>(matcher: matcher)
                return .generateRSSFeed(including: [.posts, .tips],
                                        itemPredicate: predicate,
                                        config: config,
                                        date: Date())
            }),
            .createCNAME(website: Constants.website),
            .generateSiteMap()
        ])
    }
}



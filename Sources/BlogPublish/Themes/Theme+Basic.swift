import Plot
import Publish

extension Theme where Site == BlogPublish {
    /// The default "Foundation" theme that Publish ships with, a very
    /// basic theme mostly implemented for demonstration purposes.
    static var basic: Self {
        Theme(
            htmlFactory: BasicHTMLFactory(),
            resourcePaths: ["/Resources/BasicTheme/styles.css"]
        )
    }
}

private struct BasicHTMLFactory: HTMLFactory {
    func makeIndexHTML(for index: Index,
                       context: PublishingContext<BlogPublish>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .h1(.text(index.title)),
                    .p(
                        .class("description"),
                        .text(index.description)
                    ),
                    .div(
                        .h2("Latest content", .class("latest")),
                        .class("section-header float-container")
                    ),
                    .itemList(
                        for: context.allItems(
                            sortedBy: \.date,
                            order: .descending
                        ).filter { $0.sectionID != .resume },
                        on: context.site
                    )
                ),
                .footer(for: context.site)
            )
        )
    }

    // Use this to render of index of section (articles, tips, about, resume)
    func makeSectionHTML(for section: Section<BlogPublish>,
                         context: PublishingContext<BlogPublish>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .body(
                .header(for: context, selectedSection: section.id),
                .wrapper(
                    .div(
                        .h2(.text(section.title), .class("\(section.id.rawValue)")),
                        .class("section-header float-container")
                    ),
                    .contentBody(section.body),
                    .itemList(for: section.items, on: context.site)
                ),
                .footer(for: context.site)
            )
        )
    }

    func makeItemHTML(for item: Item<BlogPublish>,
                      context: PublishingContext<BlogPublish>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .body(
                .class("item-page"),
                .header(for: context, selectedSection: item.sectionID),
                .wrapper(
                    .article(
                        .div(
                            .class("content"),
                            .if(item.metadata.resume.isSome,
                                .p("\(item.metadata.resume?.name ?? "")")
                            ),
                            .contentBody(item.body)
                        ),
                        .span("Tagged with: "),
                        .tagList(for: item, on: context.site)
                    )
                ),
                .footer(for: context.site)
            )
        )
    }

    func makePageHTML(for page: Page,
                      context: PublishingContext<BlogPublish>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(.contentBody(page.body)),
                .footer(for: context.site)
            )
        )
    }

    func makeTagListHTML(for page: TagListPage,
                         context: PublishingContext<BlogPublish>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .h1("Browse all tags"),
                    .ul(
                        .class("all-tags"),
                        .forEach(page.tags.sorted()) { tag in
                            .li(
                                .class("tag"),
                                .a(
                                    .href(context.site.path(for: tag)),
                                    .text(tag.string)
                                )
                            )
                        }
                    )
                ),
                .footer(for: context.site)
            )
        )
    }

    func makeTagDetailsHTML(for page: TagDetailsPage,
                            context: PublishingContext<BlogPublish>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .h1(
                        "Tagged with ",
                        .span(.class("tag"), .text(page.tag.string))
                    ),
                    .a(
                        .class("browse-all"),
                        .text("Browse all tags"),
                        .href(context.site.tagListPath)
                    ),
                    .itemList(
                        for: context.items(
                            taggedWith: page.tag,
                            sortedBy: \.date,
                            order: .descending
                        ),
                        on: context.site
                    )
                ),
                .footer(for: context.site)
            )
        )
    }
}

private extension Node where Context == HTML.BodyContext {
    static func wrapper(_ nodes: Node...) -> Node {
        .div(.class("wrapper"), .group(nodes))
    }

    static func header<T: Website>(
        for context: PublishingContext<T>,
        selectedSection: T.SectionID?
    ) -> Node {
        let sectionIDs = T.SectionID.allCases

        return .header(
            .wrapper(
                .a(.class("site-name"), .href("/"), .text(context.site.name)),
                .if(sectionIDs.count > 1,
                    .nav(
                        .ul(.forEach(sectionIDs) { section in
                            .li(.a(
                                .class(section == selectedSection ? "selected" : ""),
                                .href(context.sections[section].path),
                                .text(context.sections[section].title)
                            ))
                        })
                    )
                )
            )
        )
    }

    static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node where T.ItemMetadata == BlogPublish.ItemMetadata {
        return .ul(
            .class("item-list"),
            .forEach(items.filter { $0.metadata.isEnabled }) { item in
                .li(.article(
                    .span(
                        .h1(.a(.href(item.path),.text(item.title))),
                        .span(
                            .text(item.date.asText)
                        )
                    ),
                    .tagList(for: item, on: site),
                    .p(.text(item.description))
                ))
            }
        )
    }

    static func tagList<T: Website>(for item: Item<T>, on site: T) -> Node {
        return .ul(.class("tag-list"), .forEach(item.tags) { tag in
            .li(.a(
                .href(site.path(for: tag)),
                .text(tag.string)
            ))
        })
    }

    static func footer<T: Website>(for site: T) -> Node {
        return .footer(
            .p(
                .text("Generated using "),
                .a(
                    .text("Publish"),
                    .href("https://github.com/johnsundell/publish")
                )
            ),
            .p( 
                .a(
                    .text("RSS feed"),
                    .href("/feed.rss")
                ),
                .text(" | "),
                .a(
                    .text("Twitter"),
                    .href("https://twitter.com/@amine2233")
                ),
                .text(" | "),
                .a(
                    .text("GitHub"),
                    .href("https://github.com/amine2233")
                ),
                .text(" | "),
                .a(
                    .text("LinkedIn"),
                    .href("https://www.linkedin.com/in/amine-bensalah-intech-consulting/")
                )
            )
        )
    }
}

//extension BasicHTMLFactory where Site == BlogPublish {
//    func makeItemHTML(for item: Item<Site>,
//                      context: PublishingContext<Site>) throws -> HTML {
//        HTML(
//            .lang(context.site.language),
//            .head(for: item, on: context.site),
//            .body(
//                .class("item-page"),
//                .header(for: context, selectedSection: item.sectionID),
//                .wrapper(
//                    .article(
//                        .div(
//                            .class("content"),
//                            .contentBody(item.body)
//                        ),
//                        .span("Tagged with: "),
//                        .tagList(for: item, on: context.site)
//                    )
//                ),
//                .footer(for: context.site)
//            )
//        )
//    }
//}

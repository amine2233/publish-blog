import Publish

extension PublishingStep where Site == BlogPublish {
    static func addDefaultSectionTitles() -> Self {
        .step(named: "Default section articles") { context in
            context.mutateAllSections { section in
                guard section.title.isEmpty else { return }

                switch section.id {
                case .posts:
                    section.title = "Articles"
                case .resume:
                    section.title = "Resume"
                case .about:
                    section.title = "About"
                case .tips:
                    section.title = "Tips"
                }
            }
        }
    }
}

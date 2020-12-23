import Publish

extension PublishingStep {
    /// Sort all items, optionally within a specific section, using a key path.
    /// - parameter section: Any specific section to sort all items within.
    /// - parameter keyPath: The key path to use when sorting.
    /// - parameter order: The order to use when sorting.
    static func sortItems<T: Comparable>(
        in section: Site.SectionID? = nil,
        by keyPath: KeyPath<Item<Site>, T>,
        filter: @escaping (Site.SectionID) -> Bool,
        order: SortOrder = .ascending
    ) -> Self {
        let nameSuffix = section.map { " in '\($0)'" } ?? ""

        return step(named: "Sort items with filter" + nameSuffix) { context in
            let sorter = order.makeSorter(forKeyPath: keyPath)

            if let section = section {
                context.sections[section].sortItems(by: sorter)
            } else {
                for section in context.sections.filter({ filter($0.id) }) {
                    context.sections[section.id].sortItems(by: sorter)
                }
            }
        }
    }
}

extension SortOrder {
    func makeSorter<T, V: Comparable>(
        forKeyPath keyPath: KeyPath<T, V>
    ) -> (T, T) -> Bool {
        switch self {
        case .ascending:
            return {
                $0[keyPath: keyPath] < $1[keyPath: keyPath]
            }
        case .descending:
            return {
                $0[keyPath: keyPath] > $1[keyPath: keyPath]
            }
        }
    }
}

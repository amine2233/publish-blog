import Publish
import Files

extension PublishingStep where Site == BlogPublish {
    static func createCNAME(website: String) -> Self {
        .step(named: "Create CNAME file") { context in
            let file = try context.createOutputFile(at: "CNAME")
            try file.write(website)
        }
    }
}

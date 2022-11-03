import UIKit

class Transformer: NSSecureUnarchiveFromDataTransformer {
    override static var allowedTopLevelClasses: [AnyClass] {
        [UIColor.self]
    }

    static func register() {
        let className = String(describing: Transformer.self)
        let name = NSValueTransformerName(className)

        let transformer = Transformer()
        ValueTransformer.setValueTransformer(
            transformer, forName: name)
    }
}

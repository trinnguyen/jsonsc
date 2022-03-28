import Foundation

/**
 Model for generator
 */
struct GenModule {
    let classes: [GenClass]
}

struct GenClass {
    let name: String
    let props: [GenProp]
}

struct GenProp {
    let name: String
    let type: GenType
}

enum GenType {
    case int
    case bool
    case string
    case float
    case double
    case refClass(_ className: String)
}
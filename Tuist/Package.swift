// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [:]
    )
#endif

let package = Package(
    name: "lumi",
    dependencies: [
        // Add your own dependencies here:
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.10.2"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "8.0.0"),
        .package(url: "https://github.com/rive-app/rive-ios", from: "6.11.4"),
        // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
    ]
)

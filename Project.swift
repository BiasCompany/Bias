import ProjectDescription

// Get COMPANY_ID from environment variable, fallback to "app.adit" if not set
let companyId = Environment.companyId.getString(default: "ada.il")
let teamId = Environment.teamId.getString(default: "32T8HNVYGX")
let appName = "Lumi"
let appBundleId = "lumi"

let project = Project(
    name: appName,
    targets: [
        .target(
            name: appBundleId,
            destinations: .iOS,
            product: .app,
            bundleId: "\(companyId).\(appBundleId)",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "CFBundleDisplayName": "\(appName)",
                    "CFBundleShortVersionString": "1.0.0",
                    "CFBundleVersion": "1",
                    "UISupportedInterfaceOrientations": [
                        "UIInterfaceOrientationPortrait"
                    ],
                    "NSCameraUsageDescription": "We need access to your camera to capture your photo. This will allow the app to analyze your skin tone and suggest the right foundation shade. Your photo is only used for analysis and won’t be stored or shared",
                    "UISupportedInterfaceOrientations~ipad": [
                        "UIInterfaceOrientationPortrait",
                        "UIInterfaceOrientationPortraitUpsideDown",
                        "UIInterfaceOrientationLandscapeLeft",
                        "UIInterfaceOrientationLandscapeRight",
                    ],
                    "NSCameraUsageDescription": "Camera is used to analyze your skin tone.",
                    "ITSAppUsesNonExemptEncryption": false,
                ]
            ),
            sources: ["lumi/Sources/**"],
            resources: ["lumi/Resources/**"],
            dependencies: [
                .external(name: "Alamofire"),
                .external(name: "Kingfisher"),
                .external(name: "RiveRuntime"),
            ],
            settings: .settings(
                configurations: [
                    .debug(
                        name: "Debug",
                        settings: [
                            "CODE_SIGN_IDENTITY": .string("Apple Development"),
                            "CODE_SIGN_STYLE": .string("Automatic"),
                            "DEVELOPMENT_TEAM": .string(teamId),
                            "IPHONEOS_DEPLOYMENT_TARGET": .string("17.0"),
                        ]
                    ),
                    .release(
                        name: "Release",
                        settings: [
                            "CODE_SIGN_IDENTITY": .string("Apple Development"),
                            "CODE_SIGN_STYLE": .string("Automatic"),
                            "DEVELOPMENT_TEAM": .string(teamId),
                            "IPHONEOS_DEPLOYMENT_TARGET": .string("17.0"),
                        ]
                    ),
                ]
            )
        )
    ]
)

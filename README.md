# SettingsKit
A simple settings package. There are two types of settings. A generic `Setting` and a `SecureSetting`.
Declaring them is super simple.

```swift
struct SettingsManager {
    static let shared = SettingsManager()

    @Setting("action_key", defaultValue: false)
    var enableAction: Bool

    @Setting("optional_key", defaultValue: nil)
    var username: String?

    @SecureSetting("keychain_key", defaultValue: "Insecure String")
    var secureString: String
}
```

Then accessing or updating the values is as simple as
```swift
let value = SettingsManager.shared.enableAction
```
or
```swift
SettingsManager.shared.enableAction = true
```

When using anything that is an optional, setting it to `nil` will remove it from UserDefaults.

Alternatively we also support `@ComplexSetting` which allows you to save JSON to UserDefaults. Simply define a codeable Struct
```swift
struct SomeStruct: Codable {
	let myString: String
	let myInt: Int?
}

@ComplexSetting("complex")
val complexSetting: SomeStruct?
```

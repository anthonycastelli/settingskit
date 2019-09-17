# SettingsKit

A simple settings package. There are two types of settings. A generic `Setting` and a `SecureSetting`. 
Declaring them is super simple. 

```swift
struct SettingsManager {
    static let shared = SettingsManager()

    @Setting("action_key", defaultValue: false)
    var enableAction: Bool
    
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

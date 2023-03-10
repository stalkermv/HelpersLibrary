//
//  Created by Valeriy Malishevskyi on 05.08.2022.
//

#if canImport(UIKit)
import UIKit

public func obtainKeyWindow() -> UIWindow? {
    let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
    
    for scene in scenes {
        if let keyWindow = scene.windows.first(where: { $0.isKeyWindow }) {
            return keyWindow
        }
    }
    
    return nil
}

public func hideKeyboard() {
    obtainKeyWindow()?.endEditing(true)
}

public func actionWithHideKeyboard(_ action: @escaping () -> Void) -> () -> Void {
    return {
        action()
        hideKeyboard()
    }
}
#endif

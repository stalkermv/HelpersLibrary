//
//  Created by Valeriy Malishevskyi on 05.08.2022.
//

#if canImport(UIKit)
import UIKit

public extension UIApplication {
    var currentKeyWindow: UIWindow? {
        windows.first { $0.isKeyWindow }
    }
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

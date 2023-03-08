//
//  Created by Valeriy Malishevskyi on 05.08.2022.
//

import SwiftUI

public extension DispatchQueue {
    func asyncWithAnimation(_ animation: Animation = .default, _ block: @escaping () -> Void) {
        self.async {
            withAnimation(animation) {
                block()
            }
        }
    }
}

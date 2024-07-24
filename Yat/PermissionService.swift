//
//  PermissionService.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/23.
//

import Foundation
import SwiftUI


@Observable
final class PermissionsService {
    // Store the active trust state of the app.
    var isTrusted: Bool = AXIsProcessTrusted()

    // Poll the accessibility state every 1 second to check
    //  and update the trust status.
    func pollAccessibilityPrivileges() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isTrusted = AXIsProcessTrusted()

            if !self.isTrusted {
                self.pollAccessibilityPrivileges()
            }
        }
    }

    // Request accessibility permissions, this should prompt
    //  macOS to open and present the required dialogue open
    //  to the correct page for the user to just hit the add
    //  button.
    static func acquireAccessibilityPrivileges() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
        let enabled = AXIsProcessTrustedWithOptions(options)
    }
}

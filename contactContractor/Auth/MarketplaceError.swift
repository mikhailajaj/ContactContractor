//
//  MarketplaceError.swift
//  contactContractor
//
//  Created by Mikha2il 3ajaj on 2024-03-29.
//

import Amplify
import Foundation
enum MarketplaceError: Error {
    case amplify(AmplifyError)
}

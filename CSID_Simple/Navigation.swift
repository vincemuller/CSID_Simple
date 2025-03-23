//
//  Navigation.swift
//  CSID_Simple
//
//  Created by Vince Muller on 3/23/25.
//

import Foundation
import SwiftUI

class Navigation: ObservableObject {
    
    @Published var path = NavigationPath()
    
    init(){}
}

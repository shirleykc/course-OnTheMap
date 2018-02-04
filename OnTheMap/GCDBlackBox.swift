//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Shirley on 1/1/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

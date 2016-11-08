//
//  ArekEvent.swift
//  Arek
//
//  Created by Ennio Masi on 30/10/2016.
//  Copyright © 2016 ennioma. All rights reserved.
//

import Foundation
import EventKit

class ArekEvent: ArekBaseEvent {
    override init() {
        super.init()
        
        self.identifier = "ArekEvent"
    }
    
    required init(configuration: ArekConfiguration, initialPopupData: ArekPopupData?, reEnablePopupData: ArekPopupData?) {
        super.init(configuration: configuration, initialPopupData: initialPopupData, reEnablePopupData: reEnablePopupData)
    }

    override func status(completion: @escaping ArekPermissionResponse) {
        switch EKEventStore.authorizationStatus(for: EKEntityType.event) {
        case .notDetermined:
            return completion(.NotDetermined)
        case .denied, .restricted:
            return completion(.Denied)
        case .authorized:
            return completion(.Authorized)
        }
    }
    
    override func askForPermission(completion: @escaping ArekPermissionResponse) {
        EKEventStore().requestAccess(to: .event) { (granted, error) in
            if granted {
                return completion(.Authorized)
            }
            
            if let _ = error {
                return completion(.NotDetermined)
            }
            
            return completion(.Denied)
        }
    }
}

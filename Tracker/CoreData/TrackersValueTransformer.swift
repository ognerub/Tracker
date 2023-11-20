//
//  TrackersValueTransformer.swift
//  Tracker
//
//  Created by Admin on 11/11/23.
//

import Foundation

@objc
final class TrackersValueTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        NSData.self
    }
    override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let trackers = value as? [Tracker] else { return nil}
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: trackers, requiringSecureCoding: true)
            return data
        } catch {
            assertionFailure("Failed to transform 'Trackers' to 'Data'")
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        do {
            let trackers = try NSKeyedUnarchiver.unarchivedObject(ofClass: [Tracker].self, from: data as Data)
            return trackers
        } catch {
            assertionFailure("Failed to transform 'Data' to 'Trackers'")
            return nil
        }
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(
            TrackersValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: TrackersValueTransformer.self)))
    }
}


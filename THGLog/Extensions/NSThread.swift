//
//  NSThread.swift
//  THGLog
//
//  Created by Brandon Sneed on 3/17/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation

extension NSThread {

    static private let formatterCacheKey = "THGLog.Console.dateFormatter"

    class func dateFormatter(format: String, locale: NSLocale = NSLocale.currentLocale()) -> NSDateFormatter {
        let threadDictionary = NSThread.currentThread().threadDictionary

        var cache: Dictionary<String, NSDateFormatter>? = threadDictionary.objectForKey(formatterCacheKey) as? Dictionary<String, NSDateFormatter>
        if cache == nil {
            cache = Dictionary<String, NSDateFormatter>()
        }

        let formatKey = format + "_" + locale.localeIdentifier
        if let existing = cache?[formatKey] {
            return existing
        }

        let result = NSDateFormatter()
        result.locale = locale
        result.dateFormat = format
        cache?[formatKey] = result

        threadDictionary[formatterCacheKey] = cache
        
        return result;
    }
}

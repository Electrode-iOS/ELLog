//
//  NSThread.swift
//  ELLog
//
//  Created by Brandon Sneed on 3/17/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
//

import Foundation

/*
This extension and the included method have been copied here from THGFoundation (Excalibur) to
minimize dependencies. It is being renamed so that it can be used as source in projects that can't have
frameworks, e.g. command line apps.
*/

extension NSThread {

    static private let formatterCacheKey = "ELLog.Console.dateFormatter_ELLog"

    class func dateFormatter_ELLog(format: String, locale: NSLocale = NSLocale.currentLocale()) -> NSDateFormatter {
        let threadDictionary = NSThread.currentThread().threadDictionary

        var cache: Dictionary<String, NSDateFormatter>? = threadDictionary.objectForKey(formatterCacheKey) as? Dictionary<String, NSDateFormatter>
        if cache == nil {
            cache = Dictionary<String, NSDateFormatter>()
        }

        let formatKey = "\(format)_\(locale.localeIdentifier)"
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

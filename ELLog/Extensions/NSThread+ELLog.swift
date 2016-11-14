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

extension Thread {

    static fileprivate let formatterCacheKey = "ELLog.Console.dateFormatter_ELLog"

    class func dateFormatter_ELLog(_ format: String, locale: Locale = Locale.current) -> DateFormatter {
        let threadDictionary = Thread.current.threadDictionary

        var cache: Dictionary<String, DateFormatter>? = threadDictionary.object(forKey: formatterCacheKey) as? Dictionary<String, DateFormatter>
        if cache == nil {
            cache = Dictionary<String, DateFormatter>()
        }

        let formatKey = "\(format)_\(locale.identifier)"
        if let existing = cache?[formatKey] {
            return existing
        }

        let result = DateFormatter()
        result.locale = locale
        result.dateFormat = format
        cache?[formatKey] = result

        threadDictionary[formatterCacheKey] = cache
        
        return result;
    }
}

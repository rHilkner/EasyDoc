//
//  StringExtensions.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 07/02/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

extension String {
    
    /// Returns all indices of the occurence of the given string. The indices are relative to the position of the first character of the given string.
    func indicesOf(string: String) -> [Int] {
        var indices: [Int] = []
        var searchStartIndex = self.startIndex
        
        // Keep advancing the search range until you can't find any more instances of the substring
        while searchStartIndex < self.endIndex,
            let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
            !range.isEmpty {
                
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        
        return indices
    }
}

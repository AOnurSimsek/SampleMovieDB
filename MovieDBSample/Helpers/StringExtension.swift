//
//  StringExtension.swift
//  MovieDBSample
//
//  Created by Onur Şimşek on 25.05.2022.
//

import Foundation

extension String {
    func getDate()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        if let date = formatter.date(from: self) {
            formatter.dateFormat = "dd-MM-YYYY"
            return formatter.string(from: date)
        } else {
            return ""
        }
    }
    
    func getYearValue()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        if let date = formatter.date(from: self) {
            formatter.dateFormat = "YYYY"
            return "("+formatter.string(from: date)+")"
        } else {
            return ""
        }
    }
}

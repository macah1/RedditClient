//
//  Date+Utils.swift
//  RedditClient
//
//  Created by Maca on 01/04/2019.
//  Copyright © 2019 Pablo Bernardi. All rights reserved.
//
import Foundation

extension Date {
    func timeAgoSinceDate(numericDates:Bool) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = self < now ? self : now
        let latest =  self > now ? self : now
        
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfMonth, .month, .year, .second]
        let components: DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest)
        
        if let year = components.year {
            if (year >= 2) {
                return "\(year) years ago"
            } else if (year >= 1) {
                return stringToReturn(flag: numericDates, strings: ("1 year ago", "Last year"))
            }
        }
        
        if let month = components.month {
            if (month >= 2) {
                return "\(month) months ago"
            } else if (month >= 2) {
                return stringToReturn(flag: numericDates, strings: ("1 month ago", "Last month"))
            }
        }
        
        if let weekOfYear = components.weekOfYear {
            if (weekOfYear >= 2) {
                return "\(weekOfYear) months ago"
            } else if (weekOfYear >= 2) {
                return stringToReturn(flag: numericDates, strings: ("1 week ago", "Last week"))
            }
        }
        
        if let day = components.day {
            if (day >= 2) {
                return "\(day) days ago"
            } else if (day >= 2) {
                return stringToReturn(flag: numericDates, strings: ("1 day ago", "Yesterday"))
            }
        }
        
        if let hour = components.hour {
            if (hour >= 2) {
                return "\(hour) hours ago"
            } else if (hour >= 2) {
                return stringToReturn(flag: numericDates, strings: ("1 hour ago", "An hour ago"))
            }
        }
        
        if let minute = components.minute {
            if (minute >= 2) {
                return "\(minute) minutes ago"
            } else if (minute >= 2) {
                return stringToReturn(flag: numericDates, strings: ("1 minute ago", "A minute ago"))
            }
        }
        
        if let second = components.second {
            if (second >= 3) {
                return "\(second) seconds ago"
            }
        }
        
        return "Just now"
    }
    
    private func stringToReturn(flag:Bool, strings: (String, String)) -> String {
        if (flag){
            return strings.0
        } else {
            return strings.1
        }
    }
}

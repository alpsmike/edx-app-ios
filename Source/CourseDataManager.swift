//
//  CourseDataManager.swift
//  edX
//
//  Created by Akiva Leffert on 5/6/15.
//  Copyright (c) 2015 edX. All rights reserved.
//

import UIKit

private let CourseOutlineModeChangedNotification = "CourseOutlineModeChangedNotification"
private let CurrentCourseOutlineModeKey = "OEXCurrentCourseOutlineMode"

public class CourseDataManager: NSObject, CourseOutlineModeControllerDataSource {
    
    private let interface : OEXInterface?
    private let networkManager : NetworkManager?
    
    private let DefaultCourseMode = CourseOutlineMode.Video
    
    public init(interface : OEXInterface?, networkManager : NetworkManager?) {
        self.interface = interface
        self.networkManager = networkManager
    }
    
    private var queriers : [String:CourseOutlineQuerier] = [:]
    
    public func querierForCourseWithID(courseID : String) -> CourseOutlineQuerier {
        if let querier = queriers[courseID] {
            return querier
        }
        else {
            let querier = CourseOutlineQuerier(courseID: courseID, interface : interface, networkManager : networkManager)
            queriers[courseID] = querier
            return querier
        }
    }
    
    public var currentOutlineMode : CourseOutlineMode {
        get {
            return CourseOutlineMode(rawValue: NSUserDefaults.standardUserDefaults().stringForKey(CurrentCourseOutlineModeKey) ?? "") ?? DefaultCourseMode
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue.rawValue, forKey: CurrentCourseOutlineModeKey)
            NSNotificationCenter.defaultCenter().postNotificationName(CourseOutlineModeChangedNotification, object: nil)
        }
    }
    
    func freshOutlineModeController() -> CourseOutlineModeController {
        return CourseOutlineModeController(dataSource : self)
    }
    
    public var modeChangedNotificationName : String {
        return CourseOutlineModeChangedNotification
    }
}

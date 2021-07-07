//
//  DSLogger.swift
//  DfsxAnalysis
//
//  Created by lotawei on 2020/11/30.
//

import Foundation

public enum DSLogLevel : Int
{
    case verbose = 2
    case debug = 3
    case info = 4
    case warn = 5
    case error = 6
}

public class DSLogger
{
    fileprivate let  defaulprefix = "DSLogger:"
    var log:DSLogLevel?
    public static let shared = DSLogger()
    private init()
    {
        log = DSLogLevel.info
    }
    
    public var logLevel:DSLogLevel?
    {
        get
        {
            return log
        }
        set
        {
            log = newValue
        }
    }
    
  public    func debug(_ item: @autoclosure () -> Any) {
        if log!.rawValue <= DSLogLevel.debug.rawValue
        {
            print("\(defaulprefix)\(item())")
        }
    }
    
   public func verbose(_ item: @autoclosure () -> Any)
    {
        if log!.rawValue <= DSLogLevel.verbose.rawValue
        {
            print("\(defaulprefix)\(item())")
        }
    }
    
  public  func info(_ item: @autoclosure () -> Any)
    {
        if log!.rawValue <= DSLogLevel.info.rawValue
        {
            print("\(defaulprefix)\(item())")
        }
    }
    
  public  func warn(_ item: @autoclosure () -> Any)
    {
        if log!.rawValue <= DSLogLevel.warn.rawValue
        {
            print("\(defaulprefix)\(item())")
        }
    }
    
  public  func error(_ item: @autoclosure () -> Any)
    {
        if log!.rawValue <= DSLogLevel.error.rawValue
        {
            print("\(defaulprefix)\(item())")
        }
    }
}

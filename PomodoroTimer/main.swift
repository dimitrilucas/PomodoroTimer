//
//  main.swift
//  PomodoroTimer
//
//  Created by Dimitri Lucas on 8/30/24.
//

import Cocoa


//struct PomodoroAppMain {
//    static func main() {
//        let app = NSApplication.shared
//        let delegate = PomodoroApp()
//        app.delegate = delegate
 //       app.run()
 //   }
//}

let app = NSApplication.shared
let delegate = PomodoroApp()
app.delegate = delegate
app.run()

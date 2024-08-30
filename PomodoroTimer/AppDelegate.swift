//
//  AppDelegate.swift
//  PomodoroTimer
//
//  Created by Dimitri Lucas on 8/30/24.
//

//import Foundation
import Cocoa
import UserNotifications

class PomodoroApp: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var timer: Timer?
    var isBreak = false
    var duration = 0

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title = "🍅"
        statusItem.menu = NSMenu()
        statusItem.menu?.addItem(NSMenuItem(title: "Start Pomodoro", action: #selector(startTimer), keyEquivalent: "S"))
        
        // Request notification permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }

    @objc func startTimer() {
        if timer == nil || !timer!.isValid {
            startPomodoro()
        }
    }

    func startPomodoro() {
        duration = isBreak ? 5 * 60 : 25 * 60
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        updateTitle()
    }

    @objc func updateTimer() {
        duration -= 1
        updateTitle()
        if duration <= 0 {
            timer?.invalidate()
            sendNotification()
            isBreak.toggle()
            startPomodoro()
        }
    }

    func updateTitle() {
        let minutes = duration / 60
        let seconds = duration % 60
        statusItem.button?.title = String(format: "%02d:%02d", minutes, seconds)
    }

    func sendNotification() {
        let notification = UNMutableNotificationContent()
        notification.title = isBreak ? "Break Over" : "Pomodoro Completed"
        notification.body = isBreak ? "Time to work! Start your next Pomodoro" : "Great job! Take a short break"
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
    let fileManager = FileManager.default
    let savedStatePath = "\(NSHomeDirectory())/Library/Saved Application State/\(Bundle.main.bundleIdentifier!).savedState"
    do {
        try fileManager.removeItem(atPath: savedStatePath)
    } catch {
        print("Failed to delete saved state: \(error)")
    }
    return .terminateNow
}

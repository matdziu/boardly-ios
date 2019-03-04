//
//  EventUIRenderer.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 20/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import EventKit

class EventUIRenderer {
    
    private var gameImageView1GestureRecognizer: UITapGestureRecognizer!
    private var gameImageView2GestureRecognizer: UITapGestureRecognizer!
    private var gameImageView3GestureRecognizer: UITapGestureRecognizer!

    func displayEventInfo(event: BoardlyEvent,
                          eventNameLabel: UILabel,
                          gameLabel: UILabel,
                          placeButton: UIButton,
                          locationImageView: UIImageView,
                          boardGameImageView: UIImageView,
                          seeDescriptionButton: UIButton,
                          dateButton: UIButton,
                          timeImageView: UIImageView,
                          gameLabel2: UILabel,
                          boardGameImageView2: UIImageView,
                          gameLabel3: UILabel,
                          boardGameImageView3: UIImageView) {
        eventNameLabel.text = event.eventName
        placeButton.setTitle(event.placeName, for: .normal)
        
        displayGameNameAndImage(gameName: event.gameName, gameLabel: gameLabel, gameImageUrl: event.gameImageUrl, gameImageView: boardGameImageView)
        displayGameNameAndImage(gameName: event.gameName2, gameLabel: gameLabel2, gameImageUrl: event.gameImageUrl2, gameImageView: boardGameImageView2)
        displayGameNameAndImage(gameName: event.gameName3, gameLabel: gameLabel3, gameImageUrl: event.gameImageUrl3, gameImageView: boardGameImageView3)
        
        setSeeDescriptionButton(description: event.description, seeDescriptionButton: seeDescriptionButton)
        setDateTextView(timestamp: event.timestamp, dateButton: dateButton)
        
        boardGameImageView.userInfo[GAME_ID_USER_INFO] = event.gameId
        boardGameImageView2.userInfo[GAME_ID_USER_INFO] = event.gameId2
        boardGameImageView3.userInfo[GAME_ID_USER_INFO] = event.gameId3
        
        placeButton.userInfo[LATITUDE_USER_INFO] = event.placeLatitude
        placeButton.userInfo[LONGITUDE_USER_INFO] = event.placeLongitude
        placeButton.userInfo[LOCATION_NAME_USER_INFO] = event.placeName
        placeButton.addTarget(self, action: #selector(openMap(_:)), for: .touchUpInside)
        
        if event.timestamp > 0 {
            dateButton.userInfo[EVENT_NAME_USER_INFO] = event.eventName
            dateButton.userInfo[GAME_NAME_USER_INFO] = event.gameName
            dateButton.userInfo[GAME_NAME_2_USER_INFO] = event.gameName2
            dateButton.userInfo[GAME_NAME_3_USER_INFO] = event.gameName3
            dateButton.userInfo[START_TIME_USER_INFO] = event.timestamp
            dateButton.userInfo[PLACE_NAME_USER_INFO] = event.placeName
            dateButton.addTarget(self, action: #selector(saveToCalendar(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func openMap(_ sender: UIButton) {
        let latitude = sender.userInfo[LATITUDE_USER_INFO] as? Double ?? 0.0
        let longitude = sender.userInfo[LONGITUDE_USER_INFO] as? Double ?? 0.0
        let placeName = sender.userInfo[LOCATION_NAME_USER_INFO] as? String ?? ""
        openMapForPlace(latitude: latitude, longitude: longitude, locationName: placeName)
    }
    
    @objc private func saveToCalendar(_ sender: UIButton) {
        let eventName = sender.userInfo[EVENT_NAME_USER_INFO] as? String ?? ""
        let gameName = sender.userInfo[GAME_NAME_USER_INFO] as? String ?? ""
        let gameName2 = sender.userInfo[GAME_NAME_2_USER_INFO] as? String ?? ""
        let gameName3 = sender.userInfo[GAME_NAME_3_USER_INFO] as? String ?? ""
        let startTime = sender.userInfo[START_TIME_USER_INFO] as? Int64 ?? 0
        let placeName = sender.userInfo[PLACE_NAME_USER_INFO] as? String ?? ""
        
        let title = "Boardly: \(NSLocalizedString("event", comment: "")) \(eventName)"
        let description = "\(NSLocalizedString("Together you'll be playing in", comment: "")) \(gameName)\(appendWithComma(gameName: gameName2))\(appendWithComma(gameName: gameName3)). \(NSLocalizedString("The event will take place in", comment: "")) \(placeName)."
        let startDate = Date(timeIntervalSince1970: TimeInterval(startTime / 1000))
        
        addEventToCalendar(title: title, description: description, startDate: startDate)
    }
    
    private func appendWithComma(gameName: String) -> String {
        if (gameName != "") {
            return ", \(gameName)"
        } else {
            return ""
        }
    }
    
    func openMapForPlace(latitude: Double, longitude: Double, locationName: String) {
        let regionDistance: CLLocationDistance = 5000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = locationName
        mapItem.openInMaps(launchOptions: options)
    }
    
    private func displayGameNameAndImage(gameName: String, gameLabel: UILabel,
                                         gameImageUrl: String, gameImageView: UIImageView) {
        if (!gameName.isEmpty) {
            gameLabel.isHidden = false
            gameImageView.isHidden = false
            gameLabel.text = gameName
            gameImageView.downloaded(from: gameImageUrl, placeHolder: UIImage(named: Image.boardGamePlaceholder.rawValue))
        } else {
            gameLabel.isHidden = true
            gameImageView.isHidden = true
        }
    }
    
    private func setSeeDescriptionButton(description: String, seeDescriptionButton: UIButton) {
        if (!description.isEmpty) {
            seeDescriptionButton.isHidden = false
            seeDescriptionButton.userInfo[DESCRIPTION_USER_INFO] = description
            seeDescriptionButton.addTarget(self, action: #selector(launchDescriptionDialog(_:)), for: .touchUpInside)
        } else {
            seeDescriptionButton.isHidden = true
        }
    }
    
    @objc private func launchDescriptionDialog(_ sender: UIButton) {
        let description = sender.userInfo[DESCRIPTION_USER_INFO] as? String ?? ""
        UIApplication.shared.keyWindow?.rootViewController?.showAlertWithOkButton(message: description)
    }
    
    @objc private func openBoardGameInfoPage(_ sender: UITapGestureRecognizer) {
        let gameId = (sender.view?.userInfo[GAME_ID_USER_INFO] as? String) ?? ""
        var endpoint = ""
        if gameId.isOfType(type: RPG_TYPE) {
            endpoint = "rpg/\(gameId.clearFromType(type: RPG_TYPE))"
        } else {
            endpoint = "boardgame/\(gameId)"
        }
        if let link = URL(string: "https://boardgamegeek.com/\(endpoint)") {
            UIApplication.shared.open(link)
        }
    }
    
    private func setDateTextView(timestamp: Int64, dateButton: UIButton) {
        if (timestamp > 0) {
            dateButton.setTitle(Date(timeIntervalSince1970: TimeInterval(timestamp / 1000)).formatForDisplay(), for: .normal)
        } else {
            dateButton.setTitle(NSLocalizedString("To be added", comment: ""), for: .normal)
        }
    }
    
    private func addEventToCalendar(title: String, description: String, startDate: Date) {
        let eventStore = EKEventStore()
        let endDate = Date(timeIntervalSince1970: TimeInterval(startDate.toMillis().advanced(by: HOUR_IN_MILLIS) / 1000))
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch {
                    return
                }
                DispatchQueue.main.async {
                    UIApplication.shared.keyWindow?.rootViewController?.showAlertWithOkButton(message: NSLocalizedString("Event added to calendar", comment: ""))
                }
            }
        })
    }
}

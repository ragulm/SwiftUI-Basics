//
//  CombineBasics.swift
//  PracticeSwiftUI
//
//  Created by Ragul Lakshmanan on 19/07/23.
//

import Foundation
import Combine
import SwiftUI

class CombineBasics: ObservableObject {
    
    var subscription: AnyCancellable?
    
    var publishedCancellable = Set<AnyCancellable>()
    
    // Uncomment each line to check respective functionality
    init() {
//        validateCarWithPublished()
//        validatePassthroughSubject()
//        validateCurrentValueSubject()
//        chkPublisherCollecWithArray()
//        chkPublisherMapWithArray()
//        chkPublisher()
//        subscribeFunc()
//        subscribeWithMapFunc()
//        NotificationCenter.default.post(Notification(name: UIApplication.keyboardDidShowNotification))
//        subscription?.cancel()
//        NotificationCenter.default.post(Notification(name: UIApplication.keyboardDidShowNotification))
    }
    
    //SUBSCRIBER with map publisher, which transforms the data provided by the main publisher and creates a new publisher. Then the new value is sent to the subscriber(SINK) as sent from map return type
    //subscribe with sink subscriber. Here for the notification publsidher, sink subscriber is created and any changes to the publisher will be updated to the sink closure
    func subscribeWithMapFunc() {
        let notification = UIApplication.keyboardDidShowNotification
        let publisher = NotificationCenter.default.publisher(for: notification)
            .map { (val) -> String in
                print(val.name)
                return "ML one"
            }
        subscription = publisher.sink(receiveCompletion: { _ in
            print("Completion")
        }, receiveValue: { notification in
            print("Received notification: \(notification)")
        })
    }
    
    
    //subscribe with sink subscriber. Here for the notification publsidher, sink subscriber is created and any changes to the publisher will be updated to the sink closure
    func subscribeFunc() {
        let notification = UIApplication.keyboardDidShowNotification
        let publisher = NotificationCenter.default.publisher(for: notification)
        subscription = publisher.sink(receiveCompletion: { _ in
            print("Completion")
        }, receiveValue: { notification in
            print("Received notification: \(notification)")
        })
    }
    
    func chkPublisherWIthArray() {
        [1, 2, 3]
            .publisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Something went wrong: \(error)")
                case .finished:
                    print("Received Completion")
                }
            }, receiveValue: { value in
                print("Received value \(value)")
            })
    }
    
    func chkPublisherMapWithArray() {
        [1, 2, 3]
            .publisher
            .map { (vall) -> String in
                return "ML for INT"
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Something went wrong: \(error)")
                case .finished:
                    print("Received Completion")
                }
            }, receiveValue: { value in
                print("Received value \(value)")
            })
    }
    
    func chkPublisherCollecWithArray() {
        [1, 2, 3]
            .publisher
            .collect(2)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Something went wrong: \(error)")
                case .finished:
                    print("Received Completion")
                }
            }, receiveValue: { value in
                print("Received value \(value)")
            })
    }
    
    func validateCurrentValueSubject() {
        let carr = CarCurrentValueSubject()
        let vall = carr.drive(kilometers: 2.0)
        print(vall)
    }
    
    func validatePassthroughSubject() {
        let carr = CarPassthroughSubject()
        let vall = carr.drive(kilometers: 2.0)
        print(vall)
    }
    
    func validateCarWithPublished() {
        let carr = CarWithPublished()
        carr.$kwhInBattery.sink {vall in
            print("ML vall")
            print(vall)
        }.store(in: &publishedCancellable)
        
        carr.drive(kilometers: 2.0)
    }
}

// For PassthroughSubject
class CarWithPublished {
    
    @Published var kwhInBattery = 50.0
      let kwhPerKilometer = 0.14

      func drive(kilometers: Double) {
        let kwhNeeded = kilometers * kwhPerKilometer

        kwhInBattery -= kwhNeeded
      }
}

// For PassthroughSubject
class CarPassthroughSubject {
    
    var ddd = Set<AnyCancellable>()
    
    func drive(kilometers: Double) {
        let kwhInBattery = PassthroughSubject<Double, Never>()
        
        kwhInBattery.send(3.0)
        
        kwhInBattery.sink {val in
            print("ml val")
            print(val)
        }.store(in: &ddd)
        
        kwhInBattery.send(3.0)
        kwhInBattery.send(3.0)
    }
}

// For CurrentValueSubject
class CarCurrentValueSubject {
  var kwhInBattery = CurrentValueSubject<Double, Never>(50.0)
  let kwhPerKilometer = 0.14

  func drive(kilometers: Double) -> Double {
    var kwhNeeded = kilometers * kwhPerKilometer
    kwhInBattery.value -= kwhNeeded
      return kwhInBattery.value
  }
}

struct CombineBasicsView: View {
    
    @StateObject var vm = CombineBasics()
    
    var body: some View {
        Text("ml")
    }
}

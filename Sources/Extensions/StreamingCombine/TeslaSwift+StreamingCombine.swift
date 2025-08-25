//
//  TeslaSwift+StreamingCombine.swift
//  TeslaSwift
//
//  Created by João Nunes on 19/12/2020.
//  Copyright © 2020 Joao Nunes. All rights reserved.
//

import Combine
import TeslaSwift

extension TeslaStreaming  {
    public func streamPublisher(vehicle: Vehicle) -> TeslaStreamingPublisher {
        return TeslaStreamingPublisher(vehicle: vehicle, stream: self)
    }

    public struct TeslaStreamingPublisher: Publisher, Cancellable {
        public typealias Output = TeslaStreamingEvent
        public typealias Failure = Error

        let vehicle: Vehicle
        let stream: TeslaStreaming

        init(vehicle: Vehicle, stream: TeslaStreaming) {
            self.vehicle = vehicle
            self.stream = stream
        }

        public func receive<S>(subscriber: S) where S: Subscriber, TeslaStreamingPublisher.Failure == S.Failure, TeslaStreamingPublisher.Output == S.Input {

            Task {
                do {
                    for try await streamEvent in try await stream.openStream(vehicle: vehicle) {
                        switch streamEvent {
                            case .open:
                                _ = subscriber.receive(TeslaStreamingEvent.open)
                            case .event(let event):
                                _ = subscriber.receive(TeslaStreamingEvent.event(event))
                            case .error(let error):
                                _ = subscriber.receive(TeslaStreamingEvent.error(error))
                            case .disconnected:
                                _ = subscriber.receive(TeslaStreamingEvent.disconnected)
                                subscriber.receive(completion: Subscribers.Completion.finished)
                        }
                    }
                } catch let error {
                    _ = subscriber.receive(TeslaStreamingEvent.error(error))
                    subscriber.receive(completion: Subscribers.Completion.finished)
                }
            }
        }

        public func cancel() {
            stream.closeStream()
        }
    }
}

//
//  UnitTestVM.swift
//  PracticeSwiftUI
//
//  Created by Ragul Lakshmanan on 18/07/23.
//

import Foundation
import Combine

// Class for Unit Test case

protocol JobClientProtocol {
    var fetchJobsResult: AnyPublisher<[Job], Error>! { get }
    func fetchJobs() -> AnyPublisher<[Job], Error>
}

struct Job {
    let id: String
    let title: String
    let description: String
}

class JobsViewModel {
    private let client: JobClientProtocol

    init(client: JobClientProtocol) {
        self.client = client
    }

    enum JobsViewState: Equatable {
        case populated
        case empty
        case error(_ error: Error)

        static func == (lhs: JobsViewState, rhs: JobsViewState) -> Bool {
            switch (lhs, rhs) {
            case (.populated, .populated): return true
            case (.empty, .empty): return true
            case (.error, .error): return true
            default: return false
            }
        }
    }

    @Published var viewState: JobsViewState = .empty

    func loadJobs() {
        client.fetchJobs()
            .map { jobs -> JobsViewState in
                return jobs.isEmpty ? .empty : .populated
            }.catch { error -> Just<JobsViewState> in
                return Just(.error(error))
            }.assign(to: &$viewState)
    }
}

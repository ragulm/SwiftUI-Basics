//
//  PracticeSwiftUITests.swift
//  PracticeSwiftUITests
//
//  Created by Ragul Lakshmanan on 13/07/23.
//

import XCTest
@testable import PracticeSwiftUI
import Combine

final class PracticeSwiftUITests: XCTestCase {
    private var mockJobClient: MockJobClient!
        private var viewModelToTest: JobsViewModel!

        private var cancellables: Set<AnyCancellable> = []

        override func setUpWithError() throws {
            try super.setUpWithError()
            mockJobClient = MockJobClient()
            viewModelToTest = JobsViewModel(client: mockJobClient)
        }

        override func tearDownWithError() throws {
            mockJobClient = nil
            viewModelToTest = nil
            try super.tearDownWithError()
        }

        func testGetJobsPopulated() {
            let jobsToTest = [Job(id: "1", title: "title", description: "desc")]
            let expectation = XCTestExpectation(description: "State is set to populated")

            viewModelToTest.$viewState.dropFirst().sink { state in
                XCTAssertEqual(state, .populated)
                expectation.fulfill()
            }.store(in: &cancellables)

            mockJobClient.fetchJobsResult = Result.success(jobsToTest).publisher.eraseToAnyPublisher()
            viewModelToTest.loadJobs()
       
            wait(for: [expectation], timeout: 1)
        }

        func testGetJobsEmpty() {
            let jobsToTest: [Job] = []
            let expectation = XCTestExpectation(description: "State is set to empty")

            viewModelToTest.$viewState.dropFirst().sink { state in
                XCTAssertEqual(state, .empty)
                expectation.fulfill()
            }.store(in: &cancellables)

            mockJobClient.fetchJobsResult = Result.success(jobsToTest).publisher.eraseToAnyPublisher()
            viewModelToTest.loadJobs()

            wait(for: [expectation], timeout: 1)
        }
}

class MockJobClient: JobClientProtocol {
    
    var fetchJobsResult: AnyPublisher<[Job], Error>!
    func fetchJobs() -> AnyPublisher<[Job], Error> {
        return fetchJobsResult
    }
}

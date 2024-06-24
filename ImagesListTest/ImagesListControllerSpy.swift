//
//  ImagesListPresenterSpy.swift
//  ImagesListTest
//
//  Created by Кирилл Кашицкий on 21.06.2024.
//

import XCTest
@testable import ImageFeed

final class ImagesListControllerSpy: ImagesListViewControllerProtocol {
    
    // Flags for calling methods verification
    private(set) var isConfigCellCalled = false
    private(set) var isUpdateTableViewAnimatedCalled = false
    
    // Arguments
    private(set) var configCellArguments: (cell: ImagesListCell, indexPath: IndexPath)?
    private(set) var updateTableViewAnimatedArguments: (oldCount: Int, newCount: Int)?
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        isConfigCellCalled = true
        configCellArguments = (cell, indexPath)
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        isUpdateTableViewAnimatedCalled = true
        updateTableViewAnimatedArguments = (oldCount, newCount)
    }

    // Reset spy state
    func reset() {
        isConfigCellCalled = false
        isUpdateTableViewAnimatedCalled = false
        configCellArguments = nil
        updateTableViewAnimatedArguments = nil
    }
}

//
//  Extensions.swift
//  Sourcery
//
//  Created by Dominik Hádl on 27/04/16.
//  Copyright © 2016 Nodes ApS. All rights reserved.
//

import UIKit

// MARK: - UITableView -

public extension UITableView {

    // MARK: Register

    public func registerCellType(cellType: TableViewPresentable.Type) {
        if cellType.loadsFromNib {
            self.registerNib(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
        } else {
            self.registerClass(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
        }
    }

    public func registerCellType<T where T: TableViewPresentable>(cellType: T.Type) {
        if cellType.loadsFromNib {
            self.registerNib(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
        } else {
            self.registerClass(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
        }
    }

    public func registerCellTypes(cellTypes: [TableViewPresentable.Type]) {
        for cell in cellTypes {
            registerCellType(cell)
        }
    }

    // MARK: Dequeue

    public func registerAndDequeueCell(cellType: TableViewPresentable.Type) -> UITableViewCell {
        // First register
        registerCellType(cellType)

        // Try to get cell or fail miserably
        guard let cell = self.dequeueReusableCellWithIdentifier(cellType.reuseIdentifier) else {
            fatalError("Cell registration and dequeue failed. Please check that " +
                       "your NIB file exists or your class is available and set up correctly.")
        }

        // Return cell
        return cell
    }

    public func dequeueCellType<T where T: TableViewPresentable>(cellType: TableViewPresentable.Type) -> T {
        var requestedCell = self.dequeueReusableCellWithIdentifier(cellType.reuseIdentifier) as? T
        requestedCell     = requestedCell ?? registerAndDequeueCell(cellType) as? T

        // This 'should never happen'
        guard let cell = requestedCell else {
            fatalError("Internatl inconsistency error. If you got this far," +
                       " there is something seriously wrong with Swift.")
        }

        return cell
    }

    public func dequeueCellTypeDefault(cellType: TableViewPresentable.Type) -> UITableViewCell {
        let cell = self.dequeueReusableCellWithIdentifier(cellType.reuseIdentifier)
        return cell ?? registerAndDequeueCell(cellType)
    }

    // MARK: Header & Footer

    public func registerHeaderFooterView(viewType: TableViewPresentable.Type) {
        if viewType.loadsFromNib {
            self.registerNib(viewType.nib, forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier)
        } else {
            self.registerClass(viewType, forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier)
        }
    }

    public func registerAndDequeueHeaderFooterView(viewType: TableViewPresentable.Type) -> UITableViewHeaderFooterView? {
        // First register
        registerHeaderFooterView(viewType)

        // Try to get cell or fail miserably
        guard let view = self.dequeueReusableHeaderFooterViewWithIdentifier(viewType.reuseIdentifier) else {
            fatalError("Header/Footer view registration and dequeue failed. Please check that " +
                "your NIB file exists or your class is available and set up correctly.")
        }

        // Return cell
        return view
    }

    public func dequeueHeaderFooterView(viewType: TableViewPresentable.Type) -> UITableViewHeaderFooterView? {
        var requestedView = self.dequeueReusableHeaderFooterViewWithIdentifier(viewType.reuseIdentifier)
        requestedView     = requestedView ?? registerAndDequeueHeaderFooterView(viewType)

        // This 'should never happen'
        guard let view = requestedView else {
            fatalError("Internatl inconsistency error. If you got this far," +
                " there is something seriously wrong with Swift.")
        }

        return view
    }
}
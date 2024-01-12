//
//  ProductsViewNavigator.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

protocol ProductsViewNavigator: AutoMockable, AnyObject {
    
    /// Presents the products details screen
    func showDetails(forProduct productId: Int)
    
    /// Presents the filter context menu
    func showFilterMenu()
    
    /// Presents the order by context menu
    func showOrderByMenu()
}

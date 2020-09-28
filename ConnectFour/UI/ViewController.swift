//
//  ViewController.swift
//  ConnectFour
//
//  Created by Andy Bell on 28.09.20.
//

import UIKit

class ViewController: UIViewController {

    private let columnsStack = UIStackView(frame: .zero)
    private let columnCount = 7
    private let rowCount = 6
    private let sidePadding: CGFloat = 200.0
    
    private var gameManager: GameManager!
    private var columns = [ColumnView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameManager = GameManager(columnCount: columnCount, rowCount: rowCount)
        configureMainColumnsStack(cols: columnCount, rows: rowCount)
    }
    
    private func configureMainColumnsStack(cols: Int, rows: Int) {
        
        let aspectRatio = CGFloat(cols) / CGFloat(rows)
        
        columnsStack.axis = .horizontal
        columnsStack.distribution = .fillEqually
        columnsStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(columnsStack)
        
        NSLayoutConstraint.activate([
            columnsStack.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -sidePadding),
            columnsStack.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: aspectRatio, constant: -sidePadding),
            columnsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            columnsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        for i in 0..<cols {
            
            let column = ColumnView(frame: .zero)
            column.backgroundColor = i % 2 == 0 ? UIColor.lightGray : UIColor.white
            column.tag = i
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(columnTapAction(_:)))
            column.addGestureRecognizer(tapGesture)
            
            columnsStack.addArrangedSubview(column)
            columns.append(column)
        }
    }
    
    private func addDiscToColumn(_ coldIdx: Int, withColor color: UIColor) {
        
        let column = columns[coldIdx]
        column.addDiscWithColor(color)
    }
    
    @IBAction func columnTapAction(_ sender: UITapGestureRecognizer) {
        
        guard let tapColumn = sender.view as? ColumnView,
              gameManager.freeSlotIdxInCol(tapColumn.tag) != nil else {
            return
        }
        gameManager.insertIntoCol(tapColumn.tag, state: .red)
        addDiscToColumn(tapColumn.tag, withColor: UIColor.red)
    }
}

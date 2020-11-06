//
//  ViewController.swift
//  ConnectFour
//
//  Created by xxxxxxx on 28.09.20.
//

import UIKit

class ViewController: UIViewController {

    private let columnsStack = UIStackView(frame: .zero)
    private let sidePadding: CGFloat = 200.0
    private let p1Label = PlayerLabel(frame: .zero)
    private let p2Label = PlayerLabel(frame: .zero)

    var viewModel: ViewModelDefault!
    
    private var columns = [ColumnView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMainColumnsStack(cols: viewModel.columnCount, rows: viewModel.rowCount)
        configurePlayerLabels()
        
        viewModel.gameStateDidUpdate = { [weak self] gameState in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.layoutForGameState(gameState)
            }
        }
        
        viewModel.requestNewGame()
    }
    
    private func layoutForGameState(_ gameState: GameState) {
        
        switch gameState {
        case .won:
            addDisc(forMove: viewModel.currentMove)
            displayWin(for: viewModel.winnerName)
        case .draw:
            addDisc(forMove: viewModel.currentMove)
            displayForDraw()
        case .inProgress:
            addDisc(forMove: viewModel.currentMove)
            setPlayerLabelColors()
        case .started:
            p1Label.text = "Player 1:\n\(viewModel.playerOneName)"
            p2Label.text = "Player 2:\n\(viewModel.playerTwoName)"
            setPlayerLabelColors()
        }
    }
    
    private func setPlayerLabelColors() {

        UIView.animate(withDuration: 0.3) {
            self.p1Label.layer.backgroundColor = self.viewModel.playerOneColor.cgColor
            self.p2Label.layer.backgroundColor = self.viewModel.playerTwoColor.cgColor
        }
    }
    
    private func configurePlayerLabels() {
        
        p1Label.text = "Player 1"
        p1Label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(p1Label)
        
        NSLayoutConstraint.activate([
            p1Label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            p1Label.trailingAnchor.constraint(equalTo: columnsStack.leadingAnchor, constant: -10),
            p1Label.centerYAnchor.constraint(equalTo: columnsStack.centerYAnchor),
            p1Label.heightAnchor.constraint(equalTo: columnsStack.heightAnchor)
        ])
        
        p2Label.text = "Player 2"
        p2Label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(p2Label)
        
        NSLayoutConstraint.activate([
            p2Label.leadingAnchor.constraint(equalTo: columnsStack.trailingAnchor, constant: 10),
            p2Label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            p2Label.centerYAnchor.constraint(equalTo: columnsStack.centerYAnchor),
            p2Label.heightAnchor.constraint(equalTo: columnsStack.heightAnchor)
        ])
    }
    
    private func configureMainColumnsStack(cols: Int, rows: Int) {
        
        let aspectRatio = CGFloat(cols) / CGFloat(rows)
        
        columnsStack.clipsToBounds = true
        columnsStack.layer.cornerRadius = 20.0
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
            column.backgroundColor = i % 2 == 0 ? UIColor.systemGray : UIColor.systemGray2
            column.tag = i
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(columnTapAction(_:)))
            column.addGestureRecognizer(tapGesture)
            
            columnsStack.addArrangedSubview(column)
            columns.append(column)
        }
    }
    
    private func addDisc(forMove gameMove: GameMove?) {
        guard let move = gameMove else { return }
        let column = columns[move.insertColumn]
        column.addDiscWithColor(move.insertColor)
    }
    
    private func clearGameUI() {
        
        p1Label.text = ""
        p1Label.backgroundColor = .clear
        p2Label.text = ""
        p2Label.backgroundColor = .clear
        
        for col in columnsStack.subviews where col.isKind(of: ColumnView.self) {
            guard let colView = col as? ColumnView else {
                return
            }
            colView.clearDiscs()
        }
    }
    
    private func displayWin(for playerName: String) {
        
        let alert = UIAlertController(title: "Four In A Row!", message: "\(playerName) has won the game", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: resetForNewGame))
        present(alert, animated: true, completion: nil)
    }
    
    private func displayForDraw() {
        
        let alert = UIAlertController(title: "It's A Draw!", message: "The slots are full. Let's play another one...", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: resetForNewGame))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func resetForNewGame(_ sender: Any) {
        clearGameUI()
        viewModel.requestNewGame()
    }
    
    @IBAction func columnTapAction(_ sender: UITapGestureRecognizer) {
        
        guard let tapColumn = sender.view as? ColumnView else {
            return
        }
        viewModel.didTapColumn(tapColumn.tag)
    }
}

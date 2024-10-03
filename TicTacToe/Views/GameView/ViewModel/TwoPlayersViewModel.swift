//
//  TwoPlayersViewModel.swift
//  TicTacToe
//
//  Created by Roman Golub on 03.10.2024.
//

import SwiftUI

final class TwoPlayersViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var isPlayerOneTurn: Bool = true
    
    @Published var moves: [TwoPlayersModel.Move?] = Array(repeating: nil, count: 9)
    @Published var currentTurn: TwoPlayersModel.Player = .playerOne
    
    func processPlayerMove(for position: Int) {
            if isSquareOccupied(in: moves, forIndex: position) { return }

            if isPlayerOneTurn {
                moves[position] = TwoPlayersModel.Move(player: .playerOne, boardIndex: position)
                currentTurn = .playerOne
                if checkWinCondition(for: .playerOne, in: moves) {
                    // Win player one
                    return
                }
            } else {
                moves[position] = TwoPlayersModel.Move(player: .playerTwo, boardIndex: position)
                currentTurn = .playerTwo
                if checkWinCondition(for: .playerTwo, in: moves) {
                    // Win player two
                    return
                }
            }

            if checkForDraw(in: moves) {
                // "It's a Draw!"
                return
            }

            // Toggle the turn
            isPlayerOneTurn.toggle()
        currentTurn = isPlayerOneTurn ? .playerOne : .playerTwo
        }
    
    func isSquareOccupied(in moves: [TwoPlayersModel.Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func checkWinCondition(for player: TwoPlayersModel.Player, in moves: [TwoPlayersModel.Move?]) -> Bool {
        // Setting Win conditions
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        // If player move == a win condition, then win
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        
        return false
    }
    
    func checkForDraw(in moves: [TwoPlayersModel.Move?]) -> Bool {
        // If all squares occupied, then draw
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
        currentTurn = .playerOne
    }
}

# Link to chessAPI docs: https://readthedocs.org/projects/python-chess/downloads/pdf/latest/
# Link to chessAPI github: https://github.com/niklasf/python-chess

import chess
import chess.polyglot
import chess.svg
import chess.pgn
import chess.engine
import chess.syzygy
import copy
from pieces import piece_values, pawn_squares, knight_squares, bishop_squares, rook_squares, queen_squares, king_squares
# path to human.bin, which holds opening moves
book = "C:/Users/ryanh/Documents/GitHub/Projects/Chess_AI_Project/Chess_Books/human.bin"
# path to endgame tablebase 
end_table = "C:/Users/ryanh/Documents/GitHub/Projects/Chess_AI_Project/Chess_Books/3-4-5piecesSyzygy/3-4-5"

def board_eval(board):

    if(board.is_checkmate()):
        if(board.turn):
            return -1000000
        else:
            return 1000000
        if(board.is_stalemate()):
            return 0
        if(board.is_insufficient_material):
            return 0

    score = 0
    pmap = board.piece_map()
    for piece in pmap:
        score += piece_values[pmap[piece].symbol()]

        if(pmap[piece].symbol() == 'p'):
            score -= pawn_squares[7-(piece//8)][7-(piece%8)]
        elif(pmap[piece].symbol() == 'P'):
            score += pawn_squares[piece//8][piece%8]
        elif(pmap[piece].symbol() == 'n'):
            score -= knight_squares[7-(piece//8)][7-(piece%8)]
        elif(pmap[piece].symbol() == 'N'):
            score += knight_squares[piece//8][piece%8]
        elif(pmap[piece].symbol() == 'b'):
            score -= bishop_squares[7-(piece//8)][7-(piece%8)]
        elif(pmap[piece].symbol() == 'B'):
            score += bishop_squares[piece//8][piece%8]
        elif(pmap[piece].symbol() == 'r'):
            score -= rook_squares[7-(piece//8)][7-(piece%8)]
        elif(pmap[piece].symbol() == 'R'):
            score += rook_squares[piece//8][piece%8]
        elif(pmap[piece].symbol() == 'q'):
            score -= queen_squares[7-(piece//8)][7-(piece%8)]
        elif(pmap[piece].symbol() == 'Q'):
            score += queen_squares[piece//8][piece%8]
        elif(pmap[piece].symbol() == 'k'):
            score -= king_squares[7-(piece//8)][7-(piece%8)]
        elif(pmap[piece].symbol() == 'K'):
            score += king_squares[piece//8][piece%8]
    
    if board.turn:
        return score
    else:
        return -score

def minimax(board, target_depth):
    try:
        move = chess.polyglot.MemoryMappedReader(book).weighted_choice(board).move
        return move
    except:
        pass

    top_score = -9999999
    top_move = None
    for move in board.legal_moves:
        board.push(move)
        score = -_minimax(1, board, target_depth)
        if(score >= top_score):
            top_score = score
            top_move = move
        board.pop()
    return top_move

def _minimax(current_depth, board, target_depth):

    best_score = -10000000

    if(current_depth == target_depth):
        return board_eval(board) 

    for move in board.legal_moves:
        board.push(move)
        score = -_minimax(current_depth+1, board, target_depth)
        board.pop()
        best_score = max(best_score, score)
  
    return best_score

def _alpha_beta(current_depth, board, target_depth, alpha, beta):

    best_score = -10000000

    if(current_depth == target_depth):
        return mid_trade(board, alpha, beta)

    for move in board.legal_moves:
        board.push(move)
        score = -_alpha_beta(current_depth+1, board, target_depth, -beta, -alpha)
        board.pop()
        if (score >= beta):
            return score
        best_score = max(best_score, score)
        alpha = max(alpha, best_score)
        
    return best_score

def alpha_beta(board, target_depth):

    try:
        move = chess.polyglot.MemoryMappedReader(book).weighted_choice(board).move
        return move
    except:
        pass

    if(len(board.piece_map()) <= 5):
        return endgame(board)

    alpha = -10000000
    beta = 10000000
    top_score = -9999999
    top_move = None
    for move in board.legal_moves:
        board.push(move)
        score = -_alpha_beta(1, board, target_depth, -beta, -alpha)
        if(score >= top_score):
            top_score = score
            top_move = move
        alpha = max(score, alpha)
        board.pop()
    return top_move

def mid_trade(board, alpha, beta):
    current_score = board_eval(board)

    if current_score >= beta:
        return beta
    alpha = max(alpha, current_score)


    for move in board.legal_moves:
        if board.is_capture(move):
            board.push(move)
            score = -mid_trade(board, -beta, -alpha)
            board.pop()

            if score >= beta:
                return beta
            alpha = max(alpha, score)
    return alpha

def _alpha_beta_endgame(current_depth, board, target_depth, alpha, beta):

    best_score = -10000000

    if(current_depth == target_depth):
        with chess.syzygy.open_tablebase(end_table) as tablebase:
            return tablebase.get_dtz(board)
    for move in board.legal_moves:
        board.push(move)
        score = -_alpha_beta_endgame(current_depth + 1, board, target_depth, -beta, -alpha)
        board.pop()
        if (score >= beta):
            return score
        best_score = max(best_score, score)
        alpha = max(alpha, best_score)
        
    return best_score

def endgame(board):

    best_score = -10000000
    best_move = None

    for move in board.legal_moves:
        board.push(move)
        with chess.syzygy.open_tablebase(end_table) as tablebase:
            score = tablebase.get_dtz(board)
        board.pop()
        if(score > best_score):
            best_score = score
            best_move = move
        
    return best_move

def playGame(board = chess.Board()):

    board = chess.Board()
    player = input("Would you like to play Black or White: ")
    while(player != "Black" and player != "White"):
        print("Invalid Input, try again.") 
        player = input("Would you like to play Black or White: ")
    if (player == "White"):
        while(not board.is_game_over()):
            print("\nWhite's Move:\n")
            print(board)
            player_input = chess.Move.from_uci(input("Enter your move: "))
            while (player_input not in board.legal_moves):
                print("Invalid Move, try again.")
                player_input = chess.Move.from_uci(input("Enter your move: "))
            board.push(player_input)
            if(not board.is_game_over()):
                print("\nBlack's Move:\n")
                move = alpha_beta(board, 4)
                print(move)
                board.push(move)
    else:
        while(not board.is_game_over()):
            print("\nWhite's Move:\n")
            print(board)
            move = alpha_beta(board, 4)
            print(move)
            board.push(move)
            if(not board.is_game_over()):
                print("\nBlack's Move:\n")
                print(board)
                player_input = chess.Move.from_uci(input("Enter your move: "))
                while (player_input not in board.legal_moves):
                    print("Invalid Move, try again.")
                    player_input = chess.Move.from_uci(input("Enter your move: "))
                board.push(player_input)
    print(board)
    print("Game over: " + board.result())
            
def playSelf(board = chess.Board()):
    while(not board.is_game_over()):
        print("\nWhite's Move:\n")
        print(board)
        move = alpha_beta(board, 4)
        print(move)
        board.push(move)
        if(not board.is_game_over()):
            print("\nBlack's Move:\n")
            print(board)
            move = alpha_beta(board, 4)
            print(move)
    print("\nFinal Board:\n")
    print(board)
    print("Game over: " + board.result())

#playGame()
playSelf()

#playSelf(chess.Board('1k2K3/8/3p4/1r6/6B1/8/8/8 w - - 0 1'))

#print(len(board.piece_map()))

#with chess.syzygy.open_tablebase(end_table) as tablebase:
#    board = chess.Board('3k2B1/1r6/3P4/4K3/8/8/8/8 w - - 0 1')
#   print(tablebase.probe_dtz(board))
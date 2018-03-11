class boardConatiner {
  Map<String, String> _board = new Map();
  boardConatiner() {
    createNewBoard();
    print('Created board');
  }

  void createNewBoard() {
    for(int i=0;i<9;i++){
      this._board[i.toString()] = 'empty';
    }
  }

  void setBoard(var newBoard) {
    this._board = newBoard;
  }

  Map<String, String> getBoard() {
    return this._board;
  }

  Map<String,String> makeMove(String position, String player){
    this._board[position.toString()] = player.toString();
    print('Moved at '+position+' by player '+player);
    return this._board;
  }
}
//Board state 2d array holds information of game board.
//Holds objects containing occupied, color, column, row, and div data points
var boardState = new Array(7);
  for (i=0; i < 7; i++) {
    boardState[i] = new Array(6);
  }

/*
  [
    [ 0,  1,  2,  3,  4]
    [ 5,  6,  7,  8,  9]
    [10, 11, 12, 13, 14]
    [15, 16, 17, 18, 19]
    [20, 21, 22, 23, 24]
  ]
*/

var color;
var flag = false;
var hoverSpace;
var hovering;
var scrableSquares = false;
var boardGrowth = false;
var rulesBox = false;
var turn = 'red';     //Turn variable saves color of current player's turn

//Calls BuildBoard when the page first loads
window.onload = function() {
  BuildBoard();
}

//Function swaps the turn variable between black and red between player turns
TurnSwitch = function(square) {
  if (square.type == 'extraTurn'){
    return;
  }
  if (turn == 'red') {
    turn = 'yellow';
    color = '#f6d003';
    document.querySelector('#win').innerText = 'Yellow Player Wins';
    
  }
  else if (turn == 'yellow') {
    turn = 'red';
    color = '#f60e26';
    document.querySelector('#win').innerText = 'Red Player Wins';
  }
  document.querySelectorAll('.swap').forEach(div => {div.style.backgroundColor = color})
}

//Function calls all win checks, determining if current player has won
 WinCheck = function(board) {   
  if(CheckDiagPos(board) || CheckDiagNeg(board) || CheckHorizontal(board) || CheckVertical(board)){
    EnableWinBox();
    return 1;
  }
  return 0;
}

//Function checks if the last piece resulted in a win for current planyer on the vertical
CheckVertical = function(board) {
  let win = 0;
  let count = 1;
  let curentColumn = board.column;
  let curentRow = board.row;
  if (boardState[curentColumn][curentRow].type == 'two'){
    count++;
  }
  
  while(count < 4 && curentRow != 0){
    if (boardState[curentColumn][curentRow - 1].color == turn){
      if(boardState[curentColumn][curentRow - 1].type == 'two'){
        count++;
      }
      
      count++;
      curentRow = curentRow - 1;
    }
    else{
      break;
    }
  }
  curentRow = board.row;
  while(count < 4 && curentRow != (boardState[0].length - 1)) {
    if (boardState[curentColumn][curentRow + 1].color == turn){
      if(boardState[curentColumn][curentRow + 1].type == 'two'){
        count++;
      }
      count++;
      curentRow = curentRow + 1;
    }
    else {
      break;
    }
  }
  if (count >= 4){
    win = 1;
  }
  return win;
}

//Function checks if the last piece resulted in a win for current player on the horizontal
CheckHorizontal = function(board) {
  let win = 0;
  let count = 1;
  let curentColumn = board.column;
  let curentRow = board.row;
  if (boardState[curentColumn][curentRow].type == 'two'){
    count++;
  }
  while(count < 4 && curentColumn != 0){
    if (boardState[curentColumn - 1][curentRow].color == turn){
      if(boardState[curentColumn - 1][curentRow].type == 'two'){
        count++;
      }
      count++;
      curentColumn = curentColumn - 1;
    }
    else {
      break;
    }
  }
  curentColumn = board.column;
  while(count < 4 && curentColumn != (boardState.length - 1)) {
    if (boardState[curentColumn + 1][curentRow].color == turn){
      if(boardState[curentColumn + 1][curentRow].type == 'two'){
        count++;
      }
      count++;
      curentColumn = curentColumn + 1;
    }
    else {
      break;
    }
  }
  if (count >= 4){
    win = 1;
  }
  return win;
}

//Function checks if the last piece resulted in a win for current player on the negative slope diagonal
CheckDiagNeg = function(board) {
  let win = 0;
  let count = 1;
  let curentColumn = board.column;
  let curentRow = board.row;
  if (boardState[curentColumn][curentRow].type == 'two'){
    count++;
  }
  while(count < 4 && curentColumn != (boardState.length - 1) && curentRow != (boardState[0].length - 1)){
    if (boardState[curentColumn + 1][curentRow + 1].color == turn){
      if(boardState[curentColumn + 1][curentRow + 1].type == 'two'){
        count++;
      }
      count++;
      curentColumn = curentColumn + 1;
      curentRow = curentRow + 1;
    }
    else{
      break;
    }
  }
  curentColumn = board.column;
  curentRow = board.row;
  while(count < 4  && curentColumn != 0 && curentRow != 0) {
    if (boardState[curentColumn - 1][curentRow - 1].color == turn){
      if(boardState[curentColumn - 1][curentRow - 1].type == 'two'){
        count++;
      }
      count++;
      curentColumn = curentColumn - 1;
      curentRow = curentRow - 1;
    }
    else {
      break;
    }
  }
  if (count >= 4){
    win = 1;
  }
  return win;
}

//Function checks if the last piece resulted in a win for current player on the positive slope diagonal
CheckDiagPos = function(board) {
  let win = 0;
  let count = 1;
  let curentColumn = board.column;
  let curentRow = board.row;
  if (boardState[curentColumn][curentRow].type == 'two'){
    count++;
  }
  while(count < 4 && curentColumn != (boardState.length - 1) && curentRow != 0){
    if (boardState[curentColumn + 1][curentRow - 1].color == turn){
      if(boardState[curentColumn + 1][curentRow - 1].type == 'two'){
        count++;
      }
      count++;
      curentColumn = curentColumn + 1;
      curentRow = curentRow - 1;
    }
    else{
      break;
    }
  }
  curentColumn = board.column;
  curentRow = board.row;
  while(count < 4 && curentColumn != 0 && curentRow != (boardState[0].length - 1)) {
    if (boardState[curentColumn - 1][curentRow + 1].color == turn){
      if(boardState[curentColumn - 1][curentRow + 1].type == 'two'){
        count++;
      }
      count++;
      curentColumn = curentColumn - 1;
      curentRow = curentRow + 1;
    }
    else {
      break;
    }
  }
  
  if (count >= 4){
    win = 1;
  }
  return win;
}

//On click of a div, this function will drop a piece into the bottom most div of the column clicked. The checks if the game has been won, then swaps to opposite player's turn
Select = function(column, row) {
  try{
    let i = 0;
    for (i = (boardState[0].length - 1); i >= 0; i--) {
      if (boardState[column][i].occupied == 0) {
        flag = true;
        var temp = hovering;
        hovering = null;
        temp.style.top = 50*(i+1) + 'px';
        setTimeout(() => { 
          boardState[column][i].div.appendChild(temp);
          temp.style.left = '0px';
          temp.style.top = '0px';
          //temp = null;
          boardState[column][i].color = turn;
          boardState[column][i].occupied = 1;
          if(WinCheck(boardState[column][i])) {
           return;
          }

          if(boardGrowth){
            //Expand Board Left
            if (column == 0){
              AddLeft()
            }
            //Expand Board Right
            if (column == boardState.length - 1){
              AddRight()
            }

            //Expand Board Vertically
            if (i == 0){
              AddTop()
            }
          }

          TurnSwitch(boardState[column][i]);
          
          DelHoverPuck(boardState[column][i]);
             
        } , 200);
        flag = false;
        
        break;
      }  
    }
  }
  catch(err){}
}

AddTop = function(){
  //Shift everyting in boardState down 1
  for (a = boardState.length-1; a >= 0; a--){
    for (b = boardState[0].length-1; b >= 0; b--){
      boardState[a][b+1] = boardState[a][b];
      boardState[a][b+1].row += 1;
      boardState[a][b+1].div.style.top = 50*(boardState[a][b+1].row+1) + 'px';
    }
  }
  //Insert new row of divs at top of boardState
  for (j = 0; j <= boardState.length-1; j++){
    this.div = document.createElement('div');
    document.querySelector('#game-board').appendChild(this.div);
    this.div.className = "box";
    let square = {occupied: 0, color: null, type: null, column: j, row: 0, div: this.div};
    this.div.style.left = 50*square.column + 'px';
    this.div.style.top = 50*(square.row+1) + 'px';
    this.div.addEventListener("click", function(){Select(square.column, square.row);});
    this.div.addEventListener("mouseenter", function(){HoverPuck(square);});
    this.div.addEventListener("mouseout", function(){DelHoverPuck(square);});
    boardState[square.column][square.row] = square;  
    if (scrableSquares == true){
      BuildFeatures(square);
    }
    if (square.column == 0) {
      this.div.style.clear = 'both';
    }
  }
  
}

AddLeft = function(){
  //Shift everyhing in boardState right one space
  hoverSpace.style.width = 50*(boardState.length+1) + 'px';
  boardState.push(new Array(boardState[0].length));
  for (a = boardState.length-2; a >= 0; a--){
    for (b = boardState[0].length-1; b >= 0; b--){
      boardState[a+1][b] = boardState[a][b];
      boardState[a+1][b].column = a+1;
      boardState[a+1][b].div.style.left = 50*boardState[a+1][b].column + 'px';

    }
  }
  //Add new collumn of divs on left side of boardState 
  for (j = 0; j <= boardState[0].length-1; j++){
    this.div = document.createElement('div');
    document.querySelector('#game-board').appendChild(this.div);
    this.div.className = "box";
    let square = {occupied: 0, color: null, type: null, column: 0, row: j, div: this.div};
    this.div.style.left = 50*square.column + 'px';
    this.div.style.top = 50*(square.row+1) + 'px';
    this.div.addEventListener("click", function(){Select(square.column, square.row);});
    this.div.addEventListener("mouseenter", function(){HoverPuck(square);});
    this.div.addEventListener("mouseout", function(){DelHoverPuck(square);});
    if (scrableSquares == true){
      BuildFeatures(square);
    }
    boardState[square.column][square.row] = square;

    
  }
  
}

AddRight = function(){
  hoverSpace.style.width = 50*(boardState.length+1) + 'px';
  boardState.push(new Array(boardState[0].length));
  for (j = boardState[0].length-1; j >= 0; j--){
    this.div = document.createElement('div');
    document.querySelector('#game-board').appendChild(this.div);
    
    this.div.className = "box";
    let square = {occupied: 0, color: null, type: null, column: boardState.length-1, row: j, div: this.div};
    this.div.style.left = 50*square.column + 'px';
    this.div.style.top = 50*(square.row+1) + 'px';
    this.div.addEventListener("click", function(){Select(square.column, square.row);});
    this.div.addEventListener("mouseenter", function(){HoverPuck(square);});
    this.div.addEventListener("mouseout", function(){DelHoverPuck(square);});
    if (scrableSquares == true){
      BuildFeatures(square);
    }
    boardState[square.column][square.row] = square;        
  }    
  
}

//Function populates boardState 2d array, and builds the div's for the game board
BuildBoard = function() {
  
  hoverSpace = document.createElement('div');
  hoverSpace.className = "box";
  hoverSpace.style.width = '350px';
  hoverSpace.style.height = '50px';
  document.querySelector('#game-board').appendChild(hoverSpace);
  
  for (row = 0; row < 6; row++) {
      for (column = 0; column < 7; column++){
        this.div = document.createElement('div');
        let square = {occupied: 0, color: null, type: null, column: column, row: row, div: this.div};
        this.div.className = "box";
        this.div.style.left = 50*square.column + 'px';
        this.div.style.top = 50*(square.row+1) + 'px';
        document.querySelector('#game-board').appendChild(this.div);
        if (scrableSquares == true){
          BuildFeatures(square);
        }
        this.div.addEventListener("click", function(){Select(square.column, square.row);});
        this.div.addEventListener("mouseenter", function(){HoverPuck(square);});
        this.div.addEventListener("mouseout", function(){DelHoverPuck(square);});
        boardState[column][row] = square;        
      }
  }
}

HoverPuck = function(board){
  hovering = document.createElement('div');
  hovering.className = 'puck ' + turn;
  hoverSpace.appendChild(hovering);
  hovering.style.left = 50*board.column + 'px';
}

DelHoverPuck = function(board){
  try{
    hovering.remove();

  }
  catch(err){} 
} 

EnableBoardGrowth = function(){
  if (boardGrowth){
    boardGrowth = false;
    document.querySelector('#boardGrowth').style.backgroundColor = '#f60e26';
    
  }
  else{
    boardGrowth = true;
    document.querySelector('#boardGrowth').style.backgroundColor = '#173885';
  }
}

EnableScrableSquares = function(){
  if (scrableSquares){
    scrableSquares = false;
    document.querySelector('#scrableSquares').style.backgroundColor = '#f60e26';
    
  }
  else{
    scrableSquares = true;
    document.querySelector('#scrableSquares').style.backgroundColor = '#173885';
  }  
  
}

EnableRulesBox = function(){
  if(rulesBox){
    rulesBox = false;
    document.querySelector('#rulesBox').style.opacity = '0';
    document.querySelector('#rulesBox').style.zIndex = '-100000';
    document.querySelector('#rulesButton').style.backgroundColor = '#f60e26';
    
  }
  else{
    rulesBox = true;
    document.querySelector('#rulesButton').style.backgroundColor = '#173885';
    document.querySelector('#rulesBox').style.opacity = '1';
    document.querySelector('#rulesBox').style.zIndex = '100001';
  }
}

EnableWinBox = function(){
    document.querySelector('#win').style.opacity = '1';
    document.querySelector('#win').style.zIndex = '100000';
}

ReBuildBoard = function() {
  document.querySelector('#win').style.opacity = '0';
  document.querySelector('#win').style.zIndex = '-100000';
  hoverSpace.remove();
  for (a = boardState.length-1; a >= 0; a--){
    for (b = boardState[0].length-1; b >= 0; b--){
      boardState[a][b].div.remove()
      
    }
  }
  boardState = new Array(7);
  for (i=0; i < 7; i++) {
    boardState[i] = new Array(6);
  }
  BuildBoard();
}

BuildFeatures = function(square) {
  
  let random = Math.floor(Math.random()*100);
  
  if (random < 6) {
    square.type = 'extraTurn';
    square.div.style.backgroundColor = '#f2337b';
  }
  else if (random < 11) {
    square.type = 'two';
    square.div.style.backgroundColor = '#077ddf';
  }
  else if (random < 16) {
    square.occupied = 1;
    square.type = 'both';
    square.div.style.backgroundColor = '#40a53d';
    this.div = document.createElement('div');
    square.div.appendChild(this.div);
    square.color = turn;
    this.div.className = 'puck swap';
  }
  //Spot for nobody
  else if (random < 21) {
    square.occupied = 1;
    square.type = 'none';
    this.div = document.createElement('div');
    square.div.appendChild(this.div);
    square.color = 'grey';
    this.div.className = 'puck';
    this.div.style.backgroundColor = 'grey';
  }
}
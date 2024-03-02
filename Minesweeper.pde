import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_BOMBS = 15;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++){
      for (int c = 0; c < NUM_ROWS; c++)
        buttons[r][c] = new MSButton(r, c);
    }
    
    
    setMines();
}
public void setMines()
{
    while (mines.size() < NUM_BOMBS){
      int r = (int)(Math.random()*NUM_ROWS);
      int c = (int)(Math.random()*NUM_COLS);
      if (!mines.contains(buttons[r][c])){
        mines.add(buttons[r][c]);
      }
    }
}

public void draw ()
{
    background( 0 );
}
public boolean isWon()
{
    boolean won = true;
    for(int r = 0; r < NUM_ROWS; r++){
      for (int c = 0; c < NUM_ROWS; c++){
        if (!buttons[r][c].isClicked() && !mines.contains(buttons[r][c])){
          won = false;
          break;
        }
      }
    }
    return won;
}
public void displayLosingMessage()
{
    for(int r = 0; r < NUM_ROWS; r++){
      for (int c = 0; c < NUM_ROWS; c++){
        buttons[r][c].lose();
      }
    }
}
public void displayWinningMessage()
{
    for(int r = 0; r < NUM_ROWS; r++){
      for (int c = 0; c < NUM_ROWS; c++){
        buttons[r][c].win();
      }
    }
}
public boolean isValid(int r, int c)
{
    if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) return true;
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for (int i = -1; i < 2; i++){
      for (int j = -1; j < 2; j++){
        if (isValid(row + i, col + j) && mines.contains(buttons[row + i][col + j]) && !(i == 0 && j == 0))
          numMines++;
      }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        if (mouseButton == RIGHT && !clicked){
          flagged = !flagged;
          if (flagged == false);
        }
        else {
          clicked = true;
          if (mines.contains(this))
            displayLosingMessage();
          else if (isWon() == true){
            displayWinningMessage(); 
          }
          else if (countMines(this.myRow, this.myCol) > 0)
            myLabel = String.valueOf(countMines(this.myRow, this.myCol));
          else {
            for (int i = -1; i < 2; i++){
              for (int j = -1; j < 2; j++){
                if (isValid(this.myRow + i, this.myCol + j) && !(i == 0 && j == 0) && !buttons[this.myRow + i][this.myCol + j].isClicked()){
                  buttons[this.myRow + i][this.myCol + j].mousePressed();
                }
              }
            }
          }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );
        rect(x, y, width, height);
        fill(0);
        text(myLabel, x+width/2, y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = String.valueOf(newLabel);
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    public void win()
    {
        clicked = false;
        flagged = false;
        String message = new String("YOUWON!");
        if (myRow == 0 && myCol < 3) setLabel(message.substring(myCol, myCol + 1));
        else if (myRow == 1 && myCol < 4) setLabel(message.substring(myCol + 3, myCol + 4));
        else setLabel("");
    }
    public void lose()
    {
        clicked = false;
        flagged = false;
        String message = new String("YOULOSE!");
        if (myRow == 0 && myCol < 3) setLabel(message.substring(myCol, myCol + 1));
        else if (myRow == 1 && myCol < 5) setLabel(message.substring(myCol + 3, myCol + 4));
        else setLabel("");
    }
}

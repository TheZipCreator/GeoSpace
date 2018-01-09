PImage[] tiles = new PImage[1]; //The tile textures in the game
PImage[] player = new PImage[2]; //The player images or animations
PImage cplayer; //Current player image
PVector pos; //Player Position
PVector vel; //Player Velocity
PVector acc; //Player Acceleration
PVector dir; //Player Moving Direction
int[][] world; //The world
int wx = 200; //World X-Size
int wy = 1000; //World Y-Size
int bs; //Block size
float noiseScale = 0.05; //The noise scale
float grav = 0.05; //The gravity
float speed = 5; //Player Speed
float deltaTime = 0; //Time between frames
float lastMillis = 0; //For deltaTime


void setup() {
  tiles[0] = loadImage("sand.png"); //Load the textures
  player[0] = loadImage("temp_player_r.png"); //Load the player images
  player[1] = loadImage("temp_player_l.png");
  player[0].resize(16, 32); //Resize the player images
  player[1].resize(16, 32);
  cplayer = player[0];
  pos = new PVector(0, 0); //Set the player pos, acc and vel
  vel = new PVector(0, 0);
  acc = new PVector(0, 0);
  dir = new PVector(0, 0);
  world = new int[wx][wy];
  for(int x = 0; x < wx; x++) { //Initialize the world
    for(int y = 0; y < wy; y++) {
      world[x][y] = 0;
    }
  }
  for(int x = 0; x < wx; x++) { //Generate terrain
    int noiseVal = floor(noise(x*noiseScale)*20);
    world[x][noiseVal] = 1;
    for(int i = wy-1; i > noiseVal; i--) { //Fill the blocks under the current block
      world[x][i] = 1; 
    }
  }
}
void settings() {
  //fullScreen();
  size(800, 600);
}
void draw() {
  background(200, 200, 0);
  deltaTime = millis()-lastMillis;
  for(int x = 0; x < wx; x++) { //Loop through all the blocks
    for(int y = 0; y < wy; y++) {
      if(world[x][y] > 0) { //If there is something there
        image(tiles[world[x][y]-1], x*16, y*16); // Then draw it
      }
    }
  }
  image(cplayer, pos.x, pos.y); //Render the player
  int gpx = floor(pos.x/16); //Calculate the grid positions
  int gpy = floor(pos.y/16);
  //println(pos.x, pos.y, gpx, gpy, world[gpx][gpy]);
  if(world[gpx][gpy+2] == 0) {
    acc.y += grav; //Apply gravity
  } else {
    if(vel.y > 0) {
      vel.y = 0;
    }
  }
  //fill(255, 0, 0, 128);
  //rect(gpx*16, gpy*16, 16, 16);
  if(world[gpx][gpy+1] != 0) {
    pos.y -= 16;
  }
  pos.add(vel); //Do physics
  vel.add(acc);
  acc.mult(0.9); //Because air resistance
  pos.add(dir); //Move player
  println(deltaTime);
  lastMillis = millis();
}
void keyPressed() {
  if(key == 'd') {
    dir.x = speed;
    cplayer = player[0];
  }
  if(key == 'a') {
    dir.x = -speed;
    cplayer = player[1];
  }
}
void keyReleased() {
  if(key == 'd') {
    dir.x = 0;
  }
  if(key == 'a') {
    dir.x = 0;
  }
}
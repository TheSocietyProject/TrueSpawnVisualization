
/*
  // TODO load coords
  // TODO set maxCoord to maxCoord in pic
  -maybe rem cross?
  
*/



public String getPath(){
  return android.os.Environment.getExternalStoragePublicDirectory(android.os.Environment.DIRECTORY_DCIM).getParentFile().getAbsolutePath() + 
  "/CODING/trueSpawn/";
}



float xOffset, zOffset;

String path = "";


float zoom;
float yTranslate;

PImage bg;

float halfW;


boolean line = true;

float maxCoord;

float[] xCoord, zCoord, yCoord;

float[] pos = new float[]{
  0,
  100
};

int[] cols = new int[]{
  color(248, 248, 100, 128),
  color(255, 100, 100, 255)
};

float minX, minY, minZ, maxX, maxY, maxZ,
      nDist, nY,  distMedian, yMedian,
      xMid, zMid;
      
int n;


void setup(){
  //fullScreen();
  size(displayWidth, displayWidth, P3D);
  halfW = width / 2.0;
  
  path = getPath();
  
  xOffset = 0 * 16.0; // x chunks
  zOffset = 0 * 16.0;
  
  // was 3, -5.5
  
  
  //xOffset = translate(xOffset);
  //zOffset = translate(zOffset);
  
  try{
    bg = loadImage(path + "bg.png");
  } catch(Exception e){
    bg = null;
    println("error");
  }
  if(bg == null){
    bg = createImage(1, 1, RGB);
  }
  
  maxCoord = 1000;// TODO set to max block of pic
  
  zoom = halfW / 3.0; // 3.0
  yTranslate = 7.0 * halfW / 9.0;
  
  //loadRandomCoords();
  
  loadCoords();
  
  
  noLoop();
}


public void prepareMinMax(){
  maxX = 0;
  maxY = 0;
  maxZ = 0;
  
  minX = maxCoord;
  minY = 256;
  minZ = maxCoord;
  
  nDist = 0;
  nY = 0;
  n = 0;
  
  
  xMid = 0;
  zMid = 0;
}

public void loadCoords(){
  prepareMinMax();
  
  String[] info;
  try{
    info = loadStrings(path + "coords.txt");
  }catch(Exception e){
    info = null;
  }
  if(info == null){
    info = new String[0];
  }
  
  int len = info.length;
  println(len);
  xCoord = new float[len];
  zCoord = new float[len];
  yCoord = new float[len];
  
  float[] dist = new float[len];
  
  String[] sp;
  for(int i = 0; i < len; i ++){
    sp = info[i].split(" ");
    xCoord[i] = Float.parseFloat(sp[1]);
    yCoord[i] = Float.parseFloat(sp[2]);
    zCoord[i] = Float.parseFloat(sp[3]);
    
    dist[i] = dist(xCoord[i], zCoord[i]);
    
    minMax(xCoord[i], yCoord[i], zCoord[i]);
    xMid += xCoord[i];
    zMid += zCoord[i];
    
  }
  
  // TODO make max and stuff here...
  
  yMedian = sort(yCoord)[yCoord.length / 2];
  distMedian = sort(dist)[dist.length / 2];
  
  xMid /= n;
  zMid /= n;
  
}

public void loadRandomCoords(){
  int len = 1000;
  xCoord = new float[len];
  zCoord = new float[len];
  yCoord = new float[len];
  float r;
  float alpha;
  for(int i = 0; i < xCoord.length; i ++){
    alpha = random(360);
    r = random(maxCoord);
    
    xCoord[i] = r * cos(alpha);
    zCoord[i] = r * sin(alpha);
    
    yCoord[i] = random(256.0 * (maxCoord - r) / maxCoord);
  }
}

boolean first;

void draw(){
  background(0);
  
  
  
  translate(halfW, yTranslate, -zoom);
  
  rotateX(PI / 8.0); // was PI/8.0
  rotateZ(PI / 32.0);
  
  //println(xOffset + " " + maxCoord);
  image(bg, -translate(bg.width / 2.0 - xOffset), -translate(bg.height / 2.0 - zOffset), translate(bg.width), translate(bg.height));
  renderCross();
  rectMode(CENTER);
  
  
  
  renderPos();
  
  
  rotateZ(-PI / 32.0);
  rotateX(-PI / 8.0);
  translate(-halfW, -yTranslate, zoom);
  
  
  fill(255);
  
  String txt;
  float xPos = halfW / 12.0;
  float yPos = 2.0 * textAscent();
  
  
  txt = "distance to 0 0";
  text(txt, xPos, yPos);
  yPos += 2.0 * textAscent();
  
  txt = "min: " + dist(minX, minZ);
  text(txt, xPos, yPos);
  yPos += 2.0 * textAscent();
  
  txt = "avg: " + (nDist / n);
  text(txt, xPos, yPos);
  yPos += 2.0 * textAscent();
  
  txt = "median: " + distMedian;
  text(txt, xPos, yPos);
  yPos += 2.0 * textAscent();
  
  txt = "max: " + dist(maxX, maxZ);
  text(txt, xPos, yPos);
  yPos += 4.0 * textAscent();
  
  
  txt = "middle (x: " + xMid + " z: " + zMid + ")";
  text(txt, xPos, yPos);
  yPos += 2.0 * textAscent();
  
  txt = "respawns: " + n;
  text(txt, xPos, yPos);
  yPos += 2.0 * textAscent();
  
  
  
  yPos = height - 7 * 2.0 * textAscent();
  
  
  txt = "y coordinate";
  text(txt, xPos, yPos);
  yPos += 2.0 * textAscent();
  
  txt = "min: " + minY;
  text(txt, xPos, yPos);
  yPos += 2.0 * textAscent();
  
  txt = "avg: " + (nY / n);
  text(txt, xPos, yPos);
  yPos += 2.0 * textAscent();
  
  txt = "median: " + yMedian;
  text(txt, xPos, yPos);
  yPos += 2.0 * textAscent();
  
  txt = "max: " + maxY;
  text(txt, xPos, yPos);
  yPos += 2.0 * textAscent();
  
  
  if(mousePressed){
    //loadRandomCoords();
    maxCoord += mouseX - width / 2.0;
  }
  
  
  if(!first){
    first = true;
    saveFrame(path + "result.png");
  }
}

public void renderPos(){
  lastX = 0;
  lastY = 0;
  lastZ = 0;
  beginShape(LINES);
  for(int i = 0; i < xCoord.length && i < zCoord.length; i ++){
    col(convertColor(100.0 * i / xCoord.length));
    //renderPos(convertColor(100.0 * i / xCoord.length), xCoord[i], zCoord[i]);
    renderVertex(xCoord[i], yCoord[i], zCoord[i]);
    //vertex(x*scl, y*scl, terrain[x][y]);
    //vertex(x*scl, (y+1)*scl, terrain[x][y+1]);
    
    last(i);
  }
  
  endShape();
}


float lastX, lastY, lastZ;


public void col(int col){
  fill(col);
  stroke(col);
}



public void renderVertex(float x, float y, float z){
  
  //vertex(lastX, lastZ, lastY);
  x = translate(x);
  z = translate(z);
  y = translate(y) / 2.0;
  vertex(x, z, 0);
  vertex(x, z, y);
  
}


public void minMax(float xC, float yC, float zC){
  if(dist(xC, zC) < dist(minX, minZ)){
    minX = xC;
    minZ = zC;
  }
  
  if(yC < minY){
    minY = yC;
  }
  
  if(dist(xC, zC) > dist(maxX, maxZ)){
    maxX = xC;
    maxZ = zC;
  }
  
  if(yC > maxY){
    maxY = yC;
  }
  
  
  nDist += dist(xC, zC);
  nY += yC;
  
  n ++;
}


public void last(int i){
  lastX = translate(xCoord[i]);
  lastY = translate(yCoord[i]);
  lastZ = translate(zCoord[i]);
}



public void renderCross(){
  stroke(convertColor(100), 128);
  
  float size = 1000;
  line(-translate(size), 0, translate(size), 0);
  line(0, -translate(size), 0, translate(size));
  
  fill(256);
  //ellipse(xOffset, zOffset, translate(2.0 * size), translate(2.0 * size));
  
}

public int convertColor(float val){
  return convertColor(val, pos, cols);
}

public int convertColor(float value, float[] pos, int[] cols){
  for(int i = 1; i < pos.length; i ++){
    if(value < pos[i]){
      int down = cols[i - 1];
      int up = cols[i];
      float dif = (value - pos[i - 1]) / (pos[i] - pos[i - 1]);
      
      int c = color(
        red(down) + dif * (red(up) - red(down)),
        green(down) + dif * (green(up) - green(down)),
        blue(down) + dif * (blue(up) - blue(down)),
        alpha(down) + dif * (alpha(up) - alpha(down)));
      return c;
    }
  }
  return cols[cols.length - 1];
}


public float dist(float a, float b){
  return sqrt(a * a + b * b);
}

public float translate(float pos){
  if(maxCoord == 0){
    return pos * halfW;
  }
  return  pos * halfW / maxCoord;
}


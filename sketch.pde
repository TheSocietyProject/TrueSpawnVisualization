

public void initChangeable(){
  maxCoord = 2124 + 128;// TODO set to max block of pic
  
  
}

float distSumLen = 32; // always changeable
// 32 was good for 1024. 64 is good for 2048?


float transparency = 200;


int[] cols = new int[]{
  color(231, 149, 22),
  color(96, 96, 200),
  color(121, 35, 147)
};




//------------

public String getPath(){
  return android.os.Environment.getExternalStoragePublicDirectory(android.os.Environment.DIRECTORY_DCIM).getParentFile().getAbsolutePath() + 
  "/CODING/trueSpawn/";
}




float xOffset, zOffset;

String path = "";


float zoom;
float yTranslate, xTranslate;

PImage bg;

float halfW;


boolean line = true;

float maxCoord;

int len;


float[] pos = new float[]{
  0,
  100
};



float minDist, maxDist,
      minY, maxY,
      nDist, nY,
      distMedian, yMedian,
      xMid, zMid;
      
int n;

void settings(){
  //size((int) (0.6 * 1920), (int) (0.6 * 1080), P3D);
  fullScreen();
  
}


void setup(){
  // 1920 1080
  // 960 540
  initChangeable();
  
  
  halfW = height / 2.0;
  
  path = getPath();
  
  textSize(height / 55.0);
  
  // in case the bg isnt centered
  xOffset = 0 * 16.0; // x chunks
  zOffset = 0 * 16.0;
  
  try{
    bg = loadImage(path + "bg.png");
  } catch(Exception e){
    bg = null;
    println("error");
  }
  
  if(bg == null){
    try{
      bg = loadImage(path + "map.png");
    } catch(Exception e){
      bg = null;
      println("error");
    }
  }
  
  if(bg == null){
    bg = createImage(1, 1, RGB);
  }
  
  
  zoom = halfW / 2.0; // 3.0
  //yTranslate = 7.0 * halfW / 9.0;
  //xTranslate = halfW / 1.3;
  
  yTranslate = halfW;
  xTranslate = halfW;
 // zoom = 0;
  
  loadCoords();
  
  
 // noLoop();
}


public void prepareMinMax(){
  maxDist = 0;
  maxY = 0;
  
  minDist = maxCoord;
  minY = 256;
  
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
  
  len = info.length;
  println("file length: " + len);
  entries = new Entry[len];
  setInd = 0;
  
  float[] dist = new float[len];
  float[] yLvl = new float[len];
  
  Entry e;
  
  String[] sp;
  for(int i = 0; i < len; i ++){
    sp = info[i].split(" ");
    
    e = new Entry(sp[0], Float.parseFloat(sp[1]), Float.parseFloat(sp[2]), Float.parseFloat(sp[3]), i);
    add(e);
    
    dist[i] = e.dist();
    yLvl[i] = e.y;
    
    nDist += e.dist();
    nY += e.y;
    
    n ++;
    
    xMid += e.x; // needs orig scale
    zMid += e.z;
    
  }
  
  calcDistSum();
  
  nDist /= (float) n;
  nY /= (float) n;
  
  yLvl = sort(yLvl);
  minY = yLvl[0];
  yMedian = yLvl[yLvl.length / 2];
  maxY = yLvl[yLvl.length - 1];
  
  dist = sort(dist);
  minDist = dist[0];
  distMedian = dist[dist.length / 2];
  maxDist = dist[dist.length - 1];
  
  xMid /= (float) n;
  zMid /= (float) n;
  
}


boolean first;

void draw(){
  background(0);
  translate(xTranslate, yTranslate);
  
  //rotateX(PI / 8.0); // was PI/8.0
  //rotateZ(PI / 32.0);
  
  tint(255, transparency);
  image(bg, -translate(bg.width / 2.0 - xOffset), -translate(bg.height / 2.0 - zOffset), translate(bg.width), translate(bg.height));
  //renderCross();
  //rectMode(CENTER);
  
  renderPos();
  
  
  //rotateZ(-PI / 32.0);
  //rotateX(-PI / 8.0);
  translate(-xTranslate, -yTranslate);
  
  float txtPos = 20;
  
  translate(txtPos, 0);
  
  fill(255);
  
  String txt;
  
  
  float yPos = 2.0 * textAscent();
  
  
  txt = "middle (x: " + xMid + " z: " + zMid + ")";
  text(txt, 0, yPos);
  yPos += 2.0 * textAscent();
  
  txt = "respawns: " + n;
  text(txt, 0, yPos);
  yPos += 4.0 * textAscent();
  
  
  
  txt = "distance to 0 0";
  text(txt, 0, yPos);
  yPos += 2.0 * textAscent();
  
  txt = "min: " + minDist; // entries[0].dist()
  text(txt, 0, yPos);
  yPos += 2.0 * textAscent();
  
  txt = "avg: " + nDist;
  text(txt, 0, yPos);
  yPos += 2.0 * textAscent();
  
  txt = "median: " + distMedian;
  text(txt, 0, yPos);
  yPos += 2.0 * textAscent();
  
  txt = "max: " + maxDist;
  text(txt, 0, yPos);
  yPos += 4.0 * textAscent();
  
  
  
  
  
  yPos = height - 7 * 2.0 * textAscent();
  
  
  txt = "y coordinate";
  text(txt, 0, yPos);
  yPos += 2.0 * textAscent();
  
  txt = "min: " + minY;
  text(txt, 0, yPos);
  yPos += 2.0 * textAscent();
  
  txt = "avg: " + nY;
  text(txt, 0, yPos);
  yPos += 2.0 * textAscent();
  
  txt = "median: " + yMedian;
  text(txt, 0, yPos);
  yPos += 2.0 * textAscent();
  
  txt = "max: " + maxY;
  text(txt, 0, yPos);
  yPos += 2.0 * textAscent();
  
  
  
  float xPos = width / 2.0;
  yPos = 8.0 * height / 9.0;
  fill(cols[1]);
  txt = "how many respawns with the same distance from 0 0 with a range of " + distSumLen;
  text(txt, xPos, yPos);
  yPos += 2.0 * textAscent();
  
  
  fill(cols[0]);
  txt = "height and average height relative to distance with same range as above";
  text(txt, xPos, yPos);
  yPos += 2.0 * textAscent();
  /*
  txt = "most respawns with about the same distance from 0 0: " + distSumMax;
  text(txt, xPos, yPos);
  
*/
  
  
  translate(-txtPos, 0, 0);
  
  translate(width / 2.0 + 1.5 * txtPos, height - height / 32.0);
  
  renderGraph(width / 2.0, height / 1.1);
  //------------
  
  if(mousePressed){
    // for debugging
    distSumLen += (mouseX - width / 2.0) / 4.0;
    calcDistSum();
  }
  
  
  if(!first){
    first = true;
    // to export the resulting img
    saveFrame(path + "result.png");
  }
}




public void renderPos(){
  
  //beginShape(LINES);
  
  renderVertex();
  
  
 // endShape();
}

public void col(int col){
  fill(col);
  stroke(col);
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




public float translate(float pos){
  if(maxCoord == 0){
    return pos * halfW;
  }
  return  pos * halfW / maxCoord;
}


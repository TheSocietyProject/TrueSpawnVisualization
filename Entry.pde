


// ìnd 0 has smallest dist

Entry[] entries;
int setInd;


int distSumMax;
float heightAvgMax;

public void calcDistSum(){
  distSumMax = 0;
  heightAvgMax = 0;
  HdRv cur;
  for(int i = 0; i < entries.length; i ++){
    cur = entries[i].calcDistSumLen(i, distSumLen / 2.0);
    if(cur.sum > distSumMax){
      distSumMax = cur.sum;
    }
    
    if(cur.heightAvg > heightAvgMax)
      heightAvgMax = cur.heightAvg;
    
  }
  
  
}

public void renderGraph(float xSize, float ySize){
  
  for(int i = 0; i < entries.length; i ++){
    if(i > 0)
      entries[i].renderGraph(entries[i - 1], xSize, ySize);
    
    entries[i].renderPoint(xSize, ySize);
    
  }
  
  
}


public void renderVertex(){
  
  for(int i = 0; i < entries.length; i ++){
    entries[i].renderVertex();
  }
}

public void add(Entry toAdd){
  int i = 0;
  
  
  while(i < setInd){
    if(toAdd.dist() < entries[i].dist()){
      Entry extra;
      Entry zw = entries[i];
      entries[i] = toAdd;
      i ++;
      
      for( ; i < setInd; i ++){
        extra = entries[i];
        entries[i] = zw;
        zw = extra;
        
      }
      
      entries[i] = zw;
      setInd ++;
      
      return;
    }
    
    
    i ++;
  }
  
  // if is here its at the end
  entries[i] = toAdd;
  
  setInd ++;
}





public class Entry{
  
  public int distSum;
  public float heightAvg;
  
  public String time;
  public float x, y, z;
  
  int xol;
  
  public Entry(String time, float x, float y, float z, int i){
    this.time = time;
    this.x = x;
    this.y = y;
    this.z = z;
    
  //this.xol = convertColor(100.0 * i / len);
    this.xol = cols[2];// TODO this has to be changed
  }
  
  
  
  
  public float dist(){
    return dist(x, z);
  }
  
  
  public float x(){
    return translate(x);
  }
  
  public float y(){
    return translate(y);
  }
  
  public float z(){
    return translate(z);
  }
  
  
  
  
  
  
  
  
  public void renderVertex(){
    col(xol);
    float size = 0.75;
    ellipse(x(), z(), size, size);
    //vertex(x(), z(), 0);
    //vertex(x(), z(), y() / 2.0);
    
    
  }
  
  
  
  public float dist(float a, float b){
    return sqrt(a * a + b * b);
  }
  
  
  public void renderGraph(Entry last, float xSize, float ySize){
    stroke(cols[1]);
    line(xSize * last.dist() / maxCoord,
      -ySize * last.distSum / distSumMax,
      xSize * this.dist() / maxCoord,
      -ySize * this.distSum / distSumMax
      );
    
      
    stroke(cols[0]);
    line(xSize * last.dist() / maxCoord,
      -ySize * last.heightAvg / 255.0,
      xSize * this.dist() / maxCoord,
      -ySize * this.heightAvg / 255.0
      );
    
      
    
  }
  
  public void renderPoint(float xSize, float ySize){
    col(cols[0]);
    point(xSize * this.dist() / maxCoord, -ySize * this.y / 255.0);
    // smh y has to be multiplied by 2...
  }
  
 
 
 public HdRv calcDistSumLen(int i, float dist){
    HdRv rV = addDistSum(false, i, this.dist() - dist, new HdRv());
    //if(i + 1 < entries.length)
    rV = entries[i].addDistSum(true, i, this.dist() + dist, rV);
    rV.heightAvg /= rV.sum;
    
    rV.sum -= 3; // so 0 is the lowest
    this.distSum = rV.sum;
    this.heightAvg = rV.heightAvg;
    
    return rV;
  }
  
  public HdRv addDistSum(boolean bigger, int i, float maxDist, HdRv rV){
    rV.sum ++;
    rV.heightAvg += y;
    if(bigger){
      i ++;
      if(this.dist() > maxDist || i >= entries.length)
        return rV;
    } else {
      i --;
      if(this.dist() < maxDist || i < 0)
        return rV;
    }
    
    
    return entries[i].addDistSum(bigger, i, maxDist, rV);
  }
  
}

public class HdRv{
  
  public HdRv(){
    sum = 0;
    heightAvg = 0;
  }
  
  int sum;
  float heightAvg;
}
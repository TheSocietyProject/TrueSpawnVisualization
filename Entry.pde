


// ìnd 0 has smallest dist

Entry[] entries;
int setInd;


int distSumMax;

public void calcDistSum(){
  distSumMax = 0;
  int cur;
  for(int i = 0; i < entries.length; i ++){
    cur = entries[i].calcDistSumLen(i, distSumLen / 2.0);
    if(cur > distSumMax){
      distSumMax = cur;
    }
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
    entries[i].renderVertex(i);
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
  
  public String time;
  public float x, y, z;
  
  
  public Entry(String time, float x, float y, float z){
    this.time = time;
    this.x = x;
    this.y = y;
    this.z = z;
    
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
  
  
  
  
  
  
  
  
  public void renderVertex(int i){
    col(convertColor(100.0 * i / len));
    
    vertex(x(), z(), 0);
    vertex(x(), z(), y() / 2.0);
    
    
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
    
  }
  
  public void renderPoint(float xSize, float ySize){
    stroke(cols[0]);
    fill(cols[0]);
    ellipse(xSize * this.dist() / maxCoord, -ySize * this.y / 255.0, 1, 1);
    // smh y has to be multiplied by 2...
  }
  
 
 
 public int calcDistSumLen(int i, float dist){
    int rV = addDistSum(false, i, this.dist() - dist, 0);
    //if(i + 1 < entries.length)
    rV = entries[i].addDistSum(true, i, this.dist() + dist, rV);
    
    rV -= 3; // so 0 is the lowest
    this.distSum = rV;
    
    return rV;
  }
  
  public int addDistSum(boolean bigger, int i, float maxDist, int sum){
    sum ++;
    if(bigger){
      i ++;
      if(this.dist() > maxDist || i >= entries.length)
        return sum;
    } else {
      i --;
      if(this.dist() < maxDist || i < 0)
        return sum;
    }
    
    
    return entries[i].addDistSum(bigger, i, maxDist, sum);
  }
  
  
  
  
  
}
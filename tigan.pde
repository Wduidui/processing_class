class Snake {
  // positions
  int[] xpos;
  int[] ypos;

  // 长度
  Snake(int n) {
    xpos = new int[n];
    ypos = new int[n];
  }

  void update(int newX, int newY) {
    //将所有元素向下移动一个点。
//xpos[0]=xpos[1]，xpos[1]=xpos=[2]等等。在第二至最后一个元素处停止
    for (int i = 0; i < xpos.length-1; i ++ ) {
      xpos[i] = xpos[i+1]; 
      ypos[i] = ypos[i+1];
    }

    // 用鼠标位置更新数组中的最后一个点。
    xpos[xpos.length-1] = newX; 
    ypos[ypos.length-1] = newY;
  }

  void display() {
    // Draw 
    for (int i = 0; i < xpos.length; i ++ ) {
//画个椭圆的每个元素的数组。
//颜色和尺寸
      stroke(0);
      fill(125-i*5);
      ellipse(xpos[i],ypos[i],i,i); 
    }

  }

}



import processing.video.*;

// Variable for capture device
Capture video;

// searching 
color trackColor; 


Snake snake;

void setup() {
  size(400,400);
  video = new Capture(this,width,height);
  video.start();
  //tracking for red
  trackColor = color(255,0,0);
  
  // 初始化蛇
  snake = new Snake(50);
  
}


void captureEvent(Capture video) {
  video.read();
}

void draw() {
  video.loadPixels();
  image(video,0,0);

  
  float worldRecord = 500; 

//最接近颜色的XY坐标
  int closestX = 0;
  int closestY = 0;

  //开始循环遍每个像素
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width;
      
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      
      float d = dist(r1,g1,b1,r2,g2,b2); // We are using the dist( ) function to compare the current color with the color we are tracking.

      
      if (d < worldRecord) {
        worldRecord = d;
        closestX = x;
        closestY = y;
      }
    }
  }

 
  if (worldRecord < 10) { 
    // Update the snake's location
    snake.update(closestX,closestY);
  }
  
  snake.display();
  
}

void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
}

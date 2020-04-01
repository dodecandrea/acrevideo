/*
  Source code for generating random visuals
  Used in Acre's video for the single "Quaranta"
  
  Dodecandrea
*/
import java.util.Random;

int num = 40;
int step = 10;
Random rand;
boolean b;

//Number of photos in directory images
int numPhotos = 38;

//Contain perlin shapes and images
ArrayList<PShape> shapes;
ArrayList<PImage> images;

//For random positions, rotations and photos
float[] x;
float[] y;
float[] z;
float[] pi;
int[] r;

//Moving values
float a;
int fwd;

//The font used
PFont font;

void setup() {
  size(1920, 1080, P3D);
  
  //Load font
  font = createFont("medieval.ttf", 32);
  rand = new Random();
  
  //Initialize the arrays
  shapes = new ArrayList();
  images = new ArrayList();
  x = new float[600];
  y = new float[600];
  z = new float[600];
  pi = new float[600];
  r = new int[(int)random(1, 10)];
  
  //Load arrays
  for(int i = 0; i < numPhotos; i++) {
    images.add(loadImage(("images/" + (i+1) + ".jpg")));
    shapes.add(create(images.get(i), random(5/100), random(5/100)));
  }
  for(int i = 0; i < 600; i++) {
    x[i]= random(width);
    y[i] = random(height);
    z[i] = random(-1200, -400);
    pi[i] = random(TWO_PI);
  }
  for(int i = 0; i < r.length; i++) {
    r[i] = floor(random(numPhotos));
  }
  
  b = rand.nextBoolean();
  //Set the font in the enviroment
  textFont(font);
}

void draw() {
  background(255);
  //background(128, 0, 0);
  camera(width/2, height/3, 935+fwd, width/2.0+a, height/2.0, -800+fwd, 0, 1, 0);
  fill(0);
  
  //Random writings in 3D space
  for(int i = 0; i < 30; i++) {
    pushMatrix();
      translate(x[i], y[i], z[i]);
      rotateY(y[i]);
      textSize(72); 
      text("acre", 0, 0, 0);
    popMatrix();
  }
  
  //Random pictures in 3D space
  for(int i = 0; i < r.length; i++) {
    pushMatrix();
      translate(x[i],y[i], z[i]);
      rotateX(pi[i]);
      shape(shapes.get(r[i]), 0, 0);
    popMatrix();
  }
  
  //Increment values for movement
  fwd -= 2;
  if(b) a = fwd*0.5; else a = -fwd*0.5;
}


//The function used to create the shapes for the images
PShape create(PImage img, float xoff, float yoff) {
  ArrayList<PVector>vectors = new ArrayList();
  for(int x = 0; x < num; x ++) {
    for(int y = 0; y < num; y ++) {
      vectors.add(new PVector(x*step, y*step, noise(xoff, yoff)*120));
      yoff += 0.2;
    }
    xoff += 0.2;
    yoff = 0;
  }
  PShape s = createShape(GROUP);
  for(int x = 0; x < num-1; x ++) {
    for(int y = 0; y < num-1; y ++) {
      PShape t = createShape();
      t.beginShape(TRIANGLES);
      t.noStroke();
      t.texture(img);
      t.vertex(vectors.get(x+y*num).x, vectors.get(x+y*num).y, vectors.get(x+y*num).z, x*10, y*10);
      t.vertex(vectors.get((x+y*num)+1).x, vectors.get((x+y*num)+1).y, vectors.get((x+y*num)+1).z, (x+1)*10, y*10);
      t.vertex(vectors.get(x+(y+1)*(num)).x, vectors.get(x+(y+1)*(num)).y, vectors.get(x+(y+1)*num).z, x*10, (y+1)*10);
      t.endShape();
      PShape t1 = createShape();
      t1.beginShape(TRIANGLES);
      t1.noStroke();
      t1.texture(img);
      t1.vertex(vectors.get((x+y*num)+1).x, vectors.get((x+y*num)+1).y, vectors.get((x+y*num)+1).z, (x+1)*10, y*10);
      t1.vertex(vectors.get(x+(y+1)*(num)).x, vectors.get(x+(y+1)*(num)).y, vectors.get(x+(y+1)*num).z, x*10, (y+1)*10);
      t1.vertex(vectors.get(x+1+(y+1)*(num)).x, vectors.get(x+1+(y+1)*(num)).y, vectors.get(x+1+(y+1)*num).z, (x+1)*10, (y+1)*10);
      t1.endShape();
      s.addChild(t);
      s.addChild(t1);
      yoff += 0.03;
    }
    xoff += 0.03;
  }
  return s;
}

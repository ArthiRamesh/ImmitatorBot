/* --------------------------------------------------------------------------
 * Skeleton Tracking
 * --------------------------------------------------------------------------
 * Raj
 * http://facebook.com/raj.lokesh
 * --------------------------------------------------------------------------
 * date:  21/02/2014 (m/d/y)
 * ----------------------------------------------------------------------------
 */

import SimpleOpenNI.*;
import processing.serial.*;
Serial se=new Serial(this,"COM14",9600 );
SimpleOpenNI  k;
PVector com = new PVector();                                   
PVector com2d = new PVector();  

PVector lHand = new PVector();
PVector lElbow = new PVector();
PVector lShoulder = new PVector();

PVector lFoot = new PVector();
PVector lKnee = new PVector();
PVector lHip = new PVector();

PVector rHand = new PVector();
PVector rElbow = new PVector();
PVector rShoulder = new PVector();

PVector rFoot = new PVector();
PVector rKnee = new PVector();
PVector rHip = new PVector();


float[] ang = new float[9];
int x, p, m;
PShape s;
PFont font;
String[] parts= new String[] {
  "Body", "LElbow", "LShoulder", "LKnee", "LHip", "RElbow", "RShoulder", "RKnee", "RHip"
};

void setup()
{   
  k = new SimpleOpenNI(this);
  if (k.isInit() == false)
  {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }
  k.setMirror(true);

  // enable ir generation can be ommited

  //k.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL); OLD VERSION

  k.enableDepth();
  k.enableRGB();
  k.enableUser();

  //size(1280,800);
  //font=loadfont("SansSerif-14.vlw");
  s=loadShape("Android.svg");
  //shapeMode(CENTER);



  //strokeWeight(3);
  size(640*2, 700);
  background(0);
  stroke(0);
  frameRate(10);
  smooth(); //added without knowing what it is
}
void draw()
{

  noStroke();
  fill(0);
  rect(640, 0, 640, height);




  // update the cam
  k.update();
  // draw depthImageMap
  //image (k.depthImage(),0,0);
  image(k.userImage(), 0, 0);
  // draw irImageMap

  int[] userList = k.getUsers();
  for (int i=0;i<userList.length;i++)
  {
    if (k.isTrackingSkeleton(userList[i]))
    {
      if (i==0)
      {

        //println("Tracking skeleton.......");
        updateang();
        moveservo();


        stroke(0, 255, 0);

        drawSk(userList[i]);
      } 
      else 
      {
        stroke(255, 0, 0);
        drawSk(userList[i]);
      }
      // draw the center of mass
      if (k.getCoM(userList[i], com))
      {
        k.convertRealWorldToProjective(com, com2d);
        stroke(100, 255, 0);
        strokeWeight(1);
        beginShape(LINES);
        vertex(com2d.x, com2d.y - 5);
        vertex(com2d.x, com2d.y + 5);

        vertex(com2d.x - 5, com2d.y);
        vertex(com2d.x + 5, com2d.y);
        endShape();

        fill(0, 255, 100);
        text(Integer.toString(userList[i]), com2d.x, com2d.y);
      }
    }
  }

  shape(s, 755, -100, 400, 400);
  move(750-100+150, 110+100, PI, ang[2], ang[1], 50);
  move(770-105+477, 110+100, 0, -ang[6], -ang[5], 50);
  move(778-100+228, 285+120, PI/2, ang[4], ang[3], 60);
  move(702-120+450, 285+120, PI/2, -ang[8], -ang[7], 60);
  fill(0);
  rect(0, 480, 680, height-480);
  stroke(0, 255, 0);
  fill(0, 255, 0);
  print("Ang"+0+": "+round(degrees(ang[0]))+" ");
  text(parts[0]+": "+round(degrees(ang[0])), 440, 500);
  for (x=1,p=0,m=0;x<=8;x++,p++)
  {

    stroke(0, 255, 0);
    fill(0, 255, 0);
    print("Ang"+x+": "+round(degrees(ang[x])+90)+" ");
    if (p>=4) {
      p=0;
      m=80;
    }
    text(parts[x]+": "+round(degrees(ang[x])+90), 310+100*p, 580+m);
  }
  print("\n\n\n");
  image(k.rgbImage(), 0, k.depthHeight(), 293.33, 220);
}
void move(int x, int y, float a0, float a1, float a2, float l)
{
  pushStyle();
  strokeCap(ROUND);
  strokeWeight(62);
  stroke(134, 189, 66);
  pushMatrix();
  translate(x, y);
  rotate(a0);
  rotate(a1);
  line(0, 0, l, 0);
  translate(l, 0);
  rotate(a2);
  line(0, 0, l, 0);
  popMatrix();
  popStyle();
}
void drawSk(int uId)
{
  pushStyle();
  //stroke(0, 255, 0);
  //strokeWeight(3);
  k.drawLimb(uId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  k.drawLimb(uId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  k.drawLimb(uId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  k.drawLimb(uId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  k.drawLimb(uId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  k.drawLimb(uId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  k.drawLimb(uId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  k.drawLimb(uId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  k.drawLimb(uId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  k.drawLimb(uId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  k.drawLimb(uId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  k.drawLimb(uId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  k.drawLimb(uId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  k.drawLimb(uId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  k.drawLimb(uId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);

  popStyle();
}
public void onNewUser(SimpleOpenNI k, int uId)
{
  println("New User Found - userId: "+uId);
  if (k.isTrackingSkeleton(uId)) return;
  println(" Start pose detection");
  //k.startPoseDetection("Psi",uId);
  k.startTrackingSkeleton(uId);
}


public void onLostUser(SimpleOpenNI k, int uId)
{

  println("Lost User: "+uId);
  k.stopTrackingSkeleton(uId);
}

public void onStartPose(String poss, int uId)
{
  println("Start Pose "+poss+" detected for user: "+uId);
  println("Stop posing");
  //k.stopPoseDetection(uId);
  //k.requestCalirationSkeleton(uId, true);
}

public void onEndPose(String poss, int uId)
{

  println("End Pose "+poss+" detected for user: "+uId);
}

public void onStartCalibration(int uId)
{

  println("Starting Calibration for user: "+uId);
}
public void onEndCalibration(int uId, boolean s)
{

  println("Calibration "+s+ " for user: "+uId);
  if (s)
  {
    println("User Calibrated!!!");
    k.startTrackingSkeleton(uId);
  }
  else
  {

    println("User Calibration Failed!!!");
    println("Starting pose detection again...");
    //k.startPoseDetection("Psi",uId);
  }
}

float angle(PVector a, PVector b, PVector c)
{
  float a1=atan2(a.y-b.y, a.x-b.x);
  float a2=atan2(b.y-c.y, b.x-c.x);
  float ang=a2-a1;
  return ang;
}

void updateang()
{
  k.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_HAND, lHand);
  k.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_ELBOW, lElbow);
  k.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_SHOULDER, lShoulder);

  k.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_FOOT, lFoot);
  k.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_KNEE, lKnee);
  k.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_HIP, lHip);

  k.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_HAND, rHand);
  k.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_ELBOW, rElbow);
  k.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_SHOULDER, rShoulder);

  k.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_FOOT, rFoot);
  k.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_KNEE, rKnee);
  k.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_HIP, rHip);

  ang[0]=atan2(PVector.sub(rShoulder, lShoulder).z, PVector.sub(rShoulder, lShoulder).x);

  k.convertRealWorldToProjective(rFoot, rFoot);
  k.convertRealWorldToProjective(rKnee, rKnee);
  k.convertRealWorldToProjective(rHip, rHip);
  k.convertRealWorldToProjective(lFoot, lFoot);
  k.convertRealWorldToProjective(lKnee, lKnee);
  k.convertRealWorldToProjective(lHip, lHip);
  k.convertRealWorldToProjective(lHand, lHand);
  k.convertRealWorldToProjective(lElbow, lElbow);
  k.convertRealWorldToProjective(lShoulder, lShoulder);
  k.convertRealWorldToProjective(rHand, rHand);
  k.convertRealWorldToProjective(rElbow, rElbow);
  k.convertRealWorldToProjective(rShoulder, rShoulder);


  ang[1]=angle(lShoulder, lElbow, lHand);
  ang[2]=angle(rShoulder, lShoulder, lElbow);
  ang[3]=angle(lHip, lKnee, lFoot);
  ang[4]=angle(new PVector(lHip.x, 0), lHip, lKnee);

  ang[5]=angle(rHand, rElbow, rShoulder);
  ang[6]=angle(rElbow, rShoulder, lShoulder);
  ang[7]=angle(rFoot, rKnee, rHip);
  ang[8]=angle(rKnee, rHip, new PVector(rHip.x, 0));
}
void moveservo() {
  se.write('p');
  for (int i=1;i<9;i++)
    se.write((int)round(degrees(ang[i])+90));
}


import processing.sound.*;
//Soundsライブラリをロード
SoundFile mscButton; //音声ファイルを読み込む箱を作る
SoundFile mscFinish;
SoundFile mscStart;
SoundFile mscBgmSemi;

static int ENEMY_NUMBER = 10;
static int ENEMY_HEIGHT = 100;
static int ENEMY_WIDTH = 100;

static int ENEMY_SPEED_MIN = 5;
static int ENEMY_SPEED_MAX = 10;
static int ENEMY_DIRECT_LEFT = 0;
static int ENEMY_DIRECT_RIGHT = 1;
static int ENEMY_HIDE = 2;
static int PLAY_TIME = 15;

static final int SCREEN_WIDTH = 1500;
static final int SCREEN_HEIGHT = 900;

static int START_SCREEN = 0;
static int READY_SCREEN = 1;
static int PLAY_SCREEN = 2;
static int FINISH_SCREEN = 3;
static int RESULT_SCREEN = 4;

PImage imgBackground;
PImage imgDragonfly;
PImage imgSun;
PImage imgTreeLeft;
PImage imgTreeRight;
PImage imgTree3;
PImage imgTree5;
PImage imgTree6;
PImage imgTree8;

PImage imgStartButton;
PImage imgWatch;
PImage imgScore;
PImage imgOne;
PImage imgTwo;
PImage imgThree;
PImage imgNet2;
PImage imgNet1;
PImage imgCloud;
PImage imgCloudTall1;
PImage imgCloudTall2;
PImage imgCloudTall3;

PImage imgCloudFlow1;
PImage imgCloudFlow2;
PImage imgCloudFlow3;
PImage imgSunFlower1;
PImage imgSunFlower2;
PImage imgSunFlower3;

PImage imgSemi;

PImage[] enemy = new PImage[ENEMY_NUMBER];

int state = 0;
int flagFinish = 1;
int flagHit = 1;
int startTime;
int startTimeSec;
int startTimeMin;
int nowTime;

float[] ex = new float[ENEMY_NUMBER];
float[] ey = new float[ENEMY_NUMBER];
int[] ed = new int[ENEMY_NUMBER];
int[] epoint = new int[ENEMY_NUMBER];
float[] espeed = new float[ENEMY_NUMBER];

PFont font;
PFont fontLogo;
PFont fontCrayon;
PFont fontBear;
PFont fontChild;


Player player1;

class Player {
  int score = 0;
  int count = 0;

  Player() {
  }
}

void gameInit() {
  for (int i=0; i<ENEMY_NUMBER; i++) {
    ed[i] = ENEMY_HIDE;
  }
}

void enemyDisplay() {
  for (int i=0; i<ENEMY_NUMBER; i++) {
    if (ed[i] < ENEMY_HIDE) {
      image(enemy[ed[i]], ex[i], ey[i]);
    }
  }
}

void enemyMove() {
  if (random(1000) < 100) {
    enemyAdd();
  }
  for (int i=0; i<ENEMY_NUMBER; i++) {
    if (ed[i] != ENEMY_HIDE) {
      ex[i] = ex[i] + espeed[i];
    }
    if ((ed[i] == ENEMY_DIRECT_LEFT) && (ex[i] > SCREEN_WIDTH + ENEMY_WIDTH)) {
      ed[i] = ENEMY_HIDE;
    }
    if ((ed[i] == ENEMY_DIRECT_RIGHT) && (ex[i] < -ENEMY_WIDTH)) {
      ed[i] = ENEMY_HIDE;
    }
  }
}

void enemyAdd() {
  for (int i=0; i<ENEMY_NUMBER; i++) {
    if (ed[i] == ENEMY_HIDE) {
      espeed[i] = random(ENEMY_SPEED_MIN, ENEMY_SPEED_MAX);
      epoint[i] = int(espeed[i] * 5);
      if (random(100) < 50) {
        ed[i] = 0;
        ex[i] = - ENEMY_WIDTH;
      } else {
        ed[i] = 1;
        ex[i] = SCREEN_WIDTH + ENEMY_WIDTH;
        espeed[i] = -espeed[i];
      }
      ey[i] = int(random(120, 600));
      break;
    }
  }
}

void enemyJudge() {
  if (mousePressed == false) {
    flagHit = 1;
  }
  for (int i=0; i<ENEMY_NUMBER; i++) {
    if (ex[i] <= mouseX && mouseX <= ex[i] + ENEMY_WIDTH && ey[i] <= mouseY && mouseY <= ey[i] + ENEMY_HEIGHT && mousePressed == true && flagHit == 1) {
      ed[i] = ENEMY_HIDE;
      enemyHit(i);
      flagHit = 0;
      break;
    }
  }
}

void mouseClicked() {
  //print(state+"\n");
  if (state == 2) {
    enemyJudge();
  }
}

void enemyHit(int i) {
  //当たった時に音を出す。効果を表現
  player1.score += epoint[i];
  player1.count += 1;
}

void loadImg() {
  imgBackground = loadImage("backNew.png");
  
  imgSun = loadImage("sun.png");
  imgSun.resize(300, 300);
  imgTreeLeft = loadImage("tree1.png");
  imgTreeLeft.resize(250, 350);
  imgTreeRight = loadImage("tree2.png");
  imgTreeRight.resize(250, 350);

  imgStartButton = loadImage("start_button.png");
  imgStartButton.resize(500, 210);

  imgWatch = loadImage("watch.png");
  imgWatch.resize(130, 130);

  imgScore = loadImage("score.png");

  imgOne = loadImage("one.png");
  imgTwo = loadImage("two.png");
  imgThree = loadImage("three.png");

  imgOne.resize(250, 400);
  imgTwo.resize(250, 400);
  imgThree.resize(250, 400);

  imgNet2 = loadImage("net.png");
  imgNet2.resize(200, 200);

  imgNet1 = loadImage("net1.png");
  imgNet1.resize(200, 200);

  imgSunFlower1 = loadImage("himawari.png");
  imgSunFlower1.resize(75, 125);
  
  imgSunFlower2 = loadImage("himawari.png");
  imgSunFlower2.resize(150, 250);
  
  imgSunFlower3 = loadImage("himawari.png");
  imgSunFlower3.resize(90, 150);

  enemy[0] = loadImage("enemy1.png");
  enemy[0].resize(ENEMY_WIDTH, ENEMY_HEIGHT);

  enemy[1] = loadImage("enemy2.png");
  enemy[1].resize(ENEMY_WIDTH, ENEMY_HEIGHT);
  
  imgCloud = loadImage("kumo.png");
  imgCloud.resize(600, 300);
  
  imgCloudTall1 = loadImage("cloud2.png");
  imgCloudTall1.resize(600, 300);
  
  imgCloudTall2 = loadImage("cloud2.png");
  imgCloudTall2.resize(100, 50);
  
  imgCloudTall3 = loadImage("cloud2.png");
  imgCloudTall3.resize(300, 150);
  
  imgCloudFlow1 = loadImage("cloud3.png");
  imgCloudFlow1.resize(600, 300);
  
  imgCloudFlow2 = loadImage("cloud3.png");
  imgCloudFlow2.resize(100, 50);
  
  imgCloudFlow3 = loadImage("cloud3.png");
  imgCloudFlow3.resize(150, 150);
  
  imgTree3 = loadImage("tree3.png");
  imgTree3.resize(400, 400);
  
  imgTree5 = loadImage("tree5.png");
  imgTree5.resize(200, 200);
  
  imgTree6 = loadImage("tree3.png");
  imgTree6.resize(350, 350);
  
  imgTree8 = loadImage("tree8.png");
  imgTree8.resize(1000, 1000);
  
  imgSemi = loadImage("semi.png");
  imgSemi.resize(50, 75);
}

void showBackground() {
  image(imgBackground, 0, 0);
  
  image(imgCloudTall1, 800, 100);
  //image(imgCloudTall2, 1000, 600);
  //image(imgCloudTall3, 50, 450);
  
  image(imgCloudFlow1, 900, 100);
  //image(imgCloudFlow2, 50, 300);
 
  //image(imgCloudFlow3, 250, 100);

  //image(imgSun, 1200, 0);
  
  //image(imgTreeLeft, 100, 400);
  //image(imgTreeRight, 1200, 400);
  
  //image(imgTree3, 700, 500);
  image(imgTree5, 900, 550);
  image(imgTree6, 400, 500);
  image(imgTree8, 950, -50);
  //image(imgCloud, 300, 300);
  
  image(imgSemi, 1425, 700);

  image(imgSunFlower1, 100, 750);
  image(imgSunFlower2, 125, 625);
  image(imgSunFlower3, 230, 730);
  //image(imgSunFlower, 400, 600);
  //image(imgSunFlower, 500, 600);
  //image(imgSunFlower, 600, 600);
  //image(imgSunFlower, 700, 600);
  //image(imgSunFlower, 800, 600);
  //image(imgSunFlower, 800, 600);

}

void showScore() {
  noFill();
  rect(400, 30, 730, 110, 30);

  //textFont(fontLogo);  //選択したフォントを使用する
  textFont(fontChild);
  textSize(110);
  textAlign(RIGHT);
  textSize(110);
  text("スコア", 730, 125);
  text(player1.score, 1000, 125);
  textSize(90);
  text("pt", 1100, 115);
}

void showTimeFrame() {
  stroke(34, 139, 34);
  strokeWeight(6);
  noFill();
  rect(25, 30, 250, 110, 30);
  image(imgWatch, 5, 20);
}

void showNet() {
  if (mousePressed == true) {
    image(imgNet1, mouseX-100, mouseY-50);
  } else {
    image(imgNet2, mouseX-100, mouseY-50);
  }
}

void showTitle() {
  //枠を表示
  //stroke(34, 139, 34);
  //strokeWeight(6);
  //noFill();
  //rect(350, 250, 800, 225, 10);

  fill(255, 102, 51);
  textFont(fontChild);
  textSize(150);
  textAlign(LEFT);
  text("とんぼをとろう！", 180, 400);
}

void showTimeUp() {
  //枠を表示
  stroke(34, 139, 34);
  strokeWeight(6);
  fill(51, 255, 204);
  rect(350, 300, 800, 225, 10);

  //"time up"を表示
  fill(0, 0, 0);
  textFont(fontChild);
  textSize(110);
  textAlign(RIGHT);
  text("タイムアップ!", 1100, 450);
}

void startGame() {
  if (500 <= mouseX && mouseX <=1000 && 600 <= mouseY && mouseY <= 810 && mousePressed == true) {
    state = 1;
    mscButton.play();
    startTime = getNowTime();
  }
}
int getNowTime() {
  return second() + (minute() * 60) + (hour() * 3600);
}

void showRemainingTime(int remainingTime) {
  int time = remainingTime;
  if (time < 0) {
    time = 0;
  }

  fill(0, 0, 0);
  //textFont(fontLogo);
  textFont(fontChild);
  textSize(110);
  textAlign(RIGHT);
  text(time, 270, 125);
}

void showResult() {
  //結果を表示
  stroke(34, 139, 34);
  strokeWeight(6);
  noFill();
  rect(180, 200, 650, 500, 30);

  //
  fill(0, 0, 0);
  //textFont(fontLogo);
  textFont(fontChild);
  textSize(90);
  textAlign(LEFT);
  text("とった数", 210, 390);
  text("スコア", 210, 560);
  text("pt", 700, 560);
  text("匹", 750, 390);

  textAlign(RIGHT);
  text(player1.count, 700, 390);
  text(player1.score, 700, 560);
}

void showButtonRestart() {
  //リスタートボタンを表示
  stroke(34, 139, 34);
  strokeWeight(6);
  fill(51, 255, 204);
  rect(880, 250, 400, 150, 30);


  //"もう一回"を表示
  fill(0, 0, 0);
  //textFont(fontLogo);
  textFont(fontChild);
  textSize(70);
  textAlign(CENTER);
  text("もう一回", 1080, 350);

  if (1000 <= mouseX && mouseX <=1400 && 250 <= mouseY && mouseY <= 400 && mousePressed == true) {
    player1 = new Player();
    gameInit();
    mscButton.play();
    flagFinish = 1;
    flagHit = 1;
    state = 0;
  }
}
void showButtonFinish() {
  //終了ボタンを表示

  stroke(34, 139, 34);
  strokeWeight(6);
  fill(51, 255, 204);
  rect(880, 480, 550, 150, 30);


  //"もう一回"を表示
  fill(0, 0, 0);
  //textFont(fontLogo);
  textFont(fontChild);
  textSize(70);
  textAlign(CENTER);
  text("ゲームをおわる", 1150, 580);
  
  if (880 <= mouseX && mouseX <= 1430 && 480 <= mouseY && mouseY <= 630 && mousePressed == true) {
    exit();  
  }
  
}

void setup() {
  //size(SCREEN_WIDTH, SCREEN_HEIGHT);

  frameRate(60);
  size(1500, 900);
  loadImg();

  mscButton = new SoundFile(this, "start_button.mp3");
  mscStart = new SoundFile(this, "start.mp3");
  mscFinish = new SoundFile(this, "finish.mp3");
  mscBgmSemi = new SoundFile(this, "summermemories.mp3");
  player1 = new Player();

  font = createFont("MS Gothic", 200, true);
  fontLogo = createFont("logofont.ttf", 32);
  fontCrayon = createFont("crayon.ttf", 32);
  fontBear = createFont("bear.otf", 32);
  fontChild = createFont("child.otf", 32);

  gameInit();
  mscBgmSemi.loop();
}

void draw() {
  showBackground();
  switch(state) {
  case 0: //start display

    //スタートボタンを表示
    image(imgStartButton, 500, 600);

    //タイトルを表示
    showTitle();

    //ゲームを開始
    startGame();

    break;
  case 1: //開始までの秒数をカウントする画面

    //showBackground();

    float nowTime = getNowTime();
    if (startTime + 1 >= nowTime) {
      //[3]の画像を表示
      image(imgThree, 650, 200);
    } else if (startTime + 2 >= nowTime) {
      //[2]の画像を表示
      image(imgTwo, 650, 200);
    } else if (startTime + 3 >= nowTime) {
      //[1]の画像を表示
      image(imgOne, 650, 200);
    } else {
      //game start
      state = 2;
      startTimeSec = getNowTime();
      break;
    }

    break;

  case 2: //play display

    int remainingTime = PLAY_TIME - int(getNowTime() - startTimeSec);

    //残り時間の枠を表示
    showTimeFrame();

    //残り時間を表示
    showRemainingTime(remainingTime);

    //"スコア"表示
    showScore();

    if (remainingTime < 0) {

      //"time up！"を表示
      showTimeUp();

      if (flagFinish == 1) {
        mscFinish.play();
        startTime = getNowTime();
        flagFinish = 0;
      } else {
        flagFinish = 0;
      }

      nowTime = getNowTime();
      if (startTime + 2.5 < nowTime) {
        state = 3;
      }
    } else {

      //カーソルを虫取り網に変更
      showNet();

      //敵を表示
      enemyDisplay();

      //敵が移動する
      enemyMove();

      //敵のあたり判定
      enemyJudge();
    }

    break;

  case 3:
    //結果を表示
    showResult();
    
    //リスタートボタンを表示
    showButtonRestart();
    
    //終了ボタンを表示
    showButtonFinish();
  
  }
}

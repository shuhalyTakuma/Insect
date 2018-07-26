
/***********************************************************/
/* ライブラリの読み込み
/***********************************************************/

import processing.sound.*; //Soundsライブラリをロード

/***********************************************************/
/* 変数を定義
/***********************************************************/

SoundFile mscButtonClick; //クリックボタンの再生音
SoundFile mscFinish;      //終了ブザーの音
SoundFile mscStart;       //スタートブザーの音
SoundFile mscBgmSemi;     //セミの鳴き声

/*=========================================================*/
/* 敵の設定変数
/*=========================================================*/
static int ENEMY_NUMBER = 10;    //敵の数
static int ENEMY_HEIGHT = 100;   //敵の高さ
static int ENEMY_WIDTH = 100;    //敵の横幅
static int ENEMY_SPEED_MIN = 5;  //敵のスピードの最小値
static int ENEMY_SPEED_MAX = 10; //敵のスピードの最大値

float[] ex = new float[ENEMY_NUMBER]; //敵のx座標
float[] ey = new float[ENEMY_NUMBER]; //敵のy座標

/*-------------------------------------------------------*/
/* 変数名 : ed
/* 敵ごとの出現方向、非表示の設定変数
/*
/* ENEMY_DIRECT_LEFT  : 左から出現 
/* ENEMY_DIRECT_RIGHT : 右から出現
/* ENEMY_HIDE         : 非表示                            */
/*-------------------------------------------------------*/
int[] ed = new int[ENEMY_NUMBER]; 
static int ENEMY_DIRECT_LEFT = 0;
static int ENEMY_DIRECT_RIGHT = 1;
static int ENEMY_HIDE = 2;

PImage[] enemy = new PImage[ENEMY_NUMBER]; //敵の画像を設定
int[] epoint = new int[ENEMY_NUMBER];      //敵のポイントを設定
float[] espeed = new float[ENEMY_NUMBER];  //敵のスピードを保持する


/*=========================================================*/
/* 背景画像の設定変数
/*=========================================================*/
PImage imgBackground; //背景

PImage imgTree1; //木　
PImage imgTree2; //木
PImage imgTree3; //木

PImage imgCloudVerticallyLong;   //縦長の雲
PImage imgCloudHorizontallyLong; //横長の雲

PImage imgSunFlower1;
PImage imgSunFlower2;
PImage imgSunFlower3;

PImage imgSemi; //セミ

PImage imgStartButton; //スタートボタン

PImage imgOne;   //カウントダウンの「1」
PImage imgTwo;   //カウントダウンの「2」
PImage imgThree; //カウントダウンの「3」

PImage imgNetVertical;  //縦向きの虫取り網; 
PImage imgNetHorizontal; //横向きの虫取り網;

PImage imgWatch; //時計


/*=========================================================*/
/* ゲームの設定変数
/*=========================================================*/
static int PLAY_TIME = 15; //ゲームのプレイ時間

static int SCREEN_WIDTH = 1500; //画面の横幅
static int SCREEN_HEIGHT = 900; //画面の高さ

int startButtonClickTime; //スタートボタンをクリックした時刻
int startPlayTime;        //ゲームが開始された時刻
int finishTime;
PFont fontChild; //フォント

/*-------------------------------------------------------*/
/* 画面遷移変数
/* 0 : スタート画面
/* 1 : カウントダウン画面
/* 2 : プレイ画面
/* 3 : 結果表示画面
/*-------------------------------------------------------*/
int state; 

/*-------------------------------------------------------*/
/* 終了フラグ
/* 0 : プレイ中
/* 1 : プレイ終了
/*-------------------------------------------------------*/
int flagFinish; 

/*-------------------------------------------------------*/
/* 終了フラグ
/* 0 : マウスが押されている
/* 1 : マウスが押されていない
/*-------------------------------------------------------*/
int flagLeaveMouse;



/***********************************************************/
/* クラスを定義
/***********************************************************/
public class Player {
  private int score = 0; //スコア
  private int count = 0; //とった虫の数

  Player () {
  }
}

Player player; //プレイヤーのインスタンス




/***********************************************************/
/* 関数を定義
/***********************************************************/
/*=========================================================*/
/* 関数名 : gameInit
/* 引数   : なし
/* 機能   : 設定の初期化関数
/*=========================================================*/
void gameInit() {
  
  state = 0;          //表示画面をスタート画面に設定
  flagFinish = 0;     //ゲームをプレイ中に設定
  flagLeaveMouse = 1; //マウスが離れている状態に設定
  
  /*-------------------------------------------------------*/
  /* 全ての敵を非表示に設定
  /*-------------------------------------------------------*/
  for (int i=0; i<ENEMY_NUMBER; i++) {
    ed[i] = ENEMY_HIDE;
  }
}


/*=========================================================*/
/* 関数名 : enemyDisplay
/* 引数   : なし
/* 機能   : 変数edが非表示に設定されていない敵をex, eyをもとに表示
/*=========================================================*/
void enemyDisplay() {
  for (int i=0; i<ENEMY_NUMBER; i++) {    
    if (ed[i] != ENEMY_HIDE) {   
      /*---------------------------------------------------*/
      /* 関数名 : image
      /* 引数   : (表示する画像, x座標, y座標)
      /* 機能   : 画像を特定の位置に表示
      /*---------------------------------------------------*/
      image(enemy[ed[i]], ex[i], ey[i]);
    }
  }
}


/*=========================================================*/
/* 関数名 : enemyMove
/* 引数   : なし
/* 機能   : 敵を移動させる
/*=========================================================*/
void enemyMove() {
  /*-------------------------------------------------------*/
  /* 100/1000の確率で敵を追加
  /*-------------------------------------------------------*/
  if (random(1000) < 100) {
    enemyAdd();
  }
  
  for (int i=0; i<ENEMY_NUMBER; i++) {
    /*-----------------------------------------------------*/
    /* espeedの値を現在のx座標に追加し、敵を移動させる。
    /*-----------------------------------------------------*/
    if (ed[i] != ENEMY_HIDE) {
      ex[i] = ex[i] + espeed[i];
    }
    /*-----------------------------------------------------*/
    /* 左から来た敵が右端を超えた時、非表示にする
    /*-----------------------------------------------------*/
    if ((ed[i] == ENEMY_DIRECT_LEFT) && (ex[i] > SCREEN_WIDTH + ENEMY_WIDTH)) {
      ed[i] = ENEMY_HIDE;
    }
    
    /*-----------------------------------------------------*/
    /* 右から来た敵が左端を超えた時、非表示にする
    /*-----------------------------------------------------*/
    if ((ed[i] == ENEMY_DIRECT_RIGHT) && (ex[i] < -ENEMY_WIDTH)) {
      ed[i] = ENEMY_HIDE;
    }
  }
}


/*=========================================================*/
/* 関数名 : enemyAdd
/* 引数   : なし
/* 機能   : 敵を追加する
/*=========================================================*/
void enemyAdd() {
  for (int i=0; i<ENEMY_NUMBER; i++) {
    
    /*-----------------------------------------------------*/
    /* 非表示中の敵を追加する
    /*-----------------------------------------------------*/
    if (ed[i] == ENEMY_HIDE) {
      espeed[i] = random(ENEMY_SPEED_MIN, ENEMY_SPEED_MAX);
      epoint[i] = int(espeed[i] * 5);
      
      /*---------------------------------------------------*/
      /* random(100) が  0 ~  49 : 敵を右方向に出現させる
      /* random(100) が 50 ~ 100 : 敵を右方向に出現させる
      /*---------------------------------------------------*/      
      if (random(100) < 50) {
        ed[i] = ENEMY_DIRECT_LEFT;          //表示位置を左に設定
        ex[i] = - ENEMY_WIDTH;              //表示開始時のx座標を設定
      } else {
        ed[i] = ENEMY_DIRECT_RIGHT;         //表示位置を右に設定
        ex[i] = SCREEN_WIDTH + ENEMY_WIDTH; //表示開始時のx座標を設定
        espeed[i] = -espeed[i];             //左方向に進行させるため符号を反転
      }
      
      ey[i] = int(random(120, 600));        //表示開始時のy座標を120 ~ 600の間で設定
      
      break;
    }
  }
}


/*=========================================================*/
/* 関数名 : mouseClicked
/* 引数   : なし
/* 機能   : マウスがクリックされた時の処理を記述する.
/*=========================================================*/
void mouseClicked() {
  /*-------------------------------------------------------*/
  /* ゲームプレイ中にマウスがクリックされた時、敵を捕まえられるか
  /* 判定を行う
  /*-------------------------------------------------------*/
  if (state == 2) {
    enemyHitJudge();
  }
}


/*=========================================================*/
/* 関数名 : enemyHitJudge
/* 引数   : なし
/* 機能   : 敵を追加する
/*=========================================================*/
void enemyHitJudge() {
  /*-------------------------------------------------------*/
  /* マウスが押されていないとき
  /* flagLeaveMouse を 1
  /* に設定
  /*-------------------------------------------------------*/
  if (mousePressed == false) {
    flagLeaveMouse = 1;
  }
  
  /*-------------------------------------------------------*/
  /* 以下の3条件を満たした時、敵を捕まえられたことにする
  /* 1. マウスが敵の表示範囲内にあること
  /* 2. マウスが押されていること
  /* 3. 直前でマウスが離れていたこと
  /*-------------------------------------------------------*/
  for (int i=0; i<ENEMY_NUMBER; i++) {
    if (ex[i] <= mouseX && 
        mouseX <= ex[i] + ENEMY_WIDTH &&
        ey[i] <= mouseY && 
        mouseY <= ey[i] + ENEMY_HEIGHT &&
        mousePressed == true && 
        flagLeaveMouse == 1) {
          
      ed[i] = ENEMY_HIDE; //敵を非表示にする
      enemyHit(i);        //敵を捕まえられた時の処理を行う
      flagLeaveMouse = 0; //マウスが離れたことにする
      break;
    }
  }
}


/*=========================================================*/
/* 関数名 : enemyHit
/* 引数   : i = 捕まえた敵のID
/* 機能   : 敵を捕まえた時の処理を行う
/*=========================================================*/
void enemyHit(int i) {
  player.score += epoint[i]; //スコアに敵のポイントを加える
  player.count += 1;         //捕まえた敵の数を1増やす
}


/*=========================================================*/
/* 関数名 : loadImg
/* 引数   : なし
/* 機能   : 画像を読み込む
/*=========================================================*/
void loadImg() {
  /*-------------------------------------------------------*/
  /* 関数名 : loadImage
  /* 引数   : 画像ファイル jpg, png, ...
  /* 機能   : 画像を読み込む
  /*-------------------------------------------------------*/
  
  /*-------------------------------------------------------*/
  /* 関数名 : resize
  /* 引数   : (幅, 高さ)
  /* 機能   : 指定した大きさに画像サイズを変更する
  /*-------------------------------------------------------*/
  imgBackground = loadImage("backNew.png");
  
  imgStartButton = loadImage("start_button.png"); //スタートボタンの画像を読み込み
  imgStartButton.resize(500, 210); 

  imgWatch = loadImage("watch.png");
  imgWatch.resize(130, 130);


  imgOne = loadImage("one.png");
  imgOne.resize(250, 400);
  imgTwo = loadImage("two.png");
  imgTwo.resize(250, 400);
  imgThree = loadImage("three.png");
  imgThree.resize(250, 400);


  imgNetHorizontal = loadImage("net.png");
  imgNetHorizontal.resize(200, 200);

  imgNetVertical = loadImage("net1.png");
  imgNetVertical.resize(200, 200);

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
  
  imgCloudVerticallyLong = loadImage("cloud2.png");
  imgCloudVerticallyLong.resize(600, 300);
  
  
  imgCloudHorizontallyLong = loadImage("cloud3.png");
  imgCloudHorizontallyLong.resize(600, 300);
  
  imgTree2 = loadImage("tree5.png");
  imgTree2.resize(200, 200);
  
  imgTree3 = loadImage("tree3.png");
  imgTree3.resize(350, 350);
  
  imgTree1 = loadImage("tree8.png");
  imgTree1.resize(1000, 1000);
  
  imgSemi = loadImage("semi.png");
  imgSemi.resize(50, 75);
}


void showBackground() {
  image(imgBackground, 0, 0);
  
  image(imgCloudVerticallyLong, 800, 100);
  image(imgCloudHorizontallyLong, 900, 100);

  image(imgTree1, 950, -50);
  image(imgTree2, 900, 550);
  image(imgTree3, 400, 500);
  
  image(imgSemi, 1425, 700);

  image(imgSunFlower1, 100, 750);
  image(imgSunFlower2, 125, 625);
  image(imgSunFlower3, 230, 730);
}


void showScore() {
  noFill();
  rect(400, 30, 730, 110, 30);

  textFont(fontChild);
  textSize(110);
  textAlign(RIGHT);
  textSize(110);
  text("スコア", 730, 125);
  text(player.score, 1000, 125);
  textSize(90);
  text("pt", 1100, 115);
}


void showNet() {
  if (mousePressed == true) {
    image(imgNetVertical, mouseX-100, mouseY-50);
  } else {
    image(imgNetHorizontal, mouseX-100, mouseY-50);
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

void showTimeFrame() {
  stroke(34, 139, 34);
  strokeWeight(6);
  noFill();
  rect(25, 30, 250, 110, 30);
  image(imgWatch, 5, 20);
}

void showRemainingTime(int remainingTime) {
  int time = remainingTime;
  if (time < 0) {
    time = 0;
  }

  fill(0, 0, 0);
  textFont(fontChild);
  textSize(110);
  textAlign(RIGHT);
  text(time, 270, 125);
}


int getNowTime() {
  return second() + (minute() * 60) + (hour() * 3600);
}

void startGame() {
  if (500 <= mouseX && mouseX <=1000 && 600 <= mouseY && mouseY <= 810 && mousePressed == true) {
    state = 1;
    mscButtonClick.play();
    startButtonClickTime = getNowTime();
  }
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

void showResult() {
  //結果を表示
  stroke(34, 139, 34);
  strokeWeight(6);
  noFill();
  rect(180, 200, 650, 500, 30);

  //
  fill(0, 0, 0);
  textFont(fontChild);
  textSize(90);
  textAlign(LEFT);
  text("とった数", 210, 390);
  text("スコア", 210, 560);
  text("pt", 700, 560);
  text("匹", 750, 390);

  textAlign(RIGHT);
  text(player.count, 700, 390);
  text(player.score, 700, 560);
}

void showButtonRestart() {
  //リスタートボタンを表示
  stroke(34, 139, 34);
  strokeWeight(6);
  fill(51, 255, 204);
  rect(880, 250, 400, 150, 30);


  //"もう一回"を表示
  fill(0, 0, 0);
  textFont(fontChild);
  textSize(70);
  textAlign(CENTER);
  text("もう一回", 1080, 350);

  if (1000 <= mouseX && mouseX <=1400 && 250 <= mouseY && mouseY <= 400 && mousePressed == true) {
    gameInit();
    player = new Player();
    mscButtonClick.play();
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

  mscButtonClick = new SoundFile(this, "start_button.mp3");
  mscStart = new SoundFile(this, "start.mp3");
  mscFinish = new SoundFile(this, "finish.mp3");
  mscBgmSemi = new SoundFile(this, "summermemories.mp3");
  
  player = new Player();

  fontChild = createFont("child.otf", 32);

  gameInit();
  mscBgmSemi.loop();
}

void draw() {
  showBackground();
  int nowTime;
  switch(state) {
    case 0: //start display
  
      image(imgStartButton, 500, 600); //スタートボタンを表示
  
      showTitle(); //タイトルを表示
  
      startGame(); //ゲームを開始
  
      break;
    case 1: //開始までの秒数をカウントする画面
  
      nowTime = getNowTime();
      
      if (startButtonClickTime + 1 >= nowTime) {
        image(imgThree, 650, 200);    //[3]の画像を表示
      } else if (startButtonClickTime + 2 >= nowTime) {
        image(imgTwo, 650, 200);      //[2]の画像を表示
      } else if (startButtonClickTime + 3 >= nowTime) {
        image(imgOne, 650, 200);      //[1]の画像を表示
      } else {
        //game start
        state = 2;
        startPlayTime = getNowTime();
        break;
      }
  
      break;
  
    case 2: //play display
      
      int remainingTime = PLAY_TIME - int(getNowTime() - startPlayTime);
  
      showTimeFrame();                  //残り時間の枠を表示
      showRemainingTime(remainingTime); //残り時間を表示
      showScore();                      //"スコア"表示
      
      if (remainingTime >= 0) {
        
        showNet();       //カーソルを虫取り網に変更
  
        enemyDisplay();  //敵を表示
        enemyMove();     //敵が移動する
        enemyHitJudge(); //敵のあたり判定
       
      } else {
        
        showTimeUp(); // "time up！" を表示
  
        if (flagFinish == 0) {
          mscFinish.play(); //終了ブザーを鳴らす
          finishTime = getNowTime(); //
        }
        
        flagFinish = 1;
  
        nowTime = getNowTime();
        if (finishTime + 2.5 < nowTime) {
          state = 3;
        }
       
      }
  
      break;
  
    case 3:
    
      showResult();        //結果を表示
      showButtonRestart(); //リスタートボタンを表示
      showButtonFinish();  //終了ボタンを表示
      
      break;
  
  }
}

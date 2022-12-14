//+------------------------------------------------------------------+
//|                                                MuzunaiListV2.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, ttss000"
#property link      "https://twitter.com/ttss000"
#property version   "1.03"
#property strict
#property indicator_chart_window

#define X_ADJ 0
#define Y_ADJ 1

// http://useyan.x0.com/s/html/mono-font.htm 等幅フォントの例
input string FontName = "Segoe UI";  //"ＭＳ ゴシック"　"ＭＳ 明朝" "HG行書体" "GungsuhChe"
input color  FontColor = clrBlack;
input int    FontSize = 10;
input int    LineSpace = 6;//行間

input int    XShift = 10;//オブジェクト群の左側スペース
input int    YShift = 75;//オブジェクト群の上側スペース
input int Left0_Right1=1;

input int    BlockShift = 0;// 60文字毎のブロックの配置ズレ調整用
input color clrUp = clrBlue;
input color clrDown = clrRed;
input int x_right_location=200;
input int x0=10;
input int x1=80;
input int x_diff=40;
input int y0=450;
input int y_diff=15;

// OS によって60文字ブロックのサイズが違うので要注意。
// フォントサイズ 7～18 を想定。

// for Vista
int BlockSize[] = {0,1,2,3,4,5,6,360,420,480,480,540,600,660,720,780,780,840,900};

// for WindowsXP
//int BlockSize[] = {0,1,2,3,4,5,6,300/*7*/,300,300,420/*10*/,420,480,540,540/*14*/,600,660,660,720/*18*/};

enum ENUM_SYMBOLS {
  AUDJPY, AUDUSD, CHFJPY,  EURAUD, EURCAD, EURGBP, EURJPY, EURUSD, GBPAUD, GBPJPY, GBPUSD, NZDJPY, NZDUSD, USDJPY, XAUUSD
};
string str_symbols[] = {"AUDJPY", "AUDUSD", "CHFJPY", "EURAUD", "EURCAD", "EURGBP", "EURJPY", "EURUSD", "GBPAUD", "GBPJPY", "GBPUSD", "NZDJPY", "NZDUSD", "USDJPY", "XAUUSD"};

datetime dt_M15_prev = 0;
datetime dt_M15 = 0;

int g_FontSize = FontSize;

//string g_comment_tmp = "";

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
//--- indicator buffers mapping
  dt_M15 = iTime(NULL, PERIOD_M15, 0);
  if(FontSize > 18 ) g_FontSize = 18;
  if(FontSize <  7 ) g_FontSize =  7;
//---
  //g_comment_tmp = "";
  //Comment(g_comment_tmp);
  //CommentOBJ(g_comment_tmp);
  return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
void    OnDeinit(const int reason)
{
  EventKillTimer();
//DelBoxObj();
  DelObj();
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
//---
  int x_tmp=0;
  dt_M15 = iTime(NULL, PERIOD_M15, 0);
  string object_name = "";
  //comment_tmp = comment_tmp + (TimeCurrent()-dt_M15) + " min)\n";
  if(dt_M15 != dt_M15_prev) {
    //g_comment_tmp = "M15 kakutei ji ni han'ei\n";
    int symbol_arr_size = ArraySize(str_symbols);
    // memo
    object_name="muzumemo"+"x0";
    if(ObjectFind(0, object_name)<0) {
      ObjectCreate(0,object_name, OBJ_LABEL, 0, 0, 0);
    }
    if(Left0_Right1) {
      x_tmp = x_right_location - x0;
      ObjectSetInteger(0, object_name, OBJPROP_CORNER, 0, CORNER_RIGHT_UPPER);
    } else {
      x_tmp = x0;
    }
    ObjectSetInteger(0, object_name, OBJPROP_XDISTANCE, 0, x_tmp);
    ObjectSetInteger(0, object_name, OBJPROP_YDISTANCE, 0, y0);
    ObjectSetInteger(0, object_name, OBJPROP_FONTSIZE, 0, FontSize);
    ObjectSetString(0, object_name, OBJPROP_TEXT, 0, "Kakutei shita Ashi");
    ObjectSetString(0, object_name, OBJPROP_FONT, 0, FontName);
    ObjectSetInteger(0, object_name, OBJPROP_COLOR, 0, FontColor);
    // title
    object_name="muzutitle"+"x0";
    if(ObjectFind(0, object_name)<0) {
      ObjectCreate(0,object_name, OBJ_LABEL, 0, 0, 0);
    }
    if(Left0_Right1) {
      x_tmp = x_right_location - x0;
      ObjectSetInteger(0, object_name, OBJPROP_CORNER, 0, CORNER_RIGHT_UPPER);
    } else {
      x_tmp = x0;
    }
    ObjectSetInteger(0, object_name, OBJPROP_XDISTANCE, 0, x_tmp);
    ObjectSetInteger(0, object_name, OBJPROP_YDISTANCE, 0, y0+y_diff);
    ObjectSetInteger(0, object_name, OBJPROP_FONTSIZE, 0, FontSize);
    ObjectSetString(0, object_name, OBJPROP_TEXT, 0, "Symbol");
    ObjectSetString(0, object_name, OBJPROP_FONT, 0, FontName);
    ObjectSetInteger(0, object_name, OBJPROP_COLOR, 0, FontColor);
    object_name="muzutitle"+"x1";
    if(ObjectFind(0, object_name)<0) {
      ObjectCreate(0,"muzutitle"+"x1", OBJ_LABEL, 0, 0, 0);
    }
    if(Left0_Right1) {
      x_tmp = x_right_location - x1;
      ObjectSetInteger(0, object_name, OBJPROP_CORNER, 0, CORNER_RIGHT_UPPER);
    } else {
      x_tmp = x1;
    }
    ObjectSetInteger(0, object_name, OBJPROP_XDISTANCE, 0, x_tmp);
    ObjectSetInteger(0, "muzutitle"+"x1", OBJPROP_YDISTANCE, 0, y0+y_diff);
    ObjectSetInteger(0, object_name, OBJPROP_FONTSIZE, 0, FontSize);
    ObjectSetString(0, "muzutitle"+"x1", OBJPROP_TEXT, 0, "M15");
    ObjectSetString(0, object_name, OBJPROP_FONT, 0, FontName);
    ObjectSetInteger(0, object_name, OBJPROP_COLOR, 0, FontColor);
    object_name="muzutitle"+"x2";
    if(ObjectFind(0, "muzutitle"+"x2")<0) {
      ObjectCreate(0,"muzutitle"+"x2", OBJ_LABEL, 0, 0, 0);
    }
    if(Left0_Right1) {
      x_tmp = x_right_location - (x1+x_diff);
      ObjectSetInteger(0, object_name, OBJPROP_CORNER, 0, CORNER_RIGHT_UPPER);
    } else {
      x_tmp = x1+x_diff;
    }
    ObjectSetInteger(0, object_name, OBJPROP_XDISTANCE, 0, x_tmp);
    //ObjectSetInteger(0, "muzutitle"+"x2", OBJPROP_XDISTANCE, 0, x1+x_diff);
    ObjectSetInteger(0, "muzutitle"+"x2", OBJPROP_YDISTANCE, 0, y0+y_diff);
    ObjectSetInteger(0, object_name, OBJPROP_FONTSIZE, 0, FontSize);
    ObjectSetString(0, "muzutitle"+"x2", OBJPROP_TEXT, 0, "H4");
    ObjectSetString(0, object_name, OBJPROP_FONT, 0, FontName);
    ObjectSetInteger(0, object_name, OBJPROP_COLOR, 0, FontColor);
    object_name="muzutitle"+"x3";
    if(ObjectFind(0, "muzutitle"+"x3")<0) {
      ObjectCreate(0,"muzutitle"+"x3", OBJ_LABEL, 0, 0, 0);
    }
    if(Left0_Right1) {
      x_tmp = x_right_location - ( x1+x_diff*2);
      ObjectSetInteger(0, object_name, OBJPROP_CORNER, 0, CORNER_RIGHT_UPPER);
    } else {
      x_tmp = ( x1+x_diff*2);
    }
    ObjectSetInteger(0, object_name, OBJPROP_XDISTANCE, 0, x_tmp);
    //ObjectSetInteger(0, "muzutitle"+"x3", OBJPROP_XDISTANCE, 0, x1+x_diff*2);
    ObjectSetInteger(0, "muzutitle"+"x3", OBJPROP_YDISTANCE, 0, y0+y_diff);
    ObjectSetInteger(0, object_name, OBJPROP_FONTSIZE, 0, FontSize);
    ObjectSetString(0, "muzutitle"+"x3", OBJPROP_TEXT, 0, "D1");
    ObjectSetString(0, object_name, OBJPROP_FONT, 0, FontName);
    ObjectSetInteger(0, object_name, OBJPROP_COLOR, 0, FontColor);
    for(int i = 0 ; i < symbol_arr_size ; i++) {
      bool bIsFirstTime = true;
      /////////////////// M15 /////////////////////
      object_name="muzusymbol"+IntegerToString(i);
      if(ObjectFind(0, object_name)<0) {
        ObjectCreate(0,object_name, OBJ_LABEL, 0, 0, 0);
      }
      if(Left0_Right1) {
        x_tmp = x_right_location - ( x0);
        ObjectSetInteger(0, object_name, OBJPROP_CORNER, 0, CORNER_RIGHT_UPPER);
      } else {
        x_tmp = x0;
      }
      ObjectSetInteger(0, object_name, OBJPROP_XDISTANCE, 0, x_tmp);
      //ObjectSetInteger(0, object_name, OBJPROP_XDISTANCE, 0, x0);
      ObjectSetInteger(0, object_name, OBJPROP_YDISTANCE, 0, y0+(i+2)*y_diff);
      ObjectSetInteger(0, object_name, OBJPROP_FONTSIZE, 0, FontSize);
      ObjectSetString(0, object_name, OBJPROP_FONT, 0, FontName);
      ObjectSetString(0, object_name, OBJPROP_TEXT, 0, str_symbols[i]);
      ObjectSetInteger(0, object_name, OBJPROP_COLOR, 0, FontColor);
      // m15
      object_name="muzu_m15"+IntegerToString(i);
      if(ObjectFind(0, object_name)<0) {
        ObjectCreate(0,object_name, OBJ_LABEL, 0, 0, 0);
      }
      if(Left0_Right1) {
        x_tmp = x_right_location - ( x1);
        ObjectSetInteger(0, object_name, OBJPROP_CORNER, 0, CORNER_RIGHT_UPPER);
      } else {
        x_tmp = x1;
      }
      ObjectSetInteger(0, object_name, OBJPROP_XDISTANCE, 0, x_tmp);
      ObjectSetString(0, object_name, OBJPROP_TEXT, 0, "");
//      ObjectSetInteger(0, object_name, OBJPROP_XDISTANCE, 0, x1);
      ObjectSetInteger(0, object_name, OBJPROP_YDISTANCE, 0, y0+(i+2)*y_diff);
      ObjectSetInteger(0, object_name, OBJPROP_FONTSIZE, 0, FontSize);
      ObjectSetString(0, object_name, OBJPROP_FONT, 0, "Wingdings 3");
      if(iBands(str_symbols[i], PERIOD_M15, 20, 1, 0, PRICE_CLOSE,  MODE_UPPER, 1) < iClose(str_symbols[i], PERIOD_M15, 1)) {
        ObjectSetInteger(0, object_name, OBJPROP_COLOR, 0, clrUp);
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, ShortToString(233));
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, "J");  //p
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, "p");  //p
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0xa3));  // OK
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0x93));  // bad
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0x68));  // ok
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0xe3));  // bad
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0xdb));  // ok
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0xa3));  // OK
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0x97));  // bad
        ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0xd3)+CharToString(0xd3));  // OK
        //if(bIsFirstTime) {
        //  //g_comment_tmp = g_comment_tmp + str_symbols[i];
        //  bIsFirstTime = false;
        //}
        //g_comment_tmp = g_comment_tmp + ": M15 up ike2";
      } else if(iClose(str_symbols[i], PERIOD_M15, 1) < iBands(str_symbols[i], PERIOD_M15, 20, 1, 0, PRICE_CLOSE,  MODE_LOWER, 1)) {
        ObjectSetInteger(0, object_name, OBJPROP_COLOR, 0, clrDown);
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, ShortToString(234));
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, "K");
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, "q");
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0x94));  // bad
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0x69));  // ok
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0xe4));  // bad
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0xdc));  // ok
        ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0xa4));  // OK
        ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0x98));  // bad
        ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0xd4)+CharToString(0xd4));  // OK
      ObjectSetInteger(0, object_name, OBJPROP_XDISTANCE, 0, x_tmp+X_ADJ);

        ObjectSetInteger(0, object_name, OBJPROP_YDISTANCE, 0, y0+(i+2)*y_diff+Y_ADJ);  
        //if(bIsFirstTime) {
        //  //g_comment_tmp = g_comment_tmp + str_symbols[i];
        //  bIsFirstTime = false;
        //}
        //g_comment_tmp = g_comment_tmp + ": M15 dn ike2";
      } else if( iClose(str_symbols[i], PERIOD_M15, 1) < iBands(str_symbols[i], PERIOD_M15, 20, 1, 0, PRICE_CLOSE,  MODE_UPPER, 1)
                 && iBands(str_symbols[i], PERIOD_M15, 20, 1, 0, PRICE_CLOSE,  MODE_MAIN, 1) < iClose(str_symbols[i], PERIOD_M15, 1)  ) {
        ObjectSetInteger(0, object_name, OBJPROP_COLOR, 0, clrUp);
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, "#");
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, "s");
        ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0xd3));  // OK
        if(bIsFirstTime) {
          //g_comment_tmp = g_comment_tmp + str_symbols[i];
          bIsFirstTime = false;
        }
        //g_comment_tmp = g_comment_tmp + ": M15 dn ike2";
      } else if(iBands(str_symbols[i], PERIOD_M15, 20, 1, 0, PRICE_CLOSE,  MODE_LOWER, 1) < iClose(str_symbols[i], PERIOD_M15, 1)
                && iClose(str_symbols[i], PERIOD_M15, 1)  <  iMA(str_symbols[i], PERIOD_M15, 20, 0, MODE_SMA, PRICE_CLOSE, 1) ) {
        ObjectSetInteger(0, object_name, OBJPROP_COLOR, 0, clrDown);
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, "$");
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, "r");
        ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0xd4));  // OK
        //if(bIsFirstTime) {
        //  //g_comment_tmp = g_comment_tmp + str_symbols[i];
        //  bIsFirstTime = false;
        //}
        //g_comment_tmp = g_comment_tmp + ": M15 dn ike2";
      }
      /////////////////// H4 /////////////////////
      object_name="muzu_h4"+IntegerToString(i);
      if(ObjectFind(0, object_name)<0) {
        ObjectCreate(0,object_name, OBJ_LABEL, 0, 0, 0);
      }
      ObjectSetString(0, object_name, OBJPROP_TEXT, 0, "");
      if(Left0_Right1) {
        x_tmp = x_right_location - ( x1+x_diff);
        ObjectSetInteger(0, object_name, OBJPROP_CORNER, 0, CORNER_RIGHT_UPPER);
      } else {
        x_tmp = x1+x_diff;
      }
      ObjectSetInteger(0, object_name, OBJPROP_XDISTANCE, 0, x_tmp);
      //ObjectSetInteger(0, object_name, OBJPROP_XDISTANCE, 0, x1+x_diff);
      ObjectSetInteger(0, object_name, OBJPROP_YDISTANCE, 0, y0+(i+2)*y_diff);
      ObjectSetInteger(0, object_name, OBJPROP_FONTSIZE, 0, FontSize);
      ObjectSetString(0, object_name, OBJPROP_FONT, 0, "Wingdings 3");
      if(iBands(str_symbols[i], PERIOD_H4, 20, 1, 0, PRICE_CLOSE,  MODE_UPPER, 1) < iClose(str_symbols[i], PERIOD_H4, 1)) {
        ObjectSetInteger(0, object_name, OBJPROP_COLOR, 0, clrUp);
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, "J");
        ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0xd3)+CharToString(0xd3));  // OK
        if(bIsFirstTime) {
          //g_comment_tmp = g_comment_tmp + str_symbols[i];
          bIsFirstTime = false;
        }
        //g_comment_tmp = g_comment_tmp + ": H4 up ike2";
      } else if(iClose(str_symbols[i], PERIOD_H4, 1) < iBands(str_symbols[i], PERIOD_H4, 20, 1, 0, PRICE_CLOSE,  MODE_LOWER, 1)) {
        ObjectSetInteger(0, object_name, OBJPROP_COLOR, 0, clrDown);
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, "K");
        ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0xd4)+CharToString(0xd4));  // OK
        if(bIsFirstTime) {
          //g_comment_tmp = g_comment_tmp + str_symbols[i];
          bIsFirstTime = false;
        }
        //g_comment_tmp = g_comment_tmp + ": H4 dn ike2";
      } else if( iClose(str_symbols[i], PERIOD_H4, 1) < iBands(str_symbols[i], PERIOD_H4, 20, 1, 0, PRICE_CLOSE,  MODE_UPPER, 1)
                 && iBands(str_symbols[i], PERIOD_H4, 20, 1, 0, PRICE_CLOSE,  MODE_MAIN, 1) < iClose(str_symbols[i], PERIOD_H4, 1)  ) {
        ObjectSetInteger(0, object_name, OBJPROP_COLOR, 0, clrUp);
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, "#");
        ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0xd3));  // OK
        if(bIsFirstTime) {
          //g_comment_tmp = g_comment_tmp + str_symbols[i];
          bIsFirstTime = false;
        }
        //g_comment_tmp = g_comment_tmp + ": M15 dn ike2";
      } else if(iBands(str_symbols[i], PERIOD_H4, 20, 1, 0, PRICE_CLOSE,  MODE_LOWER, 1) < iClose(str_symbols[i], PERIOD_H4, 1)
                && iClose(str_symbols[i], PERIOD_H4, 1)  <  iMA(str_symbols[i], PERIOD_H4, 20, 0, MODE_SMA, PRICE_CLOSE, 1) ) {
        ObjectSetInteger(0, object_name, OBJPROP_COLOR, 0, clrDown);
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, "$");
        ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0xd4));  // OK
        if(bIsFirstTime) {
          //g_comment_tmp = g_comment_tmp + str_symbols[i];
          bIsFirstTime = false;
        }
        //g_comment_tmp = g_comment_tmp + ": M15 dn ike2";
      }
      /////////////////// D1/////////////////////
      object_name="muzu_d1"+IntegerToString(i);
      if(ObjectFind(0, object_name)<0) {
        ObjectCreate(0,object_name, OBJ_LABEL, 0, 0, 0);
      }
      ObjectSetString(0, object_name, OBJPROP_TEXT, 0, "");
      if(Left0_Right1) {
        x_tmp = x_right_location - ( x1+x_diff*2);
        ObjectSetInteger(0, object_name, OBJPROP_CORNER, 0, CORNER_RIGHT_UPPER);
      } else {
        x_tmp = x1+x_diff*2;
      }
      ObjectSetInteger(0, object_name, OBJPROP_XDISTANCE, 0, x_tmp);
      //ObjectSetInteger(0, object_name, OBJPROP_XDISTANCE, 0, x1+x_diff*2);
      ObjectSetInteger(0, object_name, OBJPROP_YDISTANCE, 0, y0+(i+2)*y_diff);
      ObjectSetString(0, object_name, OBJPROP_FONT, 0, "Wingdings 3");
      if(iBands(str_symbols[i], PERIOD_D1, 20, 1, 0, PRICE_CLOSE,  MODE_UPPER, 1) < iClose(str_symbols[i], PERIOD_D1, 1)) {
        ObjectSetInteger(0, object_name, OBJPROP_COLOR, 0, clrUp);
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, "J");
        ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0xd3)+CharToString(0xd3));  // OK
        if(bIsFirstTime) {
          //g_comment_tmp = g_comment_tmp + str_symbols[i];
          bIsFirstTime = false;
        }
        //g_comment_tmp = g_comment_tmp + ": D1 up ikei2";
      } else if(iClose(str_symbols[i], PERIOD_D1, 1) < iBands(str_symbols[i], PERIOD_D1, 20, 1, 0, PRICE_CLOSE,  MODE_LOWER, 1)) {
        ObjectSetInteger(0, object_name, OBJPROP_COLOR, 0, clrDown);
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, "K");
        ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0xd4)+CharToString(0xd4));  // OK
        if(bIsFirstTime) {
          //g_comment_tmp = g_comment_tmp + str_symbols[i];
          bIsFirstTime = false;
        }
        //g_comment_tmp = g_comment_tmp + ": D1 dn ike2";
        //if(!bIsFirstTime) {
        //  //g_comment_tmp = g_comment_tmp + "\n";
        //}
      } else if( iClose(str_symbols[i], PERIOD_D1, 1) < iBands(str_symbols[i], PERIOD_D1, 20, 1, 0, PRICE_CLOSE,  MODE_UPPER, 1)
                 && iBands(str_symbols[i], PERIOD_D1, 20, 1, 0, PRICE_CLOSE,  MODE_MAIN, 1) < iClose(str_symbols[i], PERIOD_D1, 1)  ) {
        ObjectSetInteger(0, object_name, OBJPROP_COLOR, 0, clrUp);
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, "#");
        ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0xd3));  // OK
        if(bIsFirstTime) {
          //g_comment_tmp = g_comment_tmp + str_symbols[i];
          bIsFirstTime = false;
        }
        //g_comment_tmp = g_comment_tmp + ": M15 dn ike2";
      } else if(iBands(str_symbols[i], PERIOD_D1, 20, 1, 0, PRICE_CLOSE,  MODE_LOWER, 1) < iClose(str_symbols[i], PERIOD_D1, 1)
                && iClose(str_symbols[i], PERIOD_D1, 1)  <  iMA(str_symbols[i], PERIOD_D1, 20, 0, MODE_SMA, PRICE_CLOSE, 1) ) {
        ObjectSetInteger(0, object_name, OBJPROP_COLOR, 0, clrDown);
        //ObjectSetString(0, object_name, OBJPROP_TEXT, 0, "$");
        ObjectSetString(0, object_name, OBJPROP_TEXT, 0, CharToString(0xd4));  // OK
        if(bIsFirstTime) {
          //g_comment_tmp = g_comment_tmp + str_symbols[i];
          bIsFirstTime = false;
        }
        //g_comment_tmp = g_comment_tmp + ": M15 dn ike2";
      }
    }
    dt_M15_prev = dt_M15;
  }
  //CommentOBJ(g_comment_tmp);
//--- return value of prev_calculated for next call
  //Comment(g_comment_tmp);
  return(rates_total);
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
// TXT- で始まるオブジェクトを全削除する
void DelObj()
{
  string objname;
  for(int i=ObjectsTotal(); i>=0; i--) {
    objname = ObjectName(i);
    if( StringFind(objname,"TXT-")>=0) ObjectDelete(objname);
    if(0 == StringFind(objname,"muzu", 0)) ObjectDelete(objname);
  }
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

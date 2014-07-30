//+------------------------------------------------------------------+
//|                                   tensaix2j_amazingcrossover.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict


double PIP = 0.0001;
int call_it_a_day = 0;
int slpip = 100;
int tppip = 50;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
      /*
      Indicators
      ----------
      5 EMA -- YELLOW
      10 EMA -- RED
      RSI (10 - Apply to Median Price: HL/2) -- One level at 50. 
      
      
      TIME FRAME
      -------------
      1 Hour Only (very important!)
      
      
      VIEW
      -----
      Zoom in quite a bit on your chart so that the candlesticks and EMA's are very large. I use Alpari and this translates into the penultimate (one just previous of the highest) magnification.
      
      
      PAIRS
      ------
      Virtually any pair seems to work as this is strictly technical analysis.
      
      I recommend sticking to the main currencies and avoiding cross currencies (just my preference).
      
      
      WHEN TO ENTER A TRADE
      -------------------------
      
      Enter LONG when the Yellow EMA crosses the Red EMA from underneath.
      RSI must be approaching 50 from the BOTTOM and cross 50 to warrant entry.
      
      Enter SHORT when the Yellow EMA crosses the Red EMA from the top.
      RSI must be approaching 50 from the TOP and cross 50 to warrant entry.
      
      
      I've attached a picture which demonstrates all these conditions.
      
      Read more: http://forums.babypips.com/free-forex-trading-systems/19721-amazing-crossover-system-100-pips-per-day.html#ixzz38xZpF8k3
      */
      
      int ret;
      
      if ( OrdersTotal() == 0 ) {
         
         double ema_yellow_5_0  = iMA( Symbol(), PERIOD_H1,  5 , 0 , MODE_EMA, PRICE_CLOSE , 0 );
         double ema_yellow_5_1  = iMA( Symbol(), PERIOD_H1,  5 , 0 , MODE_EMA, PRICE_CLOSE , 1 );
         
         double ema_red_10_0    = iMA( Symbol(), PERIOD_H1, 10 , 0 , MODE_EMA, PRICE_CLOSE , 0 );
         double ema_red_10_1    = iMA( Symbol(), PERIOD_H1, 10 , 0 , MODE_EMA, PRICE_CLOSE , 1 );
         
         double rsi_50_0        = iRSI( Symbol(), PERIOD_H1, 10, PRICE_MEDIAN, 0 );
         double rsi_50_1        = iRSI( Symbol(), PERIOD_H1, 10, PRICE_MEDIAN, 1 );
         double rsi_50_2        = iRSI( Symbol(), PERIOD_H1, 10, PRICE_MEDIAN, 2 );
         
         double size = NormalizeDouble( AccountBalance() / 50000, 2 );
         
         
         // Cross from underneath
         if ( ema_yellow_5_1 < ema_red_10_1 && ema_yellow_5_0 >= ema_red_10_0 ) {
              
              if ( rsi_50_2 < rsi_50_1 && rsi_50_1 < rsi_50_0 && rsi_50_0 >= 50 ) {
                  ret = OrderSend( Symbol(), OP_BUY, size,  Ask, 11, Ask - slpip * PIP , Ask + tppip * PIP );
              }
         
         // Cross from the top                  
         } else if ( ema_yellow_5_1 > ema_red_10_1 && ema_yellow_5_0 <= ema_red_10_0 ) {
               
              if ( rsi_50_2 > rsi_50_1 && rsi_50_1 > rsi_50_0 && rsi_50_0 <= 40 ) {
                  ret = OrderSend( Symbol(), OP_SELL, size , Bid, 11 , Bid + slpip * PIP, Bid - tppip * PIP );
              }
         }
         
          
          
          
      }
   
   
  }
//+------------------------------------------------------------------+

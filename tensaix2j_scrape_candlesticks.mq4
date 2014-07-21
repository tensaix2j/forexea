//+------------------------------------------------------------------+
//|                                tensaix2j_scrape_candlesticks.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

#import "BidAskScraper.dll"

int initBidAskScraper( string str );
void deinitBidAskScraper();      
void writeString( string str );

#import


int OnInit()
  {
//---

   int ret = initBidAskScraper( "C:/Users/tensaix2j/Programming/forex/Candlestick_"  + Symbol() + "_" + IntegerToString( Period()) +  ".txt");
   
   
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
      int digitaccuracy = 5;
      if ( Symbol() == "USDJPY" ) {  
         digitaccuracy = 2;
      }
      
      string stropen = DoubleToStr( Open[1], digitaccuracy );
      if ( StringLen( stropen ) < 6 ) {
         stropen = " " + stropen;
      }
      string strhigh = DoubleToStr( High[1], digitaccuracy );
      if ( StringLen( strhigh ) < 6 ) {
         strhigh = " " + strhigh;
      }
      string strlow = DoubleToStr( Low[1], digitaccuracy );
      if ( StringLen( strlow ) < 6 ) {
         strlow = " " + strlow;
      }
      string strclose = DoubleToStr( Close[1], digitaccuracy );
      if ( StringLen( strclose ) < 6 ) {
         strclose = " " + strclose;
      }
      
        
    writeString( TimeToStr( Time[1] ) + " " + DoubleToStr(Time[1],0) + " " + stropen + " " + strhigh + " " + strlow + " " + strclose + "\n");
     
  }
//+------------------------------------------------------------------+

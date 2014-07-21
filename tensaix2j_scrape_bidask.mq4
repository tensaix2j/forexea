//+------------------------------------------------------------------+
//|                                       tensaix2j_scrapebidask.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict

#import "BidAskScraper.dll"

int initBidAskScraper( string str );
void deinitBidAskScraper();      
void writeString( string str );

#import




//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   int ret = initBidAskScraper( "C:/Users/tensaix2j/Programming/forex/BidAsk_" + Symbol() + ".txt");
   

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
      deinitBidAskScraper();
   
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
      
      string strbid = DoubleToStr(Bid, digitaccuracy );
      if ( StringLen( strbid ) < 6 ) {
         strbid = " " + strbid;
      }
      
      string strask = DoubleToStr(Ask,digitaccuracy);
      if ( StringLen( strask) < 6 ) {
         strask = " " + strask;
      }
         
      writeString( TimeToStr( TimeCurrent() ) + " " + DoubleToStr(TimeCurrent(),0) + " " + strbid + " " + strask + "\n");
      
  }
//+------------------------------------------------------------------+

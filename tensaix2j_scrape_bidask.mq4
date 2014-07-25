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
   int ret = initBidAskScraper( "C:/Users/tensaix2j/Programming/forex/tmp/BidAsk_" + Symbol() + ".txt");
   

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
  
  
string PadToAccuracy( string price, int digitaccuracy ) {
   
   string concat = "";
   int i;
   for ( i = 0 ; i < digitaccuracy - StringLen( price ) ; i++ ) {
      
      concat = concat + " ";
   }
   concat = concat + price ;
   return concat;
   
}
  
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
      
      string strbid = PadToAccuracy( DoubleToStr(Bid, Digits ) , Digits + 4 );
      string strask = PadToAccuracy( DoubleToStr(Ask, Digits ) , Digits + 4 );
      
      writeString( TimeToStr( TimeCurrent() ) + " " + DoubleToStr(TimeCurrent(),0) + " " + strbid + " " + strask + "\n");
      
  }
//+------------------------------------------------------------------+

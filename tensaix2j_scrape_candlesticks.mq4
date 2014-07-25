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

   int ret = initBidAskScraper( "C:/Users/tensaix2j/Programming/forex/tmp/Candlestick_"  + Symbol() + "_" + IntegerToString( Period()) +  ".txt");
   
   
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
      
      string stropen   = PadToAccuracy( DoubleToStr( Open[1], Digits ),  Digits + 4 );
      string strhigh   = PadToAccuracy( DoubleToStr( High[1], Digits ),  Digits + 4 );
      string strlow    = PadToAccuracy( DoubleToStr( Low[1], Digits ),   Digits + 4 );
      string strclose  = PadToAccuracy( DoubleToStr( Close[1], Digits ), Digits + 4 );
      
      writeString( TimeToStr( Time[1] ) + " " + DoubleToStr(Time[1],0) + " " + stropen + " " + strhigh + " " + strlow + " " + strclose + "\n");
     
  }
//+------------------------------------------------------------------+

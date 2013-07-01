//+------------------------------------------------------------------+
//|                                   tensaix2j_testrsimacdcombo.mq4 |
//|                                                        tensaix2j |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "tensaix2j"
#property link      ""

extern double SLPIP = 40;
extern double TPPIP = 40;
extern double betsize = 0.01;
extern bool martingale = false;
static double _betsize ;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
   _betsize = betsize;
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }

//---------
double lastOrderProfit() {
   
   if ( OrdersHistoryTotal() == 0 ) {
      return (0.0);
   } else {
      
      OrderSelect(OrdersHistoryTotal()-1, SELECT_BY_POS , MODE_HISTORY);
      return (OrderProfit() );
      
   }
}

double lastOrderSize() {
      
   if ( OrdersHistoryTotal() == 0 ) {
      return (betsize);
   } else {
      
      OrderSelect(OrdersHistoryTotal()-1, SELECT_BY_POS , MODE_HISTORY);
      return ( OrderLots() );
      
   }
}


//------------  
int lastOrderIsXHoursAgo( int x ) {

   // Get the most recent
   if ( OrdersTotal() == 0 ) {
      
      // No order at all, OK to make order
      return (1);
   
   } else { 
   
      // Has orders, check the last one if it is long ago enough
      
      OrderSelect( OrdersTotal() - 1 , SELECT_BY_POS );
      
      
      
      datetime currenttime = TimeCurrent();
      datetime opentime = OrderOpenTime();
      
      //Print( currenttime, " " , opentime, " " , currenttime - opentime );
      
      if ( currenttime - opentime > (3600 * x) ) {
         return (1);
      } else {
         return (0);
      }
     
   }
}  
  
  
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----

   double rsi = iRSI( Symbol(), PERIOD_H1,14, PRICE_CLOSE, 0 );
   
   // Note: Cannot use iMACD() function because it doesn't return the signal value
   // Note: Signal line is the EMA9 of MACD not EMA9 of price.
   
   double macd_arr[9];
   for ( int i = 0 ; i < 9 ; i++ ) {
      
      double old_ema12 = iMA( Symbol(), PERIOD_H1, 12 , 0, MODE_EMA, PRICE_CLOSE, i );
      double old_ema26 = iMA( Symbol(), PERIOD_H1, 26 , 0, MODE_EMA, PRICE_CLOSE, i );
      macd_arr[i]  = old_ema12 - old_ema26;
      
   }
   /*
   Print( "macd_arr", " " , 
            macd_arr[0], " " , 
            macd_arr[1], " " ,
            macd_arr[2], " " ,
            macd_arr[3], " " ,
            macd_arr[4], " " ,
            macd_arr[5], " " ,
            macd_arr[6], " " ,
            macd_arr[7], " " , 
            macd_arr[8] );
      
   */
   
   double signal  = iMAOnArray( macd_arr, 9, PERIOD_H1, 0, MODE_EMA, 0 );
   double macd = macd_arr[0];
   double macd_hist = macd - signal;
   
   double macd_hist_from_imacd = iMACD( Symbol() , PERIOD_H1, 12,26, 9, PRICE_CLOSE, MODE_MAIN, 0 );
   
   //Print( rsi," ", macd," ", signal," ", macd_hist," " , macd_hist_from_imacd );  
   
   // Has no order now
   if ( lastOrderIsXHoursAgo(24) == 1 ) {
       
       double slpoint;
       double tppoint;
       
       if ( martingale == true && lastOrderProfit() < 0.0 ) {
            _betsize = lastOrderSize() * 2.0;
            if ( _betsize > 8 * betsize ) {
              _betsize = 8 * betsize;
            }
            
       } else {
            _betsize = betsize;
       } 
       
       Print( _betsize );
       
       
       
       if ( rsi < 45.0 && macd < 0.0 && (macd - signal > 0) ) {     
          
          slpoint = Ask - Point * SLPIP * 10; 
          tppoint = Ask + Point * TPPIP * 10; 
          OrderSend( Symbol(), OP_BUY, _betsize , Ask,  10, slpoint, tppoint );
            
       } 
       
       /*
       if ( rsi > 85.0 && macd > 0.0 && (signal - macd > 0 )) {
         
          
         
          slpoint = Bid + Point * SLPIP * 10;
          tppoint = Bid - Point * TPPIP * 10;      
          OrderSend( Symbol(), OP_SELL, _betsize, Bid, 10 , slpoint , tppoint );
       }
       */
   }
         
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
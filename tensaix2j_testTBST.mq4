//+------------------------------------------------------------------+
//|                                           tensaix2j_testTBST.mq4 |
//|                                                        tensaix2j |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "tensaix2j"
#property link      ""




//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+

extern double PIP = 0.0001;
extern double SLPIP = 20;
extern double TPPIP = 80;



int init()
  {
//----
        
   
    
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
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   int i;
   bool sidewayflat = 0;
   
   
   //double betsize =  MathFloor( AccountBalance() / 50) * 0.01;
   double betsize = 0.01;
   if (betsize < 0.01 ) {
      betsize = 0.01;
   }
   
   
   if ( OrdersTotal() == 0 ) {
   
      // Select last closed position in the history
      OrderSelect(  OrdersHistoryTotal() - 1  ,  SELECT_BY_POS, MODE_HISTORY);
      
      if (  TimeMonth( OrderCloseTime() ) == TimeMonth(Time[0]) &&
            TimeDay( OrderCloseTime() )   == TimeDay(Time[0]) )  {
      
         // Don't reopen on the same day of SL
         // Do nothing   
      
      } else {
   
         // Bank Candle > 32 pips  , time is between 1500-0100 Malaysia/Singapore time(GMT +8)
         // hour +6 because octafx is GMT+2, adjust to GMT+8
         int  currenthour = TimeHour(Time[1] + 6 * 3600) ;
   
         double cbheight = MathAbs(Open[1]- Close[1] );
         if ( cbheight > 25 * PIP && cbheight < 46 * PIP && currenthour >= 15 && currenthour <= 23   ) {
      
            // Need to make sure the previous 4 bars are flat
            bool hasup = 0;
            bool hasdown = 0;
         
            double sideway_highest = High[2];
            double sideway_lowest  = Low[2];
         
            // Sideway
            for ( i = 2 ; i < 6 ; i++ ) {
         
               double barheight = MathAbs(Open[i] - Close[i] );
               double lhheight  = MathAbs(High[i] - Low[i] );
               
               
               if ( High[i] > sideway_highest ) {
                  sideway_highest = High[i];
               }
               if ( Low[i] < sideway_lowest ) {
                  sideway_lowest = Low[i];
               }
               
               if ( barheight > 20 * PIP || lhheight > 60 * PIP ) {
                  // no flat sideway
                  sidewayflat = 0;
                  break;
               } else {
               
                  if ( Open[i] > Close[i] ){
                     hasdown = 1;
                  } else {
                     hasup = 1;
                  }
               
               }
         
               // got flat side way
               sidewayflat = 1;
            }
         
      
            //CB wick
            double cbwick = 0.0;
            if ( Close[1] > Open[1] ) {
               cbwick = High[1] - Close[1]; 
            } else {
               cbwick = Close[1] - Low[1];
            }
         
      
            // got flat side way + bank candle, so buy
            // and sidewayHLrange < 30 and CB wick < 10
            double slpoint,tppoint;
            double sidewayHLrange = sideway_highest - sideway_lowest;
            
         
            if ( sidewayflat && hasup && hasdown && 
                     cbwick < 15 * PIP ) {
         
         
               Print( "Betsize", " " , betsize );
               
               if ( Close[1] > Open[1] ) {
            
                  // Green bank candle
                  slpoint = Ask - Point * SLPIP * 10; 
                  tppoint = Ask + Point * TPPIP * 10; 
                  OrderSend( Symbol(), OP_BUY, betsize , Ask,  10, slpoint, tppoint );
         
               } else {
         
                  // Red bank candle
                  slpoint = Bid + Point * SLPIP * 10;
                  tppoint = Bid - Point * TPPIP * 10;      
                  OrderSend( Symbol(), OP_SELL, betsize, Bid, 10 , slpoint , tppoint );
               }    
            }
         }
      }
   }
 
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
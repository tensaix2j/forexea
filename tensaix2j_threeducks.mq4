//+------------------------------------------------------------------+
//|                                         tensaix2j_threeducks.mq4 |
//|                                                        tensaix2j |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "tensaix2j"
#property link      ""

double PIP = 0.0001;
double SLPIP = 40;
double TPPIP = 50;
double betsize = 0.01;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
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
   
   if ( OrdersTotal() < 4 ) {
   
      
      
      OrderSelect( OrdersTotal() - 1 , SELECT_BY_POS, MODE_TRADES );
      if ( TimeDay(OrderOpenTime()) != TimeDay(Time[0]) ) {
            
         double slpoint,tppoint;
         
         double cH4 = iClose( Symbol() , PERIOD_H4 , 0 );
         double pH4 = iClose( Symbol() , PERIOD_H4 , 1 );
         
         double cH1 = iClose( Symbol() , PERIOD_H1 , 0 );
         double pH1 = iClose( Symbol() , PERIOD_H1 , 1 );
         
         double cM5 = iClose( Symbol() , PERIOD_M5 , 0 );   
         double pM5 = iClose( Symbol() , PERIOD_M5 , 1 );
         
         double smaH4  = iMA( Symbol(), PERIOD_H4, 60, 0, MODE_SMA , PRICE_CLOSE, 0 );
         double psmaH4 = iMA( Symbol(), PERIOD_H4, 60, 0, MODE_SMA , PRICE_CLOSE, 1 );
         
         double smaH1   = iMA( Symbol(), PERIOD_H1, 60, 0, MODE_SMA , PRICE_CLOSE, 0 );
         double psmaH1  = iMA( Symbol(), PERIOD_H1, 60, 0, MODE_SMA , PRICE_CLOSE, 1 );
         
         double smaM5 = iMA( Symbol(), PERIOD_M5, 60, 0, MODE_SMA , PRICE_CLOSE, 0 );
         double psmaM5 = iMA( Symbol(), PERIOD_M5, 60, 0, MODE_SMA , PRICE_CLOSE, 1 );
         
         
         
         // Sell Path
         if (  cH4 < smaH4 &&  pH4 > psmaH4 && 
               cH1 < smaH1 &&  pH1 > psmaH1 
                ) {
      
               slpoint = Bid + Point * SLPIP * 10;
               tppoint = Bid - Point * TPPIP * 10;      
               OrderSend( Symbol(), OP_SELL, betsize, Bid, 10 , slpoint , tppoint );          
      
          
         
         // Buy Path
         } else if (  
               cH4 > smaH4 &&  pH4 < psmaH4  &&
               cH1 > smaH1 &&  pH1 < psmaH1 ) {
            
               slpoint = Ask - Point * SLPIP * 10; 
               tppoint = Ask + Point * TPPIP * 10; 
               OrderSend( Symbol(), OP_BUY, betsize , Ask,  10, slpoint, tppoint );
         }
      }
   }   
   
//----
   return(0);
  }
//+------------------------------------------------------------------+






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

double PIP = 0.0001;
double SLPIP = 75;
double TPPIP = 25;

int lastTriedHour;


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
   
   
   if ( OrdersTotal() == 0 ) {
      
     if ( Hour() >= 4 && Hour() <= 11 && Minute() == 0 ) {
          
         
          
         // Identify C.B
         double CBheight = MathAbs( iClose( Symbol(), PERIOD_H1, 1 ) - iOpen( Symbol(), PERIOD_H1, 1 ) );
         
         
         if ( CBheight >= 28 * PIP && CBheight <= 36 * PIP ) {
             
             // Identify Sideways
             int sideway_OK = 1;
             int sw[6];
             
             int i;
             for ( i = 2 ; i <= 6 ; i++ ) {
             
                 if ( MathAbs( iHigh( Symbol(), PERIOD_H1, i ) - iLow( Symbol(), PERIOD_H1, i ) ) > 20 * PIP || MathAbs( iClose( Symbol(), PERIOD_H1, i ) -  iOpen( Symbol(), PERIOD_H1, i ) ) > 10 * PIP ) {
                     // No sideway
                     sideway_OK = 0;
                     
                        
                     //Print("Sideway " + (i-2) + " " + MathAbs( iHigh( Symbol(), PERIOD_H1, i ) - iLow( Symbol(), PERIOD_H1, i ) ) + " " +  MathAbs( iClose( Symbol(), PERIOD_H1, i ) -  iOpen( Symbol(), PERIOD_H1, i ) )  );
                     
                     break;
                 }
                 sw[i-2] = ( iClose( Symbol(), PERIOD_H1, i ) - iOpen( Symbol(), PERIOD_H1, i ) > 0 ) ? 1 : 0;      
             }
             
             
             if ( sideway_OK == 1 ) {
                 
                 if ( sw[0] == sw[1] && sw[1] == sw[2] ) {
                    // Bad sideway 
                    Print("Bad Sideway __XXX " , sw[4], " ", sw[3]," ", sw[2], " ", sw[1], " ", sw[0]);
                     
                 } else if ( sw[2] == sw[3] && sw[3] == sw[4] ) { 
                    
                    Print("Bad Sideway XXX__ " , sw[4], " ", sw[3]," ", sw[2], " ", sw[1], " ", sw[0]);
                                   
                                   
                 } else {
   
                     int ret;
                  
                     if ( iClose( Symbol(), PERIOD_H1, 1 ) -  iOpen( Symbol(), PERIOD_H1, 1 )  > 0 ) {
                        ret = OrderSend( Symbol(), OP_BUY, 0.01, Ask, 30, Ask - SLPIP * PIP, Ask + TPPIP * PIP );
                         
                     } else {
                        
                        ret = OrderSend( Symbol(), OP_SELL, 0.01, Bid, 30, Bid + SLPIP * PIP, Bid - TPPIP * PIP );
                     }
                 }
                  
             } else {
                  Print("No Sideway");
             }  
               
         } 
     }
     
   }
 
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
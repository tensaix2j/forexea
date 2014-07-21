//+------------------------------------------------------------------+
//|                                      tensaix2j_asianbreakout.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict

int call_it_a_day = 0;
int modified = 0;


double pip = 0.01;
double size = 0.01;

int tppip1 = 40;
int tppip2 = 70;
int slpip  = 25;


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
      int ret;
      
      if ( OrdersTotal() == 0 ) {

				
				if ( Hour() >= 8 && Hour() <= 9 && call_it_a_day == 0 ) {

					int offset = Hour() - 8;

					double high_from_6_to_7 = iHigh( Symbol(), PERIOD_H1, 2 + offset );
					if ( iHigh( Symbol(), PERIOD_H1, 1 + offset ) > high_from_6_to_7 ) 
					   high_from_6_to_7 = iHigh( Symbol(), PERIOD_H1, 1 + offset ) ;
      
					double low_from_6_to_7 = iLow( Symbol(), PERIOD_H1, 2 + offset );
					if ( iLow( Symbol(), PERIOD_H1, 1 + offset ) < low_from_6_to_7 )
					   low_from_6_to_7 = iLow( Symbol(), PERIOD_H1, 1 + offset );
               
					
					if ( Ask - high_from_6_to_7 >= 2 * pip ) {

                  ret = OrderSend( Symbol(), OP_BUY , size , Ask, 11, Ask - slpip * pip , Ask + tppip1 * pip );
                  ret = OrderSend( Symbol(), OP_BUY , size , Ask, 11, Ask - slpip * pip , Ask + tppip2 * pip );
                  
                  modified = 0	;	
						call_it_a_day = 1	;									

					} else if ( low_from_6_to_7 - Bid >= 2 * pip ) { 
						
						//ret = OrderSend( Symbol(), OP_SELL , size , Bid , 11, Bid + slpip * pip , Bid - tppip1 * pip );
                  //ret = OrderSend( Symbol(), OP_SELL , size , Bid , 11, Bid + slpip * pip , Bid - tppip2 * pip );
                  
                  modified = 0	;
						call_it_a_day = 1	;			
					}
				
				} else if ( Hour() == 10 ) {
					call_it_a_day = 0	;
				}

			
			} else if ( OrdersTotal() == 1 ) {
				
				if ( modified == 0 ) {
				
					ret = OrderSelect( 0, SELECT_BY_POS );
					ret = OrderModify( OrderTicket(), 0, OrderOpenPrice(), OrderTakeProfit(), 0 );
					modified = 1;
					
				}
			}
			
  }
//+------------------------------------------------------------------+

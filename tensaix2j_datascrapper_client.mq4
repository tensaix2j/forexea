//+------------------------------------------------------------------+
//|                                tensaix2j_datascrapper_client.mq4 |
//|                                                        tensaix2j |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "tensaix2j"
#property link      ""

#include <socket.mqh>
int channel;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
   channel = socket_client( 10000, "192.168.0.102");
   sock_send( channel , "fopen " + Symbol() + ".dat" + "\n" );
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   sock_send( channel , "fclose" + "\n" );
   sock_close( channel );
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+



int start()
  {
//----
      
   // Ready to send
   sock_send( channel, "data " + Time[1] + "," + TimeToStr(Time[1],TIME_DATE|TIME_SECONDS)   + "," + Open[1] + "," + High[1] + "," + Low[1] + "," + Close[1] +"\n" );
    
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
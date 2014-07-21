//+------------------------------------------------------------------+
//|                                        tensaix2j_eventsignal.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict

#define SOCKET_CONNECT_STATUS_OK				0
#define SOCKET_CONNECT_STATUS__ERROR		1000
#define SOCKET_CLIENT_WAIT_REPLY_TIMEOUT  400
#define SOCKET_CLIENT_STATUS_CONNECTED		1
#define SOCKET_CLIENT_STATUS_DISCONNECTED	2
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct SOCKET_CLIENT
  {
   uchar             status;   // status
   ushort            sequence; // sequence counter 
   uint              sock;     // socket number
  };

//+------------------------------------------------------------------+
#import "mqsocket.dll"
//+------------------------------------------------------------------+   
uint SocketOpen(
                SOCKET_CLIENT &cl,// variable to serve connection data
                string host,      // server host
                ushort port       // server port
                );

void SocketClose(
                 SOCKET_CLIENT &cl // variable to serve connection data
                 );

uint SocketWriteData(
                     SOCKET_CLIENT &cl,// variable to serve connection data
                     string symbol,    // symbol
                     datetime dt,      // tick time
                     double bid,       // Bid
                     double ask        // Ask
                     );

uint SocketWriteString(
                       SOCKET_CLIENT &cl,// variable to serve connection data
                       string str        // string
                       );
                       

uint SocketWriteString_ExpectReply(
                       SOCKET_CLIENT &cl,// variable to serve connection data
                       string str,        // string to send
                       string &reply,       // string as buffer for reply
                       int   timeout_ms
                       );

void TestFillString( string str );
                                              

#import
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum type
  {
   type_string,//String
   type_data   //Data
  };

input type TYPE_DATA=type_data;// data type

//#define host "10.55.2.154"
#define host "localhost"
#define port 10000

SOCKET_CLIENT client;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
   

   if(SocketOpen(client,host,port)==SOCKET_CONNECT_STATUS_OK) {
   
      Print("Socket Opened");
      
   }             
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   SocketClose(client);
   Print("Socket Closed");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

     static int lastResetDay = -1;
     static int lastResetHour = -1;
     static int checkCountPerHour = 0; 
     
     int thisMinute = TimeMinute( TimeCurrent() ) ;
     int thisHour   = TimeHour( TimeCurrent() );
     int thisDay    = TimeDay( TimeCurrent() );
     
     
     if (  !( thisDay   == lastResetDay &&
              thisHour  == lastResetHour ) ) {
         checkCountPerHour = 0;      
         
         lastResetDay = thisDay;
         lastResetHour = thisHour;
     }
      
     if ( checkCountPerHour < 2 && ( ( thisMinute == 20  && checkCountPerHour == 0 ) || thisMinute == 50 )  ) {
            
         string reply = "        ";
         string reply_arr[];
         
         uint ret = SocketWriteString_ExpectReply( client, "data " + Symbol() + " " + TimeCurrent()  + "\n" , reply , 3000 );
         StringSplit( reply, StringGetCharacter(" ",0), reply_arr );
   
         if ( reply_arr[0] == "signal" && reply_arr[1] != "none" ) {   
            
            Print("Reply is ", reply );
            
            if ( reply_arr[1] == "BUY" || reply_arr[1] == "BUYD" ) {
               OrderSend( Symbol(), OP_BUY, 0.01, Ask, 3, Ask - 0.0030 , Ask + 0.0020 ); 
            
            } else if ( reply_arr[1] == "SELL" ) {
               OrderSend( Symbol(), OP_SELL, 0.01, Bid, 3, Bid + 0.0030 , Bid - 0.0020 ); 
            
            }
         
         }
         
         checkCountPerHour += 1;
             
     } 
  
   
  }
//+------------------------------------------------------------------+

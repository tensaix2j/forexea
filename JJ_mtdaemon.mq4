//+------------------------------------------------------------------+
//|                                                  JJ_mtdaemon.mq4 |
//|                                               Copyright 2013, JJ |
//|                                                                  |
//+------------------------------------------------------------------+


#property copyright "Copyright 2013, JJ"
#property link      ""


#include <select.mqh>

int sock_server;
int ctrl_flags[10];

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init() {

    sock_server = socket_server( 10000 );
    ctrl_flags[0] = 1;
	run_select_loop( sock_server, ctrl_flags );	
	
   	return(0);
}


//-------
void select_ondata_callback( int sock, string msg ) {

	Print("Sock : ", sock , " Msg : " , msg );
	if ( msg == "quit" ) {
		Print("Quitting! Bye");
		ctrl_flags[0] = 0;
		closesocket(sock_server);
		WSACleanup();
	}

}


//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
   Print("Deinit");
   closesocket(sock_server);
              
//----
   return(0);
  }




//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+


#include <socket.mqh>



//+------------------------------------------------------------------+
//|                                tensaix2j_datascrapper_client.mq4 |
//|                                                        tensaix2j |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "tensaix2j"
#property link      ""

int channel;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
   channel = socket_client( 20000, "192.168.0.103");
   
   sock_send( channel , "fopen " + Symbol() + ".dat" + "\r\n" );
   
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   sock_send( channel , "fclose" + "\r\n" );
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
   
   // Basic
   
   //Print("Current bar for USDCHF H1: ",iTime("USDCHF",PERIOD_H1,i),", ",  iOpen("USDCHF",PERIOD_H1,i),", ",
   //                                   iHigh("USDCHF",PERIOD_H1,i),", ",  iLow("USDCHF",PERIOD_H1,i),", ",
   //                                   iClose("USDCHF",PERIOD_H1,i),", ", iVolume("USDCHF",PERIOD_H1,i));
   
   
   // MACD
   //double iMACD(	string symbol, int timeframe, int fast_ema_period, int slow_ema_period, int signal_period, int applied_price, int mode, int shift)
   double MAFastTrendPeriod = 12;
   double MASlowTrendPeriod = 26;
   double MacdCurrent   =  iMACD(NULL,0,MAFastTrendPeriod,MASlowTrendPeriod,9,PRICE_CLOSE,MODE_MAIN,0);
   double MacdPrevious  =  iMACD(NULL,0,MAFastTrendPeriod,MASlowTrendPeriod,9,PRICE_CLOSE,MODE_MAIN,1);
   double SignalCurrent =  iMACD(NULL,0,MAFastTrendPeriod,MASlowTrendPeriod,9,PRICE_CLOSE,MODE_SIGNAL,0);
   double SignalPrevious=  iMACD(NULL,0,MAFastTrendPeriod,MASlowTrendPeriod,9,PRICE_CLOSE,MODE_SIGNAL,1);
   
   // EMA
   //double iMA(	string symbol, int timeframe, int period, int ma_shift, int ma_method, int applied_price, int shift)
   double MovingPeriod     =  12;
   double MovingShift      =  6;
   double EMA0        =  iMA(  NULL,0,MovingPeriod,MovingShift,MODE_EMA,PRICE_CLOSE,0);
   double EMA1       =  iMA(  NULL,0,MovingPeriod,MovingShift,MODE_EMA,PRICE_CLOSE,1);
   double EMA_diff = EMA0 - EMA1; 
   
   // SMA
   //double iMA(	string symbol, int timeframe, int period, int ma_shift, int ma_method, int applied_price, int shift)
   double SMA0        =  iMA(  NULL,0,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,0);
   double SMA1       =  iMA(  NULL,0,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,1);
   double SMA_diff   = SMA0 - SMA1;
   
   
   // Stoch
   //double iStochastic(	string symbol, int timeframe, int %Kperiod, int %Dperiod, int slowing, int method, int price_field, int mode, int shift)
   double StotCurrent   = iStochastic(NULL, 0, 5, 3, 3, MODE_SMA, 1, MODE_MAIN, 0);
   double StotPrevious  = iStochastic(NULL, 0, 5, 3, 3, MODE_SMA, 1, MODE_MAIN, 1);

   // ADX
   //double iADX(	string symbol, int timeframe, int period, int applied_price, int mode, int shift)
   double ADXP     = iADX(NULL, 0, 14, PRICE_CLOSE, MODE_MAIN, 2);
   double ADXC     = iADX(NULL, 0, 14, PRICE_CLOSE, MODE_MAIN, 1);
   double ADXDIPP  = iADX(NULL, 0, 14, PRICE_CLOSE, MODE_PLUSDI, 2);
   double ADXDIPC  = iADX(NULL, 0, 14, PRICE_CLOSE, MODE_PLUSDI, 1);  
   double ADXDIMP  = iADX(NULL, 0, 14, PRICE_CLOSE, MODE_MINUSDI, 2);
   double ADXDIMC  = iADX(NULL, 0, 14, PRICE_CLOSE, MODE_MINUSDI, 1);    
   
   // RSI
   int RSIPeriod=14;
   double RSI0 =iRSI(NULL,0,RSIPeriod,PRICE_CLOSE,0);
   double RSI1 =iRSI(NULL,0,RSIPeriod,PRICE_CLOSE,1);
   
   // Momentum
   double MO0 = iMomentum(NULL, NULL,5,0,0);
   double MO1 = iMomentum(NULL, NULL,5,0,1);
   
   // Demarker
   double DEMARKER0 = iDeMarker(NULL,0,25,0);
   double DEMARKER1 = iDeMarker(NULL,0,25,1);
   
   // Ichimoku
   int Tenkan=9;
   int Kijun=26;
   int Senkou=52;

   double TENKANSEN0   = iIchimoku(NULL,0,Tenkan,Kijun,Senkou,MODE_TENKANSEN,0);
   double TENKANSEN1   = iIchimoku(NULL,0,Tenkan,Kijun,Senkou,MODE_TENKANSEN,1);
   double TENKANSEN2   = iIchimoku(NULL,0,Tenkan,Kijun,Senkou,MODE_TENKANSEN,2);
   double TENKANSEN_diff0 = TENKANSEN0 - TENKANSEN1;
   double TENKANSEN_diff1 = TENKANSEN1 - TENKANSEN2;
   
   

   // Ready to send
   sock_send( channel , iTime( Symbol(), Period(), 0)   + " " + 
                        
                        Ask + " " + 
                        Bid + " " + 
                        
                        iOpen( Symbol(), Period(), 0)   + " " + 
                        iHigh( Symbol(), Period(), 0)   + " " + 
                        iLow( Symbol(), Period(), 0)   + " " + 
                        iClose( Symbol(), Period(), 0)   + " " + 
                        iVolume( Symbol(), Period(), 0)   + " " + 
                        
                        
                        MacdCurrent + " " + 
                        MacdPrevious + " " + 
                        SignalCurrent + " " + 
                        SignalPrevious + " " + 
                        
                        EMA_diff + " " + 
                        SMA_diff + " " + 
                        
                        
                        StotCurrent + " " + 
                        StotPrevious + " " + 
                        
                        ADXP + " " +
                        ADXC + " " +
                        ADXDIPP + " " +
                        ADXDIPC + " " +
                        ADXDIMP + " " +
                        ADXDIMC + " " +
                        
                        RSI0 + " " +
                        RSI1 + " " +
                        
                        MO0 + " " +
                        MO1 + " " +
                        
                        DEMARKER0 + " " +
                        DEMARKER1 + " " +
                        
                        TENKANSEN_diff0 + " " +
                        TENKANSEN_diff1 + " " +
                        
                       
                        
                        "\r\n");
   
   
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
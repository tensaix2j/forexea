
require 'rubygems'
require 'socket'
require 'json'


#--------
def accept_new_connection( sock )
	
	newsock = sock.accept
	@descriptors << newsock
	@clients << newsock;
	
	puts "#{newsock.to_s} connected."
	
end

#-----------
def settle_incoming_msg( sock )
	
	begin
		if sock.eof? 
			puts "#{sock.to_s} closed."
			sock.close
			@descriptors.delete(sock)
			@clients.delete( sock )

		else
			msg = sock.gets()
			#puts "#{ sock }: #{msg}"
			dispatch_msg( msg  , sock)
		end
	
	rescue Exception => e
		
		puts e.message()
		puts e.backtrace()

	end
end


#------------
def broadcast ( sock , msg )

	puts "Broadcasting: #{msg}"
	
	@clients.each { |s|

		begin
			s.puts( msg ) if ( s != sock ) 
		rescue
			puts "Unable to write into #{s}. Skipping.."
		end

	}
end


#----------------
$loaded = {}
$fp = nil
$myqueue = []

def dispatch_msg( msg , sock ) 
	
	msg_arr = msg.split(" ")
	msg_header = msg_arr[0]
		
	# Do shit here. 
	if msg_header[/broadcast/] 

		msg_arr.shift()
		msg_payload = msg_arr * " "
		broadcast(sock, msg_payload )



	elsif  msg_header[/loadfile/]
		
		if $loaded[msg_arr[1]] == nil
			loadfile( msg_arr[1] )
		else
			puts "Already loaded"	
		end	



	elsif msg_header[/loadmodel/]

		if $loaded[msg_arr[1]] == nil
			loadmodel( msg_arr[1] )
		else
			puts "Already loaded"
		end


	elsif msg_header[/fopen/] != nil

		filename = msg_arr[1]
        $fp = File.open( filename , 'w' )
        puts "Opened #{filename}"
        

    elsif msg_header[/fclose/] != nil

        $fp.close()
		puts "Closed fp"
        

	elsif msg_header[/getevent/]

		time   		= msg_arr[1]
		symbol_1 	= msg_arr[2][0..2]
		symbol_2 	= msg_arr[2][3..5]
		
		if $record[ [time,symbol_1] ] != nil

			sock.puts( "OK " + time + " " + symbol_1 + " " + $record[ [time,symbol_1] ] * " ")

		elsif $record[ [ time,symbol_2] ] != nil
					
			sock.puts( "OK " + time + " " + symbol_2 + " " + $record[ [time,symbol_2] ] * " ")
						
		else
			sock.puts "no_news"

		end


	elsif msg_header[/to_predict/]

		if $model == nil 

			puts "Model not loaded"
		else

			msg_arr.shift()
			msg_payload = msg_arr * " "

			tohlc = msg_payload.split(",")

			o = tohlc[2].to_f
			h = tohlc[3].to_f
			l = tohlc[4].to_f
			c = tohlc[5].to_f

			extract_prop(o,h,l,c, $myqueue)
			
			# Collected enough 
			if $myqueue.length == 5

				result = []
				extract_pattern( $myqueue , $model , 0 , result )
				
				if result[0] + result[1] != 0
					puts msg_payload
					p result
				end

				$myqueue.shift()
			else

				puts "Not enough data yet. #{ $myqueue.length} "
			end
		end	

	elsif msg_header[/data/] 

		if $fp != nil
            
			msg_arr.shift()
			msg_payload = msg_arr * " "

            $fp.puts( msg_payload )
            $fp.flush()

        end

	end
	
end




#--------------
$record = {}


def loadfile( econevent_file )

	fp =  File.open( econevent_file )
	line = fp.gets()
	while ( !fp.eof() )
		
		line = fp.gets()
		arrs = line.split(",")
		if arrs[1] == "USD" || arrs[1] == "EUR"

			if $record[ [arrs[0],arrs[1]] ] == nil || arrs[2] > $record[ [arrs[0],arrs[1]] ][0]
				$record[  [arrs[0],arrs[1]]  ] = [ arrs[2], arrs[3], arrs[4], arrs[5] ]
			end
		end

	end
	$loaded[ econevent_file ] = 1
	fp.close()


end


#-------------------
$model = nil

def loadmodel( model_file )

	puts "Loading model #{ model_file }"
	
	require "modeling.rb"
	begin 
		
		$model = {}
		fp =  File.open( model_file )
		
		while ( !fp.eof() )	

			line = fp.gets()

			arrs = line.split(",").map { |i| i.to_i }
			key =  arrs[0...10]
			val =  arrs[10...12]
			$model[key] = val
		end
		
		$loaded[ model_file ] = 1
			
		
	rescue
		puts e.message
	end

	
	
	fp.close()

end




#------------
def main( argv )

	@descriptors = Array::new

	if argv.length < 1
		puts "Usage: ruby rsocket.rb <port>"
		return
	end

	port = argv[0]
	
	@serverSocket = TCPServer.new("", port)
	@serverSocket.setsockopt( Socket::SOL_SOCKET, Socket::SO_REUSEADDR, 1 )
	@descriptors << @serverSocket
	@clients = []
	printf "Server started on port %d\n", port
	
	while (1)
		
		res = select( @descriptors, nil ,nil ,nil )
		if res != nil
			res[0].each do
				|sock|
				if sock == @serverSocket 
					accept_new_connection( sock )
				else
					settle_incoming_msg( sock )
				end
			end
		end
	end
end

main ARGV




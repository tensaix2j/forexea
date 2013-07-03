
require 'rubygems'
require 'socket'


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
			puts "#{ sock }: #{msg}"
			
			dispatch_msg( msg  , sock)
		end
	
	rescue
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
$fp = nil

def dispatch_msg( msg , sock ) 
	
	msg_arr = msg.split(" ")
	msg_header = msg_arr[0]
		
	# Do shit here. 
	if msg_header[/broadcast/] 

		msg_arr.shift()
		msg_payload = msg_arr * " "
		broadcast(sock, msg_payload )

	elsif  msg_header[/loadfile/]
		
		if $loaded == 0
			$loaded = 1
			loadfile
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
$loaded = 0

def loadfile()

	fp =  File.open( "econevent.dat")
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

	p $record

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




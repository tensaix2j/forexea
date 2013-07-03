

require 'rubygems'
require 'time'
require 'json'

# No neural network please. Stupid NN
#require 'neuro'



def main( argv )


	fp = File.open(argv[0])

	myqueue = []

	while ( !fp.eof() )
		
		line = fp.gets()
		
		line.split(",")
		o = line[2].to_f
		h = line[3].to_f
		l = line[4].to_f
		c = line[5].to_f

		# Extract candleprop and stuff to myqueue
		extract_prop( o,h,l,c, myqueue )

		# Collected enough 
		if myqueue.length == 6

			extract_pattern( myqueue , $pat_l4, 1 , [] )

			myqueue.shift()
		end
		

	end
	fp.close()

	#Dump
	$pat_l4.keys.each {
		|key|
		puts "#{key * ","},#{ $pat_l4[key] * "," }"

	}




end



#---------------------
$pat_l4 = {}

def extract_pattern( myqueue , model, teaching_or_predicting , result ) 

	bullcount = 0
	up_pinbarcount = 0
	down_pinbarcount = 0
	flatter = 0
	big_barcount = 0
	big_up = 0
	big_down = 0

	conseq_up = 0
	conseq_down = 0
	conseq_alt = 0

	t_conseq_updown = 0
	t_conseq_alt = 0


	(0...5).each { |i|
		bullcount += myqueue[i][3]
	
		# Long top wick
		if myqueue[i][0] == 2 && myqueue[i][2] < 2 
			up_pinbarcount += 1
		end			
		
		if myqueue[i][2] == 2 && myqueue[i][0] < 2 
			down_pinbarcount += 1
		end			

		if myqueue[i][0]  + myqueue[i][1] + myqueue[i][2] == 0
			flatter += 1
		end

		if i > 0 && myqueue[i-1][3] == myqueue[i][3]
			t_conseq_alt = 0
			t_conseq_updown += 1
			
			conseq_up    = t_conseq_updown if myqueue[i][3] == 1 && t_conseq_updown > conseq_up
			conseq_down  = t_conseq_updown if myqueue[i][3] == 0 && t_conseq_updown > conseq_down

		else
			t_conseq_updown = 0
			t_conseq_alt += 1

			conseq_alt = t_conseq_alt if t_conseq_alt > conseq_alt
		end

		if myqueue[i][4] > 0.00260 

			big_barcount += 1

			if myqueue[i][3] == 1
				big_up += 1
			else
				big_down += 1
			end
		end

	}

	key = [ bullcount,up_pinbarcount,down_pinbarcount,flatter,
			big_barcount,big_up,big_down, 
			conseq_up, conseq_down, conseq_alt ]
	
	if teaching_or_predicting == 1
	
		# 6th bar is up or down
		result = myqueue[5][3] 

		model[ key ] = [0,0] if model[key] == nil
		model[ key ][ result ] += 1

	else
		if model[key] != nil
			result[0] = model[key][0]
			result[1] = model[key][1]
		else
			result[0] = 0
			result[1] = 0
		end	
	end	


end	

#--------



#--------------
def categorizer( val ) 

	if val >= 0.40 
		return 2

	elsif val <= 0.12
		
		return 0
	else
		
		return 1
	end	

end

#-------------------------
def extract_prop(o,h,l,c, result)

	entiresize 		= h - l
	bodysize 		= ( o - c ).abs
	bodytop 		=  o > c ? o : c
	bodybottom 		= o < c ? o : c
	topwicksize 	= h - bodytop
	bottomwicksize 	= bodybottom - l
	bullish  		= c > o ? 1 : 0

	if  entiresize >= 0.00080 
		
		topwick_percent  = topwicksize * 1.0 / entiresize  
		topwick_type 	 = categorizer( topwick_percent )

		body_percent 	 = bodysize * 1.0 / entiresize
		body_type 		 = categorizer( body_percent )

		bottomwick_percent = bottomwicksize * 1.0 / entiresize
		bottomwick_type  = categorizer( bottomwick_percent )

		result << [ topwick_type, body_type, bottomwick_type, bullish, entiresize ]
	
	else
		result << [ 0 , 0 , 0 , bullish , entiresize ]
	end
end

#-------
def experiment()
	myqueue = [
				[ 0,0,1, 0,0.00100 ],
				[ 0,0,1, 0,0.00400 ],
				[ 0,0,1, 1,0.00400 ],
				[ 0,0,1, 0,0.00100 ],
				[ 0,0,1, 0,0.00400 ]
			]

	extract_pattern(myqueue )

	p $pat_l4

end

#-----------------------
if ARGV[0] == "main"

	# To run as executable, ruby main EURUSD.dat
	ARGV.shift	
	main(ARGV)

end

















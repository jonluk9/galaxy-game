note
	description: "Summary description for {ERROR_MESSAGES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ERROR_MESSAGES

create {ERROR_MESSAGE_ACCESS}
	make

feature{NONE}
	make
		do

		end



feature -- assigner methods
	ABORT:STRING
	do
		--Result.make_empty
		Result:="%N"+"  "+"Negative on that request:no mission in progress."
	end
	LAND(i:INTEGER;exp:EXPLORER):STRING
	do

		inspect i
		when 1 then--N
			Result:="%N"+"  "+"Negative on that request:no mission in progress."
		when 2 then--NE
			Result :="%N"+"  "+"Negative on that request:already landed on a planet at Sector:"+exp.row.out+":"+exp.column.out
		when 3 then--E
			Result :="%N"+"  "+"Negative on that request:no yellow dwarf at Sector:"+exp.row.out+":"+exp.column.out
		when 4 then--SE
			Result :="%N"+"  "+"Negative on that request:no planets at Sector:"+exp.row.out+":"+exp.column.out
		else--NW
			Result :="%N"+"  "+"Negative on that request:no unvisited attached planet at Sector:"+exp.row.out+":"+exp.column.out
		end
	end
	LIFTOFF(i:INTEGER;exp:EXPLORER):STRING
	do

		inspect i
		when 1 then--N
			Result:="%N"+"  "+"Negative on that request:no mission in progress."
		else--NW
			Result :="%N"+"  "+"Negative on that request:you are not on a planet at Sector:"+exp.row.out+":"+exp.column.out
		end
	end
	MOVE(i:INTEGER;exp:EXPLORER):STRING
	do

		inspect i
		when 1 then--N
			Result:="%N"+"  "+"Negative on that request:no mission in progress."
		when 2 then--N
			Result :="%N"+"  "+"Negative on that request:you are currently landed at Sector:"+exp.row.out+":"+exp.column.out

		else--NW
			Result :="%N"+"  "+"Cannot transfer to new location as it is full."
		end
	end
	PASS:STRING
	do
		--Result.make_empty
		Result:="%N"+"  "+"Negative on that request:no mission in progress."
	end
	PLAY:STRING
	do
		--Result.make_empty
		Result:="%N"+"  "+"To start a new mission, please abort the current one first."
	end
	STATUS:STRING
	do
		--Result.make_empty
		Result:="%N"+"  "+"Negative on that request:no mission in progress."
	end
	TEST(i:INTEGER):STRING
	do
		--Result.make_empty
		inspect i
		when 1 then--N
			Result:="%N"+"  "+"To start a new mission, please abort the current one first."
		else--NW
			Result:="%N"+"  "+"Thresholds should be non-decreasing order."
		end
	end
	WORMHOLE(i:INTEGER;exp:EXPLORER):STRING
	do

		inspect i
		when 1 then--N
			Result:="%N"+"  "+"Negative on that request:no mission in progress."
		when 2 then--N
			Result :="%N"+"  "+"Negative on that request:you are currently landed at Sector:"+exp.row.out+":"+exp.column.out

		else--NW
			Result :="%N"+"  "+"Explorer couldn't find wormhole at Sector:"+exp.row.out+":"+exp.column.out

		end
	end

--DEATH MESSAGES
----------------------------------------------------------
--Below are different death messages each entity may have listed in priority:

--EXPLORER:
--1. (Out of fuel.) “Explorer got lost in space - out of fuel at Sector:X:Y” where X and Y are the row and column where the explorer ran out of fuel.
--2. (Death due to blackhole.) “Explorer got devoured by blackhole (id: -1) at Sector:3:3”
--3. (Death due to asteroid.) “Explorer got destroyed by asteroid (id: Z) at Sector:X:Y” where X and Y are the row and column where the explorer got hit by an asteroid and Z is the asteroid id.
--4. (Death due to malevolent.) “Explorer got lost in space - out of life support at Sector:X:Y” where X and Y are the row and column where the explorer ran out of life (due to malevolent).

--BENIGN:
--1. (Out of fuel.) “Benign got lost in space - out of fuel at Sector:X:Y” where X and Y are the row and column where the benign ran out of fuel.
--2. (Death due to blackhole.) “Benign got devoured by blackhole (id: -1) at Sector:3:3”
--3. (Death due to asteroid.) “Benign got destroyed by asteroid (id: Z) at Sector:X:Y” where X and Y are the row and column where the benign got hit by an asteroid and Z is the asteroid id.

--MALEVOLENT:
--1. (Out of fuel.) “Malevolent got lost in space - out of fuel at Sector:X:Y” where X and Y are the row and column where the malevolent ran out of fuel.
--2. (Death due to blackhole.) “Malevolent got devoured by blackhole (id: -1) at Sector:3:3”
--3. (Death due to asteroid.) “Malevolent got destroyed by asteroid (id: Z) at Sector:X:Y” where X and Y are the row and column where the malevolent got hit by an asteroid and Z is the asteroid id.
--4. (Death due to benign.) “Malevolent got destroyed by benign (id: Z) at Sector:X:Y”  where X and Y are the row and column where the malevolent got destroyed by a benign and Z is the benign id.

--JANITAUR:
--1. (Out of fuel.) “Janitaur got lost in space - out of fuel at Sector:X:Y” where X and Y are the row and column where the janitaur ran out of fuel.
--2. (Death due to blackhole.)  “Janitaur got devoured by blackhole (id: -1) at Sector:3:3”
--3. (Death due to asteroid.) “Janitaur got destroyed by asteroid (id: Z) at Sector:X:Y” where X and Y are the row and column where the janituar got hit by an asteroid and Z is the asteroid id.

--ASTEROID:
--1. (Death due to blackhole.)  “Asteroid got devoured by blackhole (id: -1) at Sector:3:3”
--2. (Death due to janitaur.)  “Asteroid got imploded by janitaur (id: Z) at Sector:X:Y” where X and Y are the row and column where the asteroid got destroyed by a janitaur and Z is the janitaur id.

--PLANET:
--1. (Death due to blackhole.) “Planet got devoured by blackhole (id: -1) at Sector:3:3”

end

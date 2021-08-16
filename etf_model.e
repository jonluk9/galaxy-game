note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
		local

    		sa: SHARED_INFORMATION_ACCESS
			-- Initialization for `Current'.
		do
        	info := sa.shared_info
        	error := ea.error
        	info.test(3,5,7,15,30)
			create status_.make_empty
			create error_message.make_empty
			status_:="%N"+"  "+"Welcome! Try test(3,5,7,15,30)"
			create test_mode_display.make_empty

			create galaxy.make_empty
			i := 0
			count1 := 0
			count2 := 0
			fuel:=3
			life:=3
			test_mode := FALSE
			show_map := FALSE
			aborted := FALSE
			b_error:= FALSE
			b_status:= FALSE
			in_game := FALSE
			started := FALSE

			abort_message := ""
		end

feature -- model attributes
	status_ : STRING
	i : INTEGER
	galaxy:GALAXY
	test_mode:BOOLEAN
	b_error:BOOLEAN
	b_status:BOOLEAN
	show_map:BOOLEAN
	test_mode_display : STRING
	fuel:INTEGER
	life:INTEGER
	count1:INTEGER
	count2:INTEGER
    info: SHARED_INFORMATION
    error: ERROR_MESSAGES
    ea: ERROR_MESSAGE_ACCESS
	aborted:BOOLEAN
    abort_message : STRING
    error_message : STRING
    in_game:BOOLEAN
    started:BOOLEAN
--	temp: RANDOM_GENERATOR
--	r_generator: RANDOM_GENERATOR
--	access: RANDOM_GENERATOR_ACCESS

feature -- model operations
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	reset
			-- Reset model state.
		do
			make
		end

	abort
   -- Ends the game prematurely. Only valid when game is
   -- in progress.
	   local

		do

			aborted:=true
			show_map:=false
         count2:= count2+1
		if(in_game) then
			abort_message:=("%N"+"  "+"Mission aborted. Try test(3,5,7,15,30)")
			in_game:= false
		else
			b_error:=true
			abort_message:= error.abort


		end
		end

	land
    -- Lands the explorer on a planet to check for life on planet.
    -- A game has to be in progress, the explorer is not already
    -- landed and there must be a planet with a yellow dwarf in the
    -- current sector where that planet has not been landed on yet.
    -- If there are multiple planets in this sector, land on the one
    -- that has not been landed on yet with the lowest id.
    -- Note that this command will cause a turn to pass/occur.
    -- After the explorer land, other moveable entities whose clock
    -- time (rest) is zero also act in id order, i.e. 1, 2, ..
    -- In test mode: displays entity actions, abstract state,
    -- then board.
	   local

--		valid:BOOLEAN
		do
			if(in_game)
			then
				galaxy.turn("land")
				if not galaxy.m_error then
					count1:=count1+1
					count2:=0

					show_map:=true
				else
--					b_error:=true
					count2:=count2+1
					show_map:=false

				end
			else
				b_error:=true
				count2:=count2+1
				error_message:= error.land (1, galaxy.exp)
					show_map:=false
			end
		end

	liftoff
    -- Lifts the explorer off a planet.
    -- A game has to be in progress and the explorer is landed
    -- on a planet which also has a yellow dwarf in the same
    -- sector that cannot support life.
    -- The explorer remains in its quadrant, but can now move.
    -- Note that this command will cause a turn to pass/occur.
    -- After the explorer liftoff, other moveable entities whose clock
    -- time (rest) is zero also act in id order, i.e. 1, 2, ..
    -- In test mode: displays entity actions, abstract state,
    -- then board.
	   local

--		valid:BOOLEAN
		do
			if(in_game)
			then
				galaxy.turn ("liftoff")
				if not galaxy.m_error then
					count1:=count1+1
					count2:=0

				else
--					b_error:=true
					count2:=count2+1
					show_map:=false

				end
			else
				b_error:=true
				count2:=count2+1
				error_message:= error.liftoff (1, galaxy.exp)
					show_map:=false
			end
		end

	move(dir: INTEGER_32)
    -- Moves the explorer in a given direction.
    -- A game has to be in progress and the sector
    -- to travel to is not full.
    -- Note that this command will cause a turn to pass/occur.
    -- After the explorer moves, other moveable entities whose clock
    -- time (rest) is zero also act in id order, i.e. 1, 2, ..
    -- In test mode: displays entity actions, abstract state,
    -- then board.
	   local

--		valid:BOOLEAN
		do
			if(in_game)
			then
				galaxy.move (dir)
				if not galaxy.m_error then
					count1:=count1+1
					count2:=0
				else
--					b_error:=true
					count2:=count2+1

				end
			else
				b_error:=true
				count2:=count2+1
				error_message:= error.move (1, galaxy.exp)
			end

	end

	pass
    -- Lets the explorer pass a turn.
    -- Note that this command will cause a turn to pass/occur
    -- and other entities can affect the explorer.
    -- After the explorer pass, other moveable entities whose clock
    -- time (rest) is zero also act in id order, i.e. 1, 2, ..
    -- In test mode: displays entity actions, abstract state,
    -- then board.
	   local

--		valid:BOOLEAN
		do
			if(in_game)
			then
				galaxy.turn ("pass")
				if not galaxy.m_error then
					count1:=count1+1
					count2:=0
				else
--					b_error:=true
					count2:=count2+1

				end
			else
				b_error:=true
				count2:=count2+1
				error_message:= error.pass
			end
		end

	play
   -- Starts a new game using test(30)
   -- provided a game has not been started yet or is over.
   -- Play mode displays only the board and key messages as outputs
   -- and not the complete abstract state.
		local
--			valid:BOOLEAN

    		sa: SHARED_INFORMATION_ACCESS
			-- Initialization for `Current'.
		do
--			valid:=true
			if not(in_game)
			then
				show_map:=true
				test_mode:=false
				count1:=count1+1
				count2:=0
	        	info := sa.shared_info
        		info.test(3,5,7,15,30)
				galaxy.make
				in_game:=true
			else
				b_error:=true
				count2:=count2+1
				error_message:= error.play
			end
		end

	status
     -- Displays explorer's energy, life and sector.
     -- Note that this command does not cause a turn to pass/occur

	   local

--		valid:BOOLEAN
		do
			if(in_game)
			then
				count2:=count2+1
				b_status:=true
				show_map:=false
				if(galaxy.exp.landed=FALSE) then
					status_:="%N  "+"Explorer status report:Travelling at cruise speed at ["+galaxy.exp.row.out+","+galaxy.exp.column.out+","+galaxy.exp.quad.out+"]"
				else
					status_:="%N  "+"Explorer status report:Stationary on planet surface at ["+galaxy.exp.row.out+","+galaxy.exp.column.out+","+galaxy.exp.quad.out+"]"

				end
				status_:=status_+"%N  "+"Life units left:"+galaxy.exp.life.out+", Fuel units left:"+galaxy.exp.fuel.out
			else
				b_error:=true
				count2:=count2+1
				error_message:= error.status
					show_map:=false

			end
		end


	test(a_threshold: INTEGER_32 ; j_threshold: INTEGER_32 ; m_threshold: INTEGER_32 ; b_threshold: INTEGER_32 ; p_threshold: INTEGER_32)
   -- Starts a new game in test mode provided game
   -- has not been started yet or is over.
   -- Test mode uses a deterministic random generator and displays
   -- the abstract state of the game.
   -- Allows the setting of threshold values to populate the board initially
   -- (between 1 and 101 non-decreasing), e.g
	-- p_threshold: 40, i.e. generate Planets for 1..39
	-- a random number of 40 to 100 generates no moveable entities
        -- If the random number generator generates a number from
	-- 1 to 100 and the number is in the interval from 1 (inclusive)
        -- to the p_threshold (exclusive) a planet is created. From
        -- p_threshold (inclusive) to 101 (exclusive) generates nothing.
   -- Note that this command will not cause a turn to pass/occur.
		local
--			valid:BOOLEAN

    		sa: SHARED_INFORMATION_ACCESS
			-- Initialization for `Current'.
		do
--			valid:=true
			if not (in_game)
			then
				if not (a_threshold<=j_threshold and j_threshold<=m_threshold and m_threshold<=b_threshold and b_threshold<=p_threshold)
				then
					b_error:=true
					count2:=count2+1
					error_message:= error.test(2)
				else
					show_map:=true
		        	info := sa.shared_info
	--	        	info.set_planet_threshold(p_threshold)
	        		info.test(a_threshold,j_threshold,m_threshold,b_threshold,p_threshold)
					galaxy.make
					count1:=count1+1
					count2:=0

					test_mode:=true
					in_game:=true
				end
			else
				b_error:=true
				count2:=count2+1
				error_message:= error.test(1)
			end
		end

	wormhole
    -- Tunnels the explorer to a random sector (first open quadrant).
    -- A game has to be in progress and there must be
    -- a wormhole in the current sector.
    -- Note that this command will cause a turn to pass/occur
    -- and other entities can affect the explorer.
    -- After the explorer wormholes, other moveable entities whose
    -- clock time (rest) is zero also act in id order, i.e. 1, 2, ..
    -- In test mode: displays entity actions, abstract state,
    -- then board.
		do
			if (in_game)
			then
				galaxy.turn("wormhole")
				if not galaxy.m_error then
					count1:=count1+1
					count2:=0
				else
--					b_error:=true
					count2:=count2+1

				end
			else
				b_error:=true
				count2:=count2+1
				error_message:= error.wormhole (1, galaxy.exp)
			end
		end

feature -- queries
	out : STRING
		do
			create Result.make_from_string ("  ")
			Result.append ("state:")
			Result.append (count1.out)
			Result.append (".")
			Result.append (count2.out)
			if in_game  then
				if test_mode then

					Result.append (", mode:test")
				else
					Result.append (", mode:play")
				end
			end
			if b_error then
				Result.append (", error")
				Result.append (error_message)
				error_message.wipe_out
			elseif galaxy.m_error then
				Result.append (", error")
				Result.append (galaxy.error_string)
			else
				Result.append (", ok")

			end
			if not started then
				Result.append (status_)

				started := true
			end
			if(aborted) then
				Result.append (abort_message)
				abort_message.wipe_out
			end
			aborted:=false
			if(galaxy.exp_landed) then
				Result.append(galaxy.land_string)
--				Result.append((galaxy.gameend).out)
--				Result.append((in_game).out)
			end
			if in_game and (not galaxy.m_error) and (not b_status) and (not b_error) and show_map and not (galaxy.exp_landed and galaxy.gameend) then
				if(test_mode)
				then
					Result.append (galaxy.test_display)
				else
					if(show_map)
					then
						Result.append (galaxy.out)
					end
				end
			end
			if b_status then
				Result.append (status_)

			end
			if(galaxy.gameend) then
				in_game:=false
--				Result.append ("%N  The game has ended. You can start a new game.")
			end
				b_error := false
				galaxy.printed_error
				b_status := false
				show_map := true
		end

end





note
	description: "Galaxy represents a game board in simodyssey."
	author: "Kevin B"
	date: "$Date$"
	revision: "$Revision$"

class
	GALAXY

inherit

	ANY
		redefine
			out
		end

create
	make, make_empty

feature -- attributes

	grid: ARRAY2 [SECTOR]
			-- the board

	gen: RANDOM_GENERATOR_ACCESS

	shared_info_access: SHARED_INFORMATION_ACCESS

	shared_info: SHARED_INFORMATION
		attribute
			Result := shared_info_access.shared_info
		end

	planets: ARRAYED_LIST [PLANET]

	movables: ARRAYED_LIST [MOVABLE]

	exp: EXPLORER

	stations: ARRAY [ENTITY]

	m_id: INTEGER

	error_string: STRING

	movement_string: STRING

	death_string: STRING

	land_string: STRING

	just_started: BOOLEAN

	m_move: BOOLEAN

	gameend: BOOLEAN

	m_dead: BOOLEAN

	exp_moved: BOOLEAN

	exp_landed: BOOLEAN

	m_error: BOOLEAN

	error: ERROR_MESSAGES

	ea: ERROR_MESSAGE_ACCESS

		--	type ACTION = {pass,move,wormhole,land,liftoff}

feature --constructor

	make_empty
		do
			create movables.make (0)
			create planets.make (0)
			create land_string.make_empty
			create movement_string.make_empty
			create error_string.make_empty
			create death_string.make_empty
			create stations.make_empty
			create exp.make
			error := ea.error
			m_id := 1
			m_move := false
			m_error := false
			gameend := false
			create grid.make_filled (create {SECTOR}.make_dummy, shared_info.number_rows, shared_info.number_columns)
		end

	make
			-- creates a dummy of galaxy grid
		local
			row: INTEGER
			column: INTEGER
			b: BLACKHOLE
		do
			just_started := true
			m_move := false
			m_dead := false
			gameend := false
			m_error := false
			m_id := 1
			error := ea.error
			create movables.make (0)
			create land_string.make_empty
			create error_string.make_empty
			create planets.make (0)
			create movement_string.make_empty
			create death_string.make_empty
			create stations.make_empty
			create exp.make
			create b.make
			stations.force (b, stations.count + 1)
			create grid.make_filled (create {SECTOR}.make_dummy, shared_info.number_rows, shared_info.number_columns)
			from
				row := 1
			until
				row > shared_info.number_rows
			loop
				from
					column := 1
				until
					column > shared_info.number_columns
				loop
					grid [row, column] := create {SECTOR}.make (row, column, exp)
					if not (row = 3 and column = 3) then
						populate (row, column)
					end
						--					n:= gen.rchoose (1, 3)
						--					m_id := 1
						--					across 1|..| n is i
						--					loop
						--						threshold := gen.rchoose (1, 100)
						--						if threshold < shared_info.planet_threshold then
						--							planet:=create {PLANET}.make (m_id,row,column)
						--							planets.force (planet, planets.count+1)
						--							grid[row,column].put(planet.en)
						--							m_id := m_id+1
						--						end
						--					end
					column := column + 1;
				end
				row := row + 1
			end
			set_stationary_items
		end

feature --commands

	printed_error
		do
			m_error := false
			error_string.wipe_out
			land_string.wipe_out
			exp_landed := false
			m_dead := false
			m_move := false
		end

	populate (row: INTEGER; column: INTEGER)
			-- this feature creates 1 to max_capacity-1 components to be intially stored in the
			-- sector. The component may be a planet or nothing at all.
		local
			threshold: INTEGER
			number_items: INTEGER
			loop_counter: INTEGER
				--					component: ENTITY_ALPHABET
			turns: INTEGER
			M: MOVABLE
			planet: PLANET
		do
			number_items := grid [row, column].gen.rchoose (1, grid [row, column].shared_info.max_capacity - 1) -- MUST decrease max_capacity by 1 to leave space for Explorer (so a max of 3)
			from
				loop_counter := 1
			until
				loop_counter > number_items
			loop
				threshold := grid [row, column].gen.rchoose (1, 100) -- each iteration, generate a new value to compare against the threshold values provided by `test` or `play`

				if threshold < shared_info.asteroid_threshold then
--					create component.make('A')
					M := create {ASTEROID}.make (m_id, row, column)
				else
					if threshold < shared_info.janitaur_threshold then
--						create component.make('J')
						M := create {JANITAUR}.make (m_id, row, column)
					else
						if (threshold < shared_info.malevolent_threshold) then
--							create component.make('M')
							M := create {MALEVOLENT}.make (m_id, row, column)
						else
							if (threshold < shared_info.benign_threshold) then
--								create component.make('B')
								M := create {BENIGN}.make (m_id, row, column)
							else
								if threshold < shared_info.planet_threshold then
--									create component.make('P')
									planet := create {PLANET}.make (m_id, row, column)
									M := planet
									planets.extend (planet)
								end
							end
						end
					end
				end

--				if threshold < grid [row, column].shared_info.planet_threshold then
--						--							create component.make('P')
--					planet := create {PLANET}.make (m_id, row, column)
--				end
				if attached M as entity then
					grid [row, column].put (M) -- add new entity to the contents list

						--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					turns := grid [row, column].gen.rchoose (0, 2) -- Hint: Use this number for assigning turn values to the planet created
						-- The turn value of the planet created (except explorer) suggests the number of turns left before it can move.
						--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

						-- todo
					M.assign_turns_left (turns)
					movables.extend (M)
--					planets.extend (planet)
					m_id := m_id + 1
					M := void -- reset component object
				end
				loop_counter := loop_counter + 1
			end
		end

	set_stationary_items
			-- distribute stationary items amongst the sectors in the grid.
			-- There can be only one stationary item in a sector
		local
			loop_counter: INTEGER
			check_sector: SECTOR
			temp_row: INTEGER
			temp_column: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > shared_info.number_of_stationary_items
			loop
				temp_row := gen.rchoose (1, shared_info.number_rows)
				temp_column := gen.rchoose (1, shared_info.number_columns)
				check_sector := grid [temp_row, temp_column]
				if (not check_sector.has_stationary) and (not check_sector.is_full) then
					grid [temp_row, temp_column].put (create_stationary_item (- loop_counter - 1, temp_row, temp_column))
					loop_counter := loop_counter + 1
				end -- if
			end -- loop
		end -- feature set_stationary_items

	create_stationary_item (i: INTEGER; temp_row: INTEGER; temp_column: INTEGER): ENTITY
			-- this feature randomly creates one of the possible types of stationary actors
		local
			chance: INTEGER
			Y: YELLOW_DWARF
			W: WORMHOLE
			G: BLUE_GIANT
		do
			chance := gen.rchoose (1, 3)
			inspect chance
			when 1 then
					--create Result.make('Y')--YELLOW_DWARF
				Y := create {YELLOW_DWARF}.make (i, temp_row, temp_column)
					--				if attached Y  as z then

				Result := Y
					--				end

				stations.force (Y, stations.count + 1)
			when 2 then
					--create Result.make('*')--BLUE GIANT
					--				Result:=create {BLUE_GIANT}.make (i,temp_row,temp_column)
				G := create {BLUE_GIANT}.make (i, temp_row, temp_column)
					--				if attached G  as z then

				Result := G
					--				end
				stations.force (G, stations.count + 1)
			when 3 then
					--				--create Result.make('W')--WORMHOLE
					--				Result:=create {WORMHOLE}.make (i,temp_row,temp_column)
					--				stations.force (Result, stations.count+1)
				W := create {WORMHOLE}.make (i, temp_row, temp_column)
					--				if attached W  as z then

				Result := W
					--				end
				stations.force (W, stations.count + 1)
			else
					--create Result.make('Y') -- create more yellow dwarfs this will never happen, but create by default
					--				Result:=create Y.make (i,temp_row,temp_column)

				Y := create {YELLOW_DWARF}.make (i, temp_row, temp_column)
					--				if attached Y  as z then

				Result := Y
				stations.force (Y, stations.count + 1)
					--				end
			end -- inspect
		ensure
			stations.count = old stations.count + 1
		end
			--todo

	turn (action: STRING)
		local
				--			valid:BOOLEAN
			num: INTEGER
		do
			if m_error then
			elseif (action ~ "land" and not grid [exp.row, exp.column].has_Y) then
				m_error := true
				error_string := error.land (3, exp)
			elseif (action ~ "land" and exp.landed) then
				m_error := true
				error_string := error.land (2, exp)
			elseif (action ~ "land" and not grid [exp.row, exp.column].has_p) then
				m_error := true
				error_string := error.land (4, exp)
			elseif (action ~ "land" and not check_unvisit_attached_p) then
				m_error := true
				error_string := error.land (5, exp)
			elseif (action ~ "liftoff" and not exp.landed) then
				m_error := true
				error_string := error.liftoff (2, exp)
			elseif (action ~ "wormhole" and exp.landed) then
				m_error := true
				error_string := error.wormhole (2, exp)
			elseif (action ~ "wormhole" and not grid [exp.row, exp.column].has_W) then
				m_error := true
				error_string := error.wormhole (3, exp)

					--todo
					--print_error
			else
				act (action)
				check_ (exp)
				if gameend and exp.landed then
				else
					across
						movables is m
					loop
						if m.dead then
						elseif (m.turns_left = 0) then

							if m.en.is_planet and grid [m.row, m.column].has_star then

								across
									planets is p
								loop
									if m.id=p.id then

										if p.dead then
										elseif (p.turns_left = 0) and p.attached_ = false and p.id > 0 then
											if grid [p.row, p.column].has_star then
												p.assign_attached (TRUE)
												if grid [p.row, p.column].has_Y then
													num := gen.rchoose (1, 2)
													if (num = 2) then
														p.assign_support_life (TRUE)
													end
												end
											end
										end
									end
								end
							else
								if grid[m.row,m.column].has_w and (m.en.is_m or m.en.is_b )then
									wormhole(m)
								else
									movement(m)
								end
								check_(m)
								if not m.dead then
									reproduce(m)
									behave(m)
								end
							end
--								else
	--								movement (p)
	--								check_ (p)
	--								if not (p.row = 3 and p.column = 3) then
	--									behave (p)
	--								end
	--							end
						else
							m.assign_turns_left (m.turns_left - 1)
						end
					end
				end
			end
		end

	act (action: STRING)
		do
			if (action ~ "pass") then
					--do nothing
			elseif action ~ "move" then
					--move
			elseif action ~ "wormhole" then
				wormhole (exp)
			elseif action ~ "land" then
				exp_landed := true
				exp.assign_landed (TRUE)
				if check_support_life then
					gameend := true
					land_string.append ( "%N  Tranquility base here - we've got a life!")

						--game Ends
				else
					gameend := false
					land_string.append( "%N"+"  Explorer found no life as we know it at Sector:" + exp.row.out + ":" + exp.column.out)
				end
			elseif action ~ "liftoff" then
				exp.assign_landed (FALSE)
				exp_landed := true
				land_string := "%N  Explorer has lifted off from planet at Sector:" + exp.row.out + ":" + exp.column.out
			end
		end

	check_support_life: BOOLEAN
		local
			added: BOOLEAN
			--			temp_row:INTEGER
			--			temp_col:INTEGER

		do
			Result := false
			added := false
			across
				grid [exp.row, exp.column].entity_list is e
			loop
				if (e.en.is_planet) then
					across
						planets is p
					loop
						if not added and p.row = exp.row and p.column = exp.column and  p.attached_ and not p.visited_ then
							if (p.support_life) then
								Result := true
								added := true
								p.assign_visited (true)
							else
								Result := false
								added := true
								p.assign_visited (true)
							end
						end
					end
				end
			end
		end

	check_unvisit_attached_p: BOOLEAN
		local
			added: BOOLEAN
			--			temp_row:INTEGER
			--			temp_col:INTEGER

		do
			Result := false
			added := false
			across
				grid [exp.row, exp.column].entity_list is e
			loop
				if (e.en.is_planet) then
					across
						planets is p
					loop
						if not added and p.row = exp.row and p.column = exp.column and p.attached_ and not p.visited_ then
								--						if (p.support_life)
								--						then
							Result := true
							added := true
								--						else
								--							Result:=false
								--							added:=true

								--						end
						end
					end
				end
			end
		end

	check_p_index (id: INTEGER): INTEGER
		local
			added: BOOLEAN
			--			temp_row:INTEGER
			--			temp_col:INTEGER

		do
			Result := 1
			added := false
			from
				Result := 1
			until
				added
			loop
				if not added and movables [Result].id = id then
						--						if (p.support_life)
						--						then
					added := true
						--						else
						--							Result:=false
						--							added:=true

						--						end
				end
				Result := Result + 1
			end
			Result := Result - 1
		ensure
			Result > 0
		end

	wormhole (ent: ENTITY)
		local
			added: BOOLEAN
			old_row: INTEGER
			old_col: INTEGER
			old_quad: INTEGER
			temp_row: INTEGER
			temp_col: INTEGER
		do
			m_move := true
			if ent.en.is_exp or ent.en.is_b or ent.en.is_m then
				from
					added := false
				until
					added
				loop
					temp_row := gen.rchoose (1, 5)
					temp_col := gen.rchoose (1, 5)
					old_row:=ent.row
					old_col:=ent.column
					old_quad:=ent.quad
					if (not grid [temp_row, temp_col].is_full) then
						movement_string.append ("    ")
						movement_string.append (ent.out + ":" + ent.position)
						grid [ent.row, ent.column].remove (ent)
						grid [temp_row, temp_col].put (ent)
						if not (old_row=temp_row and old_col=temp_col and old_quad=ent.quad) then

							ent.assign_row (temp_row)
							ent.assign_column (temp_col)
							movement_string.append (  "->"+ent.position + "%N")
						else
							movement_string.append ("%N")
						end
						added := TRUE
					end
				end
			end
		end

	movement (ent: MOVABLE)
		local
			direction: TUPLE [row_mod: INTEGER; col_mod: INTEGER]
			planet_dir: TUPLE [row_mod: INTEGER; col_mod: INTEGER]
			--			planet_row : INTEGER
			--			planet_column : INTEGER
		do
			m_move := true

				--			if is_planet(ent) then
				--				direction:=num_dir(gen.rchoose(1,8))
				--				if not grid[ent.row+direction.row_mod,ent.column+direction.col_mod].is_full then

				----					grid[ent.row,ent.column].remove(ent)
				--					grid[ent.row+direction.row_mod,ent.column+direction.col_mod].put(ent)
				----					ent.row:=ent.row+direction.row
				----					ent.column:=ent.row+direction.col
				--				end
			direction := num_dir (gen.rchoose (1, 8))
			planet_dir := [(ent.row + direction.row_mod) \\ 5, (ent.column + direction.col_mod) \\ 5]
			if (planet_dir.row_mod = 0) then
				planet_dir [1] := 5
			end
			if (planet_dir.col_mod = 0) then
				planet_dir [2] := 5
			end
			movement_string.append ("    ")
			movement_string.append (ent.out + ":" + ent.position)
			if not grid [planet_dir.row_mod, planet_dir.col_mod].is_full then
				ent.assign_moved (true)
				grid [ent.row, ent.column].remove (ent)
				grid [planet_dir.row_mod, planet_dir.col_mod].put (ent)
				ent.assign_row (planet_dir.row_mod)
				ent.assign_column (planet_dir.col_mod)
				movement_string.append ("->" + ent.position)
			end
			movement_string.append ("%N")
				--			end

		end

	check_ (ent: MOVABLE)
		local
			pid: INTEGER
		do
				--			if is_explorer(ent) and move_valid then
			if ent.en.is_exp and exp_moved then
				exp.assign_fuel (exp.fuel - 1)
				exp_moved := false
			elseif (ent.en.is_b or ent.en.is_m or ent.en.is_j) and ent.moved then
				ent.assign_fuel (ent.fuel - 1)
				ent.assign_moved (false)
			end
			if (ent.en.is_exp or ent.en.is_b or ent.en.is_m or ent.en.is_j) and grid [ent.row, ent.column].has_star then
				if grid [ent.row, ent.column].has_y then
					if ent.fuel + 2 < ent.max_fuel then
						ent.assign_fuel (ent.fuel + 2)
					else
						ent.assign_fuel (ent.max_fuel)
					end
				else
					if ent.fuel + 5 < ent.max_fuel then
						ent.assign_fuel (ent.fuel + 5)
					else
						ent.assign_fuel (ent.max_fuel)
					end
				end
			end
			if (ent.en.is_exp or ent.en.is_b or ent.en.is_m or ent.en.is_j) and ent.fuel = 0 then
				if ent.en.is_exp then

					exp.assign_life (0)
					gameend := true
				end
				ent.assign_dead (true)
				ent.make_death_string
				death_string.append (ent.death_message)
				grid [ent.row, ent.column].remove (ent)
				m_dead := true
--			end
			elseif (ent.en.is_a or ent.en.is_b or ent.en.is_m or ent.en.is_j) and ent.row = 3 and ent.column = 3  then
				m_dead := true
				grid [ent.row, ent.column].remove (ent)
				ent.assign_dead (true)
				ent.make_death_string_blackhole
				death_string.append (ent.death_message)
			end
			if ent.en.is_exp and ent.row = 3 and ent.column = 3 and not (exp.fuel = 0) then
				m_dead := true
				grid [ent.row, ent.column].remove (ent)
				exp.assign_life (0)
				ent.assign_dead (true)
				ent.make_death_string_blackhole
				death_string.append (ent.death_message)
--				death_string.append ("%N" + "    " + ent.out + ent.des + "," + "%N")
--				death_string.append ("      Explorer got devoured by blackhole (id: -1) at Sector:3:3")
				gameend := true
			end
			if ent.en.is_planet and ent.row = 3 and ent.column = 3 then
				grid [ent.row, ent.column].remove (ent)
					--land_string:=check_p_index(ent.id).out
				pid := check_p_index (ent.id)
				movables [pid].assign_dead (true)
					--				planets.go_i_th ((pid))
					--					planets.replace (create {PLANET}.make_empty)
					--					planets.remove
					--				planets.prune(planets[ent.id])
				m_dead := true
				death_string.append ("%N" + "    " + ent.out + ent.des + ",")
				death_string.append ("%N" + "      Planet got devoured by blackhole (id: -1) at Sector:3:3")
			end
		ensure
			check_fuel: ent.en.is_exp and exp_moved implies exp.fuel = old exp.fuel - 1
			check_life: ent.en.is_exp and exp.fuel = 0 implies exp.life = 0
			check_blackhole: ent.en.is_exp and ent.row = 3 and ent.column = 3 implies exp.life = 0
		end

	behave (ent:MOVABLE)
		local
			num: INTEGER
		do
			if ent.dead then

			elseif ent.en.is_a then
				across grid[ent.row,ent.column].return_m_ent_low_high is e
				loop
					if e.en.is_m or e.en.is_b or e.en.is_j or e.en.is_exp then
						if e.en.is_exp and not exp.landed then
							grid[ent.row,ent.column].remove (e)
							exp.assign_life (0)
							gameend := true
							exp.assign_dead(true)
							exp.make_death_string_a(ent.id)
							death_string.append (exp.death_message)
							m_dead := true
							movement_string.append ("      destroyed "+exp.out+" at "+exp.position)
							movement_string.append ("%N")
						else
							across movables is m
							loop
								if m.id=e.id then
									grid[ent.row,ent.column].remove (e)
									m.assign_dead(true)
									m.make_death_string_a(ent.id)
									death_string.append (m.death_message)
									m_dead := true
									movement_string.append ("      destroyed "+m.out+" at "+m.position)
									movement_string.append ("%N")
								end
							end
						end
					end

				end
				ent.assign_turns_left (gen.rchoose (0, 2))
			elseif ent.en.is_j then
				across grid[ent.row,ent.column].return_m_ent_low_high is e
				loop
					if e.en.is_a and ent.load<2 then
						grid[ent.row,ent.column].remove (e)
						ent.assign_load (ent.load+1)
						across movables is m
						loop
							if m.id=e.id then
								m.assign_dead(true)
								m.make_death_string_j(ent.id)
								death_string.append (m.death_message)
								m_dead := true
								movement_string.append ("      destroyed "+m.out+" at "+m.position)
								movement_string.append ("%N")
							end
						end

					end

				end
				if grid[ent.row,ent.column].has_w then
					ent.assign_load (0)

				end
				ent.assign_turns_left (gen.rchoose (0, 2))
			elseif ent.en.is_b then
				across grid[ent.row,ent.column].return_m_ent_low_high is e
				loop
					if e.en.is_m and ent.load<2 then
						grid[ent.row,ent.column].remove (e)
						across movables is m
						loop
							if m.id=e.id then
								m.assign_dead(true)
								m.make_death_string_b(ent.id)
								death_string.append (m.death_message)
								m_dead := true
								movement_string.append ("      destroyed "+m.out+" at "+m.position)
								movement_string.append ("%N")
							end
						end

					end

				end
				ent.assign_turns_left (gen.rchoose (0, 2))
			elseif ent.en.is_m then
				if not grid[ent.row,ent.column].has_B and ent.row=exp.row and ent.column=exp.column and not exp.landed and not exp.dead  then
					exp.assign_life (exp.life-1)
								movement_string.append ("      attacked "+exp.out+" at "+exp.position)
								movement_string.append ("%N")
					if exp.life=0 then
						grid[ent.row,ent.column].remove (exp)
						exp.assign_dead (true)
						exp.make_death_string_m
						death_string.append (exp.death_message)
						m_dead := true
						gameend := true
					end
				end
				ent.assign_turns_left (gen.rchoose (0, 2))
			elseif ent.en.is_planet then
				across planets is p
				loop
					if p.id=ent.id then

						if grid [p.row, p.column].has_star then
							p.assign_attached (TRUE)
							if grid [p.row, p.column].has_Y then
								num := gen.rchoose (1, 2)
								if num = 2 then
									p.assign_support_life (TRUE)
								end
							end
						else
							ent.assign_turns_left (gen.rchoose (0, 2))
						end
					end
				end
			end

		end

	num_dir (int: INTEGER): TUPLE [row_mod: INTEGER; col_mod: INTEGER]
			-- Convert an integer encoding to a direction. 1 = N, 2 = E, 3 = S, 4 = W.
		do
			inspect int
			when 1 then --N
				Result := [-1, 0]
			when 2 then --NE
				Result := [-1, 1]
			when 3 then --E
				Result := [0, 1]
			when 4 then --SE
				Result := [1, 1]
			when 5 then --S
				Result := [1, 0]
			when 6 then --SW
				Result := [1, -1]
			when 7 then --W
				Result := [0, -1]
			else --NW
				Result := [-1, -1]
			end
		end

	move (i: INTEGER)
		local
			direction: TUPLE [row_mod: INTEGER; col_mod: INTEGER]
			exp_dir: TUPLE [row_mod: INTEGER; col_mod: INTEGER]
		do
				--			if is_planet(ent) then
			if (exp.landed) then
				m_error := true
				error_string := error.move (2, exp)
			else
				direction := num_dir (i)
				exp_dir := [(exp.row + direction.row_mod) \\ 5, (exp.column + direction.col_mod) \\ 5]

					--				if(exp_dir.row_mod = 6) then exp_dir[1] :=1 end
					--				if(exp_dir.col_mod = 6) then exp_dir[2] :=1 end
				if (exp_dir.row_mod = 0) then
					exp_dir [1] := 5
				end
				if (exp_dir.col_mod = 0) then
					exp_dir [2] := 5
				end
				if not grid [exp_dir.row_mod, exp_dir.col_mod].is_full then
					exp_moved := true
					m_move := true
					grid [exp.row, exp.column].remove (exp)
					movement_string.append ("    ")
					movement_string.append (exp.out + ":" + exp.position + "->")
					grid [exp_dir.row_mod, exp_dir.col_mod].put (exp)
					exp.assign_row (exp_dir.row_mod)
					exp.assign_column (exp_dir.col_mod)
					movement_string.append (exp.position + "%N")
					turn ("move")
				else
					m_error := true
					error_string := error.move (3, exp)
				end
			end
		end

	reproduce(ent:MOVABLE)
	local
		M:MOVABLE
	do
	if(ent.en.is_m or ent.en.is_b or ent.en.is_j) then
		if not grid[ent.row,ent.column].is_full and ent.actions_left=0 then
			if (ent.en.is_m) then
				M := create {MALEVOLENT}.make (m_id, ent.row, ent.column)
				ent.assign_actions_left (1)
				 end
				if (ent.en.is_b) then
							M := create {BENIGN}.make (m_id, ent.row, ent.column)
							ent.assign_actions_left (1)
							 end
							if (ent.en.is_j) then
										M := create {JANITAUR}.make (m_id, ent.row, ent.column)
										ent.assign_actions_left (2)
										 end


		if attached M as entity then
						grid [ent.row, ent.column].put (M) -- add new entity to the contents list

								movement_string.append ("      reproduced "+M.out+" at "+M.position)
								movement_string.append ("%N")
							--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
						  -- Hint: Use this number for assigning turn values to the planet created
							-- The turn value of the planet created (except explorer) suggests the number of turns left before it can move.
							--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

							-- todo
						M.assign_turns_left (grid [ent.row, ent.column].gen.rchoose (0, 2))
						movables.extend (M)
	--					planets.extend (planet)
						m_id := m_id + 1
						--M := void -- reset component object
					end

		else
			if not (ent.actions_left=0) then
				ent.assign_actions_left (ent.actions_left-1)
			elseif grid[ent.row,ent.column].is_full then

			end


		end
	end
	end


feature -- query

	out: STRING
			--Returns grid in string form
		local
--			string1: STRING
--			string2: STRING
--			row_counter: INTEGER
--			column_counter: INTEGER
--			contents_counter: INTEGER
--			temp_sector: SECTOR
--			temp_component: ENTITY_ALPHABET
--			printed_symbols_counter: INTEGER
		do
			create Result.make_empty
			if (exp.row = 3 and exp.column = 3) and not (exp.fuel = 0) then
				Result.append (exp.death_string)
				Result.append ("%N" + "  The game has ended. You can start a new game.")
			elseif exp.fuel = 0 then
				Result.append (exp.death_string)
				Result.append ("%N" + "  The game has ended. You can start a new game.")
			elseif  (exp.life = 0) then
				Result.append (exp.death_string)
				Result.append ("%N" + "  The game has ended. You can start a new game.")
			end
				--		if not just_started then
				--			string1.append("  Movement:")
				--			if(m_move) then
				--				string1.append("%N"+movement_string)
				--				movement_string.wipe_out
				--			else
				--				string1.append("none"+"%N")

				--			end
				--		end
				--		just_started:=false
			Result.append ("%N")
			Result.append ("  Movement:")
			if (m_move) then
				Result.append ("%N" + movement_string)
				movement_string.wipe_out
			else
				Result.append ("none" + "%N")
			end
			Result.append (map)
		end

	test_display: STRING
		local
				--		string1: STRING
				--		string2: STRING
			row_counter: INTEGER
			column_counter: INTEGER
			contents_counter: INTEGER
			temp_sector: SECTOR
--			temp_component: ENTITY_ALPHABET
			temp_en: ENTITY
			temp_p: MOVABLE
--			printed_symbols_counter: INTEGER
		do
			create Result.make_empty
				--		create string1.make(7*shared_info.number_rows)
				--		create string2.make(7*shared_info.number_columns)
			if (exp.row = 3 and exp.column = 3) and not (exp.fuel = 0) then
				Result.append (exp.death_string)
				Result.append ("%N" + "  The game has ended. You can start a new game.")
			elseif exp.fuel = 0 then
				Result.append (exp.death_string)
				Result.append ("%N" + "  The game has ended. You can start a new game.")
			elseif  (exp.life = 0) then
				Result.append (exp.death_string)
				Result.append ("%N" + "  The game has ended. You can start a new game.")

			end
			Result.append ("%N")
			Result.append ("  Movement:")
			if (m_move) then
				Result.append ("%N" + movement_string)
				movement_string.wipe_out
			else
				Result.append ("none" + "%N")
			end
			Result.append ("  Sectors:")
			from
				row_counter := 1
			until
				row_counter > shared_info.number_rows
			loop
				from
					column_counter := 1
				until
					column_counter > shared_info.number_columns
				loop
					temp_sector := grid [row_counter, column_counter]
					Result.append ("%N" + "    " + temp_sector.out)
					column_counter := column_counter + 1
				end
				row_counter := row_counter + 1
			end
			Result.append ("%N" + "  Descriptions:")
			from
				contents_counter := stations.count
			until
				contents_counter = 0
			loop
				temp_en := stations [contents_counter]
				if attached temp_en as character then
					Result.append ("%N" + "    " + temp_en.out + "->")
					if temp_en.en.is_star then
						if temp_en.en.is_y then
							Result.append ("Luminosity:2")
						else
							Result.append ("Luminosity:5")
						end
					end
				else
					Result.append ("-")
				end -- if
				contents_counter := contents_counter - 1
			end -- loop
			if exp.life > 0 then
				Result.append ("%N" + "    " + exp.out + exp.des)
			end
			from
				contents_counter := 1
			until
				contents_counter > movables.count
			loop
				temp_p := movables [contents_counter]
				if temp_p.dead then
				elseif attached temp_p as character then
					Result.append ("%N" + "    " + character.out + character.des)
				else
					Result.append ("-")
				end -- if
				contents_counter := contents_counter + 1
			end -- loop
			Result.append ("%N" + "  Deaths This Turn:")
			if (m_dead) then
				Result.append (death_string)
				death_string.wipe_out
			else
				Result.append ("none")
			end

				--		if(exp.row=3 and exp.column=3) and not(exp.fuel=0) then

				--			string1.append("      Explorer got devoured by blackhole (id: -1) at Sector:3:3")
				--		elseif exp.fuel=0 then

				--			string1.append("      Explorer got lost in space - out of fuel at Sector:"+exp.row.out+":"+exp.column.out)
				--  		end
				--		if(exp.row=3 and exp.column=3) then

				--			string1.append("      Planet got devoured by blackhole (id: -1) at Sector:3:3")
				--		end
			Result.append ("%N")
			Result.append (map)
			if (exp.row = 3 and exp.column = 3) and not (exp.fuel = 0) then
				Result.append (exp.death_string)
				Result.append ("%N" + "  The game has ended. You can start a new game.")
			elseif exp.fuel = 0 then
				Result.append (exp.death_string)
				Result.append ("%N" + "  The game has ended. You can start a new game.")
			elseif  (exp.life = 0) then
				Result.append (exp.death_string)
				Result.append ("%N" + "  The game has ended. You can start a new game.")
			end
		end

	compare_ent_with_planet (en: ENTITY): MOVABLE
		do
			Result:=create {PLANET}.make_empty
			across
				movables is p
			loop
				if en.id = p.id and en.row = p.row and en.column = p.column and en.quad = p.quad then
					Result := p
				end
			end
		end

	map: STRING
		local
			string1: STRING
			string2: STRING
			row_counter: INTEGER
			column_counter: INTEGER
			contents_counter: INTEGER
			temp_sector: SECTOR
			temp_component: ENTITY_ALPHABET
			printed_symbols_counter: INTEGER
		do
			create Result.make_empty
			create string1.make (7 * shared_info.number_rows)
			create string2.make (7 * shared_info.number_columns)
			from
				row_counter := 1
			until
				row_counter > shared_info.number_rows
			loop
				string1.append ("    ")
				string2.append ("    ")
				from
					column_counter := 1
				until
					column_counter > shared_info.number_columns
				loop
					temp_sector := grid [row_counter, column_counter]
					string1.append ("(")
					string1.append (temp_sector.print_sector)
					string1.append (")")
					string1.append ("  ")
					from
						contents_counter := 1
						printed_symbols_counter := 0
					until
						contents_counter > temp_sector.contents.count
					loop
						temp_component := temp_sector.contents [contents_counter]
						if attached temp_component as character then
							string2.append_character (character.item)
						else
							string2.append ("-")
						end -- if
						printed_symbols_counter := printed_symbols_counter + 1
						contents_counter := contents_counter + 1
					end -- loop

					from
					until
						(shared_info.max_capacity - printed_symbols_counter) = 0
					loop
						string2.append ("-")
						printed_symbols_counter := printed_symbols_counter + 1
					end
					string2.append ("   ")
					column_counter := column_counter + 1
				end -- loop

				string1.append ("%N")
				if not (row_counter = shared_info.number_rows) then
					string2.append ("%N")
				end
				Result.append (string1.twin)
				Result.append (string2.twin)
				row_counter := row_counter + 1
				string1.wipe_out
				string2.wipe_out
			end
		end

invariant
	id: m_id > 0

end

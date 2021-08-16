note
	description: "Represents a sector in the galaxy."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SECTOR

inherit ANY
	redefine
		out
	end


create
	make, make_dummy

feature -- attributes
	shared_info_access : SHARED_INFORMATION_ACCESS

	shared_info: SHARED_INFORMATION
		attribute
			Result:= shared_info_access.shared_info
		end

	gen: RANDOM_GENERATOR_ACCESS

	contents: ARRAYED_LIST [ENTITY_ALPHABET] --holds 4 quadrants

	row: INTEGER

	column: INTEGER

	entity_list: ARRAYED_LIST[ENTITY]

feature -- constructor
	make(row_input: INTEGER; column_input: INTEGER; a_explorer:ENTITY)
		--initialization
		require
			valid_row: (row_input >= 1) and (row_input <= shared_info.number_rows)
			valid_column: (column_input >= 1) and (column_input <= shared_info.number_columns)
		do
			row := row_input
			column := column_input
			create contents.make (shared_info.max_capacity) -- Each sector should have 4 quadrants
			contents.compare_objects
			create entity_list.make (shared_info.max_capacity) -- Each sector should have 4 quadrants
			entity_list.compare_objects
			if (row = 3) and (column = 3) then
				put (create {BLACKHOLE}.make) -- If this is the sector in the middle of the board, place a black hole
			else
				if (row = 1) and (column = 1) then
					put (a_explorer) -- If this is the top left corner sector, place the explorer there
				end
				--populate -- Run the populate command to complete setup
			end -- if
		end

feature -- commands
	make_dummy
		--initialization without creating entities in quadrants
		do
			create contents.make (shared_info.max_capacity)
			contents.compare_objects
			create entity_list.make (shared_info.max_capacity)
			entity_list.compare_objects
		end

--	populate
--			-- this feature creates 1 to max_capacity-1 components to be intially stored in the
--			-- sector. The component may be a planet or nothing at all.
--		local
--			threshold: INTEGER
--			number_items: INTEGER
--			loop_counter: INTEGER
--			component: ENTITY_ALPHABET
--			turn :INTEGER
--		do
--			number_items := gen.rchoose (1, shared_info.max_capacity-1)  -- MUST decrease max_capacity by 1 to leave space for Explorer (so a max of 3)
--			from
--				loop_counter := 1
--			until
--				loop_counter > number_items
--			loop
--				threshold := gen.rchoose (1, 100) -- each iteration, generate a new value to compare against the threshold values provided by `test` or `play`


--				if threshold < shared_info.planet_threshold then
--					create component.make('P')
--				end


--				if attached component as entity then
--					put (entity) -- add new entity to the contents list

--					--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--					turn:=gen.rchoose (0, 2) -- Hint: Use this number for assigning turn values to the planet created
--					-- The turn value of the planet created (except explorer) suggests the number of turns left before it can move.
--					--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--					component := void -- reset component object
--				end

--				loop_counter := loop_counter + 1
--			end
--		end

feature {GALAXY} --command

	put (new_component: ENTITY)
			-- put `new_component' in contents array
		local
			loop_counter: INTEGER
			index: INTEGER
			found: BOOLEAN
			space: BOOLEAN
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or found or space
			loop

--				if contents [loop_counter] = new_component.en then
--					found := TRUE
--				end --if
				if contents [loop_counter].item = '-' then
					space := TRUE
					index := loop_counter
				end --if
				loop_counter := loop_counter + 1
			end -- loop

			if space  then
				contents.go_i_th (index)
				contents.replace (new_component.en)
				entity_list.go_i_th (index)
				entity_list.replace (new_component)
				--			todo	
				new_component.assign_quad (index)
			end

			if not space and not found and not is_full then
				contents.extend (new_component.en)
				entity_list.extend (new_component)
				--			todo	
				new_component.assign_quad (contents.count)
			end
		ensure
			component_put: not is_full implies contents.has (new_component.en)
		end
		remove (component: ENTITY)
				-- put `new_component' in contents array
			local
				loop_counter: INTEGER
				found: BOOLEAN
				index : INTEGER
			do
				from
					loop_counter := 1
				until
					loop_counter > contents.count or found
				loop
					if contents [loop_counter] = component.en then
						found := TRUE
						index := loop_counter
					end --if
					loop_counter := loop_counter + 1
				end -- loop

				if found then

--					contents.prune_all (component.en)
--					contents.prune_all (contents[index])
					contents.go_i_th (index)
					contents.replace (create {ENTITY_ALPHABET}.make ('-'))
					entity_list.go_i_th (index)
					entity_list.replace (create {DUMMY_ENTITY}.make)
--					contents[index].make ()
--					entity_list.prune_all(component)
					--			todo	

				end
--			ensure
--				component_put: not is_full implies contents.has (new_component.en)
			end

feature -- Queries

	print_sector: STRING
			-- Printable version of location's coordinates with different formatting
		do
			Result := ""
			Result.append (row.out)
			Result.append (":")
			Result.append (column.out)
		end

	is_full: BOOLEAN
			-- Is the location currently full?
		local
			loop_counter: INTEGER
			occupant: ENTITY_ALPHABET
			empty_space_found: BOOLEAN
		do
			if contents.count < shared_info.max_capacity then
				empty_space_found := TRUE
			end
			from
				loop_counter := 1
			until
				loop_counter > contents.count or empty_space_found
			loop
				occupant := contents [loop_counter]
				if not attached occupant  then
					empty_space_found := TRUE
				end
				if occupant.item='-'  then
					empty_space_found := TRUE
				end
				loop_counter := loop_counter + 1
			end

			if contents.count = shared_info.max_capacity and then not empty_space_found then
				Result := TRUE
			else
				Result := FALSE
			end
		end

	has_stationary: BOOLEAN
			-- returns whether the location contains any stationary item
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_stationary
				end -- if
				loop_counter := loop_counter + 1
			end
		end

	has_star: BOOLEAN
			-- returns whether the location contains any stationary item
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_star
				end -- if
				loop_counter := loop_counter + 1
			end
		end

	has_Y: BOOLEAN
			-- returns whether the location contains any stationary item
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_Y
				end -- if
				loop_counter := loop_counter + 1
			end
		end

	has_W: BOOLEAN
			-- returns whether the location contains any stationary item
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_W
				end -- if
				loop_counter := loop_counter + 1
			end
		end

	has_B: BOOLEAN
			-- returns whether the location contains any stationary item
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_b
				end -- if
				loop_counter := loop_counter + 1
			end
		end

	has_p: BOOLEAN
			-- returns whether the location contains any stationary item
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_planet
				end -- if
				loop_counter := loop_counter + 1
			end
		end

	next_available_quad: INTEGER
		local
			loop_counter: INTEGER
			occupant: ENTITY_ALPHABET
			empty_space_found: BOOLEAN
		do
			Result:=0
			from
				loop_counter := 1
			until
				loop_counter > contents.count or empty_space_found
			loop
				occupant := contents [loop_counter]
				if not attached occupant  then
					empty_space_found := TRUE
					Result:=loop_counter
				else
					loop_counter := loop_counter + 1

				end
			end
		end

--		return_m_ent_low_high:SEQ[ENTITY]
--			local

--			do
--				Result.make_empty
--			end
	return_m_ent_low_high: SEQ[ENTITY]
		local
			loop_counter:INTEGER
			temp:ENTITY
			sorted_list: ARRAYED_LIST[ENTITY]
		do
			create Result.make_empty
--			create sorted_list.make_from_array (entity_list.deep_twin.to_array)
			create sorted_list.make (shared_info.max_capacity) -- Each sector should have 4 quadrants
			sorted_list.compare_objects
			from
				loop_counter := 1
			until
				loop_counter > entity_list.count
			loop
				sorted_list.extend (entity_list[loop_counter])
				loop_counter := loop_counter + 1
			end -- loop

			across 1|..| (sorted_list.count) is i
			loop
			     across 1|..| (sorted_list.count-1) is j
			     loop
				     if(sorted_list[j].id>sorted_list[j+1].id)then
				     	temp :=sorted_list[j]
				     	sorted_list. put_i_th (sorted_list[j+1], j)
				     	sorted_list.put_i_th(temp, j+1)

				     end

				end

			end

			across sorted_list is ent
			loop
				if not ent.en.is_dummy then
					Result.append(ent)
				end
			end
		end
	out:STRING
	local
		temp_component:ENTITY
		temp_en:ENTITY_ALPHABET
		contents_counter:INTEGER
		printed_symbols_counter:INTEGER
	do
		Result:="["+row.out+","+column.out+"]->"
		from
			contents_counter := 1
			printed_symbols_counter:=0
		until
			contents_counter > contents.count
		loop
			temp_en := contents[contents_counter]
			temp_component := entity_list[contents_counter]
			if attached temp_en as character then
				Result.append(temp_component.out)
				if ( contents_counter<4) then
					Result.append(",")

				end
			else
				Result.append("-")
			end
			contents_counter := contents_counter + 1
					printed_symbols_counter:=printed_symbols_counter+1
		end
		from
		until (shared_info.max_capacity - printed_symbols_counter)=0
		loop
				Result.append("-")
				if ( printed_symbols_counter<3) then
					Result.append(",")

				end
				printed_symbols_counter:=printed_symbols_counter+1

		end
--		Result.append(return_m_ent_low_high.out)

	end
end

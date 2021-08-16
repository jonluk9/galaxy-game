note
	description: "Summary description for {MOVABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MOVABLE
inherit
	ENTITY
feature -- variables
	death_message:STRING
	turns_left : INTEGER
	actions_left : INTEGER
	rep_int : INTEGER
	MAX_FUEL : INTEGER

	dead:BOOLEAN
	moved:BOOLEAN
	load : INTEGER

	fuel : INTEGER
feature -- helper methods
	assign_actions_left(t: INTEGER)
	do
		actions_left:= t

	end
	assign_turns_left(t: INTEGER)
	do
		turns_left:= t

	end
	assign_fuel(i: INTEGER)
	DO
		fuel := i
	end
	assign_dead(f : BOOLEAN)
	do
		dead := f
	end
	assign_moved(f : BOOLEAN)
	do
		moved := f
	end
	assign_load(t: INTEGER)
	do
		load:= t

	end
	make_death_string
	do

	end
	make_death_string_a(i:INTEGER)
	do

	end
	make_death_string_m
	do

	end
	make_death_string_j(i:INTEGER)
	do

	end
	make_death_string_b(i:INTEGER)
	do

	end
	make_death_string_blackhole
	do

	end
end

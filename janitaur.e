note
	description: "Summary description for {JANITAUR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JANITAUR
inherit
	MOVABLE
	redefine
		des,make_death_string,make_death_string_blackhole,make_death_string_a--,out
	end
create make
feature -- variables
--	en : ENTITY_ALPHABET
--	lum:INTEGER
--	fuel : INTEGER
--	landed:BOOLEAN
--	death_message:BOOLEAN

feature -- constructor
	make(i: INTEGER;r: INTEGER;c: INTEGER)
	do
		id:=i
		row:=r
		column:=c
		create en.make('J')
		create death_message.make_empty
		rep_int:=2
		fuel:=5
		MAX_FUEL:=5
		actions_left:=rep_int
	end
--feature -- helper methods
--	assign_load(t: INTEGER)
--	do
--		load:= t

--	end
feature -- helper methods
	des:STRING
	do
		--Result.make_empty
		if dead then
			Result := ("->fuel:"+fuel.out+"/5, load:"+load.out+"/2, actions_left_until_reproduction:"+actions_left.out+"/2, turns_left:N/A")

		else

			Result := ("->fuel:"+fuel.out+"/5, load:"+load.out+"/2, actions_left_until_reproduction:"+actions_left.out+"/2, turns_left:"+turns_left.out)

		end
	end
	make_death_string
	do
		death_message.make_empty
		death_message.append ("%N" + "    " + out + des + "," + "%N")
		death_message.append ("      Janitaur got lost in space - out of fuel at Sector:" + row.out + ":" + column.out)


	end
	make_death_string_blackhole
	do
		death_message.make_empty
		death_message.append ("%N" + "    " + out + des + "," + "%N")
		death_message.append ("      Janitaur got devoured by blackhole (id: -1) at Sector:3:3")


	end
	make_death_string_a(i:INTEGER)
	do
		death_message.make_empty
		death_message.append ("%N" + "    " + out + des + "," + "%N")
		death_message.append ("      Janitaur got destroyed by asteroid (id: "+i.out+") at Sector:" + row.out + ":" + column.out)

	end

invariant
    id:
        id>0 and en.item = 'J'

end


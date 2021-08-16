note
	description: "Summary description for {ASTEROID}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ASTEROID
inherit
	MOVABLE
	redefine
		des,make_death_string_blackhole,make_death_string_j--,out
	end
create make
feature -- variables
--	en : ENTITY_ALPHABET
--	lum:INTEGER
--	fuel : INTEGER
--	life : INTEGER
--	landed:BOOLEAN
--	death_message:BOOLEAN

feature -- constructor
	make(i: INTEGER;r: INTEGER;c: INTEGER)
	do
		id:=i
		row:=r
		column:=c
		create en.make('A')
		create death_message.make_empty
	end
feature -- helper methods
	des:STRING
	do
		--Result.make_empty
		if dead then
			Result := ("->turns_left:N/A")
		else

			Result := ("->turns_left:"+turns_left.out)

		end
	end
	make_death_string_blackhole
	do
		death_message.make_empty
		death_message.append ("%N" + "    " + out + des + "," + "%N")
		death_message.append ("      Asteroid got devoured by blackhole (id: -1) at Sector:3:3")


	end
	make_death_string_j(i:INTEGER)
	do
		death_message.make_empty
		death_message.append ("%N" + "    " + out + des + "," + "%N")
		death_message.append ("      Asteroid got imploded by janitaur (id: "+i.out+") at Sector:" + row.out + ":" + column.out)

	end

invariant
    id:
        id>0 and en.item = 'A'

end


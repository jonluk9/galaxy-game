note
	description: "Summary description for {EXPLORER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXPLORER
inherit
	MOVABLE
	redefine
		des,make_death_string,make_death_string_blackhole,make_death_string_a,make_death_string_m
	end
create make
feature -- variables
--	en : ENTITY_ALPHABET
--	fuel : INTEGER
	life : INTEGER
	landed:BOOLEAN
	death_string:STRING

feature -- constructor
	make
	do
		id:=0
		row:=1
		column:=1
		fuel:=3
		life:=3
		create en.make('E')
		create death_message.make_empty
		create death_string.make_empty
		landed:=false
		quad:=1
		MAX_FUEL:=3
	end
feature -- assigner methods
--	assign_fuel(i: INTEGER)
--	DO
--		fuel := i
--	end
	assign_life(i: INTEGER)
	DO
		life := i
	end
	assign_landed(i: BOOLEAN)
	DO
		landed := i
	end
	des:STRING
	do
		--Result.make_empty
		Result := ("->fuel:"+fuel.out+"/3, life:"+life.out+"/3, landed?:"+landed.out.substring (1, 1))
	end
	make_death_string
	do
		death_message.make_empty
		death_message.append ("%N" + "    " + out + des + "," + "%N")
		death_message.append ("      Explorer got lost in space - out of fuel at Sector:" + row.out + ":" + column.out)
		death_string.make_empty
		death_string.append ("%N" +"  Explorer got lost in space - out of fuel at Sector:" + row.out + ":" + column.out)


	end
	make_death_string_blackhole
	do
		death_message.make_empty
		death_message.append ("%N" + "    " + out + des + "," + "%N")
		death_message.append ("      Explorer got devoured by blackhole (id: -1) at Sector:3:3")
		death_string.make_empty
		death_string.append ("%N" +"  Explorer got devoured by blackhole (id: -1) at Sector:3:3")


	end
	make_death_string_m
	do
		death_message.make_empty
		death_message.append ("%N" + "    " + out + des + "," + "%N")
		death_message.append ("      Explorer got lost in space - out of life support at Sector:" + row.out + ":" + column.out)
		death_string.make_empty
		death_string.append ("%N" +"  Explorer got lost in space - out of life support at Sector:" + row.out + ":" + column.out)

	end
	make_death_string_a(i:INTEGER)
	do
		death_message.make_empty
		death_message.append ("%N" + "    " + out + des + "," + "%N")
		death_message.append ("      Explorer got destroyed by asteroid (id: "+i.out+") at Sector:" + row.out + ":" + column.out)
		death_string.make_empty
		death_string.append ("%N" +"  Explorer got destroyed by asteroid (id: "+i.out+") at Sector:" + row.out + ":" + column.out)

	end
invariant
    id:
        id=0 and en.item = 'E'
end

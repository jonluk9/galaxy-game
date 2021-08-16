note
	description: "Summary description for {BENIGN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BENIGN
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
--	life : INTEGER
--	landed:BOOLEAN
--	death_message:BOOLEAN

feature -- constructor
	make(i: INTEGER;r: INTEGER;c: INTEGER)
	do
		id:=i
		row:=r
		column:=c
		create en.make('B')
		create death_message.make_empty
		rep_int:=1
		fuel:=3
		MAX_FUEL:=3
		actions_left:=rep_int
	end
feature -- helper methods
	des:STRING
	do
		--Result.make_empty
		if dead then
			Result := ("->fuel:"+fuel.out+"/3, actions_left_until_reproduction:"+actions_left.out+"/1, turns_left:N/A")
		else

			Result := ("->fuel:"+fuel.out+"/3, actions_left_until_reproduction:"+actions_left.out+"/1, turns_left:"+turns_left.out)

		end
	end
	make_death_string
	do
		death_message.make_empty
		death_message.append ("%N" + "    " + out + des + "," + "%N")
		death_message.append ("      Benign got lost in space - out of fuel at Sector:" + row.out + ":" + column.out)


	end
	make_death_string_blackhole
	do
		death_message.make_empty
		death_message.append ("%N" + "    " + out + des + "," + "%N")
		death_message.append ("      Benign got devoured by blackhole (id: -1) at Sector:3:3")


	end
	make_death_string_a(i:INTEGER)
	do
		death_message.make_empty
		death_message.append ("%N" + "    " + out + des + "," + "%N")
		death_message.append ("      Benign got destroyed by asteroid (id: "+i.out+") at Sector:" + row.out + ":" + column.out)

	end

invariant
    id:
        id>0 and en.item = 'B'

end


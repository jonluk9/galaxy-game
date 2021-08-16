note
	description: "Summary description for {BLACKHOLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BLACKHOLE
inherit
	NOT_MOVABLE
create make
feature -- variables
--	en : ENTITY_ALPHABET
--	fuel : INTEGER
--	life : INTEGER
--	landed:BOOLEAN
--	death_message:BOOLEAN

feature -- constructor
	make
	do
		id:=-1
		row:=3
		column:=3
		create en.make('O')
		quad:=1
	end

invariant
    id:
        id=-1 and en.item = 'O'
end



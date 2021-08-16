note
	description: "Summary description for {YELLOW_DWARF}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	YELLOW_DWARF
inherit
	NOT_MOVABLE
create make
feature -- variables
--	en : ENTITY_ALPHABET
	lum:INTEGER
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
		lum:=2
		create en.make('Y')
	end

invariant
    id:
        id<-1 and en.item = 'Y'
end

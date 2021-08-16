note
	description: "Summary description for {BLUE_GIANT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BLUE_GIANT
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
		lum:=5
		create en.make('*')
	end

invariant
    id:
        id<-1 and en.item = '*'

end

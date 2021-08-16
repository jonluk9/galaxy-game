note
	description: "Summary description for {WORMHOLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WORMHOLE
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
	make(i: INTEGER;r: INTEGER;c: INTEGER)
	do
		id:=i
		row:=r
		column:=c
		create en.make('W')
	end

invariant
    id:
        id<-1 and en.item = 'W'
end

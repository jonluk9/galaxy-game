note
	description: "Summary description for {PLANET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLANET

inherit
	MOVABLE
	redefine
		des--,out
	end
create make, make_empty
feature -- variables
--	en : ENTITY_ALPHABET
--	turns_left : INTEGER
--	dead:BOOLEAN
	attached_:BOOLEAN
	visited_:BOOLEAN
--	death_message:STRING
	support_life : BOOLEAN
--	turns_left : INTEGER

feature -- constructor
make_empty
do
id:=0
row :=1
column:=1
create death_message.make_empty
create en.make('P')
		turns_left:=1
		attached_:=false
		dead:=false
		visited_:=false
		quad:=1

end
	make(i: INTEGER;r: INTEGER;c: INTEGER)
	do
		id:=i
		row:=r
		column:=c
		create en.make('P')
		create death_message.make_empty
		turns_left:=2
		dead:=false
		attached_:=false
		visited_:=false
		quad:=0
	end
feature -- helper methods
--	assign_turns_left(t: INTEGER)
--	do
--		turns_left:= t

--	end
	assign_attached(f : BOOLEAN)
	do
		attached_ := f
	end
	assign_visited(f : BOOLEAN)
	do
		visited_ := f
	end
	assign_support_life(f : BOOLEAN)
	do
		support_life := f
	end
--	out:STRING
--	do
--		--Result.make_empty
--		if id=0 then
--			Result:=""
--		else

--			Result:=("["+id.out+","+en.out+"]")
--		end
--	end
	des:STRING
	do
		--Result.make_empty
		if id=0 then
			Result:=""
		else
			if attached_ or dead then

			Result := ("->attached?:"+attached_.out.substring (1, 1)+", support_life?:"+support_life.out.substring (1, 1)+", visited?:"+visited_.out.substring (1, 1)+", turns_left:N/A")

			else
			Result := ("->attached?:"+attached_.out.substring (1, 1)+", support_life?:"+support_life.out.substring (1, 1)+", visited?:"+visited_.out.substring (1, 1)+", turns_left:"+turns_left.out)

			end
		end
	end

invariant
    id:
        id>0 and en.item = 'P'

end

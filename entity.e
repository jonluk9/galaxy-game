note
	description: "Summary description for {ENTITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENTITY

inherit
    ANY
        redefine
            out
--            ,is_equal
        end
feature -- variables
	id : INTEGER
	row : INTEGER
	column : INTEGER
	en : ENTITY_ALPHABET
	quad: INTEGER
feature -- assigner methods
--	assign_turns_left(t: INTEGER)
--	do
--		turns_left:= t

--	end
	assign_quad(i: INTEGER)
	do
		quad := i
	end
	assign_row(i: INTEGER)
	do
		row := i
	end

	assign_column(i: INTEGER)
	do
	column := i
	end

	position:STRING
	do
		--Result.make_empty
		Result := ("["+row.out+","+column.out+","+quad.out+"]")
	end
	out:STRING
	do
		--Result.make_empty
		Result:=("["+id.out+","+en.out+"]")
	end
	des:STRING
	do
		--Result.make_empty
		Result := ""
	end

--    is_equal(other : ENTITY): BOOLEAN
--        do
--            Result := current.id.is_equal (other.id) and current.en.is_equal (other.en)
--        end

invariant
    allowable_symbols:
        en.item = 'E' or en.item = 'P' or en.item = 'O' or en.item = 'W' or en.item = 'Y' or en.item = '*'or en.item = '-'or en.item = 'A' or en.item = 'M' or  en.item = 'J' or en.item='B'

end

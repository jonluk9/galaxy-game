note
	description: "Summary description for {DUMMY_ENTITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DUMMY_ENTITY
inherit
	ENTITY
        redefine
            out
        end
create
    make
feature -- constructor
	make
	do
		id:=0
		row:=0
		column:=0
		create en.make('-')
	end
	out:STRING
	do
		--Result.make_empty
		Result:=("-")
	end

invariant
    id:
        id=0 and en.item = '-'
end

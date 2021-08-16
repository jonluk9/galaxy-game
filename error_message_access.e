note
	description: "Singleton access for shared information."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	ERROR_MESSAGE_ACCESS

feature -- Query
    error: ERROR_MESSAGES
        once
            create result.make
        end


invariant
	error = error

end

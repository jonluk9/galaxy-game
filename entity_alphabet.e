note
    description: "[
       Alphabet allowed to appear on the galaxy board.
    ]"
    author: "Kevin Banh"
    date: "April 30, 2019"
    revision: "1"

class
    ENTITY_ALPHABET

inherit
    ANY
        redefine
            out,
            is_equal
        end

create
    make

feature -- Constructor

    make (a_char: CHARACTER)
        do
            item := a_char
        end

feature -- Attributes

    item: CHARACTER


feature -- Query

    out: STRING
            -- Return string representation of alphabet.
        do
            Result := item.out
        end

    is_equal(other : ENTITY_ALPHABET): BOOLEAN
        do
            Result := current.item.is_equal (other.item)
        end

    is_stationary: BOOLEAN
          -- Return if current item is stationary.
    	do
           if item = 'W' or item = 'Y' or item = '*' or item = 'O' then
           		Result := True
           end
        end

    is_star: BOOLEAN
          -- Return if current item is stationary.
    	do
           if item = 'Y' or item = '*' then
           		Result := True
           end
        end

    is_Y: BOOLEAN
          -- Return if current item is stationary.
    	do
           if item = 'Y' then
           		Result := True
           end
        end

    is_M: BOOLEAN
          -- Return if current item is stationary.
    	do
           if item = 'M' then
           		Result := True
           end
        end

    is_B: BOOLEAN
          -- Return if current item is stationary.
    	do
           if item = 'B' then
           		Result := True
           end
        end

    is_J: BOOLEAN
          -- Return if current item is stationary.
    	do
           if item = 'J' then
           		Result := True
           end
        end

    is_A: BOOLEAN
          -- Return if current item is stationary.
    	do
           if item = 'A' then
           		Result := True
           end
        end

    is_exp: BOOLEAN
          -- Return if current item is stationary.
    	do
           if item = 'E' then
           		Result := True
           end
        end

    is_planet: BOOLEAN
          -- Return if current item is stationary.
    	do
           if item = 'P' then
           		Result := True
           end
        end

    is_w: BOOLEAN
          -- Return if current item is stationary.
    	do
           if item = 'W' then
           		Result := True
           end
        end

       is_dummy: BOOLEAN
          -- Return if current item is stationary.
    	do
           if item = '-' then
           		Result := True
           end
        end

invariant
    allowable_symbols:
        item = 'E' or item = 'P' or item = 'O' or item = 'W' or item = 'Y' or item = '*'or item = '-' or item = 'A' or item = 'M' or  item = 'J' or item='B'
end

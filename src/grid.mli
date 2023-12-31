
module type Element = sig 
    type element [@@deriving equal, yojson]
    val element_is_valid: element -> bool 
    val empty_element: element 
    val element_to_string: element -> string
  end 
  
  
  module type Sudoku_grid = sig 
    include Element
    type row = (int, element, Core.Int.comparator_witness) Core.Map.t
    type t = (int, row, Core.Int.comparator_witness) Core.Map.t
    type coordinate = int * int
    val equal : t -> t -> bool
    (** Compares two sudoku boards, returns true iff the two boards has the same dimension and all the elements in are equal *)
  
    val empty : t
    (** First index is the row *)
  
    val get : t -> int -> int -> element option
    (** Given a board and a position, returns the element at that position, 
        otherwise None is returned if the board is invalid or an invalid position was given *)
    val set : t -> int -> int -> element -> t
    (** Changes the value at a given coordinate to the given given element. *)
    val get_all : t -> element list 
    (** Returns all elements in the grid *)
    val get_row : t -> int -> element list
    (** Returns the row at the given index. Assumes that the given index and board are valid *)
    val get_col : t -> int -> element list
    (** Returns the column at the given index. Assumes that the given index and board are valid *)
    val get_block : t -> int -> element list
    (** Returns the 3x3 block at the given index. Assumes that the given index and board are valid *)

    val is_valid_grid: t -> bool
    (** Checks that the grid is 9x9 and that each element satisfies [element_is_valid] *)

    type json = Yojson.Safe.t

    val serialize : t -> json
    (** converts a board to json *)
    val deserialize : json -> t option
    (** loads a board from json *)
  end
  
  module Make_sudoku_grid (El: Element): Sudoku_grid with type element = El.element
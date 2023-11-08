[@@@ocaml.warning "-27"]

open Core 
module Sudoku_board  = struct
  type element =
    | Empty
    | Fixed of int
    | Volatile of int  (** Contains the board state including which *)
  type row = (int, element, Int.comparator_witness) Map.t
  type t = (int, row , Int.comparator_witness) Map.t
  type difficulty = int 

  let element_to_string = function 
  | Empty -> " "
  | Fixed a | Volatile a -> Int.to_string a

  let get (board: t) (x: int) (y: int): element option = 
    let open Option.Let_syntax in
    Map.find board x 
    >>= Fn.flip Map.find y 
    
  let is_solved (board: t): bool = false

  let empty: t = 
    let a = Map.empty(module Int) in
    let empty_row = 
      List.init 9 ~f:(fun _ -> Empty) |> List.foldi ~init: a ~f: (fun index map element -> 
        Map.add_exn map ~key: index ~data: element
        ) in 
  
    List.init 9 ~f:(fun _ -> empty_row) |> List.foldi ~init: a ~f: (fun index map element -> 
        Map.add_exn map ~key: index ~data: element
        ) 

  let generate_random _ = failwith "Not implemented"
  (** Takes a fully solved sudoko. This method expects a fully solved sudoku *)
  let generate_degenerate (board: t) (difficulty: difficulty): t = failwith "Not implemented"

  (** *)
  let solve (_: t): t option = None 

  (** Generates a solved sudoko with all the cells filled *)

  let de_serialize (str: string): t option = None
  let serialize (_: t): string = ""
  
  let pretty_print (board: t): string = 
    let pretty_print_row (row: row): string = 
      (Map.fold row ~init: "" ~f: (fun ~key:col_num ~data:value accum -> 
        let block =  (element_to_string value) ^ " " in
        if col_num mod 3 = 0 then 
          accum ^ "| " ^ block
        else 
          accum ^ block
      )) ^ "|"
    in 

    let divider_line: string = String.init (4 + (3+4) * 3) ~f: (fun _ -> '-') ^ "\n"
  in 

    (Map.fold board ~init:"" ~f:(fun ~key:row_num ~data:row_data accum -> 
      let row = pretty_print_row (row_data) ^ "\n"
    in 
    if row_num mod 3 = 0 then 
        accum ^ divider_line ^ row 
    else 
        accum ^ row 
    )
    ) ^ divider_line


end

module Sudoku_game = struct
  (** Fixed cell is used when the user attempts to change a cell that is fixed. Already present is used when the user's move would make a row/column/3x3 square have a duplicate entry *)
  type error_states = Fixed_cell | Already_present
  type move = { x : int; y : int; value : int option }

  type hint =
    | Incorrect_cell of (int * int)
    | Suggested_move of move
    | Alread_solved

  let do_move (board: Sudoku_board.t) (move: move): (Sudoku_board.t, error_states) result = failwith "Not implented"
  (** Fails if attempting to change a fixed cell or the user makes a blatantly invalid move, like adding a 2 to a row that already contains a 2. If the move succeeds the updated board will be returned *)

  let generate_hint (board: Sudoku_board.t): hint = failwith "Not implented"
end

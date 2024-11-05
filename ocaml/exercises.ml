exception Negative_Amount


let change amount =
  if amount < 0 then
    raise Negative_Amount
  else
    let denominations = [25; 10; 5; 1] in
    let rec aux remaining denominations =
      match denominations with
      | [] -> []
      | d :: ds -> (remaining / d) :: aux (remaining mod d) ds
    in
    aux amount denominations

(* first_then_apply function *)
let first_then_apply array predicate consumer =
  match List.find_opt predicate array with
  | None -> None
  | Some x -> consumer x

(* this powers_generator function for generating an infinite sequence of powers *)
let powers_generator base =
  let rec generate_from power () =
    Seq.Cons (power, generate_from (power * base))
  in
  generate_from 1

(* meaningful_line_count function *)
let meaningful_line_count filename =
  let meaningful_line line = 
    let trimmed = String.trim line in
    String.length trimmed > 0 && not (String.get trimmed 0 = '#')
  in 
  let the_file = open_in filename in
  let count = ref 0 in
  Fun.protect
    ~finally:(fun () -> close_in the_file)
    (fun () ->
       try
         while true do
           let line = input_line the_file in
           if meaningful_line line then incr count
         done;
         !count
       with End_of_file -> !count)

(* Shape type with Sphere and Box variants *)
type shape =
 | Sphere of float
 | Box of float * float * float

(* Function to calculate the volume of a shape *)
let volume s =
  match s with
   | Sphere r -> Float.pi *. (r ** 3.) *. 4. /. 3.
   | Box (l, w, h) -> l *. w *. h

(* function to calculate the surface area of a shape *)
let surface_area s =
  match s with
  | Sphere r -> 4.0 *. Float.pi *. (r ** 2.0)
  | Box (l, w, h) -> 2.0 *. (l *. w +. l *. h +. w *. h)

(* Binary Search Tree type *)
type 'a binary_search_tree =
 | Empty 
 | Node of 'a binary_search_tree * 'a * 'a binary_search_tree

(* Insert an element into the binary search tree *)
let rec insert value tree =
  match tree with
  | Empty -> Node (Empty, value, Empty)
  | Node (left, v, right) ->
    if value < v then Node (insert value left, v, right)
    else if value > v then Node (left, v, insert value right)
    else tree  (* Ignore duplicates *)

(* check if a value is contained in the binary search tree *)
let rec contains value tree =
  match tree with 
  | Empty -> false
  | Node (left, v, right) ->
    if value = v then true
    else if value < v then contains value left
    else contains value right

(* Calculate the size of the binary search tree *)
let rec size tree =
  match tree with 
  | Empty -> 0
  | Node (left, _, right) -> 1 + size left + size right

(* In-order traversal of the binary search tree *)
let rec inorder tree = 
  match tree with 
  | Empty -> []
  | Node (left, v, right) -> inorder left @ [v] @ inorder right

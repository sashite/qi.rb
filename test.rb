# frozen_string_literal: true

require 'simplecov'

::SimpleCov.command_name 'Brutal test suite'
::SimpleCov.start

require './lib/qi'

# ------------------------------------------------------------------------------

actual = begin
  starting_position = Qi::Position.new(
    'l', 'n', 's', 'g', 'k', 'g', 's', 'n', 'l',
    nil, 'r', nil, nil, nil, nil, nil, 'b', nil,
    'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p',
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
    nil, 'B', nil, nil, nil, nil, nil, 'R', nil,
    'L', 'N', 'S', 'G', 'K', 'G', 'S', 'N', 'L')
  [].reduce(starting_position) { |position, move| position.call(move) }
end

raise if actual.topside_in_hand_pieces != []
raise if actual.squares != ["l", "n", "s", "g", "k", "g", "s", "n", "l", nil, "r", nil, nil, nil, nil, nil, "b", nil, "p", "p", "p", "p", "p", "p", "p", "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", "P", "P", "P", "P", "P", "P", "P", "P", nil, "B", nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.bottomside_in_hand_pieces != []
raise if actual.in_hand_pieces != []
raise if actual.turn_to_topside? != false
raise if actual.feen(9, 9) != "l,n,s,g,k,g,s,n,l/1,r,5,b,1/p,p,p,p,p,p,p,p,p/9/9/9/P,P,P,P,P,P,P,P,P/1,B,5,R,1/L,N,S,G,K,G,S,N,L 0 /"

# ------------------------------------------------------------------------------

actual = begin
  starting_position = Qi::Position.new(
    'l', 'n', 's', 'g', 'k', 'g', 's', 'n', 'l',
    nil, 'r', nil, nil, nil, nil, nil, 'b', nil,
    'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p',
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
    nil, 'B', nil, nil, nil, nil, nil, 'R', nil,
    'L', 'N', 'S', 'G', 'K', 'G', 'S', 'N', 'L')
  [[56, 47, "P"]].reduce(starting_position) { |position, move| position.call(move) }
end

raise if actual.topside_in_hand_pieces != []
raise if actual.squares != ["l", "n", "s", "g", "k", "g", "s", "n", "l", nil, "r", nil, nil, nil, nil, nil, "b", nil, "p", "p", "p", "p", "p", "p", "p", "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", nil, nil, nil, nil, nil, nil, "P", "P", nil, "P", "P", "P", "P", "P", "P", nil, "B", nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.bottomside_in_hand_pieces != []
raise if actual.in_hand_pieces != []
raise if actual.turn_to_topside? != true
raise if actual.feen(9, 9) != "l,n,s,g,k,g,s,n,l/1,r,5,b,1/p,p,p,p,p,p,p,p,p/9/9/2,P,6/P,P,1,P,P,P,P,P,P/1,B,5,R,1/L,N,S,G,K,G,S,N,L 1 /"

# ------------------------------------------------------------------------------

actual = begin
  starting_position = Qi::Position.new(
    'l', 'n', 's', 'g', 'k', 'g', 's', 'n', 'l',
    nil, 'r', nil, nil, nil, nil, nil, 'b', nil,
    'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p',
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
    nil, 'B', nil, nil, nil, nil, nil, 'R', nil,
    'L', 'N', 'S', 'G', 'K', 'G', 'S', 'N', 'L')
  [[56, 47, "P"], [3, 11, "g"]].reduce(starting_position) { |position, move| position.call(move) }
end

raise if actual.topside_in_hand_pieces != []
raise if actual.squares != ["l", "n", "s", nil, "k", "g", "s", "n", "l", nil, "r", "g", nil, nil, nil, nil, "b", nil, "p", "p", "p", "p", "p", "p", "p", "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", nil, nil, nil, nil, nil, nil, "P", "P", nil, "P", "P", "P", "P", "P", "P", nil, "B", nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.bottomside_in_hand_pieces != []
raise if actual.in_hand_pieces != []
raise if actual.turn_to_topside? != false
raise if actual.feen(9, 9) != "l,n,s,1,k,g,s,n,l/1,r,g,4,b,1/p,p,p,p,p,p,p,p,p/9/9/2,P,6/P,P,1,P,P,P,P,P,P/1,B,5,R,1/L,N,S,G,K,G,S,N,L 0 /"

# ------------------------------------------------------------------------------

actual = begin
  starting_position = Qi::Position.new(
    'l', 'n', 's', 'g', 'k', 'g', 's', 'n', 'l',
    nil, 'r', nil, nil, nil, nil, nil, 'b', nil,
    'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p',
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
    nil, 'B', nil, nil, nil, nil, nil, 'R', nil,
    'L', 'N', 'S', 'G', 'K', 'G', 'S', 'N', 'L')
  [[56, 47, "P"], [3, 11, "g"], [64, 24, "+B", "P"]].reduce(starting_position) { |position, move| position.call(move) }
end

raise if actual.topside_in_hand_pieces != []
raise if actual.squares != ["l", "n", "s", nil, "k", "g", "s", "n", "l", nil, "r", "g", nil, nil, nil, nil, "b", nil, "p", "p", "p", "p", "p", "p", "+B", "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", nil, nil, nil, nil, nil, nil, "P", "P", nil, "P", "P", "P", "P", "P", "P", nil, nil, nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.bottomside_in_hand_pieces != ["P"]
raise if actual.in_hand_pieces != []
raise if actual.turn_to_topside? != true
raise if actual.feen(9, 9) != "l,n,s,1,k,g,s,n,l/1,r,g,4,b,1/p,p,p,p,p,p,+B,p,p/9/9/2,P,6/P,P,1,P,P,P,P,P,P/7,R,1/L,N,S,G,K,G,S,N,L 1 P/"

# ------------------------------------------------------------------------------

actual = begin
  starting_position = Qi::Position.new(
    'l', 'n', 's', 'g', 'k', 'g', 's', 'n', 'l',
    nil, 'r', nil, nil, nil, nil, nil, 'b', nil,
    'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p',
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
    nil, 'B', nil, nil, nil, nil, nil, 'R', nil,
    'L', 'N', 'S', 'G', 'K', 'G', 'S', 'N', 'L')
  [[56, 47, "P"], [3, 11, "g"], [64, 24, "+B", "P"], [5, 14, "g"]].reduce(starting_position) { |position, move| position.call(move) }
end

raise if actual.topside_in_hand_pieces != []
raise if actual.squares != ["l", "n", "s", nil, "k", nil, "s", "n", "l", nil, "r", "g", nil, nil, "g", nil, "b", nil, "p", "p", "p", "p", "p", "p", "+B", "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", nil, nil, nil, nil, nil, nil, "P", "P", nil, "P", "P", "P", "P", "P", "P", nil, nil, nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.bottomside_in_hand_pieces != ["P"]
raise if actual.in_hand_pieces != ["P"]
raise if actual.turn_to_topside? != false
raise if actual.feen(9, 9) != "l,n,s,1,k,1,s,n,l/1,r,g,2,g,1,b,1/p,p,p,p,p,p,+B,p,p/9/9/2,P,6/P,P,1,P,P,P,P,P,P/7,R,1/L,N,S,G,K,G,S,N,L 0 P/"

# ------------------------------------------------------------------------------

actual = begin
  starting_position = Qi::Position.new(
    'l', 'n', 's', 'g', 'k', 'g', 's', 'n', 'l',
    nil, 'r', nil, nil, nil, nil, nil, 'b', nil,
    'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p',
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
    nil, 'B', nil, nil, nil, nil, nil, 'R', nil,
    'L', 'N', 'S', 'G', 'K', 'G', 'S', 'N', 'L')
  [[56, 47, "P"], [3, 11, "g"], [64, 24, "+B", "P"], [5, 14, "g"], [24, 14, "+B", "G"]].reduce(starting_position) { |position, move| position.call(move) }
end

raise if actual.topside_in_hand_pieces != []
raise if actual.squares != ["l", "n", "s", nil, "k", nil, "s", "n", "l", nil, "r", "g", nil, nil, "+B", nil, "b", nil, "p", "p", "p", "p", "p", "p", nil, "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", nil, nil, nil, nil, nil, nil, "P", "P", nil, "P", "P", "P", "P", "P", "P", nil, nil, nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.bottomside_in_hand_pieces != ["P", "G"]
raise if actual.in_hand_pieces != []
raise if actual.turn_to_topside? != true
raise if actual.feen(9, 9) != "l,n,s,1,k,1,s,n,l/1,r,g,2,+B,1,b,1/p,p,p,p,p,p,1,p,p/9/9/2,P,6/P,P,1,P,P,P,P,P,P/7,R,1/L,N,S,G,K,G,S,N,L 1 G,P/"

# ------------------------------------------------------------------------------

actual = begin
  starting_position = Qi::Position.new(
    'l', 'n', 's', 'g', 'k', 'g', 's', 'n', 'l',
    nil, 'r', nil, nil, nil, nil, nil, 'b', nil,
    'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p',
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
    nil, 'B', nil, nil, nil, nil, nil, 'R', nil,
    'L', 'N', 'S', 'G', 'K', 'G', 'S', 'N', 'L')
  [[56, 47, "P"], [3, 11, "g"], [64, 24, "+B", "P"], [5, 14, "g"], [24, 14, "+B", "G"], [4, 3, "k"]].reduce(starting_position) { |position, move| position.call(move) }
end

raise if actual.topside_in_hand_pieces != []
raise if actual.squares != ["l", "n", "s", "k", nil, nil, "s", "n", "l", nil, "r", "g", nil, nil, "+B", nil, "b", nil, "p", "p", "p", "p", "p", "p", nil, "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", nil, nil, nil, nil, nil, nil, "P", "P", nil, "P", "P", "P", "P", "P", "P", nil, nil, nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.bottomside_in_hand_pieces != ["P", "G"]
raise if actual.in_hand_pieces != ["P", "G"]
raise if actual.turn_to_topside? != false
raise if actual.feen(9, 9) != "l,n,s,k,2,s,n,l/1,r,g,2,+B,1,b,1/p,p,p,p,p,p,1,p,p/9/9/2,P,6/P,P,1,P,P,P,P,P,P/7,R,1/L,N,S,G,K,G,S,N,L 0 G,P/"

# ------------------------------------------------------------------------------

actual = begin
  starting_position = Qi::Position.new(
    'l', 'n', 's', 'g', 'k', 'g', 's', 'n', 'l',
    nil, 'r', nil, nil, nil, nil, nil, 'b', nil,
    'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p',
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
    nil, 'B', nil, nil, nil, nil, nil, 'R', nil,
    'L', 'N', 'S', 'G', 'K', 'G', 'S', 'N', 'L')
  [[56, 47, "P"], [3, 11, "g"], [64, 24, "+B", "P"], [5, 14, "g"], [24, 14, "+B", "G"], [4, 3, "k"], [nil, 13, "G"]].reduce(starting_position) { |position, move| position.call(move) }
end

raise if actual.topside_in_hand_pieces != []
raise if actual.squares != ["l", "n", "s", "k", nil, nil, "s", "n", "l", nil, "r", "g", nil, "G", "+B", nil, "b", nil, "p", "p", "p", "p", "p", "p", nil, "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", nil, nil, nil, nil, nil, nil, "P", "P", nil, "P", "P", "P", "P", "P", "P", nil, nil, nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.bottomside_in_hand_pieces != ["P"]
raise if actual.in_hand_pieces != []
raise if actual.turn_to_topside? != true
raise if actual.feen(9, 9) != "l,n,s,k,2,s,n,l/1,r,g,1,G,+B,1,b,1/p,p,p,p,p,p,1,p,p/9/9/2,P,6/P,P,1,P,P,P,P,P,P/7,R,1/L,N,S,G,K,G,S,N,L 1 P/"

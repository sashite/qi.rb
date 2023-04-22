# frozen_string_literal: true

require "simplecov"

::SimpleCov.command_name "Brutal test suite"
::SimpleCov.start

require "./lib/qi"

STARTING_POSITION = {
  side_id: 0,
  board: {
     0 => "l",
     1 => "n",
     2 => "s",
     3 => "g",
     4 => "k",
     5 => "g",
     6 => "s",
     7 => "n",
     8 => "l",
    10 => "r",
    16 => "b",
    18 => "p",
    19 => "p",
    20 => "p",
    21 => "p",
    22 => "p",
    23 => "p",
    24 => "p",
    25 => "p",
    26 => "p",
    54 => "P",
    55 => "P",
    56 => "P",
    57 => "P",
    58 => "P",
    59 => "P",
    60 => "P",
    61 => "P",
    62 => "P",
    64 => "B",
    70 => "R",
    72 => "L",
    73 => "N",
    74 => "S",
    75 => "G",
    76 => "K",
    77 => "G",
    78 => "S",
    79 => "N",
    80 => "L"
  },
  hands: [[], []]
}

# ------------------------------------------------------------------------------

actual = begin
  [].reduce(STARTING_POSITION) { |position, move| Qi.call(move, **position) }
end

raise if actual.itself != {:side_id=>0, :board=>{0=>"l", 1=>"n", 2=>"s", 3=>"g", 4=>"k", 5=>"g", 6=>"s", 7=>"n", 8=>"l", 10=>"r", 16=>"b", 18=>"p", 19=>"p", 20=>"p", 21=>"p", 22=>"p", 23=>"p", 24=>"p", 25=>"p", 26=>"p", 54=>"P", 55=>"P", 56=>"P", 57=>"P", 58=>"P", 59=>"P", 60=>"P", 61=>"P", 62=>"P", 64=>"B", 70=>"R", 72=>"L", 73=>"N", 74=>"S", 75=>"G", 76=>"K", 77=>"G", 78=>"S", 79=>"N", 80=>"L"}, :hands=>[[], []]}

# ------------------------------------------------------------------------------

actual = begin
  [[56, 47, "P"]].reduce(STARTING_POSITION) { |position, move| Qi.call(move, **position) }
end

raise if actual.itself != {:side_id=>1, :board=>{0=>"l", 1=>"n", 2=>"s", 3=>"g", 4=>"k", 5=>"g", 6=>"s", 7=>"n", 8=>"l", 10=>"r", 16=>"b", 18=>"p", 19=>"p", 20=>"p", 21=>"p", 22=>"p", 23=>"p", 24=>"p", 25=>"p", 26=>"p", 54=>"P", 55=>"P", 57=>"P", 58=>"P", 59=>"P", 60=>"P", 61=>"P", 62=>"P", 64=>"B", 70=>"R", 72=>"L", 73=>"N", 74=>"S", 75=>"G", 76=>"K", 77=>"G", 78=>"S", 79=>"N", 80=>"L", 47=>"P"}, :hands=>[[], []]}

# ------------------------------------------------------------------------------

actual = begin
  [[56, 47, "P"], [3, 11, "g"]].reduce(STARTING_POSITION) { |position, move| Qi.call(move, **position) }
end

raise if actual.itself != {:side_id=>0, :board=>{0=>"l", 1=>"n", 2=>"s", 4=>"k", 5=>"g", 6=>"s", 7=>"n", 8=>"l", 10=>"r", 16=>"b", 18=>"p", 19=>"p", 20=>"p", 21=>"p", 22=>"p", 23=>"p", 24=>"p", 25=>"p", 26=>"p", 54=>"P", 55=>"P", 57=>"P", 58=>"P", 59=>"P", 60=>"P", 61=>"P", 62=>"P", 64=>"B", 70=>"R", 72=>"L", 73=>"N", 74=>"S", 75=>"G", 76=>"K", 77=>"G", 78=>"S", 79=>"N", 80=>"L", 47=>"P", 11=>"g"}, :hands=>[[], []]}

# ------------------------------------------------------------------------------

actual = begin
  [[56, 47, "P"], [3, 11, "g"], [64, 24, "+B", "P"]].reduce(STARTING_POSITION) { |position, move| Qi.call(move, **position) }
end

raise if actual.itself != {:side_id=>1, :board=>{0=>"l", 1=>"n", 2=>"s", 4=>"k", 5=>"g", 6=>"s", 7=>"n", 8=>"l", 10=>"r", 16=>"b", 18=>"p", 19=>"p", 20=>"p", 21=>"p", 22=>"p", 23=>"p", 24=>"+B", 25=>"p", 26=>"p", 54=>"P", 55=>"P", 57=>"P", 58=>"P", 59=>"P", 60=>"P", 61=>"P", 62=>"P", 70=>"R", 72=>"L", 73=>"N", 74=>"S", 75=>"G", 76=>"K", 77=>"G", 78=>"S", 79=>"N", 80=>"L", 47=>"P", 11=>"g"}, :hands=>[["P"], []]}

# ------------------------------------------------------------------------------

actual = begin
  [[56, 47, "P"], [3, 11, "g"], [64, 24, "+B", "P"], [5, 14, "g"]].reduce(STARTING_POSITION) { |position, move| Qi.call(move, **position) }
end

raise if actual.itself != {:side_id=>0, :board=>{0=>"l", 1=>"n", 2=>"s", 4=>"k", 6=>"s", 7=>"n", 8=>"l", 10=>"r", 16=>"b", 18=>"p", 19=>"p", 20=>"p", 21=>"p", 22=>"p", 23=>"p", 24=>"+B", 25=>"p", 26=>"p", 54=>"P", 55=>"P", 57=>"P", 58=>"P", 59=>"P", 60=>"P", 61=>"P", 62=>"P", 70=>"R", 72=>"L", 73=>"N", 74=>"S", 75=>"G", 76=>"K", 77=>"G", 78=>"S", 79=>"N", 80=>"L", 47=>"P", 11=>"g", 14=>"g"}, :hands=>[["P"], []]}

# ------------------------------------------------------------------------------

actual = begin
  [[56, 47, "P"], [3, 11, "g"], [64, 24, "+B", "P"], [5, 14, "g"], [24, 14, "+B", "G"]].reduce(STARTING_POSITION) { |position, move| Qi.call(move, **position) }
end

raise if actual.itself != {:side_id=>1, :board=>{0=>"l", 1=>"n", 2=>"s", 4=>"k", 6=>"s", 7=>"n", 8=>"l", 10=>"r", 16=>"b", 18=>"p", 19=>"p", 20=>"p", 21=>"p", 22=>"p", 23=>"p", 25=>"p", 26=>"p", 54=>"P", 55=>"P", 57=>"P", 58=>"P", 59=>"P", 60=>"P", 61=>"P", 62=>"P", 70=>"R", 72=>"L", 73=>"N", 74=>"S", 75=>"G", 76=>"K", 77=>"G", 78=>"S", 79=>"N", 80=>"L", 47=>"P", 11=>"g", 14=>"+B"}, :hands=>[["P", "G"], []]}

# ------------------------------------------------------------------------------

actual = begin
  [[56, 47, "P"], [3, 11, "g"], [64, 24, "+B", "P"], [5, 14, "g"], [24, 14, "+B", "G"], [4, 3, "k"]].reduce(STARTING_POSITION) { |position, move| Qi.call(move, **position) }
end

raise if actual.itself != {:side_id=>0, :board=>{0=>"l", 1=>"n", 2=>"s", 6=>"s", 7=>"n", 8=>"l", 10=>"r", 16=>"b", 18=>"p", 19=>"p", 20=>"p", 21=>"p", 22=>"p", 23=>"p", 25=>"p", 26=>"p", 54=>"P", 55=>"P", 57=>"P", 58=>"P", 59=>"P", 60=>"P", 61=>"P", 62=>"P", 70=>"R", 72=>"L", 73=>"N", 74=>"S", 75=>"G", 76=>"K", 77=>"G", 78=>"S", 79=>"N", 80=>"L", 47=>"P", 11=>"g", 14=>"+B", 3=>"k"}, :hands=>[["P", "G"], []]}

# ------------------------------------------------------------------------------

actual = begin
  [[56, 47, "P"], [3, 11, "g"], [64, 24, "+B", "P"], [5, 14, "g"], [24, 14, "+B", "G"], [4, 3, "k"], [nil, 13, "G"]].reduce(STARTING_POSITION) { |position, move| Qi.call(move, **position) }
end

raise if actual.itself != {:side_id=>1, :board=>{0=>"l", 1=>"n", 2=>"s", 6=>"s", 7=>"n", 8=>"l", 10=>"r", 16=>"b", 18=>"p", 19=>"p", 20=>"p", 21=>"p", 22=>"p", 23=>"p", 25=>"p", 26=>"p", 54=>"P", 55=>"P", 57=>"P", 58=>"P", 59=>"P", 60=>"P", 61=>"P", 62=>"P", 70=>"R", 72=>"L", 73=>"N", 74=>"S", 75=>"G", 76=>"K", 77=>"G", 78=>"S", 79=>"N", 80=>"L", 47=>"P", 11=>"g", 14=>"+B", 3=>"k", 13=>"G"}, :hands=>[["P"], []]}

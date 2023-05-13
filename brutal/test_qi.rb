# frozen_string_literal: true

require "simplecov"

::SimpleCov.command_name "Brutal test suite"
::SimpleCov.start

begin
  require_relative "../lib/qi"
rescue ::LoadError
  require "../lib/qi"
end

STARTING_POSITION_CONTEXT = {
  0  => "l",
  1  => "n",
  2  => "s",
  3  => "g",
  4  => "k",
  5  => "g",
  6  => "s",
  7  => "n",
  8  => "l",
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
}.freeze

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new(**STARTING_POSITION_CONTEXT)

  [{ 56 => "nil", 47 => "P" }].reduce(starting_position) do |position, kwargs|
    position.commit(**kwargs.transform_keys { |k| k.is_a?(::String) ? k.to_sym : k })
  end
end

raise if actual.captures != []
if actual.squares != { 0 => "l", 1 => "n", 2 => "s", 3 => "g", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P" }
  raise
end
raise if actual.in_check? != false
raise if actual.not_in_check? != true
raise if actual.north_turn? != true
raise if actual.south_turn? != false
raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != false
if actual.to_a != [true, [], { 0 => "l", 1 => "n", 2 => "s", 3 => "g", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P" }, false]
  raise
end
if actual.to_h != { is_north_turn: true, captures: [], squares: { 0 => "l", 1 => "n", 2 => "s", 3 => "g", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P" }, is_in_check: false }
  raise
end
raise if actual.hash != "20c7ab6d120b1b243797d7870ffaad2fab1660350538f463e52a956365a10f5f"
if actual.serialize != "}  l@0;n@1;s@2;g@3;k@4;g@5;s@6;n@7;l@8;r@10;b@16;p@18;p@19;p@20;p@21;p@22;p@23;p@24;p@25;p@26;P@47;P@54;P@55;nil@56;P@57;P@58;P@59;P@60;P@61;P@62;B@64;R@70;L@72;N@73;S@74;G@75;K@76;G@77;S@78;N@79;L@80 ."
  raise
end
if actual.inspect != "<Qi }  l@0;n@1;s@2;g@3;k@4;g@5;s@6;n@7;l@8;r@10;b@16;p@18;p@19;p@20;p@21;p@22;p@23;p@24;p@25;p@26;P@47;P@54;P@55;nil@56;P@57;P@58;P@59;P@60;P@61;P@62;B@64;R@70;L@72;N@73;S@74;G@75;K@76;G@77;S@78;N@79;L@80 .>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new(**STARTING_POSITION_CONTEXT)

  [{ 56 => "nil", 47 => "P" }, { 3 => "nil", 11 => "g" }].reduce(starting_position) do |position, kwargs|
    position.commit(**kwargs.transform_keys { |k| k.is_a?(::String) ? k.to_sym : k })
  end
end

raise if actual.captures != []
if actual.squares != { 0 => "l", 1 => "n", 2 => "s", 3 => "nil", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g" }
  raise
end
raise if actual.in_check? != false
raise if actual.not_in_check? != true
raise if actual.north_turn? != false
raise if actual.south_turn? != true
raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != false
if actual.to_a != [false, [], { 0 => "l", 1 => "n", 2 => "s", 3 => "nil", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g" }, false]
  raise
end
if actual.to_h != { is_north_turn: false, captures: [], squares: { 0 => "l", 1 => "n", 2 => "s", 3 => "nil", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g" }, is_in_check: false }
  raise
end
raise if actual.hash != "8f25dbd5ca3aec2850cf8d38142f36902e93cc6d60613020dea9de634efe5f68"
if actual.serialize != "{  l@0;n@1;s@2;nil@3;k@4;g@5;s@6;n@7;l@8;r@10;g@11;b@16;p@18;p@19;p@20;p@21;p@22;p@23;p@24;p@25;p@26;P@47;P@54;P@55;nil@56;P@57;P@58;P@59;P@60;P@61;P@62;B@64;R@70;L@72;N@73;S@74;G@75;K@76;G@77;S@78;N@79;L@80 ."
  raise
end
if actual.inspect != "<Qi {  l@0;n@1;s@2;nil@3;k@4;g@5;s@6;n@7;l@8;r@10;g@11;b@16;p@18;p@19;p@20;p@21;p@22;p@23;p@24;p@25;p@26;P@47;P@54;P@55;nil@56;P@57;P@58;P@59;P@60;P@61;P@62;B@64;R@70;L@72;N@73;S@74;G@75;K@76;G@77;S@78;N@79;L@80 .>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new(**STARTING_POSITION_CONTEXT)

  [{ 56 => "nil", 47 => "P" }, { 3 => "nil", 11 => "g" }, { 64 => "nil", 24 => "+B", "capture" => "P" }].reduce(starting_position) do |position, kwargs|
    position.commit(**kwargs.transform_keys { |k| k.is_a?(::String) ? k.to_sym : k })
  end
end

raise if actual.captures != ["P"]
if actual.squares != { 0 => "l", 1 => "n", 2 => "s", 3 => "nil", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "+B", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "nil", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g" }
  raise
end
raise if actual.in_check? != false
raise if actual.not_in_check? != true
raise if actual.north_turn? != true
raise if actual.south_turn? != false
raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != false
if actual.to_a != [true, ["P"], { 0 => "l", 1 => "n", 2 => "s", 3 => "nil", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "+B", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "nil", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g" }, false]
  raise
end
if actual.to_h != { is_north_turn: true, captures: ["P"], squares: { 0 => "l", 1 => "n", 2 => "s", 3 => "nil", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "+B", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "nil", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g" }, is_in_check: false }
  raise
end
raise if actual.hash != "24463bcd0796fea50415c3cb3586ecdca150f14c6ec3853b955b92ca986175c7"
if actual.serialize != "} P l@0;n@1;s@2;nil@3;k@4;g@5;s@6;n@7;l@8;r@10;g@11;b@16;p@18;p@19;p@20;p@21;p@22;p@23;+B@24;p@25;p@26;P@47;P@54;P@55;nil@56;P@57;P@58;P@59;P@60;P@61;P@62;nil@64;R@70;L@72;N@73;S@74;G@75;K@76;G@77;S@78;N@79;L@80 ."
  raise
end
if actual.inspect != "<Qi } P l@0;n@1;s@2;nil@3;k@4;g@5;s@6;n@7;l@8;r@10;g@11;b@16;p@18;p@19;p@20;p@21;p@22;p@23;+B@24;p@25;p@26;P@47;P@54;P@55;nil@56;P@57;P@58;P@59;P@60;P@61;P@62;nil@64;R@70;L@72;N@73;S@74;G@75;K@76;G@77;S@78;N@79;L@80 .>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new(**STARTING_POSITION_CONTEXT)

  [{ 56 => "nil", 47 => "P" }, { 3 => "nil", 11 => "g" }, { 64 => "nil", 24 => "+B", "capture" => "P" }, { 5 => "nil", 14 => "g" }].reduce(starting_position) do |position, kwargs|
    position.commit(**kwargs.transform_keys { |k| k.is_a?(::String) ? k.to_sym : k })
  end
end

raise if actual.captures != ["P"]
if actual.squares != { 0 => "l", 1 => "n", 2 => "s", 3 => "nil", 4 => "k", 5 => "nil", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "+B", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "nil", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "g" }
  raise
end
raise if actual.in_check? != false
raise if actual.not_in_check? != true
raise if actual.north_turn? != false
raise if actual.south_turn? != true
raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != false
if actual.to_a != [false, ["P"], { 0 => "l", 1 => "n", 2 => "s", 3 => "nil", 4 => "k", 5 => "nil", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "+B", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "nil", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "g" }, false]
  raise
end
if actual.to_h != { is_north_turn: false, captures: ["P"], squares: { 0 => "l", 1 => "n", 2 => "s", 3 => "nil", 4 => "k", 5 => "nil", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "+B", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "nil", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "g" }, is_in_check: false }
  raise
end
raise if actual.hash != "82cdf0d734ad78227b8a8a887c9f9a0415070a2fac911caecf3ebee374629832"
if actual.serialize != "{ P l@0;n@1;s@2;nil@3;k@4;nil@5;s@6;n@7;l@8;r@10;g@11;g@14;b@16;p@18;p@19;p@20;p@21;p@22;p@23;+B@24;p@25;p@26;P@47;P@54;P@55;nil@56;P@57;P@58;P@59;P@60;P@61;P@62;nil@64;R@70;L@72;N@73;S@74;G@75;K@76;G@77;S@78;N@79;L@80 ."
  raise
end
if actual.inspect != "<Qi { P l@0;n@1;s@2;nil@3;k@4;nil@5;s@6;n@7;l@8;r@10;g@11;g@14;b@16;p@18;p@19;p@20;p@21;p@22;p@23;+B@24;p@25;p@26;P@47;P@54;P@55;nil@56;P@57;P@58;P@59;P@60;P@61;P@62;nil@64;R@70;L@72;N@73;S@74;G@75;K@76;G@77;S@78;N@79;L@80 .>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new(**STARTING_POSITION_CONTEXT)

  [{ 56 => "nil", 47 => "P" }, { 3 => "nil", 11 => "g" }, { 64 => "nil", 24 => "+B", "capture" => "P" }, { 5 => "nil", 14 => "g" }, { 24 => "nil", 14 => "+B", "capture" => "G" }].reduce(starting_position) do |position, kwargs|
    position.commit(**kwargs.transform_keys { |k| k.is_a?(::String) ? k.to_sym : k })
  end
end

raise if actual.captures != %w[G P]
if actual.squares != { 0 => "l", 1 => "n", 2 => "s", 3 => "nil", 4 => "k", 5 => "nil", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "nil", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "nil", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B" }
  raise
end
raise if actual.in_check? != false
raise if actual.not_in_check? != true
raise if actual.north_turn? != true
raise if actual.south_turn? != false
raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != false
if actual.to_a != [true, %w[G P], { 0 => "l", 1 => "n", 2 => "s", 3 => "nil", 4 => "k", 5 => "nil", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "nil", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "nil", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B" }, false]
  raise
end
if actual.to_h != { is_north_turn: true, captures: %w[G P], squares: { 0 => "l", 1 => "n", 2 => "s", 3 => "nil", 4 => "k", 5 => "nil", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "nil", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "nil", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B" }, is_in_check: false }
  raise
end
raise if actual.hash != "b9cb87f1f1f3ee98beaab9f0a342808f69eb6e3bf307e28df93cca6488a2ed5e"
if actual.serialize != "} G;P l@0;n@1;s@2;nil@3;k@4;nil@5;s@6;n@7;l@8;r@10;g@11;+B@14;b@16;p@18;p@19;p@20;p@21;p@22;p@23;nil@24;p@25;p@26;P@47;P@54;P@55;nil@56;P@57;P@58;P@59;P@60;P@61;P@62;nil@64;R@70;L@72;N@73;S@74;G@75;K@76;G@77;S@78;N@79;L@80 ."
  raise
end
if actual.inspect != "<Qi } G;P l@0;n@1;s@2;nil@3;k@4;nil@5;s@6;n@7;l@8;r@10;g@11;+B@14;b@16;p@18;p@19;p@20;p@21;p@22;p@23;nil@24;p@25;p@26;P@47;P@54;P@55;nil@56;P@57;P@58;P@59;P@60;P@61;P@62;nil@64;R@70;L@72;N@73;S@74;G@75;K@76;G@77;S@78;N@79;L@80 .>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new(**STARTING_POSITION_CONTEXT)

  [{ 56 => "nil", 47 => "P" }, { 3 => "nil", 11 => "g" }, { 64 => "nil", 24 => "+B", "capture" => "P" }, { 5 => "nil", 14 => "g" }, { 24 => "nil", 14 => "+B", "capture" => "G" }, { 4 => "nil", 3 => "k" }].reduce(starting_position) do |position, kwargs|
    position.commit(**kwargs.transform_keys { |k| k.is_a?(::String) ? k.to_sym : k })
  end
end

raise if actual.captures != %w[G P]
if actual.squares != { 0 => "l", 1 => "n", 2 => "s", 3 => "k", 4 => "nil", 5 => "nil", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "nil", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "nil", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B" }
  raise
end
raise if actual.in_check? != false
raise if actual.not_in_check? != true
raise if actual.north_turn? != false
raise if actual.south_turn? != true
raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != false
if actual.to_a != [false, %w[G P], { 0 => "l", 1 => "n", 2 => "s", 3 => "k", 4 => "nil", 5 => "nil", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "nil", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "nil", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B" }, false]
  raise
end
if actual.to_h != { is_north_turn: false, captures: %w[G P], squares: { 0 => "l", 1 => "n", 2 => "s", 3 => "k", 4 => "nil", 5 => "nil", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "nil", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "nil", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B" }, is_in_check: false }
  raise
end
raise if actual.hash != "74dd6d768fe34409d1daee797542712d6dc9fbc33b1d4820650b23117338800b"
if actual.serialize != "{ G;P l@0;n@1;s@2;k@3;nil@4;nil@5;s@6;n@7;l@8;r@10;g@11;+B@14;b@16;p@18;p@19;p@20;p@21;p@22;p@23;nil@24;p@25;p@26;P@47;P@54;P@55;nil@56;P@57;P@58;P@59;P@60;P@61;P@62;nil@64;R@70;L@72;N@73;S@74;G@75;K@76;G@77;S@78;N@79;L@80 ."
  raise
end
if actual.inspect != "<Qi { G;P l@0;n@1;s@2;k@3;nil@4;nil@5;s@6;n@7;l@8;r@10;g@11;+B@14;b@16;p@18;p@19;p@20;p@21;p@22;p@23;nil@24;p@25;p@26;P@47;P@54;P@55;nil@56;P@57;P@58;P@59;P@60;P@61;P@62;nil@64;R@70;L@72;N@73;S@74;G@75;K@76;G@77;S@78;N@79;L@80 .>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new(**STARTING_POSITION_CONTEXT)

  [{ 56 => "nil", 47 => "P" }, { 3 => "nil", 11 => "g" }, { 64 => "nil", 24 => "+B", "capture" => "P" }, { 5 => "nil", 14 => "g" }, { 24 => "nil", 14 => "+B", "capture" => "G" }, { 4 => "nil", 3 => "k" }, { 13 => "G", "drop" => "G" }].reduce(starting_position) do |position, kwargs|
    position.commit(**kwargs.transform_keys { |k| k.is_a?(::String) ? k.to_sym : k })
  end
end

raise if actual.captures != ["P"]
if actual.squares != { 0 => "l", 1 => "n", 2 => "s", 3 => "k", 4 => "nil", 5 => "nil", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "nil", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "nil", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B", 13 => "G" }
  raise
end
raise if actual.in_check? != false
raise if actual.not_in_check? != true
raise if actual.north_turn? != true
raise if actual.south_turn? != false
raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != false
if actual.to_a != [true, ["P"], { 0 => "l", 1 => "n", 2 => "s", 3 => "k", 4 => "nil", 5 => "nil", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "nil", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "nil", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B", 13 => "G" }, false]
  raise
end
if actual.to_h != { is_north_turn: true, captures: ["P"], squares: { 0 => "l", 1 => "n", 2 => "s", 3 => "k", 4 => "nil", 5 => "nil", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "nil", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "nil", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B", 13 => "G" }, is_in_check: false }
  raise
end
raise if actual.hash != "677f523bbe37880979c471977b3c3be54e741a52ec67e83e07b605da2e6d4426"
if actual.serialize != "} P l@0;n@1;s@2;k@3;nil@4;nil@5;s@6;n@7;l@8;r@10;g@11;G@13;+B@14;b@16;p@18;p@19;p@20;p@21;p@22;p@23;nil@24;p@25;p@26;P@47;P@54;P@55;nil@56;P@57;P@58;P@59;P@60;P@61;P@62;nil@64;R@70;L@72;N@73;S@74;G@75;K@76;G@77;S@78;N@79;L@80 ."
  raise
end
if actual.inspect != "<Qi } P l@0;n@1;s@2;k@3;nil@4;nil@5;s@6;n@7;l@8;r@10;g@11;G@13;+B@14;b@16;p@18;p@19;p@20;p@21;p@22;p@23;nil@24;p@25;p@26;P@47;P@54;P@55;nil@56;P@57;P@58;P@59;P@60;P@61;P@62;nil@64;R@70;L@72;N@73;S@74;G@75;K@76;G@77;S@78;N@79;L@80 .>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# End of the brutal test

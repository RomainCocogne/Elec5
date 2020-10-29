- LAB-TODO-STEP-1: Analyse the attributes declaration: What are the differences between data and addr generation ? Why are data always X when transaction.randomized() is called 
	addr is random and not data. when randomize is called, data isn't initialized so its value is X.


- LAB-TODO-STEP-2-a - Add "rand" modifier to data attribute
	Randomize depends on seed so it's pseudo-rand. 2 simu with same seed produce same result.
- LAB-TODO-STEP-3-a
	Constrains are only on trans_adder, so trans1 isn't concerned by them (addr>0x5). Trans2 is constrained by addr_range and read_only_area so this is correct.
proc ::vmdAssist::makebox {} {
	variable molid
	variable keyword
	variable Lx
	variable Ly
	variable Lz

	puts "$molid $keyword"
	.w1.frow3.n.bs.box.l2 configure -text "Please wait..." -foreground red

	set cutoff 2.0
	set sel [atomselect $molid $keyword]
	# we can use type or name - i use type
	set type_list [$sel get type]
	# make list of all atom cordination
	set xyz [$sel get {x y z}]
	# calculation length of structure
	lassign [measure minmax $sel] min max
	lassign $min min_x min_y min_z
	lassign $max max_x max_y max_z
	lassign [vecsub $max $min] Lx_structure Ly_structure Lz_structure
	# find two atoms with minimum distance in A and B box alonge X direction and Y and Z
	set BondLengthX 100.0
	set BondLengthY 100.0
	set BondLengthZ 100.0
	set Natom [$sel num]
	# X
	if {$Lx_structure > 1.0} {
		for {set i 0} {$i < $Natom} {incr i} {
			lassign [lindex $xyz $i] x_i y_i z_i
			if {$x_i > [expr $max_x-$cutoff]} {
				for {set j 0} {$j < $Natom} {incr j} {
					lassign [lindex $xyz $j] x_j y_j z_j
					if {$x_j < [expr $min_x+$cutoff]} {
						set rjiX [expr ( ($x_j+$Lx_structure+0.5 - $x_i)**2.0 + ($y_j - $y_i)**2.0 + ($z_j - $z_i)**2.0 )**0.5]
						if {$rjiX < $BondLengthX} {
							set BondLengthX $rjiX
							set indAX $i
							set indBX $j
						}
					}
				}
			}
		}
		set type_AX [lindex $type_list $indAX]
		set type_BX [lindex $type_list $indBX]
	} else {
		set type_AX "NULL"
		set type_BX "NULL"
	}
	.w1.frow3.n.bs.box.l2 configure -text "Please wait... (1/4)"
	update
	# Y
	if {$Ly_structure > 1.0} {
		for {set i 0} {$i < $Natom} {incr i} {
			lassign [lindex $xyz $i] x_i y_i z_i
			if {$y_i > [expr $max_y-$cutoff]} {
				for {set j 0} {$j < $Natom} {incr j} {
					lassign [lindex $xyz $j] x_j y_j z_j
					if {$y_j < [expr $min_y+$cutoff]} {
						set rjiY [expr ( ($x_j - $x_i)**2.0 + ($y_j+$Ly_structure+0.5 - $y_i)**2.0 + ($z_j - $z_i)**2.0 )**0.5]
						if {$rjiY < $BondLengthY} {
							set BondLengthY $rjiY
							set indAY $i
							set indBY $j
						}
					}
				}
			}
		}
		set type_AY [lindex $type_list $indAY]
		set type_BY [lindex $type_list $indBY]
	} else {
		set type_AY "NULL"
		set type_BY "NULL"
	}
	.w1.frow3.n.bs.box.l2 configure -text "Please wait... (2/4)"
	update
	# Z
	puts "Lz_structure: $Lz_structure"
	if {$Lz_structure > 1.0} {
		for {set i 0} {$i < $Natom} {incr i} {
			lassign [lindex $xyz $i] x_i y_i z_i
			if {$z_i > [expr $max_z-$cutoff]} {
				for {set j 0} {$j < $Natom} {incr j} {
					lassign [lindex $xyz $j] x_j y_j z_j
					if {$z_j < [expr $min_z+$cutoff]} {
						set rjiZ [expr ( ($x_j - $x_i)**2.0 + ($y_j - $y_i)**2.0 + ($z_j+$Lz_structure+0.5 - $z_i)**2.0 )**0.5]
						if {$rjiZ < $BondLengthZ} {
							set BondLengthZ $rjiZ
							set indAZ $i
							set indBZ $j
						}
					}
				}
			}
		}
		set type_AZ [lindex $type_list $indAZ]
		set type_BZ [lindex $type_list $indBZ]
	} else {
		set type_AZ "NULL"
		set type_BZ "NULL"
	}
	puts "BondLength: $BondLengthX - $BondLengthY - $BondLengthZ"
	puts "$type_AX $type_BX - $type_AY $type_BY - $type_AZ $type_BZ"

	.w1.frow3.n.bs.box.l2 configure -text "Please wait... (3/4)"
	update

	# find true bond length of A and B atom in first box to determined the box length
	set AB_BondLengthX 100.0
	set AB_BondLengthY 100.0
	set AB_BondLengthZ 100.0

	foreach xyzi $xyz type_i $type_list {
		foreach xyzj $xyz type_j $type_list {	
			set rji [veclength [vecsub $xyzj $xyzi]]
			if {$rji < 5.0 && $rji > 0.1} {
				if {$rji < $AB_BondLengthX} {
					if {$type_i == $type_AX && $type_j == $type_BX} {
						set AB_BondLengthX 	$rji
					}
				}
				if {$rji < $AB_BondLengthY} {
					if {$type_i == $type_AY && $type_j == $type_BY} {
						set AB_BondLengthY 	$rji
					}
				}
				if {$rji < $AB_BondLengthZ} {
					if {$type_i == $type_AZ && $type_j == $type_BZ} {
						set AB_BondLengthZ 	$rji
					}
				}
			}
		}
	}
	.w1.frow3.n.bs.box.l2 configure -text "Please wait... (4/4)"
	update
	puts "AB_BondLength: $AB_BondLengthX - $AB_BondLengthY - $AB_BondLengthZ"

	# if the structure length is under 1 Angestrom it is considered as non-periodic
	if {$Lx_structure > 1.0} {
		lassign [lindex $xyz $indAX] x_A y_A z_A
		lassign [lindex $xyz $indBX] x_B y_B z_B
		set Lx [expr ($AB_BondLengthX**2.0 - ($y_B-$y_A)**2.0 - ($z_B-$z_A)**2.0)**0.5 + $Lx_structure]
	} else {
		set Lx 50.0
	}

	if {$Ly_structure > 1.0} {
		lassign [lindex $xyz $indAY] x_A y_A z_A
		lassign [lindex $xyz $indBY] x_B y_B z_B
		set Ly [expr ($AB_BondLengthY**2.0 - ($x_B-$x_A)**2.0 - ($z_B-$z_A)**2.0)**0.5 + $Ly_structure]
	} else {
		set Ly 50.0
	}

	if {$Lz_structure > 1.0} {
		lassign [lindex $xyz $indAZ] x_A y_A z_A
		lassign [lindex $xyz $indBZ] x_B y_B z_B
		set Lz [expr ($AB_BondLengthZ**2.0 - ($x_B-$x_A)**2.0 - ($y_B-$y_A)**2.0)**0.5 + $Lz_structure]
	} else {
		set Lz 50.0
	}

	puts "Lx: $Lx - Ly: $Ly - Lz: $Lz"
	molinfo $molid set {a b c} [list $Lx $Ly $Lz]
	.w1.frow3.n.bs.box.l2 configure -text "Done!" -foreground darkgreen
	$sel delete
}

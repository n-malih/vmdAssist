namespace eval ::vmdAssist {
	set version 1.0
	set MyDescription "This program contains series of tools that can helps us create and edit molecular structure"

	variable w
	variable out_atom_style {}
	variable in_atom_style {}
	variable displace 1.0
	variable molid_list {}
	variable out_data_dir {}
	variable in_data_dir {}
	variable cor_x 0
	variable cor_y 0
	variable cor_z 0
	variable aor {0 0 1}
	variable aor_x 0
	variable aor_y 0
	variable aor_z 1
	variable rot_theta 30.0
	variable keyword "all"
	variable Lx 1.0
	variable Ly 1.0
	variable Lz 1.0
	variable dir [file dirname [info script]]
	variable molid
	variable showgrid 0
	variable gridid
	variable Nx 1
	variable Ny	1
	variable Nz	1
	variable gridfactor 1.0
	variable CoGx --
	variable CoGy --
	variable CoGz --
	variable Sh_A x
	variable Sh_B y
	variable Sh_C z
	variable RD a
	variable arc 360
	variable ms_molid_list {}
	variable merge_list {}
	variable NoR 1
	variable DoR 0
	variable NoR_S 1
	variable DoR_S 3.4
	variable mdir 0
	variable box_dict
	variable boxstate 0
	variable mol_sel
	variable Pi 3.14159265358979323846
	variable key {name type mass charge element atomicnumber radius resname resid}
	variable expkey -
	variable newvalue
	variable Lx_SC 1
	variable Ly_SC 1
	variable Lz_SC 1
}
package provide vmdAssist $::vmdAssist::version

proc ::vmdAssist::gui {} {
	variable Nx
	variable Ny
	variable Nz
	variable Lx
	variable Ly
	variable Lz
	variable w


	if { [winfo exists .w1] } {
		wm deiconify .w1
		return
	}

	set w [tk::toplevel .w1]
	wm title .w1 "vmdAssist"

	ttk::frame .w1.frow1 -padding 5
	grid .w1.frow1 -row 0 -column 0 -sticky w

	# View direction - - - - - - - -  - -
	ttk::labelframe .w1.frow1.f1 -text "View direction" -padding 5
	ttk::button .w1.frow1.f1.d_b1 -text "xy"	-command {display resetview}										-width 4
	ttk::button .w1.frow1.f1.d_b2 -text "-xy"	-command {display resetview ; rotate y by 180}						-width 4
	ttk::button .w1.frow1.f1.d_b3 -text "yz" 	-command {display resetview ; rotate z by -90 ; rotate x by -90}	-width 4
	ttk::button .w1.frow1.f1.d_b4 -text "-yz"	-command {display resetview ; rotate z by 90  ; rotate x by -90}	-width 4
	ttk::button .w1.frow1.f1.d_b5 -text "zx" 	-command {display resetview ; rotate y by 90 ; rotate x by 90}		-width 4
	ttk::button .w1.frow1.f1.d_b6 -text "-zx"	-command {display resetview ; rotate z by 90 ; rotate y by -90}		-width 4

	ttk::button .w1.frow1.f1.mdir_b1 -text "x -y"	-command {display resetview ; rotate x by 180}										-width 4
	ttk::button .w1.frow1.f1.mdir_b2 -text "yx"		-command {display resetview ; rotate z by 90; rotate y by 180}						-width 4
	ttk::button .w1.frow1.f1.mdir_b3 -text "y -z"	-command {display resetview ; rotate x by 90; rotate y by 90}	-width 4
	ttk::button .w1.frow1.f1.mdir_b4 -text "zy"		-command {display resetview ; rotate y by 90}	-width 4
	ttk::button .w1.frow1.f1.mdir_b5 -text "z -x"	-command {display resetview ; rotate y by 90; rotate x by -90}		-width 4
	ttk::button .w1.frow1.f1.mdir_b6 -text "xz"		-command {display resetview ; rotate x by -90}		-width 4

	ttk::checkbutton .w1.frow1.f1.cb1 -text "more" -variable ::vmdAssist::mdir -command  {
		if {$::vmdAssist::mdir} {
			grid .w1.frow1.f1.mdir_b1 -column 3 -row 0
			grid .w1.frow1.f1.mdir_b2 -column 4 -row 0
			grid .w1.frow1.f1.mdir_b3 -column 3 -row 1
			grid .w1.frow1.f1.mdir_b4 -column 4 -row 1
			grid .w1.frow1.f1.mdir_b5 -column 3 -row 2
			grid .w1.frow1.f1.mdir_b6 -column 4 -row 2
		} else {
			grid remove .w1.frow1.f1.mdir_b1
			grid remove .w1.frow1.f1.mdir_b2
			grid remove .w1.frow1.f1.mdir_b3
			grid remove .w1.frow1.f1.mdir_b4
			grid remove .w1.frow1.f1.mdir_b5
			grid remove .w1.frow1.f1.mdir_b6
		}
	}

	grid .w1.frow1.f1			-column 0	-row 0	-padx 2 -pady 2 -sticky w
	grid .w1.frow1.f1.cb1		-column 0	-row 1
	grid .w1.frow1.f1.d_b1		-column 1	-row 0
	grid .w1.frow1.f1.d_b2		-column 2	-row 0
	grid .w1.frow1.f1.d_b3		-column 1	-row 1
	grid .w1.frow1.f1.d_b4		-column 2	-row 1
	grid .w1.frow1.f1.d_b5		-column 1	-row 2
	grid .w1.frow1.f1.d_b6		-column 2	-row 2
	# END - View direction - - - - - - - -  - -


	# Show Box and Grid line - - - - - - - -  - -
	ttk::frame .w1.frow1.fbg
	grid .w1.frow1.fbg -row 0 -column 1 -sticky ws -padx 10

	ttk::checkbutton .w1.frow1.fbg.bg_cb1 -text "Box" -variable ::vmdAssist::boxstate  -command [namespace code {
		::vmdAssist::mol_id_check
		pbc box -toggle -center bb -molid $molid
		if {[dict get $box_dict $molid]} {
			dict set box_dict $molid 0
		} else {
			dict set box_dict $molid 1
		}
	}
	]
	ttk::checkbutton .w1.frow1.fbg.bg_cb2 -text "XYZ Axes" -variable ::vmdAssist::showgrid -command [namespace code {
		if {$showgrid} {
			set scale [expr 50*$gridfactor]
			if {[set gridid [molinfo top]] == -1} {return}
			graphics $gridid color red;		graphics $gridid line [vecscale $scale {-1 0 0}] [vecscale $scale {1 0 0}] width 2
			graphics $gridid color green;	graphics $gridid line [vecscale $scale {0 -1 0}] [vecscale $scale {0 1 0}] width 2
			graphics $gridid color blue;	graphics $gridid line [vecscale $scale {0 0 -1}] [vecscale $scale {0 0 1}] width 2
		} else {
			catch {graphics $gridid delete all}
		}
	}
	]
	ttk::entry .w1.frow1.fbg.bg_e1 -textvariable ::vmdAssist::gridfactor -width 4 -validate key -validatecommand {string is double %P}

	grid .w1.frow1.fbg.bg_cb1 -column 0 -row 0 -sticky w
	grid .w1.frow1.fbg.bg_cb2 -column 0 -row 1 -sticky w
	grid .w1.frow1.fbg.bg_e1  -column 1 -row 1 -sticky w
	# END - Show Box and Grid line - - - - - - - -  - -

	ttk::label .w1.frow1.fbg.l1 -text Transparency
	ttk::scale .w1.frow1.fbg.s -from 0.5 -to 1.0 -value 1.0 -orient horizontal -command {wm attributes .w1 -alpha}
	ttk::button .w1.frow1.fbg.bws -text "Windows side by side" -command {
		wm geometry .w1 446x[winfo screenheight .]+[expr [winfo screenwidth .]-446]+0
		display reposition 0 [expr [winfo screenheight .]-20]; display resize [expr [winfo screenwidth .]-446] [expr [winfo screenheight .]-100]
	}
	grid .w1.frow1.fbg.l1 -row 0 -column 2 -padx 20
	grid .w1.frow1.fbg.s  -row 1 -column 2 -padx 20
	grid .w1.frow1.fbg.bws -row 2 -column 2

	ttk::button .w1.about -text About -command {tk_messageBox -type ok -title "About" -message "vmdAssist contains a series of tools that can help us to create and edit atomic structures.\n\nvmdAssist v1.0\n\nby Nader Malih\n\nmalih.nader@gmail.com"}
	grid .w1.about -row 0 -column 0 -sticky ne -padx 10 -pady 10


	# Molecule Select - - - - - - - -  - -
	ttk::frame .w1.f_ms -padding 5
	grid .w1.f_ms -column 0 -row 1 -sticky w

	ttk::label .w1.f_ms.l5 -text "Molecule:"
	ttk::combobox .w1.f_ms.combo3 -state readonly -postcommand [namespace code {
		set molid_list [molinfo list]
		set molname_list {}
		foreach i $molid_list {
			set name [file tail [molinfo $i get name]]
			set name [string trim $name "{}"]
			lappend molname_list $name
		}
		.w1.f_ms.combo3 configure -values $molname_list
	}
	]

	grid .w1.f_ms.l5 			-column 0	-row 0		-padx 2 -pady 2	 -sticky e
	grid .w1.f_ms.combo3 		-column 1	-row 0		-padx 2 -pady 2	 -sticky w

	bind .w1.f_ms.combo3 <<ComboboxSelected>> [namespace code {
		set molid [lindex $molid_list [.w1.f_ms.combo3 current]]
		mol top $molid
		if {[catch {set boxstate [dict get $box_dict $molid]}]} {dict set box_dict $molid 0; set boxstate 0}
		lassign [molinfo $molid get {a b c}] Lx Ly Lz
		set keyword "all"
		.w1.frow3.n.trc.sel.b1 invoke
	}
	]
	# END - Molecule Select - - - - - - - -  - -


	# Notebook
	ttk::frame .w1.frow3 -padding 5
	grid .w1.frow3 -column 0 -row 2 -sticky w

	ttk::notebook .w1.frow3.n
	grid .w1.frow3.n -column 0 -row 0
	ttk::style configure  TNotebook.Tab -foreground blue -padding 5

	ttk::frame .w1.frow4 -padding 5
	grid .w1.frow4 -column 0 -row 3 -sticky w

	ttk::notebook .w1.frow4.n1
	grid .w1.frow4.n1 -column 0 -row 0



	# Sheet to Tube - - - - - - - -  - -
	ttk::frame .w1.frow3.n.fShT -relief sunken -padding 5
	.w1.frow3.n add .w1.frow3.n.fShT -text "Build" -padding 2

	ttk::frame .w1.frow3.n.fShT.f1
	grid .w1.frow3.n.fShT.f1 -column 0 -row 0

	ttk::label			.w1.frow3.n.fShT.f1.l1 -text "Sheet plane:"
	ttk::radiobutton	.w1.frow3.n.fShT.f1.r1 -text xy -value z -variable ::vmdAssist::Sh_C -command [namespace code {.w1.frow3.n.fShT.f1.r4 configure -text x -value x -command [namespace code {set RD a; set Sh_B y}]; .w1.frow3.n.fShT.f1.r5 configure -text y -value y -command [namespace code {set RD b; set Sh_B x}]; .w1.frow3.n.fShT.f1.r4 invoke}]
	ttk::radiobutton	.w1.frow3.n.fShT.f1.r2 -text xz -value y -variable ::vmdAssist::Sh_C -command [namespace code {.w1.frow3.n.fShT.f1.r4 configure -text x -value x -command [namespace code {set RD a; set Sh_B z}]; .w1.frow3.n.fShT.f1.r5 configure -text z -value z -command [namespace code {set RD c; set Sh_B x}]; .w1.frow3.n.fShT.f1.r4 invoke}]
	ttk::radiobutton	.w1.frow3.n.fShT.f1.r3 -text yz -value x -variable ::vmdAssist::Sh_C -command [namespace code {.w1.frow3.n.fShT.f1.r4 configure -text y -value y -command [namespace code {set RD b; set Sh_B z}]; .w1.frow3.n.fShT.f1.r5 configure -text z -value z -command [namespace code {set RD c; set Sh_B y}]; .w1.frow3.n.fShT.f1.r4 invoke}]
	grid .w1.frow3.n.fShT.f1.l1 -column 0 -row 0 -sticky w
	grid .w1.frow3.n.fShT.f1.r1 -column 1 -row 0 -sticky w
	grid .w1.frow3.n.fShT.f1.r2 -column 2 -row 0 -sticky w
	grid .w1.frow3.n.fShT.f1.r3 -column 3 -row 0 -sticky w

	ttk::label			.w1.frow3.n.fShT.f1.l2 -text "Rolling direction:"
	ttk::radiobutton	.w1.frow3.n.fShT.f1.r4 -text x -value x -variable ::vmdAssist::Sh_A -command [namespace code {set RD a; set Sh_B y}]
	ttk::radiobutton	.w1.frow3.n.fShT.f1.r5 -text y -value y -variable ::vmdAssist::Sh_A -command [namespace code {set RD b; set Sh_B x}]
	grid .w1.frow3.n.fShT.f1.l2 -column 0 -row 1 -sticky w
	grid .w1.frow3.n.fShT.f1.r4 -column 1 -row 1 -sticky w
	grid .w1.frow3.n.fShT.f1.r5 -column 2 -row 1 -sticky w

	ttk::labelframe .w1.frow3.n.fShT.nb -text "Nanotube - Torus" -padding 5
	grid .w1.frow3.n.fShT.nb -column 0 -row 1 -sticky ew

	ttk::label 	.w1.frow3.n.fShT.nb.l3 -text "Arc:"
	ttk::entry 	.w1.frow3.n.fShT.nb.e1 -textvariable ::vmdAssist::arc -width 6 -validate key -validatecommand {string is double %P}
	grid .w1.frow3.n.fShT.nb.l3 -column 0 -row 0 -sticky w
	grid .w1.frow3.n.fShT.nb.e1 -column 1 -row 0 -sticky w

	ttk::button .w1.frow3.n.fShT.nb.b1 -text Nanotube 				-command [namespace code {
		::vmdAssist::box_check
		set sel [atomselect $molid all]
		set L [molinfo $molid get $RD]
		set R0 [expr {$L/$arc*180/$Pi}]
		set Hmean [vecmean [$sel get $Sh_C]]

		set xyz {}
		foreach a [$sel get $Sh_A] b [$sel get $Sh_B] c [$sel get $Sh_C] {
			set theta [expr {$a/$R0}]
			set Rnew [expr {$R0+$Hmean-$c}]
			lappend xyz [list [expr {$Rnew*cos($theta)}] [expr {-1*$Rnew*sin($theta)}] $b]
		}
		set new_mol [mol new atoms [$sel num]]
		animate dup $new_mol
		mol rename $new_mol "Nanotube $arc"
		set new_sel [atomselect $new_mol all]
		$new_sel set $key [$sel get $key]
		$new_sel set {x y z} $xyz
		mol bondsrecalc $new_mol
		mol addrep $new_mol
		molinfo $new_mol set {a b c} [list [expr ceil($R0)*2+50] [expr ceil($R0)*2+50] [molinfo $molid get [switch $Sh_B x {return -level 0 a} y {return -level 0 b} z {return -level 0 c}]]]
		mol top $new_mol
		display resetview
		pbc box -center bb -molid $new_mol
		dict set box_dict $new_mol 1
		set boxstate 1
		$sel delete; $new_sel delete
		.w1.frow3.n.fShT.txt configure -state normal
		.w1.frow3.n.fShT.txt replace 1.0 end "Radius: $R0"
		.w1.frow3.n.fShT.txt configure -state disable
	}
	]
	ttk::button .w1.frow3.n.fShT.nb.b2 -text "Rolling animation"	-command [namespace code {
		::vmdAssist::box_check
		set sel [atomselect $molid all]
		set L [molinfo $molid get $RD]
		set Hmean [vecmean [$sel get $Sh_C]]
		set new_mol [mol new atoms [$sel num]]
		mol rename $new_mol "Nanotube rolling animation"
		animate dup $new_mol
		set new_sel [atomselect $new_mol all]
		$new_sel set $key [$sel get $key]; $new_sel delete

		for {set i 1} {$i<=360} {incr i} {
			set R0 [expr {$L/$i*180/$Pi}]
			set xyz {}
			foreach a [$sel get $Sh_A] b [$sel get $Sh_B] c [$sel get $Sh_C] {
				set theta [expr {$a/$R0}]
				set Rnew [expr {$R0+$Hmean-$c}]
				lappend xyz [list [expr {$Rnew*cos($theta)}] [expr {-1*$Rnew*sin($theta)}] $b]
			}
			animate dup $new_mol
			set new_sel [atomselect $new_mol all frame $i]
			$new_sel set {x y z} $xyz; $new_sel delete
		}
		mol bondsrecalc $new_mol
		mol addrep $new_mol
		molinfo $new_mol set {a b c} [list [expr ceil($R0)*2+50] [expr ceil($R0)*2+50] [molinfo $molid get [switch $Sh_B x {return -level 0 a} y {return -level 0 b} z {return -level 0 c}]]]
		mol top $new_mol
		display resetview
		pbc box -center bb -molid $new_mol
		dict set box_dict $new_mol 1
		set boxstate 1
		.w1.frow3.n.fShT.txt configure -state normal
		.w1.frow3.n.fShT.txt replace 1.0 end "Radius: $R0"
		.w1.frow3.n.fShT.txt configure -state disable
	}
	]
	ttk::button .w1.frow3.n.fShT.nb.b3 -text "Torus" -command [namespace code {
		::vmdAssist::box_check
		set sel [atomselect $molid all]
		set L [molinfo $molid get $RD]
		set R0 [expr {$L/2.0/$Pi}]
		set Hmean [vecmean [$sel get $Sh_C]]
		set xyz {}
		foreach a [$sel get $Sh_A] b [$sel get $Sh_B] c [$sel get $Sh_C] {
			set theta [expr {$a/$R0}]
			set Rnew [expr {$R0+$Hmean-$c}]
			lappend xyz [list [expr {$Rnew*cos($theta)}] [expr {-1*$Rnew*sin($theta)}] $b]
		}

		set L [molinfo $molid get [switch $Sh_B x {return -level 0 a} y {return -level 0 b} z {return -level 0 c}]]
		set R0_T [expr {$L/$arc*180/$Pi}]
		set xyz_tor {}
		foreach bca $xyz {
			lassign $bca b c a
			set theta [expr {$a/$R0_T}]
			set Rnew [expr {$R0_T-$c}]
			lappend xyz_tor [list [expr {$Rnew*cos($theta)}] [expr {-1*$Rnew*sin($theta)}] $b]
		}

		set new_mol [mol new atoms [$sel num]]
		animate dup $new_mol
		mol rename $new_mol "Torus $arc"
		set new_sel [atomselect $new_mol all]
		$new_sel set $key [$sel get $key]
		$new_sel set {x y z} $xyz_tor
		mol bondsrecalc $new_mol
		mol addrep $new_mol
		molinfo $new_mol set {a b c} [list [expr ceil($R0_T+$R0)*2+50] [expr ceil($R0_T+$R0)*2+50] [expr ceil($R0)*2+50]]
		mol top $new_mol
		display resetview
		pbc box -center bb -molid $new_mol
		dict set box_dict $new_mol 1
		set boxstate 1
		$sel delete; $new_sel delete
		.w1.frow3.n.fShT.txt configure -state normal
		.w1.frow3.n.fShT.txt replace 1.0 end "Tube Radius: $R0\nTorus Radius: $R0_T"
		.w1.frow3.n.fShT.txt configure -state disable
	}
	]
	grid .w1.frow3.n.fShT.nb.b1 -column 0 -row 1
	grid .w1.frow3.n.fShT.nb.b2 -column 1 -row 1
	grid .w1.frow3.n.fShT.nb.b3 -column 0 -row 2

	# Spiral Tube
	ttk::labelframe .w1.frow3.n.fShT.s -text "Spiral Nanotube" -padding 5
	grid .w1.frow3.n.fShT.s -column 0 -row 2 -sticky ew

	ttk::label .w1.frow3.n.fShT.s.l1 -text "Number of Rings: "
	ttk::entry .w1.frow3.n.fShT.s.e1 -textvariable  ::vmdAssist::NoR -width 6 -validate key -validatecommand {string is int %P}
	ttk::label .w1.frow3.n.fShT.s.l2 -text "Rings Distance:"
	ttk::entry .w1.frow3.n.fShT.s.e2 -textvariable  ::vmdAssist::DoR -width 6 -validate key -validatecommand {string is double %P}
	ttk::button .w1.frow3.n.fShT.s.b1 -text "Build" -command [namespace code {
		::vmdAssist::box_check
		set sel [atomselect $molid all]
		set L [molinfo $molid get $RD]
		set R0 [expr {$L/2.0/$Pi}]
		set Hmean [vecmean [$sel get $Sh_C]]
		set xyz {}
		foreach a [$sel get $Sh_A] b [$sel get $Sh_B] c [$sel get $Sh_C] {
			set theta [expr {$a/$R0}]
			set Rnew [expr {$R0+$Hmean-$c}]
			lappend xyz [list [expr {$Rnew*cos($theta)}] [expr {-1*$Rnew*sin($theta)}] $b]
		}

		set L [molinfo $molid get [switch $Sh_B x {return -level 0 a} y {return -level 0 b} z {return -level 0 c}]]
		set R0_T [expr {$L/2.0/$Pi}]
		set xyz_tor {}
		foreach bca $xyz {
			lassign $bca b c a
			set theta [expr {$a/$R0_T}]
			set Rnew [expr {$R0_T-$c}]
			lappend xyz_tor [list [expr {$Rnew*cos($theta)}] [expr {-1*$Rnew*sin($theta)}] $b]
		}

		set xyz_spring1 {}
		foreach xyz $xyz_tor {
			lassign $xyz x y z
			set z [expr $z + (2*$R0+$DoR)/2/$Pi * (acos($x/sqrt($x**2.0+$y**2.0))*($y+0.1)/abs($y+0.1)+-1*$Pi*(($y+0.1)/abs($y+0.1)-1)) ]
			lappend xyz_spring1 [list $x $y $z]
		}

		set xyz_spring {}
		set new_att {}
		for {set i 0} {$i < $NoR} {incr i} {
			foreach xyz $xyz_spring1 att [$sel get $key] {
				lappend xyz_spring [vecadd $xyz [list 0 0 [expr (2*$R0+$DoR)*$i]]]
				lappend new_att $att
			}
		}

		set new_mol [mol new atoms [expr [$sel num]*$NoR]]
		animate dup $new_mol
		mol rename $new_mol "Spring Nanotube"
		set new_sel [atomselect $new_mol all]
		$new_sel set $key $new_att
		$new_sel set {x y z} $xyz_spring
		mol bondsrecalc $new_mol
		mol addrep $new_mol
		molinfo $new_mol set {a b c} [list [expr ceil($R0_T+$R0)*2+50] [expr ceil($R0_T+$R0)*2+50] [expr (2*$R0+$DoR)*$NoR]]
		mol top $new_mol
		display resetview
		pbc box -center bb -molid $new_mol
		dict set box_dict $new_mol 1
		set boxstate 1
		$sel delete; $new_sel delete
		.w1.frow3.n.fShT.txt configure -state normal
		.w1.frow3.n.fShT.txt replace 1.0 end "Tube Radius: $R0\nTorus Radius: $R0_T"
		.w1.frow3.n.fShT.txt configure -state disable
	}
	]

	grid .w1.frow3.n.fShT.s.l1 -column 0 -row 0 -sticky w
	grid .w1.frow3.n.fShT.s.e1 -column 1 -row 0
	grid .w1.frow3.n.fShT.s.l2 -column 0 -row 1 -sticky w
	grid .w1.frow3.n.fShT.s.e2 -column 1 -row 1
	grid .w1.frow3.n.fShT.s.b1 -column 0 -row 2 -columnspan 2

	# Spiral Sheet

	ttk::labelframe .w1.frow3.n.fShT.ss -text "Spiral Sheet" -padding 5
	grid .w1.frow3.n.fShT.ss -column 1 -row 1 -sticky nsew -padx 5

	ttk::label .w1.frow3.n.fShT.ss.l1 -text "Number of Rings: "
	ttk::entry .w1.frow3.n.fShT.ss.e1 -textvariable  ::vmdAssist::NoR_S -width 6 -validate key -validatecommand {string is int %P}
	ttk::label .w1.frow3.n.fShT.ss.l2 -text "Rings Distance:"
	ttk::entry .w1.frow3.n.fShT.ss.e2 -textvariable  ::vmdAssist::DoR_S -width 6 -validate key -validatecommand {string is double %P}
	ttk::button .w1.frow3.n.fShT.ss.b1 -text "Build" -command [namespace code {
		::vmdAssist::box_check
		set CoGx 0; set CoGy 0; set CoGz 0; .w1.frow3.n.trc.gc.f2.l2_b2 invoke
		set L_A [switch $Sh_A x {return -level 0 $Lx} y {return -level 0 $Ly} z {return -level 0 $Lz}]
		set L_B [switch $Sh_B x {return -level 0 $Lx} y {return -level 0 $Ly} z {return -level 0 $Lz}]
		if {$L_A < $L_B} {set R [expr $L_A/2]} else {set R [expr $L_B/2]}
		set sel [atomselect $molid "sqrt($Sh_A**2+$Sh_B**2)<=$R"]

		set xyz_spring1 {}
		foreach xyz [$sel get [list $Sh_A $Sh_B $Sh_C]] {
			lassign $xyz x y z
			set z [expr $z + $DoR_S/2/$Pi * (acos($x/sqrt($x**2.0+$y**2.0))*($y+0.1)/abs($y+0.1)+-1*$Pi*(($y+0.1)/abs($y+0.1)-1)) ]
			lappend xyz_spring1 [list $x $y $z]
		}

		set xyz_spring {}
		set new_att {}
		for {set i 0} {$i < $NoR_S} {incr i} {
			foreach xyz $xyz_spring1 att [$sel get $key] {
				lappend xyz_spring [vecadd $xyz [list 0 0 [expr $DoR_S*$i]]]
				lappend new_att $att
			}
		}

		set new_mol [mol new atoms [expr [$sel num]*$NoR_S]]
		animate dup $new_mol
		mol rename $new_mol "Spring Sheet"
		set new_sel [atomselect $new_mol all]
		$new_sel set $key $new_att
		$new_sel set {x y z} $xyz_spring
		mol bondsrecalc $new_mol
		mol addrep $new_mol
		molinfo $new_mol set {a b c} [list [expr ceil($R)*2+50] [expr ceil($R)*2+50] [expr $DoR_S*$NoR_S]]
		mol top $new_mol
		display resetview
		pbc box -center bb -molid $new_mol
		dict set box_dict $new_mol 1
		set boxstate 1
		$sel delete; $new_sel delete
		.w1.frow3.n.fShT.txt configure -state normal
		.w1.frow3.n.fShT.txt replace 1.0 end "Sheet Radius: $R"
		.w1.frow3.n.fShT.txt configure -state disable
	}
	]

	grid .w1.frow3.n.fShT.ss.l1 -column 0 -row 0 -sticky w
	grid .w1.frow3.n.fShT.ss.e1 -column 1 -row 0
	grid .w1.frow3.n.fShT.ss.l2 -column 0 -row 1 -sticky w
	grid .w1.frow3.n.fShT.ss.e2 -column 1 -row 1
	grid .w1.frow3.n.fShT.ss.b1 -column 0 -row 2 -columnspan 2

	# Log - - -
	text .w1.frow3.n.fShT.txt -height 1 -width 20 -state disable
	grid .w1.frow3.n.fShT.txt -column 1 -row 2 -sticky nsew -padx 5 -pady 5

	# END - Sheet to Tube - - - - - - - -  - -


	# Translation/Rotation/Geometric Center  - - - - - - - -  - -
	ttk::frame .w1.frow3.n.trc -relief sunken -padding 5
	.w1.frow3.n add .w1.frow3.n.trc -text "Translation/Rotation/GeoCenter" -padding 2

	# Selection - - -
	ttk::frame .w1.frow3.n.trc.sel -padding 5
	grid .w1.frow3.n.trc.sel -column 0 -row 0 -columnspan 2 -sticky w

	ttk::label  .w1.frow3.n.trc.sel.l1 -text "Selection: "
	ttk::entry  .w1.frow3.n.trc.sel.e1 -textvariable ::vmdAssist::keyword
	ttk::button .w1.frow3.n.trc.sel.b1 -text "set" -width 5 -command [namespace code {
		::vmdAssist::mol_id_check
		if {[catch {$mol_sel molid}] == 0} {$mol_sel delete}
		if {[catch {set mol_sel [atomselect $molid $keyword]}]} {
			.w1.frow3.n.trc.sel.l2 configure -text "wrong entry for selection" -foreground red
		} else {
			.w1.frow3.n.trc.sel.l2 configure -text "selection is ok" -foreground darkgreen
		}
	}
	]
	ttk::label  .w1.frow3.n.trc.sel.l2 -text "- - -"

	grid .w1.frow3.n.trc.sel.l1 			-column 2	-row 0		-padx 2 -pady 2	 -sticky e
	grid .w1.frow3.n.trc.sel.e1 			-column 3	-row 0		-padx 2 -pady 2	 -sticky e
	grid .w1.frow3.n.trc.sel.b1 			-column 4	-row 0		-padx 2 -pady 2	 -sticky e
	grid .w1.frow3.n.trc.sel.l2 			-column 5	-row 0		-padx 2 -pady 2	 -sticky e

	# Translation - - -
	ttk::labelframe .w1.frow3.n.trc.f1 -text "Translation" -padding 5
	grid .w1.frow3.n.trc.f1 -column 0 -row 1

	ttk::button .w1.frow3.n.trc.f1.b1 -text "+y" -command [namespace code {::vmdAssist::translate 0 1 0}]	-width 4
	ttk::button .w1.frow3.n.trc.f1.b2 -text "-z" -command [namespace code {::vmdAssist::translate 0 0 -1}]	-width 4
	ttk::button .w1.frow3.n.trc.f1.b3 -text "-x" -command [namespace code {::vmdAssist::translate -1 0 0}]	-width 4
	ttk::button .w1.frow3.n.trc.f1.b4 -text "+x" -command [namespace code {::vmdAssist::translate 1 0 0}]	-width 4
	ttk::button .w1.frow3.n.trc.f1.b5 -text "+z" -command [namespace code {::vmdAssist::translate 0 0 1}]	-width 4
	ttk::button .w1.frow3.n.trc.f1.b6 -text "-y" -command [namespace code {::vmdAssist::translate 0 -1 0}]	-width 4
	ttk::entry	.w1.frow3.n.trc.f1.e1 -textvariable ::vmdAssist::displace -width 4 -validate key -validatecommand {string is double %P}

	grid .w1.frow3.n.trc.f1.b1		-column 1	-row 0
	grid .w1.frow3.n.trc.f1.b2		-column 2	-row 0
	grid .w1.frow3.n.trc.f1.b3		-column 0	-row 1
	grid .w1.frow3.n.trc.f1.e1		-column 1	-row 1
	grid .w1.frow3.n.trc.f1.b4		-column 2	-row 1
	grid .w1.frow3.n.trc.f1.b5		-column 0	-row 2
	grid .w1.frow3.n.trc.f1.b6		-column 1	-row 2

	# Rotate structure - - -
	ttk::labelframe .w1.frow3.n.trc.rot -text "Rotation" -padding 5
	grid .w1.frow3.n.trc.rot -column 0 -row 2 -columnspan 2 -sticky w

	# Center of rotation
	ttk::label .w1.frow3.n.trc.rot.l1 -text "Center of rotation:"
	ttk::frame .w1.frow3.n.trc.rot.f1
	ttk::label .w1.frow3.n.trc.rot.f1.l2 -text "x:"
	ttk::label .w1.frow3.n.trc.rot.f1.l3 -text "y:"
	ttk::label .w1.frow3.n.trc.rot.f1.l4 -text "z:"
	ttk::entry .w1.frow3.n.trc.rot.f1.e1 -textvariable ::vmdAssist::cor_x -width 10 -validate key -validatecommand {string is double %P}
	ttk::entry .w1.frow3.n.trc.rot.f1.e2 -textvariable ::vmdAssist::cor_y -width 10 -validate key -validatecommand {string is double %P}
	ttk::entry .w1.frow3.n.trc.rot.f1.e3 -textvariable ::vmdAssist::cor_z -width 10 -validate key -validatecommand {string is double %P}

	grid .w1.frow3.n.trc.rot.l1		  -row 0  -column 0   -sticky w
	grid .w1.frow3.n.trc.rot.f1       -row 0  -column 1   -sticky w
	grid .w1.frow3.n.trc.rot.f1.l2    -row 0  -column 1   -sticky w
	grid .w1.frow3.n.trc.rot.f1.e1    -row 0  -column 2   -sticky w
	grid .w1.frow3.n.trc.rot.f1.l3    -row 0  -column 3   -sticky w
	grid .w1.frow3.n.trc.rot.f1.e2    -row 0  -column 4   -sticky w
	grid .w1.frow3.n.trc.rot.f1.l4    -row 0  -column 5   -sticky w
	grid .w1.frow3.n.trc.rot.f1.e3    -row 0  -column 6   -sticky w

	# Axis of rotation
	ttk::label .w1.frow3.n.trc.rot.l5 -text "Axis of rotation:"
	ttk::frame .w1.frow3.n.trc.rot.f2
	ttk::radiobutton .w1.frow3.n.trc.rot.f2.r1 -text "x"       -variable ::vmdAssist::aor -value {1 0 0} -command [namespace code {lassign $aor aor_x aor_y aor_z; ::vmdAssist::update_aor readonly}]
	ttk::radiobutton .w1.frow3.n.trc.rot.f2.r2 -text "y"       -variable ::vmdAssist::aor -value {0 1 0} -command [namespace code {lassign $aor aor_x aor_y aor_z; ::vmdAssist::update_aor readonly}]
	ttk::radiobutton .w1.frow3.n.trc.rot.f2.r3 -text "z"       -variable ::vmdAssist::aor -value {0 0 1} -command [namespace code {lassign $aor aor_x aor_y aor_z; ::vmdAssist::update_aor readonly}]
	ttk::radiobutton .w1.frow3.n.trc.rot.f2.r4 -text "custom"  -variable ::vmdAssist::aor -value {0 0 0} -command [namespace code {::vmdAssist::update_aor normal}]

	ttk::label .w1.frow3.n.trc.rot.f2.l6 -text "x:"
	ttk::label .w1.frow3.n.trc.rot.f2.l7 -text "y:"
	ttk::label .w1.frow3.n.trc.rot.f2.l8 -text "z:"
	ttk::entry .w1.frow3.n.trc.rot.f2.e4 -textvariable ::vmdAssist::aor_x -state readonly -width 3 -validate key -validatecommand {string is double %P}
	ttk::entry .w1.frow3.n.trc.rot.f2.e5 -textvariable ::vmdAssist::aor_y -state readonly -width 3 -validate key -validatecommand {string is double %P}
	ttk::entry .w1.frow3.n.trc.rot.f2.e6 -textvariable ::vmdAssist::aor_z -state readonly -width 3 -validate key -validatecommand {string is double %P}

	grid .w1.frow3.n.trc.rot.l5    	  -row 1  -column 0   -sticky w
	grid .w1.frow3.n.trc.rot.f2       -row 1  -column 1   -sticky w
	grid .w1.frow3.n.trc.rot.f2.r1    -row 0  -column 1   -sticky w
	grid .w1.frow3.n.trc.rot.f2.r2    -row 0  -column 2   -sticky w
	grid .w1.frow3.n.trc.rot.f2.r3    -row 0  -column 3   -sticky w
	grid .w1.frow3.n.trc.rot.f2.r4    -row 0  -column 4   -sticky w

	grid .w1.frow3.n.trc.rot.f2.l6    -row 0  -column 5   -sticky w
	grid .w1.frow3.n.trc.rot.f2.l7    -row 0  -column 7   -sticky w
	grid .w1.frow3.n.trc.rot.f2.l8    -row 0  -column 9   -sticky w
	grid .w1.frow3.n.trc.rot.f2.e4    -row 0  -column 6   -sticky w
	grid .w1.frow3.n.trc.rot.f2.e5    -row 0  -column 8   -sticky w
	grid .w1.frow3.n.trc.rot.f2.e6    -row 0  -column 10   -sticky w

	# Amount of rotation
	ttk::label  .w1.frow3.n.trc.rot.l9 -text "Amount of rotation:"
	ttk::frame  .w1.frow3.n.trc.rot.f3
	ttk::entry  .w1.frow3.n.trc.rot.f3.e7 -textvariable ::vmdAssist::rot_theta -width 4
	ttk::button .w1.frow3.n.trc.rot.f3.b1 -text Left	-width 7	-command {::vmdAssist::rotate 1}
	ttk::button .w1.frow3.n.trc.rot.f3.b2 -text Right	-width 7	-command {::vmdAssist::rotate -1}

	grid .w1.frow3.n.trc.rot.l9    	  -row 2  -column 0   -sticky w
	grid .w1.frow3.n.trc.rot.f3       -row 2  -column 1   -sticky w
	grid .w1.frow3.n.trc.rot.f3.e7    -row 0  -column 1   -sticky w
	grid .w1.frow3.n.trc.rot.f3.b1    -row 0  -column 2   -sticky w
	grid .w1.frow3.n.trc.rot.f3.b2    -row 0  -column 3   -sticky w

	# Geometric center - - -
	ttk::labelframe .w1.frow3.n.trc.gc -text "Geometric Center" -padding 5
	grid .w1.frow3.n.trc.gc -column 1 -row 1  -padx 5 -sticky wns

	ttk::frame .w1.frow3.n.trc.gc.f1
	grid .w1.frow3.n.trc.gc.f1				-column 0	-row 0	-padx 2 -pady 2
	ttk::label .w1.frow3.n.trc.gc.f1.l1 -text "x:"
	ttk::label .w1.frow3.n.trc.gc.f1.l2 -text "y:"
	ttk::label .w1.frow3.n.trc.gc.f1.l3 -text "z:"
	ttk::entry .w1.frow3.n.trc.gc.f1.e1 -textvariable ::vmdAssist::CoGx -width 10 -validate key -validatecommand {string is double %P}
	ttk::entry .w1.frow3.n.trc.gc.f1.e2 -textvariable ::vmdAssist::CoGy -width 10 -validate key -validatecommand {string is double %P}
	ttk::entry .w1.frow3.n.trc.gc.f1.e3 -textvariable ::vmdAssist::CoGz -width 10 -validate key -validatecommand {string is double %P}
	grid .w1.frow3.n.trc.gc.f1.l1 -column 1	-row 0
	grid .w1.frow3.n.trc.gc.f1.l2 -column 3	-row 0
	grid .w1.frow3.n.trc.gc.f1.l3 -column 5	-row 0
	grid .w1.frow3.n.trc.gc.f1.e1 -column 2	-row 0
	grid .w1.frow3.n.trc.gc.f1.e2 -column 4	-row 0
	grid .w1.frow3.n.trc.gc.f1.e3 -column 6	-row 0

	ttk::frame .w1.frow3.n.trc.gc.f2
	grid .w1.frow3.n.trc.gc.f2				-column 0	-row 1	-padx 2 -pady 2
	ttk::button 	.w1.frow3.n.trc.gc.f2.l2_b1 -text "Get" -width 7 -command [namespace code {
		::vmdAssist::mol_sel_check
		set CoGx [vecmean [$mol_sel get x]]; set CoGy [vecmean [$mol_sel get y]]; set CoGz [vecmean [$mol_sel get z]]
	}
	]
	ttk::button 	.w1.frow3.n.trc.gc.f2.l2_b2 -text "Set" -width 7 -command [namespace code {
		::vmdAssist::mol_sel_check
		$mol_sel moveby [vecsub [list $CoGx $CoGy $CoGz] [list [vecmean [$mol_sel get x]] [vecmean [$mol_sel get y]] [vecmean [$mol_sel get z]]]]
	}
	]
	ttk::button 	.w1.frow3.n.trc.gc.f2.l2_b3 -text "Set to Center of Box" -command [namespace code {
		::vmdAssist::box_check
		set CoGx [expr $Lx/2]; set CoGy [expr $Ly/2]; set CoGz [expr $Lz/2]
		.w1.frow3.n.trc.gc.f2.l2_b2 invoke
	}
	]

	grid .w1.frow3.n.trc.gc.f2.l2_b1		-column 1	-row 0
	grid .w1.frow3.n.trc.gc.f2.l2_b2		-column 2	-row 0
	grid .w1.frow3.n.trc.gc.f2.l2_b3		-column 3	-row 0
	# END - Translation/Rotation/Gometric Center  - - - - - - - -  - -


	# Box Settings - - - - - - - -  - -
	ttk::frame 	.w1.frow3.n.bs -relief sunken -padding 5
	.w1.frow3.n add .w1.frow3.n.bs -text "BoxSettings/EditMolecule" -padding 2

	# Box settings - - -
	ttk::labelframe .w1.frow3.n.bs.box -text "Box Settings" -padding 5
	grid .w1.frow3.n.bs.box -column 0 -row 0 -sticky w

	ttk::label .w1.frow3.n.bs.box.l1 -text "Box Length: "
	ttk::frame .w1.frow3.n.bs.box.f1
	ttk::label .w1.frow3.n.bs.box.f1.b_l1 -text "Lx:"
	ttk::label .w1.frow3.n.bs.box.f1.b_l2 -text "Ly:"
	ttk::label .w1.frow3.n.bs.box.f1.b_l3 -text "Lz:"
	ttk::entry .w1.frow3.n.bs.box.f1.b_e1 -textvariable ::vmdAssist::Lx -width 10 -validate key -validatecommand {string is double %P}
	ttk::entry .w1.frow3.n.bs.box.f1.b_e2 -textvariable ::vmdAssist::Ly -width 10 -validate key -validatecommand {string is double %P}
	ttk::entry .w1.frow3.n.bs.box.f1.b_e3 -textvariable ::vmdAssist::Lz -width 10 -validate key -validatecommand {string is double %P}
	grid .w1.frow3.n.bs.box.l1		-column 0	-row 0
	grid .w1.frow3.n.bs.box.f1      -column 1	-row 0 -columnspan 3
	grid .w1.frow3.n.bs.box.f1.b_l1 -column 0	-row 0
	grid .w1.frow3.n.bs.box.f1.b_l2 -column 2	-row 0
	grid .w1.frow3.n.bs.box.f1.b_l3 -column 4	-row 0
	grid .w1.frow3.n.bs.box.f1.b_e1 -column 1	-row 0
	grid .w1.frow3.n.bs.box.f1.b_e2 -column 3	-row 0
	grid .w1.frow3.n.bs.box.f1.b_e3 -column 5   -row 0

	ttk::button .w1.frow3.n.bs.box.b1 -text "Get Box" -command [namespace code {
		::vmdAssist::mol_id_check
		lassign [molinfo $molid get {a b c}] Lx Ly Lz
		if {[molinfo $molid get {a b c}] == {0.000000 0.000000 0.000000}} {tk_messageBox -type ok -title "Zero box length" -message "Box size is not defined in loaded molecule.\nUse \"Set Box\"/\"GuessBox\" button to create box."; return -level 0 1} else {return -level 0 0}

	}
	]
	ttk::button .w1.frow3.n.bs.box.b2 -text "Set Box" -command [namespace code {
		::vmdAssist::mol_id_check
		molinfo $molid set {a b c} [list $Lx $Ly $Lz]
		pbc box -center bb -molid $molid
		dict set box_dict $molid 1
		set boxstate 1
	}
	]
	ttk::button .w1.frow3.n.bs.box.b3 -text "Guess Box" -command [namespace code {
		::vmdAssist::mol_id_check
		source [file join $dir {guess_box.tcl}]
		::vmdAssist::makebox
		pbc box -center bb -molid $molid
		dict set box_dict $molid 1
		set boxstate 1
	}
	]
	ttk::label .w1.frow3.n.bs.box.l2 -text "---"

	grid .w1.frow3.n.bs.box.b1 -column 1 -row 1 -pady 10 -sticky s
	grid .w1.frow3.n.bs.box.b2 -column 2 -row 1 -pady 10 -sticky s
	grid .w1.frow3.n.bs.box.b3 -column 3 -row 1 -pady 10 -sticky s
	grid .w1.frow3.n.bs.box.l2 -column 0 -row 4 -columnspan 2 -sticky w

	# Edit Molecule - - -
	ttk::labelframe .w1.frow3.n.bs.em -text "Edit Molecule" -padding 5
	grid .w1.frow3.n.bs.em -column 0 -row 1 -sticky w

	ttk::label .w1.frow3.n.bs.em.l1 -text "Select type:"
	ttk::combobox .w1.frow3.n.bs.em.combo1 -state readonly -width 10 -postcommand [namespace code {
		::vmdAssist::mol_id_check
		set sel [atomselect $molid all]
		set type_list {}
		foreach type [$sel get type] {
			set add 1
			foreach item $type_list {if {$type == $item} {set add 0; break}}
			if {$add} {lappend type_list $type}
		}
		.w1.frow3.n.bs.em.combo1 configure -values $type_list
		$sel delete
	}
	]
	ttk::label .w1.frow3.n.bs.em.l2 -text "Change:"
	ttk::combobox .w1.frow3.n.bs.em.combo2 -state readonly -width 10 -values $::vmdAssist::key
	.w1.frow3.n.bs.em.combo2 current 0
	ttk::label .w1.frow3.n.bs.em.l3 -text "-" -width 10
	ttk::label .w1.frow3.n.bs.em.l4 -text "To:"
	ttk::entry .w1.frow3.n.bs.em.e1 -width 10 -textvariable ::vmdAssist::newvalue
	ttk::button .w1.frow3.n.bs.em.b1 -text Change -command [namespace code {
		::vmdAssist::mol_id_check
		set sel [atomselect $molid "type [.w1.frow3.n.bs.em.combo1 get]"]
		set att_list {}
		for {set i 0} {$i < [$sel num]} {incr i} {lappend att_list $newvalue}
		$sel set [.w1.frow3.n.bs.em.combo2 get] $att_list
		$sel delete
	}
	]
	bind .w1.frow3.n.bs.em.combo1 <<ComboboxSelected>> {::vmdAssist::get_att}
	bind .w1.frow3.n.bs.em.combo2 <<ComboboxSelected>> {::vmdAssist::get_att}


	grid .w1.frow3.n.bs.em.l1		-column 0 -row 0 -sticky w
	grid .w1.frow3.n.bs.em.combo1	-column 0 -row 1
	grid .w1.frow3.n.bs.em.l2		-column 1 -row 0 -sticky w
	grid .w1.frow3.n.bs.em.combo2	-column 1 -row 1
	grid .w1.frow3.n.bs.em.l3		-column 2 -row 1
	grid .w1.frow3.n.bs.em.l4 		-column 3 -row 1
	grid .w1.frow3.n.bs.em.e1 		-column 4 -row 1
	grid .w1.frow3.n.bs.em.b1 		-column 4 -row 2
	# END - Box Settings - - - - - - - -  - -


	# Cell repeat - - - - - - - -  - -
	ttk::frame 	.w1.frow4.n1.cr -relief sunken -padding 5
	.w1.frow4.n1 add .w1.frow4.n1.cr -text "Super Cell Builder" -padding 2

	ttk::labelframe .w1.frow4.n1.cr.fmaster -text "Super Cell Builder" -padding 5
	grid .w1.frow4.n1.cr.fmaster -column 0 -row 0

	ttk::label 	.w1.frow4.n1.cr.fmaster.lnc -text "Number of Cell: "
	ttk::label 	.w1.frow4.n1.cr.fmaster.ll -text "Length: "
	grid .w1.frow4.n1.cr.fmaster.lnc		-column 0	-row 0
	grid .w1.frow4.n1.cr.fmaster.ll			-column 0	-row 1 -sticky e

	ttk::label .w1.frow4.n1.cr.fmaster.l1 -text "Nx:"
	ttk::label .w1.frow4.n1.cr.fmaster.l2 -text "Ny:"
	ttk::label .w1.frow4.n1.cr.fmaster.l3 -text "Nz:"
	ttk::entry .w1.frow4.n1.cr.fmaster.e1 -textvariable ::vmdAssist::Nx -width 6 -validate all -validatecommand [namespace code {if {"%V" == "key"} {string is int %P} elseif {"%V" == "focusout"} {::vmdAssist::box_check; set Lx_SC [expr $Nx*$Lx];return 1} else {return 1}}]
	ttk::entry .w1.frow4.n1.cr.fmaster.e2 -textvariable ::vmdAssist::Ny -width 6 -validate all -validatecommand [namespace code {if {"%V" == "key"} {string is int %P} elseif {"%V" == "focusout"} {::vmdAssist::box_check; set Ly_SC [expr $Ny*$Ly];return 1} else {return 1}}]
	ttk::entry .w1.frow4.n1.cr.fmaster.e3 -textvariable ::vmdAssist::Nz -width 6 -validate all -validatecommand [namespace code {if {"%V" == "key"} {string is int %P} elseif {"%V" == "focusout"} {::vmdAssist::box_check; set Lz_SC [expr $Nz*$Lz];return 1} else {return 1}}]
	grid .w1.frow4.n1.cr.fmaster.l1 -column 1	-row 0
	grid .w1.frow4.n1.cr.fmaster.l2 -column 3	-row 0
	grid .w1.frow4.n1.cr.fmaster.l3 -column 5	-row 0
	grid .w1.frow4.n1.cr.fmaster.e1 -column 2	-row 0
	grid .w1.frow4.n1.cr.fmaster.e2 -column 4	-row 0
	grid .w1.frow4.n1.cr.fmaster.e3 -column 6	-row 0


	ttk::label .w1.frow4.n1.cr.fmaster.l11 -text "Lx: "
	ttk::label .w1.frow4.n1.cr.fmaster.l12 -text "Ly: "
	ttk::label .w1.frow4.n1.cr.fmaster.l13 -text "Lz: "
	ttk::entry .w1.frow4.n1.cr.fmaster.e11 -textvariable ::vmdAssist::Lx_SC -width 6 -validate all -validatecommand [namespace code {if {"%V" == "key"} {string is double %P} elseif {"%V" == "focusout"} {::vmdAssist::box_check; set Nx [expr int(ceil($Lx_SC/$Lx))];return 1} else {return 1}}]
	ttk::entry .w1.frow4.n1.cr.fmaster.e12 -textvariable ::vmdAssist::Ly_SC -width 6 -validate all -validatecommand [namespace code {if {"%V" == "key"} {string is double %P} elseif {"%V" == "focusout"} {::vmdAssist::box_check; set Ny [expr int(ceil($Ly_SC/$Ly))];return 1} else {return 1}}]
	ttk::entry .w1.frow4.n1.cr.fmaster.e13 -textvariable ::vmdAssist::Lz_SC -width 6 -validate all -validatecommand [namespace code {if {"%V" == "key"} {string is double %P} elseif {"%V" == "focusout"} {::vmdAssist::box_check; set Nz [expr int(ceil($Lz_SC/$Lz))];return 1} else {return 1}}]
	grid .w1.frow4.n1.cr.fmaster.l11 -column 1	-row 1
	grid .w1.frow4.n1.cr.fmaster.l12 -column 3	-row 1
	grid .w1.frow4.n1.cr.fmaster.l13 -column 5	-row 1
	grid .w1.frow4.n1.cr.fmaster.e11 -column 2	-row 1
	grid .w1.frow4.n1.cr.fmaster.e12 -column 4	-row 1
	grid .w1.frow4.n1.cr.fmaster.e13 -column 6	-row 1

	ttk::button .w1.frow4.n1.cr.fmaster.bcr -text "Generate" -command [namespace code {
		::vmdAssist::box_check
		set new_xyz {}
		set new_att {}
		set Natoms 0
		for {set i 0} {$i < $Nx} {incr i} {
			for {set j 0} {$j < $Ny} {incr j} {
				for {set k 0} {$k < $Nz} {incr k} {
					foreach x [$mol_sel get x] y [$mol_sel get y] z [$mol_sel get z] att [$mol_sel get $key] {
						lappend new_xyz [list [expr $x+$i*$Lx] [expr $y+$j*$Ly] [expr $z+$k*$Lz]]
						lappend new_att $att
						incr Natoms
					}
				}
			}
		}
		set new_mol [mol new atoms $Natoms]
		animate dup $new_mol
		set sel [atomselect $new_mol all]
		$sel set {x y z} $new_xyz
		$sel set $key $new_att
		mol bondsrecalc $new_mol
		mol rename $new_mol [concat [molinfo $molid get name]($Nx-$Ny-$Nz)]
		mol addrep $new_mol
		molinfo $new_mol set {a b c} [vecmul [list $Nx $Ny $Nz] [list $Lx $Ly $Lz]]
		mol top $new_mol
		display resetview
		pbc box -center bb -molid $new_mol
		dict set box_dict $new_mol 1
		set boxstate 1
		$sel delete
	}
	]

	grid .w1.frow4.n1.cr.fmaster.bcr -column 1 -row 2 -pady 10 -columnspan 6
	# END - Cell repeat - - - - - - - -  - -


	# Combine/Extract structure - - - - - - - -  - -
	ttk::frame 	.w1.frow4.n1.ms -relief sunken -padding 5
	.w1.frow4.n1 add .w1.frow4.n1.ms -text "Combine/Extract Molecule" -padding 2

	# Combine - - -
	ttk::labelframe .w1.frow4.n1.ms.fmix -text "Combine Molecule" -padding 5
	grid .w1.frow4.n1.ms.fmix -row 0 -column 0 -sticky w

	ttk::label  .w1.frow4.n1.ms.fmix.l1 -text "List of Molecules:"
	ttk::label  .w1.frow4.n1.ms.fmix.l2 -text ""
	ttk::button .w1.frow4.n1.ms.fmix.b1 -text Add -command [namespace code {
		if {[catch {molinfo $molid get id}]} {
			tk_messageBox -type ok -title "No molecule" -message "No molecule selected/Molecule deleted" -detail "Please select molecule again."
		} else {
			lappend merge_list $molid
			.w1.frow4.n1.ms.fmix.l2 configure -text "[.w1.frow4.n1.ms.fmix.l2 cget -text][.w1.f_ms.combo3 get]\n"
		}
	}
	]
	ttk::button .w1.frow4.n1.ms.fmix.b2 -text Combine	-command [namespace code {
		if {[llength $merge_list] != 0} {
			::TopoTools::mergemols $merge_list
			set new_mol [molinfo top]
			pbc box -center bb -molid $new_mol
			dict set box_dict $new_mol 1
			set boxstate 1
		} else {
			tk_messageBox -type ok -title "Empty list" -message "Add your molecule."
		}
	}
	]
	ttk::button .w1.frow4.n1.ms.fmix.b3 -text Reset	-command [namespace code {set merge_list {}; .w1.frow4.n1.ms.fmix.l2 configure -text ""}]

	grid .w1.frow4.n1.ms.fmix.l1 -row 1 -column 0 -sticky ne
	grid .w1.frow4.n1.ms.fmix.l2 -row 1 -column 1 -columnspan 3 -sticky w
	grid .w1.frow4.n1.ms.fmix.b1 -row 0 -column 1
	grid .w1.frow4.n1.ms.fmix.b2 -row 0 -column 2
	grid .w1.frow4.n1.ms.fmix.b3 -row 0 -column 3

	# Export - - -
	ttk::labelframe .w1.frow4.n1.ms.fexpr -text "Extract Part of Molecule" -padding 5
	grid .w1.frow4.n1.ms.fexpr -row 1 -column 0 -sticky new -padx 5

	ttk::label  .w1.frow4.n1.ms.fexpr.l1 -text "Selection: "
	ttk::entry  .w1.frow4.n1.ms.fexpr.e1 -textvariable ::vmdAssist::expkey
	ttk::button .w1.frow4.n1.ms.fexpr.b1 -text "Extract selection" -command [namespace code {
		::vmdAssist::mol_id_check
		if {[catch {set sel [atomselect $molid $expkey]}]} {
			.w1.frow4.n1.ms.fexpr.l2 configure -text "wrong entry for selection" -foreground red
		} else {
			if {[$sel num] == 0} {.w1.frow4.n1.ms.fexpr.l2 configure -text "nothing selected"; return 1}
			.w1.frow4.n1.ms.fexpr.l2 configure -text "Done!" -foreground darkgreen
			set new_mol [mol new atoms [$sel num]]
			animate dup $new_mol
			set name [string trim [molinfo $molid get name] "{}"]
			mol rename $new_mol "$name-extract"
			set new_sel [atomselect $new_mol all]
			$new_sel set $key [$sel get $key]
			$new_sel set {x y z} [$sel get {x y z}]
			mol bondsrecalc $new_mol
			mol addrep $new_mol
			molinfo $new_mol set {a b c} [molinfo $molid get {a b c}]
			mol top $new_mol
			display resetview
			pbc box -center bb -molid $new_mol
			dict set box_dict $new_mol 1
			set boxstate 1
			$sel delete; $new_sel delete
		}
	}
	]
	ttk::label  .w1.frow4.n1.ms.fexpr.l2 -text "- - -"

	grid .w1.frow4.n1.ms.fexpr.l1 			-column 2	-row 0		-padx 2 -pady 2	 -sticky e
	grid .w1.frow4.n1.ms.fexpr.e1 			-column 3	-row 0		-padx 2 -pady 2	 -sticky e
	grid .w1.frow4.n1.ms.fexpr.b1 			-column 4	-row 0		-padx 2 -pady 2	 -sticky e
	grid .w1.frow4.n1.ms.fexpr.l2 			-column 5	-row 0		-padx 2 -pady 2	 -sticky e
	# END - Combine/Extract structure - - - - - - - -  - -


	# LAMMPS Data File i/o - - - - - - - -  - -
	set style {atomic bond angle molecular charge full sphere auto}

	ttk::frame 	.w1.frow4.n1.io -relief sunken -padding 5
	.w1.frow4.n1 add .w1.frow4.n1.io -text "LAMMPS DataFile" -padding 2

	ttk::labelframe .w1.frow4.n1.io.fmaster -text "LAMMPS DataFile" -padding 5
	grid .w1.frow4.n1.io.fmaster -column 0 -row 0

	ttk::label		.w1.frow4.n1.io.fmaster.l1 -text "Open Dir:"
	ttk::entry		.w1.frow4.n1.io.fmaster.e1 -textvariable ::vmdAssist::in_data_dir -width 37
	ttk::button 	.w1.frow4.n1.io.fmaster.b1 -text "Browse" -command {set ::vmdAssist::in_data_dir [tk_getOpenFile -initialdir [pwd]  -filetypes {{{Text file} {.txt}  TEXT} {{All Files} * }} -title "Select LAMMPS data file"]}
	ttk::frame		.w1.frow4.n1.io.fmaster.f1
	ttk::label		.w1.frow4.n1.io.fmaster.f1.l2 -text "Atom Style:"
	ttk::combobox	.w1.frow4.n1.io.fmaster.f1.cb1 -textvariable ::vmdAssist::in_atom_style -values $style -state readonly -width 9
	.w1.frow4.n1.io.fmaster.f1.cb1 set auto
	ttk::button .w1.frow4.n1.io.fmaster.f1.b2 -text "Open" -command [namespace code {
		if {[file exists $in_data_dir]} {
			if {$in_atom_style == "auto"} {
				topo readlammpsdata $in_data_dir
			} else {
				topo readlammpsdata $in_data_dir $in_atom_style
			}
		} else {
			tk_messageBox -type ok -title "Err" -message "No file selected" -detail "Please select your LAMMPS data file."
		}
	}
	]

	grid .w1.frow4.n1.io.fmaster.l1		-column 0	-row 0 -sticky w
	grid .w1.frow4.n1.io.fmaster.e1		-column 1	-row 0 -sticky w
	grid .w1.frow4.n1.io.fmaster.b1		-column 2	-row 0 -sticky w

	grid .w1.frow4.n1.io.fmaster.f1		-column 0	-row 1 -columnspan 3 -sticky w
	grid .w1.frow4.n1.io.fmaster.f1.l2		-column 0	-row 0 -sticky w
	grid .w1.frow4.n1.io.fmaster.f1.cb1		-column 1	-row 0 -sticky w
	grid .w1.frow4.n1.io.fmaster.f1.b2		-column 2	-row 0 -sticky w

	ttk::separator .w1.frow4.n1.io.fmaster.sep1 -orient horizontal
	grid .w1.frow4.n1.io.fmaster.sep1 -column 0 -row 2 -columnspan 6 -sticky we -pady 2

	ttk::label .w1.frow4.n1.io.fmaster.l3 -text "Save Dir:"
	ttk::entry .w1.frow4.n1.io.fmaster.e2 -textvariable ::vmdAssist::out_data_dir -width 37
	ttk::button .w1.frow4.n1.io.fmaster.b3 -text "Browse" -command {set ::vmdAssist::out_data_dir [tk_getSaveFile -initialdir [pwd] -initialfile LAMMPS_data -defaultextension .txt -filetypes {{{Text file} {.txt}  TEXT} {{All Files} * }} -title "Save as LAMMPS data file"]}
	ttk::frame .w1.frow4.n1.io.fmaster.f2
	ttk::label .w1.frow4.n1.io.fmaster.f2.l4 -text "Atom Style:"
	ttk::combobox .w1.frow4.n1.io.fmaster.f2.cb2 -textvariable ::vmdAssist::out_atom_style -values $style -state readonly -width 9
	.w1.frow4.n1.io.fmaster.f2.cb2 set full
	ttk::button .w1.frow4.n1.io.fmaster.f2.b4 -text "Save" -command [namespace code {
		if {[file isdirectory [file dirname $out_data_dir]]} {
			if {$out_atom_style == "auto"} {topo writelammpsdata $out_data_dir} else {topo writelammpsdata $out_data_dir $out_atom_style}
		} else {
			tk_messageBox -type ok -title "Err" -message "Wrong path selected" -detail "Please select a path for your LAMMPS data file."
		}
	}
	]

	grid .w1.frow4.n1.io.fmaster.l3		-column 0	-row 3 -sticky w
	grid .w1.frow4.n1.io.fmaster.e2		-column 1	-row 3 -sticky w -columnspan 2
	grid .w1.frow4.n1.io.fmaster.b3		-column 2	-row 3 -sticky w

	grid .w1.frow4.n1.io.fmaster.f2		-column 0	-row 4 -columnspan 3 -sticky w
	grid .w1.frow4.n1.io.fmaster.f2.l4		-column 0	-row 0 -sticky w
	grid .w1.frow4.n1.io.fmaster.f2.cb2		-column 1	-row 0 -sticky w
	grid .w1.frow4.n1.io.fmaster.f2.b4		-column 2	-row 0 -sticky ws
	# END - LAMMPS Data File i/o - - - - - - - -  - -



}

# proc ----------------------------------------
proc ::vmdAssist::translate {mx my mz} {
	variable displace
	variable mol_sel
	::vmdAssist::mol_sel_check
	$mol_sel moveby [list [expr $mx*$displace] [expr $my*$displace] [expr $mz*$displace]]
}

proc ::vmdAssist::rotate {LoR} {
	variable mol_sel
	variable cor_x; variable cor_y; variable cor_z
	variable aor_x; variable aor_y; variable aor_z
	variable rot_theta
	::vmdAssist::mol_sel_check
	$mol_sel move [trans center [list $cor_x $cor_y $cor_z] axis [list $aor_x $aor_y $aor_z] [expr $LoR*$rot_theta]]
}

proc ::vmdAssist::mol_sel_check {} {
	variable mol_sel
	if {[catch {$mol_sel molid}]} {
		tk_messageBox -type ok -title "No molecule" -message "No molecule selected" -detail "Please select your molecule."
		return -level 2 1
	}
	return 0
}

proc ::vmdAssist::mol_id_check {} {
	variable molid
	if {[catch {molinfo $molid get id}]} {
		tk_messageBox -type ok -title "No molecule" -message "No molecule selected" -detail "Please select your molecule."
		return -level 2 1
	}
	return 0
}

proc ::vmdAssist::box_check {} {
	if {[.w1.frow3.n.bs.box.b1 invoke]} {.w1.frow3.n select 2; return -level 2 1}
}

proc ::vmdAssist::get_att {} {
	variable molid
	::vmdAssist::mol_id_check
	set sel [atomselect $molid "type [.w1.frow3.n.bs.em.combo1 get]"]
	set type_list {}
	foreach type [$sel get [.w1.frow3.n.bs.em.combo2 get]] {
		set add 1
		foreach item $type_list {if {$type == $item} {set add 0; break}}
		if {$add} {lappend type_list $type}
	}
	.w1.frow3.n.bs.em.l3 configure -text $type_list
	$sel delete
}

# this proc update aor field state
proc ::vmdAssist::update_aor {state} {
	.w1.frow3.n.trc.rot.f2.e4 configure -state $state
	.w1.frow3.n.trc.rot.f2.e5 configure -state $state
	.w1.frow3.n.trc.rot.f2.e6 configure -state $state
}

proc vmdAssist_gui {} {
	::vmdAssist::gui
	return $::vmdAssist::w
}


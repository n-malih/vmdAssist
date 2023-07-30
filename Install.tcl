if {[file isdirectory [file join [pwd] "vmdassist1.0"]]} {
    set path [file join [pwd] "vmdassist1.0"]
} elseif {[file isdirectory [file join [file dirname [info script]] "vmdassist1.0"]]} {
    set path [file join [file dirname [info script]] "vmdassist1.0"]
} else {
    puts "\"vmdassist1.0\" folder not found"
    return
}

if {$tcl_platform(platform) == "windows"} {
    if {[file exists [file join $env(HOME) "vmd.rc"]]} {
        set vmdrc_dir [file join $env(HOME) "vmd.rc"]
    } elseif {[file exists [file join $env(VMDDIR) "vmd.rc"]]} {
        set vmdrc_dir [file join $env(VMDDIR) "vmd.rc"]
    } else {
        puts "\"vmd.rc\" not found. Create a text file in \"$env(VMDDIR)\", rename it to \"vmd.rc\" and restart install program."
        return
    }
} else {
    if {[file exists [file join $env(HOME) ".vmdrc"]]} {
        set vmdrc_dir [file join $env(HOME) ".vmdrc"]
    } elseif {[file exists [file join $env(VMDDIR) ".vmdrc"]]} {
        set vmdrc_dir [file join $env(VMDDIR) ".vmdrc"]
    } else {
        puts "\".vmdrc\" not found. Create a text file in \"$env(VMDDIR)\", rename it to \".vmdrc\" and restart install program."
        return
    }
}

set vmdrc [open $vmdrc_dir a+]
puts $vmdrc "\n"
puts $vmdrc "lappend auto_path {$path}"
puts $vmdrc "\n"
puts $vmdrc {vmd_install_extension vmdAssist vmdAssist_gui "vmdAssist"}
puts $vmdrc "\n"
close $vmdrc

puts "vmdrc directory: $vmdrc_dir"
puts "All done successfully!\nRestart VMD. Next time you can find vmdAssist in Extensions menu"
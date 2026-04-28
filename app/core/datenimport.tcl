package require OZ
package require rl_json
set doc {"name":"Ali","age":30,"active":true}
set json dict{}
source C://Tcl/Projekt/datenimport/app/infrastructure/common.tcl
package require OZ::file::IniFile
package require OZ::file::ini_compat

#set f [OZ::file::IniFile C:\Tcl\Projekt\datenimport\config.ini]

# set f [IniFile::Open $::infrastructure::mandant_url]

# puts [ReadIni $f]

#puts [info object methods $f -all]
#set h [$f GetSection ProAlphaEarningsDriver]

#puts [info object methods $h -all]
#puts [$f Get wsExportClientList]
# set f [open $::infrastructure::mandant_url "r"]
# while {[gets $f line] >= 0} {
#     if {[regexp {^wsReleaseClientList} $line]} {
#         puts "FOUND: $line"
#         break
#     }
# }

# close $f
# regexp {^\s*wsReleaseClientList\s*=\s*(.*)$} $line -> value

# set numbers [split $value]
# puts $numbers

namespace eval  ::core::file {
    proc file_reader {file_path branche goal} {
        

    if {[catch {
            set f [IniFile::Open $file_path]
            set h [$f GetSection $branche]
            set value [$h Get $goal]
        } err]} {
            puts "INI read error: $err"
            return ""
        }

    return $value
    }
            
    proc mandant_finder {mandant_file} {
                set f [open $mandant_file "r"]

                while {[gets $f line] >= 0} {
                    if {[regexp {^\s*wsReleaseClientList\s*=} $line]} {
                        puts "FOUND: $line"
                        regexp {^\s*wsReleaseClientList\s*=\s*(.*)$} $line -> value
                        break
                    }
                }

                close $f
                set numbers [split $value]
                return $numbers
    }

    proc mandant_reader {file_path branche goal} {
        try {
            
            set mandant_number [::core::file::file_reader $file_path $branche $goal]

            if {$mandant_number eq ""} {

                return [::core::file::mandant_finder $::infrastructure::mandant_url]
            } else {
                return $mandant_number
            }
        }
        
        #::core::ini_reader $::infrastructure::config_url "request" "url"
    }


}
#set f [open $::infrastructure::mandant_url "r"]

puts [::core::file::file_reader $::infrastructure::config_url "request" "url"]
puts [::core::file::mandant_reader $::infrastructure::config_url "mandant" "m_ids"]


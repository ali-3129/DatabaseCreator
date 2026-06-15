set ::APP_ROOT [file normalize [file join [file dirname [info script]] ".."]]
set p [source [file join $::APP_ROOT "app" "core" "request.tcl"]]
source [file join $::APP_ROOT "core" "datenimport.tcl"]
source [file join $::APP_ROOT "infrastructure" "common.tcl"]
source [file join $::APP_ROOT "data" "model.tcl"]
source [file join $::APP_ROOT "core" "cleaner.tcl"]




proc run {url uniqueIdPath uniqueIdSuffix} {
    if {[catch {
        #set url [::core::file::file_reader $::infrastructure::config_url "request" "bestelldaten_url"]
        set mids [::core::file::mandant_reader $::infrastructure::config_url "mandant" "m_ids"]
        set db_path [::core::file::file_reader $::infrastructure::config_url "path" "datenbank_path"]
        set pre [::core::file::file_reader $::infrastructure::config_url "path" "datenban_prefix"]
        set db_pre_path [file normalize [file join $db_path $pre]]
        

        foreach mandant $mids {
           set url_with_id [::core::request::url_append $url $mandant]
           puts $url_with_id

            set end_path [file normalize [file join $db_pre_path "$mandant.db"]]
            puts $end_path
            set db [::database::openDB $end_path]
            puts $end_path
            if {[ catch { set value [::core::request::retry $url_with_id] 
                        set data [::http::data $value]
                        set records [::core::cleaner::extract_hash_records $data $uniqueIdPath $uniqueIdSuffix]
                        ::database::write $db $records
                        $db close
            } err]} {
                puts $err
            }
        }

    } err]} {
        puts "Run failed: $err"
        return ""
    }

}


proc main {} {
    set modus [::core::file::file_reader $::infrastructure::config_url "einstellung" "modus"]
    set uniqueIdSuffix ""
    switch $modus {
        WE {
                set url [::core::file::file_reader $::infrastructure::config_url "request" "we_url"]
                puts "$url"
                set uniqueIdPath {uniqueID}
                
                run $url $uniqueIdPath $uniqueIdSuffix
            }

            default {
                set url [::core::file::file_reader $::infrastructure::config_url "request" "bestelldaten_url"]
                puts $url
                set uniqueIdPath {head uniqueID}
                set uniqueIdSuffix "|EB"
                run $url $uniqueIdPath $uniqueIdSuffix
            }
        }
}

#main
#run
proc test_value {} {
    set f [open "C://Users/asghari/Desktop/web_call_we.txt" r ]
    set context [read $f]
    return $context
}

proc test {} {
    set value [test_value]
    set uniqueIdPath {uniqueID}
    set uniqueIdSuffix "|EB"

    set records [::core::cleaner::extract_hash_records $value $uniqueIdPath $uniqueIdSuffix]
    #set db [::database::openDB $::infrastructure::database_path_test]
    #::database::write $db $records
    #$db close
}

test

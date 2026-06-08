set ::APP_ROOT [file normalize [file join [file dirname [info script]] ".."]]
set p [source [file join $::APP_ROOT "app" "core" "request.tcl"]]
source [file join $::APP_ROOT "core" "datenimport.tcl"]
source [file join $::APP_ROOT "infrastructure" "common.tcl"]
source [file join $::APP_ROOT "data" "model.tcl"]
source [file join $::APP_ROOT "core" "cleaner.tcl"]

puts $p

proc run {} {
    if {[catch {
        set url [::core::file::file_reader $::infrastructure::config_url "request" "url"]
        set mids [::core::file::mandant_reader $::infrastructure::config_url "mandant" "m_ids"]
        

        set result [dict create]
        foreach mandant $mids {
           set uid [::core::request::url_append $url $mandant]
           puts $uid
            set uiid [::core::request::url_append $::infrastructure::database_path "$mandant.db"]
            set db [::database::openDB $uiid]
            puts $uiid
            if {[ catch { set value [::core::request::retry $uid] 
                        set data [::http::data $value]
                        set records [::core::cleaner::extract_hash_records $data]
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

#run
proc test_value {} {
    set f [open "C://Users/asghari/Desktop/web_call.txt" r ]
    set context [read $f]
    return $context
}

proc test {} {
    set value [test_value]
    set records [::core::cleaner::extract_hash_records $value]
    set db [::database::openDB $::infrastructure::database_path]
    ::database::write $db $records
    $db close
}

run

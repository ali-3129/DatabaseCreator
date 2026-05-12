set ::APP_ROOT [file normalize [file join [file dirname [info script]] ".."]]
set p [source [file join $::APP_ROOT "app" "core" "request.tcl"]]
source [file join $::APP_ROOT "core" "datenimport.tcl"]
source [file join $::APP_ROOT "infrastructure" "common.tcl"]
puts $p

proc run {} {
    if {[catch {
        set url [::core::file::file_reader $::infrastructure::config_url "request" "url"]
        set mids [::core::file::mandant_reader $::infrastructure::config_url "mandant" "m_ids"]
        set result [dict create]
        foreach mandant $mids {
           set uid [::core::request::url_append $url $mandant]
           puts $uid
            if {[ catch { set value [::core::request::retry $uid] 
                        set records [::core::request::text_cleaner $value]
                        dict set result $mandant $records
            } err]} {
                puts $err
            }
            
        }
        #set uid [::core::request::url_append $url $mids]
        #puts $uid
        # set cleaned_text [::core::request::fetch_all_records $uid]
        # puts $cleaned_text
    } err]} {
        puts "Run failed: $err"
        return ""
    }

    #return $cleaned_text
}

run
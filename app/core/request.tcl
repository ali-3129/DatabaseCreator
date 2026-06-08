# source C://Tcl/Projekt/datenimport/app/core/datenimport.tcl
# source C://Tcl/Projekt/datenimport/app/infrastructure/common.tcl
package require rl_json
package require http
set ::APP_ROOT [file normalize [file join [file dirname [info script]] ".."]]

source [file join $::APP_ROOT "core" "datenimport.tcl"]
source [file join $::APP_ROOT "infrastructure" "common.tcl"]
if {[llength [info commands json]] == 0} {namespace import ::rl_json::json}


namespace eval ::core::request {
    # Namespace body
    proc url_append {url mandant_id} {
        #set url [::core::file::file_reader $::infrastructure::config_url "request" "url"]
        set mandant_id [split $mandant_id]
        append url $mandant_id
        return $url
    }

    proc retry {url} {
        set try_rund 1
        while {$try_rund <= 3} {

            if {[catch {
                set value [::core::request::mandant_request $url]
                
            } err]} {
                puts $err
                puts "try : $try_rund faild"
                after 2000
                incr try_rund
                
            } else {
                return $value
                # ::core::request::text_cleaner [::http::data $value]
                break
            }
        }
        
    }

    proc mandant_request {url} {
        puts $url
        if {[catch { set value [::http::geturl $url]

        } err]} {
            error "http error: $err"
        }
        return $value
    }


}
# puts [::core::file::file_reader $::infrastructure::config_url "request" "url"]
# puts [::core::file::mandant_reader $::infrastructure::config_url "mandant" "m_ids"]
# ::core::request::url_append 100


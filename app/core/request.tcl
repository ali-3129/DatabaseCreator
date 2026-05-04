source C://Tcl/Projekt/datenimport/app/core/datenimport.tcl
source C://Tcl/Projekt/datenimport/app/infrastructure/common.tcl
package require rl_json
package require http

if {[llength [info commands json]] == 0} {namespace import ::rl_json::json}


namespace eval ::core::request {
    # Namespace body
    proc url_append {mandant_id} {
        set url [::core::file::file_reader $::infrastructure::config_url "request" "url"]
        append url $mandant_id
        ::core::request::retry $url
    }

    proc retry {url} {
        set try_rund 1
        while {$try_rund <= 3} {

            if {[catch {::core::request::mandant_request $url
                
            } err]} {
                puts $err
                puts "try : $try_rund faild"
                after 2000
                incr try_rund
                
            } else {
                break
            }
        }
        
    }

    proc mandant_request {url} {
        puts $url
        if {[catch { set value [::http::geturl $url]
            ::core::request::text_cleaner [::http::data $value]
        } err]} {
            error "http error: $err"
        }
    }

    proc text_cleaner {value} {
        set data [json get $value data]
        puts $data
        #puts $value
    }
}
puts [::core::file::file_reader $::infrastructure::config_url "request" "url"]
puts [::core::file::mandant_reader $::infrastructure::config_url "mandant" "m_ids"]
::core::request::url_append 100


source C://Tcl/Projekt/datenimport/app/core/datenimport.tcl
source C://Tcl/Projekt/datenimport/app/infrastructure/common.tcl



namespace eval ::core::request {
    # Namespace body
    
}
puts [::core::file::file_reader $::infrastructure::config_url "request" "url"]
puts [::core::file::mandant_reader $::infrastructure::config_url "mandant" "m_ids"]
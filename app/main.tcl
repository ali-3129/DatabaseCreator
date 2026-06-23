set ::APP_ROOT [file normalize [file join [file dirname [info script]] ".."]]
set p [source [file join $::APP_ROOT "app" "core" "request.tcl"]]
source [file join $::APP_ROOT "core" "datenimport.tcl"]
source [file join $::APP_ROOT "infrastructure" "common.tcl"]
source [file join $::APP_ROOT "data" "model.tcl"]
source [file join $::APP_ROOT "core" "cleaner.tcl"]




proc run {url uniqueIdPath uniqueIdSuffix} {
    set segment ""

    if {[catch {
        ::infrastructure::logger::info "Run started"

        set segment "read mandants"
        set mids [::core::file::mandant_reader \
            $::infrastructure::config_url \
            "mandant" \
            "m_ids"]

        ::infrastructure::logger::info "Loaded [llength $mids] mandants"

        set segment "read database path"
        set db_path [::core::file::file_reader \
            $::infrastructure::config_url \
            "path" \
            "datenbank_path"]

        set segment "read database prefix"
        set pre [::core::file::file_reader \
            $::infrastructure::config_url \
            "path" \
            "datenban_prefix"]

        set segment "build database base path"
        set db_pre_path [file normalize [file join $db_path $pre]]

        ::infrastructure::logger::info "Database base path: $db_pre_path"

        foreach mandant $mids {
            set db ""
            set value ""
            set mandantSegment ""

            if {[catch {
                set mandantSegment "build request url"
                set url_with_id [::core::request::url_append $url $mandant]

                set mandantSegment "build database path"
                set end_path [file normalize [file join $db_pre_path "$mandant.db"]]

                ::infrastructure::logger::info "Processing mandant=$mandant"
                ::infrastructure::logger::info "Request URL for mandant=$mandant: $url_with_id"
                ::infrastructure::logger::info "Database path for mandant=$mandant: $end_path"

                set mandantSegment "open database"
                set db [::database::openDB $end_path]

                set mandantSegment "send request"
                set value [::core::request::retry $url_with_id]

                set mandantSegment "read response body"
                set data [::http::data $value]

                ::infrastructure::logger::info "Response length for mandant=$mandant: [string length $data]"

                set mandantSegment "extract hash records"
                set records [::core::cleaner::extract_hash_records \
                    $data \
                    $uniqueIdPath \
                    $uniqueIdSuffix]

                ::infrastructure::logger::info "Extracted [llength $records] records for mandant=$mandant"

                set mandantSegment "write records to database"
                set result [::database::write $db $records]
                ::infrastructure::logger::info "Database write result for mandant=$mandant: $result"

                set mandantSegment "close database"
                $db close
                set db ""
                ::infrastructure::logger::info "Mandant=$mandant processed successfully"

            } err opts]} {
                ::infrastructure::logger::error "Mandant=$mandant failed during '$mandantSegment': $err"

                if {$db ne ""} {
                    catch {$db close}
                }

                continue
            }
        }

        ::infrastructure::logger::info "Run finished"
        ::infrastructure::logger::end

    } err opts]} {
        ::infrastructure::logger::error "Run failed during '$segment': $err"
        return ""
    }
}



proc main {} {
    set logger_path [::core::file::file_reader $::infrastructure::config_url "logger" "path"]
    set logger_prefix [::core::file::file_reader $::infrastructure::config_url "logger" "prefix"]
    set logger_pre_path [file normalize [file join $logger_path $logger_prefix]]
    set suffix [::core::file::file_reader $::infrastructure::config_url "logger" "suffix"]
    set logger_end_path [file normalize [file join $logger_pre_path $suffix]]
    puts $logger_end_path
    ::infrastructure::logger::setup $logger_end_path
    set modus [::core::file::file_reader $::infrastructure::config_url "einstellung" "modus"]
    
    set uniqueIdSuffix ""
    switch $modus {
        WE {
                set url [::core::file::file_reader $::infrastructure::config_url "request" "we_url"]
                puts "$url"
                set uniqueIdPath {uniqueID}
                ::infrastructure::logger::info "modus: Wareneingänge was selected"
                run $url $uniqueIdPath $uniqueIdSuffix
            }

            default {
                set url [::core::file::file_reader $::infrastructure::config_url "request" "bestelldaten_url"]
                puts $url
                set uniqueIdPath {head uniqueID}
                set uniqueIdSuffix "|EB"
                ::infrastructure::logger::info "modus: Bestellungsimport was selected"
                run $url $uniqueIdPath $uniqueIdSuffix
            }
        }
}

#main
run
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
    set db [::database::openDB $::infrastructure::database_path_test]
    ::database::write $db $records
    $db close
}

#test

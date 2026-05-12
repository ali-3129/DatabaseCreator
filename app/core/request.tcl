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

    proc text_cleaner {value} {
        set headTemplate [dict create \
            objectID "" \
            objectType "" \
            uniqueID "" \
            externalReferenceID "" \
            docType "" \
            createdDate "" \
            printedDate "" \
            transState "" \
            totalValue "" \
            shippingCondition "" \
            cashDiscount ""
        ]

        set positionTemplate [dict create \
            objectID "" \
            objectType "" \
            positionNo "" \
            itemID "" \
            itemText "" \
            addItemText "" \
            extOrderNumber "" \
            eanCode "" \
            itemDescription "" \
            quantity "" \
            unit "" \
            pricePerUnit "" \
            currency "" \
            net "" \
            total "" \
            purchasePricePointer ""
        ]

        set scheduleTemplate [dict create \
            objectID "" \
            desiredDeliveryDate "" \
            desiredDeliveryWeek "" \
            desiredQuantity ""
        ]

        set records {}
        set dataLen [json length $value data]

        for {set i 0} {$i < $dataLen} {incr i} {
            set headDict $headTemplate

            dict for {key _} $headTemplate {
                dict set headDict $key \
                    [json get -default "" $value data $i head $key]
            }

            set positions {}
            set posLen [json length $value data $i positions]

            for {set p 0} {$p < $posLen} {incr p} {
                set posDict $positionTemplate

                dict for {key _} $positionTemplate {
                    dict set posDict $key \
                        [json get -default "" $value data $i positions $p $key]
                }

                set schedules {}
                set schedLen [json length $value data $i positions $p deliverySchedules]

                for {set s 0} {$s < $schedLen} {incr s} {
                    set schedDict $scheduleTemplate

                    dict for {key _} $scheduleTemplate {
                        dict set schedDict $key \
                            [json get -default "" $value data $i positions $p deliverySchedules $s $key]
                    }

                    lappend schedules $schedDict
                }

                dict set posDict deliverySchedules $schedules
                lappend positions $posDict
            }

            set record [dict create \
                head $headDict \
                positions $positions \
            ]

            lappend records $record
        }
        puts [dict get $headTemplate uniqueID]
        return $records
    }
}
# puts [::core::file::file_reader $::infrastructure::config_url "request" "url"]
# puts [::core::file::mandant_reader $::infrastructure::config_url "mandant" "m_ids"]
# ::core::request::url_append 100


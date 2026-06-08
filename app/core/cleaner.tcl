package require rl_json

namespace eval ::core::cleaner {
    proc extract_hash_records {response} {
        set records {}
        set dataLen [json length $response data]

        for {set i 0} {$i < $dataLen} {incr i} {
            set uniqueID [json get -default "" $response data $i head uniqueID]
            puts $uniqueID
            set block    [json extract $response data $i]
            set hash     [sha2::sha256 -hex $block]

            lappend records [dict create \
                uniqueID $uniqueID \
                hash $hash \
            ]
        }

        return $records
    }

        # proc text_cleaner {value} {
    #     set headTemplate [dict create \
    #         objectID "" \
    #         objectType "" \
    #         uniqueID "" \
    #         externalReferenceID "" \
    #         docType "" \
    #         createdDate "" \
    #         printedDate "" \
    #         transState "" \
    #         totalValue "" \
    #         shippingCondition "" \
    #         cashDiscount ""
    #     ]

    #     set positionTemplate [dict create \
    #         objectID "" \
    #         objectType "" \
    #         positionNo "" \
    #         itemID "" \
    #         itemText "" \
    #         addItemText "" \
    #         extOrderNumber "" \
    #         eanCode "" \
    #         itemDescription "" \
    #         quantity "" \
    #         unit "" \
    #         pricePerUnit "" \
    #         currency "" \
    #         net "" \
    #         total "" \
    #         purchasePricePointer ""
    #     ]

    #     set scheduleTemplate [dict create \
    #         objectID "" \
    #         desiredDeliveryDate "" \
    #         desiredDeliveryWeek "" \
    #         desiredQuantity ""
    #     ]

    #     set records {}
    #     set dataLen [json length $value data]

    #     for {set i 0} {$i < $dataLen} {incr i} {
    #         set headDict $headTemplate

    #         dict for {key _} $headTemplate {
    #             dict set headDict $key \
    #                 [json get -default "" $value data $i head $key]
    #         }

    #         set positions {}
    #         set posLen [json length $value data $i positions]

    #         for {set p 0} {$p < $posLen} {incr p} {
    #             set posDict $positionTemplate

    #             dict for {key _} $positionTemplate {
    #                 dict set posDict $key \
    #                     [json get -default "" $value data $i positions $p $key]
    #             }

    #             set schedules {}
    #             set schedLen [json length $value data $i positions $p deliverySchedules]

    #             for {set s 0} {$s < $schedLen} {incr s} {
    #                 set schedDict $scheduleTemplate

    #                 dict for {key _} $scheduleTemplate {
    #                     dict set schedDict $key \
    #                         [json get -default "" $value data $i positions $p deliverySchedules $s $key]
    #                 }

    #                 lappend schedules $schedDict
    #             }

    #             dict set posDict deliverySchedules $schedules
    #             lappend positions $posDict
    #         }

    #         set record [dict create \
    #             head $headDict \
    #             positions $positions \
    #         ]

    #         lappend records $record
    #     }
    #     puts [dict get $headTemplate uniqueID]
    #     return $records
    # }
}

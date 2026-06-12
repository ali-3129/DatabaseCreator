namespace eval ::database {
    # Namespace body
    proc openDB {dbpath} {
        if {[catch {
            ::KeyDBInit $dbpath
            set db [::KeyDBOpen]
        } err ]} {
            puts $err
        }
        return $db
    }
    
    
    proc write {db records} {
        
        if {[catch {
            
            foreach record $records {
                set key [dict get $record uniqueID]
                set value [dict get $record hash]
                if {[$db exists $key]} {
                set oldHash [$db get $key]

                if {$oldHash ne $value} {
                    $db set $key $value
                    puts "Changed: $key"
                }
            } else {
                $db set $key $value
                puts "New: $key"
            }
                
            }
           
        } err ]} {
            puts $err
        }
    }
}


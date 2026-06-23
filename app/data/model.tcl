namespace eval ::database {
    # Namespace body
    proc openDB {dbpath} {
            ::KeyDBInit $dbpath
            set db [::KeyDBOpen]

        return $db
    }
    
    
    proc write {db records} {
        
        set change_counter 0
        set add_counter 0
            
        foreach record $records {
            
            set key [dict get $record uniqueID]
            set value [dict get $record hash]
            if {[$db exists $key]} {
            set oldHash [$db get $key]

            if {$oldHash ne $value} {
                $db set $key $value
                incr change_counter
                puts "Changed: $key"
            }
        } else {
            $db set $key $value
            puts "New: $key"
            incr add_counter 
        }
            
        }
        return "changed: $change_counter   new added : $add_counter"

    }
}


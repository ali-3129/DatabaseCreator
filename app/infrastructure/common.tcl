package require OZ::database::KeyDB
namespace eval ::infrastructure {
    # Namespace body
    set config_url [file normalize "./app/infrastructure/config.ini"]
    
    set database_path_test [file normalize "./test.db"]
    #::KeyDBInit $database_path

}

namespace eval ::infrastructure::logger {
    variable logHandle ""

    proc setup {logPath} {
        variable logHandle

        file mkdir [file dirname $logPath]
        set logHandle [open $logPath a]
        fconfigure $logHandle -buffering none -encoding utf-8
    }

    proc info {msg} {
        variable logHandle
        puts $logHandle "[clock format [clock seconds] -format {%Y-%m-%d %H:%M:%S}] INFO $msg"
    }

    proc error {msg} {
        variable logHandle
        puts $logHandle "[clock format [clock seconds] -format {%Y-%m-%d %H:%M:%S}] ERROR $msg"
    }

    proc end {} {
        variable logHandle
        puts $logHandle [string repeat "-" 100]
    }
}
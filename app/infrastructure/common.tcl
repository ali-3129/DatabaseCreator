package require OZ::database::KeyDB
namespace eval ::infrastructure {
    # Namespace body
    set config_url [file normalize "./app/infrastructure/config.ini"]
    
    set database_path_test [file normalize "./test.db"]
    #::KeyDBInit $database_path

}

package require OZ::database::KeyDB
namespace eval ::infrastructure {
    # Namespace body
    set config_url [file normalize "./app/infrastructure/config.ini"]
    set mandant_url "C://stratoz/solutions/REMPro/IntegrationPlatform/system/system.ini"

    set database_path "C:/Tcl/Projekt/datenimport/"
    ::KeyDBInit $database_path

}

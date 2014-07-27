##############################################################################
#
# Slack Functionality
# https://slack.com/
#
# @author Jason Roman <j@jayroman.com>
#
##############################################################################

# rest package also includes the http and json packages
package require rest
package require tls
package require json::write
package require yaml

# add https support
http::register https 443 ::tls::socket

# do not add newlines in json - keep it condensed
json::write indented 0

# define the slack namespace and all variables that must be defined and non-empty in config.yml
namespace eval slack {
    namespace eval incomingwebhook {
        variable url {}
        variable token {}
    }
}


# processes the configuration file for slack
proc ::slack::processConfig {} {

    global SlackbotScriptDir

    # load config.yml in the script's directory into the 'config' dictionary
    set config [yaml::yaml2dict -file [file join $SlackbotScriptDir config.yml]]

    # loop through each top level key in the config
    dict for {topLevelKey subDict} [dict get $config] {

        # now loop through each key/value pair of that key
        dict for {key value} [dict get $subDict] {

            # check if we previously defined this variable in our namespace declaration, and if so, set its value
            if {[info exists ::slack::${topLevelKey}::$key]} {
                set ::slack::${topLevelKey}::$key $value
            }
        }
    }

    # all namespace parameters must be defined with a non-empty value - exit if any are missing
    set missingKeys {}

    # loop through each sub-namespace here (::slack::*)
    foreach {subNamespaceName} [listns slack] {

        # loop through each declared variable in the namespace, and add any missing keys to the list of them
        foreach {key} [listnsvars $subNamespaceName] {

            if { [subst $$key] == "" } {
                lappend missingKeys $key
            }
        }
    }

    if { [llength $missingKeys] } {
        puts "Undefined configuration variables: \n[join $missingKeys \n]"
        exit
    }
}

::slack::processConfig

exit


set slack(push) {
    url $::slack::incomingwebhook::url
    method post
    static_args { token $::slack::incomingwebhook::token }
    req_args { payload: }
}

set slack(push) [subst $slack(push)]

rest::create_interface slack
##############################################################################
#
# Eggdrop Slackbot
#
# @author Jason Roman <j@jayroman.com>
#
##############################################################################

# get the directory of where this script is located
set SlackbotScriptDir [file dirname [info script]]

# load slack functionality
source [file join $SlackbotScriptDir utility.tcl]
source [file join $SlackbotScriptDir slack.tcl]

# listen for any and all text in the channel to forward
bind pubm - * pub_slackpush


# pushes a chat message to slack
proc pub_slackpush {nick mask hand channel args} {

    set msg [lindex $args 0]

    # if there is no mapping for this channel to slack, do not echo
    if { ![::slack::channel::mappingExists $channel] } {
        return 0
    }

    # if this is a bot command, do not echo
    if { [::slack::channel::isCommand $msg] } {
        return 0
    }

    # get the name of the task (everything after the command)
    #set txt [json::write string $msg]
    #set username [json::write string $nick]
    #set slackChannel [json::write string [::slack::channel::ircToSlack $channel]]
    set payload [
        json::write object
        "text" [json::write string $msg]
        username [json::write string $nick]
        channel [json::write string [::slack::channel::ircToSlack $channel]]
        unfurl_links [json::write string "true"]
    ]

    set result [slack::push -payload $payload]
}

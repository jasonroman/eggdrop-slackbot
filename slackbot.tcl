##############################################################################
#
# Eggdrop Slackbot - Simple Message Relay from IRC to Slack
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
    if {![::slack::channel::mappingExists $channel]} {
        return 0
    }

    # if this is a bot command, do not echo
    if {[::slack::channel::isCommand $msg]} {
        return 0
    }

    # set the JSON payload and push it to slack
    set payload [
        ::json::write object \
        text [json::write string "<$nick> $msg"] \
        username [json::write string $nick] \
        channel [json::write string [::slack::channel::ircToSlack $channel]] \
        unfurl_links [json::write string $::slack::webhook::unfurl_links]
    ]

    set result [slack::push -payload $payload]
}

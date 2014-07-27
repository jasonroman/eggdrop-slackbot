##############################################################################
#
# Eggdrop Slackbot
#
# @author Jason Roman <j@jayroman.com>
#
##############################################################################

# get the directory of where this script is located
set script_dir [file dirname [info script]]

# load slack functionality
source [file join $script_dir slack.tcl]

# listen for any and all text in the channel to forward
bind pubm - * pub_slackpush

# pushes a chat message to slack
proc pub_slackpush {nick mask hand channel args} {

    set message [lindex $args 0]

    if { $channel != "#PAPHPPeople" } {
        return 0
    }

    if { [string index $message 0] == "!" } {
        return 0
    }

    # get the name of the task (everything after the command)
    set text [json::write string $message]
    set username [json::write string $nick]
    set slack_channel [json::write string $channel]
    set payload [json::write object text $text username $username unfurl_links \"true\"]

    set result [slack::push -payload $payload]
}

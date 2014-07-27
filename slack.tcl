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

# add https support
http::register https 443 ::tls::socket 

set url "https://nabproduct.slack.com/services/hooks/incoming-webhook"
set token "T2qfDXSTlzELfPnJdAdsdZ5s"

set slack(push) {
    url $url
    method post
    static_args { token $token }
    req_args { payload: }
}

set slack(push) [subst $slack(push)]

rest::create_interface slack

json::write indented 0
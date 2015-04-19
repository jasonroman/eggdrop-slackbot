Eggdrop Slackbot - Simple Message Relay from IRC to Slack
================

This is an IRC Eggdrop Bot that interacts with [Slack](https://slack.com/).  It's purpose is to relay messages from channels in IRC to a corresponding channel or private group in Slack.  When could this situation even occur?  Say your company has an internal IRC behind a firewall that you can't access from your phone, but still want to see messages posted to it from your Slack app.  This would allow you to do so.  Or say DevOps has their own IRC server and posts messages to the **#aahhhfire** channel whenever a server goes down - you could automatically relay that message to Slack where you could see it immediately.

### Slack Setup

Go to your Slack Integrations and add an Incoming Webhook (if you are already using one this will be listed under the Configured Integrations tab instead of All Services).  Under* Integration Settings -> Post to Channel*, just select **#general** or any existing channel as the message relay will ignore this anyway.  Under Customize Name this similarly does not matter as the relay will be posting messages as IRC users instead of the name you give it.

The relevant field you will need for the bot setup is the Webhook URL.

### Eggdrop Setup

Set up your eggdrop bot as you normally would and load the slackbot script when the bot loads.  For example, in your eggdrop bot's .conf file you would add:

    source /path/to/your/eggdrop/slackbot.tcl

Now you must set up the bot's **config.yml**.  Take the Webhook URL from your Slack Setup and place it in the *url* variable of the *webhook* section:

    webhook:
        url:   https://hooks.slack.com/services/<therest/ofthe/path>

Now you must specify one or more channels to relay from IRC to Slack.  This supports public channels and private groups.  Let's relay messages to the two default Slack channels, **#general** and **#random**:

    channel:
        mapping:
            # format: <irc_channel>: <slack_channel>
            "#lounge": "#general"
            "#random": "#random"

In this example, any message posted to **#lounge** on IRC will then be posted to **#general** in Slack.  As an example,  if I am logged into IRC as "jroman" in the channel **lounge** and type the message *Whoa! I'm posting this from IRC!*, the following will be posted in Slack's **#general** channel:

![example](https://raw.githubusercontent.com/jasonroman/eggdrop-slackbot/master/example.png)

Notice how it ignores the Slack Integration's Customize Name setting and uses the name of IRC user.  The Warthog icon is something that I configured in the Slack bot and will always show up, along with the *BOT* text next to the username.

The **#** is required when specifying the IRC channel, but you may include or exclude it when specifying the Slack channel (this is true for both public channels and private groups, even though Slack does not show **#** for private groups).

One other feature is the ability to not relay bot commands.  For instance, your eggdrop bot might support commands that start with ***** or **!**, like ***quote** or **!thetime**, and you may not want that command or its results to show up in Slack.  You can ignore messages that begin with one or more prefixes by specifying them in your config file.  For the situation above, you would specify it as:

    channel:
        command_prefix: "!, *"

Enjoy!
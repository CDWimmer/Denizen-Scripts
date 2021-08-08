# |   _                               _____ _   _ _____
# |  | |             v 1.0           |  __ \ | | |_   _|
# |  | |__   ___  _ __ ___   ___  ___| |  \/ | | | | |
# |  | '_ \ / _ \| '_ ` _ \ / _ \/ __| | __| | | | | |
# |  | | | | (_) | | | | | |  __/\__ \ |_\ \ |_| |_| |_
# |  |_| |_|\___/|_| |_| |_|\___||___/\____/\___/ \___/
# |        Essentials/EssentialsX Home Importer
#
# @author Ch4rl1e
# @date 2021/08/07
# @denizen-build 5677-DEV
# @script-version 1

essentials_home_import_command:
    type: command
    debug: false
    name: homesguiessentialsimport
    usage: /homesguiessentialsimport (name/all)
    description: Import all player's Essentials homes into homesGUI
    permission: homesgui.essentials.import
    script:
    - if <context.args.size> >= 1:
        - define playercount 0
        - define homecount 0
        - if <context.args.get[1]> == all:
            - narrate "Importing the homes of everyone whos logged in within 1 year. This might take a hot minute."
            - foreach <server.players> as:importedplayer:
                - if <[importedplayer].last_played_time.is_after[<util.time_now.sub[365d]>]>:
                    - narrate "<yellow>Importing <[importedplayer].name>."
                    - define playercount:++
                    - foreach <[importedplayer].essentials_homes> key:homename as:homelocation:
                        - flag <[importedplayer]> homesgui_homes.<[homename]>:<[homelocation]>
                        - define homecount:++
        - else:
            - define targetplayer <server.match_offline_player[<context.args.get[1]>]>
            - if !<[targetplayer].exists>:
                - narrate "<red>Couldn't find a player with a matching name."
                - stop
            - narrate "Importing <player.name>'s homes..."
            - define playercount:++
            - foreach <[targetplayer].essentials_homes> key:homename as:homelocation:
                - flag <[targetplayer]> homesgui_homes.<[homename]>:<[homelocation]>
                - define homecount:++
        - narrate "<yellow>Imported <[homecount]> homes from <[playercount]> players."
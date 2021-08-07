ess_homes_gui_command:
    type: command
    name: esshomesgui
    debug: false
    usage: /esshomesgui
    description: Opens the GUI to browse your Essentials homes, as set with /sethome
    permission: commands.homes_gui
    script:
    - inventory open d:ess_homes_gui

ess_homes_gui:
    type: inventory
    debug: false
    inventory: chest
    title: "<red><bold>Homes Teleport Menu"
    gui: true
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] [quit_button]
    procedural items:
    - define list <list>
    # go through all of a player's essentials homes and generate items for each.
    - foreach <player.essentials_homes> key:homename as:homelocation:
        - define item <item[home_button].with_flag[homeloc:<[homelocation]>]>
        - define roundlocation <[homelocation].round_to[1]>
        - adjust def:item display:<blue><[homename]>
        - adjust def:item "lore:Click to teleport to <light_purple><[homename]>!<n><gray>(<[roundlocation].x>, <[roundlocation].y>, <[roundlocation].z>) in <[roundlocation].world.name>"
        - define list:->:<[item]>
    # Add a button for player's bed as essentials doesn't provide it above:
    - define item <item[home_button].with_flag[homeloc:bed]>
    - adjust def:item display:<blue>Bed
    - adjust def:item material:green_bed
    - adjust def:item "lore:Click to teleport to your bed!<n><dark_gray>(If you have a bed)"
    - define list:->:<[item]>
    - repeat 27:
        - define list:->:<item[blank_button]>

    # return items
    - determine <[list]>

ess_homes_gui_script:
    debug: false
    type: world
    events:
        after player clicks quit_button in ess_homes_gui:
        - inventory close
        after player clicks home_button in ess_homes_gui:
        # - narrate "Teleporting you to <context.item.display>"
        # essentials narrates this already
        - if <context.item.flag[homeloc]> == bed:
            - execute as_player "essentials:home bed"
        - else:
            - narrate "<yellow>Teleporting you to <gold><context.item.display>"
            - execute as_op "essentials:tppos <context.item.flag[homeloc].round.xyz.replace_text[,].with[ ]> <player.location.yaw> <player.location.pitch> <context.item.flag[homeloc].world.name>" silent:true

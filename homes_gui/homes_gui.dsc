# Todos:
# | make bed home verify a bed is actually next to your bed home spawn location
# | "are you sure?" step for deleting homes?
# | Implement moar permissions
# | maybe: set max homes per group
# | less bad

# |   _                               _____ _   _ _____
# |  | |             v 1.1           |  __ \ | | |_   _|
# |  | |__   ___  _ __ ___   ___  ___| |  \/ | | | | |
# |  | '_ \ / _ \| '_ ` _ \ / _ \/ __| | __| | | | | |
# |  | | | | (_) | | | | | |  __/\__ \ |_\ \ |_| |_| |_
# |  |_| |_|\___/|_| |_| |_|\___||___/\____/\___/ \___/
# |   the second worst thing to happen to those orphans
#
# @author Ch4rl1e
# @date 2021/08/07
# @denizen-build 5677-DEV
# @script-version 1.1

# ----------------------- Commands

homes_gui_list_command:
    type: command
    name: homes
    debug: false
    usage: /homes
    description: Opens the GUI to browse your homes, as set with /sethome
    permission: <script[homes_gui_config].data_key[open_gui_permission]>
    script:
    - if !<player.has_flag[homesgui_page]>:
        - flag <player> homesgui_page:1
    - inventory open d:homes_list_gui

homes_gui_text_command:
    type: command
    name: listhomes
    debug: false
    usage: /listhomes
    description: Lists your homes in the chat.
    permission: <script[homes_gui_config].data_key[open_gui_permission]>
    script:
    - define homenames <player.flag[homesgui_homes].keys>
    - if <player.bed_spawn.exists>:
        - define homenames:->:bed
    - narrate "<yellow>Homes: <gold><[homenames].formatted><yellow>."

homes_gui_sethome_command:
    type: command
    name: sethome
    debug: false
    usage: /sethome (name)
    description: Set or overwrite a home to your current location.
    permission: <script[homes_gui_config].data_key[create_homes_permission]>
    script:
    # define the name of the home, default to "home" if no name provided
    - if <context.args.size> >= 1:
        - define newhomename <context.args.get[1]>
        - if <[newhomename].to_lowercase> == bed:
            - narrate "<red>Cannot set a home named 'bed'! This name is reserved for your bed respawn point."
    - else:
        - define newhomename home
    # fetch the max homes limit from config
    - define homesmax <script[homes_gui_config].data_key[homesmax]>
    # If the play has the limit or more homes set, AND the new home doesn't match an existing home, test for bypass perm or op
    - if <player.flag[homesgui_homes].size> >= <[homesmax]> && !<player.flag[homesgui_homes].keys.contains[<[newhomename]>]>:
        - if <player.has_permission[<script[homes_gui_config].data_key[homesmax_bypass_permission]>]> || <player.is_op>:
            - flag <player> homesgui_homes.<[newhomename]>:<player.location>
        - else:
            - narrate "<red>You already have the maximum of <gold><[homesmax]><red> homes set, either delete or reuse an existing home!"
            - stop
    - else:
        - flag <player> homesgui_homes.<[newhomename]>:<player.location>
    - narrate "<yellow>Set your home named <gold><[newhomename]><yellow> to your current location."

homes_gui_delhome_command:
    type: command
    name: delhome
    debug: false
    usage: /delhome (name)
    description: Deletes a saved home.
    permission: <script[homes_gui_config].data_key[delete_homes_permission]>
    tab completions:
        1: <player.flag[homesgui_homes].keys>
    script:
    - if <context.args.size> >= 1:
        - define homename <context.args.get[1]>
    - else:
        - define homename home
    - if <player.has_flag[homesgui_homes]>:
        - if <player.flag[homesgui_homes].keys.contains[<[homename]>]>:
            - flag <player> homesgui_homes.<[homename]>:!
            - narrate "<yellow>Deleted home <gold><[homename]><yellow>."
        - else:
            - narrate "<red>Nothing to delete, have no home named <gold><[homename]><red>!"
    - else:
        - narrate "<red>Nothing to delete, you haven't set any homes yet!"

homes_gui_home_command:
    type: command
    name: home
    debug: false
    usage: /home (name)
    description: teleport home!
    permission: <script[homes_gui_config].data_key[home_teleport_permission]>
    tab completions:
        1: <player.flag[homesgui_homes].keys>
    script:
    - if <context.args.size> >= 1:
        - define homename <context.args.get[1]>
    - else:
        - define homename home
    - if <player.has_flag[homesgui_homes]> && <player.flag[homesgui_homes].keys.contains[<[homename]>]>:
        - inject homes_gui_teleport_delay
        - narrate "<yellow>Teleporting to home <gold><[homename]><yellow>..."
        - teleport <player> <player.flag[homesgui_homes].get[<[homename]>]>
    - else:
        - narrate "<red>Cannot teleport: No home named <yellow><[homename]><red>!"

# ------------------------ GUIs

homes_list_gui:
    type: inventory
    debug: false
    inventory: chest
    title: "<bold>Homes Teleport Menu"
    gui: true
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [home_delete_menu_button] [blank_black_button] [blank_black_button] [blank_black_button] [blank_black_button] [blank_black_button] [blank_black_button] [blank_black_button] [quit_button]
    procedural items:
    - inject homes_gui_list_menu_procedural_task
    # return items
    - determine <[list]>

homes_delete_gui:
    type: inventory
    debug: false
    inventory: chest
    title: "<bold>Homes Delete Menu"
    gui: true
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [home_delete_menu_exit_button] [blank_black_button] [blank_black_button] [blank_black_button] [blank_black_button] [blank_black_button] [blank_black_button] [blank_black_button] [quit_button]
    procedural items:
    - inject homes_gui_delete_menu_procedural_task
    # return items
    - determine <[list]>

homes_gui_list_menu_procedural_task:
    type: task
    debug: false
    script:
    - define list <list>
    - define homes <list>
    - if <player.flag[homesgui_homes].is_empty.if_null[true]>:
        # if player has no homes set
        - define homes:->:<item[empty_button]>
    - else:
        # generate items for all the player's homes
        - foreach <player.flag[homesgui_homes]> key:homename as:homelocation:
            - define item <item[home_button].with_flag[homeloc:<[homelocation]>].with_flag[homename:<[homename]>]>
            - define roundlocation <[homelocation].round_to[1]>
            - adjust def:item display:<blue><[homename]>
            - adjust def:item "lore:Click to teleport to <light_purple><[homename]><reset>!<n><gray>(<[roundlocation].x>, <[roundlocation].y>, <[roundlocation].z>)"
            - define homes:->:<[item]>
    # generate item for bed spawn in this world, if it exists
    - if <player.bed_spawn.exists>:
        - define item <item[home_button].with_flag[homeloc:<player.bed_spawn>].with_flag[homename:bed]>
        - adjust def:item display:<blue>Bed
        - adjust def:item material:blue_bed
        - adjust def:item "lore:Click to teleport to your bed in this world!"
        - define homes:->:<[item]>
    # == pagination == todo: this could be its own task given its near identical to delete's pagination section
    # create controls row for pages
    - repeat 9:
        - define page_controls:->:<item[blank_black_button]>
    - if <player.flag[homesgui_page]> > 1:
        # previous page button
        - define page_controls[1]:<item[homes_gui_arrow_left_item]>
    - if <[homes].size> > <player.flag[homesgui_page].mul[9]>:
        # add the right arrow if needed
        - define page_controls[9]:<item[homes_gui_arrow_right_item]>
    - define list:|:<[page_controls]>
    # get the page of homes items and add them to the list
    - define thispage <[homes].get[<player.flag[homesgui_page].sub[1].mul[9].max[1]>].to[<player.flag[homesgui_page].mul[9]>]>
    # pad the middle if its not full
    - repeat <element[9].sub[<[thispage].size>]>:
        - define thispage:->:<item[blank_button]>
    - define list:|:<[thispage]>

homes_gui_delete_menu_procedural_task:
    type: task
    debug: false
    script:
    - if !<player.has_flag[homesgui_page]>:
        - flag <player> homesgui_page:1
    - define list <list>
    - define homes <list>
    - if <player.flag[homesgui_homes].is_empty.if_null[true]>:
        # if player has no homes set
        - define homes:->:<item[empty_button]>
    - else:
        # generate items for all the player's homes, and their bed if it exists
        - foreach <player.flag[homesgui_homes]> key:homename as:homelocation:
            - define item <item[home_delete_button].with_flag[homeloc:<[homelocation]>].with_flag[homename:<[homename]>]>
            - define roundlocation <[homelocation].round_to[1]>
            - adjust def:item display:<blue><[homename]>
            - adjust def:item "lore:Click to <red><bold>delete<reset> home <light_purple><[homename]>!<n><gray>(<[roundlocation].x>, <[roundlocation].y>, <[roundlocation].z>)"
            - define homes:->:<[item]>
    # == pagination ==
    # create controls row for pages
    - repeat 9:
        - define page_controls:->:<item[blank_black_button]>
    - if <player.flag[homesgui_page]> > 1:
        # previous page button if needed
        - define page_controls[1]:<item[homes_gui_arrow_left_item]>
    - if <[homes].size> > <player.flag[homesgui_page].mul[9]>:
        # add the right arrow if needed
        - define page_controls[9]:<item[homes_gui_arrow_right_item]>
    - define list:|:<[page_controls]>
    # build a page of home items (max 9)
    - define thispage:<[homes].get[<player.flag[homesgui_page].sub[1].mul[9].max[1]>].to[<player.flag[homesgui_page].mul[9]>]>
    # pad the rest of the row if its not full
    - repeat <element[9].sub[<[thispage].size>]>:
        - define thispage:->:<item[blank_button]>
    - define list:|:<[thispage]>

# -------------------------- Teleport Delay Handler

homes_gui_teleport_delay:
    type: task
    debug: false
    script:
    - if !<player.has_permission[<script[homes_gui_config].data_key[teleport_delay_bypass_permission]>]>:
        - narrate "<yellow>Teleporting in <gold><script[homes_gui_config].data_key[teleport_delay]><yellow> seconds, stand still."
        - define Location <player.location.block>
        - repeat <script[homes_gui_config].data_key[teleport_delay]>:
            - if <player.location.block> != <[Location]>:
                - narrate "<red>Teleportation has been cancelled as you have moved!"
                - stop
            - wait 1s

# ---------------------------- Events

homes_gui_events_script:
    debug: false
    type: world
    events:
        after player clicks quit_button in homes_list_gui:
        - inventory close
        after player clicks home_button in homes_list_gui:
        - narrate "<yellow>Teleporting you to <gold><context.item.flag[homename]><yellow>."
        - inject homes_gui_teleport_delay
        - if <context.item.flag[homeloc]> == bed:
            - teleport <player> <player.bed_spawn>
        - else:
            - teleport <player> <context.item.flag[homeloc]>
        after player clicks home_delete_menu_button in homes_list_gui:
        - inventory open d:homes_delete_gui
        after player clicks home_delete_button in homes_delete_gui:
        - narrate "<red>Deleted home <gold><context.item.flag[homename]><red>."
        - flag <player> homesgui_homes.<context.item.flag[homename]>:!
        - inventory open d:homes_delete_gui
        after player clicks quit_button in homes_delete_gui:
        - inventory close
        after player clicks home_delete_menu_exit_button in homes_delete_gui:
        - inventory open d:homes_list_gui
        after player clicks homes_gui_arrow_left_item in homes_list_gui:
        - flag <player> homesgui_page:-:1
        - inventory open d:homes_list_gui
        after player clicks homes_gui_arrow_left_item in homes_delete_gui:
        - flag <player> homesgui_page:-:1
        - inventory open d:homes_delete_gui
        after player clicks homes_gui_arrow_right_item in homes_list_gui:
        - flag <player> homesgui_page:+:1
        - inventory open d:homes_list_gui
        after player clicks homes_gui_arrow_right_item in homes_delete_gui:
        - flag <player> homesgui_page:+:1
        - inventory open d:homes_delete_gui
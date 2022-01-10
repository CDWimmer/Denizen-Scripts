homes_gui_config:
    type: data
    debug: false
    # The maximum number of homes a player can have
    homesmax: 4
    # The permission that allows a player to ignore the maximum number of homes
    homesmax_bypass_permission: homesgui.bypass.no_max
    # Number of seconds a player must stand still before they teleport
    teleport_delay: 3
    # The permission node to allow a player to bypass the teleport delay
    teleport_delay_bypass_permission: homesgui.bypass.delay
    # - The following commented lines are not implemented. Modify the main permission lines in homes_gui.dsc for their related commands.
    # # The permssion to actually create homes
    # create_homes_permission: homesgui.homes.create
    # # Delete home permission
    # delete_homes_permission: homesgui.homes.delete
    # # open guis/list permission
    # open_gui_permission: homesgui.homes.list
    # # teleport home permission
    # home_teleport_permission: homesgui.homes.tp
    # - The following commented lines relate to commands that are not yet implemented.
    # # teleport to other people's homes permission
    # home_teleport_other_permission: homesgui.other.tp
    # # delete other people's homes permission
    # delete_homes_other_permission: homesgui.other.delete

    # No permission message
    no_perm_message: <red>You don't have permission to do that!
    # TODO(implement this)Range in blocks to search for a bed when checking for bed spawn validity:
    bed_validation_range: 1.2
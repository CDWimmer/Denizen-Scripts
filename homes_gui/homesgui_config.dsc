homes_gui_config:
    type: data
    debug: false
    # The maximum number of homes a player can have
    homesmax: 4
    # The permission that allows a player to ignore the maximum number of homes
    homesmax_bypass_permission: homesgui.no_max
    # Number of seconds a player must stand still before they teleport
    teleport_delay: 3
    # The permission node to allow a player to bypass the teleport delay
    teleport_delay_bypass_permission: homesgui.teleport.delay.bypass
    # The permssion to actually create homes
    create_homes_permission: homesgui.homes.create
    # Delete home permission
    delete_homes_permission: homesgui.homes.delete
    # delete other people's homes permission
    delete_homes_other_permission: homesgui.homes.delete.other
    # teleport home permission
    home_teleport_permission: homesgui.homes.tp
    # teleport to other people's homes permission
    home_teleport_other_permission: homesgui.homes.tp.other
    # open guis permission
    open_gui_permission: homesgui.gui
    # No permission message
    no_perm_message: <red>You don't have permission to do that!
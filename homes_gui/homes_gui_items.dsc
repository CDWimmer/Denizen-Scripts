quit_button:
    debug: false
    type: item
    material: barrier
    display name: <red>Cancel
    lore:
    - Exit this menu.

home_button:
    debug: false
    type: item
    material: white_bed
    display name: <blue>Bed
    lore:
    - If you're reading this, no you didn't<n>(Please report this to admin.)
    flags:
    # some default so it doesn't totally break under some bizarre circumstance. Shouldn't ever happen but you never know.
        homeloc: <location[0,0,0]>
        bed: false
        homename: bed

home_delete_button:
    debug: false
    type: item
    material: white_bed
    display name: <blue>Bed
    lore:
    - If you're reading this, no you didn't<n>(Please report this to admin.)
    flags:
        homeloc: false
        homename: bed

empty_button:
    debug: false
    type: item
    material: red_wool
    display name: <red>No homes
    lore:
    - You have not set any homes yet!

blank_button:
    debug: false
    type: item
    material: gray_stained_glass_pane
    display name: " "
    lore:
    - " "

blank_black_button:
    debug: false
    type: item
    material: black_stained_glass_pane
    display name: " "
    lore:
    - " "

home_delete_menu_button:
    debug: false
    type: item
    material: flint_and_steel
    display name: <red><bold>Delete mode
    lore:
    - Switch to delete mode

home_delete_menu_exit_button:
    debug: false
    type: item
    material: arrow
    display name: <green>Back
    lore:
    - Back to homes menu

homes_gui_arrow_left_item:
    type: item
    material: player_head
    display name: Previous Page
    mechanisms:
        skull_skin: 6d9cb85a-2b76-4e1f-bccc-941978fd4de0|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTE4NWM5N2RiYjgzNTNkZTY1MjY5OGQyNGI2NDMyN2I3OTNhM2YzMmE5OGJlNjdiNzE5ZmJlZGFiMzVlIn19fQ==


homes_gui_arrow_right_item:
    type: item
    material: player_head
    display name: Next Page
    mechanisms:
        skull_skin: 3cd9b7a3-c8bc-4a05-8cb9-0b6d4673bca9|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMzFjMGVkZWRkNzExNWZjMWIyM2Q1MWNlOTY2MzU4YjI3MTk1ZGFmMjZlYmI2ZTQ1YTY2YzM0YzY5YzM0MDkxIn19fQ

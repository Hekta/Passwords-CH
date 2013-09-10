
proc('_store_password', @player, @password,
    store_value(concat('passwords.', to_lower(@player)), bcrypt(@password))
)

proc('_clear_password', @player,
    clear_value(concat('passwords.', to_lower(@player)))
)

proc('_purge_passwords',
    assign(@players, array())
    assign(@limit, multiply(1000, 60, 60, 24, import('passwords.config')['max-inactivity']))
    foreach(get_offline_players(), @player,
        if(and(_phas_password(@player), gt(subtract(time(), plast_played(@player)), @limit)),
            array_push(@players, @player)
            if(_pis_locked(@player), _unlock_player(@player))
            _clear_password(@player)
        )
    )
    return(@players)
)

proc('_phas_password', @player,
    return(has_value(concat('passwords.', to_lower(@player))))
)

proc('_check_password', @player, @test,
    return(check_bcrypt(@test, get_value(concat('passwords.', to_lower(@player)))))
)

proc('_lock_player', @player,
    assign(@location, ploc(@player))
    export(concat('players.', @player, '.passwords.isLocked'), true)

    assign(@taskIDs, array())
    if(import('passwords.config')['password-required'],
        array_push(@taskIDs,
            set_interval(10000, 0,
                closure(@player,
                    if(_phas_password(@player),
                        tmsg(@player, concat(color('c'), 'You must confirm your identity with the /login command to play on the server.')),
                        tmsg(@player, concat(color('c'), 'You need to register a password to play on this server, use the /register command for this.'))
                    )
                )
            )
        ),
        array_push(@taskIDs,
            set_interval(10000, 0,
                closure(@player,
                    tmsg(@player, concat(color('c'), 'You have a password, you must confirm your identity with the /login command to play on the server.'))
                )
            )
        )
    )
    if(gt(import('passwords.config')['time-limit'], 0), array_push(@taskIDs, set_timeout(multiply(import('passwords.config')['time-limit'], 1000), closure(@player, pkick(@player, concat(color('c'), 'You took too long to authenticate you.'))))))
    export(concat('players.', @player, 'passwords.taskIDs'), @taskIDs)

    bind('entity_damage', associative_array('id': concat('passwords_entityDamage_', @player), 'priority': 'highest'), null, @event, @player,
        ifelse(
            and(equals(@event['type'], 'PLAYER'), equals(@event['player'], @player)),
            cancel() consume(),
            and(array_index_exists(@event, 'shooter'), equals(@event['shooter'], @player)),
            cancel() tmsg(@player, concat(color('c'), 'You are not authenticated!')) consume(),
            and(array_index_exists(@event, 'damager'), equals(@event['damager'], @player)),
            cancel() tmsg(@player, concat(color('c'), 'You are not authenticated!')) consume(),
        )
    )
    bind('exp_change', associative_array('id': concat('passwords_expChange_', @player), 'priority': 'highest'), associative_array('player': @player), @event,
        cancel() consume()
    )
    bind('inventory_click', associative_array('id': concat('passwords_inventoryClick_', @player), 'priority': 'highest'), null, @event, @player,
        if(equals(@event['player'], @player), cancel() tmsg(@player, concat(color('c'), 'You are not authenticated!')) consume())
    )
    bind('item_drop', associative_array('id': concat('passwords_itemDrop_', @player), 'priority': 'highest'), associative_array('player': @player), @event,
        cancel() tmsg(@event['player'], concat(color('c'), 'You are not authenticated!')) consume()
    )
    bind('item_pickup', associative_array('id': concat('passwords_itemPickup_', @player), 'priority': 'highest'), associative_array('player': @player), @event,
        cancel() consume()
    )
    bind('player_chat', associative_array('id': concat('passwords_playerChat_', @player), 'priority': 'highest'), associative_array('player': @player), @event,
        cancel() tmsg(@event['player'], concat(color(c), 'You are not authenticated!')) consume()
    )
    bind('player_command', associative_array('id': concat('passwords_playerCommand_', @player), 'priority': 'highest'), associative_array('player': @player), @event,
        if(not(array_contains_ic(array('/login', '/register'), @event['prefix'])),
            cancel() tmsg(@event['player'], concat(color('c'), 'You are not authenticated!')) consume()
        )
    )
    bind('player_interact', associative_array('id': concat('passwords_playerInteract_', @player), 'priority': 'highest'), associative_array('player': @player), @event,
        cancel() consume()
    )
    bind('player_interact_entity', associative_array('id': concat('passwords_playerInteractEntity_', @player), 'priority': 'highest'), associative_array('player': @player), @event,
        cancel() tmsg(@event['player'], concat(color('c'), 'You are not authenticated!')) consume()
    )
    bind('player_move', associative_array('id': concat('passwords_playerMove_', @player), 'priority': 'highest'), associative_array('player': @player, 'threshold': 1), @event, @location,
        set_ploc(@event['player'], @location) consume()
    )
    bind('pressure_plate_activated', associative_array('id': concat('passwords_pressurePlateActivated_', @player), 'priority': 'highest'), null, @event, @player,
        if(equals(@event['player'], @player), cancel() consume())
    )
    bind('target_player', associative_array('id': concat('passwords_targetPlayer_', @player), 'priority': 'highest'), associative_array('player': @player), @event,
        cancel() consume()
    )

    export(concat('players.', @player, '.passwords.hasFlight'), phas_flight(@player))
    set_pflight(@player, true)

    export(concat('players.', @player, '.passwords.attempts'), 0)
)

proc('_unlock_player', @player,
    assign(@taskIDs, import(concat('players.', @player, 'passwords.taskIDs')))
    if(is_array(@taskIDs), foreach(@taskIDs, @taskID, clear_task(@taskID)))
    export(concat('players.', @player, 'passwords.taskIDs'), null)

    foreach(array('entityDamage', 'expChange', 'inventoryClick', 'itemDrop', 'itemPickup', 'playerChat', 'playerCommand', 'playerInteract', 'playerInteractEntity', 'playerMove', 'pressurePlateActivated', 'targetPlayer'), @eventName,
        unbind(concat('passwords_', @eventName, '_', @player))
    )

    set_pflight(@player, import(concat('players.', @player, '.passwords.hasFlight')))
    export(concat('players.', @player, '.passwords.hasFlight'), null)

    export(concat('players.', @player, '.passwords.attempts'), 0)

    export(concat('players.', @player, '.passwords.isLocked'), null)
)

proc('_pis_locked', @player,
    return(boolean(import(concat('players.', @player, '.passwords.isLocked'))))
)

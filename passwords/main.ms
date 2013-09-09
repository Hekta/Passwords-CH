
include('procs.library/procs.ms')


assign(@config, ini_decode(read('config.txt')))
switch(array_get(@config, 'password-required-for-all-players', 'false'),
    'true',
    array_set(@config, 'password-required-for-all-players', true),
    array_set(@config, 'password-required-for-all-players', false)
)
switch(array_get(@config, 'purge-on-startup', 'false'),
    'true',
    array_set(@config, 'purge-on-startup', true),
    array_set(@config, 'purge-on-startup', false)
)
array_set(@config, 'days-of-inactivity-for-purge', integer(array_get(@config, 'days-of-inactivity-for-purge', 60)))
array_set(@config, 'number-of-attempts-allowed', integer(array_get(@config, 'number-of-attempts-allowed', 4)))
array_set(@config, 'time-limit-in-seconds-for-authentication', integer(array_get(@config, 'time-limit-in-seconds-for-authentication', 60)))
array_set(@config, 'password-min-length', integer(array_get(@config, 'password-min-length', 5)))
export('passwords.config', @config)


if(import('passwords.config')['purge-on-startup'], _purge_passwords())


if(import('passwords.config')['password-required-for-all-players'],
    foreach(all_players(), @player, if(_pis_locked(@player), _unlock_player(@player)) _lock_player(@player)),
    foreach(all_players(), @player, if(_phas_password(@player), if(_pis_locked(@player), _unlock_player(@player)) _lock_player(@player)))
)


if(import('passwords.config')['password-required-for-all-players'],
    bind('player_join', associative_array('priority': 'highest'), null, @event,
        _lock_player(@event['player'])
    ),
    bind('player_join', associative_array('priority': 'highest'), null, @event,
        if(_phas_password(@event['player']),
            _lock_player(@event['player'])
        )
    )
)

bind('player_kick', associative_array('priority': 'highest'), null, @event,
    if(_pis_locked(@event['player']),
        _unlock_player(@event['player'])
    )
)

bind('player_quit', associative_array('priority': 'highest'), null, @event,
    if(_pis_locked(@event['player']),
        _unlock_player(@event['player'])
    )
)

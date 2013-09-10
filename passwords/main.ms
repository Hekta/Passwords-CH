
include('procs.library/procs.ms')


assign(@config, yml_decode(read('../passwords-preferences.txt')))
array_set(@config, 'password-required', boolean(array_get(@config, 'password-required', false)))
array_set(@config, 'purge-on-startup', boolean(array_get(@config, 'purge-on-startup', false)))
array_set(@config, 'max-inactivity', integer(array_get(@config, 'max-inactivity', 60)))
array_set(@config, 'attempts-allowed', integer(array_get(@config, 'attempts-allowed', 4)))
array_set(@config, 'time-limit', integer(array_get(@config, 'time-limit', 60)))
array_set(@config, 'min-length', integer(array_get(@config, 'min-length', 5)))
export('passwords.preferences', @config)


if(import('passwords.preferences')['purge-on-startup'], _purge_passwords())


if(import('passwords.preferences')['password-required'],
    foreach(all_players(), @player, if(_pis_locked(@player), _unlock_player(@player)) _lock_player(@player)),
    foreach(all_players(), @player, if(_phas_password(@player), if(_pis_locked(@player), _unlock_player(@player)) _lock_player(@player)))
)


if(import('passwords.preferences')['password-required'],
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

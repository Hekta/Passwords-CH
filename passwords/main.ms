
include('procs.library/procs.ms')


assign(@preferences, yml_decode(read('../passwords-preferences.txt')))
array_set(@preferences, 'password-required', boolean(array_get(@preferences, 'password-required', false)))
array_set(@preferences, 'purge-on-startup', boolean(array_get(@preferences, 'purge-on-startup', false)))
array_set(@preferences, 'max-inactivity', integer(array_get(@preferences, 'max-inactivity', 60)))
array_set(@preferences, 'attempts-allowed', integer(array_get(@preferences, 'attempts-allowed', 4)))
array_set(@preferences, 'time-limit', integer(array_get(@preferences, 'time-limit', 60)))
array_set(@preferences, 'min-length', integer(array_get(@preferences, 'min-length', 5)))
export('passwords.preferences', @preferences)


if(_passwords_preference('purge-on-startup'), _purge_passwords())


if(_passwords_preference('password-required'),
    foreach(all_players(), @player, if(_pis_locked(@player), _unlock_player(@player)) _lock_player(@player)),
    foreach(all_players(), @player, if(_phas_password(@player), if(_pis_locked(@player), _unlock_player(@player)) _lock_player(@player)))
)


if(_passwords_preference('password-required'),
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

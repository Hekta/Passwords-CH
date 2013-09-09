Passwords-CH
============


- Installation:

 - Copy the "passwords" folder in the LocalPackages folder of CommandHelper.

 - Add this line in "persistance.config" in CommandHelper folder to create a database which will contain the passwords: storage.passwords.**=sqlite://database/passwords.db

 - You can edit the "config.txt" file in "passwords" folder.

 - The /passwords command will display the help.


- Permissions:

 - The label of the aliases is "passwords" (they require the "commandhelper.alias.passwords" permission to run properly).

 - The "passwords.admin" permission is for use the admin aliases.


- Configs:

 - logout-on-reload: If true, players who have a password will have to reauthenticate after a /reload or a /reloadaliases.

 - password-min-length: Minimum of characters a password must contain.

 - number-of-attempts-allowed: If a player exceeds the attempts limit, he will be kicked (0 to disable it).

 - time-limit-in-seconds-for-authentication: After this time limit, if a player is not authenticated, he will be kicked (0 to disable it).

 - purge-on-startup: If true, on startup and /reload, the passwords of players considered inactive will be automatically removed from the database.

 - days-of-inactivity-for-purge: If a player has not connected since this number of days, it is considered inactive.

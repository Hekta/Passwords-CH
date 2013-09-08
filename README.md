Passwords-CH
============


- Installation:

 - Copy the "passwords" folder in the LocalPackages folder of CommandHelper.

 - Add this line in "persistance.config" in CommandHelper folder to create a database which will contain the passwords: storage.passwords.**=sqlite://database/passwords.db

 - You can edir the "config.txt".

 - The /passwords command will display the help.


- Permissions:

 - "passwords.admin" for use the admin aliases.


- Configs:

 - logout-on-reload: If true, players who have a password will have to reauthenticate after a /reload or a /reloadaliases command.

 - password-min-length: Minimum of character a password must contain.

 - time-limit-in-seconds-for-authentication: After this limit, if a player is not authenticated, he will be kicked (0 to disabled it).

 - purge-on-startup: If true, on startup and /reload, the passwords of players considered inactive will be automatically removed from the database.

 - days-of-inactivity-for-purge: If a player has not connected since the numbers of days indicated, it is considered inactive.

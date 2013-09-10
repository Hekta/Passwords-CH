Passwords-CH
============


- Installation:

 - Copy the "passwords" folder and the "passwords-preferences.txt" file in the LocalPackages folder of CommandHelper.

 - Add this line in "persistance.config" in CommandHelper folder to create a database which will contain the passwords: storage.passwords.**=sqlite://database/passwords.db

 - You can edit the "passwords-preferences.txt" file.

 - The /passwords command will display the help.


- Permissions:

 - The label of the aliases is "passwords" (they require the "commandhelper.alias.passwords" permission to run properly).

 - The "passwords.admin" permission is needed to use the admin aliases.


- Preferences:

 - password-required: If true, all players will have to register a password to play, if false, only the players who will choose to register a password will have to enter it each connections.

 - attempts-allowed: Number of attempts allowed. If a player exceeds the attempts limit, he will be kicked (0 to disable it).

 - time-limit: In seconds. After the time limit, if a player is not authenticated, he will be kicked (0 to disable it).

 - min-length: Minimum of characters a password must contain.

 - purge-on-startup: If true, on startup and /reload, the passwords of players considered inactive will be automatically removed from the database.

 - max-inactivity: In days. If a player has not connected since this number of days, it is considered inactive.

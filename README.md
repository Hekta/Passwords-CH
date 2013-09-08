Passwords-CH
============


- Installation:

 - Copy the "passwords" folder in the "LocalPackages" folder of CommandHelper.

 - Add this line in "persistance.config" to create a database which will contain the passwords: storage.passwords.**=sqlite://database/passwords.db

 - The /passwords command will display the help.


- Permissions:

 - "passwords.admin" for use the admin aliases.


- Config:

 - logout-on-reload: if true, players who have a password will have to reauthenticate after a /reload or a /reloadaliases command.

 - password-min-length: minimum of character a password must contain.

 - time-limit-in-second-for-authentication: After this limit, if a player is not authenticated, he will be kicked.

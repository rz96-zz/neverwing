# System Description
Our team implemented a version of the Facebook messenger game EverWing (working title is currently NeverWing).

Key features: 
Interactive web GUI
Main character shoot projectiles that inflict damage on monsters
Monsters advance on the main character without inflicting damage; HP is lost when main character comes into contact with monsters or projectiles from monsters.
3 types of monsters - low, medium, and high level of damage required to kill
Higher difficulty monsters begin appearing on the screen as the player’s score increases

This system is a one-player game in which the player can move horizontally with keyboards keys “a” and “d” to move left and right, respectively, across the bottom of the GUI while constantly shooting bullets/projectiles. The player begins with an HP of 200.  As soon as the game starts, rows of monsters advance from the top of the GUI to the bottom of the GUI towards the player.will they be “random” If the player is in contact with a monster, the player’s HP drops by 10 points if it’s a low level monster, 20 points if it’s a medium level monster, or 30 points if it’s a high level monster. To kill a monster, the main character needs to inflict 10 HP, 20 HP, 30 HP damage to a low, medium, and high level monster respectively. Each projectile inflicts a 5 HP damage. Once a player’s HP drops to 0, the game is over. When the player reaches a score of xx, then the monsters advancing on the board is a higher difficulty level. Score is kept by how many monsters defeated, proportional to the level of damage needed to kill them.

# verilogProject_theGadiator

Project Title:  The Gladiator

Team Member: Changjin He, Yue Yin

Project Description:

  The Gladiator is a zero-sum game for 2 players, with some role-playing features. Players play as a gladiator in this game. 

  To win this game, player needs to defeat his competitor. Each player has 3 hp, when player loses all his hp, he is defeated.

  There are totally 4 movements for players to select, charge, attack, defense and dodge, players can select one movement in each round.
  
  Following is the rules:

	  Initial state: Both players have 3 hp and 1 ENG. (ENG stands for energy)
	
	  Charge: When player charges, ENG adds 1.
    
	  Attack: (i) Normal attak   : costs 1 ENG, does 1 damage
		  		      upgrades to ultimate when play has more than one ENG
		  (ii)Ultimate attack: costs 2 ENG, does 2 damages
            
	  Defense: does not cost ENG
		   generated a shield that absorbs 1 damage in current round
             
	  Dodge:   cost 1 ENG
		   avoid any attacks

	  "offest damage": same kind of attack will offset damage.
			   when ultimate versus normal attack, ultimate does 1 damage and normal attack does 0 damage.		
	
	  "Invalid movements": 1. overcharge: when player's energy reaches maximum, even if player select the charge movement, it won't exceed the maximum.
			       2. non-charge: When player's energy is empty, if player select attack or dodge, he will automatically change to charge movement.
 
	  10s countdown timer: timer starts when one player selected his movement, the other must select his in 10 second, otherwise he will repeat his movement last round.

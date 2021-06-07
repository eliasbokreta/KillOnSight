# KillOnSight [UNDER DEVELOPMENT]

## What is it ?
This is a World Of Warcraft addon which allows to create a Kill On Sight list of enemy players and alert you whenever you target or mouseover them, it also scan for currently visible nameplates on your UI and trigger an alert.

## Requirements
KillOnSight is currently developed using **Classic Burning Cruisade** interface (version 20501). It may works on Retail but it hasn't been tested yet

## Installation
- Download zip folder from [here](https://github.com/eliasbokreta/KillOnSight/archive/refs/heads/main.zip) and extract into your **AddOns** folder, generally located under  `Battle.net\World Of Warcraft\_classic_\Interface` folder.
You can also `git clone https://github.com/eliasbokreta/KillOnSight.git` and move the folder into your **AddOns** folder.
- Start the game
- Enable the *KillOnSight* addon from your addon WoW menu


## Usage
### Commands :
You can access the command line with the following chat slash commands
- `/k <option>`
- `/kos <option>`
- `/killonsight <option>`

### Options :
- `/kos add` : Add current target to KoS
- `/kos delete <playerName>` : Remove a player from the list
- `/kos menu` : Display/hide KoS main menu
- `/kos settings` : Open interface addon settings

## Screenshots
![](.github/kosaddon.png)


## To do
- <s>Implement a single player deletion for the KoS list</s>
- <s>Implement an update on last seen position for KoS list</s>
- Implement kills/dead stats for the KoS list
- Separate main window with tabs :
    - <s>KoS list tab</s>
    - Kill/dead history tab, with possibility to add a previous enemy to the KoS list
- <s>Implement a timer for already shown alerts, avoiding alert spaming when changing target/mouseover</s>
- Implement a silent mode with only chat console messages

## Donate
### Paypal :
[![paypal](https://www.paypalobjects.com/en_US/FR/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/donate?hosted_button_id=Z77GXAPHXMC48)

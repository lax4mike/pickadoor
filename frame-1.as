/* extracted actionscript from pickadoor.fla */

var choosenDoor;
var openedDoor;
var bananaDoor;

cheatBox._visible = false;

var stay_win = 0;
var stay_lose = 0;
var change_win = 0;
var change_lose = 0;

bananaSound = new Sound();
bananaSound.attachSound("banana.wav");
bananaSound.setVolume(25);
goatSound = new Sound();
goatSound.attachSound("bleeeat.wav");
goatSound.setVolume(25);


reset();
function reset(){
	bananaDoor = randomNumber(3);
	openedDoor = 0;
	choosenDoor = 0;
	for(i = 1; i <=3; i++){
		eval("door"+i).enabled = true;
		eval("door"+i).gotoAndStop("start");
		eval("check"+i).unloadMovie();
	}

trace("banana door: " + bananaDoor);
	resetDoorButtons();

	arrowButton.unloadMovie();
	dText.text = "Behind one of these doors is a car\nBehind the other two are goats\n\nPick the car to win!";
	attachPrizes();
}

updateStats();
function updateStats(){
	stayWin.text = stay_win;
	stayLose.text = stay_lose;
	changeWin.text = change_win;
	changeLose.text = change_lose;
	if (stay_win+stay_lose == 0){
		stayPer.text = "0%";
	} else {
		stayPer.text = Math.round(stay_win/(stay_win+stay_lose)*100)+"%";
	}
	if (change_win+change_lose == 0){
		changePer.text = "0%"
	} else {
		changePer.text = Math.round(change_win/(change_win+change_lose)*100)+"%";
	}
	if ((stay_win > 0) && (change_win > 0)){
		cheatBox._visible = true;
	}
}

//puts pictures behind door
function attachPrizes(){
	for (i = 1; i <= 3; i++){
		eval("prize"+i).attachMovie("goat", "goat", 2);
	}

	eval("prize"+bananaDoor).attachMovie("winner", "winner", 2);
}

//when i = 3, returns 1,2, or 3. when i = 2, returns 0 or 1
function randomNumber(i){
	randomNum = Math.random();
	if (i == 3){
		if (randomNum < (1/3)){
			return 1;
		} else if (randomNum < (2/3)){
			return 2;
		} else if (randomNum <= 1){
			return 3;
		}
	} else if (i == 2){
		if (randomNum <= .5){
			return 0;
		} else if (randomNum <= 1){
			return 1;
		}
	}
}

//moves check marks as clicked
function updateChecks(door){
	if (choosenDoor != door){
		eval("check"+choosenDoor).unloadMovie();
		choosenDoor = door;
		eval("check"+choosenDoor).attachMovie("check", "check", 2);
	}
}

//initial door button actions
function resetDoorButtons(){
	door1.onRelease = function(){

		updateChecks(1);

		dText.text = "\n\nYou have choosen door #1\n We will now show you another door."
		arrowButton.attachMovie("nextButton", "nextButton", 0);

		//determines what door to show
		arrowButton.nextButton.onRelease = function(){
			if (bananaDoor == 1){
				if (randomNumber(2)){
					openedDoor = 2;
				} else {
					openedDoor = 3;
				}
			} else {
				if (bananaDoor == 2){
					openedDoor = 3;
				} else {
					openedDoor = 2;
				}

			}
			dText.text = "There is a goat behind door #"+openedDoor+"\n Would you like to change your choice?\n\n Click the check mark if you wish to stay\n or click the other door to change"
			eval("door"+openedDoor).gotoAndPlay("open");
			goatSound.start();
			arrowButton.unloadMovie();
			setNewButtons();
		}
	}


	door2.onRelease = function(){

		updateChecks(2);

		dText.text = "\n\nYou have choosen door #2\n We will now show you another door."
		arrowButton.attachMovie("nextButton", "nextButton", 0);
		arrowButton.nextButton.onRelease = function(){
			if (bananaDoor == 2){
				if (randomNumber(2)){
					openedDoor = 1;
				} else {
					openedDoor = 3;
				}
			} else {
				if (bananaDoor == 1){
					openedDoor = 3;
				} else {
					openedDoor = 1;
				}

			}
			dText.text = "There is a goat behind door #"+openedDoor+"\n Would you like to change your choice?\n\n Click the check mark if you wish to stay\n or click the other door to change"
			eval("door"+openedDoor).gotoAndPlay("open");
			goatSound.start();
			arrowButton.unloadMovie();
			setNewButtons();
		}
	}

	door3.onRelease = function(){

		updateChecks(3);

		dText.text = "\n\nYou have choosen door #3\n We will now show you another door."
		arrowButton.attachMovie("nextButton", "nextButton", 0);
		arrowButton.nextButton.onRelease = function(){
			if (bananaDoor == 3){
				if (randomNumber(2)){
					openedDoor = 1;
				} else {
					openedDoor = 2;
				}
			} else {
				if (bananaDoor == 1){
					openedDoor = 2;
				} else {
					openedDoor = 1;
				}

			}
			dText.text = "There is a goat behind door #"+openedDoor+"\n Would you like to change your choice?\n\n Click the check mark if you wish to stay\n or click the other door to change"
			eval("door"+openedDoor).gotoAndPlay("open");
			goatSound.start();
			arrowButton.unloadMovie();
			setNewButtons();
		}
	}
}


//reassigns actions to door on second choice
function setNewButtons(){
	eval("door"+openedDoor).enabled = false;

	eval("door"+choosenDoor).onRelease = function(){
		if (bananaDoor == choosenDoor){
			bananaSound.start();
			dText.text = "You win!!\n\n but I lied...\n You won a Banana!!";
			stay_win++;
		} else {
			goatSound.start();
			dText.text = "You lose\n\n You got a stinking goat";
			stay_lose++;
		}
		eval("check"+choosenDoor).unloadMovie();
		eval("door"+choosenDoor).gotoAndPlay("open");
		eval("door"+choosenDoor).enabled = false;
		eval("door"+Math.abs(openedDoor+choosenDoor-6)).enabled = false;
		updateStats();

		arrowButton.attachMovie("playAgain", "playAgain", 0);
		arrowButton.playAgain.onRelease = function(){
			reset();
		}
	}

	eval("door"+Math.abs(openedDoor+choosenDoor-6)).onRelease = function(){
		if (bananaDoor == Math.abs(openedDoor+choosenDoor-6)){
			bananaSound.start();
			dText.text = "You win!!\n\n but I lied...\n You won a Banana!!";
			change_win++;
		} else {
			goatSound.start();
			dText.text = "You lose\n\n You got a stinking goat";
			change_lose++;
		}
		eval("door"+Math.abs(openedDoor+choosenDoor-6)).gotoAndPlay("open");
		eval("check"+choosenDoor).unloadMovie();
		eval("door"+choosenDoor).enabled = false;
		eval("door"+Math.abs(openedDoor+choosenDoor-6)).enabled = false;
		updateStats();

		arrowButton.attachMovie("playAgain", "playAgain", 0);
		arrowButton.playAgain.onRelease = function(){
			reset();
		}
	}
}

//simulation
sim.onRelease = function(){
	simulate();
}

function simulate(){

	var stayID = setInterval(simStay, 10);
	var k = 0;
	var changeID = setInterval(simChange, 10);
	var j = 0;

	function simStay(){
		k++;

		var simBananaDoor = randomNumber(3);
		var compDoor = randomNumber(3);
		if (simBananaDoor == compDoor){
			stay_win++;
		} else {
			stay_lose++;
		}
		updateStats();
		if (k >= 50){
			clearInterval(stayID);
			attachPrizes();
		}
	}

	function simChange(){
		j++;

		simBananaDoor = randomNumber(3);
		var compDoor = randomNumber(3);
		for (i = 1; i <= 3; i++){
			eval("prize"+i).attachMovie("goat", "goat", 2);
		}
		eval("prize"+simBananaDoor).attachMovie("winner", "winner", 2);
		if (simBananaDoor != compDoor){
			change_win++;
		} else {
			change_lose++;
		}
		updateStats();
		if (j >= 50){
			clearInterval(changeID);
			attachPrizes();
		}
	}
	reset();
}

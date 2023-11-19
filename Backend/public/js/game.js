// Variables
const cells = document.querySelectorAll("[data-cell]"); // Sélectionne toutes les cellules du morpion
let gameStatus = document.getElementById("gameStatus"); // Élément affichant le statut du jeu
let endGameStatus = document.getElementById("endGameStatus"); // Message de fin de jeu
let playerOne = "X"; // Symbole du joueur 1
let playerTwo = "O"; // Symbole du joueur 2
let randomStart = Math.ceil(Math.random() * 2); // Nombre aléatoire contient 1 ou 2
let playerTurn = randomStart == 1 ? playerOne : playerTwo; // Définit le joueur qui commence

// Affichage du joueur qui commence la partie
if (randomStart === 1) {
  gameStatus.textContent = "Le joueur 1 commence !";
} else {
  gameStatus.textContent = "Le joueur 2 commence !";
}

// Définit les conditions de victoire
const winningPatterns = [
  [0, 1, 2],
  [3, 4, 5],
  [6, 7, 8],
  [0, 3, 6],
  [1, 4, 7],
  [2, 5, 8],
  [0, 4, 8],
  [2, 4, 6],
];

// Fonction pour vérifier si un joueur a gagné
function checkWin(playerTurn) {
  return winningPatterns.some((combination) => {
    return combination.every((index) => {
      return cells[index].innerHTML == playerTurn;
    });
  });
}

// Fonction qui envoie les coordonnées posX et posY
async function sendPos(posX, posY) {
  try {
    if (typeof posX !== "number" || typeof posY !== "number") {
      console.error("Les coordonnées posX et posY doivent être des nombres.");
      return;
    }

    let position = `${posX},${posY}`;

    const response = await fetch("/morpion", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ position: position }),
    });

    if (!response.ok) {
      throw new Error(
        `Erreur HTTP! Statut : ${response.status}, Texte : ${response.statusText}`
      );
    }

    const data = await response.json();
    console.log("Réponse du serveur :", data);
  } catch (error) {
    console.error("Erreur lors de l'envoi des données:", error);
  }
}

// Fonction appelée lorsqu'une cellule est cliquée
function playGame(e) {
  const clickedCell = e.target;
  const index = Array.from(cells).indexOf(clickedCell); // Obtient l'indice de la cellule cliquée
  const posX = index % 3; // Calcul de la position X
  const posY = Math.floor(index / 3); // Calcul de la position Y

  console.log("posX:", posX, "posY:", posY);
  sendPos(posX, posY);

  clickedCell.innerHTML = playerTurn; // Affecte à la cellule la valeur de playerTurn

  // Vérifie s'il y a un gagnant
  if (checkWin(playerTurn)) {
    updateGameStatus("wins" + playerTurn);
    return endGame();
  } else if (checkDraw()) {
    // Vérifie s'il y a un match nul
    updateGameStatus("draw");
    return endGame();
  }

  updateGameStatus(playerTurn); // Met à jour le statut du jeu
  playerTurn == playerOne ? (playerTurn = playerTwo) : (playerTurn = playerOne); // Change de joueur
}

// Fonction pour vérifier s'il y a un match nul
function checkDraw() {
  return [...cells].every((cell) => {
    return cell.innerHTML == playerOne || cell.innerHTML == playerTwo;
  });
}

// Fonction pour mettre à jour le statut du jeu
function updateGameStatus(status) {
  let statusText;

  switch (status) {
    case "X":
      statusText = "Au tour du joueur 2 (O)";
      break;
    case "O":
      statusText = "Au tour du joueur 1 (X)";
      break;
    case "winsX":
      statusText = "Le joueur 1 (X) a gagné!";
      break;
    case "winsO":
      statusText = "Le joueur 2 (O) a gagné!";
      break;
    case "draw":
      statusText = "Egalité! Personne ne gagne!";
      break;
  }

  gameStatus.innerHTML = statusText; // Met à jour le statut du jeu
  endGameStatus.innerHTML = statusText; // Met à jour le message de fin de jeu
}

// Fonction appelée à la fin du jeu
function endGame() {
  document.getElementById("gameEnd").style.display = "block"; // Affiche l'élément de fin de jeu
}

// Fonction pour recharger le jeu
function reloadGame() {
  window.location.reload();
}

// Ajoute un écouteur d'événements à chaque cellule pour gérer le jeu
cells.forEach((cell) => {
  cell.addEventListener("click", playGame, { once: true }); // once: true indique que l'événement ne doit être appelé qu'une seule fois
});

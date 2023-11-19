function continuerPartie() {
  const gameId = document.getElementById('gameSelect').value;
  console.log(gameId);
  fetch(`/games/${gameId}`, { method: 'GET' })
    .then(response => {
      if (response.ok) {
        // go to game
        window.location.href = `/games/${gameId}`;
        return response.json();
      }
      throw new Error('Réponse réseau non OK.');
    })
    .then(data => {
      console.log(data);
      // Traitez ici la réponse, par exemple, en redirigeant vers une autre page ou en affichant des détails de jeu
    })
    .catch(error => console.error('Il y a eu un problème avec l\'opération fetch: ' + error.message));
}

function creerPartie() {
  const player1 = document.getElementById('player1Select').value;
  const player2 = document.getElementById('player2Select').value;

  fetch('/games', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ player1: player1, player2: player2 }),
  })
    .then(response => {
      if (response.ok) {
        // go to game
        return response.json();
      }
      throw new Error('Réponse réseau non OK.');
    })
    .then(data => {
      window.location.href = `/games/${data.game_id}`;
    })
    .catch(error => console.error('Il y a eu un problème avec l\'opération fetch: ' + error.message));
}


function creerJoueur() {
  const playerName = document.getElementById('playerName').value;

  fetch('/players', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ name: playerName }),
  })
  .then(response => response.json())
  .then(data => {
    if (data.id) {
      // Ajouter le joueur aux listes déroulantes
      ajouterJoueurAuxListes(data);
      document.getElementById('playerName').value = '';
    } else {
      console.error('Erreur lors de la création du joueur:', data.errors);
    }
  })
  .catch(error => console.error('Erreur:', error));
}

function ajouterJoueurAuxListes(joueur) {
  const selectElements = [document.getElementById('player1Select'), document.getElementById('player2Select')];
  selectElements.forEach(select => {
    const option = document.createElement('option');
    option.value = joueur.id;
    option.textContent = joueur.name;
    select.appendChild(option);
  });
}

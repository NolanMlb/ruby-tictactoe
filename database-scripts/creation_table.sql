SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Database: `tictactoe`
--

-------------------------------------------------- CREATE TABLES --------------------------------------------------
CREATE TABLE IF NOT EXISTS games (
    id VARCHAR PRIMARY KEY,
    player_x_id VARCHAR NOT NULL,
    player_o_id VARCHAR NOT NULL,
    winner VARCHAR NULL,
    status VARCHAR NOT NULL CHECK (status IN ('ongoing', 'finished')),

    FOREIGN KEY (player_x_id) REFERENCES players(id),
    FOREIGN KEY (player_o_id) REFERENCES players(id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS moves (
    game_id VARCHAR NOT NULL,
    x_pos INT NOT NULL,
    y_pos INT NOT NULL,
    movement_index INT NOT NULL,

    FOREIGN KEY (game_id) REFERENCES games(id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS players (
    id VARCHAR PRIMARY KEY,
    name VARCHAR NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

COMMIT;

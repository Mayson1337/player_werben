# player_werben
Spieler erhalten Belohnungen beim Werben anderer Spieler

Sobald ein Spieler ein Level aufsteigt:
    => TriggerEvent('void:addGeworben', source, level)

Benötigt ESX Legacy V1.9 oder das in die Datenbank hinzufügen:
    => ALTER TABLE users ADD COLUMN `id` INT NOT NULL AUTO_INCREMENT;

RegisterCommand("geworben", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local id = tonumber(args[1])
    if id ~= nil then
      MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
          ['@identifier'] = xPlayer.identifier
        }, function(result)
          if #result > 0 then
            local hatgeworben = tonumber(result[1]["hatgeworben"])
            local selfid = tonumber(result[1]["id"])
            if hatgeworben == 0 and selfid ~= id then
              MySQL.Async.fetchAll('SELECT * FROM users WHERE id = @id', {
                  ['@id'] = id
                }, function(result)
                  if #result > 0 then
                    local geworben = tonumber(result[1]["geworben"])
                    local geworbengesamt = tonumber(result[1]["geworbengesamt"])
                    local name = tostring(result[1]["firstname"]) .. " " .. tostring(result[1]["lastname"])
                    TriggerClientEvent('notifications', xPlayer.source, "green", "Geworben", "Du hast erfolgreich " .. name .. " als dein Anwerber gesetzt.<br>Du erhälst deine nächste Prämie mit Level 3!<br>+2.000$", 6000)
                    MySQL.Async.execute("UPDATE users SET geworben = @geworben, geworbengesamt = @ geworbengesamt WHERE id = @id", 
                      {
                        ['@id'] = id,
                        ['@geworben'] = geworben + 1,
                        ['@geworbengesamt'] = geworbengesamt + 1
                      }
                    )
                    MySQL.Async.execute("UPDATE users SET hatgeworben = @hatgeworben WHERE identifier = @identifier", 
                      {
                        ['@identifier'] = xPlayer.identifier,
                        ['@hatgeworben'] = id
                      }
                    )
                  else
                    TriggerClientEvent('notifications', xPlayer.source, "red", "Geworben", "Dieser Spieler wurde nicht gefunden!")
                  end
                end)
            else
              if selfid == id then
                TriggerClientEvent('notifications', xPlayer.source, "red", "Geworben", "Du kannst dich nicht selbst werben!")
              else
                TriggerClientEvent('notifications', xPlayer.source, "red", "Geworben", "Du hast bereits einen Spieler angegeben!")
              end
            end
          end
        end)
    else
      TriggerClientEvent('notifications', xPlayer.source, "red", "Geworben", "Bitte gib eine Spieler-ID an!")
    end
  end)
 
RegisterServerEvent('void:addGeworben')
AddEventHandler('void:addGeworben', function(source, visum)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
      }, function(result)
        if #result > 0 then
          local geworben = tonumber(result[1]["hatgeworben"])
          addGeworbenPoints(geworben, visum)
          if geworben >= 1 then
            if visum == 3 then
              xPlayer.addMoney(5000)
              TriggerClientEvent('notifications', xPlayer.source, "green", "Geworben", "Da du geworben wurdest erhälst du 5.000$", 12000)
            else
              if visum == 8 then
                xPlayer.addMoney(15000)
                TriggerClientEvent('notifications', xPlayer.source, "green", "Geworben", "Da du geworben wurdest erhälst du 15.000$", 12000)
              else
                if visum == 15 then
                  xPlayer.addMoney(50000)
                  TriggerClientEvent('notifications', xPlayer.source, "green", "Geworben", "Da du geworben wurdest erhälst du 50.000$", 12000)
                end
              end
            end
          end
        end
      end)
  end)
 
function addGeworbenPoints(geworben, level)
  MySQL.Async.fetchAll('SELECT * FROM users WHERE id = @id', {
      ['@id'] = geworben
    }, function(result)
      if #result > 0 then
        local punkte = tonumber(result[1]["geworben"]) 
        if geworben >= 1 then
          if level == 3 then
            MySQL.Async.execute("UPDATE users SET geworben = @geworben WHERE id = @id", 
              {
                ['@id'] = geworben,
                ['@geworben'] = punkte + 2
              }
            )
          else
            if level == 8 then
              MySQL.Async.execute("UPDATE users SET geworben = @geworben WHERE id = @id", 
                {
                  ['@id'] = geworben,
                  ['@geworben'] = punkte + 5
                }
              )
            else
              if level == 15 then
                MySQL.Async.execute("UPDATE users SET geworben = @geworben WHERE id = @id", 
                  {
                    ['@id'] = geworben,
                    ['@geworben'] = punkte + 10
                  }
                )
              end
            end
          end
        end
      end
    end)
  end
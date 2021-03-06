local przyciskifivem = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}


ESX                           = nil
local PlayerData              = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
 	    PlayerData = ESX.GetPlayerData()
    end
end)



RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterCommand('sprzedaj', function(source, args)
    local letters = args[1]
    local numbers = args[2]
    local price = args[3]

    local closestPlayer, distance = ESX.Game.GetClosestPlayer()

    if distance ~= -1 and distance <= 3 then
        if letters ~= nil and numbers ~= nil and price ~= nil then
            print('Rejestracja: ' .. letters .. ' ' .. numbers .. ' Cena: ' .. price)
            TriggerServerEvent('bivv-vehselling:proposeDeal', GetPlayerServerId(closestPlayer), letters .. ' ' .. numbers .. ' ', price)
        else
            ESX.ShowNotification('Zapomnia??e?? czego?? dopisa??')
        end
    else
        ESX.ShowNotification('Nie ma nikogo w pobli??u')
    end
end, false) 

RegisterNetEvent('bivv-vehselling:proposedDeal')
AddEventHandler('bivv-vehselling:proposedDeal', function(price, plate)

    local DoingDeal = true

    Citizen.CreateThread(function()
        while DoingDeal do
            Citizen.Wait(5)

            local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))

            ESX.Game.Utils.DrawText3D({x = x, y = y, z = z + 1}, '~g~[1] Akceptuj ~r~[2] Odrzu??', 0.6)
            if IsControlJustReleased(0, przyciskifivem['1']) then
                TriggerEvent("pNotify:SendNotification", {text = "Kupi??e?? pojazd", type = "success", timeout = 1400, layout = "centerLeft"})
                TriggerServerEvent('bivv-vehselling:acceptDeal', plate, price)
                DoingDeal = false
            else
            ESX.ShowNotification('~g~Proponowana Cena: ' ..price.. ' $ za: ~y~ ' ..plate)

              end

        
            if IsControlJustReleased(0, przyciskifivem['2']) then
                DoingDeal = false
            end
        end
    end)

end)

function sendNotification(message, messageType, messageTimeout)
    TriggerEvent('notification', message)
end
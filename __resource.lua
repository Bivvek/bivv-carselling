resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

author 'Bivvus#4339'
description 'Sprzedawanie Pojazdow by Bivvus'
version "2.1.3.7"

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server/main.lua',
}

client_scripts {
  'client/main.lua',
}
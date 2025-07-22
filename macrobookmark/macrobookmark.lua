addon.name      = 'bookmark';
addon.author    = 'Viy';
addon.version   = '0.1.0';
addon.desc      = 'macro navigation storage';

require('common');

local chat    = require('chat');
local storage = {};

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or not args[1]:any('/bookmark')) then
        return;
    end

    if (#args >= 2) then
        local command = args[2];

        -- Return to Home
        if (command:any('reset') and storage.home ~= nil) then
            AshitaCore:GetChatManager():QueueCommand(1, string.format('/macro book %s', storage.home.book));
            AshitaCore:GetChatManager():QueueCommand(1, string.format('/macro set %s', storage.home.page));
        end

        -- Return to the tag
        if (command:any('return') and storage.tag ~= nil) then
            AshitaCore:GetChatManager():QueueCommand(1, string.format('/macro book %s', storage.tag.book));
            AshitaCore:GetChatManager():QueueCommand(1, string.format('/macro set %s', storage.tag.page));
        end

        -- Set home
        if (command:any('home')) then
            storage.home = {
                book = args[3],
                page = args[4]
            };
            print(chat.header(addon.name):append(chat.message(string.format('Home Set - Book:%s, Page:%s', storage.home.book, storage.home.page))))
        end

        -- Tag a page
        if (tonumber(args[2]) ~= nil and tonumber(args[3]) ~= nil) then
            storage.tag = {
                book = args[2],
                page = args[3]
            };
        end

        return;
    end
end);
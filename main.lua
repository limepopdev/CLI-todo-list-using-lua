local tasks = {}
local getInput

local typeHelpMessage = "Type 'help' to get a list of commands and how to use them"
local invalidArgsMessage = "Invalid arguments. " .. typeHelpMessage
local noTaskOfIdMessage = "No task with an id of %d. Use 'list' to get a list of all current tasks, their ids, and if they are completed or not"

local helpMessage = [[

Available commands:

help:
    description - "Get a list of commands and how to use them"
    usage - "help"

add:
    description - "Add an entry to your to-do list"
    usage - "add <task>"

list:
    description - "Get a list of all current tasks, their ids, and if they are completed or not"
    usage - "list"

remove:
    description - "Remove an entry from your to-do list"
    usage - "remove <task-id>"

complete:
    description - "Mark a task in your to-do list as complete"
    usage - "complete <task-id>"

uncomplete:
    description - "Mark a task in your to-do list as incomplete"
    usage - "uncomplete <task-id>"

rename:
    description - "Rename a task in your to-do list"
    usage - "rename <task-id> <new-name>"

clear:
    description - "Clears all tasks from your to-do list"
    usage - "clear"
]]

local function parseInput(message)
    local result = {}
    for word in message:gmatch("%S+") do
        table.insert(result, word)
    end
    return result
end

local commands = {}

commands.help = function()
    print(helpMessage)
end

commands.add = function(args)
    local task = table.concat(args, " ", 2)

    for _, entry in ipairs(tasks) do
        if entry.name == task then
            print("That task already exists")
            return
        end
    end

    table.insert(tasks, { name = task, completed = false })
    print(string.format("Task Added: '%s'", task))
end

commands.list = function()
    if #tasks == 0 then
        print("No tasks found")
        return
    end

    for i, entry in ipairs(tasks) do
        local status = entry.completed and "Completed" or "Uncompleted"
        print(string.format("(%d) %s [%s]", i, entry.name, status))
    end
end

commands.remove = function(args)
    local id = tonumber(args[2])
    if not id then
        print(invalidArgsMessage)
        return
    end

    local entry = tasks[id]
    if entry then
        table.remove(tasks, id)
        print(string.format("Removed task '%s'", entry.name))
        return
    end

    print(string.format(noTaskOfIdMessage, id))
end

commands.complete = function(args)
    local id = tonumber(args[2])
    if not id then
        print(invalidArgsMessage)
        return
    end

    local entry = tasks[id]
    if entry then
        if entry.completed then
            print(string.format("Task is already completed: '%s'", entry.name))
        else
            entry.completed = true
            print(string.format("Completed task '%s'", entry.name))
        end
        return
    end

    print(string.format(noTaskOfIdMessage, id))
end

commands.uncomplete = function(args)
    local id = tonumber(args[2])
    if not id then
        print(invalidArgsMessage)
        return
    end

    local entry = tasks[id]
    if entry then
        if entry.completed then
            entry.completed = false
            print(string.format("Uncompleted task '%s'", entry.name))
        else
            print(string.format("Task is already uncompleted: '%s'", entry.name))
        end
        return
    end

    print(string.format(noTaskOfIdMessage, id))
end

commands.rename = function(args)
    local id = tonumber(args[2])
    if not id then
        print(invalidArgsMessage)
        return
    end

    local newName = table.concat(args, " ", 3)
    if not newName or newName == "" then
        print(invalidArgsMessage)
        return
    end

    local entry = tasks[id]
    if entry then
        if entry.name == newName then
            print(string.format("Task already has the name: '%s'", newName))
        else
            entry.name = newName
            print(string.format("Changed name of task to '%s'", newName))
        end
        return
    end

    print(string.format(noTaskOfIdMessage, id))
end

commands.clear = function(args)
    if #tasks == 0 then
        print("There were no tasks to clear")
    else
        tasks = {}
        print("All tasks have been cleared")
    end
end

local function executeCommand(input)
    local cmd = commands[input[1]]
    if cmd then
        cmd(input)
    else
        print("That is not a valid command")
    end
end

getInput = function()
    while true do
        io.write("> ")
        local input = io.read()
        if not input then break end
        if input ~= "" then
            executeCommand(parseInput(input))
        end
    end
end

print("Type 'help' to get a list of all available commands")
getInput()

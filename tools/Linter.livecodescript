script "Linter"

on startup
  try
    read from stdin until empty
    put it into theScript

    local isScriptOnly = false
    if word 1 of theScript is "script" then
      put true into isScriptOnly
    end if

    put the filename of me into theFilename
    set the itemDelimiter to slash
    put "scriptErrors.txt" into item -1 of theFilename
    put url ("file:"&theFilename) into theErrorsList

    create script only stack "TestScript"

    if isScriptOnly then
      delete line 1 of theScript
    end if

    set the script of stack "TestScript" to theScript

    put the result into theErrors
    set the itemDelimiter to comma

    repeat for each line theError in theErrors
      if theError is not empty then
        if isScriptOnly then
          add 1 to item 2 of theError
        end if
        write item 2 of theError, line (item 1 of theError) of theErrorsList & linefeed to stdout
      end if
    end repeat

    write linefeed to stdout
  catch e
    write e & linefeed & linefeed to stdout
  end try

  quit
end startup

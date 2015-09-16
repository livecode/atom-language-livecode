script "Linter"

local sErrorsList

on startup
  try
    local tScope
    repeat for each element theArgument in the commandArguments
      if theArgument begins with "-scope" then
         split theArgument with "="
         put theArgument[2] into tScope
      end if
    end repeat

    read from stdin until empty
    put it into tScript

    put the filename of me into theFilename
    set the itemDelimiter to slash
    put "scriptErrors.txt" into item -1 of theFilename
    put url ("file:"&theFilename) into sErrorsList
    split sErrorsList with return

    create script only stack "TestScript"

    if tScope is empty or tScope is ".source.livecodescript" then
      local tLineOffset = 0

      -- check for script only
      if word 1 of tScript is "script" then
        put 1 into tLineOffset
      end if

      if tLineOffset is 1 then
        delete line 1 of tScript
      end if

      LintScript tScript, tLineOffset
    else if tScope is ".source.iRev" then

    end if

    write linefeed to stdout
  catch e
    write e & linefeed & linefeed to stdout
  end try

  quit
end startup

command LintScript pScript, pLineOffset
  set the script of stack "TestScript" to pScript

  put the result into theErrors
  set the itemDelimiter to comma

  repeat for each line theError in theErrors
    if theError is not empty then
      write item 2 of theError + pLineOffset, item 3 of theError, sErrorsList[item 1 of theError] & linefeed to stdout
    end if
  end repeat
end LintScript

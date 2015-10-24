script "GenerateSnippets"
constant kBaseIndent = "      "
constant kIndent = "  "

on preOpenStack
   set the visible of me to true
   create btn "Generate Snippets"
   set the rect of it to "10,10,124,33"
end preOpenStack

on mouseUp
   if the short name of the target is "Generate Snippets" then
      put kBaseIndent & "builtins:" & cr & \
            kBaseIndent & kIndent & "suggestions: [" into theSnippets
      
      # functions
      set the folder to specialFolderPath("home") & "/livecode/docs/dictionary/function"
      repeat for each line theFile in the files
         put url ("file:"&theFile) into theDoc
         put GetDescription(theDoc) into theDescription
         filter theDoc with "Syntax: *"
         repeat for each line theSyntax in theDoc
            delete word 1 of theSyntax
            replace "[" with empty in theSyntax
            replace "]" with empty in theSyntax
            
            -- parameters
            put empty into theFunctionName
            put empty into theParameters
            if theSyntax contains "(" then
               get MatchText(theSyntax,"(?i)^(.*)\((.*)\)",theFunctionName,theParameters)
               
               if theParameters is empty then
                  next repeat
               end if
               
               put theFunctionName into thePrefix
               
               put theFunctionName&"(" into theBody
               
               if theParameters is not empty then
                  replace "<" with "" in theParameters
                  replace ">" with "" in theParameters
                  split theParameters with comma
                  repeat with theIndex = 1 to the number of elements of theParameters
                     split theParameters[theIndex] with "|"
                     replace space with empty in theParameters[theIndex][1]
                     put "${"&theIndex&":"&theParameters[theIndex][1]&"}, "  after theBody
                  end repeat
                  put ")" into char -2 to -1 of theBody
               else
                  put ")" after theBody
               end if
               
               AddSnippet theSnippets, theFunctionName, theBody, "function", theDescription, theFile
               
            else
               
               if theSyntax contains "of" then
                  put word 2 to -4 of theSyntax into theOptions
                  put word -3 of theSyntax into theFunctionName
                  put word -1 of theSyntax into theParameter
                  replace "<" with "" in theParameter
                  replace ">" with "" in theParameter
                  put " of ${1:"&theParameter&"}"  into theParameter
               else
                  put empty into theParameter
                  put word 2 to -2 of theSyntax into theOptions
                  put word -1 of theSyntax into theFunctionName
               end if
               
               if theOptions contains "|" then
                  split theOptions with "|"
                  repeat with theIndex = 1 to the number of elements of theOptions
                     -- trim
                     put word 1 to -1 of theOptions[theIndex] into theOptions[theIndex]
                     if theOptions[theIndex] is not empty then
                        put kIndent after theOptions[theIndex]
                     end if
                     AddSnippet theSnippets, theOptions[theIndex] & theFunctionName, theOptions[theIndex] & theFunctionName & theParameter, "function", theDescription, theFile
                  end repeat
               else
                  if theParameter is empty then
                     next repeat
                  end if
               end if
            end if
         end repeat
      end repeat
      
      # messages
      set the folder to specialFolderPath("home") & "/livecode/docs/dictionary/message"
      repeat for each line theFile in the files
         put url ("file:"&theFile) into theDoc
         put GetDescription(theDoc) into theDescription
         filter theDoc with "Syntax: *"
         repeat for each line theSyntax in theDoc
            delete word 1 of theSyntax
            replace "<" with "" in theSyntax
            replace ">" with "" in theSyntax
            put word 1 of theSyntax into theMessageName
            put word 2 to -1 of theSyntax into theParameters
            put theMessageName into theSyntax
            split theParameters by comma
            repeat with theIndex = 1 to the number of elements of theParameters
               if theParameters[theIndex] contains "|" then
                  -- unfortunately some of the syntax definitions describe a set of possible values
                  -- or parameter types and this simplifies things considerably...
                  put "Value" into theParameter
               else
                  -- trim
                  put word 1 of theParameters[theIndex] into theParameter
               end if
               put space & "p" & toUpper(char 1 of theParameter) & char 2 to -1 of theParameter & comma after theSyntax
            end repeat
            if the last char of theSyntax is comma then
               delete the last char of theSyntax
            end if
            
            put theSyntax & cr & space & "${1:/* code */ }" & cr & "end" && theMessageName into theBody
            AddSnippet theSnippets, theMessageName & " ... end " & theMessageName, theBody, "message", theDescription, theFile
         end repeat
      end repeat
      
      # properties
      set the folder to specialFolderPath("home") & "/livecode/docs/dictionary/property"
      repeat for each line theFile in the files
         put url ("file:"&theFile) into theDoc
         put GetDescription(theDoc) into theDescription
         filter theDoc with "Syntax: *"
         repeat for each line theSyntax in theDoc
            -- strip off set|put the
            put word 4 to -1 of theSyntax into theSyntax
            put theSyntax into theSnippet
            replace "<" with "{" in theSnippet
            replace ">" with "}" in theSnippet
            replace "{" with "${" in theSnippet
            replace "[" with "${" in theSnippet
            replace "]" with "}" in theSnippet
            replace " | " with "OR" in theSnippet
            set the itemDelimiter to "{"
            repeat with theIndex = 2 to the number of items of theSnippet
               put theIndex-1&":" before item theIndex of theSnippet
            end repeat
            
            
            AddSnippet theSnippets, theSyntax, theSnippet, "property", theDescription, theFile
         end repeat
      end repeat
      
      # keywords
      set the folder to specialFolderPath("home") & "/livecode/docs/dictionary/keyword"
      repeat for each line theFile in the files
         put url ("file:"&theFile) into theDoc
         put GetDescription(theDoc) into theDescription
         filter theDoc with "Syntax: *"
         repeat for each line theSyntax in theDoc
            -- strip off set|put the
            put word 2 to -1 of theSyntax into theSyntax
            if theSyntax is "[]" then next repeat
            if theSyntax is "\" then next repeat
            AddSnippet theSnippets, theSyntax, theSyntax, "keyword", theDescription, theFile
         end repeat
      end repeat
      
      # constants
      set the folder to specialFolderPath("home") & "/livecode/docs/dictionary/constant"
      repeat for each line theFile in the files
         put url ("file:"&theFile) into theDoc
         put GetDescription(theDoc) into theDescription
         filter theDoc with "Syntax: *"
         repeat for each line theSyntax in theDoc
            -- strip off set|put the
            put word 2 to -1 of theSyntax into theSyntax
            AddSnippet theSnippets, theSyntax, theSyntax, "constant", theDescription, theFile
         end repeat
      end repeat
      
      # objects
      set the folder to specialFolderPath("home") & "/livecode/docs/dictionary/object"
      repeat for each line theFile in the files
         put url ("file:"&theFile) into theDoc
         put GetDescription(theDoc) into theDescription
         filter theDoc with "Syntax: *"
         repeat for each line theSyntax in theDoc
            -- strip off set|put the
            put word 2 to -1 of theSyntax into theSyntax
            AddSnippet theSnippets, theSyntax, theSyntax, "object", theDescription, theFile
         end repeat
      end repeat
      
      # operators
      set the folder to specialFolderPath("home") & "/livecode/docs/dictionary/operator"
      repeat for each line theFile in the files
         put url ("file:"&theFile) into theDoc
         put GetDescription(theDoc) into theDescription
         filter theDoc with "Syntax: *"
         repeat for each line theSyntax in theDoc
            replace "&gt;" with ">" in theDoc
            replace "&lt:" with "<" in theDoc
            put word 3 to -1 of theSyntax into theSyntax
            if the number of chars of word 1 of theSyntax is 1 then
               next repeat
            end if
            if the number of chars of word 1 of theSyntax < 5 and the number of words in theSyntax is 2 then
               next repeat
            end if
            repeat for each line theSnippet in ParseSyntaxDefinition(theSyntax)
               if theSnippet is empty then next repeat
               put 2 into checkAn
               if word checkAn of theSnippet is "not" then
                  add 1 to checkAn
               end if
               if word checkAn of theSnippet is "an" and char 1 of word checkAn+1 of theSnippet is not among the chars of "aeiou" then
                  next repeat
               end if
               if word checkAn of theSnippet is "a" and char 1 of word checkAn+1 of theSnippet is among the chars of "aeiou" then
                  next repeat
               end if
               put theSnippet into theParsedSyntax
               replace "<" with "${" in theSnippet
               replace ">" with "}" in theSnippet
               set the itemDelimiter to "{"
               repeat with theIndex = 2 to the number of items of theSnippet
                  put theIndex-1&":" before item theIndex of theSnippet
               end repeat
               AddSnippet theSnippets, theParsedSyntax, theSnippet, "operator", theDescription, theFile
            end repeat
         end repeat
      end repeat
      
      # commands
      set the folder to specialFolderPath("home") & "/livecode/docs/dictionary/command"
      repeat for each line theFile in the files
         put url ("file:"&theFile) into theDoc
         put GetDescription(theDoc) into theDescription
         filter theDoc with "Syntax: *"
         repeat for each line theSyntaxDefinition in theDoc
            delete word 1 of theSyntaxDefinition
            if the number of words of theSyntaxDefinition is 1 then
               next repeat
            end if
            repeat for each line theSyntax in ParseSyntaxDefinition(theSyntaxDefinition)
               if theSyntax is empty then next repeat -- not sure why we are geting empty lines
               put theSyntax into theParameters
               replace "<" with "" in theSyntax
               replace ">" with "" in theSyntax
               put word 1 to 3 of theSyntax into thePrefix
               replace space with empty in thePrefix
               
               split theParameters with "<"
               repeat with theIndex = 1 to the number of elements of theParameters
                  if theIndex is 1 then
                     put theParameters[theIndex] into theBody
                  else
                     split theParameters[theIndex] with ">"
                     put "${"&theIndex-1&":"&theParameters[theIndex][1]&"}"&theParameters[theIndex][2] after theBody
                  end if
               end repeat
               AddSnippet theSnippets, theSyntax, theBody, "command", theDescription, theFile
            end repeat
         end repeat
      end repeat
      
      put cr & kBaseIndent & kIndent & "]" & cr & \
            "# GENERATED SNIPPETS END" & cr after theSnippets
      
      put url ("binfile:"&specialFolderPath("home")&"/atom-language-livecode/settings/language-livecode.cson") into theCSON
      put offset(kBaseIndent & "builtins:",theCSON) into theStart
      put offset("# GENERATED SNIPPETS END",theCSON) into theEnd
      add length("# GENERATED SNIPPETS END") to theEnd
      if theStart > 0 and theEnd > 0 then
         put theSnippets into char theStart to theEnd of theCSON
      else if theStart > 0 then
         put theSnippets into char theStart to -1 of theCSON
      else
         put cr&theSnippets after theCSON
      end if
      put theCSON into url ("binfile:"&specialFolderPath("home")&"/atom-language-livecode/settings/language-livecode.cson")
   end if
end mouseUp

function GetDescription pDoc
   filter pDoc with "Summary: *"
   put word 2 to -1 of line 1 of pDoc into pDoc
   replace "'" with "\'" in pDoc
   replace quote with "\"&quote in pDoc
   return pDoc
end GetDescription

function ParseOptionalSyntax pSyntaxDefinition
   put 0 into foundStartChar
   put 0 into foundEndChar
   put offset("[",pSyntaxDefinition,foundStartChar) into foundStartChar
   -- answer files broken and making me hit recurstion limits
   if char 1 to foundStartChar of pSyntaxDefinition contains "]" then
      replace "]" with empty in char 1 to foundStartChar of pSyntaxDefinition
      put offset("[",pSyntaxDefinition,0) into foundStartChar
   end if
   if foundStartChar > 0 then
      repeat
         put offset("]",pSyntaxDefinition,foundEndChar) into theChar
         put foundEndChar + theChar into foundEndChar
         if foundEndChar = 0 then
            -- unmatched pairs
            replace "[" with "" in pSyntaxDefinition
            exit repeat
         end if
         put char foundStartChar+1 to foundEndChar-1 of pSyntaxDefinition into theOption
         -- nested optional syntax...
         if "[" is not in theOption then
            exit repeat
         else
            -- check for matching pairs
            put 0 into theBracketCount
            repeat with X = 1 to the number of chars of theOption
               if char X of theOption is "[" then
                  add 1 to theBracketCount
               else if char X of theOption is "]" then
                  subtract 1 from theBracketCount
               end if
            end repeat
            if theBracketCount is 0 then
               exit repeat
            end if
         end if
      end repeat

      if foundEndChar <> 0 then
         -- we found some optional syntax so we need to split the syntax defintion into two
         put pSyntaxDefinition into theOption1
         delete char foundEndChar of theOption1
         delete char foundStartChar of theOption1
         put pSyntaxDefinition into theOption2
         delete char foundStartChar to foundEndChar of theOption2
         put ParseOptionalSyntax(theOption1) into theOption1
         put ParseOptionalSyntax(theOption2) into theOption2
         return theOption1 & cr & theOption2
      end if
   end if

   return pSyntaxDefinition
end ParseOptionalSyntax

function ParseVariationSyntax pSyntaxDefinition
   put 0 into foundStartChar
   put 0 into foundEndChar

   put offset("{",pSyntaxDefinition,foundStartChar) into foundStartChar
   if foundStartChar <> 0 then
      put offset("}",pSyntaxDefinition,foundEndChar) into foundEndChar
      if foundEndChar = 0 then
         exit repeat
      end if
      put char foundStartChar+1 to foundEndChar-1 of pSyntaxDefinition into theVariations

      if foundEndChar <> 0 then
         -- we found an array of variable syntax
         set the itemDelimiter to "|"
         repeat for each item theVariation in theVariations
            put pSyntaxDefinition into theSyntax
            put theVariation into char foundStartChar to foundEndChar of theSyntax
            put ParseVariationSyntax(theSyntax) & cr after theSyntaxes
         end repeat
         return theSyntaxes
      end if
   end if
   return pSyntaxDefinition
end ParseVariationSyntax

function ParseSyntaxDefinition pSyntaxDefinition
   local theSyntaxes
   replace "..." with "" in pSyntaxDefinition

   put ParseOptionalSyntax(pSyntaxDefinition) into theSyntaxes
   repeat for each line theSyntax in theSyntaxes
      put ParseVariationSyntax(theSyntax) & cr after theParsedSyntaxes
   end repeat
   return theParsedSyntaxes
end ParseSyntaxDefinition

command AddSnippet @pSnippets, pName, pBody, pType, pDescription, pFile
   -- some spacing issues from the syntax parser
   replace space & space with space in pBody
   if pBody ends with space then
      delete the last char of pBody
   end if
   replace space & space with space in pName
   if pName ends with space then
      delete the last char of pName
   end if

   put kBaseIndent & kIndent & kIndent into tIndent

   put tIndent&"{" & cr into theSnippet

   replace quote with "\"&quote in pBody

   if the number of lines of pBody > 1 then
      put "'''" & cr before pBody
      put cr & "'''" after pBody

      repeat with theIndex = 2 to the number of lines of pBody
         put tIndent & kIndent before line theIndex of pBody
      end repeat
   else
      put "'" & pBody & "'" into pBody
   end if

   # I assume this is based on the lcdoc filename... hope so
   set the itemDelimiter to "."
   put "https://livecode.com/resources/api/#livecode_script/"&item 1 of pFile into theMoreURL

   put tIndent & kIndent & "type: '" & pType & "'" & cr after theSnippet
   put tIndent & kIndent & "snippet: " & pBody & cr after theSnippet
   put tIndent & kIndent & "description: '" & pDescription & "'" & cr after theSnippet
   put tIndent & kIndent & "descriptionMoreURL: '" & theMoreURL & "'" & cr after theSnippet

   put tIndent&"}" after theSnippet

   put cr & theSnippet after pSnippets

end AddSnippet

{BufferedProcess, CompositeDisposable} = require 'atom'

module.exports =
  config:
    executablePath:
      type: 'string'
      title: 'LiveCode Server Engine Path'
      default: 'livecode-server' # Let OS's $PATH handle the rest
      description: 'Where is your livecode server installed? ' +
        'Default assumes it\'s on $PATH'
    explicitVars:
      type: 'boolean'
      title: 'Explicit Variables'
      default: 'false'
      description: 'Get errors on undeclared variables'
    lcCompilePath:
      type: 'string'
      title: 'Compiler Path For LiveCode Builder'
      default: switch
        when process.platform == 'darwin'
        then '~/livecode/_build/mac/Debug/lc-compile'
        when process.platform == 'linux'
        then '~/livecode/build-linux-x86_64/livecode/out/Debug/lc-compile'
        when process.platform == 'win32'
        then '~/livecode/_build/Win32/Debug/lc-compile.exe'
      description: 'Where is your lc-compile installed? ' +
        'Default assumes it\'s on $PATH'
    modulePaths:
      type: 'string'
      title: 'Module Paths For LiveCode Builder'
      default: switch
        when process.platform == 'darwin'
        then '~/livecode/_build/mac/Debug/modules/lci/'
        when process.platform == 'linux'
        then '~/livecode/build-linux-x86_64/livecode/out/Debug/modules/lci/'
        when process.platform == 'win32'
        then '~/livecode/_build/Win32/Debug/modules/lci/'
      description: 'Where are the modules installed? ' +
        'Default is where they should be after building ' +
        'a debug build of LiveCode. Delimit paths with `;`.'

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.observe 'language-livecode.executablePath',
      (executablePath) =>
        @executablePath = executablePath
    @subscriptions.add atom.config.observe 'language-livecode.explicitVars',
      (explicitVars) =>
        @explicitVars = explicitVars
    @subscriptions.add atom.config.observe 'language-livecode.lcCompilePath',
      (lcCompilePath) =>
        @lcCompilePath = lcCompilePath
    @subscriptions.add atom.config.observe 'language-livecode.modulePaths',
      (modulePaths) =>
        @modulePaths = modulePaths
    path = require 'path'
    @linterPath = path.join(__dirname, '..', 'tools', 'Linter.lc')
    @notified = false

  deactivate: ->
    @subscriptions.dispose()

  provideLinter: ->
    provider =
      grammarScopes: ['source.livecodescript', 'source.iRev', 'source.lcb']
      scope: 'file'
      lintsOnChange: true
      name: 'language-livecode'
      lint: (textEditor) =>
        filePath = textEditor.getPath()
        command = @executablePath
        parameters = []
        stackfile = @linterPath
        parameters.push(stackfile)
        scope = '-scope=' + textEditor.getRootScopeDescriptor()
        parameters.push(scope)
        explicitVariables = '-explicitVariables=' + @explicitVars
        parameters.push(explicitVariables)
        lcCompile = '-lcCompile=' + @lcCompilePath
        parameters.push(lcCompile)
        lcCompileModulePaths = '-modulePaths=' + @modulePaths
        parameters.push(lcCompileModulePaths)
        editorFilePath = '-filepath=' + filePath
        parameters.push(editorFilePath)
        text = textEditor.getText()
        return @exec(command, parameters, {stdin: text}).then (output) ->
          regex = /(\d+),(\d+),(.*)/g
          messages = []
          while((match = regex.exec(output)) isnt null)
            line = match[1]-1
            messages.push
              severity: 'error'
              location:
                    file: filePath
                    position: [
                      [
                        line
                        match[2] - 0
                      ]
                      [
                        line
                        textEditor.getBuffer().lineLengthForRow(line)
                      ]
                    ]
              excerpt: match[3]
          return messages

  exec: (command, args = [], options = {}) ->
    return new Promise (resolve, reject) ->
      data = stdout: [], stderr: []
      stdout = (output) -> data.stdout.push(output.toString())
      stderr = (output) -> data.stderr.push(output.toString())
      exit = ->
        resolve(data.stdout.join(''))
      handleError = (errorObject) ->
        errorObject.handle()
        if !@notified
          atom.notifications.addWarning(
            'Please check you have LiveCode Server installed correctly',
            {
              detail: 'LiveCode Server is required for linting your files\n' +
              'edit the location in the package settings'
            }
            )
          @notified = true
        resolve('')
      spawnedProcess = new BufferedProcess({command, args, options, stdout, stderr, exit})
      spawnedProcess.onWillThrowError(handleError)
      if options.stdin
        spawnedProcess.process.stdin.write(options.stdin.toString())
        spawnedProcess.process.stdin.end() # We have to end it or the programs will keep waiting forever

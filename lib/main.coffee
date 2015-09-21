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

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.observe 'language-livecode.executablePath',
      (executablePath) =>
        @executablePath = executablePath
    @subscriptions.add atom.config.observe 'language-livecode.explicitVars',
      (explicitVars) =>
        @explicitVars = explicitVars
    path = require 'path'
    @linterPath = path.join(__dirname, '..', 'tools', 'Linter.lc')
    @notified = false

  deactivate: ->
    @subscriptions.dispose()

  provideLinter: ->
    provider =
      grammarScopes: ['source.livecodescript', 'source.iRev']
      scope: 'file'
      lintOnFly: true
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
        text = textEditor.getText()
        return @exec(command, parameters, {stdin: text}).then (output) ->
          regex = /(\d+),(\d+),(.*)/g
          messages = []
          while((match = regex.exec(output)) isnt null)
            line = match[1]-1
            messages.push
              type: "Error"
              filePath: filePath
              range: [
                [line, match[2]-0],
                [line, textEditor.getBuffer().lineLengthForRow(line)]
              ]
              text: match[3]
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

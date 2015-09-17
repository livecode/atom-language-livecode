{CompositeDisposable} = require 'atom'

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

  deactivate: ->
    @subscriptions.dispose()

  provideLinter: ->
    helpers = require('atom-linter')
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
        return helpers.exec(command, parameters, {stdin: text}).then (output) ->
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

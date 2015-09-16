{CompositeDisposable} = require 'atom'

module.exports =
  config:
    executablePath:
      type: 'string'
      title: 'LiveCode Server Engine Path'
      default: 'livecode-server' # Let OS's $PATH handle the rest

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.observe 'language-livecode.executablePath',
      (executablePath) =>
        @executablePath = executablePath
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
          text = textEditor.getText()
          return helpers.exec(command, parameters, {stdin: text}).then (output) ->
            regex = /(\d+),(\d+),(.*)/g
            messages = []
            while((match = regex.exec(output)) isnt null)
              messages.push
                type: "Error"
                filePath: filePath
                range: [[match[1]-1, match[2]-0],[match[1]-1, textEditor.getBuffer().lineLengthForRow(match[1]-1)]]
                text: match[3]
            return messages

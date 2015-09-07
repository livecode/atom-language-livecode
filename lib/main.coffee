{CompositeDisposable} = require 'atom'

module.exports =
  config:
    executablePath:
      type: 'string'
      title: 'LiveCode Standalone Engine Path'
      default: 'livecode' # Let OS's $PATH handle the rest

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.observe 'language-livecode.executablePath',
      (executablePath) =>
        @executablePath = executablePath
    path = require 'path'
    @linterPath = path.join(__dirname, '..', 'tools', 'Linter.livecodescript')

  deactivate: ->
    @subscriptions.dispose()

  provideLinter: ->
    helpers = require('atom-linter')
    provider =
      grammarScopes: ['source.livecodescript']
      scope: 'file'
      lintOnFly: true
      lint: (textEditor) =>
          filePath = textEditor.getPath()
          command = @executablePath
          parameters = []
          parameters.push('-ui')
          stackfile = @linterPath
          parameters.push(stackfile)
          text = textEditor.getText()
          return helpers.exec(command, parameters, {stdin: text}).then (output) ->
            regex = /(\d+),(.*)/g
            messages = []
            while((match = regex.exec(output)) isnt null)
              messages.push
                type: "Error"
                filePath: filePath
                range: helpers.rangeFromLineNumber(textEditor, match[1]-1)
                text: match[2]
            return messages

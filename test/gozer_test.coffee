express = require('express')
Gozer = require('../src/gozer')

startServer = (options = {}) ->
  app = express()
  app.use(express.static(__dirname + '/app'))
  app.listen(options.port || 80)

describe 'Gozer', ->
  gozer = page = null

  before ->
    startServer(port: 3002)
    gozer = new Gozer(port: 3002)

  beforeEach ->
    page = gozer
      .visit('/')
      .resize(width: '1024')

  describe 'HTML tests', ->
    it 'can evaluate the document markup', ->
      expect(page.run(-> document.title))
        .to.eventually.equal('Gozer')

  describe 'CSS tests', ->
    it 'can manually retrieve computed styles', ->
      fontFamily = page.run ->
        getComputedStyle(document.body).getPropertyValue('font-family')
      expect(fontFamily)
        .to.eventually.have.string('Helvetica Neue')

    it 'can retrieve computed styles with a helper', ->
      expect(page.getStyle('body', 'font-family'))
        .to.eventually.have.string('Helvetica Neue')

    context 'with breakpoints', ->
      it 'retrieves the computed style', ->
        expect(page.getStyle('body', 'font-size'))
          .to.eventually.equal('16px')

        page.resize(width: 600)

        expect(page.getStyle('body', 'font-size'))
          .to.eventually.equal('12px')
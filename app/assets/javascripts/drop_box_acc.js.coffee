# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
class DropboxSave
# @param {Dropbox.Client} dbClient a non-authenticated Dropbox client
# @param {DOMElement} root the app's main UI element
  constructor: (@dbClient, @root) ->
    @$root = $ @root
    $('#signout-button').click (event) => @onSignOut event

    @dbClient.authenticate (error, data) =>
      return @showError(error) if error
      @dbClient.getUserInfo (error, userInfo) =>
        return @showError(error) if error

  upload:  (path,filename,data) ->
    target_file = path + "/" + filename
    @dbClient.writeFile(target_file,data,null,@writefilecallback)


  onSignOut: (event, task) ->
    @dbClient.signOut (error) =>
      return @showError(error) if error
      window.location.reload()


  writefilecallback: (functionObj)  ->
    alert('test alert: dropbox callback received')


@savedrop = ->
  client = new Dropbox.Client(
    key: 'LpbwnTiZg2A=|ck2jOpTJHxVv34pNbef8HTKiBZeSp6R8zuIbcPShCQ==', sandbox: true)
  client.authDriver new Dropbox.Drivers.Redirect(rememberUser: true)
  window.dropbox = new DropboxSave client, '#app-ui'
  i = 0
  @xhreq = []
  while i < window.linkArray.length
    @pos = window.linkArray[i].indexOf(":")
    @photo_url = window.linkArray[i].substr(@pos + 3)
    @photo_url = "http://mylaicosproxy.herokuapp.com/?src="+@photo_url
    @xhreq[i] = new XMLHttpRequest()
    @xhreq[i].open('GET',@photo_url,true)
   # @xhreq[i].open('GET',window.linkArray[i],true)
    @xhreq[i].responseType = 'blob';
    @xhreq[i].onload = ->
      if (this.status == 200)
        window.dropbox.upload("first_photo","first_photo.png",this.response)

    @xhreq[i].send();
    i++

$ ->
  window.savelinks = []
  window.linkArray = []
  nameArray = document.getElementsByName("uploadlinks")
  for refLinks in nameArray
    imageTag = refLinks.children[0]
    window.linkArray.push imageTag.src


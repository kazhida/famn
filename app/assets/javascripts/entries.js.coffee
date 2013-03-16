# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(($)->
  $('#more')
    .live("ajax:complete", (xhr)->
      $('#more-debug').html('Done.')
    )
    .live("ajax:beforeSend", (xhr)->
      $('#more-debug').html('Loading...')
      $('#time').append('<div>Loading...</div>')
    )
    .live("ajax:success", (event, data, status, xhr)->
      $('#more-debug').html('Yeah!')
    )
    .live("ajax:error", (data, status, xhr)->
      alert("failure!!!")
    )
)
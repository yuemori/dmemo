timeoutId = undefined
markdownEditor = ->
  if timeoutId
    clearTimeout(timeoutId)
    timeoutId = undefined
  $editor = $(this)
  timeoutId = setTimeout(=>
    $.ajax("/markdown_preview",
      type: "POST",
      data:
        md: $editor.val(),
      success: (data)->
        $($editor.data("target")).html(data.html)
    )
  , 300)

$(document).ready(->
  $(".markdown-editor").on('keyup', markdownEditor)
  $(document).bind('cbox_complete', ->
    $("#colorbox .markdown-editor").on('keyup', markdownEditor)
  )

  $("a.colorbox").colorbox(closeButton: false, width: "600px", maxWidth: "1200px")

  $(".unfavorite-table-link").on("ajax:success", (data)->
    console.log(data)
    $(".favorite-table-block").addClass("unfavorited")
    $(".favorite-table-block").removeClass("favorited")
  )

  $(".favorite-table-link").on("ajax:success", (data)->
    console.log(data)
    $(".favorite-table-block").addClass("favorited")
    $(".favorite-table-block").removeClass("unfavorited")
  )

  $("#data_source_adapter").change(()->
    adapter = $("#data_source_adapter").val()
    console.log adapter

    if adapter == 'bigquery'
      $('.bigquery').removeClass('hidden')
      $('.database').addClass('hidden')
    else
      $('.bigquery').addClass('hidden')
      $('.database').removeClass('hidden')
  )

  $('form').on 'click', '.remove_fields', (event) ->
    $(this).closest('fieldset').find('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $('.fieldset').append($(this).data('fields').replace(regexp, time))
    event.preventDefault()
)

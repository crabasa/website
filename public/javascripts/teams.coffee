# unbind infinite scrolling on pjax
$(document).bind 'start.pjax', ->
  $('#page.teams ul.teams, #page.teams-entries ul.teams').data('infinitescroll')?.unbind()

load = ->
  $('#page.teams, #page.teams-entries').each ->
    $('ul.teams').infinitescroll
      navSelector: '.more'
      nextSelector: '.more a'
      itemSelector: 'ul.teams > li'
      loading:
        img: '/images/spinner.gif'
        msgText: ''
        speed: 50
        finished: (opts) -> opts.loading.msg.hide()
        finishedMsg: 'No more teams. :('

  $('#page.teams-show').each ->
    # re-send invites
    $(this).delegate '.invites a', 'click', (e) ->
      e.preventDefault()
      e.stopImmediatePropagation()
      $t = $(this).hide()
      $n = $t.next().show().html 'sending&hellip;'
      $.post @href, ->
        $n.text('done').delay(500).fadeOut 'slow', -> $t.show()

    # deploy instructions
    $('.step')
      .addClass(-> $(this).attr('id'))
      .removeProp('id')
    $('ul.steps a').click (e) ->
      if location.hash == $(this).attr('href')
        e.preventDefault()
        location.hash = 'none'
    $(window).hashchange (e) ->
      if hash = location.hash || $('ul.steps li.pending:first a').attr('href')
        $('.step')
          .hide()
          .filter(hash.replace('#', '.'))
            .show()
        $('ul.steps a')
          .removeClass('selected')
          .filter('a[href="' + hash + '"]')
            .addClass('selected')
    .hashchange()

  $('#page.teams-edit').each ->

    # show the delete box on load if the hash is delete
    if window.location.hash is '#delete'
      window.location.hash = ''
      $form = $('#inner form:first')
      pos = $form.position()
      $delete = $('form.delete').show()
      $delete.css
        left: pos.left + ($form.width() - $delete.outerWidth()) / 2
        top: pos.top

    $('a.pull', this).click ->
      li = $(this).closest('li')
      i = li.prevAll('li').length + 1
      li.html $('<input>',
        class: 'email'
        type: 'email'
        name: 'emails[]'
        placeholder: 'member' + i + '@example.com')
      false

$(load)
$(document).bind 'end.pjax', load

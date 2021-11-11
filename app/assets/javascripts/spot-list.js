/*global $*/

let list = []
let index;
let oldIndex;

$(() => {
  $( ".spot-list__list" ).sortable({
    opacity: 0.5,
    scroll: false,
    update: (event, ui) => {
      if (ui.sender == null) {
        console.log("update");
        list = $(".spot-list__list").sortable("toArray");
        // Ajux
        $.ajax({
          type: "PATCH",
          url: location.pathname.replace("/edit", ""),
          data: { ids: list },
          dataType : "script",
        })
        // Ajaxリクエストが成功した場合
        .done(function(data){
        })
        // Ajaxリクエストが失敗した場合
        .fail(function(XMLHttpRequest, textStatus, errorThrown){
          alert(errorThrown);
        });
      }
    },
    receive: (event, ui) => {
      console.log("receive");
      console.log(ui);
      let placeId = ui.item[0].id;
      index = $(".spot-list__list").children().index(ui.item[0]);
      // Ajux
      $.ajax({
        type: "POST",
        url: location.pathname.replace("edit", "spots"),
        data: {
          place_id: placeId,
          index: index,
        },
        dataType : "script",
      })
      // Ajaxリクエストが成功した場合
      .done(function(data){
      })
      // Ajaxリクエストが失敗した場合
      .fail(function(XMLHttpRequest, textStatus, errorThrown){
        alert(errorThrown);
      });
    },
  });
});

$(() => {
  $( ".place-list__list" ).sortable({
    opacity: 0.5,
    scroll: false,
    connectWith: ".spot-list__list",
    });
});
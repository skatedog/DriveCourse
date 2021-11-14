/*global $*/

let oldSortNumber
let newSortNumber
let newPlaceId


$(() => {
  $(document).on("change", "#course_avoid_highways", function() {
    if ($(this).prop("checked")) {
      avoidHighways = true;
    } else {
      avoidHighways = false;
    }
    updateMap(spots);
  });
  $(document).on("change", "#course_avoid_tolls", function() {
    if ($(this).prop("checked")) {
      avoidTolls = true;
    } else {
      avoidTolls = false;
    }
    updateMap(spots);
  });
  $(document).on("change", "#course_departure", function() {
    departureTime = new Date($(this).val())
    if (departureTime < Date.now()) {
      alert("出発日時は未来の日時を設定してください。");
    } else if (spots.length >= 2) {
      updateMap(spots);
    }
  });
  $( ".place-list__list" ).sortable({
    opacity: 0.5,
    scroll: false,
    connectWith: ".spot-list__list",
    });
  // 削除
  $(document).on("click", ".spot-list__item-delete", function() {
    oldSortNumber = $(this).parent().attr("id")
    let placeName = spots[oldSortNumber].name;

    spots.splice(oldSortNumber, 1)
    spots.forEach((spot) => {
      if (spot.sort_number > oldSortNumber) {
        spot.sort_number --;
      }
    });

    $(this).parent().remove();

    let newPlace = places.find((place) => {
      return place.name == placeName;
    });

    $(".place-list__list").append(`<li id=${newPlace.id} class="place-list__item ui-sortable-handle">${newPlace.name}</li>`);

    sortSpots(spots);
    refreshItemIds();
    updateMap(spots);
  });
  $( ".spot-list__list" ).sortable({
    opacity: 0.5,
    scroll: false,
    update: (event, ui) => {
      // 並び替え
      if (ui.sender == null) {
        oldSortNumber = ui.item[0].id;
        newSortNumber = $(".spot-list__list").children().index(ui.item[0]);
        spots.forEach((spot) => {
          if (spot.sort_number == oldSortNumber) {
            spot.sort_number = newSortNumber;
          } else if (oldSortNumber < spot.sort_number && spot.sort_number <= newSortNumber) {
            spot.sort_number --;
          } else if (oldSortNumber > spot.sort_number && spot.sort_number >= newSortNumber) {
            spot.sort_number ++;
          }
        })
      }
      sortSpots(spots);
      refreshItemIds();
      updateMap(spots);
    },
    receive: (event, ui) => {
      // 追加
      newPlaceId = ui.item[0].id;
      newSortNumber = $(".spot-list__list").children().index(ui.item[0]);
      spots.forEach((spot) => {
        if (spot.sort_number >= newSortNumber) {
          spot.sort_number ++;
        }
      });
      let placeInfo = places.find((place) => {
        return place.id == newPlaceId;
      });
      let newSpot = Object.assign({}, placeInfo)
      delete newSpot.id;
      newSpot.sort_number = newSortNumber;
      spots.push(newSpot);
    	$(".spot-list__list").children().eq(newSortNumber).append("<button class='spot-list__item-delete'>削除</button>");
    	$(".spot-list__list").children().eq(newSortNumber).addClass("ui-sortable-handle");
    },
  });
});

const sortSpots = (spots) => {
  spots.sort((a, b) => {
		return a.sort_number - b.sort_number;
	});
}

const refreshItemIds = () => {
  $(".spot-list__list").children().each((i, item) =>{
    $(item).attr("id", i);
  });
  $("#course_spots").val(JSON.stringify(spots));
}
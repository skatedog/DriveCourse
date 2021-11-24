/*global $*/

$(() => {
  // 「マイプレイス」内のプレイスタグをドラッグアンドドロップ可能にする。
  $( ".place-list__list--place" ).sortable({
    opacity: 0.5,
    scroll: false,
    connectWith: ".place-list__list--spot", // 「ドライブコース」内にドロップ可能にする。
    });

  // 「ドライブコース」内のスポットタグをドラッグアンドドロップ可能にする。
  $( ".place-list__list--spot" ).sortable({
    opacity: 0.5,
    scroll: false,
    receive: (event, ui) => {
      // 「マイプレイス」からプレイスタグを受け取った場合の処理
      // プレイスタグが何番目に追加されたかを取得する。
      let newSortNumber = $(".place-list__list--spot").children().index(ui.item[0]);

      // 追加されたプレイスタグ以降のスポットタグの順番を更新する。
      spots.forEach((spot) => {
        if (spot.sort_number >= newSortNumber) {
          spot.sort_number ++;
        }
      });

      // 追加されたプレイスの情報を取得する。
      let placeInfo = places.find((place) => {
        return place.id == ui.item[0].id;
      });

      // プレイスの情報をスポット配列に追加する。
      let newSpot = Object.assign({}, placeInfo)
      delete newSpot.id;
      newSpot.sort_number = newSortNumber;
      spots.push(newSpot);

      // プレイスタグをスポットタグに変更する。
      let newSpotItem = $(".place-list__list--spot").children().eq(newSortNumber);
      newSpotItem.empty();
    	newSpotItem.append("<div class='place-list__text'>" + newSpot.name + "</div>");
    	newSpotItem.append("<button class='place-list__item-delete'>×</button>");
    	newSpotItem.attr("class", "place-list__item ui-sortable-handle");
    },
    update: (event, ui) => {
      // 「ドライブコース」内のスポットタグが更新された場合の処理
      if (ui.sender == null) {
        // 並び替えされた場合のみ実行する処理
        // 移動前後の順番を基にスポットタグの情報を更新する。
        let oldSortNumber = ui.item[0].id;
        let newSortNumber = $(".place-list__list--spot").children().index(ui.item[0]);
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
      refreshSpots(spots);
      updateCourseMap(spots);
    },
  });

  // 「高速道路を使わない」の状態が変化した場合の処理
  $(document).on("change", "#course_avoid_highways", function() {
    if ($(this).prop("checked")) {
      avoidHighways = true;
    } else {
      avoidHighways = false;
    }
    updateCourseMap(spots);
  });

  // 「高速道路を使わない」の状態が変化した場合の処理
  $(document).on("change", "#course_avoid_tolls", function() {
    if ($(this).prop("checked")) {
      avoidTolls = true;
    } else {
      avoidTolls = false;
    }
    updateCourseMap(spots);
  });

  // 「出発日時」の状態が変化した場合の処理
  $(document).on("change", "#course_departure", function() {
    departureTime = new Date($(this).val())
    if (departureTime < Date.now()) {
      alert("出発日時は未来の日時を設定してください。");
    } else if (spots.length >= 2) {
      updateCourseMap(spots);
    }
  });

  // 「ドライブコース」内のスポットタグの削除ボタンが押された場合の処理
  $(document).on("click", ".place-list__item-delete", function() {
    // 削除するスポットタグの順番と名前を取得する。
    let oldSortNumber = $(this).parent().attr("id")
    let placeName = spots[oldSortNumber].name;

    // 削除するスポットタグより後ろのスポットの順番を更新する。
    spots.splice(oldSortNumber, 1)
    spots.forEach((spot) => {
      if (spot.sort_number > oldSortNumber) {
        spot.sort_number --;
      }
    });

    // スポットタグを削除する。
    $(this).parent().remove();

    // 削除されたスポットのタグをプレイスに追加する。
    let newPlace = places.find((place) => {
      return place.name == placeName;
    });
    $(".place-list__list--place").append(`<li id=${newPlace.id} class="place-list__item ui-sortable-handle">${newPlace.name}</li>`);

    refreshSpots(spots);
    updateCourseMap(spots);
  });
});

const refreshSpots = (spots) => {
  // スポット配列内の順番を並び替える。
  spots.sort((a, b) => {
		return a.sort_number - b.sort_number;
	});

	// 「ドライブコース」内のスポットタグの順番IDを振りなおす。
  $(".place-list__list--spot").children().each((i, item) =>{
    $(item).attr("id", i);
  });
  $("#course_spots").val(JSON.stringify(spots));
}

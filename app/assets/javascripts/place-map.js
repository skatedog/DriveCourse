/*global $*/
/*global google*/

let map;
let marker;
let geocoder;

// プレイスマップを初期化する。
function initPlaceMap() {
  map = initMap();
  marker = setMarker(map);
  geocoder = new google.maps.Geocoder();

  // markerをdragできるようにする。
  marker.setOptions({ draggable: true });

  // markerがdragされた場合の処理。
  google.maps.event.addListener(marker, "dragend", (event) => {
    // markerの座標を基に地図とフォームの値を更新する。
    changeByLatLng(event.latLng);
  });

  // mapがclickされた場合の処理。
  google.maps.event.addListener(map, "click", (event) => {
    // clickされた位置の座標を基に地図とフォームの値を更新する。
    changeByLatLng(event.latLng);
  });
}

$(() => {
  // プレイスリストのプレイスがクリックされた場合の処理。
  $(document).on("click", ".place-list__item--place", function() {
    // idからプレイスの座標を取得し、地図とフォームの値を更新する。
    let id = $(this).attr("id");
    let place = places.find((place) => {
      return place.id == id;
    });
    let latLng = new google.maps.LatLng(place.latitude, place.longitude);
    changeByLatLng(latLng);
  });

  // プレイス検索ボタンが押された場合の処理。
  $("#place-search-button").on("click", function() {
    // geocoderで検索ワードから座標と住所を割り出し、地図とフォームの値を更新する。
    let word = document.getElementById("place-search-word").value;
    geocoder.geocode( { address: word }, (results, status) => {
      if (status == 'OK') {
        let latLng = results[0].geometry.location;
        let address = results[0].formatted_address.replace(/^日本、(〒\d{3}-\d{4} )?/,"");
        UpdatePlaceMap(latLng, address);
        $("#place_name").val(word);
      } else {
        alert('Geocode was not successful for the following reason: ' + status);
      }
    });
  });
});

// 地図とフォームの値を更新する。
const changeByLatLng = (latLng) => {
  geocoder.geocode( { latLng: latLng }, (results, status) => {
    if (status == 'OK') {
      let address = results[0].formatted_address.replace(/^日本、(〒\d{3}-\d{4} )?/,"");
      UpdatePlaceMap(latLng, address);
    } else {
      alert('Geocode was not successful for the following reason: ' + status);
    }
  });
}

// viewと地図を更新する。
const UpdatePlaceMap = (latLng, address) => {
  let lat = latLng.lat();
  let lng = latLng.lng();
  $("#place_latitude").val(lat);
  $("#place_longitude").val(lng);
  $("#place_address").val(address);
  map.panTo(latLng);
  marker.setPosition(latLng);
}

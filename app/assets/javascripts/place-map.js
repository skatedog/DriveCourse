/*global $*/
/*global google*/

let map;
let marker;
let geocoder;

function initPlaceMap() {
  map = initMap(lat, lng);
  marker = setMarker(map, lat, lng);
}

function initEditablePlaceMap() {
  map = initMap(lat, lng);
  marker = setMarker(map, lat, lng);
  geocoder = new google.maps.Geocoder();

  // markerをdragできるようにする
  marker.setOptions({ draggable: true });

  // markerがdragされた場合の処理
  google.maps.event.addListener(marker, "dragend", (event) => {
    changeByLatLng(event.latLng);
  });

  // mapがclickされた場合の処理
  google.maps.event.addListener(map, "click", (event) => {
    changeByLatLng(event.latLng);
  });
}

// 引数:座標, 機能:地図を初期化する, 返値:mapオブジェクト
const initMap = (lat = 35.68124, lng = 139.76658) => {
  let latLng = new google.maps.LatLng(lat, lng);
  let opts = {
    zoom: 15,
    center: latLng,
  };
  return new google.maps.Map(document.getElementById("map"), opts);
}

// 引数:mapオブジェクトと座標, 機能:地図にマーカーをセットする, 返値:markerオブジェクト
const setMarker = (map, lat = 35.68124, lng = 139.76658) => {
  let latLng = new google.maps.LatLng(lat, lng);
  let opts = {
    position: latLng,
    map: map,
  }
  return new google.maps.Marker(opts);
}

// 座標を基にviewと地図を更新する
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

// 検索ワードを基にviewと地図を更新する
const ChangeByFormWord = () => {
  let word = document.getElementById("form_word").value;
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
}

// viewと地図を更新する
const UpdatePlaceMap = (latLng, address) => {
  let lat = latLng.lat();
  let lng = latLng.lng();
  $("#place_latitude").val(lat);
  $("#place_longitude").val(lng);
  $("#place_address").val(address);
  map.panTo(latLng);
  marker.setPosition(latLng);
}

$(() => {
  $(document).on("click", ".place-list__item--place", function() {
    let id = $(this).attr("id");
    let place = places.find((place) => {
      return place.id == id;
    });
    let latLng = new google.maps.LatLng(place.latitude, place.longitude);
    changeByLatLng(latLng);
  });
});
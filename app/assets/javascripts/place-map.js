/*global google*/
/*global $*/

var map;
var marker;

// 地図を初期化する
const initPlaceMap = () => {
  var latLng = new google.maps.LatLng(lat,lng);
  var opts = {
    zoom: 15,
    center: latLng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById("map"), opts);
  marker = new google.maps.Marker({
    position: latLng,
    map: map
  });
}

// 地図を初期化する
const initEditablePlaceMap = () => {
  var latLng = new google.maps.LatLng(lat,lng);
  var opts = {
    zoom: 15,
    center: latLng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById("map"), opts);
  marker = new google.maps.Marker({
    position: latLng,
    map: map,
    draggable: true
  });
  // 地図がクリックされた場合の処理
  google.maps.event.addListener(map, "click", (event) => {
    getAddress(event.latLng);
  });

  // マーカーが動かされた場合の処理
  google.maps.event.addListener(marker, "dragend", (event) => {
    getAddress(event.latLng);
  });
}

// 座標から住所を検索する。
const getAddress = (latLng) => {
  var geocoder = new google.maps.Geocoder();
  geocoder.geocode( { latLng: latLng }, (results, status) => {
    if (status == 'OK') {
      let address = results[0].formatted_address.replace(/^日本、(〒\d{3}-\d{4} )?/,"");
      $("#place_address").val(address);
      changeLatLng(latLng)
    } else {
      alert('Geocode was not successful for the following reason: ' + status);
    }
  });
}

// 検索フォーム(#form_word)の住所から緯度と経度を取得し、その座標に移動する。
const panToFormWord = () => {
  var word = document.getElementById("form_word").value;
  var geocoder = new google.maps.Geocoder();
  geocoder.geocode( { address: word }, (results, status) => {
    if (status == 'OK') {
      let latLng = results[0].geometry.location;
      let address = results[0].formatted_address.replace(/^日本、(〒\d{3}-\d{4} )?/,"");
      $("#place_name").val(word);
      $("#place_address").val(address);
      changeLatLng(latLng)
    } else {
      alert('Geocode was not successful for the following reason: ' + status);
    }
  });
}

// 指定した座標にマーカーと中心を移動し、hidden_fieldの値を書き換える。
const changeLatLng = (latLng) => {
  let lat = latLng.lat();
  let lng = latLng.lng();
  $("#place_latitude").val(lat);
  $("#place_longitude").val(lng);
  map.panTo(latLng);
  marker.setPosition(latLng);
}
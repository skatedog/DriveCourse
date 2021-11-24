// 引数の座標で地図を初期化しマップオブジェクトを返す。デフォルトの座標は東京駅を設定。
const initMap = (lat = 35.68124, lng = 139.76658) => {
  let latLng = new google.maps.LatLng(lat, lng);
  let opts = {
    zoom: 15,
    center: latLng,
  };
  return new google.maps.Map(document.getElementById("map"), opts);
}

// マップオブジェクトにマーカーをセットする。
const setMarker = (map, lat, lng) => {
  let latLng = new google.maps.LatLng(lat, lng);
  let opts = {
    position: latLng,
    map: map,
  }
  return new google.maps.Marker(opts);
}

/*global $*/
/*global google*/

let directionsService;
let directionsRenderer;

// コースマップを初期化する。
function initCourseMap() {
	directionsService = new google.maps.DirectionsService();
	directionsRenderer = new google.maps.DirectionsRenderer();
	switch (spots.length) {
		case 0:
			map = initMap();
			break;
		case 1:
			map = initMap(spots[0].latitude, spots[0].longitude);
			break;
		default:
			map = initMap(spots[0].latitude, spots[0].longitude);
			updateCourseMap(spots);
	}
}

// 与えられたスポットの情報を基にコースマップを更新する。
const updateCourseMap = (spots) => {
	switch (spots.length) {
		case 0:
			marker.setMap(null);
			break;
		case 1:
			directionsRenderer.setMap(null);
			marker = setMarker(map, spots[0].latitude, spots[0].longitude);
			map.panTo(new google.maps.LatLng(spots[0].latitude, spots[0].longitude));
			map.setZoom(15);
			break;
		default:
			if (!(typeof marker === "undefined")) { marker.setMap(null); }
			let length = spots.length;

			// 出発地の座標
			let originLatLng = new google.maps.LatLng(spots[0].latitude, spots[0].longitude);

			// 目的地の座標
			let destinationLatLng = new google.maps.LatLng(spots[length - 1].latitude, spots[length - 1].longitude);

			// 経由地の座標
			let waypoints = [];
			let waypointsInfo = spots.slice(1, length -1);
			for (let i = 0; i < waypointsInfo.length; i++) {
				waypoints.push({
					location: new google.maps.LatLng(waypointsInfo[i].latitude, waypointsInfo[i].longitude),
					stopover: true
				});
			}

			// ルート検索条件
			let request = {
				origin: originLatLng,
				destination: destinationLatLng,
				waypoints: waypoints,
				travelMode: google.maps.TravelMode.DRIVING,
				avoidHighways: avoidHighways,
				avoidTolls: avoidTolls,
				drivingOptions: {
					departureTime: new Date(departureTime)
				},
			};

			// ルート検索
			directionsService.route(request, (result, status) => {
				if (status == google.maps.DirectionsStatus.OK) {
					directionsRenderer.setOptions({
						preserveViewport: false
					});

					// 検索の戻り値(result)の値を加工し、マーカーをクリックしたときに表示される文字を変更する。
					// 検索結果を変数に入れる。
					let legs = result.routes[0].legs

					// 所要時間を計算するための変数を初期化する。
					let totalDurationValue = 0;

					// 追加距離を計算するための変数を初期化する。
					let totalDistanceValue = 0;

					// 出発地に表示する文字
					legs[0].start_address = spots[0].name;

					for(let i = 0; i < legs.length; i++) {
						let duration = legs[i].duration.text
						let distance = legs[i].distance.text

						totalDurationValue += legs[i].duration.value;
						totalDistanceValue += legs[i].distance.value;

						let totalDuration = toDuration(totalDurationValue);
						let totalDistance = toDistance(totalDistanceValue);

						let info = spots[i + 1].name
											 + "<br><br>[前地点から]<br>&nbsp;所要時間：" + duration
											 + "<br>&nbsp;移動距離：" + distance
											 + "<br><br>[出発地から]<br>&nbsp;所要時間：" + totalDuration
											 + "<br>&nbsp;移動距離：" + totalDistance;

						if (i < legs.length - 1) {
							// 途中に表示する文字
							legs[i + 1].start_address =  info;
						} else {

							// 目的地に表示する文字
							legs[i].end_address = info;
						}
					}

					// ルート検索結果を基にルートを更新する。
					directionsRenderer.setDirections(result);
					directionsRenderer.setMap(map);
				}
			});
	}
}

// 〇秒を〇時間〇分に変換する。
const toDuration = (value) => {
	let h = Math.floor(value / (60 * 60));
	let m = Math.round(value % (60 * 60) / (60))
	if (h == 0) {
		return m + "分";
	} else {
		return h + "時間" + m + "分";
	}
}

// 〇mを〇.〇kmに変換する。
const toDistance = (value) => {
	return Math.round(value / 1000 * 10) / 10 + " km"
}

/*global $*/
/*global google*/

let directionsService;
let directionsRenderer;

function initEditableCourseMap() {
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
			updateMap(spots);
	}
}

const updateMap = (spots) => {
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

			let originLatLng = new google.maps.LatLng(spots[0].latitude, spots[0].longitude);
			let destinationLatLng = new google.maps.LatLng(spots[length - 1].latitude, spots[length - 1].longitude);

			let waypoints = [];
			let waypointsInfo = spots.slice(1, length -1);
			for (let i = 0; i < waypointsInfo.length; i++) {
				waypoints.push({
					location: new google.maps.LatLng(waypointsInfo[i].latitude, waypointsInfo[i].longitude),
					stopover: true
				});
			}

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

			directionsService.route(request, (result, status) => {
				if (status == google.maps.DirectionsStatus.OK) {
					directionsRenderer.setOptions({
						preserveViewport: false
					});

					let legs = result.routes[0].legs
					let totalDurationValue = 0;
					let totalDistanceValue = 0;
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
							legs[i + 1].start_address =  info + "途中";
						} else {
							legs[i].end_address = info + "最後";
						}
					}
					directionsRenderer.setDirections(result);
					directionsRenderer.setMap(map);
				}
			});
	}
}

const toDuration = (value) => {
	let h = Math.floor(value / (60 * 60));
	let m = Math.round(value % (60 * 60) / (60))
	if (h == 0) {
		return m + "分";
	} else {
		return h + "時間" + m + "分";
	}
}

const toDistance = (value) => {
	return Math.round(value / 1000 * 10) / 10 + " km"
}

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
			if (!typeof marker === undefined) { marker.setMap(null); }
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
					directionsRenderer.setDirections(result);
					directionsRenderer.setMap(map);
				}
			});
	}
}

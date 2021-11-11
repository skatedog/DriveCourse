/*global $*/
/*global google*/

let directionsService;
let directionsRenderer;

function initEditableCourseMap() {
  map = initMap();
	directionsService = new google.maps.DirectionsService();
	directionsRenderer = new google.maps.DirectionsRenderer();
	sortSpotList(spotsInfo);
}

const sortSpotList = (spotsInfo) => {
	spotsInfo.sort((a, b) => {
		return a.sortNumber - b.sortNumber;
	});

	let length = spotsInfo.length;

	let originLatLng = new google.maps.LatLng(spotsInfo[0].lat, spotsInfo[0].lng);
	let destinationLatLng = new google.maps.LatLng(spotsInfo[length - 1].lat, spotsInfo[length - 1].lng);

	let waypoints = [];
	let waypointsInfo = spotsInfo.slice(1, length -1);
	for (let i = 0; i < waypointsInfo.length; i++) {
		waypoints.push({
			location: new google.maps.LatLng(waypointsInfo[i].lat, waypointsInfo[i].lng),
			stopover: (waypointsInfo[i].stopover == "true") ? true : false,
		});
	}

	let request = {
		origin: originLatLng,
		destination: destinationLatLng,
		waypoints: waypoints,
		travelMode: google.maps.TravelMode.DRIVING,
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

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){
	$('div#handle').slider({});
	
	var map;
	if (GBrowserIsCompatible()) {
		map = new GMap2(document.getElementById("map"));
		map.setCenter(new google.maps.LatLng(0.0, 0.0), 2);
		map.addControl(new GLargeMapControl3D());
		
		createMarkers(map);
	}
});

function createMarkers(map) {
	$('div#events ul li').each(function() {
		var el = $(this);
		var lat = parseFloat(el.children("input.lat").val());
		var lng = parseFloat(el.children("input.lng").val());
		var date = el.children('span.date').text();
		var desc = el.children('span.desc').text();
		
		if(!(lat == '' || lng == '')) {
			var marker = new GMarker(new GLatLng(lat, lng));
			marker.bindInfoWindowHtml('<h3>'+date+'<h3>'+'<p>'+desc+'</p>');
			
			map.addOverlay(marker);	
		}
	});
}

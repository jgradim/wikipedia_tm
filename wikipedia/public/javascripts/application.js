// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){
	
	var map;
	if (GBrowserIsCompatible()) {
		map = new GMap2(document.getElementById("map"));
		map.setCenter(new google.maps.LatLng(0.0, 0.0), 2);
		map.addControl(new GLargeMapControl3D());
	}
	
});

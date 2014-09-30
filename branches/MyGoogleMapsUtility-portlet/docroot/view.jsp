<%
/**
 * Copyright (c) Pasturenzi Francesco
 * This is the VIEW of the Portlet.
 */
%>


<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<jsp:useBean id="typeUtility" class="java.lang.String" scope="request" />

<jsp:useBean id="chkStreetView" class="java.lang.String" scope="request" />
<jsp:useBean id="chkZoom" class="java.lang.String" scope="request" />
<jsp:useBean id="chkDraggable" class="java.lang.String" scope="request" />
<jsp:useBean id="chkPanControl" class="java.lang.String" scope="request" />
<jsp:useBean id="chkRotateControl" class="java.lang.String" scope="request" />
<jsp:useBean id="chkScaleControl" class="java.lang.String" scope="request" />

<jsp:useBean id="typeMap" class="java.lang.String" scope="request" />

<jsp:useBean id="address" class="java.lang.String" scope="request" />
<jsp:useBean id="descriptionMarker" class="java.lang.String" scope="request" />
<jsp:useBean id="typeIcon" class="java.lang.String" scope="request" />

<jsp:useBean id="fromAddress" class="java.lang.String" scope="request" />
<jsp:useBean id="toAddress" class="java.lang.String" scope="request" />

<jsp:useBean id="notDefinedMessage" class="java.lang.String" scope="request" />

<portlet:defineObjects />

<%
if(typeMap.equals("") || typeMap == null ){
	typeMap = "HYBRID";
}

if(typeUtility.equals("OneMarker") && (typeIcon.equals("") || typeIcon == null) ){
	typeIcon = "marker_classic";
}
%>


<div style="position:relative;margin:auto;width:100%;padding:5px;">
	
	<br>
	<%if(notDefinedMessage.equals("")){ %>
		
		<div  style="width:500px;margin:auto;margin-bottom:0px;">
			<img src="<%=request.getContextPath() %>/images/header_googlemaps.png" style="width:500px;" />
		</div>
		<%if(typeUtility.equals("OneMarker")){ %>
		<div id="mymap" style="width:500px;height:500px;margin:auto;margin-top:0px;margin-bottom:0px;">
		</div>
		<%}else if(typeUtility.equals("GetRoute")){ %>
		<div id="mymap" style="width:500px;height:300px;margin:auto;margin-top:0px;margin-bottom:0px;">
		</div>
		<div id="directionsPanel" style="width:500px;margin:auto;margin-top:0px;margin-bottom:0px;height:200px;overflow:auto;"></div>
		<%} %>
		<div  style="width:500px;margin:auto;margin-bottom:0px;">
			<img src="<%=request.getContextPath() %>/images/footer_googlemaps.png" style="width:500px;margin:auto;" />
		</div>
		
		
	<%}else{ %>
	
		<div class="portlet-msg-alert" style="margin:auto;margin-top:0px;margin-bottom:0px;text-align:center;font-size:16px;color:#FF0000;">
			<%=notDefinedMessage %>
		</div>
		
	<%} %>
	<br>

	<div style="text-align:left;">
		<a href="http://www.pastuweb.com" target="_blank">
		<img src="http://www.pastuweb.com/loghi_pw/icone/pastuweb.png" width="30" alt="Creato da pastuweb.com" title="Creato da pastuweb.com" />
		</a>
	</div>


</div>


<%if(notDefinedMessage.equals("")){ %>
<script type="text/javascript">
	
	var map;
	var marker;
	var infowindow;
	var address;
	var description;	
	var myicon;
	
	var fromAddress;
	var toAddress;
	var directionDisplay;
    var directionsService;
    var stepDisplay;
    var markerArray = [];
	
	function initialize(){
		var myOptions = {
		  zoom: 16,
		  
		  
		  <%if(chkStreetView.equals("true")){ %>
		  streetViewControl: true,
		  <%}else{%>
		  streetViewControl: false,
		  <%}%>
		  
		  <%if(chkZoom.equals("true")){ %>
		  zoomControl: true,
		  <%}else{%>
		  zoomControl: false,
		  <%}%>
		  
		  <%if(chkDraggable.equals("true")){ %>
		  draggable: true,
		  <%}else{%>
		  draggable: false,
		  <%}%>
		  
		  <%if(chkPanControl.equals("true")){ %>
		  panControl: true,
		  <%}else{%>
		  panControl: false,
		  <%}%>
		  
		  <%if(chkRotateControl.equals("true")){ %>
		  rotateControl: true,
		  <%}else{%>
		  rotateControl: false,
		  <%}%>
		  
		  <%if(chkScaleControl.equals("true")){ %>
		  scaleControl: true,
		  <%}else{%>
		  scaleControl: false,
		  <%}%>
		  
		  mapTypeId: google.maps.MapTypeId.<%=typeMap%>
		};
		
		map = new google.maps.Map(document.getElementById("mymap"), myOptions);
		
		<%if(typeUtility.equals("OneMarker")){ %>
			address = "<%=address %>";
			description = "<%=descriptionMarker %>";
			showAddress(address);			
			
		<%}else if(typeUtility.equals("GetRoute")){%>
			
		 	fromAddress = "<%=fromAddress %>";
			toAddress = "<%=toAddress %>";
			
			//setCenter from fromAddress
			setCenterFromAddress(fromAddress);
			
			// Instantiate a directions service.
	  	    directionsService = new google.maps.DirectionsService();
			
	  		// Create a renderer for directions and bind it to the map.
	  	    var rendererOptions = {
	  	      map: map
	  	    }
	  	    directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions);
	  	    directionsDisplay.setPanel(document.getElementById("directionsPanel"));
	  	    
	  	    // Instantiate an info window to hold step text.
	  	    stepDisplay = new google.maps.InfoWindow();
		
		<%}%>
		
		return false;
	}

	
	function showAddress(address) {
		var geocoder = new google.maps.Geocoder();
		geocoder.geocode( { 'address': address}, function(results, status) {
		 if (status == google.maps.GeocoderStatus.OK) {
			
			//set Center of Map
		  	map.setCenter(results[0].geometry.location);
		  	
		  	//set Marker + Icon
		  	myicon = new google.maps.MarkerImage("<%=request.getContextPath() %>/images/<%=typeIcon%>.png",new google.maps.Size(50,50), null, null, new google.maps.Size(50,50));
			marker = new google.maps.Marker({
				position: results[0].geometry.location,
				map: map,
				title: address,
				icon: myicon
			});
			//set InfoWindow
			infowindow = new google.maps.InfoWindow({
				content: address + ": "+description
			});
			//set Event "click" on Marker
			google.maps.event.addListener(marker, 'click', function(event) {
				infowindow.open(map,marker);
			});
			
			
		 } else {
		  alert("Geocode was not successful for the following reason: " + status);
		 }
		});
	}
	
	function setCenterFromAddress(address) {
		var geocoder = new google.maps.Geocoder();
		geocoder.geocode( { 'address': address}, function(results, status) {
		 if (status == google.maps.GeocoderStatus.OK) {
			
			//set Center of Map
		  	map.setCenter(results[0].geometry.location);
			
		 } else {
		  alert("Geocode was not successful for the following reason: " + status);
		 }
		});
	}
	
	function calcRoute() {
	  	  
  	    // First, remove any existing markers from the map.
  	    for (i = 0; i < markerArray.length; i++) {
  	      markerArray[i].setMap(null);
  	    }
  	    // Now, clear the array itself.
  	    markerArray = [];
  	    // Retrieve the start and end locations and create
  	    // a DirectionsRequest using DRIVING directions.
  	    var start = fromAddress;
  	    var end = toAddress;
  	    var request = {
  	        origin: start,
  	        destination: end,
  	        travelMode: google.maps.DirectionsTravelMode.DRIVING
  	    };

  	    // Route the directions and pass the response to a
  	    // function to create markers for each step.
  	    directionsService.route(request, function(response, status) {
  	      if (status == google.maps.DirectionsStatus.OK) {
  	        directionsDisplay.setDirections(response);
  	        showSteps(response);
  	      }else{
  	    	  alert("Digit Error!!!");
  	      }
  	    });
  	  }

  	  function showSteps(directionResult) {
  	    // For each step, place a marker, and add the text to the marker's
  	    // info window. Also attach the marker to an array so we
  	    // can keep track of it and remove it when calculating new
  	    // routes.
  	    var myRoute = directionResult.routes[0].legs[0];

  	    for (var i = 0; i < myRoute.steps.length; i++) {
  	      var marker = new google.maps.Marker({
  	        position: myRoute.steps[i].start_point, 
  	        map: map
  	      });
  	      attachInstructionText(marker, myRoute.steps[i].instructions);
  	      markerArray[i] = marker;
  	    }
  	  }

  	  function attachInstructionText(marker, text) {
  	    google.maps.event.addListener(marker, 'click', function() {
  	    	stepDisplay.setContent(text);
  	    	stepDisplay.open(map, marker);
  	      //}
  	    });
  	  }
	

	$(document).ready(function() {
		  initialize();
		  
		  <%if(typeUtility.equals("GetRoute")){ %>
		  calcRoute();
		  <%}%>
	});
	
	
</script>
<%}%>

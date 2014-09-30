<%
/**
 * Copyright (c) Pasturenzi Francesco
 * This is the form that you can see click on button "Preferences" of the Portlet
 */
%>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<jsp:useBean id="saveSettingsGoogleMapsUtilityURL" class="java.lang.String" scope="request" />

<portlet:defineObjects />


<form id="<portlet:namespace/>accountForm" action="<%=saveSettingsGoogleMapsUtilityURL%>" method="POST">
	
	<div class="portlet-msg-alert">
	The <span style="color:#FF0000;">procedure</span> for displaying the Google Map with their settings is <span style="color:#FF0000;">fully Guided</span>.<br>
	</div>
	<hr>
	<br>
	
	<strong style="color:#000000;">Type of Utility (*):</strong><br>
	<input type="radio" name="inTypeUtility" value="OneMarker"/> Simple Marker with Info Window
	<input type="radio" name="inTypeUtility" value="GetRoute"/> Get Route (From - To)
	
	<br><br>
	<div id="modSettingsMap">
		<strong style="color:#000000;">Settings Map (*):</strong><br>
		<input type="checkbox" class="settingsMap" name="inStreetView" value="false"/> Street View
		<input type="checkbox" class="settingsMap" name="inZoom" value="false"/> Zoom
		<input type="checkbox" class="settingsMap" name="inDraggable" value="false"/> Draggable
		<input type="checkbox" class="settingsMap" name="inPanControl"  value="false"/> Pan Control
		<input type="checkbox" class="settingsMap" name="inRotateControl" value="false"/> Rotate Control
		<input type="checkbox" class="settingsMap" name="inScaleControl" value="false"/> Scale Control
	</div>
	<br>

	<div id="modTypeMap">
		<strong style="color:#000000;">Type of Map (*):</strong><br>
		<input type="radio"  name="inTypeMap" value="CLASSIC"/> Terrain
		<input type="radio"  name="inTypeMap" value="HYBRID"/> Hybrid
		<input type="radio"  name="inTypeMap" value="SATELLITE"/> Satellite
		<input type="radio"  name="inTypeMap" value="ROADMAP"/> Road
	</div>
	<br>
	
	
	<!-- One Marker -->
	<div id="modOneMarker">
		<strong style="color:#000000;">Settings for Simple Marker (*):</strong><br>
		Address:<br>
		<input type="text" id="inAddress" name="inAddress" size="100"><br>
		Marker's description:<br>
		<textarea rows="5" cols="45" name="inDescriptionMarker">write your marker's description</textarea>
		<br><br>
		Marker's Icon:<br>
		<input type="radio" name="inTypeIcon" value="home_classic"/><img src="<%=request.getContextPath() %>/images/home_classic.png" style="width:25px;" alt="Home Classic" title="Home Classic" />
		<input type="radio" name="inTypeIcon" value="home_blue"/><img src="<%=request.getContextPath() %>/images/home_blue.png" style="width:25px;" alt="Home Blue" title="Home Blue" />
		<input type="radio" name="inTypeIcon" value="home_black"/><img src="<%=request.getContextPath() %>/images/home_black.png" style="width:25px;" alt="Home Black" title="Home Black" />
		<input type="radio" name="inTypeIcon" value="marker_classic"/><img src="<%=request.getContextPath() %>/images/marker_classic.png" style="width:25px;" alt="Marker Classic" title="Marker Classic" /><br>
		<input type="radio" name="inTypeIcon" value="marker_green"/><img src="<%=request.getContextPath() %>/images/marker_green.png" style="width:25px;" alt="Marker Green" title="Marker Green" />
		<input type="radio" name="inTypeIcon" value="marker_pin_red"/><img src="<%=request.getContextPath() %>/images/marker_pin_red.png" style="width:25px;" alt="Marker Pin Red" title="Marker Pin Red" />
		<input type="radio" name="inTypeIcon" value="marker_pin_blue"/><img src="<%=request.getContextPath() %>/images/marker_pin_blue.png" style="width:25px;" alt="Marker Pin Blue" title="Marker Pin Blue" /><br>
		<input type="radio" name="inTypeIcon" value="cart"/><img src="<%=request.getContextPath() %>/images/cart.png" style="width:25px;" alt="Cart" title="Cart" />
		<input type="radio" name="inTypeIcon" value="shop_classic"/><img src="<%=request.getContextPath() %>/images/shop_classic.png" style="width:25px;" alt="Shop Classic" title="Shop Classic" />
		<br>
	</div>
	
	
	<!-- Get Route (From - To) -->
	<div id="modGetRoute">
		<strong style="color:#000000;">Settings for Get Route (*):</strong><br>
		Address From:<br>
		<input type="text" id="inFromAddress" name="inFromAddress" size="100"><br>
		Address To:<br>
		<input type="text" id="inToAddress" name="inToAddress" size="100"><br>
		<br>
	</div>
	
	
	<br>
	<p style="text-align:left;" id="buttSubmit">
		<input type="submit" id="inviaSettingsGoogleMapsUtilityForm" title="Save" value="Save">
	</p>
	
	<hr>
	<div class="portlet-msg-info">
	For any other simple IMPROVEMENTS or bugs: <a href="http://www.appuntivari.net/chi-siamo" target="_blank">francesco.pasturenzi@gmail.com</a>
	or you can find the source code on My Public GitHub Repository: <a href="https://github.com/pastuweb/java-liferay.appuntivari.net/tree/master/MyGoogleMapsUtility-portlet" target="_blank">MyGoogleMapsUtility-portlet</a>
	</div>
	<br>
</form>

<script type="text/javascript">		

        	 
        	resetAll();
     		$('input[name=inTypeUtility]:radio').attr("checked", false);
     		$('input[name=inTypeMap]:radio').attr("checked", false);
     	
     		$('.settingsMap').attr("checked", false);
          	
          	$('input[name=inTypeUtility]:radio').on('change', function (e) {
          		var value = $(this).val();
          		if(value=="OneMarker"){
          			resetAll();
              		$('#modSettingsMap').show();
              		$('#modTypeMap').show();
              		
          			$('input[name=inTypeMap]:radio').attr("checked", false);
              		$('.settingsMap').attr("checked", false);
              		
          			$('#modOneMarker').show();    
          			
          			$('#buttSubmit').show();
          		}else if(value=="GetRoute"){
          			resetAll();
          			$('#modSettingsMap').show();
              		$('#modTypeMap').show();
              		
          			$('input[name=inTypeMap]:radio').attr("checked", false);
              		$('.settingsMap').attr("checked", false);
              		
     				$('#modGetRoute').show();    
          			
          			$('#buttSubmit').show();
          		}
          	});
          	
          	$('.settingsMap').on('change', function (e) {
          		if($(this).attr("checked", true)){
          			$(this).val("true");
          		}else{
          			$(this).val("false");
          		}
          	});
          	
          	function resetAll(){
          		
          		$('#modSettingsMap').hide();
         		$('#modTypeMap').hide();
         		$('#modOneMarker').hide();
         		$('#modGetRoute').hide();
          	}


</script>


  
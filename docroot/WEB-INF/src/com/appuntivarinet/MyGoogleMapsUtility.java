package com.appuntivarinet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.logging.Logger;

import javax.portlet.*;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.security.auth.PrincipalThreadLocal;
import com.liferay.portal.util.PortalUtil;


public class MyGoogleMapsUtility extends GenericPortlet {
	
	public static Log log = LogFactory.getLog("MyGoogleMapsUtility");
	
	/* initialize the default parameter of "portlet.xml" */
	protected String editJSP;
	protected String viewJSP;
	
	public void init() throws PortletException{
		editJSP = getInitParameter("edit-jsp");
		viewJSP = getInitParameter("view-jsp");
	}
	
	
	//set the Portlet's default View
	public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException{
		
		PortletPreferences prefs = renderRequest.getPreferences();
		
		String typeUtility = (String) prefs.getValue("typeUtility", "");
		
		String chkStreetView = (String) prefs.getValue("chkStreetView", "");
		log.info("chkStreetView: "+chkStreetView);
		String chkZoom = (String) prefs.getValue("chkZoom", "");
		log.info("chkZoom: "+chkZoom);
		String chkDraggable = (String) prefs.getValue("chkDraggable", "");
		log.info("chkDraggable: "+chkDraggable);
		String chkPanControl = (String) prefs.getValue("chkPanControl", "");
		log.info("chkPanControl: "+chkPanControl);
		String chkRotateControl = (String) prefs.getValue("chkRotateControl", "");
		log.info("chkRotateControl: "+chkRotateControl);
		String chkScaleControl = (String) prefs.getValue("chkScaleControl", "");
		log.info("chkScaleControl: "+chkScaleControl);

		
		String typeMap = (String) prefs.getValue("typeMap", "");
		
		String address = (String) prefs.getValue("address", "");
		String descriptionMarker = (String) prefs.getValue("descriptionMarker", "");
		String typeIcon = (String) prefs.getValue("typeIcon", "");
		
		String fromAddress = (String) prefs.getValue("fromAddress", "");
		String toAddress = (String) prefs.getValue("toAddress", "");

		
		String notDefinedMessage = (String) prefs.getValue("notDefinedMessage", "");

		
		/* Default value */
		if(typeUtility.equals("")){
			notDefinedMessage = "click on Preferences";
			renderRequest.setAttribute("notDefinedMessage", notDefinedMessage);
		}else if(typeUtility.equals("OneMarker")){
			
			renderRequest.setAttribute("typeUtility", typeUtility);
			
			renderRequest.setAttribute("chkStreetView", chkStreetView);
			renderRequest.setAttribute("chkZoom", chkZoom);
			renderRequest.setAttribute("chkDraggable", chkDraggable);
			renderRequest.setAttribute("chkPanControl", chkPanControl);
			renderRequest.setAttribute("chkRotateControl", chkRotateControl);
			renderRequest.setAttribute("chkScaleControl", chkScaleControl);
			
			renderRequest.setAttribute("typeMap", typeMap);
			
			renderRequest.setAttribute("address", address);
			renderRequest.setAttribute("descriptionMarker", descriptionMarker);
			renderRequest.setAttribute("typeIcon", typeIcon);
			
			renderRequest.setAttribute("fromAddress", null);
			renderRequest.setAttribute("toAddress", null);
			
			renderRequest.setAttribute("notDefinedMessage", new String(""));
		
		}else if(typeUtility.equals("GetRoute")){
			
			renderRequest.setAttribute("typeUtility", typeUtility);
			
			renderRequest.setAttribute("chkStreetView", chkStreetView);
			renderRequest.setAttribute("chkZoom", chkZoom);
			renderRequest.setAttribute("chkDraggable", chkDraggable);
			renderRequest.setAttribute("chkPanControl", chkPanControl);
			renderRequest.setAttribute("chkRotateControl", chkRotateControl);
			renderRequest.setAttribute("chkScaleControl", chkScaleControl);
			
			renderRequest.setAttribute("typeMap", typeMap);
			
			renderRequest.setAttribute("address", null);
			renderRequest.setAttribute("descriptionMarker", null);
			renderRequest.setAttribute("typeIcon", null);
			
			renderRequest.setAttribute("fromAddress", fromAddress);
			renderRequest.setAttribute("toAddress", toAddress);
			
			renderRequest.setAttribute("notDefinedMessage", new String(""));
		}

		include(viewJSP, renderRequest, renderResponse);
	}
	
	
	
	
	/* special method: used to dispatch to right JSP */
	protected void include(String path, RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException{
		PortletRequestDispatcher portletRequestDispatcher = getPortletContext().getRequestDispatcher(path);
		if(portletRequestDispatcher == null){
			log.info("path : "+path+" non e' valido.");
		}else{
			portletRequestDispatcher.include(renderRequest, renderResponse);
		}
	}
	
	/* set the Portlet's default Edit: it's a simple <form> */
	public void doEdit(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException{
		
		renderResponse.setContentType("text/html");
		PortletURL saveSettingsStatisticsURL = renderResponse.createActionURL();
		saveSettingsStatisticsURL.setParameter("saveSettingsGoogleMapsUtility", "saveSettingsGoogleMapsUtility");
		renderRequest.setAttribute("saveSettingsGoogleMapsUtilityURL", saveSettingsStatisticsURL.toString());

		include(editJSP, renderRequest, renderResponse);
		
	}
	
	/* ACTION call from Portlet's <form> of EDIT JSP */
	public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException{
		
		String saveSettingsGoogleMapsUtility = actionRequest.getParameter("saveSettingsGoogleMapsUtility");
		/*You can add other getParameter of EDIT JSP*/
		
		if(saveSettingsGoogleMapsUtility != null){
			PortletPreferences prefs = actionRequest.getPreferences();
			
			if(actionRequest.getParameter("inTypeUtility")!= null)
				prefs.setValue("typeUtility", actionRequest.getParameter("inTypeUtility"));
			
			if(actionRequest.getParameter("inStreetView")!= null)
				prefs.setValue("chkStreetView", actionRequest.getParameter("inStreetView"));
			if(actionRequest.getParameter("inZoom")!= null)
				prefs.setValue("chkZoom", actionRequest.getParameter("inZoom"));
			if(actionRequest.getParameter("inDraggable")!= null)
				prefs.setValue("chkDraggable", actionRequest.getParameter("inDraggable"));
			if(actionRequest.getParameter("inPanControl")!= null)
				prefs.setValue("chkPanControl", actionRequest.getParameter("inPanControl"));
			if(actionRequest.getParameter("inRotateControl")!= null)
				prefs.setValue("chkRotateControl", actionRequest.getParameter("inRotateControl"));
			if(actionRequest.getParameter("inScaleControl")!= null)
				prefs.setValue("chkScaleControl", actionRequest.getParameter("inScaleControl"));
			
			
			if(actionRequest.getParameter("inTypeMap")!= null)
				prefs.setValue("typeMap", actionRequest.getParameter("inTypeMap"));
			
			
			if(actionRequest.getParameter("inAddress")!= null)
				prefs.setValue("address", actionRequest.getParameter("inAddress"));
			if(actionRequest.getParameter("inDescriptionMarker")!= null)
				prefs.setValue("descriptionMarker", actionRequest.getParameter("inDescriptionMarker"));
			if(actionRequest.getParameter("inTypeIcon")!= null)
				prefs.setValue("typeIcon", actionRequest.getParameter("inTypeIcon"));
			
			if(actionRequest.getParameter("inFromAddress")!= null)
				prefs.setValue("fromAddress", actionRequest.getParameter("inFromAddress"));
			if(actionRequest.getParameter("inToAddress")!= null)
				prefs.setValue("toAddress", actionRequest.getParameter("inToAddress"));
			
			prefs.store();
			actionResponse.setPortletMode(PortletMode.VIEW);
		}
		
		
	}

	
}

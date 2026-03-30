<cf_templateheader title="Inventarios">
	<link href="../css/iv.css" rel="stylesheet" type="text/css">	
	<cfinclude template="/sif/portlets/pNavegacion.cfm"> 	
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Transformaci&oacute;n de artículos'>
			<cfinclude template="Transforma-form1.cfm">
		<cf_web_portlet_end>		
<cf_templatefooter>
<!---*******************************************
*******Sistema de Educación*********************
*******Administración de Centros de Estudio*****
*******Plan de Evaluación***********************
*******Fecha de Creación: Ene/2006**************
*******Desarrollado por: Dorian Abarca Gómez****
********************************************--->
<!---*******************************************
*******Registro de Cambios Realizados***********
*******Modificación No:*************************
*******Realizada por:***************************
*******Detalle de la Modificación:**************
********************************************--->
<!---*******************************************
*******Se crea Variable pNavegacion para********
*******obtener variables con datos del proceso**
*******como nombre para utilizarlo en titulos***
*******aquí se crea nav__SPdescripcion**********
********************************************--->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#"> 
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfinclude template="requisiciones_common.cfm">
			<cfinclude template="requisiciones_filtro.cfm">
		<cf_web_portlet_end>	
<cf_templatefooter>
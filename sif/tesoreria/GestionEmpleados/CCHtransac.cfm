<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_TransaccionesCajaChica" default = "Transacciones de Caja Chica" returnvariable="LB_TransaccionesCajaChica" xmlfile = "CCHtransac.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_GestionTransaccionesCajaChica" default = "Gesti&oacute;n de Transacciones de Caja Chica" returnvariable="LB_GestionTransaccionesCajaChica" xmlfile = "CCHtransac.xml">



<cf_templateheader title="#LB_TransaccionesCajaChica#"> 
	<cf_navegacion name="Config" navegacion="">
	<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="verificacion">
	</cfinvoke>
	<cfparam name="Attributes.entrada"		default="">
	<!---<cfquery name="rsSQLD" datasource="#session.dsn#">
		select count(1) as cantidad from CCHica where CCHresponsable=
	</cfquery>--->
		<cfif isdefined ('url.CCHTtipo')>
			<cfset form.CCHTtipo=#url.CCHTtipo#>
		</cfif>

			<cfif isdefined ('url.CCHTestado')>
			<cfset form.CCHTestado=#url.CCHTestado#>
		</cfif>
	<!---	<cfdump var="-#form.CCHTtipo#-"><br />
		<cfdump var="-#form.CCHTestado#-"><br />
		<cfabort>--->
<cfif isdefined ('Attributes.entrada') and len(trim(Attributes.entrada)) gt 0>
<cfset bandera =1>
</cfif>
		
		<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>		  
			<cfset titulo = '#LB_GestionTransaccionesCajaChica#'>			
		<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">																						
		<cfif isdefined ('form.CCHTtipo') and len(trim(form.CCHTtipo)) gt 0 and (form.CCHTtipo eq 'DISMINUCION' OR form.CCHTtipo eq 'CIERRE') and isdefined ('form.CCHTestado') and form.CCHTestado eq 'POR CONFIRMAR' or isdefined ('form.CCHDid') >
				<cfinclude template="CCHtransac_depo.cfm">
		<cfelseif isdefined ('form.CCHTid') or isdefined ('url.CCHTid') or isdefined ('form.Nuevo') or isdefined ('form.btnNuevo') or isdefined ('url.Nuevo')>
			<cfinclude template="CCHtransac_form.cfm"> 
		<cfelse>
			<cfinclude template="CCHtransac_lista.cfm">
		</cfif>			
	  	<cf_web_portlet_end>
<cf_templatefooter>

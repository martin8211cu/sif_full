<cfinvoke key="BTN_Filtrar" default="Filtrar"	returnvariable="BTN_Filtrar"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="/sif/generales.xml"/>
<cfinvoke key="LB_Titulo" default="Impresi&oacute;n de Solicitudes de Pago(Usuario)"	returnvariable="LB_Titulo"	method="Translate" 
component="sif.Componentes.Translate"  xmlfile="imprSolicitPago.xml"/>

<cf_navegacion name="TESSPid" default=""> 
<cfparam name="LvarFiltroPorUsuario" default="false">
<cfparam name="LvarSufijoForm" default="">

<cfif isdefined("LvarFiltroPorUsuario") and #LvarFiltroPorUsuario#>
	<cfset titulo="#LB_TituloU#">
    <cfset LvarSufijoForm="Usuario">
<cfelse>
	<cfset titulo="#LB_Titulo#">
</cfif>


<cfif form.TESSPid NEQ "" and not isdefined("url.regresar")>
	<cfset paramsuri='&imprime=1'>
	<cfif isdefined("Form.TESSPid")>
		<cfset paramsuri = paramsuri & '&TESSPid=#form.TESSPid#'>
	</cfif>
	<cfset form.MSG="">
	<cfif isdefined ('Attributes.location') and (Attributes.location eq 'solicitudesAnticipo.cfm' or Attributes.location eq 'solicitudesAnticipoE.cfm' )>
		<cf_htmlReportsHeaders 
		title="#LB_Titulo#" 
		filename="SolicitudPago.xls"		
		irA="#Attributes.location#?regresar=1"
		download="no"
		preview="no"
		>
	<cfelse>
		<cf_htmlReportsHeaders 
		title="#LB_Titulo#" 
		filename="SolicitudPago.xls"		
		irA="imprSolicitPago#LvarSufijoForm#.cfm?regresar=1"
		download="no"
		preview="no"
		>
	</cfif>
	<cf_templatecss>
	<cfinclude template="imprSolicitPago_form.cfm">
<cfelse>
	<cf_templateheader title="#titulo#">
		<cfinclude template="imprSolicitPago_lista.cfm">
	<cf_templatefooter>
</cfif>

<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
<!--- Pasa Valores del Url al Form --->
<cfset recargada = true><!--- Para saber cuando se llega a la pantalla por primera vez. O despues de venir del SQL
								Cuando llega por primera ves los parámetros vienen por Url, cuando llega despues de 
								un cambio los mismos llegan por Form. --->
<cfif isDefined("Url.RCNid") and not isDefined("Form.RCNid")>
	<cfset recargada = false>
	<cfset Form.RCNid = Url.RCNid>
</cfif>
<cfif isDefined("Url.DEid") and not isDefined("Form.DEid")>
	<cfset Form.DEid = Url.DEid>
</cfif>
<cfif isDefined("Url.Tcodigo") and not isDefined("Form.Tcodigo")>
	<cfset Form.Tcodigo = Url.Tcodigo>
</cfif>
<cfif isDefined("Url.ICid") and not isDefined("Form.ICid")><!--- Incidencias --->
	<cfset Form.ICid = Url.ICid>
</cfif>
<cfif isDefined("Url.Did") and not isDefined("Form.Did")><!--- Deducciones --->
	<cfset Form.Did = Url.Did>
</cfif>

<!-----================ TRADUCCION =================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AgregarIncidencia"
	Default="Agregar Incidencia"	
	returnvariable="LB_AgregarIncidencia"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AgregarDeduccion"
	Default="Agregar Deduccion"	
	returnvariable="LB_AgregarDeduccion"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ModificarIncidencia"
	Default="Modificar Incidencia"	
	returnvariable="LB_ModificarIncidencia"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ModificarDeduccion"
	Default="Modificar Deducción"	
	returnvariable="LB_ModificarDeduccion"/>

<!--- Define Titulo y Frame--->
<cfif isDefined("Url.frame")>
	<cfif Url.frame eq 'IN'>
		<cfset Title = LB_AgregarIncidencia>
		<cfset frame="IN">
	<cfelseif Url.frame eq 'DE'>
		<cfset Title = LB_AgregarDeduccion>
		<cfset frame="DE">
	</cfif>
<cfelse>
	<cfset Title = LB_AgregarIncidencia>
	<cfset frame="IN">
</cfif>

<!--- Si viene ICid o Did predefine modo en cambio y pone titulo correspondiente. --->
<cfif isDefined("Form.ICid")>
  <cfset Form.modo="CAMBIO">
  <cfset Title = LB_ModificarIncidencia>
<cfelseif isDefined("Form.Did")>
  <cfset Form.modo="CAMBIO">
  <cfset Title = LB_ModificarDeduccion>
</cfif>

<!--- Define el Modo --->
<cfif isdefined("Form.Cambio")>  
  <cfset modo="CAMBIO">
<cfelse>  
  <cfif not isdefined("Form.modo")>    
    <cfset modo="ALTA">
  <cfelseif Form.modo EQ "CAMBIO">
    <cfset modo="CAMBIO">
  <cfelse>
    <cfset modo="ALTA">
  </cfif>  
</cfif>

<html>
<head>
<title><cfoutput>#Title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<cf_templatecss>
<cf_templatecss>
<link href="../../../css/web_portlet.css" rel="stylesheet" type="text/css">

<SCRIPT LANGUAGE="JavaScript">
	<!--//
	//Refresca la pantalla principal haciendo submit para que se vea mas elegante.
	function reloadOpener(){
	   window.opener.document.form1.submit();
	   window.close();
	}
	//Cierra la pantalla despues de cualquier cambio y refresca la pantalla principal con la funcion reloadOpener.
	<cfif recargada>
		reloadOpener();
	</cfif>
	//-->
</SCRIPT>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
  	<tr valign="top"> 
		<td align="center">
		  <cfinclude template="/rh/portlets/pEmpleado.cfm">
		</td>
  	</tr>
	<tr>
		<td align="center">
			<table width="97%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
			  <tr>
				<cfoutput>
				<td nowrap class="#Session.preferences.Skin#_thcenter" align="center">#Title#</td>
				</cfoutput>
			  </tr>
			  <tr>
				<td nowrap align="center">
					<cfif isdefined("url.RCNid") and not isdefined("form.RCNid")>
						<cfset form.RCNid = url.RCNid >
					</cfif>
					<cfif isdefined("url.Tcodigo") and not isdefined("form.Tcodigo")>
						<cfset form.Tcodigo = url.Tcodigo >
					</cfif>
					<cfif frame eq 'IN'>
						<cfinclude template="RM-fameIncidencias.cfm">
					<cfelseif frame eq 'DE'>
						<cfset action = "ResultadoModify-sql.cfm">
						<cfset RCNid   = form.RCNid >
						<cfset Tcodigo = form.Tcodigo >
						<cfinclude template="../../expediente/catalogos/formDeducciones.cfm">
					</cfif>
				</td>
			  </tr>
			</table>
		</td>
	</tr>
</table>
</body>
</html>
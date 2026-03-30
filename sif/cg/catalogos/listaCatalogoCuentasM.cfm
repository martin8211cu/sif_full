

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>

<cfif isdefined("url.CGICMid") and len(trim(url.CGICMid)) and not isdefined("form.CGICMid")>
	<cfset form.CGICMid = url.CGICMid>
</cfif>

<cfquery name="rs" datasource="#session.dsn#">
	select CGICMcodigo,	CGICMnombre
	from CGIC_Mapeo
	where CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGICMid#">
</cfquery>

<cfif isdefined("LvarInfo")>
	<cfset LvarAction   = 'CatalogoCuentasMINFO.cfm'>
	<cfset LvarRegresar = 'TipoMapeoCuentasINFO.cfm'>
<cfelse>
	<cfset LvarAction   = 'CatalogoCuentasM.cfm'>
	<cfset LvarRegresar = 'TipoMapeoCuentas.cfm'>
</cfif>

<cfinvoke key="LB_Titulo" default="Cuentas para Mapeo" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate" 
xmlfile="listaCatalogoCuentasM.xml"/>
<cfinvoke key="LB_Cuenta" default="Cuenta" returnvariable="LB_Cuenta" component="sif.Componentes.Translate" method="Translate" 
xmlfile="listaCatalogoCuentasM.xml"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate" 
xmlfile="listaCatalogoCuentasM.xml"/>
<cf_templateheader title="#LB_Titulo#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="#LB_Titulo#: #rs.CGICMcodigo# - #rs.CGICMnombre#">
			<cfset navegacion=''>
			<cfoutput>
				<form name="form1" method="post" action="#LvarAction#">
					<input name="CGICMid" type="hidden" value="#form.CGICMid#">
					<cfset navegacion = ''>
					<cfset navegacion = navegacion & "CGICMid=#form.CGICMid#">
					<table border="0" cellpadding="0" cellspacing="0" style="width:100%">
						<tr>
							<td>
								<cfinvoke 
								  component="sif.Componentes.pListas"
								  method="pLista"
								  returnvariable="pListaRet"
									tabla				= "CGIC_Catalogo"
									columnas  			= "CGICCid, CGICCcuenta, CGICCnombre, '' as truco"
									desplegar			= "CGICCcuenta, CGICCnombre, truco"
									etiquetas			= "#LB_Cuenta#, #LB_Nombre#, "
									formatos			= "S,S,U"
									filtro				= "CGICMid = #form.CGICMid#"
									align 				= "Left, Left, Left"
									ajustar				= "S"
									checkboxes			= "N"
									incluyeform			= "false"
									formname			= "form1"
									botones				= "Nuevo,Regresar"
									navegacion			= "#navegacion#"
									mostrar_filtro		= "true"
									filtrar_automatico	= "true"
									showLink			= "true"
									showemptylistmsg	= "true"
									keys				= "CGICCid"
									MaxRows				= "15"
									irA					= "#LvarAction#"
									/>
							</td>
						</tr>
					</table>
				</form>	
		</cfoutput>
		<cf_web_portlet_end>	
<cf_templatefooter>
<script language="javascript" type="text/javascript">
	function funcRegresar(){
		document.form1.action='<cfoutput>#LvarRegresar#</cfoutput>';
		document.form1.submit();
		return true;
	}
</script>
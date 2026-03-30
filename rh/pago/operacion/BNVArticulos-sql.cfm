
<cfif (not isdefined("Form.cod_articulo") or not len(trim(Form.cod_articulo))) or
	(not isdefined("Form.descripcion") or not len(trim(Form.descripcion))) or
	(not isdefined("Form.cod_egreso") or not len(trim(Form.cod_egreso)))>

	<cfinvoke key="LB_BNVArticulo" default="Art&iacute;culos Presupuestales de BN Vital" returnvariable="LB_BNVArticulo" component="sif.Componentes.Translate" method="Translate"/>	 
	<cfinvoke key="LB_COD_ARTICULO" default="C&oacute;digo" xmlfile="/rh/generales.xml" returnvariable="LB_COD_ARTICULO" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="LB_DESCRIPCION" default="Descripci&oacute;n" xmlfile="/rh/generales.xml" returnvariable="LB_DESCRIPCION" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="LB_COD_EGRESO" default="Egreso" xmlfile="/rh/generales.xml" returnvariable="LB_COD_EGRESO" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="LB_COD_ARTICULO_REM" default="Remplazo" xmlfile="/rh/generales.xml" returnvariable="LB_COD_ARTICULO_REM" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="BTN_Filtrar" default="Filtrar" xmlfile="/rh/generales.xml" returnvariable="BTN_Filtrar" component="sif.Componentes.Translate" method="Translate"/>
	<cfinvoke key="BTN_Limpiar" default="Limpiar" xmlfile="/rh/generales.xml" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate"/>			
	<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos" xmlfile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
	<!--- FIN VARIABLES DE TRADUCCION --->
	         
	<cf_web_portlet_start titulo="#LB_BNVArticulo#">
		<table width="90%" height="400" border="0" cellspacing="0" cellpadding="0">
			
			<tr valign="top"><td>&nbsp;</td></tr>
			<tr valign="top"> 
				<td> 
					<center>Son requeridos:  el c&oacute;digo de art&iacute;culo, la descripci&oacute;n del art&iacute;culo, el c&oacute;digo de egreso</center>
				</td>
			</tr>

			<tr valign="top">
			<td align="center" >
			<input type="button" value="Regresar" name="Regresar" onclick="javascript: document.location.href='BNVArticulos.cfm'">
			</td></tr>
		</table>
	<cf_web_portlet_end>
	
	
	<cfabort>
</cfif>

<cfset datasourceBNV = "sifinterfaces">
<cftransaction>
	<cftry>
	  <cfif isdefined("Form.Alta")>
			
			<cfquery name="rsExiste" datasource="#datasourceBNV#">
				select * from INTP_Articulos_BNV where rtrim(ltrim(cod_articulo)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.cod_articulo)#">
			</cfquery>	
			
			<cfif rsExiste.RecordCount GT 0>
				<cfinclude template="/sif/errorPages/BDerror.cfm">
				<cfabort>
			</cfif>
			
			<cfquery name="ArticuloBNVIns" datasource="#datasourceBNV#">			
				insert into INTP_Articulos_BNV 
					(cod_articulo,desc_articulo,cod_egreso,cod_articulo_remp)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.cod_articulo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.descripcion#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.cod_egreso#">, 
					<cfif isdefined("Form.cod_articulo_rem") and len(trim(Form.cod_articulo_rem))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.cod_articulo_rem#">
					<cfelse>
						null
					</cfif>
					)
			</cfquery>				
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>			
			<cfquery name="ArticuloBNVDel" datasource="#datasourceBNV#">
				delete from INTP_Articulos_BNV where cod_articulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.cod_articulo)#">
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Cambio")>	
			<cfquery name="ArticuloBNVUp" datasource="#datasourceBNV#">	
				update INTP_Articulos_BNV set 
					desc_articulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.descripcion#">,
					cod_egreso = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.cod_egreso#">,
					cod_articulo_remp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.cod_articulo_rem#">
				where cod_articulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.cod_articulo#">
			</cfquery>
			<cfset modo="CAMBIO">				  				  
		</cfif>			
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
	</cftransaction>
	
<cfoutput>
	<form action="BNVArticulos.cfm" method="post" name="sql">
		<cfif isdefined("Form.Nuevo")>
			<input name="Nuevo" type="hidden" value="Nuevo"> 
		<cfelse>
			<input name="cod_articulo" type="hidden" value="#form.cod_articulo#">
				
		</cfif>	
		<input name="modo" type="hidden" value="<cfif isdefined('modo')>#modo#</cfif>">
		<input name="Pagina" type="hidden" value="<cfif isdefined('Form.Pagina')>#Form.Pagina#</cfif>">	
	</form>
</cfoutput>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>

<cfinvoke key="LB_Titulo" default="Excluir cuentas de Mapeo" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate"
xmlfile="CatalogoCuentasInactivasCE.xml"/>
<cfinvoke key="LB_Formato" default="Formato" returnvariable="LB_Formato" component="sif.Componentes.Translate" method="Translate"
xmlfile="CatalogoCuentasInactivasCE.xml"/>
<cfinvoke key="LB_Descripcion" default="Descripción" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"
xmlfile="CatalogoCuentasInactivasCE.xml"/>
<cfinvoke key="LB_Cuenta" default="Cuenta" returnvariable="LB_Cuenta" component="sif.Componentes.Translate" method="Translate"
xmlfile="CatalogoCuentasInactivasCE.xml"/>

<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">
	<cfquery name="rs" datasource="#Session.DSN#">
		select Pvalor,Pdescripcion
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>

		<cfset filtro = "">
		<cfset navegacion = "">

			<cfset IRA = 'CatalogoCuentasInactivasCE.cfm'>

		<cfset varEmpElimina =  ObtenerDato(1310)>
		<cfif varEmpElimina.Pvalor EQ '' or varEmpElimina.Pvalor NEQ Session.Ecodigo>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
			      <br/>
			      <tr>
				      <td align="center">Este proceso solo se puede usar en una Empresa que este configurada como Empresa de Eliminaci&oacute;n.</td>
				  </tr>
				  <tr>
					  <td align="center"><a href="../../../../otrassol/consolidacion/Catalogos/ParametrosCtaEliminacion.cfm" style="color:#456ABA"> Parámetro de Eliminaci&oacute;n</a></td>
				  </tr>
			</table>
			<br>
		<cfelse>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
				 	<td valign="top" style="padding-top:10px">
						<cfinclude template="formCatalogoCuentasInactivasCE.cfm">
					</td>
				</tr>
				<tr>
					<td valign="top" width="50%">
						<br>
						<br>

						<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet"
							tabla				= "CEInactivas"
							columnas  			= "Ccuenta,Cformato, Cdescripcion"
							desplegar			= "Cformato, Cdescripcion"
							etiquetas			= "#LB_Formato#, #LB_Descripcion#"
							formatos			= "S,S,S"
							filtro				= "GEid<>-1  AND (Ecodigo = #Session.Ecodigo#) ORDER BY Cformato"
							align 				= "Left, Left, Left"
							ajustar				= "N"
							checkboxes			= "N"
							incluyeform			= "true"
							formname			= "filtro"
							navegacion			= "#navegacion#"
							mostrar_filtro		= "true"
							filtrar_automatico	= "true"
							showLink			= "true"
							showemptylistmsg	= "true"
							keys				= "Cformato"
							MaxRows				= "50"
							irA					= "#IRA#"
							/>
					</td>
			 	</tr>
			</table>
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>
<cfoutput>
<cfquery datasource="#session.DSN#" name="rsimagen">
	select Cbanner, ts_rversion
	from Clasificaciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccodigo#">
</cfquery>
<cfif Len(rsimagen.Cbanner) GT 1>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td ><hr width="99%" align="center"></td></tr>
	<tr>
		<td align="center">
			<table width="99%" border="0" align="center"	>
				<tr>
					<td align="center" width="75%">
						<cfinvoke component="sif.Componentes.DButils"
						method="toTimeStamp"
						returnvariable="tsurl">
						<cfinvokeargument name="arTimeStamp" value="#rsimagen.ts_rversion#"/>
						</cfinvoke>
						
						<img src="/cfmx/sif/iv/catalogos/logo_clasificacion.cfm?Ccodigo=#form.Ccodigo#&ts=#tsurl#" width="200" height="150" border="0">
					</td>
					<td valign="middle" align="center">
						<cfset masbotones = "EliminarImg">
						<cfset masbotonesv = "Eliminar Imagen">
						<cf_botones exclude="ALTA,CAMBIO,BAJA,LIMPIAR" include="#masbotones#"  includevalues="#masbotonesv#" tabindex="1" >
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</cfif>
</cfoutput>
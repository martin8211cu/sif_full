<cfif isdefined('form.GELid') and form.GELid NEQ "">
	<cfset id=form.GELid>
<cfelseif isdefined ('form.id') and form.id NEQ "">
	<cfset id=form.id>
</cfif>
<cfif id NEQ "">
	<cfquery datasource="#session.dsn#" name="listaDet">
		select 
			GELtotalDevoluciones,
			GELfecha
			from GEliquidacion DL
			where  GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">
			
	 </cfquery>
</cfif>

<!---LISTA--->

<table width="100%" border="0" align="left" >
	<tr>
		<cfif isdefined ('listaDet.GELtotalDevoluciones') and listaDet.GELtotalDevoluciones GT 0>	
			<td width="100%" valign="top">
				<cfset titulo = 'Lista de Devoluciones Asociados'>
				<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
				
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
					query="#listaDet#"
					desplegar="GELtotalDevoluciones,GELfecha,"
					etiquetas="Monto,Fecha"
					formatos="N,D"
					align="left,left"
					form_method="post"	
					showEmptyListMsg="yes"				
					PageIndex="1"
					showLink="yes"
					MaxRows="5"	
					navegacion = "&GELid=#id#"
				/>
					<cf_web_portlet_end>
			</td>
		<cfelse>
			<td align="center"><strong>No hay devoluciones</strong></td>
		</cfif>
	</tr>
</table>
	
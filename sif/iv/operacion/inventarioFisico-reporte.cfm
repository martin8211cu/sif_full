<!--- tiene esto para que compare como tipo string..., pues si son solo numeros los compara como tales (y en bd son varchar)...--->
<cfif ('.' & url.Acodigoini) gt ('.' & url.Acodigofin)>
	<cfset tmp = url.Acodigoini >
	<cfset url.Acodigoini = url.Acodigofin >
	<cfset url.Acodigofin = tmp >
</cfif>

<cfif isdefined("url.Ccodigoini") and len(trim(url.Ccodigoini)) eq 0 >
	<cfquery name="rsMinClas" datasource="#session.DSN#">
		select min(Ccodigoclas)  as codigo
		from Clasificaciones
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfset url.Ccodigoini = rsMinClas.codigo >
</cfif>

<cfif isdefined("url.Ccodigofin") and len(trim(url.Ccodigofin)) eq 0 >
	<cfquery name="rsMaxClas" datasource="#session.DSN#">
		select max(Ccodigoclas)  as codigo
		from Clasificaciones
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfset url.Ccodigofin = rsMaxClas.codigo >
</cfif>

<!--- clasificacion --->
<cfif ('.' & url.Ccodigoini) gt ('.' & url.Ccodigofin)>
	<cfset tmp = url.Ccodigoini >
	<cfset url.Ccodigoini = url.Ccodigofin >
	<cfset url.Ccodigofin = tmp >
</cfif>

<cfsavecontent variable="myQuery">
	<cfoutput>
	select b.Almcodigo, b.Bdescripcion, d.Ccodigoclas, d.Cdescripcion, a.Eestante, a.Ecasilla, c.Acodigo, c.Adescripcion, a.Eexistencia
	from Existencias a
	
	inner join Almacen b
	on b.Aid=a.Alm_Aid
	and b.Almcodigo between '#url.Acodigoini#' and '#url.Acodigofin#'
	and b.Ecodigo=a.Ecodigo
	
	inner join Articulos c
	on c.Aid=a.Aid
	
	inner join Clasificaciones d
	on d.Ecodigo=c.Ecodigo
	and d.Ccodigo=c.Ccodigo
	and d.Ccodigoclas between '#url.Ccodigoini#' and '#url.Ccodigofin#'
	
	where a.Ecodigo = #session.Ecodigo#
	
	order by b.Almcodigo, b.Bdescripcion, d.Ccodigoclas, d.Cdescripcion
	</cfoutput>
</cfsavecontent>

<cfheader name="Content-Disposition" value="inline; filename=InventarioFisico.xls">
<cfcontent type="application/vnd.msexcel">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<cfoutput>
	<tr >
		<td >&nbsp;</td>
		<td >&nbsp;</td>
		<td align="center" ><strong><font size="4">#replace(session.Enombre, ',', '', 'all')#</font></strong></td>
		<td >&nbsp;</td>
		<td >&nbsp;</td>
	</tr>
	<tr >
		<td >&nbsp;</td>
		<td >&nbsp;</td>
		<td align="center" ><strong><font size="3">Inventario F&iacute;sico de Suministros</font></strong></td>
		<td >&nbsp;</td>
		<td >&nbsp;</td>
	</tr>
	<tr >
		<td >&nbsp;</td>
		<td >&nbsp;</td>
		<td align="center" ><strong><font size="3">Hoja de Conteo</font></strong></td>
		<td >&nbsp;</td>
		<td >&nbsp;</td>
	</tr>
	</cfoutput>
<cfset registros = 0 >
<cftry>
	<cf_jdbcquery_open name="data" datasource="#session.DSN#">
	<cfoutput>#myquery#</cfoutput>
	</cf_jdbcquery_open>
		<cfoutput query="data" group="Almcodigo">
			<cfset registros = registros + 1 >
			<tr>
				<td><strong>Almacen</strong></td>
				<td><strong>Cod:#replace(Almcodigo, ',', '', 'all')#</strong></td>
				<td><strong>#replace(Bdescripcion, ',', '', 'all')#</strong></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr >
				<td ><strong>Ubicacion</strong></td>
				<td >&nbsp;</td>
				<td >&nbsp;</td>
				<td >&nbsp;</td>
				<td >&nbsp;</td>
			</tr>
			<tr >
				<td ><strong>Estante</strong></td>
				<td ><strong>Casilla</strong></td>
				<td ><strong>Codigo</strong></td>
				<td ><strong>Descripcion</strong></td>
				<td ><strong>Inventario Fisico</strong></td>
			</tr>
			<cfoutput group="Ccodigoclas">
				<tr>
					<td><strong>Clasificacion</strong></td>
					<td><strong>#replace(Ccodigoclas, ',', '', 'all')#</strong></td>
					<td><strong>#replace(Cdescripcion, ',', '', 'all')#</strong></td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<cfoutput>
				<tr>
					<td nowrap="nowrap"><cfif len(trim(Eestante))>#Eestante#</cfif></td>
					<td ><cfif len(trim(Ecasilla))>#Ecasilla#</cfif></td>
					<td nowrap="nowrap">Cod:#replace(Acodigo, ',', '', 'all')#</td>
					<td nowrap="nowrap">#Replace(Adescripcion, ',', '', 'all')#</td>
					<td nowrap="nowrap" bgcolor="##FFCC66"></td>
				</tr>
				</cfoutput>
			</cfoutput>
		</cfoutput>
<cfcatch type="any">
	<cf_jdbcquery_close>
	<cfrethrow>
</cfcatch>
</cftry>
	<cf_jdbcquery_close>
</table>


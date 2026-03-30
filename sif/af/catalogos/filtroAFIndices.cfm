<cfquery name="rsPeriodo" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = 50
		and Mcodigo = 'GN'
</cfquery>
<cfset rsPeriodos = QueryNew("Pvalor")>
<cfset temp = QueryAddRow(rsPeriodos,5)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor-2,1)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor-1,2)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor+0,3)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor+1,4)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor+2,5)>
<cfoutput>
<form name="form2" style="margin:0; " method="post"  action="AFIndices.cfm"  >
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro" style="padding-top : 5px; padding-bottom : 5px;">
	<tr> 
	<td><div align="right">Periodo:</div></td>
	<td><select name="AFIperiodo" onChange="javascript:this.form.submit();">
	<cfloop query="rsPeriodos">
	<option value="#Pvalor#" <cfif rsPeriodos.Pvalor eq form.AFIperiodo>selected</cfif>>#Pvalor#</option>
	</cfloop>
	</select></td>
</table>
</form>
</cfoutput>

<cfquery name="rsQueryLista" datasource="#session.dsn#">
	select 
		afi.AFIperiodo, 
		afi.AFImes, 
		avg(afi.AFIindice) as IndiceProm,
		c.ACcodigo as ACcodigoClas,
		c.ACid as ACidClas,
		ct.ACcodigo as ACcodigoCat,
		{fn concat(c.ACcodigodesc, {fn concat(' - ',c.ACdescripcion)})}   as Clase, 
		{fn concat(ct.ACcodigodesc, {fn concat(' - ',ct.ACdescripcion)})} as Categoria
	from AFIndices afi
		inner join AClasificacion c
		 on c.ACcodigo = afi.ACcodigo
		and c.ACid     = afi.ACid
		and c.Ecodigo  = afi.Ecodigo
		inner join ACategoria ct
		   on ct.Ecodigo = c.Ecodigo
			 and ct.ACcodigo = c.ACcodigo
	where afi.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	and afi.AFIperiodo = <cfqueryparam value="#form.AFIperiodo#" cfsqltype="cf_sql_integer" >

	group by afi.AFIperiodo, afi.AFImes, c.ACcodigo, c.ACid, ct.ACcodigo, {fn concat(c.ACcodigodesc, {fn concat(' - ',c.ACdescripcion)})}, {fn concat(ct.ACcodigodesc, {fn concat(' - ',ct.ACdescripcion)})}
	order by 7,8,1,2

	<!--- select AFIperiodo, AFImes, avg(AFIindice) as IndiceProm
	from AFIndices
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	and AFIperiodo = <cfqueryparam value="#form.AFIperiodo#" cfsqltype="cf_sql_integer" >
	group by AFIperiodo, AFImes  --->
</cfquery>
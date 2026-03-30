
<cfset lvarReturn = "">

<cfif isDefined("form.jtreeListaItem") and isDefined("form.esCorporativo") and form.esCorporativo>
	<cfset vListaEmp = form.jtreeListaItem >  
<cfelse>
	<cfset vListaEmp = session.Ecodigo > 	
</cfif>


<!--- Devuelve la lista de grupos de cargas de las empresas seleccionadas --->
<cfif isdefined('form.GetListGC')>
	<!--- Obtiene los grupos de cargas de una o mas empresas relacionadas --->
	<cf_translatedata name="get" tabla="ECargas" col="ECdescripcion" returnvariable="LvarECdescripcion">
	<cfquery name="rsListGC" datasource="#session.DSN#">
		select distinct ec.ECcodigo, #LvarECdescripcion# as ECdescripcion
		from ECargas ec 
		where ec.Ecodigo in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#vListaEmp#" list="true">)
		order by #LvarECdescripcion#
	</cfquery>

	<cfset lvarReturn = serializeJSON(rsListGC)>
</cfif>


<!--- Devuelve las cargas relacionadas al grupo de cargas seleccionado --->
<cfif isdefined('form.GetListCargas')>
	<!--- Obtiene el detalle del grupo de cargas seleccionado --->
	<cf_translatedata name="get" tabla="DCargas" col="DCdescripcion" returnvariable="LvarDCdescripcion">	
	<cfquery name="rsListCargas" datasource="#session.DSN#">
		select distinct dc.DCcodigo, #LvarDCdescripcion# as DCdescripcion
		from ECargas ec 
		inner join DCargas dc
		    on ec.ECid = dc.ECid
		    and ec.Ecodigo = dc.Ecodigo
		where ec.Ecodigo in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#vListaEmp#" list="true">)
		<cfif isDefined("form.ECcodigo")>
			and ec.ECcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.ECcodigo#">
		</cfif>
		order by dc.DCcodigo
	</cfquery>

	<cfset lvarReturn = serializeJSON(rsListCargas)>
</cfif>	

<cfoutput>#lvarReturn#</cfoutput>
<cfparam name="url.SNCEid" default="0">
<cfparam name="url.SNCDid" default="0">
<cfquery datasource="#Session.DSN#" name="rsID_concepto_gasto">
	select 
		c.SNCDdescripcion, 
		c.SNCDid,
		c.SNCEid
	from SNClasificacionD c
		inner join SNClasificacionE t
	on  c.SNCEid = t.SNCEid
	where Ecodigo = #session.Ecodigo#
	and c.SNCEid= #url.SNCEid#
</cfquery>
<cfoutput>
	<select name="Concepto" id="Concepto" tabindex="1">
	<cfloop query="rsID_concepto_gasto">
		<option value="#rsID_concepto_gasto.SNCDid#"
			<cfif rsID_concepto_gasto.SNCDid EQ url.SNCDid>selected</cfif>>
			#rsID_concepto_gasto.SNCDdescripcion#
		</option>
	</cfloop>
	</select>
</cfoutput>


	

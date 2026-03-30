<cfif isdefined("url.LCid") and Len(Trim(url.LCid)) and isdefined("url.sufijo")
	  and isdefined("url.pais") and Len(Trim(url.pais)) and isdefined("url.conexion") and Len(Trim(url.conexion))>
	<cfquery name="rsDivision" datasource="#url.conexion#">
		select a.DPnivel, a.DPnombre
		from DivisionPolitica a
		where a.Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#url.pais#">
		order by a.DPnivel
	</cfquery>

	<cfquery name="rsNiveles" datasource="#url.conexion#">
		select coalesce(min(DPnivel), 0) as minNivel, coalesce(max(DPnivel), 0) as maxNivel
		from DivisionPolitica
		where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#url.pais#">
	</cfquery>
	<cfset minnivel = rsNiveles.minNivel>
	<cfset maxnivel = rsNiveles.maxNivel>
	<cfset idactual = url.LCid>
	<cfloop condition="maxnivel GTE minnivel">
		<cfquery name="rsLocalidad#maxnivel#" datasource="#url.conexion#">
			select LCid, LCcod, LCnombre, LCidPadre
			from Localidad
			where LCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idactual#">
		</cfquery>
		<cfset idactual = Evaluate('rsLocalidad#maxnivel#.LCidPadre')>
		<cfset maxnivel = maxnivel - 1>
	</cfloop>

	<cfoutput>
	<script language="JavaScript" type="text/javascript">
		window.parent.CargarValoresLocalidadTodo#url.sufijo#(<cfloop query="rsDivision">
			'#Evaluate("rsLocalidad"&DPnivel&".LCid")#','#Evaluate("rsLocalidad"&DPnivel&".LCcod")#','#Evaluate("rsLocalidad"&DPnivel&".LCnombre")#',</cfloop>
			'dummy'
		);
	</script>
	</cfoutput>
</cfif>
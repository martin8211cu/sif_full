<cfif isdefined("form.action") and form.action EQ "getDocmunento" and isdefined("form.origen") and form.origen EQ "TSGS">
	<cfquery name="getDoc" datasource="#Session.DSN#">
		select top 1 GELGnumeroDoc, cast(CONVERT(VARCHAR(10),GELGfecha,126) as varchar) as GELGfecha,
		ltrim(rtrim(cast(glg.SNcodigo as varchar))) SNcodigo,ltrim(rtrim(cast(SNnumero as varchar))) SNnumero,gl.TESBid,
		ltrim(rtrim(GELGproveedor)) GELGproveedor,GELGproveedorId,
		glg.Mcodigo, GELGtipoCambio, Rcodigo,TimbreFiscal
		from CERepoTMP rt
		inner join GEliquidacionGasto glg on rt.ID_Linea = glg.GELGid
		inner join GEliquidacion gl on gl.GELid = glg.GELid
		left join SNegocios sn on sn.Ecodigo= glg.Ecodigo and sn.SNcodigo=glg.SNcodigo
		where rt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and rt.Origen = 'TSGS'
			and rt.ID_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GELid#">
			and glg.GELGnumeroDoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GELGnumeroDoc#">
	</cfquery>
	<cfscript>
		theJSON = SerializeJSON(getDoc);
		writeOutput(theJSON);
	</cfscript>
</cfif>

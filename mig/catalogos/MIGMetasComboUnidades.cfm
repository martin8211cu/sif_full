
<cfsetting enablecfoutputonly="yes">
<cfif isdefined ('url.MIGMid') and #url.MIGMid# GT 0>

	<cfquery name="rsUnidades" datasource="#session.dsn#">
		select a.Ucodigo,b.Udescripcion
		from MIGMetricas a
			inner join Unidades b
				on rtrim(a.Ucodigo)=rtrim(b.Ucodigo)
				and a.Ecodigo=b.Ecodigo
		where a.MIGMid=#url.MIGMid#					
		and a.Ecodigo=#session.Ecodigo#
		and a.MIGMesmetrica='I'
	</cfquery>
</cfif>

<cfif isdefined('url.modoD') and len(trim(url.modoD))>
	<cfset modoD = url.modoD>
</cfif>

<cfoutput>
	<select name="Concepto" id="Concepto" tabindex="1" disabled="disabled">
		<cfif isdefined('rsUnidades') and rsUnidades.recordcount gt 0 and #url.MIGMid# GT 0>
			<cfloop query="rsUnidades">
				<option value="#rsUnidades.Ucodigo#"<cfif modoD neq "ALTA" and trim(rsUnidades.Ucodigo)  eq trim(rsUnidades.Ucodigo)>selected="selected" </cfif>>
					#rsUnidades.Ucodigo#
				</option>
			</cfloop>
		</cfif>
	</select>
</cfoutput>




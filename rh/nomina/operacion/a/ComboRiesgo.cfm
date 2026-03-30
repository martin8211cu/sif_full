<cfsetting enablecfoutputonly="yes">


<cfif isdefined ('url.xRHTsubcomportam') and #url.xRHTsubcomportam# EQ 1>
	<cfquery datasource="sifcontrol" name="rsTipoRiesgo">
		select *
			from RHItiporiesgo
		where RHIcodigo > 0
	</cfquery>
<cfelse>
	<cfquery datasource="sifcontrol" name="rsTipoRiesgo">
		select *
		from RHItiporiesgo
			where RHIcodigo = 0
	</cfquery>
</cfif>

<cfoutput>

	<select name="TipoRiesgo" id="TipoRiesgo">  
		<cfif isdefined('rsTipoRiesgo') and rsTipoRiesgo.recordcount gt 0>
			<cfloop query="rsTipoRiesgo">
				<option value="#rsTipoRiesgo.RHIcodigo#">#HtmlEditFormat(rsTipoRiesgo.RHIdescripcion)#</option>
			</cfloop>
		</cfif>
	</select>
</cfoutput>




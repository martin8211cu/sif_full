<cfsetting enablecfoutputonly="yes">

<cfif isdefined ('url.xTipoRiesgo') and #url.xTipoRiesgo# GT 0 and isdefined('url.xRHTsubcomportam') and url.xRHTsubcomportam EQ 1>
	<cfquery datasource="sifcontrol" name="rsConsecuencia">
		select *
			from RHIconsecuencia
	</cfquery>
<cfelse>
	<cfquery datasource="sifcontrol" name="rsConsecuencia">
		select *
		from RHIconsecuencia
			where RHIcodigo = 0
	</cfquery>
</cfif>

<cfoutput>
	<select name="Consecuencia" id="Consecuencia"onchange="ajaxFunction1_ComboControlIncapacidad();">  
		<cfif isdefined('rsConsecuencia') and rsConsecuencia.recordcount gt 0>
			<cfloop query="rsConsecuencia">
				<option value="#rsConsecuencia.RHIcodigo#">#HtmlEditFormat(rsConsecuencia.RHIdescripcion)#</option>
			</cfloop>
		</cfif>
	</select>
</cfoutput>




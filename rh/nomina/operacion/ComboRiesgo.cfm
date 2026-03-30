<cfsetting enablecfoutputonly="yes">

<cfif isdefined ('url.xRHTsubcomportam') and #url.xRHTsubcomportam# EQ 1><!--- Riesgo de Trabajo --->
	<cfquery datasource="sifcontrol" name="rsTipoRiesgo">
		select *
			from RHItiporiesgo
		where RHIcodigo in (1,2,3)
	</cfquery>
<cfelseif IsDefined('url.xRHTsubcomportam') and #url.xRHTsubcomportam# eq 2><!--- Enfermedad general --->

	<cfquery datasource="sifcontrol" name="rsTipoRiesgo">
		select *
		from RHItiporiesgo
			where RHIcodigo = 0
	</cfquery>
<cfelseif IsDefined('url.xRHTsubcomportam') and #url.xRHTsubcomportam# eq 3><!--- Maternidad --->

	<cfquery datasource="sifcontrol" name="rsTipoRiesgo">
		select *
		from RHItiporiesgo
			where RHIcodigo in (6,7,8)
	</cfquery>
<cfelse ><!--- NA --->

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




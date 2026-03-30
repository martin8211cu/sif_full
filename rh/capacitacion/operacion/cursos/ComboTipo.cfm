<cfsetting enablecfoutputonly="yes">
<cfif isdefined ('url.RHIid') and #url.RHIid# GT 0>
	<cfquery datasource="#Session.DSN#" name="rsID_tipo">
		select s.RHTSid,RHTScodigo,RHTSdescripcion from RHTiposServxInst si
		inner join RHTiposServ s
		on s.RHTSid=si.RHTSid
		and s.Ecodigo=si.Ecodigo
		where s.Ecodigo=#session.Ecodigo#
		and si.RHIid=#url.RHIid#
	</cfquery>
<cfelse>
	<cfquery name="rsTipo" datasource="#Session.DSN#" >
			select s.RHTSid,RHTScodigo,RHTSdescripcion from RHTiposServxInst si
					inner join RHTiposServ s
					on s.RHTSid=si.RHTSid
					and s.Ecodigo=si.Ecodigo
					where s.Ecodigo=#session.Ecodigo#
	</cfquery>

</cfif>

<cfoutput>
	<select name="RHTSid" id="RHTSid" tabindex="1">
		<cfif isdefined('rsID_tipo') and rsID_tipo.recordcount gt 0 and #url.RHIid# GT 0>
			<cfloop query="rsID_tipo">
				<option value="#rsID_tipo.RHTSid#"<cfif  rsID_tipo.RHTSid  eq rsID_tipo.RHTSid>selected="selected" </cfif>>
					#rsID_tipo.RHTScodigo#-#rsID_tipo.RHTSdescripcion#
				</option>
			</cfloop>
		<cfelseif isdefined('rsTipo')>	
					<cfloop query="rsTipo">
						<option value="#rsTipo.RHTSid#"selected="selected">#rsTipo.RHTScodigo#-#rsTipo.RHTSdescripcion#</option>
					</cfloop>
		<cfelse>
			<script language="javascript1.2">
				alert('No existen Tipos de Servicios asociados al Instructor')
			</script>
		</cfif>
	</select>
</cfoutput>
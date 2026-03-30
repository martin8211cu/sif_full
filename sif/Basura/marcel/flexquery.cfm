<cfsetting enablecfoutputonly="yes">
<cfquery name="rs" datasource="minisif">
	select * from Empresas
</cfquery>
<cfxml casesensitive="yes" variable="rsxml">
<cfoutput>
<empresas>
	<empresa>
</cfoutput>	
		<cfoutput query="rs">
 			<nombre>
				#Edescripcion#
			</nombre>
		</cfoutput>
<cfoutput>
	</empresa>
</empresas>	
</cfoutput>
</cfxml>
<cfoutput>#rsxml#</cfoutput>


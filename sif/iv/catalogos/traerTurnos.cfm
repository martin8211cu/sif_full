<cfif isdefined("url.formulario") and len(trim(url.formulario))>
	<cfset form.formulario = url.formulario>
</cfif>

<cfif isdefined("url.Codigo_turno") and len(trim(url.Codigo_turno))>
	<cfquery name="rs" datasource="#session.DSN#">
		select rtrim(Codigo_turno) as Codigo_turno, Tdescripcion, Turno_id 
		from Turnos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Codigo_turno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(ucase(url.Codigo_turno))#">
		order by Tdescripcion
	</cfquery>
	<script language="javascript1.2" type="text/javascript">
		<cfoutput>
		<cfif rs.recordCount gt 0>
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.Codigo_turno.value = '#rs.Codigo_turno#';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.Tdescripcion.value = '#rs.Tdescripcion#';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.Turno_id.value = '#rs.Turno_id#';
		<cfelse>			
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.Codigo_turno.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.Tdescripcion.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.Turno_id.value = '';
		</cfif>
		</cfoutput>
	</script>
</cfif>



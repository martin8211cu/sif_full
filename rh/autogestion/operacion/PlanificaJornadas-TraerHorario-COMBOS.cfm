<cfif isdefined("url.RHJid") and len(trim(url.RHJid))>
	<cfquery name="rsHorario" datasource="#session.DSN#">
		select case when datepart(hh, a.RHJhoraini) > 12 then 
						datepart(hh, a.RHJhoraini) - 12
					when datepart(hh, a.RHJhoraini) = 0 then 
						12 
					else 						
						datepart(hh, a.RHJhoraini) 
				end as hinicio,
			   datepart(mi, a.RHJhoraini) as minicio,
			   case when datepart(hh, a.RHJhoraini) < 12 then 'AM' else 'PM' end as tinicio,
			   case when datepart(hh, a.RHJhorafin) > 12 then 
			   			datepart(hh, a.RHJhorafin) - 12
					when datepart(hh, a.RHJhorafin) = 0 then 
						12 
					else datepart(hh, a.RHJhorafin) end as hfinal,
			   datepart(mi, a.RHJhorafin) as mfinal,
			   case when datepart(hh, a.RHJhorafin) < 12 then 'AM' else 'PM' end as tfinal
		from RHJornadas a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHJid#">
	</cfquery>
	<cfif rsHorario.RecordCount NEQ 0>
		<script type="text/javascript" language="javascript1.2">
			<cfoutput>
				<cfoutput>
				//Hora inicio jornada
				window.parent.document.#url.form#.#url.hinicio#.value = '#trim(rsHorario.hinicio)#';
				window.parent.document.#url.form#.#url.minicio#.value = '#trim(rsHorario.minicio)#';
				window.parent.document.#url.form#.#url.sinicio#.value = '#rsHorario.tinicio#';
				//Hora finalizacion jornada
				window.parent.document.#url.form#.#url.hfin#.value = '#trim(rsHorario.hfinal)#';
				window.parent.document.#url.form#.#url.mfin#.value = '#trim(rsHorario.mfinal)#';
				window.parent.document.#url.form#.#url.sfin#.value = '#rsHorario.tfinal#';
				</cfoutput>
			</cfoutput>
		</script>
	</cfif>
</cfif>

<cfif isdefined("url.RHJid") and len(trim(url.RHJid)) and isdefined("url.psOrigen")>
	<cfif url.psOrigen EQ 'L'><!----Cuando se llama de las lista---->
		<cfquery name="rsHorario" datasource="#session.DSN#">
			select case when <cf_dbfunction name="date_part"   args="hh, a.RHJhoraini"> > 12 then 
							<cf_dbfunction name="date_part"   args="hh, a.RHJhoraini"> - 12
						when <cf_dbfunction name="date_part"   args="hh, a.RHJhoraini"> = 0 then 
							12 
						else 						
							<cf_dbfunction name="date_part"   args="hh, a.RHJhoraini"> 
					end as hinicio,
				   <cf_dbfunction name="date_part"   args="mi, a.RHJhoraini"> as minicio,
				   case when <cf_dbfunction name="date_part"   args="hh, a.RHJhoraini"> < 12 then 'AM' else 'PM' end as tinicio,
				   case when <cf_dbfunction name="date_part"   args="hh, a.RHJhorafin"> > 12 then 
							<cf_dbfunction name="date_part"   args="hh, a.RHJhorafin"> - 12
						when <cf_dbfunction name="date_part"   args="hh, a.RHJhorafin"> = 0 then 
							12 
						else <cf_dbfunction name="date_part"   args="hh, a.RHJhorafin"> end as hfinal,
				   <cf_dbfunction name="date_part"   args="mi, a.RHJhorafin"> as mfinal,
				   case when <cf_dbfunction name="date_part"   args="hh, a.RHJhorafin"> < 12 then 'AM' else 'PM' end as tfinal
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
	<cfelse>
		<cf_dbfunction name="date_part"   args="hh, a.RHJhoraini" returnvariable="Lvar_date_part_hh_RHJhoraini">
		<cf_dbfunction name="to_char"   args="#Lvar_date_part_hh_RHJhoraini#" returnvariable="Lvar_to_char_date_part_hh_RHJhoraini">
		<cf_dbfunction name="date_part"   args="mi, a.RHJhoraini" returnvariable="Lvar_date_part_mi_RHJhoraini">
		<cf_dbfunction name="to_char"   args="#Lvar_date_part_mi_RHJhoraini#" returnvariable="Lvar_to_char_date_part_mi_RHJhoraini">
		<cf_dbfunction name="date_part"   args="hh, a.RHJhorafin" returnvariable="Lvar_date_part_hh_RHJhorafin">
		<cf_dbfunction name="to_char"   args="#Lvar_date_part_hh_RHJhorafin#" returnvariable="Lvar_to_char_date_part_hh_RHJhorafin">
		<cf_dbfunction name="date_part"   args="mi, a.RHJhorafin" returnvariable="Lvar_date_part_mi_RHJhorafin">
		<cf_dbfunction name="to_char"   args="#Lvar_date_part_mi_RHJhorafin#" returnvariable="Lvar_to_char_date_part_mi_RHJhorafin">
		<cfquery name="rsHorario" datasource="#session.DSN#">
			select 	{fn concat(case len(#PreserveSingleQuotes(Lvar_to_char_date_part_hh_RHJhoraini)#) when 1 then
								{fn concat('0',#PreserveSingleQuotes(Lvar_to_char_date_part_hh_RHJhoraini)#)}
							else										
								#PreserveSingleQuotes(Lvar_to_char_date_part_hh_RHJhoraini)#
							end,
						{fn concat(':',
							case len(#PreserveSingleQuotes(Lvar_to_char_date_part_mi_RHJhoraini)#) when 1 then
								{fn concat('0',#PreserveSingleQuotes(Lvar_to_char_date_part_mi_RHJhoraini)#)}
							else
								#PreserveSingleQuotes(Lvar_to_char_date_part_mi_RHJhoraini)#
							end
						)}
					)} as HoraInicio,
				   {fn concat(case len(#PreserveSingleQuotes(Lvar_to_char_date_part_hh_RHJhorafin)#) when 1 then
								{fn concat('0',#PreserveSingleQuotes(Lvar_to_char_date_part_hh_RHJhorafin)#)}
							else										
								#PreserveSingleQuotes(Lvar_to_char_date_part_hh_RHJhorafin)#
							end,
						{fn concat(':',
							case len(#PreserveSingleQuotes(Lvar_to_char_date_part_mi_RHJhorafin)#) when 1 then
								{fn concat('0',#PreserveSingleQuotes(Lvar_to_char_date_part_mi_RHJhorafin)#)}
							else
								#PreserveSingleQuotes(Lvar_to_char_date_part_mi_RHJhorafin)#
							end
						)}
					)} as HoraFinal				  
			from RHJornadas a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHJid#">
		</cfquery>	
		<cfif rsHorario.RecordCount NEQ 0>
			<script type="text/javascript" language="javascript1.2">
				<cfoutput>
					<cfoutput>
					window.parent.document.#url.form#.RHPJffinalH_#url.idObjeto#.value = '#trim(rsHorario.HoraFinal)#';
					window.parent.document.#url.form#.RHPJfinicioH_#url.idObjeto#.value = '#trim(rsHorario.HoraInicio)#';
					</cfoutput>
				</cfoutput>
			</script>
		</cfif>
	</cfif><!---Fin de si el origen de la lista---->	
</cfif>

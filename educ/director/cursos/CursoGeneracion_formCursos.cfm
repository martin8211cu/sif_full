<cfquery name="rsMateria" datasource="#Session.DSN#">
	select b.Mcodificacion,
			b.Mnombre,
			b.Mcreditos,
			b.Mrequisitos
	from Materia b
	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and b.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
</cfquery>
<cfquery name="listaCursos" datasource="#Session.DSN#">
	select convert(varchar, a.Ccodigo) as Ccodigo, 
			a.Csecuencia as Grupo,
			a.PEcodigo,
			a.CsolicitudMaxima as Cupo,
			isnull ( (select d.Pnombre + ' ' + d.Papellido1 + ' ' + d.Papellido2
						from Docente d
						where a.DOpersona = d.DOpersona)
					,'(NO ASIGNADO)')
			as Profesor,
			s.Snombre as Sede,
			( select count(1)
			from Horario h
			where h.Ccodigo = a.Ccodigo ) as HorarioCurso
	from Curso a, Sede s
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	<!--- Ciclo Lectivo de Universidad --->
	<cfif form.CILtipoCicloDuracion EQ "E">
	and a.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo#">
	<!--- Ciclo Lectivo de Colegio --->
	<cfelse>
	and a.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PLcodigo#">
	</cfif>
	<cfif isdefined("form.Scodigo") and form.Scodigo GT 0>
	and a.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Scodigo#">
	</cfif>
	<cfif session.MoG EQ "G">
	and a.Cestado = 0
	<cfelse>
	and a.Cestado = 1
	</cfif>
	and a.Scodigo *= s.Scodigo
	order by a.Csecuencia
</cfquery>

<cfoutput>
<table width="100%"  border="0" cellspacing="0" cellpadding="2">
  <tr>
	<td class="tituloListas">C&oacute;digo</td>
	<td class="tituloListas">Materia</td>
	<td class="tituloListas" align="center">Cr&eacute;ditos</td>
	<td class="tituloListas">Requisitos</td>
  </tr>
  <tr>
		<td height="25" nowrap>#rsMateria.Mcodificacion#</td>
		<td height="25" nowrap>#rsMateria.Mnombre#</td>
		<td height="25" align="center" nowrap>#rsMateria.Mcreditos#</td>
		<td height="25" nowrap>#rsMateria.Mrequisitos#</td>
  </tr>
</table>
<table width="100%"  border="0" cellspacing="0" cellpadding="2">
  <tr>
	<td class="tituloListas" align="center">Grupo</td>
	<td class="tituloListas">Cupo</td>
	<td class="tituloListas">Sede</td>
	<td class="tituloListas">Horario</td>
	<td class="tituloListas">Profesor</td>
	<td class="tituloListas" align="center">&nbsp;</td>
  </tr>
  <cfloop query="listaCursos">
	  <!--- Consulta del Horario del Curso --->
	  <cfquery name="rsHorario" datasource="#Session.DSN#">
		  select (case a.HOdia when 1 then 'D' when 2 then 'L' when 3 then 'K' when 4 then 'M' when 5 then 'J' when 6 then 'V' when 7 then 'S' else '' end) as Dia, 
				 a.HOinicio, 
				 a.HOfinal, 
				 case when a.AUcodigo is null then '(No asig)' else b.AUcodificacion end as AUcodificacion
		  from Horario a, Aula b
		  where a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#listaCursos.Ccodigo#">
		  and a.AUcodigo *= b.AUcodigo
		  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  order by a.HOdia, a.HOinicio, a.HOfinal
	  </cfquery>
	  
	  <tr>
		<td class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>" height="25" align="center" nowrap>#numberformat(Grupo,"00")#</td>
		<td class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>" height="25" nowrap>#Cupo#</td>
		<td class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>" height="25" nowrap>#Sede#</td>
		<td class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>" height="25" nowrap>
			<cfif rsHorario.recordCount EQ 0>
			(NO ASIGNADO)
			<cfelse>
				<table border="0" width="100%" cellpadding="0" cellspacing="0">
					<cfloop query="rsHorario">
						<tr>
							<td width="4%" nowrap><strong>#Dia#</strong></td>
							<td width="20%" nowrap>&nbsp;#HOinicio#&nbsp;-&nbsp;#HOfinal#</td>
							<td nowrap>&nbsp;<strong>#AUcodificacion#</strong></td>
						</tr>
					</cfloop>
				</table>
			</cfif>
		</td>
		<td class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>" height="25" nowrap>#Profesor#</td>
		<td class="<cfif CurrentRow MOD 2>listaPar<cfelse>listaNon</cfif>" height="25" align="center" nowrap>
			<input type="image" src="/cfmx/educ/imagenes/iconos/leave_sel.gif" title="Trabajar con un Curso Incompleto" onClick="javascript:sbCambiaCurso(#form.Mcodigo#,#Ccodigo#);return false;">
		</td>
	  </tr>
  </cfloop>
</table>
</cfoutput>
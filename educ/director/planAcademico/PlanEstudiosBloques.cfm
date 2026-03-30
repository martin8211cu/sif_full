<cffunction name="fnPlural" output="true" returntype="string">
	<cfargument name="palabras" required="true">
	
	<cfscript>
	  palabras = trim(palabras) & " ";
	  LvarPlural = "";
	  ant = 1;
	  i = find(" ",palabras);
	  while (i gt 0)
	  {
	    LvarPlural = LvarPlural & mid(palabras, ant, i-ant);
		ant = i + 1;
	    LvarLetra = mid(palabras,i-1,1);
		if ( find(LvarLetra,"aeiouAEIOU") GT 0 )
		  LvarPlural = LvarPlural & "s ";
		else if (LvarLetra NEQ " ")
		  LvarPlural = LvarPlural & "es ";
		i = find(" ", palabras, ant);
	  }
	  return trim(LvarPlural);
	</cfscript>
</cffunction>

<!---       Consultas       --->
<cfquery name="rsPES" datasource="#session.DSN#">
	Select PESestado, PESdesde, PEShasta, PESmaxima, isnull(PESbloques, 0) as PESbloques, 
			GAnombre + ' en ' + pes.PESnombre + ' (' + pes.PEScodificacion + ')' as PESnombre,
			pes.CILcodigo CILcodigo, CILnombre, CILtipoCicloDuracion, CLTcicloEvaluacion, CILcicloLectivo,
			ca.CARcodigo as CARcodigo, CARnombre + ' (' + CARcodificacion + ')' as CARnombre, 
			Fnombre + ' (' + Fcodificacion + ')' as Fnombre,
			ESnombre + ' (' + EScodificacion + ')' as ESnombre
	from PlanEstudios pes, GradoAcademico ga,
		CicloLectivo cil, Carrera ca, Escuela es, Facultad f
	where pes.PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
	  and pes.GAcodigo = ga.GAcodigo
	  and pes.CILcodigo = cil.CILcodigo
	  and pes.CARcodigo  = ca.CARcodigo
	  and ca.EScodigo  = es.EScodigo
	  and es.Fcodigo = f.Fcodigo
</cfquery>

<cfquery name="rsPBL_MP" datasource="#session.DSN#">
	Select 	convert(varchar,pbl.PBLsecuencia) as PBLsecuencia, 
			pbl.PBLnombre,
			mp.MPcodigo,
			m.Mcodigo, 
			case m.Mtipo
				when 'M' then m.Mcodificacion else mp.MPcodificacion
			end Mcodificacion, 
			case m.Mtipo
				when 'M' then m.Mnombre else mp.MPnombre
			end Mnombre,
			m.Mtipo, m.Mcreditos, isnull(ltrim(m.Mrequisitos),'--') as Mrequisitos
	from PlanEstudiosBloque pbl, MateriaPlan mp, Materia m
	where pbl.PEScodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
	  and pbl.PEScodigo    *= mp.PEScodigo
	  and pbl.PBLsecuencia *= mp.PBLsecuencia
	  and mp.Mcodigo       *= m.Mcodigo
	order by pbl.PBLsecuencia, mp.MPsecuencia
</cfquery>
<cfquery name="rsPBL" dbtype="query">
  select count(1) as EnBlanco
    from rsPBL_MP
   where MPcodigo is NULL
</cfquery>


<cfquery name="rsPBL_MAX_conMateria" datasource="#session.DSN#">
	select max(peb.PBLsecuencia) as PBLsecuencia 
	from PlanEstudiosBloque peb
		, MateriaPlan mp
	where 	peb.PEScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
			and peb.PEScodigo = mp.PEScodigo
			and peb.PBLsecuencia =mp.PBLsecuencia
	order by PBLsecuencia
</cfquery>

<cfif modo EQ 'ALTA'>
	<cfset PESstatus = "INACTIVO">
	<cfset LvarModificarBloques = true>
	<cfset LvarBtnActivarVersion = false>
	<cfset LvarbtnPESNuevaVersion = false>
	<cfset LvarBtnCerrarVersion = false>
<cfelseif rsPES.PESestado EQ 0>
	<cfset PESstatus = "INACTIVO">
	<cfset LvarModificarBloques = true>
	<cfset LvarBtnActivarVersion = true>
	<cfset LvarbtnPESNuevaVersion = false>
	<cfset LvarBtnCerrarVersion = false>
<cfelseif rsPES.PESestado EQ 2>
	<cfset PESstatus = "CERRADO">
	<cfset LvarModificarBloques = false>
	<cfset LvarBtnActivarVersion = true>
	<cfset LvarbtnPESNuevaVersion = false>
	<cfset LvarBtnCerrarVersion = false>
<cfelseif lsDateFormat(now(),"YYYYMMDD") LT lsDateFormat(rsPES.PESdesde,"YYYYMMDD")>
	<cfset PESstatus = "ESTARA VIGENTE A PARTIR DE #lsDateFormat(rsPES.PESdesde,"DD/MM/YYYY")#">
	<cfset LvarModificarBloques  = false>
	<cfset LvarBtnActivarVersion = false>
	<cfset LvarbtnPESNuevaVersion   = false>
	<cfset LvarBtnCerrarVersion  = true>
<cfelseif rsPES.PEShasta EQ "" or lsDateFormat(now(),"YYYYMMDD") LTE lsDateFormat(rsPES.PEShasta,"YYYYMMDD")>
	<cfif rsPES.PEShasta EQ "">
		<cfset PESstatus = "VIGENTE PARA ESTUDIANTES NUEVOS">
	<cfelse>
		<cfset PESstatus = "VIGENTE PARA ESTUDIANTES NUEVOS HASTA #lsDateFormat(rsPES.PEShasta,"DD/MM/YYYY")#">
	</cfif>
	<cfset LvarModificarBloques = false>
	<cfset LvarBtnActivarVersion = false>
	<cfset LvarbtnPESNuevaVersion = true>
	<cfset LvarBtnCerrarVersion  = true>
<cfelseif rsPES.PESmaxima EQ "" or lsDateFormat(now(),"YYYYMMDD") LTE lsDateFormat(rsPES.PESmaxima,"YYYYMMDD")>
	<cfif rsPES.PESmaxima EQ "">
		<cfset PESstatus = "VIGENTE PARA ESTUDIANTES ANTIGUOS">
	<cfelse>
		<cfset PESstatus = "VIGENTE PARA ESTUDIANTES ANTIGUOS HASTA #lsDateFormat(rsPES.PESmaxima,"DD/MM/YYYY")#">
	</cfif>
	<cfset LvarModificarBloques = false>
	<cfset LvarBtnActivarVersion = false>
	<cfset LvarbtnPESNuevaVersion = false>
	<cfset LvarBtnCerrarVersion  = true>
<cfelse>
	<cfset PESstatus = "OBSOLETO DESDE #lsDateFormat(rsPES.PESdesde,"DD/MM/YYYY")#">
	<cfset LvarModificarBloques = false>
	<cfset LvarBtnActivarVersion = false>
	<cfset LvarbtnPESNuevaVersion = false>
	<cfset LvarBtnCerrarVersion  = true>
</cfif>
<cfif (rsPBL.EnBlanco GT 0 OR rsPBL_MP.recordCount EQ 0)>
	<cfset LvarBtnActivarVersion = false>
	<cfset PESstatus = PESstatus & " (PLAN INCOMPLETO)">
</cfif>

<cfif rsPES.CILtipoCicloDuracion EQ "L">
	<cfset LvarTipoDuracion = rsPES.CILcicloLectivo>
<cfelse>
	<cfset LvarTipoDuracion = rsPES.CLTcicloEvaluacion>
</cfif>
<cfset LvarTipoDuracionPlural=fnPlural(LvarTipoDuracion)>

<cf_templatecss>
<script language="JavaScript" src="../../js/qForms/qforms.js">//</script>
<script language="JavaScript" src="../../js/utilesMonto.js">//</script>

<cfoutput>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr> 
		<td align="right" class="fileLabel">#session.parametros.Facultad#:</td>
		<td align="left" class="fileLabel">#rsPES.Fnombre#</td>
	</tr>
	<tr> 
		<td align="right" class="fileLabel">#session.parametros.Escuela#:</td>
		<td align="left" class="fileLabel">#rsPES.ESnombre#</td>
	</tr>
	<tr> 
		<td align="right" class="fileLabel">Carrera:</td>
		<td align="left" class="fileLabel">#rsPES.CARnombre#</td>
	</tr>
	<tr> 
		<td align="right" class="fileLabel">Plan:</td>
		<td align="left" class="fileLabel">#rsPES.PESnombre#</td>
	</tr>
	<tr> 
		<td align="right" class="fileLabel">Estado:</td>
		<td align="left" class="fileLabel">#PESstatus#</td>
	</tr>
</table>
</cfoutput>

<cfif isdefined('form.modoPES') and form.modoPES NEQ ''>
	<cfset form.modo = form.modoPES>
</cfif>

<cfif form.modo EQ "MPcambio" AND form.T EQ "M" OR form.modo EQ "MPcambioE">
	<cfinclude template="materia_tabs.cfm">
<cfelseif form.modo EQ "MPalta" OR form.modo EQ "MPcambio">
	<cfinclude template="PlanEstudiosMateria_form.cfm">
<cfelse>
	<cfinclude template="PlanEstudiosBloques_form.cfm">
</cfif>

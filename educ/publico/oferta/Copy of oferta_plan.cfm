<cfquery datasource="#Session.DSN#" name="rsPES">	
		select  Fnombre as Fnombre, 
				ESnombre as ESnombre, 
				CARnombre as CARnombre, 
				GAnombre + ' en ' + PESnombre as PESnombre,
				p.PEScodigo as PEScodigo
		  from PlanEstudios p, Carrera c, Escuela e, Facultad f, GradoAcademico g
		 where f.Ecodigo = #session.Ecodigo#
		   and f.Fcodigo = e.Fcodigo
		   and e.EScodigo = c.EScodigo
		   and c.CARcodigo = p.CARcodigo
		   and p.GAcodigo *= g.GAcodigo
		   and p.PEScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#"> 
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsMAT">	
	select m.Mcodigo,b.PEScodigo,PBLnombre
		, isnull(MPcodificacion,Mcodificacion) as MPcodificacion
		, isnull(MPnombre,Mnombre) as MPnombre
		, case Mtipo when 'M' then 'Regular' else 'Electiva' end as Mtipo
		, Mcreditos
		, Mrequisitos
	from PlanEstudiosBloque b
		, MateriaPlan mp
		, Materia m
	where  b.PEScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#"> 
		and mp.PEScodigo = b.PEScodigo
		and mp.PBLsecuencia = b.PBLsecuencia
		and mp.Mcodigo = m.Mcodigo
	order by mp.PBLsecuencia, mp.MPsecuencia
</cfquery>

<cfquery dbtype="query" name="rsCodsMat">
	select distinct Mcodigo
	from rsMAT
</cfquery>

<cfset listaMat = ValueList(rsCodsMat.Mcodigo)>
<cfif isdefined('listaMat') and listaMat NEQ ''>
	<cfquery datasource="#Session.DSN#" name="rsMatElegibles">
		select me.Mcodigo
			, m.Mcodificacion
			, McodigoElegible
			, Mnombre
			, 'Elegible' as Mtipo
			, Mcreditos
			, Mrequisitos		
		from MateriaElegible me
			, Materia m
		where me.Mcodigo in (#listaMat#)
			and me.McodigoElegible=m.Mcodigo
	</cfquery>
</cfif>

<cfoutput>
  <table>
    <tr> 
      <td width="40%" align="right"><strong>Facultad: </strong></td>
      <td width="60%"><strong>#rsPES.Fnombre#</strong></td>
    </tr>
    <tr> 
      <td align="right"><strong>Escuela: </strong></td>
      <td><strong>#rsPES.ESnombre#</strong></td>
    </tr>
    <tr> 
      <td align="right"><strong>Carrera: </strong></td>
      <td><strong>#rsPES.CARnombre#</strong></td>
    </tr>
    <tr> 
      <td align="right"><strong>Plan de Estudios: </strong></td>
      <td><strong>#rsPES.PESnombre#</strong></td>
    </tr>
  </table>

  <form name="formOfertaAcad" method="post" action="oferta.cfm">
	<input type="hidden" name="PEScodigo" value="#form.PEScodigo#">
	<input type="hidden" name="codMATabre" value="">
	<input type="hidden" name="codMcodigo" value="">		
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr class="tituloListas">
		  <td width="0%">&nbsp;</td>
		  <td width="0%">&nbsp;</td>
		  <td colspan="2"><strong>C&oacute;digo</strong></td>
		  <td width="27%"><strong>Materia</strong></td>
		  <td width="10%"><strong>Tipo</strong></td>
		  <td width="16%"><strong>Cr&eacute;ditos</strong></td>
		  <td width="16%"><strong>Requisitos</strong></td>
		</tr>
		<cfset nomBloque = "">
		<cfloop query="rsMAT">
		  <cfif nomBloque NEQ rsMAT.PBLnombre>
			<cfset nomBloque = rsMAT.PBLnombre>
			<tr class="tituloCorte">
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td colspan="6"><strong>#rsMAT.PBLnombre#</strong></td>
			</tr>
		  </cfif>
		  <tr class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2" nowrap>
				<cfif rsMAT.Mtipo EQ 'Electiva'>
					<a href="javascript: abreElect('#rsMAT.MPcodificacion#');"><font color="##0000FF">#rsMAT.MPcodificacion#</font></a>
				<cfelse>
					<a href="javascript: documMateria('#rsMAT.Mcodigo#');">#rsMAT.MPcodificacion#</a>
			  	</cfif>
			</td>
			<td nowrap>
				<cfif rsMAT.Mtipo EQ 'Electiva'>
					<a href="javascript: abreElect('#rsMAT.MPcodificacion#');"><font color="##0000FF">&nbsp;&nbsp;#rsMAT.MPnombre#</font></a>
				<cfelse>
					<a href="javascript: documMateria('#rsMAT.Mcodigo#');">&nbsp;&nbsp;#rsMAT.MPnombre#</a>
			  	</cfif>
			</td>
			<td>
				<cfif rsMAT.Mtipo EQ 'Electiva'>
					<a href="javascript: abreElect('#rsMAT.MPcodificacion#');"><font color="##0000FF">&nbsp;&nbsp;Electiva</font></a>
				<cfelse>
					<a href="javascript: documMateria('#rsMAT.Mcodigo#');">&nbsp;&nbsp;#rsMAT.Mtipo#</a>
			  	</cfif>
			</td>
			<td align="center">
				<cfif rsMAT.Mtipo EQ 'Electiva'>
					<a href="javascript: abreElect('#rsMAT.MPcodificacion#');"><font color="##0000FF">&nbsp;&nbsp;#rsMAT.Mcreditos#</font></a>
				<cfelse>
					<a href="javascript: documMateria('#rsMAT.Mcodigo#');">&nbsp;&nbsp;#rsMAT.Mcreditos#</a>
			  	</cfif>
			</td>
			<td nowrap>
				<cfif rsMAT.Mtipo EQ 'Electiva'>
					<a href="javascript: abreElect('#rsMAT.MPcodificacion#');"><font color="##0000FF">&nbsp;&nbsp;#rsMAT.Mrequisitos#</font></a>
				<cfelse>
					<a href="javascript: documMateria('#rsMAT.Mcodigo#');">&nbsp;&nbsp;#rsMAT.Mrequisitos#</a>
			  	</cfif>
			</td>
		  </tr>
		  <cfif rsMAT.Mtipo EQ 'Electiva' and isdefined('codMATabre') and rsMAT.MPcodificacion EQ form.codMATabre>
			<cfif isdefined('rsMatElegibles') and rsMatElegibles.recordCount GT 0>
			  <cfquery dbtype="query" name="rsMatElegib">
			select * from rsMatElegibles where Mcodigo=
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMAT.Mcodigo#">
			  </cfquery>
			  <cfif isdefined('rsMatElegib') and rsMatElegib.recordCount GT 0>
				<cfloop query="rsMatElegib">
				  <tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td width="2%" nowrap>&nbsp;</td>
					<td width="29%" nowrap>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript: documMateria('#rsMAT.Mcodigo#');"><font color="##006600"><strong>	#rsMatElegib.Mcodificacion#</strong></font></a></td>
					<td nowrap>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript: documMateria('#rsMAT.Mcodigo#');"><font color="##006600"><strong>#rsMatElegib.Mnombre#</strong></font></a></td>
					<td nowrap>&nbsp;&nbsp&nbsp;&nbsp;<a href="javascript: documMateria('#rsMAT.Mcodigo#');"><font color="##006600"><strong>	Elegible</strong></font></a></td>
					<td align="center">&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript: documMateria('#rsMAT.Mcodigo#');"><font color="##006600"><strong>#rsMatElegib.Mcreditos#</strong></font></a></td>
					<td nowrap>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript: documMateria('#rsMAT.Mcodigo#');"><font color="##006600"><strong>	#rsMatElegib.Mrequisitos#</strong></font></a></td>
				  </tr>
				</cfloop>
			  </cfif>
			</cfif>
		  </cfif>
		</cfloop>
	  </table>
  </form>
  </cfoutput>

<script type="text/javascript" language="JavaScript">
	function abreElect(val){
		<cfif isdefined('form.codMATabre') and len(trim(form.codMATabre)) NEQ 0>
			if(val != "<cfoutput>#form.codMATabre#</cfoutput>")
				document.formOfertaAcad.codMATabre.value = val;		
		<cfelse>
			document.formOfertaAcad.codMATabre.value = val;						
		</cfif>

		document.formOfertaAcad.submit();
	}
	
	function documMateria(cod){
		document.formOfertaAcad.codMcodigo.value = cod;								
		document.formOfertaAcad.action = "documMateria.cfm";
		document.formOfertaAcad.submit();		
	}
</script>
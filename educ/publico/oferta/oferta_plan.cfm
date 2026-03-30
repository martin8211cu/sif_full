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

<cfquery datasource="#Session.DSN#" name="rsDocumPlan">
	Select PDOtitulo,PDOdescripcion
	from PlanDocumentacion
	where PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#"> 
	order by PDOsecuencia
</cfquery>

<cfinclude template="encOfertas.cfm">

<cfif isdefined('rsDocumPlan') and rsDocumPlan.recordCount GT 0>
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr>
			<td colspan="3" align="center">&nbsp;</td>
		  </tr>	
		  <tr>
			<td colspan="3" align="center" class="tituloMantenimiento">Documentaciones del Plan de Evaluaci&oacute;n</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>	  
		  <cfloop query="rsDocumPlan">			  	
			  <tr>
				<td width="3%">&nbsp;</td>
				<td colspan="2"><strong>#rsDocumPlan.PDOtitulo#</strong></td>
			  </tr>  			  
			  <tr>
				<td>&nbsp;</td>
				<td width="3%">&nbsp;</td>
				<td width="94%">
					#rsDocumPlan.PDOdescripcion#
				 </td>
			  </tr> 				  
		  </cfloop>
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="3"><hr></td>
		  </tr>		  
	  </table>
	</cfoutput>	  
</cfif>

<cfoutput>
  <form name="formOfertaAcad" method="post" action="oferta.cfm">
	<input type="hidden" name="PEScodigo" value="#form.PEScodigo#">
	<input type="hidden" name="Fcodigo" value="#form.Fcodigo#">	
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
			<cfif rsMAT.Mtipo EQ 'Electiva'>
				<tr style="cursor: pointer" onClick="javascript: abreElect('#rsMAT.MPcodificacion#');" class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
			<cfelse>
				<tr style="cursor: pointer" onClick="javascript: documMateria('#rsMAT.Mcodigo#');" class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">		  
			</cfif>

			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2" nowrap>
				<cfif rsMAT.Mtipo EQ 'Electiva'>
					<font color="##0000FF">#rsMAT.MPcodificacion#</font>
				<cfelse>
					#rsMAT.MPcodificacion#
				</cfif>
			</td>
			<td nowrap>
				<cfif rsMAT.Mtipo EQ 'Electiva'>
					<font color="##0000FF">&nbsp;&nbsp;#rsMAT.MPnombre#</font>
				<cfelse>
					&nbsp;&nbsp;#rsMAT.MPnombre#
				</cfif>			
			</td>
			<td>
				<cfif rsMAT.Mtipo EQ 'Electiva'>
					<font color="##0000FF">&nbsp;&nbsp;Electiva</font>
				<cfelse>
					&nbsp;&nbsp;#rsMAT.Mtipo#
			  	</cfif>
			</td>
			<td align="center">
				<cfif rsMAT.Mtipo EQ 'Electiva'>
					<font color="##0000FF">&nbsp;&nbsp;#rsMAT.Mcreditos#</font>
				<cfelse>
					&nbsp;&nbsp;#rsMAT.Mcreditos#
				</cfif>
			</td>
			<td nowrap>
				<cfif rsMAT.Mtipo EQ 'Electiva'>
					<font color="##0000FF">&nbsp;&nbsp;#rsMAT.Mrequisitos#</font>
				<cfelse>
					&nbsp;&nbsp;#rsMAT.Mrequisitos#
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
				  <tr style="cursor: pointer" onClick="javascript: documMateria('#rsMAT.Mcodigo#');" class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td width="2%" nowrap>&nbsp;</td>
					<td width="29%" nowrap>&nbsp;&nbsp;&nbsp;&nbsp;<font color="##006600"><strong>	#rsMatElegib.Mcodificacion#</strong></font></td>
					<td nowrap>&nbsp;&nbsp;&nbsp;&nbsp;<font color="##006600"><strong>#rsMatElegib.Mnombre#</strong></font></td>
					<td nowrap>&nbsp;&nbsp&nbsp;&nbsp;<font color="##006600"><strong>	Elegible</strong></font></td>
					<td align="center">&nbsp;&nbsp;&nbsp;&nbsp;<font color="##006600"><strong>#rsMatElegib.Mcreditos#</strong></font></td>
					<td nowrap>&nbsp;&nbsp;&nbsp;&nbsp;<font color="##006600"><strong>	#rsMatElegib.Mrequisitos#</strong></font></td>
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
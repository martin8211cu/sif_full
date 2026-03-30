<!---*******************************--->
<!---  área de consultas            --->
<!---*******************************--->
<cfquery name="rsConcurso" datasource="#session.DSN#">
	select RHCconcurso,RHCdescripcion,a.RHPcodigo,coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigoext,RHPdescpuesto,RHCcantplazas,a.ts_rversion
	from RHConcursos a , RHPuestos b
	where a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCCONCURSO#">
	and a.RHPcodigo = b.RHPcodigo and a.Ecodigo = b.Ecodigo
	and a.RHCestado = 50 
	order by RHCconcurso, RHCdescripcion
</cfquery>
<cfquery name="RSParticipantes" datasource="#Session.DSN#">
		select coalesce(count(*),0) as cantidad
		from RHConcursantes
		where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHCconcurso#">
</cfquery>
<cf_translatedata name="get" tabla="RHPruebas" col="RHPdescripcionpr" returnvariable="LvarRHPdescripcionpr">
<cfquery name="RSPRuebas" datasource="#Session.DSN#">
		select a.RHPcodigopr, 
		#LvarRHPdescripcionpr# as RHPdescripcionpr  || '('  ||<cf_dbfunction name="to_char" args="a.Cantidad">|| ')' RHPdescripcionpr, 
		a.Cantidad ,
		a.Peso
		from RHPruebasConcurso a ,  RHPruebas b
		where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHCconcurso#">
		and  a. Ecodigo = b. Ecodigo
		and  a.RHPcodigopr  = b.RHPcodigopr 
</cfquery>
<cf_translatedata name="get" tabla="RHEAreasEvaluacion" col="RHEAdescripcion" returnvariable="LvarRHEAdescripcion">
<cfquery name="RSEvaluacion" datasource="#Session.DSN#">
		select a.RHEAid, 
		#LvarRHEAdescripcion# as RHEAdescripcion, 
		a.RHAECpeso
		from RHAreasEvalConcurso a ,  RHEAreasEvaluacion b
		where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHCconcurso#">
		and  a.RHEAid  = b.RHEAid 
</cfquery>
<!---*******************************--->
<!---  área de Pintado              --->
<!---*******************************--->
<form action="#CurrentPage#" method="post" name="form1" >
<!---*******************************--->
<!---  Informacion del   Concurso   --->
<!---*******************************--->
	<table  width="100%"  align="center"border="0">
	  <tr>
		<td width="12%"></td>
		<td width="21%" align="left" >N&ordm;. Concurso:</td>
		<td width="67%"><strong><cfoutput>#rsConcurso.RHCCONCURSO#</cfoutput></strong></td>
	  </tr>
	  <tr>
		<td></td>
		<td align="left">Descripci&oacute;n:</td>
		<td><strong><cfoutput>#rsConcurso.RHCDESCRIPCION#</cfoutput></strong></td>
	  </tr>
	  <tr>
		<td></td>
		<td align="left">Puesto:</td>
		<td><strong><cfoutput>#rsConcurso.RHPcodigoext# #rsConcurso.RHPDESCPUESTO#</cfoutput></strong></td>
	  </tr>
	  <tr>
		<td></td>
		<td align="left">Plazas:</td>
		<td><strong><cfoutput>#rsConcurso.RHCCANTPLAZAS#</cfoutput></strong></td>
<!---*******************************--->
<!---  Participantes                --->
<!---*******************************--->
	  <cfif RSParticipantes.recordcount gt 0 and RSParticipantes.cantidad gt 0>
		  </tr>
			<tr>
			<td></td>
			<td align="left">Total de Participantes:</td>
			<td><strong><a href="javascript:Participantes()">[<cfoutput>#RSParticipantes.cantidad#</cfoutput>]</strong></a></td>
		  </tr>
	  <cfelse>
			</tr>
			<tr>
			<td></td>
			<td align="left">Total de Participantes:</td>
			<td><strong><cfoutput>#RSParticipantes.cantidad#</cfoutput></strong></td>
		  </tr>
	  </cfif>
	  <tr><td>&nbsp;</td></tr>
	</table>
<!---*******************************--->
<!---  Pruebas a Realizar          --->
<!---*******************************--->
	<table  width="100%"  align="center"border="1">
		<tr valign="top"  width="50%">
			<td>
				<table width="100%" border="0">
					<tr>
					<td colspan="4"  bgcolor="#CCCCCC" valign="top"><strong>Pruebas a Realizar</strong></td>
					</tr>
					<cfset Total = 0>  
					<cfif RSPRuebas.recordcount gt 0>
						<cfloop query="RSPRuebas">
							<tr>
							<td width="10%"               >&nbsp;</td>
							<td width="60%"><cfoutput>#RSPRuebas.RHPdescripcionpr# :</cfoutput></td>
							<td width="20%"              ><cfoutput>#LSNumberFormat(RSPRuebas.Peso,',9')#%</cfoutput></td>
							<td width="10%"				  >&nbsp;</td>
							</tr>
							<cfset Total = Total + RSPRuebas.Peso >
						</cfloop>
						<tr>
						<td width="10%"               >&nbsp;</td>
						<td colspan="2"><hr></td>
						<td width="10%"               >&nbsp;</td>
						</tr>

						<tr>
						<td width="10%"               >&nbsp;</td>
						<td width="60%">Total</td>
						<td width="20%"              ><cfoutput>#LSNumberFormat(Total,',9')#%</cfoutput></td>
						<td width="10%"               >&nbsp;</td>
						</tr>
					<cfelse>
						<tr>
						<td  colspan="4" align="center" ><strong>No hay pruebas para este concurso</strong></td>
						</tr> 
					</cfif>
				</table>
			</td>
			<td  valign="top" width="50%">
<!---*******************************--->
<!---  área de evaluación           --->
<!---*******************************--->
				<table width="100%" border="0">
					<tr>
					<td colspan="4"  align="center" bgcolor="#CCCCCC" valign="top"><strong>&Aacute;reas de Evaluaci&oacute;n</strong></td>
					</tr>
					<cfset Total = 0>  
					<cfif RSEvaluacion.recordcount gt 0>
						<cfloop query="RSEvaluacion">
							<tr>
							<td width="10%"               >&nbsp;</td>
							<td width="60%"><cfoutput>#RSEvaluacion.RHEAdescripcion# :</cfoutput></td>
							<td width="20%"              ><cfoutput>#LSNumberFormat(RSEvaluacion.RHAECpeso,',9')#%</cfoutput></td>
							<td width="10%"				  >&nbsp;</td>
							</tr>
							<cfset Total = Total + RSEvaluacion.RHAECpeso >
						</cfloop>
						<tr>
						<td width="10%"               >&nbsp;</td>
						<td colspan="2"><hr></td>
						<td width="10%"               >&nbsp;</td>
						</tr>						
						
						<tr>
						<td  width="10%"               >&nbsp;</td>
						<td  width="60%">Total</td>
						<td  width="20%"              ><cfoutput>#LSNumberFormat(Total,',9')#%</cfoutput></td>
						<td  width="10%"               >&nbsp;</td>
						</tr>
					<cfelse>
						<tr>
						<td  colspan="4" align="center" ><strong>No hay &aacute;reas de evaluaci&oacute;n para este concurso</strong></td>
						</tr> 
					</cfif>
				</table>
			</td>
		</tr>
	</table>
 	<input type="hidden" name="paso" value="<cfoutput>#Gpaso#</cfoutput>">
	<input name="RHCCONCURSO"    type="hidden" value="<cfif isdefined("rsConcurso.RHCCONCURSO")and (rsConcurso.RHCCONCURSO GT 0)><cfoutput>#rsConcurso.RHCCONCURSO#</cfoutput></cfif>">
	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsConcurso.ts_rversion#"/>
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">

<!---*******************************--->
<!---  área de Botones              --->
<!---*******************************--->
	<table border="0" cellspacing="0" cellpadding="0" width="100%">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<input type="hidden" name="botonSel" value="">
				<input type="submit" name="Anterior" value="<< Anterior" onClick="javascript: this.form.botonSel.value = this.name; if (window.funcAnterior) return funcAnterior();" tabindex="0"> 
				<cfif(RSParticipantes.recordcount mmTranslatedValueOutline="OUTLINE=%22%3Ccfif%3E%22" mmTranslatedValueOutlineID="OUTLINEID=6" gt 0 and RSParticipantes.cantidad gt 0)and (RSPRuebas.recordcount gt 0 or RSEvaluacion.recordcount gt 0)>
					<input type="submit" name="Finalizar" value="Finalizar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Está seguro(a) de que desea finalizar el Concurso?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}" tabindex="0">
				</cfif>
			</td>
		</tr>
	</table>
</form>
<!---*******************************--->
<!---  área de script               --->
<!---*******************************--->

<script language="javascript" type="text/javascript">
	function Participantes(){
		var PARAM  = "Lista_participantes.cfm?RHCCONCURSO="+document.form1.RHCCONCURSO.value
		open(PARAM,'','left=250,top=250,scrollbars=yes,resizable=yes,width=550,height=300')
	}
</script>


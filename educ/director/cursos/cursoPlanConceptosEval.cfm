<cfquery datasource="#Session.DSN#" name="rsConceptosEvalCurso">
	select 
		convert(varchar,c.Ccodigo) as Ccodigo
		, Cnombre
		, convert(varchar,cce.CEcodigo) as CEcodigo
		, CEnombre
		, convert(varchar,cce.PEcodigo) as PEcodigo
		, PEnombre
		, CCEporcentaje
		, CCEorden
	from Curso c
		, CursoConceptoEvaluacion cce
		, PeriodoEvaluacion pe
		, ConceptoEvaluacion ce
	where c.Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#"> 
		and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
		and c.Ccodigo=cce.Ccodigo
		and c.Ecodigo=pe.Ecodigo
		and cce.PEcodigo=pe.PEcodigo
		and pe.Ecodigo=ce.Ecodigo
		and cce.CEcodigo=ce.CEcodigo
	Order by PEcodigo,CCEorden,CEnombre
</cfquery>

<table width="93%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="1%">&nbsp;</td>
    <td width="45%">&nbsp;</td>
    <td width="2%">&nbsp;</td>
    <td width="52%">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="4" align="center" class="tituloMantenimiento">
		Plan de Evaluaci&oacute;n del Curso
	</td>
  </tr>
  <tr>
    <td width="1%">&nbsp;</td>
    <td width="45%">&nbsp;</td>
    <td width="2%">&nbsp;</td>
    <td width="52%">&nbsp;</td>
  </tr>
  <cfoutput>
	  <cfset columnasExtra = "">
	  <cfif isdefined("form.CILtipoCicloDuracion")>
		  <cfset columnasExtra = "'#form.CILcodigo#' as CILcodigo,
								'#form.CILtipoCicloDuracion#'	as CILtipoCicloDuracion,
								'#form.EScodigo#'	as EScodigo,						
								'#form.CARcodigo#' as CARcodigo,												
								'#form.GAcodigo#'	as GAcodigo,												
								'#form.PEScodigo#' as PEScodigo,												
								'#form.txtMnombreFiltro#'	as txtMnombreFiltro,												
								'#form.Scodigo#'	as Scodigo,												
								'#form.Mcodigo#'	as Mcodigo,												
								'#form.PLcodigo#'	as PLcodigo,">
	  </cfif>
	  <tr>  
		<td width="1%">&nbsp;</td>
		<td width="45%" valign="top">
			<form name="listaConceptos" method="post" action="CursoMantenimiento.cfm">
				<cfoutput>
					<cfif isdefined("form.CILtipoCicloDuracion")>
						<input type="hidden" name="CILcodigo" id="CILcodigo" value="#form.CILcodigo#">	
						<input type="hidden" name="CILtipoCicloDuracion" id="CILtipoCicloDuracion" value="#form.CILtipoCicloDuracion#">	
						<input type="hidden" name="PLcodigo" id="PLcodigo" value="#Form.PLcodigo#">	
						<input type="hidden" name="EScodigo" id="EScodigo" value="#Form.EScodigo#">	
						<input type="hidden" name="CARcodigo" id="CARcodigo" value="#Form.CARcodigo#">	
						<input type="hidden" name="GAcodigo" id="GAcodigo" value="#Form.GAcodigo#">
						<input type="hidden" name="PEScodigo" id="PEScodigo" value="#Form.PEScodigo#">	
						<input type="hidden" name="txtMnombreFiltro" id="txtMnombreFiltro" value="#Form.txtMnombreFiltro#">	
						<input type="hidden" name="Scodigo" id="Scodigo" value="#Form.Scodigo#">
						<input type="hidden" name="Mcodigo" id="Mcodigo" value="#form.Mcodigo#">
					</cfif>				
					<input type="hidden" name="CEcodigo" id="CEcodigo" value="">
					<input type="hidden" name="PEcodigo" id="PEcodigo" value="">
					<input type="hidden" name="Ccodigo" id="Ccodigo" value="">
					<input type="hidden" name="_ActionTag" id="_ActionTag" value="">
					<input type="hidden" name="_ROWS" id="_ROWS" value="#rsConceptosEvalCurso.recordCount#">										
				
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr bgcolor="##E4EDEF">
						<td>&nbsp;</td>
						<td width="0%">&nbsp;</td>
						<td width="36%"><strong>Concepto</strong></td>
						<td width="4%" align="center">&nbsp;</td>
						<td width="48%" align="center"><strong>Porcentaje</strong></td>
						<td width="6%" align="center">&nbsp;</td>
						<td width="6%" align="center">&nbsp;</td>
					  </tr>
					  <cfset codPeriodo = "">
					  <cfset varTotalPer = 0>
					  <cfset varCont = 0>
					  <cfset varPlanIncompl = false>
					  <cfloop query="rsConceptosEvalCurso">
						  <cfset varCont = varCont + 1>
						<cfif codPeriodo NEQ rsConceptosEvalCurso.PEcodigo>
							<cfif rsConceptosEvalCurso.CurrentRow GT 1>
								<tr>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td><strong><cfif varTotalPer LT 100><cfset varPlanIncompl = true><font size="2" color="##FF0000"><cfelseif  varTotalPer EQ 100><font size="2" color="##000000"></cfif>TOTAL</font></strong></td>
									<td align="right">&nbsp;</td>
									<td colspan="2" align="right" ><strong><cfif varTotalPer LT 100><font size="2" color="##FF0000"><cfelseif  varTotalPer EQ 100><font size="2" color="##000000"></cfif>
									#varTotalPer#</font></strong></td>
									<td align="center"><strong><cfif varTotalPer LT 100><font size="2" color="##FF0000"><cfelseif  varTotalPer EQ 100><font size="2" color="##000000"></cfif>%</font></strong></td>
								</tr>
							</cfif>
							<cfset varTotalPer = 0>										
							<cfset codPeriodo = rsConceptosEvalCurso.PEcodigo>					
							<tr class="areaFiltro">
								<td width="0%">&nbsp;</td>
								<td colspan="6"><strong>#rsConceptosEvalCurso.PEnombre#</strong></td>
							</tr>
						</cfif>
							<input type="hidden" name="CEcodigo_#rsConceptosEvalCurso.PEcodigo#_#varCont#" id="CEcodigo_#rsConceptosEvalCurso.PEcodigo#_#varCont#" value="#rsConceptosEvalCurso.CEcodigo#">
							
							<cfset varTotalPer = varTotalPer + rsConceptosEvalCurso.CCEporcentaje>
							<tr class=<cfif rsConceptosEvalCurso.CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
									<td>
										<cfif isdefined('form.Ccodigo') and isdefined('form.PEcodigo') and form.PEcodigo EQ  rsConceptosEvalCurso.PEcodigo and isdefined('form.CEcodigo') and form.CEcodigo EQ rsConceptosEvalCurso.CEcodigo>
											<img src="#Session.JSroot#/imagenes/lista/addressGo.gif" width="18" height="18">
										</cfif>											
									</td>
									<td>&nbsp;</td>
									<td>
										<cfif isdefined('qryCurso') and qryCurso.PEVcodigo EQ ''><a href="javascript: liga('#form.Ccodigo#','#rsConceptosEvalCurso.PEcodigo#','#rsConceptosEvalCurso.CEcodigo#');"></cfif>
											#rsConceptosEvalCurso.CEnombre#
										<cfif isdefined('qryCurso') and qryCurso.PEVcodigo EQ ''></a></cfif>
									</td>
									<td align="right">&nbsp;</td>
									<td align="right">
										<cfif isdefined('qryCurso') and qryCurso.PEVcodigo EQ ''><a href="javascript: liga('#form.Ccodigo#','#rsConceptosEvalCurso.PEcodigo#','#rsConceptosEvalCurso.CEcodigo#');"></cfif>
											#rsConceptosEvalCurso.CCEporcentaje#
										<cfif isdefined('qryCurso') and qryCurso.PEVcodigo EQ ''></a></cfif>
									</td>
								<td align="center"><cfif isdefined('qryCurso') and qryCurso.PEVcodigo EQ ''><a href="##"><img border="0" src="#Session.JSroot#/imagenes/iconos/array_up.gif" onClick="javascript: subir('#form.Ccodigo#','#rsConceptosEvalCurso.PEcodigo#','#rsConceptosEvalCurso.CEcodigo#');"></a></cfif></td>
								<td align="center"><cfif isdefined('qryCurso') and qryCurso.PEVcodigo EQ ''><a href="##"><img border="0" src="#Session.JSroot#/imagenes/iconos/array_dwn.gif" onClick="javascript: bajar('#form.Ccodigo#','#rsConceptosEvalCurso.PEcodigo#','#rsConceptosEvalCurso.CEcodigo#');"></a></cfif></td>
							</tr>		  
					  </cfloop>
					  					  
						<cfif rsConceptosEvalCurso.recordCount GT 0 and varTotalPer GT 0>
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td><strong><cfif varTotalPer LT 100><cfset varPlanIncompl = true><font size="2" color="##FF0000"><cfelseif  varTotalPer EQ 100><font size="2" color="##000000"></cfif>TOTAL</font></strong></td>
								<td align="right">&nbsp;</td>
								<td colspan="2" align="right" ><strong><cfif varTotalPer LT 100><font size="2" color="##FF0000"><cfelseif  varTotalPer EQ 100><font size="2" color="##000000"></cfif>#varTotalPer#</font></strong></td>
								<td align="center"><strong><cfif varTotalPer LT 100><font size="2" color="##FF0000"><cfelseif  varTotalPer EQ 100><font size="2" color="##000000"></cfif>%</font></strong></td>
							</tr>
						</cfif>			  
				  </table>
			  </cfoutput>
		    </form>
			</td>
		<td width="2%">&nbsp;</td>
		<td width="52%" valign="top">
			<cfif isdefined('qryCurso') and qryCurso.PEVcodigo EQ ''>
				<cfinclude template="cursoPlanConceptosEvaluac_form.cfm">
			</cfif>	
		</td>  
	  </tr>	
	  <tr>
		<td width="1%">&nbsp;</td>
		<td width="45%" align="center">
			<cfif varPlanIncompl EQ true>
				<font color="##FF0000">El Plan estará incompleto mientras no sume el 100%, <br>
				y por tanto no podrá utilizarse.</font>
			</cfif>
		</td>
		<td width="2%">&nbsp;</td>
		<td width="52%">&nbsp;</td>
	  </tr>
	</cfoutput>	  
</table>
<script language="javascript" type="text/javascript">
	function liga(cod1, cod2, cod3) {
		document.listaConceptos.Ccodigo.value = cod1;
		document.listaConceptos.PEcodigo.value = cod2;
		document.listaConceptos.CEcodigo.value = cod3;		
		document.listaConceptos.submit();
	}
	function bajar(cod1, cod2, cod3) {
		document.listaConceptos._ActionTag.value = "pushDown";
		document.listaConceptos.Ccodigo.value = cod1;
		document.listaConceptos.PEcodigo.value = cod2;
		document.listaConceptos.CEcodigo.value = cod3;				
		document.listaConceptos.action = "Curso_SQL.cfm";
		document.listaConceptos.submit();
	}
	function subir(cod1, cod2, cod3) {		
		document.listaConceptos._ActionTag.value = "pushUp";
		document.listaConceptos.Ccodigo.value = cod1;
		document.listaConceptos.PEcodigo.value = cod2;
		document.listaConceptos.CEcodigo.value = cod3;				
		document.listaConceptos.action = "Curso_SQL.cfm";
		document.listaConceptos.submit();
	}	
</script>
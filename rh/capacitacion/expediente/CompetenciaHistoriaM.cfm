<cfif isdefined("url.idcompetencia") and not isdefined("form.idcompetencia")>
	<cfset idcompetencia = url.idcompetencia >
</cfif>
<cfif isdefined("form.idcompetencia") and not isdefined("url.idcompetencia")>
	<cfset idcompetencia = form.idcompetencia >
</cfif>
<cfif isdefined("url.tipo") and not isdefined("form.tipo")>
	<cfset tipo = url.tipo >
</cfif>
<cfif isdefined("form.tipo") and not isdefined("url.tipo")>
	<cfset tipo = form.tipo >
</cfif>

<cfquery name="rsHistoria" datasource="#session.dsn#">
		select RHCEid, RHCEfdesde as RHCEfdesdet, RHCEfhasta as RHCEfhastat ,RHCEdominio ,RHCEjustificacion 
		from RHCompetenciasEmpleado 
		<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
			where RHOid= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOid#"> 
		<cfelse>
			where DEid= <cfqueryparam cfsqltype="cf_sql_integer" value="#DEid#"> 
		</cfif>
		and   idcompetencia =  <cfqueryparam cfsqltype="cf_sql_integer" value="#idcompetencia#">
		and   tipo = <cfqueryparam cfsqltype="cf_sql_char" value="#tipo#">
		and   Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by  RHCompetenciasEmpleado.RHCEfdesde
</cfquery>
<cfif tipo eq 'H'>
	<cfquery name="rsDescrip" datasource="#session.dsn#">
		select RHHcodigo as codigo,RHHdescripcion as descripcion ,RHHdescdet as detallado
		from RHHabilidades 
		where RHHid  = <cfqueryparam cfsqltype="cf_sql_integer" value="#idcompetencia#">
		and   Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>		
<cfelse>
	<cfquery name="rsDescrip" datasource="#session.dsn#">
		select RHCcodigo as codigo,RHCdescripcion as descripcion ,'' as detallado 
		from RHConocimientos 
		where RHCid  = <cfqueryparam cfsqltype="cf_sql_integer" value="#idcompetencia#">
		and   Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>	
</cfif>
<title>
		Historial
</title>	
<cfoutput>
<form method="post" name="Historia" >
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr>
			<td  colspan="4" class="listaCorte" align="center">
				<font size="2"><strong><cfoutput>#rsDescrip.codigo#-#rsDescrip.descripcion#</cfoutput></strong></font>
			</td>
		</tr>	
		<cfif len(trim(rsDescrip.detallado))>
			<tr>
				<td  colspan="4" class="listaCorte" align="center">
					<cfoutput>#rsDescrip.detallado#</cfoutput>
				</td>
			</tr>	
		</cfif>
		<cfif rsHistoria.recordcount gt 0>
			<tr>
				<td class="tituloListas" align="left" width="2%" height="17" nowrap></td>
				<td  width="25%" class="tituloListas" align="left"><strong>Fecha Desde</strong></td>
				<td  width="25%" class="tituloListas" align="left"><strong>Fecha Hasta</strong></td>
				<td  width="48%" class="tituloListas" align="right"><strong>Dominio(%)</strong></td>
			</tr>
			<cfloop query="rsHistoria"> 
				<tr style="cursor:pointer; background-color:##E4E8F3"
					onmouseover="style.backgroundColor='##CCCCCC';"
					onMouseOut="style.backgroundColor='##E4E8F3'"
				>
					<td><cfif isdefined("form.llave") and form.llave eq rsHistoria.RHCEid><img border="0" src="/cfmx/rh/imagenes/addressGo.gif"><cfelse>&nbsp;</cfif></td>
					<td onClick="javascript:editarH(#rsHistoria.RHCEid#,'#LSDateFormat(rsHistoria.RHCEfdesdet, "dd/mm/yyyy")#','<cfif LSDateFormat(rsHistoria.RHCEfhastat, "dd/mm/yyyy") neq '01/01/6100'>#LSDateFormat(rsHistoria.RHCEfhastat, "dd/mm/yyyy")#</cfif>','#rsHistoria.RHCEdominio#');" align="left" colspan="1"><cf_locale name="date" value="#rsHistoria.RHCEfdesdet#"/></td>
					<td onClick="javascript:editarH(#rsHistoria.RHCEid#,'#LSDateFormat(rsHistoria.RHCEfdesdet, "dd/mm/yyyy")#','<cfif LSDateFormat(rsHistoria.RHCEfhastat, "dd/mm/yyyy") neq '01/01/6100'>#LSDateFormat(rsHistoria.RHCEfhastat, "dd/mm/yyyy")#</cfif>','#rsHistoria.RHCEdominio#');" align="left" colspan="1"><cfif #LSDateFormat(rsHistoria.RHCEfdesdet, "dd/mm/yyyy")# eq '01/01/6100'><cf_translate key="LB_Indefinida"  xmlFile="/rh/generales.xml">indefinida</cf_translate><cfelse><cf_locale name="date" value="#rsHistoria.RHCEfdesdet#"/></cfif></td>
					<td onClick="javascript:editarH(#rsHistoria.RHCEid#,'#LSDateFormat(rsHistoria.RHCEfdesdet, "dd/mm/yyyy")#','<cfif LSDateFormat(rsHistoria.RHCEfhastat, "dd/mm/yyyy") neq '01/01/6100'>#LSDateFormat(rsHistoria.RHCEfhastat, "dd/mm/yyyy")#</cfif>','#rsHistoria.RHCEdominio#');" align="right"  colspan="1">#LSNumberFormat(rsHistoria.RHCEdominio,'____.__')#</td>
				</tr>
				<cfquery name="rsCursos" datasource="#session.dsn#">
					select  B.Msiglas,B.Mnombre,RHECfdesde
					from RHEmpleadoCurso A, RHMateria B
					where  A.RHECfdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(rsHistoria.RHCEfdesdet)#" >
					and   A.RHECfdesde <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(rsHistoria.RHCEfhastat)#" >
					<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
						and  A.RHOid= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHOid#">
					<cfelse>
						and  A.DEid= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
					</cfif>	
					and  A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and  A.Ecodigo = B.Ecodigo 
					and  A.Mcodigo  = B.Mcodigo  
					order by B.Mcodigo			
				</cfquery>	
				
				<cfif isdefined("form.DEid") and len(trim(form.DEid))>
					<cfquery name="rsEval" datasource="#session.dsn#">
						select B.RHEEdescripcion,B.RHEEfdesde
						from  RHListaEvalDes A, 
						RHEEvaluacionDes B,
						RHNotasEvalDes C
						where  A.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
						and A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and A.Ecodigo = B.Ecodigo
						and A.RHEEid = B.RHEEid
						
						and A.DEid = C.DEid
						and A.RHEEid = C.RHEEid
						and B.RHEEfdesde  >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(rsHistoria.RHCEfdesdet)#">
						and B.RHEEfdesde  <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(rsHistoria.RHCEfhastat)#">
						and B.RHEEestado = 3
						<cfif tipo EQ "H">
							and C.RHHid = <cfqueryparam cfsqltype="cf_sql_integer" value="#idcompetencia#">
						<cfelse>
							and C.RHCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#idcompetencia#">
						</cfif>
					</cfquery>	 
				</cfif>			
				<tr>
					<td  align="justify" colspan="4">
						<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">
						<tr>
						<td  width="20%" align="left"  nowrap valign="top">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Justificaci&oacute;n :</b>
						</td>
						<td  width="80%"align="left" valign="top">
							#rsHistoria.RHCEjustificacion#
						</td>
						</tr>
						</table>
					</td>
				</tr>
				<cfif rsCursos.recordcount gt 0 or ( isdefined("rsEval") and rsEval.recordcount gt 0) >
					<tr>
						<td  align="left" colspan="4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<a href="javascript: verdetalle('#trim(rsHistoria.CurrentRow)#');" ><img  id="img_#rsHistoria.CurrentRow#" src="/cfmx/rh/imagenes/derecha.gif"  width="10" height="10" border="0" >
							Ver Cursos	</a> 
						</td>
					</tr>				
				</cfif>
				<cfif rsCursos.recordcount gt 0 or rsEval.recordcount gt 0 >
					<tr id="TR_#rsHistoria.CurrentRow#" style="display: none;">
						<td  align="left" colspan="4">
							<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">
								<tr>
									<td  align="left" width="5%"></td>
									<td  align="left" width="25%"><b>Tipo</b></td>
									<td  align="left" width="60%"><b>descripci&oacute;n</b></td>
									<td  align="left" width="10%"><b>Fecha</b></td>
								</tr>
								<cfif rsCursos.recordcount gt 0 >
									<cfloop query="rsCursos">
										<tr>
											<td  align="left" ></td>
											<td  align="left" >Curso</td>
											<td  align="left" >#rsCursos.Msiglas#-#rsCursos.Mnombre#</td>
											<td  align="left" ><cf_locale name="date" value="#rsCursos.RHECfdesde#"/></td>
										</tr>
									</cfloop>
								</cfif>	
								<cfif isdefined("rsEval") and rsEval.recordcount gt 0 >
									<cfloop query="rsEval">
										<tr>
											<td  align="left" ></td>
											<td  align="left" >Eval.</td>
											<td  align="left" >#rsEval.RHEEdescripcion#</td>
											<td  align="left" ><cf_locale name="date" value="#rsEval.RHEEfdesde#"/></td>
										</tr>
									</cfloop>
								</cfif>								
							</table>
						</td>
					</tr>				
				</cfif>
			</cfloop>				
		<cfelse>
			<tr>
				<td  colspan="4" align="center"><strong>No hay historia para esta competencia</strong></td>
			</tr>
		</cfif>		
		<tr>
			<td  colspan="4" align="center">
				<input type="button"  id="BTN_regresar" value="Regresar" onClick="regresar();">
			</td>
		</tr>		
	</table>
	<input type="hidden" name="DEid" 	value ="<cfif isdefined("DEid") and len(trim(DEid))>#DEid#</cfif>">
	<input type="hidden" name="RHOid" 	value ="<cfif isdefined("RHOid") and len(trim(RHOid))>#RHOid#</cfif>">
	<input type="hidden" name="idcompetencia" 	value ="#idcompetencia#">
	<input type="hidden" name="tipo" 	value ="#tipo#">
	<input type="hidden" name="COMPID"	value ="#rsDescrip.codigo#">
	<input type="hidden" name="COMPDES" value ="#rsDescrip.descripcion#">
	<input type="hidden" name="COMPID"	value ="#rsDescrip.codigo#">
	<input type="hidden" name="RHCEdominio"	value ="">
	<input type="hidden" name="RHCEid" 	value ="">
	<input type="hidden" name="llave" 	value ="">
	<input type="hidden" name="RHCEfdesde" 	value ="">
	<input type="hidden" name="RHCEfhasta" 	value ="">
	<input type="hidden" name="MODOC1" 	value="ALTA">
	<input type="hidden" name="ANOTA" 	value="S">
	<input type="hidden" name="ADDCUR" 	value="S">
	<input type="hidden" name="tab" 	value="2">
</form>
</cfoutput>
<script type="text/javascript" language="javascript1.2" >
	function verdetalle(idx) {
		var tr = document.getElementById("TR_"+idx);
		var img = document.getElementById("img_"+idx);
		img.src = ((tr.style.display == "none") ? "/cfmx/rh/imagenes/abajo.gif" : "/cfmx/rh/imagenes/derecha.gif");
		tr.style.display = ((tr.style.display == "none") ? "" : "none");
	}	
	
	function editarH(RHCEid,RHCEfdesde,RHCEfhasta,RHCEdominio){
		document.Historia.RHCEid.value = RHCEid;
		document.Historia.llave.value = RHCEid;
		document.Historia.RHCEfdesde.value = RHCEfdesde;
		document.Historia.RHCEfhasta.value = RHCEfhasta;
		document.Historia.RHCEdominio.value = RHCEdominio;
		document.Historia.submit();
	}
	
	function regresar(){
		document.Historia.ANOTA.value = 'N';
		document.Historia.ADDCUR.value = 'N';
		document.Historia.submit();
	}

	
</script>

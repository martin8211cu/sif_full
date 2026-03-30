
 <cfquery name="rsCompetencias" datasource="#session.dsn#">
		select tipo,idcompetencia from RHCompetenciasEmpleado   
		where RHCEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCEid#">
		and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfquery name="rsListaCursos" datasource="#session.dsn#">
	select A.DEid,A.RHCid ,A.RHEMnota,A.RHEMestado ,B.Msiglas,B.Mnombre,C.RHCcodigo ,B.Mcodigo,C.RHCnombre
	from 
		RHEmpleadoCurso A,
		RHMateria B,
		RHCursos C
	where A.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> 
	and A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and A.Ecodigo = B.Ecodigo
	and A.Mcodigo= B.Mcodigo
	and B.Mcodigo= C.Mcodigo
	and A.RHCid = C.RHCid
	<cfif rsCompetencias.tipo EQ "C">
		and A.Mcodigo in (	select  D.Mcodigo from RHConocimientosMaterias  D
		where  D.RHCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCompetencias.idcompetencia#">
		and D.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
	<cfelse>
		and A.Mcodigo in (	select  D.Mcodigo from RHHabilidadesMaterias  D
		where  D.RHHid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCompetencias.idcompetencia#">
		and D.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
	</cfif>
	order by B.Mcodigo,C.RHCcodigo
</cfquery>
<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
	<tr>
		<td valign="top">
			<form name="formlistaC" method="post">
				<input type="hidden" name="DEID">
				<input type="hidden" name="RHCEid">
				<input type="hidden" name="RHCid">
				<input type="hidden" name="MODOC1" value="CAMBIO">
				<input type="hidden" name="MODOC2" value="CAMBIO">
				<input type="hidden" name="tab" value="2">
				<table width="100%" cellpadding="0" cellspacing="0" >
					<tr>
						<td class="tituloListas" align="left" width="18" height="17" nowrap></td>
						<td class="tituloListas" align="left"><strong>C&oacute;digo</strong></td>
						<td class="tituloListas" align="left"><strong>Descripci&oacute;n</strong></td>
						<!--- <td class="tituloListas" align="right"><strong>Nota</strong></td> --->
					</tr>
					<cfif rsListaCursos.recordcount gt 0>
						 <cfset CORTE = "">
						<cfoutput query="rsListaCursos">
							<cfif trim(rsListaCursos.Mcodigo) neq trim(CORTE)>
								<cfset CORTE = #trim(rsListaCursos.Mcodigo)#>
								<tr>
									<td  colspan="3" nowrap>
										<strong>#rsListaCursos.Mnombre#</strong>
									</td>
								</tr>
							</cfif>	
							<tr style=" padding:'3px'; cursor:pointer;"
							class="<cfif rsListaCursos.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" 
							onmouseover="style.backgroundColor='##E4E8F3';" 
							onMouseOut="style.backgroundColor='<cfif rsListaCursos.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>'"
							>
								<td><cfif isdefined("form.RHCid") and form.RHCid eq rsListaCursos.RHCid><img border="0" src="/cfmx/rh/imagenes/addressGo.gif"><cfelse>&nbsp;</cfif></td>
								<td  nowrap onClick="javascript:editarC(#rsListaCursos.RHCid#,#form.RHCEid#,#form.DEID#);">#rsListaCursos.RHCcodigo#</td>
								<td  nowrap onClick="javascript:editarC(#rsListaCursos.RHCid#,#form.RHCEid#,#form.DEID#);">#rsListaCursos.RHCnombre#</td>
								<!--- <td  nowrap align="right" onClick="javascript:editarC(#rsListaCursos.RHCid#,#form.RHCEid#,#form.DEID#);">#LSNumberFormat(rsListaCursos.RHEMnota,'____.__')#</td> --->
							</tr>
						</cfoutput>
					<cfelse>
							<tr>
								<td  colspan="5" align="center"><strong>El empleado no tiene asociados cursos para esta competencia</strong></td>
							</tr>
					</cfif>
				</table>
				
			</form>
		</td>
		<td>
			<cfinclude template="CompetenciaCursoMant.cfm">
		</td>
	</tr>
</table>
<script type="text/javascript" language="javascript1.2" >
	function editarC(RHCid,RHCEid,DEID){
		document.formlistaC.RHCEid.value = RHCEid;
		document.formlistaC.DEID.value = DEID;
		document.formlistaC.RHCid.value = RHCid;
		document.formlistaC.MODOC1.value = 'CAMBIO';	
		document.formlistaC.submit();
	}
</script>

<script type="text/javascript" language="javascript1.2">
  var popUpWinCertifica = 0;
  function popUpWindowCertifica(URLStr, left, top, width, height){
   if(popUpWinCertifica){
    if(!popUpWinCertifica.closed) popUpWinCertifica.close();
   }
   popUpWinCertifica = open(URLStr, 'popUpWinCertifica', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
  }
  
  function programar(parDEid,parMcodigo){
	  //Si la descripcion es vacia se programara una instancia de curso (RHCursos)/Si trae algo se programa un curso adicional (RHMateria)
   	  popUpWindowCertifica("ProgramInstaciaCurso-form.cfm?DEid="+parDEid+"&Mcodigo="+parMcodigo+"&tab=8",100,150,800,350);
  }
  
</script> 

<table width="99%" align="center" cellpadding="0" cellspacing="0">
	<tr><td>
	<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
		Default="Certificaciones" Key="LB_Certificaciones" returnvariable="LB_Certificaciones"/>	

		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_Certificaciones#">
		<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
			<cfoutput query="programas" group="RHGMcodigo">
				<cfif len(trim(programas.Descripcion))>
					<tr bgcolor="##CCCCCC" style="padding:3px; ">
						<td colspan="6">
							<table border="0" width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td width="1%"><strong><font size="2"><cf_translate key="LB_Programa">Programa</cf_translate>:&nbsp;</font></strong></td>
									<td width="59%"><cfif len(trim(programas.Descripcion))><font size="2">#programas.RHGMcodigo# - #programas.Descripcion#</font></cfif></td>
									<td width="1%" nowrap><!---<strong>Nivel de Cumplimiento:</strong>---></td>
									<td width="39%">&nbsp;</td>
								</tr>
							</table>
						</td>
					</tr>
			
					<tr class="listaCorte" >
						<td style="padding-left:5px; "><strong><cf_translate key="LB_Curso">Curso</cf_translate></strong></td>
						<td align="center"><strong><cf_translate key="LB_Periodicidad">Periodicidad</cf_translate></strong></td>
						<td align="center" nowrap><strong><cf_translate key="LB_Fecha_llevado">Fecha llevado</cf_translate></strong></td>
						<td align="center"><strong><cf_translate key="LB_Programado">Programado</cf_translate></strong></td>
						<td align="center" nowrap><strong><cf_translate key="LB_Programa">Fecha Programación</cf_translate></strong></td>
						<cfif !isDefined("LvarAuto")>
							<td></td>
						</cfif>
						
					</tr>
			
					<cfoutput group="Msiglas">
						<cfset LvarLlevado = false >
						<cfset LvarProgramado = false >
			
						<!--- 1. Fecha llevado --->
						<cfquery name="curso" datasource="#session.DSN#" maxrows="1">
							select RHECfdesde as inicio, RHECfhasta as fin
							from RHEmpleadoCurso
							where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
							and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#programas.Mcodigo#">
							and RHEMestado in (10, 15)
							order by inicio
						</cfquery>
						<cfif curso.recordcount gt 0 >
							<cfset LvarLlevado = true >
						<cfelse>
							<!--- 2. Programado --->
							<cfquery name="curso" datasource="#session.DSN#" maxrows="1">
								select RHPCfdesde as inicio, RHPCfhasta as fin
								from RHProgramacionCursos
								where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
								and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#programas.Mcodigo#">
								order by inicio
							</cfquery>
							<cfif curso.recordcount gt 0 >
								<cfset LvarProgramado = true >
							</cfif>
						</cfif>
						
						<tr class="tituloListas" <cfif not (LvarLlevado or LvarProgramado)>style="color:##FF0000"</cfif>  >
							<td style="padding-left: 10px;" width="40%"><strong>#programas.Msiglas# - #programas.Mnombre#</strong></td>
							<td align="center" width="15%" ><cfif len(trim(programas.RHMGperiodo))><strong>#programas.RHMGperiodo#</strong><cfelse>&nbsp;</cfif></td>
							<td align="center" width="15%" ><cfif LvarLlevado ><strong><cf_locale name="date" value="#curso.inicio#"/></strong><cfelse>-</cfif></td>
							<td align="center" width="10%" ><cfif LvarProgramado><img border="0" src="/cfmx/rh/imagenes/checked.gif"><cfelse><img border="0" src="/cfmx/rh/imagenes/unchecked.gif"></cfif></td>
							<td align="center" width="15%" ><cfif LvarProgramado><strong><cf_locale name="date" value="#curso.inicio#"/></strong><cfelse>-</cfif></td>
							<cfif !isDefined("LvarAuto")>
								<td align="center" width="5%"><img src="/cfmx/rh/imagenes/cal.gif" border="0" style="cursor:hand;" alt="Programar Curso" onClick="javascript:programar(#form.DEid#, #programas.Mcodigo#);"></td>
							</cfif>	
						</tr>
						
						<cfquery name="cursos_asociados" datasource="#session.DSN#">
							select 	b.RHCcodigo, 
									b.RHCnombre, 
									a.RHECfdesde as inicio, 
									a.RHECfhasta as fin,
									case a.RHEMestado when 10 then '<cf_translate key="LB_Aprobado">Aprobado</cf_translate>' when 15 then '<cf_translate key="LB_Convalidado">Convalidado</cf_translate>' end as estado
							from RHEmpleadoCurso a
							
							inner join RHCursos b
							on a.RHCid = b.RHCid
							
							where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
							and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#programas.Mcodigo#">
							and a.RHEMestado in (10, 15)
							and a.RHCid is not null
						</cfquery>
						<cfif isdefined("cursos_asociados") and cursos_asociados.recordcount gt 0 >
							<tr>
								<td colspan="6">
									<table width="99%" border="0" align="center" cellpadding="0" cellspacing="0" style="border:1px solid gray; ">
										<tr bgcolor="##CCCCCC" style="border-bottom:1px solid gray; ">
											<td colspan="4" align="center"><strong><cf_translate key="LB_Cursos_llevados_por_Materia">Cursos llevados por Materia</cf_translate></strong></td>
										</tr>
										<tr class="tituloListas">
											<td style="padding-left:25; " width="30%"><strong><cf_translate key="LB_Curso">Curso</cf_translate></strong></td>
											<td align="center" width="20%"><strong><cf_translate key="LB_Inicio">Inicio</cf_translate></strong></td>
											<td align="center" width="20%"><strong><cf_translate key="LB_Fin">Fin</cf_translate></strong></td>
											<td align="center" width="20%"><strong><cf_translate key="LB_Resultado">Resultado</cf_translate></strong></td>					
										</tr>
										<cfloop query="cursos_asociados">
											<tr class="<cfif cursos_asociados.currentrow mod 2>listaNon<cfelse>listaPar</cfif>">
												<td style="padding-left:25;">#cursos_asociados.RHCcodigo# - #cursos_asociados.RHCnombre#</td>
												<td align="center" ><cf_locale name="date" value="#cursos_asociados.inicio#"/></td>
												<td align="center" ><cf_locale name="date" value="#cursos_asociados.fin#"/></td>
												<td align="center" >#cursos_asociados.estado#</td>
											</tr>
										</cfloop>
									</table>
								</td>
							</tr>
						<cfelse>
							<tr><td colspan="5" align="center">-<cf_translate key="LB_Materia_sin_cursos_llevados">Materia sin cursos llevados</cf_translate>-</td></tr>
						</cfif>
						
						<tr><td>&nbsp;</td></tr>
					</cfoutput>
				
					<tr><td>&nbsp;</td></tr>
				</cfif>
			</cfoutput>
		
		</table>
		<cf_web_portlet_end>
	</td></tr>
	<tr><td>&nbsp;</td></tr>
</table>
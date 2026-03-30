﻿<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_EnProcesoDeAutogestion" Default="En Proceso de Autogesti&oacute;n" returnvariable="LB_EnProcesoDeAutogestion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_SolicitadaPorAutogestion" Default="Solicitada Por Autogesti&oacute;n" returnvariable="LB_SolicitadaPorAutogestion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Rechazada" Default="Rechazada" returnvariable="LB_Rechazada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_EnRevision" Default="En Revisión" returnvariable="LB_EnRevision" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Aplicada" Default="Aplicada" returnvariable="LB_Aplicada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Estado" Default="Estado" returnvariable="LB_Estado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_NoHaSeleccionadoUnCursoPresioneAceptarParaSeleccionarlo" Default="No ha seleccionado un curso.  Presione aceptar para seleccionarlo" returnvariable="LB_NoHaSeleccionadoUnCursoPresioneAceptarParaSeleccionarlo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_DebeAmpliarElCupoOEliminarAlgunosEmpleadosAntesDeAprobarLaMatricula" Default="Debe ampliar el cupo, o eliminar algunos empleados antes de aprobar la matrícula" returnvariable="LB_DebeAmpliarElCupoOEliminarAlgunosEmpleadosAntesDeAprobarLaMatricula" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_DeseaAprobarEstaMatricula" Default="Desea Aprobar esta Matrícula" returnvariable="LB_DeseaAprobarEstaMatricula" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_DeseaRechazarEstaMatricula" Default="Desea Rechazar esta Matrícula" returnvariable="LB_DeseaRechazarEstaMatricula" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_LaRelacionDeMatriculaHaSido" Default="La relaci&oacute;n de matr&iacute;cula ha sido" returnvariable="LB_LaRelacionDeMatriculaHaSido" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Rechazada" Default="rechazada" returnvariable="LB_Rechazada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_aprobada" Default="aprobada" returnvariable="LB_aprobada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CambiadaDeEstado" Default="cambiada de estado" returnvariable="LB_CambiadaDeEstado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaDeSolicitud" Default="Fecha de solicitud" returnvariable="LB_FechaDeSolicitud" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CursoSolicitado" Default="Curso solicitado" returnvariable="LB_CursoSolicitado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Institucion" Default="Instituci&oacute;n" returnvariable="LB_Institucion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Inicio" Default="Inicio" returnvariable="LB_Inicio" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_SeleccionarCurso" Default="Seleccionar Curso" returnvariable="LB_SeleccionarCurso" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_SolicitadoPor" Default="Solicitado por" returnvariable="LB_SolicitadoPor" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CupoDisponible" Default="Cupo Disponible" returnvariable="LB_CupoDisponible" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CupoRequerido" Default="Cupo Requerido" returnvariable="LB_CupoRequerido" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_AmpliarElCupoParaLos" Default="Ampliar el cupo para los" returnvariable="LB_AmpliarElCupoParaLos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_EspaciosAdicionales" Default="espacios adicionales" returnvariable="LB_EspaciosAdicionales" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cf_dbfunction name="op_concat" returnvariable="concat">
<cfquery name="rsForm" datasource="#session.dsn#">
	select rc.RHRCid, rc.Ecodigo, rc.RHRCdescripcion, rc.RHRCfecha, rc.Usucodigosol, rc.DEidsol,
		rc.CFidsol, rc.RHRCestado, rc.Mcodigo, rc.RHCid, rc.RHRCjustificacion, rc.ts_rversion,
		ia.RHIAnombre,
		m.Mnombre,
		c.RHCfdesde,
		c.RHCfhasta,
		case RHRCestado when 0 then '#LB_EnProcesoDeAutogestion#' 
		when 10 then '#LB_SolicitadaPorAutogestion#' 
		when 20 then '#LB_Rechazada#' 
		when 30 then '#LB_EnRevision#' 
		when 40 then '#LB_Aplicada#' else    '#LB_Estado# ' #concat# <cf_dbfunction name="to_char" args="RHRCestado"> end
			as estado, c.RHCcupo
	from RHRelacionCap rc
		left join RHCursos c
			on c.RHCid = rc.RHCid
		left join RHInstitucionesA ia
			on ia.RHIAid = c.RHIAid
		left join RHMateria m
			on m.Mcodigo = rc.Mcodigo
	where rc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and rc.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
</cfquery>
<cfif not ListFind('10,30',rsForm.RHRCestado)>
	<cfquery name="rsCantidad" datasource="#session.DSN#">
		select DEid
		from RHRelacionCap e
			join RHDRelacionCap rc
				on rc.RHRCid = e.RHRCid
			join RHCursos c
				on c.RHCid = e.RHCid
		where rc.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
		  and e.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
		  and exists (
		  	select * from RHEmpleadoCurso ex
			where ex.DEid = rc.DEid
			  and ex.RHCid = e.RHCid)
	</cfquery>
</cfif>

<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2109" default="" returnvariable="LvarAM"/>
<cfif rsForm.RecordCount lte 0>
	<cflocation url=".">
</cfif>
<cfquery name="cupoocupado" datasource="#session.dsn#">
	select count(1) as cantidad
	from RHEmpleadoCurso
	where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.RHCid#">
	 <cfif LvarAM eq 1>and RHECestado not in (20)</cfif>
</cfquery>
<cfquery name="cuporequerido" datasource="#session.dsn#">
	select count(1) as cantidad
	from RHDRelacionCap 
	where RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
</cfquery>
<cfquery name="s_emp" datasource="#session.dsn#">
	select 
	{fn concat(de.DEnombre,{fn concat(' ',{fn concat(de.DEapellido1,{fn concat(' ',de.DEapellido2)})})})} as nombre
	from DatosEmpleado de
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.DEidsol#">
</cfquery>
<cfif s_emp.RecordCount Is 0 or Len(Trim(s_emp.nombre)) Is 0>
	<cfquery name="s_emp" datasource="asp">
		select {fn concat(de.Pnombre,{fn concat(' ',{fn concat(de.Papellido1,{fn concat(' ', de.Papellido2)})})})} as nombre
		from Usuario u join DatosPersonales de
			on u.datos_personales = de.datos_personales
		where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Usucodigosol#">
	</cfquery>
</cfif>
<cfquery name="s_cfn" datasource="#session.dsn#">
	select {fn concat(CFcodigo,{fn concat(' - ',CFdescripcion)})} as nombre
	from CFuncional 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFidsol#">
</cfquery>

<script language="javascript1.2" type="text/javascript">
	<cfif ListFind('10,30', rsForm.RHRCestado)>
		function funcAprobar(){
			<cfif Len(TRIM(rsForm.RHCid)) EQ 0>
				alert('<cfoutput>#LB_NoHaSeleccionadoUnCursoPresioneAceptarParaSeleccionarlo#</cfoutput>.');
				location.href='.?RHRCid=<cfoutput>#rsForm.RHRCid#</cfoutput>&SEL=1&CURSO=1';
				return false;
			<cfelse>
				if (document.form1.ampliar && !document.form1.ampliar.checked){
					alert('<cfoutput>#LB_DebeAmpliarElCupoOEliminarAlgunosEmpleadosAntesDeAprobarLaMatricula#</cfoutput>.');
					return false;
				}
				return confirm( '¿<cfoutput>#LB_DeseaAprobarEstaMatricula#</cfoutput>?' );
			</cfif>
		}
		function funcRechazar(){
			return confirm( '¿<cfoutput>#LB_DeseaRechazarEstaMatricula#</cfoutput>?' );
		}
	<cfelse>
		function funcContinuar(){
			location.href="index.cfm";
			return false;
		}
	</cfif>
	function funcAnterior(){
		document.form1.SEL.value = "3";
		document.form1.action = "index.cfm";
		return true;
	}
	
	function ListaNoMatri(RHRCid,lista){
		var PARAM  = "/cfmx/rh/capacitacion/operacion/matricula/EmpleadosNoMatriculados.cfm?RHRCid="+ RHRCid + "&DeidMatr=" + lista
		open(PARAM,'','left=250,top=180,scrollbars=yes,resizable=yes,width=500,height=400')
	}
</script>
<link href="STYLE.CSS" rel="stylesheet" type="text/css">
<form action="aprobacion_sql.cfm" method="post" name="form1" id="form1">
	<cfoutput>
		<table width="95%" align="center"  border="0" cellspacing="0" cellpadding="4">
			<tr>
				<td width="17%" rowspan="13">&nbsp;</td>
				<td colspan="3">
					<cfif IsDefined('url.status')>
						<div style="background-color:00CC00;color:white;font-weight:bold;font-size:16px;padding:6px">
							#LB_LaRelacionDeMatriculaHaSido#
							<cfif rsForm.RHRCestado eq 20>#LB_Rechazada#
							<cfelseif rsForm.RHRCestado eq 40>#LB_aprobada#
							<cfelse>#LB_CambiadaDeEstado#</cfif>
						</div>
					</cfif>
				</td>
				<td width="18%" rowspan="13">&nbsp;</td>
			</tr>
			<tr>
				<td width="15%" valign="middle" nowrap><strong>#LB_Descripcion#:</strong>&nbsp;</td>
				<td colspan="2" valign="middle">
					<cfoutput>#HTMLEditFormat(rsForm.RHRCdescripcion)#</cfoutput>
				</td>
			</tr>
				<tr>
					<td colspan="1" nowrap><strong>#LB_FechaDeSolicitud#:</strong>&nbsp;</td>
					<td colspan="2">
						<cfoutput><cf_locale name="date" value="#rsForm.RHRCfecha#"/></cfoutput>
					</td>
				</tr>
				<tr>
					<td colspan="1" valign="middle"><strong>#LB_CursoSolicitado#</strong></td>
					<td colspan="2" valign="middle">
						<input type="hidden" name="RHCid" id="RHCid" value="<cfoutput>#HTMLEditFormat(rsForm.RHCid)#</cfoutput>">
						<input type="hidden" name="Mcodigo" id="Mcodigo" value="<cfoutput>#HTMLEditFormat(rsForm.Mcodigo)#</cfoutput>">
						<input name="Mnombre" type="text" id="Mnombre" value="<cfoutput>#HTMLEditFormat(rsForm.Mnombre)#</cfoutput>" size="50" readonly>
					</td>
				</tr>
				<tr>
					<td colspan="1" valign="middle">#LB_Institucion#</td>
					<td colspan="2" valign="middle"><input name="RHIAnombre" type="text" id="RHIAnombre" value="<cfoutput>#HTMLEditFormat(rsForm.RHIAnombre)#</cfoutput> " size="50" readonly></td>
				</tr>
				<tr>
					<td colspan="1" valign="middle">#LB_Inicio#</td>
					<td colspan="2" valign="middle"><input name="RHCfdesde" type="text" id="RHCfdesde" value="<cfoutput>#LSDateFormat(rsForm.RHCfdesde,'DD/MM/YYYY')#</cfoutput>" size="50" readonly></td>
				</tr>
				<tr>
					<td colspan="1" valign="top"><strong>#LB_SolicitadoPor#: </strong></td>
					<td colspan="2" valign="top"><cfoutput>
					#HTMLEditFormat(s_emp.nombre)#<br>
					#HTMLEditFormat(s_cfn.nombre)#</cfoutput></td>
				</tr>
				<tr>
					<td colspan="1"><strong>#LB_Estado#:</strong></td>
					<td colspan="2"><cfoutput>#HTMLEditFormat(rsForm.estado)#</cfoutput></td>
				</tr>
				
				<cfif Len(rsForm.RHCcupo) and Len(cupoocupado.cantidad) and Len(cuporequerido.cantidad)>
					<cfset cupoDisponible = (rsForm.RHCcupo - cupoocupado.cantidad)>
					<cfif cupoDisponible GTE 0>
						<cfset cupoDisponible = cupoDisponible>
						<cfelse>
						<cfset cupoDisponible = 0>
					</cfif>
					<tr>
						<td colspan="1"><strong>#LB_CupoDisponible#</strong></td>
						<td colspan="2"><cfoutput>#NumberFormat(cupoDisponible,',0')# de #NumberFormat(rsForm.RHCcupo,',0')#</cfoutput></td>
					</tr>
					<tr>
						<td colspan="1"><strong>#LB_CupoRequerido#</strong></td>
						<td colspan="2"><cfoutput>#NumberFormat(cuporequerido.cantidad,',0')#</cfoutput></td>
					</tr>
					<cfif ListFind('10,30',rsForm.RHRCestado) and cuporequerido.cantidad-rsForm.RHCcupo+cupoocupado.cantidad GT 0>
						<tr>
							<td colspan="1">&nbsp;</td>
							<td width="2%"><input type="checkbox" id="ampliar" name="ampliar"></td>
							<td width="48%" nowrap><label for="ampliar">#LB_AmpliarElCupoParaLos# <cfoutput>#NumberFormat(cuporequerido.cantidad-rsForm.RHCcupo+cupoocupado.cantidad,',0')#</cfoutput> #LB_EspaciosAdicionales# </label></td>
						</tr>
					</cfif>
				</cfif>
				<cfif not ListFind('10,30',rsForm.RHRCestado) and isdefined('url.YaMatriculados')>
					<tr>
						<td colspan="1"><strong>Empleados Matriculados</strong></td>
						<td colspan="2"><cfoutput>#NumberFormat(cuporequerido.cantidad - url.YaMatriculados,',0')#</cfoutput></td>
					</tr>
					<tr>
						<td><strong>Empleados sin Matricular</strong></td>
						<td><cfoutput>#NumberFormat(url.YaMatriculados,',0')#</cfoutput></td>
						<td>
							<cfif isdefined('url.YaMatriculados') and url.YaMatriculados GT 0>
								<a href="javascript: ListaNoMatri(<cfoutput>#form.RHRCid#,#url.DEidMatr#</cfoutput>);"><img border="0" src="/cfmx/rh/imagenes/findsmall.gif" title="Empleados que ya están matriculados en este curso" ></a>
							<cfelse>
								&nbsp;
							</cfif>
						</td>
					</tr>
				</cfif>
				<cfif Len(Trim(StripCR(rsForm.RHRCjustificacion)))>
					<tr>
						<td colspan="1" valign="top">&nbsp;</td>
						<td colspan="2"> <cfoutput><em>#HTMLEditFormat(rsForm.RHRCjustificacion)#</em></cfoutput>
						</td>
					</tr></cfif>
			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="4" align="center">
					<input type="hidden" name="SEL" value="">
					<input type="hidden" name="params" value="">
					<cfoutput>
						<input type="hidden" name="RHRCid" value="#rsForm.RHRCid#">
						<input type="hidden" name="RHRCestado" value="#rsForm.RHRCestado#">
					</cfoutput>
					
					<cfif ListFind('10,30',rsForm.RHRCestado)>
						<cf_botones values="<< Anterior,Rechazar,Aprobar" names="Anterior,Rechazar,Aprobar" nbspbefore="4" nbspafter="4" tabindex="3">
					<cfelse>
						<cf_botones values="<< Continuar" names="Continuar" nbspbefore="4" nbspafter="4" tabindex="3">
					</cfif>
					
				</td>
			</tr>
		</table>
	</cfoutput>
</form>

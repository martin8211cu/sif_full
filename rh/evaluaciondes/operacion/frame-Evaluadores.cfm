<!--- VARIABLES DE TRADUCCION --->	
<cfinvoke key="LB_Identificacion" default="Identificación" returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_NombreCompleto" default="Nombre Completo" returnvariable="LB_NombreCompleto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Avance" default="Avance" returnvariable="LB_Avance" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Tipo" default="Tipo" returnvariable="LB_Tipo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Autoevaluacion" default="Autoevaluación" returnvariable="LB_Autoevaluacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Jefe" default="Jefe"returnvariable="LB_Jefe" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Companero" default="Compañero" returnvariable="LB_Companero" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Subordinado" default="Colaborador"returnvariable="LB_Subordinado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_JefeExterno" default="Jefe Externo"returnvariable="LB_JefeExterno" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_NOSEHANAGREGADOEVALUADORESPARAESTARELACION" default="NO SE HAN AGREGADO EVALUADORES PARA ESTA RELACION" returnvariable="MSG_NOSEHANAGREGADOEVALUADORESPARAESTARELACION" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Filtrar" default="Filtrar" xmlfile="/rh/generales.xml" returnvariable="BTN_Filtrar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_LaInformacionDelEmpleadoAEvaluarAyudaraAEncontrarAlEmpleadoDelCualDeseaIdentificarSusEvaluadores" default="La información del empleado a evaluar ayudará a encontrar al empleado del cual desea identificar sus evaluadores." returnvariable="MSG_LaInformacionDelEmpleadoAEvaluarAyudaraAEncontrarAlEmpleadoDelCualDeseaIdentificarSusEvaluadores" component="sif.Componentes.Translate" method="Translate"/>	
 
<!--- FIN VARIABLES DE TRADUCCION --->	
<cfif isdefined("Url.FDEidentificacion") and not isdefined("Form.FDEidentificacion")>
	<cfparam name="Form.FDEidentificacion" default="#Url.FDEidentificacion#">
</cfif>
<cfif isdefined("Url.FDEnombre") and not isdefined("Form.FDEnombre")>
	<cfparam name="Form.FDEnombre" default="#Url.FDEnombre#">
</cfif>
<cfif isdefined("Url.fRHPcodigo") and not isdefined("Form.fRHPcodigo")>
	<cfparam name="Form.fRHPcodigo" default="#Url.fRHPcodigo#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "&SEL=5">
<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "&RHEEid=" & Form.RHEEid>
<cfif isdefined("Form.FDEidentificacion") and Len(Trim(Form.FDEidentificacion)) NEQ 0>
	<cfset filtro = filtro & " and upper(b.DEidentificacion) like '%" & UCase(Form.FDEidentificacion) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FDEidentificacion=" & Form.FDEidentificacion>
</cfif>
<cfif isdefined("Form.FDEnombre") and Len(Trim(Form.FDEnombre)) NEQ 0>
 	<cfset filtro = filtro & " and upper(b.DEapellido1 + ' ' + b.DEapellido2 + ', ' + b.DEnombre) like '%" & #UCase(Form.FDEnombre)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FDEnombre=" & Form.FDEnombre>
</cfif>
<cfif isdefined("Form.fRHPcodigo") and Len(Trim(Form.fRHPcodigo)) NEQ 0>
 	<cfset filtro = filtro & " and upper(a.RHPcodigo) like '%" & #UCase(Form.fRHPcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHPcodigo=" & Form.fRHPcodigo>
</cfif>

<cfoutput>
	<form name="form1" method="post" action="registro_evaluacion.cfm">
		<input type="hidden" name="SEL" value="5">
		<input type="hidden" name="RHEEid" value="#form.RHEEid#">
		<cfset descripcion_campo = MSG_LaInformacionDelEmpleadoAEvaluarAyudaraAEncontrarAlEmpleadoDelCualDeseaIdentificarSusEvaluadores>
	
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr><td colspan="4"><strong><cf_translate key="LB_DatosDelEmpleadoAEvaluar">Datos del Empleado a Evaluar</cf_translate></strong></td></tr>
			<tr> 
				<td width="4%" align="right"><cf_translate key="LB_Puesto" XmlFile="/rh/generales.xml">Puesto</cf_translate>:&nbsp;</td>
				<td width="20%" colspan="3">
					<cfif isdefined("Form.fRHPcodigo") and len(trim(Form.fRHPcodigo)) gt 0>
						<cfquery name="rsPuesto" datasource="#session.dsn#">
							select coalesce(RHPcodigoext,RHPcodigo) as RHPcodigoext,RHPcodigo as fRHPcodigo, RHPdescpuesto
							from RHPuestos
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
							  and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.fRHPcodigo#">
						</cfquery>
						<cf_rhpuesto query="#rsPuesto#" name="fRHPcodigo" size="20" form="form1" tabindex="1">
					<cfelse>
						<cf_rhpuesto name="fRHPcodigo" size="20" form="form1" tabindex="1">
					</cfif>
				</td>
			</tr>
			<tr> 
				<td width="4%" align="right" nowrap="nowrap"><cf_translate key="LB_Identificacion" XmlFile="/rh/generales.xml">Identificaci&oacute;n</cf_translate>:&nbsp;</td>
				<td width="20%">
					<input name="FDEidentificacion" type="text" id="FDEidentificacion" size="10" maxlength="60" value="<cfif isdefined("Form.FDEidentificacion")>#Form.FDEidentificacion#</cfif>" tabindex="1">
				</td>
				<td width="4%" align="right" nowrap="nowrap"><cf_translate key="LB_Nombre" XmlFile="/rh/generales.xml">Nombre</cf_translate>:&nbsp;</td>
				<td width="40%"> 
					<input name="FDEnombre" type="text" id="FDEnombre" size="30" maxlength="80" value="<cfif isdefined("Form.FDEnombre")>#Form.FDEnombre#</cfif>" tabindex="1">
				</td>
				<td width="8%" align="center">
					<input name="btnBuscar" class="btnFiltrar" type="submit" id="btnBuscar" value="#BTN_Filtrar#" tabindex="1">
				</td>
			</tr>
			<tr><td nowrap="nowrap"><input type="checkbox" name="chkTodos" value="" onClick="javascript: funcChequeaTodos();" <cfif isdefined("form.Todos") and form.Todos EQ 1>checked</cfif>>
					Marcar Todos
			</td></tr>
		</table>
	</form>
</cfoutput>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<cf_dbfunction name="concat" args="b.DEidentificacion,' ',b.DEapellido1,' ',b.DEapellido2,' ',b.DEnombre" returnvariable="DEidentificacionNombre">
			<cf_dbfunction name="concat" args="b.DEapellido1,' ',b.DEapellido2,' ',b.DEnombre" returnvariable="NombreCompleto">
			<cf_dbfunction name="concat" args="coalesce(c.RHPcodigoext,c.RHPcodigo)|'-'|c.RHPdescpuesto" returnvariable="RHPdescpuesto" delimiters="|">
			<cf_dbfunction name="concat" args="e.DEapellido1,' ',e.DEapellido2,' ',e.DEnombre" returnvariable="NombreCompletoEval">
			<cf_dbfunction name="to_char" args="a.DEid" returnvariable="lvar_DEid" >
			<cf_dbfunction name="to_char" args="d.DEideval" returnvariable="lvar_DEideval">
			<cf_dbfunction name="concat" args="#lvar_DEid#%'|'%#lvar_DEideval#" returnvariable="inactivecol" delimiters="%">
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Pendiente"
			Default="Pendiente"
			returnvariable="LB_Pendiente"/> 
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Listo"
			Default="Listo"
			returnvariable="LB_Listo"/> 
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Parcial"
			Default="Parcial"
			returnvariable="LB_Parcial"/> 
					
			
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaEduRet">
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="tabla" value="RHListaEvalDes a, DatosEmpleado b, RHPuestos c, RHEvaluadoresDes d, DatosEmpleado e"/>
				<cfinvokeargument name="columnas" value="a.RHEEid, b.DEid, 
														#DEidentificacionNombre# as DEidentificacionNombre, 
														b.DEidentificacion, 
														#NombreCompleto#  as NombreCompleto, 
														#RHPdescpuesto# as RHPdescpuesto, 
														5  as SEL, e.DEid as DEideval, e.DEidentificacion as DEidentificacioneval, 
														#NombreCompletoEval# as NombreCompletoEval, 
														d.RHEDtipo
														, 
															case RHEDtipo 
																when 'A' then '#LB_Autoevaluacion#' 
																when 'J' then '#LB_Jefe#' 
																when 'C' then '#LB_Companero#' 
																when 'S' then '#LB_Subordinado#' 
																when 'E' then '#LB_JefeExterno#' 
																end as RHEDtipodesc , 
														 0 as BTNELIMINAR,
														case d.RHEDtipo when 'A' 
															then #inactivecol#
															else '' end as inactivecol,
														 case when((select coalesce(count(z.Estado),0)
																			from RHEvaluadoresDes z 
																			where z.RHEEid = a.RHEEid  
																			and z.DEideval = d.DEideval) 
																						-
																			(select count(z.Estado)
																			from RHEvaluadoresDes z 
																			where z.RHEEid = a.RHEEid 
																			and z.DEideval = d.DEideval
																			and z.Estado=0)) = 0
																then '#LB_Pendiente#'
																else
																	case when (select coalesce(count(z.Estado),0)
																									from RHEvaluadoresDes z 
																									where z.RHEEid = a.RHEEid 
																									and z.DEideval = d.DEideval)
																								=
																			(select count(z.Estado)
																									from RHEvaluadoresDes z 
																									where z.RHEEid = a.RHEEid 
																									and z.DEideval = d.DEideval 
																									and z.Estado=1)
																	then '#LB_Listo#'
																	else'#LB_Parcial#'				
																	end
																end as Estado
														"/>
				<cfinvokeargument name="desplegar" value="DEidentificacioneval, NombreCompletoEval, Estado, RHEDtipodesc "/>
				<cfinvokeargument name="etiquetas" value="#LB_Identificacion#, #LB_NombreCompleto#, #LB_Avance#, #LB_Tipo#"/>
				<cfinvokeargument name="cortes" value="RHPdescpuesto, DEidentificacionNombre"/>
				<cfinvokeargument name="formatos" value="S,S,S,S"/>
				<cfinvokeargument name="filtro" value=" a.Ecodigo = #SESSION.ECODIGO# 
														and a.RHEEid = #FORM.RHEEID# 
														#FILTRO#
														and a.DEid = b.DEid 
														and a.Ecodigo = c.Ecodigo 
														and a.RHPcodigo = c.RHPcodigo 
														and a.DEid = d.DEid 
														and a.RHEEid = d.RHEEid 
														and d.DEideval = e.DEid
														order by 
														c.RHPcodigo,c.RHPdescpuesto, b.DEidentificacion, b.DEapellido1, b.DEapellido2, b.DEnombre, e.DEidentificacion, e.DEapellido1, e.DEapellido2, e.DEnombre"/>
				<cfinvokeargument name="align" value="left, left, left, center"/>
				<cfinvokeargument name="ajustar" value=""/>
				<cfinvokeargument name="irA" value="registro_evaluacion.cfm"/>
				<cfinvokeargument name="incluyeForm" value="true"/>
				<cfinvokeargument name="MaxRows" value="50"/>
				<cfinvokeargument name="formName" value="listaEvaluadores"/>
				<cfinvokeargument name="showLink" value="false"/>
				<cfinvokeargument name="checkboxes" value="s"/>
				<cfinvokeargument name="keys" value="DEid, DEideval"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="EmptyListMsg" value="***#MSG_NOSEHANAGREGADOEVALUADORESPARAESTARELACION#***"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="inactivecol" value="inactivecol"/>
			</cfinvoke>
		</td>
	</tr>
</table>
<script language="javascript" type="text/javascript">
	var f = document.form1;
//	f.fRHPcodigo.focus();
function funcChequeaTodos(){		
		if (document.form1.chkTodos.checked){			
			if (document.listaEvaluadores.chk && document.listaEvaluadores.chk.type) {
				document.listaEvaluadores.chk.checked = true
			}
			else{
				if (document.listaEvaluadores.chk){
					for (var i=0; i<document.listaEvaluadores.chk.length; i++) {
						document.listaEvaluadores.chk[i].checked = true					
					}
				}
			}
		}	
		else{
			<cfset url.Todos = 0>
			if (document.listaEvaluadores.chk && document.listaEvaluadores.chk.type) {
				document.listaEvaluadores.chk.checked = false
			}
			else{
				if (document.listaEvaluadores.chk){
					for (var i=0; i<document.listaEvaluadores.chk.length; i++) {
						document.listaEvaluadores.chk[i].checked = false					
					}
				}
			}
		}
	}

</script>
<!---=========== TARDUCCION ============---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_S_Bruto" key="LB_S_Bruto" default="S. Bruto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Incidencias" key="LB_Incidencias" default="Incidencias"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_S_Líquido" key="LB_S_Líquido" default="S. Líquido"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Deducciones" key="LB_Deducciones"	default="Deducciones"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Renta" key="LB_Renta" default="Renta"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_AplicarRelacion"
key="LB_Confirma_que_desea_Aplicar_esta_Relacion" default="¿Confirma que desea Aplicar esta Relación?"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Aplicar" returnvariable="BTN_Aplicar"
default="Aplicar" xmlfile="/rh/generales.xml" />

<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="BTN_Restaurar"
key="BTN_Restaurar" default="Restaurar" xmlfile="/rh/generales.xml"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="BTN_Comisiones"
key="BTN_Comisiones" default="Comisiones" xmlfile="/rh/generales.xml"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Identificacion"
key="LB_Identificacion" default="Identificación"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Empleado"
key="LB_Empleado" default="Empleado" xmlfile="/rh/generales.xml"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Cargas_Empleado"
key="LB_Cargas_Empleado" default="Cargas Empleado"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_RestaurarRelacion"
key="LB_Esta_seguro_que_desea_Restaurar_esta_Relacion_de_Caculo"
default="¿Está seguro que desea Restaurar esta Relación de Cáculo?\n\nNota: Si Restaura, todos los Registros Eliminados en esta Relación, serán Restaurados." />

<cfif isdefined("Url.RCNid") and not isdefined("Form.RCNid")>
	<cfparam name="Form.RCNid" default="#Url.RCNid#">
</cfif>
<cfif isdefined("Url.nombreFiltro") and not isdefined("Form.nombreFiltro")>
	<cfparam name="Form.nombreFiltro" default="#Url.nombreFiltro#">
</cfif>
<cfif isdefined("Url.DEidentificacionFiltro") and not isdefined("Form.DEidentificacionFiltro")>
	<cfparam name="Form.DEidentificacionFiltro" default="#Url.DEidentificacionFiltro#">
</cfif>
<cfif isdefined("Url.fSEcalculado") and not isdefined("form.fSEcalculado")>
	<cfparam name="form.fSEcalculado" default="#Url.fSEcalculado#">
</cfif>
<cfif isdefined("Url.filtrado") and not isdefined("Form.filtrado")>
	<cfparam name="Form.filtrado" default="#Url.filtrado#">
</cfif>
<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>
<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
	<cfparam name="Form.sel" default="#Url.sel#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=Filtrar">
<cfif isdefined("Form.DEid")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEid=" & form.DEid>
</cfif>
<cfif isdefined("Form.RCNid")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RCNid=" & form.RCNid>
</cfif>

<cfif isdefined("Form.nombreFiltro") and Len(Trim(Form.nombreFiltro)) NEQ 0>
	<cfset filtro = filtro & " and upper(b.DEapellido1 #_Cat#' ' #_Cat# b.DEapellido2 #_Cat# ' ' #_Cat# b.DEnombre) like '%" & #UCase(Form.nombreFiltro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nombreFiltro=" & Form.nombreFiltro>
</cfif>
<cfif isdefined("Form.DEidentificacionFiltro") and Len(Trim(Form.DEidentificacionFiltro)) NEQ 0>
	<cfset filtro = filtro & " and upper(DEidentificacion)  like '%" & #UCase(Form.DEidentificacionFiltro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEidentificacionFiltro=" & Form.DEidentificacionFiltro>
</cfif>
<cfif isdefined("form.fSEcalculado") >
	<cfset filtro = filtro & " and SEcalculado  = #form.fSEcalculado# ">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fSEcalculado=" & form.fSEcalculado>
</cfif>
<cfif isdefined("Form.sel") and form.sel NEQ 1>
<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "sel=" & form.sel>
</cfif>

<style type="text/css">
.chk {
 background: buttonface;
 padding: 1px;
 color: buttontext;
}
</style>

<!---CarolRS Verifica si debe realizarse la validacion para los centros funcionales inactivos--->
<cfquery name="rsVerificaCFActivos" datasource="#session.DSN#">
	select Pvalor from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo = 2500
</cfquery>

<cfif isdefined("rsVerificaCFActivos") and rsVerificaCFActivos.Pvalor EQ 1>
	<!---CarolRS Muestra Error CF inactivos--->
	<!---CarolRS  Incidencias registradas en Centros Funcionales inactivos:--->
	<cfquery name="rsIncidendenciasCF" datasource="#session.DSN#">
		Select distinct a.DEid, a.CFid, e.CFcodigo,e.CFdescripcion, e.CFestado
		from IncidenciasCalculo a
        	inner join CIncidentes b
            	on a.CIid = b.CIid
            inner join CalendarioPagos c
            	on c.CPid = a.RCNid
                and a.ICfecha between c.CPdesde and c.CPhasta
            inner join CFuncional e
            	on e.CFid = a.CFid
		Where RCNid = #form.RCNid#
		  and a.CFid is not null
		  and e.CFestado = 0 <!---inactivo--->
	</cfquery>

	<!---CarolRS  Pagos registrados en Centros Funcionales inactivos:--->
	<cfquery name="rsPagosCF" datasource="#session.DSN#">
		Select distinct a.DEid,c.CFestado,c.CFid,PEdesde,PEhasta
		from PagosEmpleado a, RHPlazas b, CFuncional c, DatosEmpleado f
		Where a.RCNid=#form.RCNid#
		and a.PEtiporeg=0
		and b.RHPid=a.RHPid
		and c.CFid = b.CFid
		and c.CFestado = 0  <!---inactivo--->
		and a.PEhasta = (select max(x.PEhasta) from PagosEmpleado x where x.RCNid=#form.RCNid# and x.DEid=a.DEid)
	</cfquery>
	<cfset listaDEid = ''>
	<cfif rsIncidendenciasCF.RecordCount GT 0>
		<cfset listaDEid = ValueList(rsIncidendenciasCF.DEid)>
	</cfif>
	<cfif rsPagosCF.RecordCount GT 0>
		<cfset listaDEid = listaDEid & IIF(len(trim(listaDEid)),DE(','),DE('')) & ValueList(rsPagosCF.DEid)>
	</cfif>

	<cfif len(trim(listaDEid))>
		<cfquery name="rsUpdate" datasource="#Session.DSN#">
			Update SalarioEmpleado
			set SEcalculado = 0
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
			and DEid in(#listaDEid#)
		</cfquery>
	</cfif>
	<!---FIN Muestra Error CF inactivos--->
</cfif>

<cfquery name="rsCantModificados" datasource="#Session.DSN#">
	select 1 from SalarioEmpleado
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and SEcalculado <> 1
</cfquery>

<!--- trabaja con comisiones --->
<cfquery name="rsComision" datasource="#session.DSN#">
	select coalesce(Pvalor,'0') as Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	  and Pcodigo = 330
</cfquery>

<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Session.DSN#" ecodigo="#session.Ecodigo#" pvalor="330" default="0" returnvariable="vComisionSB"/>
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Session.DSN#" ecodigo="#session.Ecodigo#" pvalor="331" default="0" returnvariable="vComisionCSB"/>
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Session.DSN#" ecodigo="#session.Ecodigo#" pvalor="785" default="0" returnvariable="UnificaSalarioB"/>

<cfset pintarReporte = true>

<cfset Request.Regresar = "ResultadoCalculo-lista.cfm">
<cfinclude template="/rh/portlets/pRelacionCalculo.cfm">

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
		<td width="90%">
			<form name="formFiltroListaEmpl" method="post" action="ResultadoCalculo-lista.cfm">
				<input type="hidden" name="filtrado" value="<cfif isdefined('form.btnFiltrar') or isdefined('form.filtrado')>Filtrar</cfif>">
				<input type="hidden" name="sel" value="<cfif isdefined('form.sel')><cfoutput>#form.sel#</cfoutput><cfelse>0</cfif>">
				<input type="hidden" name="RCNid" value="<cfoutput>#Form.RCNid#</cfoutput>">

				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro" align="center">
					<tr>
						<td width="25%" height="17" class="fileLabel"><cf_translate key="LB_Identificacion"  xmlfile="/rh/generales.xml">Identificaci&oacute;n</cf_translate></td>
						<td width="50%" class="fileLabel"><cf_translate key="LB_Nombre_del_empleado"  xmlfile="/rh/generales.xml">Nombre del empleado</cf_translate></td>
						<td width="20%" class="fileLabel">&nbsp;</td>
						<td width="5%" rowspan="2" class="fileLabel" nowrap>
							<input name="btnFiltrar" type="submit" id="btnFiltrar" class="btnFiltrar" value="Filtrar"><br>
							<input name="btnLimpiar" type="button" id="btnLimpiar" class="btnLimpiar" value="Limpiar" onclick="javascript:limpiar();">
						</td>
					</tr>
					<tr>
						<td>
							<input name="DEidentificacionFiltro" type="text" id="DEidentificacionFiltro" size="30" maxlength="60" value="<cfif isdefined('form.DEidentificacionFiltro')><cfoutput>#form.DEidentificacionFiltro#</cfoutput></cfif>">
						</td>
						<td>
							<input name="nombreFiltro" type="text" id="nombreFiltro2" size="100" maxlength="260" value="<cfif isdefined('form.nombreFiltro')><cfoutput>#form.nombreFiltro#</cfoutput></cfif>">
						</td>
						<td >
							<input class="chk" name="fSEcalculado" type="checkbox" id="fSEcalculado" value="0" <cfif isdefined("form.fSEcalculado") >checked</cfif>><cf_translate key="LB_Sin_calcular">Sin calcular</cf_translate>
						</td>
					</tr>
				</table>
			</form>
		</td>
  </tr>

  <tr>
    <td width="90%">
		<!---Validaciones--->
		 <cfquery name="rsParametro" datasource="#session.dsn#">
			select Pvalor from RHParametros where Pcodigo=2026 and Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfif rsParametro.Pvalor gt 0>
		<!--- DATOS DE LA RELACION DE CALCULO --->
				<cfquery name="CalendarioPagos" datasource="#session.DSN#">
					select CPtipo, CPdesde, CPhasta, Tcodigo
					from CalendarioPagos
					where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
				</cfquery>

				<!--- VERIFICA SI DENTRO DE LA RELACIÓN HAY EMPLEADOS CON SALARIO LIQUIDO EN NEGATIVO --->
				<cfquery name="rsSalNegativos" datasource="#session.DSN#">
					select DEidentificacion, b.DEapellido1 #_Cat# ' ' #_Cat# b.DEapellido2 #_Cat# ' ' #_Cat# b.DEnombre as nombreEmpl
					from SalarioEmpleado a
						inner join DatosEmpleado b
							on b.DEid = a.DEid
					where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
					  and SEliquido < 0
				</cfquery>

				<!--- VALIDACIONES DE CALENDARIOS DE PAGO ANTERIORES --->
					<cfif CalendarioPagos.CPtipo EQ 2> <!--- SI ES ANTICIPO DE SALARIO LA COMPARACION ES DIFERENTE --->
						<cfquery name="rsTipoNomina" datasource="#session.DSN#">
							select Ttipopago as CodTipoPago
							from TiposNomina
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and rtrim (Tcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(CalendarioPagos.Tcodigo)#">
						</cfquery>
						<cfif rsTipoNomina.CodTipoPago EQ "0"> 		<!--- Semanal --->
							<cfset Lvar_Fecha = DateAdd("d", -6, "#CalendarioPagos.CPdesde#")>
						<cfelseif rsTipoNomina.CodTipoPago EQ "1">	<!--- Bisemanal --->
							<cfset Lvar_Fecha = DateAdd("d", -13, "#CalendarioPagos.CPdesde#")>
						<cfelseif rsTipoNomina.CodTipoPago EQ "2">	<!--- Quincenal --->
							<cfset Lvar_Fecha = DateAdd("d", -14, "#CalendarioPagos.CPdesde#")>
						<cfelseif rsTipoNomina.CodTipoPago EQ "3">	<!--- Mensual --->
							<cfset Lvar_Fecha = DateAdd("d", -(DaysInMonth(CalendarioPagos.CPdesde) - 1)	, "#CalendarioPagos.CPdesde#")>
						</cfif>
						<cfset Periodo = DatePart('yyyy',Lvar_Fecha)>
						<cfset Mes = DatePart('m',Lvar_Fecha)>
						<cfquery datasource="#session.DSN#" name="CPidant">
							select a.CPid
							from CalendarioPagos a
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and a.CPdesde = (select min(CPdesde)
												from CalendarioPagos
												where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
												  and CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">
												  and CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">
												  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CalendarioPagos.Tcodigo#">)
							  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CalendarioPagos.Tcodigo#">
						</cfquery>

					<cfelseif CalendarioPagos.CPtipo EQ 0>
						<!--- VERIFICA SI HAY UNA NOMINA DE ANTICIPO PARA EL MISMO PERIODO DE LA NOMINA NORMAL QUE SE ESTA CALCULANDO
							SI HAY UNA NOMINA DE ANTICIPO SE VERIFICA QUE TIENE Q ESTAR EN HISTORICOS PARA PODER GENERARLA.
						 --->
						<cfset Periodo = DatePart('yyyy',"#CalendarioPagos.CPdesde#")>
						<cfset Mes = DatePart('m',"#CalendarioPagos.CPdesde#")>
						<cfquery name="CPidant" datasource="#session.DSN#">
							select a.CPid
							from CalendarioPagos a
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and a.CPdesde = (
								select max(b.CPdesde) from CalendarioPagos b
								where b.Ecodigo = a.Ecodigo
								  and b.Tcodigo = a.Tcodigo
								  and b.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">
								  and b.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">
								  and CPtipo = 2
								 )
							  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CalendarioPagos.Tcodigo#">
							  and CPtipo = 2
						</cfquery>
						<cfif CPidant.RecordCount EQ 0 or CalendarioPagos.CPtipo eq 1 >
							<cfquery datasource="#session.DSN#" name="CPidant">
								select a.CPid
								from CalendarioPagos a
								where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								  and a.CPdesde = (
									select max(b.CPdesde) from CalendarioPagos b
									where b.Ecodigo = a.Ecodigo
									and b.Tcodigo = a.Tcodigo
									 and b.CPdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CalendarioPagos.CPdesde#">
									 )
								  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CalendarioPagos.Tcodigo#">
							</cfquery>
						</cfif>
					</cfif>
					<cfif isdefined('CPidant') and Len(CPidant.CPid)>
						<cfquery datasource="#session.DSN#" name="existsHRCalculoNomina">
							select 1 from HRCalculoNomina
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CalendarioPagos.Tcodigo#">
							and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPidant.CPid#">
						</cfquery>
					</cfif>
					<cfif CalendarioPagos.CPtipo EQ 1>
						<cfquery name="rsEspeciales" datasource="#session.DSN#">
							select 1
							from SalarioEmpleado a, CalendarioPagos b
							where a.RCNid = b.CPid
								and a.SEcalculado = 0
								and a.SEliquido >= 0.00
								and b.CPtipo = 1	<!----Calendario de pago de tipo especial---->
								<!---Cuando no exista un calendario abierto (RCalculoNomina) con fecha hasta < a fecha hasta del calendario de la nomina aplicando---->
								and not exists(	select 1
												from CalendarioPagos c, RCalculoNomina y
												where c.CPid = y.RCNid
													and b.Tcodigo = c.Tcodigo
													and c.CPid <> b.CPid
													and c.CPhasta < b.CPhasta)

						</cfquery>
					</cfif>
		<!---Fin de validaciones--->
		</cfif>

		<!---CarolRS. Si existen empleados en la nomina cuyo salario sale de algun centro funcional inactivo, entonces no debe permitir aplicar la nomina--->
		<cfset CentrosActivos = 'no'>
		<cfif not isdefined("listaDEid") or not len(trim(listaDEid))>
			<cfset CentrosActivos = 'yes'>
		</cfif>

		<!---<cfset botones = "Excluir Deducciones" >--->
		<cfif rsCantModificados.RecordCount gt 0 and isdefined ('rsSalNegativos')
			and rsSalNegativos.RecordCount gt 0 and not isdefined ('rsEspeciales')
			and not isdefined ('existsHRCalculoNomina') and CentrosActivos EQ 'yes'>
				
			<cfset botones = "Aplicar,Restaurar">
		<cfelseif rsCantModificados.RecordCount lte 0 and CentrosActivos EQ 'yes'>
			<cfset botones = "Aplicar,Restaurar">
			
		<cfelse>
			<cfset botones = "Restaurar">
			
		</cfif>
		

		<cfif vComisionSB EQ 1 or vComisionCSB EQ 1 >
			<cfset botones = botones & ",#BTN_Comisiones#">
		</cfif>

		<cfset imgok = "">
		<!---
		Se realiza este cambio para que no de error para ORACLE

		<cfset imgrecalcular3 = ")''>">
		<cfset imgrecalcular = "{fn concat('#imgrecalcular1#', {fn concat(#idEmpleado#, '#imgrecalcular3#')} )}">
        <cfset imgrecalcular1 = "<img border=''0'' src=''/cfmx/rh/imagenes/Cferror.gif'' onClick=''javascript:return funcOpen(">--->

		<cf_dbfunction name="to_char" args="b.DEid" returnvariable ="DEidChar">
		<cfset imgrecalcular3 = ")''>">
		<cfset imgrecalcular1 = "<img border=''0'' src=''/cfmx/rh/imagenes/Cferror.gif'' onClick=''javascript:return funcOpen(">
		<cfset imgrecalcular = "{fn concat('#imgrecalcular1#', {fn concat(#DEidChar#, '#imgrecalcular3#')} )}">
		<cfset imgrecalcular4 = "{fn concat('#imgrecalcular1#', {fn concat(">
		<cfset imgrecalcular5 = ",'#imgrecalcular3#')} )}">
		<cfset imgrecalcular = "'#imgrecalcular1#' #_Cat# #DEidChar# #_Cat# '#imgrecalcular3#'">





		<!--- para mantener el check de calculado en el filtro --->
		<cfset calculado = "" >
		<cfif isdefined("form.fSEcalculado")>
			<cfset calculado = ", 0 as fSEcalculado" >
		</cfif>
		<cfif UnificaSalarioB>
            <cfinvoke component="rh.Componentes.pListas" method="pListaRH" returnvariable="pListaEmpl">
                <cfinvokeargument name="tabla" 		value="SalarioEmpleado a, DatosEmpleado b"/>
                <cfinvokeargument name="etiquetas" 	value="#LB_Identificacion#,#LB_Empleado#,#LB_S_Bruto#, #LB_S_Líquido#,#LB_Renta#, #LB_Cargas_Empleado#, #LB_Deducciones#,&nbsp;"/>
                <cfinvokeargument name="formatos" 	value="S,S,M,M,M,M,M,S"/>
                <cfinvokeargument name="formName" 	value="listaEmpleados"/>
                <cfinvokeargument name="align" 		value="left,left,right,right,right,right,right,right"/>
                <cfinvokeargument name="ajustar" 	value="N"/>
                <cfinvokeargument name="debug" 		value="N"/>
                <cfinvokeargument name="irA" 		value="ResultadoCalculo.cfm"/>
                <cfinvokeargument name="navegacion" value="#navegacion#"/>
                <cfinvokeargument name="botones" 	value="#botones#"/>
                <cfinvokeargument name="desplegar"  value="DEidentificacion, nombreEmpl, SEsalariobruto, SErenta, SEcargasempleado, SEdeducciones, SEliquido, estado"/>
                <cfinvokeargument name="filtro" 	value="a.RCNid = #Form.RCNid# and b.DEid = a.DEid  #filtro#
                		order by SEcalculado,DEidentificacion, DEapellido1, DEapellido2, DEnombre"/>
                <cfinvokeargument name="columnas" value="'#Form.RCNid#' as CPid, '#Form.RCTcodigo#' as Tcodigo, a.RCNid, b.DEid,
                		b.DEidentificacion, b.DEapellido1 #_Cat# ' ' #_Cat# b.DEapellido2 #_Cat# ' ' #_Cat# b.DEnombre as nombreEmpl,
                        a.SEsalariobruto + a.SEincidencias as SEsalariobruto, a.SErenta, a.SEcargasempleado, a.SEdeducciones, a.SEliquido,
                        case SEcalculado when 1 then #imgrecalcular# else #imgrecalcular#  end as estado, 1 as o,1 as sel #calculado#"/>
            </cfinvoke>
		<cfelse>
		<!--- datos --->
            <cfinvoke component="rh.Componentes.pListas" method="pListaRH" returnvariable="pListaEmpl">
                <cfinvokeargument name="tabla" 		value="SalarioEmpleado a, DatosEmpleado b"/>
                <cfinvokeargument name="desplegar" 	value="DEidentificacion, nombreEmpl, SEsalariobruto, SEincidencias, SErenta, SEcargasempleado, SEdeducciones, SEliquido, estado"/>
                <cfinvokeargument name="formatos" 	value="S,S,M,M,M,M,M,M,S"/>
                <cfinvokeargument name="formName" 	value="listaEmpleados"/>
                <cfinvokeargument name="align" 		value="left,left,right,right,right,right,right,right,right"/>
                <cfinvokeargument name="ajustar" 	value="N"/>
                <cfinvokeargument name="debug" 		value="N"/>
                <cfinvokeargument name="irA" 		value="ResultadoCalculo.cfm"/>
                <cfinvokeargument name="navegacion" value="#navegacion#"/>
                <cfinvokeargument name="botones" 	value="#botones#"/>
                <cfinvokeargument name="filtro" 	value="a.RCNid = #Form.RCNid# and b.DEid = a.DEid  #filtro#
                		order by SEcalculado,DEidentificacion, DEapellido1, DEapellido2, DEnombre"/>
                <cfinvokeargument name="columnas" 	value="'#Form.RCNid#' as CPid, '#Form.RCTcodigo#' as Tcodigo, a.RCNid, b.DEid,
                        b.DEidentificacion, b.DEapellido1 #_Cat# ' ' #_Cat# b.DEapellido2 #_Cat#  ' ' #_Cat# b.DEnombre as nombreEmpl,
                        a.SEsalariobruto, a.SEincidencias, a.SErenta, a.SEcargasempleado, a.SEdeducciones, a.SEliquido,
                        case SEcalculado when 1 then '#imgok#' else #imgrecalcular# end as estado, 1 as o,1 as sel #calculado#"/>
                <cfinvokeargument name="etiquetas" 	value="#LB_Identificacion#,#LB_Empleado#,#LB_S_Bruto#, #LB_Incidencias#, #LB_Renta#, #LB_Cargas_Empleado#, #LB_Deducciones#, #LB_S_Líquido#,&nbsp;"/>
   		 	</cfinvoke>
		</cfif>


	</td>
  </tr>
</table>

<!--- Guardo la información  del Fondo de Ahorro  IRR--->

  <!---  <cfquery name="insRHFondoAhorro"  datasource="#session.dsn#">
    	insert into RHFondoAhorro(Deid,Ecodigo,FAMonto,RCNid,TDid,Tcodigo,FAEstatus)
    	select dc.DEid,Ecodigo,DCvalor,pe.RCNid, TDid,Tcodigo,0
        from DeduccionesCalculo dc
		inner join DeduccionesEmpleado de on de.Did=dc.Did
        inner join PagosEmpleado pe on pe.DEid=de.DEid and pe.RCNid=dc.RCNid
		where de.DFA=1
        <cfif isdefined('url.RCNid') >
        	and pe.RCNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
        <cfelseif isdefined('form.RCNid') >
        	and pe.RCNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
        </cfif>
        <cfif IsDefined('Form.DEid')>and de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"></cfif>
    </cfquery>--->
     <!---<cfthrow message="#url.RCNid# #Arguments.datasource# #Session.dsn#">--->
    <!--- Información del Fondo  de Ahorro Guardada  IRR--->

<script language="JavaScript1.2" type="text/javascript">
	var _RCNid = document.formFiltroListaEmpl.RCNid.value;
	var nuevo=0;
	function funcOpen(id) {

			var width = 500;
			var height = 150
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			<cfoutput>
			nuevo = window.open('ResultadoCalculoMensajes.cfm?RCNid='+_RCNid + '&DEid=' + id,'Justificacion','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			</cfoutput>
			nuevo.focus();
			window.onfocus = closePopUp;
			document.listaEmpleados.nosubmit = true;
			return false;
		}


function closePopUp(){
	if(nuevo) {
		if(!nuevo.closed) nuevo.close();
		nuevo=null;
  	}
}
	<cfoutput>

		function funcDeducciones(){
			document.listaEmpleados.action = '/cfmx/rh/admin/catalogos/calendarioPagos_relacion.cfm';
			document.listaEmpleados.TCODIGO.value = '<cfoutput>#form.RCTcodigo#</cfoutput>';
			document.listaEmpleados.CPID.value = '<cfoutput>#form.RCNid#</cfoutput>';
			document.listaEmpleados.submit();
		}

		function funcRestaurar() {
			var result = false;
			if (confirm('#LB_RestaurarRelacion#'))
				document.location = "ResultadoCalculo-listaSql.cfm?Accion=Restaurar&RCNid=#Form.RCNid#&Tcodigo=#Form.RCTcodigo#";
			return result;
		}

		<cfif vComisionSB EQ 1 or vComisionCSB EQ 1 >
			function funcComisiones() {
				document.listaEmpleados.action = 'ResultadoCalculo-comisiones.cfm';
				document.listaEmpleados.CPID.value = <cfoutput>#form.RCNid#</cfoutput>;
				document.listaEmpleados.submit();
			}
		</cfif>

		<cfif (rsCantModificados.RecordCount lte 0) or (rsCantModificados.RecordCount gt 0 and isdefined ('rsSalNegativos')  and not isdefined ('rsEspeciales') and not isdefined ('existsHRCalculoNomina'))>
			function funcAplicar(){
				var result = false;
				if (confirm("#LB_AplicarRelacion#")) {
					document.location = "ResultadoCalculo-listaSql.cfm?Accion=Aplicar&RCNid=#Form.RCNid#";
				}
				return result;
			}
		</cfif>
	</cfoutput>

	function limpiar(){
		document.formFiltroListaEmpl.DEidentificacionFiltro.value = "";
		document.formFiltroListaEmpl.nombreFiltro.value = "";
		document.formFiltroListaEmpl.fSEcalculado.checked = false;
	}
</script>

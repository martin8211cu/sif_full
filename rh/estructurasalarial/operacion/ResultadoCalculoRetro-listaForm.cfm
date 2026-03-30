<!---=========== TARDUCCION ============---->
<cfinvoke key="LB_Esta_seguro_que_desea_Restaurar_esta_Relacion_de_Caculo" default="¿Está seguro que desea Restaurar esta Relación de Cáculo?\n\nNota: Si Restaura, todos los Registros Eliminados en esta Relación, serán Restaurados." returnvariable="LB_RestaurarRelacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Confirma_que_desea_Aplicar_esta_Relacion" default="¿Confirma que desea Aplicar esta Relación?"	 returnvariable="LB_AplicarRelacion" component="sif.Componentes.Translate" method="Translate"/>
<!---Boton de aplicar ---->
<cfinvoke key="BTN_Aplicar" default="Aplicar" returnvariable="BTN_Aplicar" xmlfile="/rh/generales.xml"  component="sif.Componentes.Translate" method="Translate"/>
<!---Boton de Restaurar ---->
<cfinvoke key="BTN_Restaurar" default="Restaurar" returnvariable="BTN_Restaurar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<!---Boton de Comisiones ---->
<cfinvoke key="BTN_Comisiones" default="Comisiones"	 xmlfile="/rh/generales.xml" returnvariable="BTN_Comisiones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Identificacion" default="Identificación"	 returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Empleado" default="Empleado"	 xmlfile="/rh/generales.xml" returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_S_Bruto" default="S. Bruto"	 returnvariable="LB_S_Bruto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Incidencias" default="Incidencias"	 returnvariable="LB_Incidencias" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_S_Líquido" default="S. Líquido"	 returnvariable="LB_S_Líquido" component="sif.Componentes.Translate" method="Translate"/>

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

<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=Filtrar">
<cfif isdefined("Form.DEid")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEid=" & form.DEid>
</cfif>
<cfif isdefined("Form.RCNid")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RCNid=" & form.RCNid>				
</cfif>

<cfif isdefined("Form.nombreFiltro") and Len(Trim(Form.nombreFiltro)) NEQ 0>
	<cfset filtro = filtro & " and upper({fn concat({fn concat({fn concat({ fn concat(b.DEapellido1, ' ') },b.DEapellido2)}, ' ')},b.DEnombre) }) like '%" & #UCase(Form.nombreFiltro)# & "%'">
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



<cfset pintarReporte = true>



	
<cfset Request.Regresar = "ResultadoCalculoRetro-lista.cfm">
<cfinclude template="/rh/portlets/pRelacionCalculo.cfm">

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
  <!--- <tr><td width="90%">&nbsp;</td></tr> --->
  <tr>
		<td width="90%">
			<form name="formFiltroListaEmpl" method="post" action="ResultadoCalculoRetro-lista.cfm">
				<input type="hidden" name="filtrado" value="<cfif isdefined('form.btnFiltrar') or isdefined('form.filtrado')>Filtrar</cfif>">
				<input type="hidden" name="sel" value="<cfif isdefined('form.sel')><cfoutput>#form.sel#</cfoutput><cfelse>0</cfif>">
				<input type="hidden" name="RCNid" value="<cfoutput>#Form.RCNid#</cfoutput>">
								

				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro" align="center">
					<tr> 
						<td width="25%" height="17" class="fileLabel"><cf_translate key="LB_Identificacion"  xmlfile="/rh/generales.xml">Identificaci&oacute;n</cf_translate></td>
						<td width="50%" class="fileLabel"><cf_translate key="LB_Nombre_del_empleado"  xmlfile="/rh/generales.xml">Nombre del empleado</cf_translate></td>
						<td width="20%" class="fileLabel">&nbsp;</td>
						<td width="5%" rowspan="2" class="fileLabel" nowrap>
							<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar"><br>
							<input name="btnLimpiar" type="button" id="btnLimpiar" value="Limpiar" onclick="javascript:limpiar();">
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
					select DEidentificacion, {fn concat({fn concat({fn concat({ fn concat(b.DEapellido1, ' ') },b.DEapellido2)}, ' ')},b.DEnombre) } as nombreEmpl
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
		<!---<cfset botones = "Excluir Deducciones" >--->
		<cfif rsCantModificados.RecordCount gt 0 and isdefined ('rsSalNegativos') and rsSalNegativos.RecordCount gt 0 and not isdefined ('rsEspeciales') and not isdefined ('existsHRCalculoNomina')>
			<cfset botones = "Aplicar,Restaurar"> 
		<cfelseif rsCantModificados.RecordCount lte 0>
			<cfset botones = "Aplicar,Restaurar">
		<cfelse>
			<cfset botones = "Restaurar">
		</cfif>
		
	
		
		<!---<cfif rsComision.RecordCount gt 0 and trim(rsComision.Pvalor) eq 1 >--->
		<cfif vComisionSB EQ 1 or vComisionCSB EQ 1 >
			<cfset botones = botones & ",#BTN_Comisiones#">
		</cfif>

		<cfset imgok = "">
		<cfset imgrecalcular = "<img border=''0'' src=''/cfmx/rh/imagenes/Cferror.gif'' onClick=''javascript:return funcOpen();''>">

		<!--- para mantener el check de calculado en el filtro --->	
		<cfset calculado = "" >
		<cfif isdefined("form.fSEcalculado")>
			<cfset calculado = ", 0 as fSEcalculado" >
		</cfif>
		
		<!--- datos --->	
		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaEmpl">
			<cfinvokeargument name="tabla" value="SalarioEmpleado a, DatosEmpleado b"/>
			<cfinvokeargument name="columnas" value="'#Form.RCNid#' as CPid, '#Form.RCTcodigo#' as Tcodigo, a.RCNid, b.DEid, b.DEidentificacion,
													{fn concat({fn concat({fn concat({ fn concat(b.DEapellido1, ' ') },b.DEapellido2)}, ' ')},b.DEnombre) } as nombreEmpl, 
													 a.SEsalariobruto, a.SEincidencias, a.SEliquido, 
													 case SEcalculado when 1 then '#imgok#' else '#imgrecalcular#' end as estado, 1 as o,1 as sel #calculado#"/>
			<cfinvokeargument name="desplegar" value="DEidentificacion, nombreEmpl, SEsalariobruto, SEincidencias, SEliquido, estado"/>
			<cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_Empleado#,#LB_S_Bruto#, #LB_Incidencias#, #LB_S_Líquido#,&nbsp;"/>
			<cfinvokeargument name="formatos" value="S,S,M,M,M,S"/>
			<cfinvokeargument name="formName" value="listaEmpleados"/>	
			<cfinvokeargument name="filtro" value="a.RCNid = #Form.RCNid# and b.DEid = a.DEid  #filtro# order by SEcalculado,DEidentificacion, DEapellido1, DEapellido2, DEnombre"/>
			<cfinvokeargument name="align" value="left,left,right,right,right,right"/>
			<cfinvokeargument name="ajustar" value="N"/>

			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="irA" value="ResultadoCalculoRetro.cfm"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="botones" value="#botones#"/>
		</cfinvoke>

	</td>
  </tr>
</table>


<script language="JavaScript1.2" type="text/javascript">
	var _RCNid = document.formFiltroListaEmpl.RCNid.value;
	var nuevo=0;
	function funcOpen(id) {
			var width = 500;
			var height = 150
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			<cfoutput>
			nuevo = window.open('ResultadoCalculoMensajesRetro.cfm?RCNid='+_RCNid,'Justificacion','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
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
				document.location = "ResultadoCalculoRetro-listaSql.cfm?Accion=Restaurar&RCNid=#Form.RCNid#&Tcodigo=#Form.RCTcodigo#";
			return result;
		}
		
		<cfif (rsCantModificados.RecordCount lte 0) or (rsCantModificados.RecordCount gt 0 and isdefined ('rsSalNegativos')  and not isdefined ('rsEspeciales') and not isdefined ('existsHRCalculoNomina'))>
			function funcAplicar(){
				var result = false;
				if (confirm("#LB_AplicarRelacion#")) {
					document.location = "ResultadoCalculoRetro-listaSql.cfm?Accion=Aplicar&RCNid=#Form.RCNid#";
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

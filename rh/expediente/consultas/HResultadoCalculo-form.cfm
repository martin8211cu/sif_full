<cfinvoke component="rh.Componentes.BoletaPago" method="GetRutaBoleta" returnvariable="ruta"/>

<!--- VARIABLES DE TRADUCCION --->
<cfsilent>
<cfinvoke Key="LB_Semanal" Default="Semanal" returnvariable="LB_Semanal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Bisemanal" Default="Bisemanal"	 returnvariable="LB_Bisemanal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Quincenal" Default="Quincenal"	 returnvariable="LB_Quincenal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Regresar" default="Regresar" returnvariable="BTN_Regresar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
</cfsilent>
<!--- VARIABLES DE TRADUCCION --->

<cfquery name="rsMostrarSalarioNominal" datasource="#session.DSN#">
	select coalesce(Pvalor,'0') as  Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo = 1040
</cfquery>


<cfif isdefined("url.enviadoMail") and  url.enviadoMail eq 'true' >
	<cfoutput>
	<script language="javascript" type="text/javascript">
		alert("El correo fue enviado satisfactoriamente.");
	</script>
	</cfoutput>
<cfelseif isdefined("url.enviadoMail") and  url.enviadoMail eq 'false'>	
  	<cfoutput>
	<script language="javascript" type="text/javascript">
		alert("Un error ha ocurrido, el correo NO ha  sido enviado.");
	</script>
	</cfoutput>
</cfif>

<cfif isdefined("url.RCNid") and not isdefined("form.RCNid")>	
	<cfset form.RCNid = url.RCNid >
</cfif>
<cfif isdefined("url.DEid") and not isdefined("form.DEid")>	
	<cfset form.DEid = url.DEid >
</cfif>
<cfif isdefined("url.Tcodigo") and not isdefined("form.Tcodigo")>	
	<cfset form.Tcodigo = url.Tcodigo >
</cfif>
<cfif isdefined("url.chkIncidencias") and not isdefined("form.chkIncidencias")>	
	<cfset form.chkIncidencias = url.chkIncidencias >
</cfif>
<cfif isdefined("url.chkCargas") and not isdefined("form.chkCargas")>	
	<cfset form.chkCargas = url.chkCargas >
</cfif>
<cfif isdefined("url.chkDeducciones") and not isdefined("form.chkDeducciones")>	
	<cfset form.chkDeducciones = url.chkDeducciones >
</cfif>
<!--- Consultas --->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Session.DSN#" ecodigo="#session.Ecodigo#" pvalor="785" default="0" returnvariable="UnificaSalarioB"/>

<!--- Monedas --->
<cfquery name="rsMoneda" datasource="#Session.DSN#">
	select Miso4217, Msimbolo 
	from Monedas a, HRCalculoNomina b, TiposNomina c 
	where b.Tcodigo = c.Tcodigo 
	  and a.Mcodigo = c.Mcodigo 
	  and b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	  and a.Ecodigo = b.Ecodigo
	  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<!--- HSalarioEmpleado --->
<cfquery name="rsSE" datasource="#Session.DSN#">
	select SEcalculado
	from HSalarioEmpleado 
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
</cfquery>
<!--- HRCalculoNomina --->
<cfquery name="HRCalculoNomina" datasource="#Session.DSN#">
	select c.CPfpago, a.RCdesde, a.RChasta, b.Tdescripcion,a.Tcodigo,
	case Ttipopago when 0 then '#LB_Semanal#'
	when 1 then '#LB_Bisemanal#'
	when 2 then '#LB_Quincenal#'
	else ''
	end as   descripcion
	
	from HRCalculoNomina a
	
	inner join TiposNomina b
	on a.Tcodigo = b.Tcodigo
	
	inner join CalendarioPagos c
  	on a.RCNid = c.CPid
	
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.Ecodigo = b.Ecodigo
	
</cfquery>


<!--- JavaScript --->
<script language="JavaScript1.2" type="text/javascript">
	var popUpWin=0;

	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
</script>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<cf_templatecss>
<cf_templatecss>
<style type="text/css">
.tituloAlterno2 {
	font-weight: bolder;
	text-align: center;
	vertical-align: middle;

	padding: 2px;
	background-color: #DFDFDF;
}
</style>
<cfoutput>
<form name="formEmail" method="post" action="HResultadoCalculo-email.cfm" style="margin:0">
	<cfif isdefined("Url.CPcodigo") and Len(Trim(Url.CPcodigo)) NEQ 0>
		<input name="Tcodigo" type="hidden" value="#Url.Tcodigo#">
		<input name="CPcodigo" type="hidden" value="#Url.CPcodigo#">
		<cfif isdefined("Url.chkIncidencias")>
			<input name="chkIncidencias" type="hidden" value="#Url.chkIncidencias#">
		</cfif>
		<cfif isdefined("Url.chkCargas")>
		  <input name="chkCargas2" type="hidden" value="#Url.chkCargas#" />
		</cfif>
		<cfif isdefined("Url.chkDeducciones")>
			<input name="chkDeducciones" type="hidden" value="#Url.chkDeducciones#">
		</cfif>
	<cfelseif isdefined("Form.CPcodigo") and Len(Trim(Form.CPcodigo)) NEQ 0>
		<input name="Tcodigo" type="hidden" value="#Form.Tcodigo#">
		<input name="CPcodigo" type="hidden" value="#Form.CPcodigo#">
		<input name="chkIncidencias" type="hidden" value="1">
		<input name="chkCargas" type="hidden" value="1">
		<input name="chkDeducciones" type="hidden" value="1">
	</cfif>

	<input name="butFiltrar" type="hidden" value="Filtrar">
	<input type="hidden" name="RCNid" value="#Form.RCNid#">
	<input type="hidden" name="DEid" value="#Form.DEid#">
	<input type="hidden" name="sel" value="1">
	
	<cfif isDefined("Url.Regresar")>
		<input type="hidden" name="regresar" value="<cfoutput>#Url.Regresar#</cfoutput>">
	<cfelse>
		<input type="hidden" name="regresar" value="<cfif isdefined("form.regresar") and len(trim(form.regresar))><cfoutput>#form.regresar#</cfoutput><cfelse>HistoricoPagos.cfm</cfif>">
	</cfif>
</form>
<!--- CODIGO PARA ENVIAR EMAIL --->
<!--- INICIO --->
<script language="javascript" type="text/javascript">
	function sendMail(){
	   	<!---document.formEmail.action = "<cfoutput>#Ruta.autogestion#</cfoutput>";--->
		document.formEmail.submit();
	}
</script>

</cfoutput>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td nowrap width="100%" valign="middle">&nbsp;</td>
	<!--- No imprimir esto en la Consulta historica de Boletas de pago--->
	<cfif not isdefined('form.origen') or ( isdefined("form.origen") and form.origen neq 'HBoletasPago.cfm' ) >
		<td nowrap valign="middle"><a title="Enviar por Correo" href="##" onclick="javascript:sendMail();"><img src="/cfmx/rh/imagenes/email/newmail.gif" width="16	" height="16" border="0"></a></td>
		<td nowrap valign="middle"><a title="Enviar por Correo" href="##" onclick="javascript:sendMail();"><cf_translate  key="LB_EnviarPorEmail">Enviar por Email</cf_translate></a></td>
	</cfif>
  </tr>
</table>
<!--- FIN --->
<table width="97%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
	<tr bgcolor="#EEEEEE" style="padding: 3px;">
		<td align="center"><font size="3"><b><cf_translate  key="LB_DetalleDeHistoricoDePagosRealizados">Detalle de Hist&oacute;rico de Pagos Realizados</cf_translate></b></font></td>
		<td align="right"><cf_sifayuda name="imAyuda" imagen="3" Tip="false" width="800" height="450" scrollbars="yes" ></td>
	</tr>
</table>

<cfinclude template="/rh/portlets/pEmpleado.cfm">
<br>
<!--- ========================= Informacion de la Nomina ========================= ---> 
<cfoutput>
<table width="97%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
	<tr>
		<td nowrap class="FileLabel" align="right"><cf_translate  key="LB_TipoDeNomina">Tipo de N&oacute;mina</cf_translate> :&nbsp;</td>
		<td nowrap class="" align="left">#HRCalculoNomina.Tdescripcion#</td>
		<td nowrap class="FileLabel" align="right"><cf_translate  key="LB_Pago">Pago</cf_translate> :&nbsp;</td>
		<td nowrap class="" align="left">#LSDateFormat(HRCalculoNomina.CPfpago,'dd/mm/yyyy')#</td>
		<td nowrap class="FileLabel" align="right"><cf_translate  key="LB_Desde">Desde</cf_translate> :&nbsp;</td>
		<td nowrap class="" align="left">#LSDateFormat(HRCalculoNomina.RCdesde,'dd/mm/yyyy')#</td>
		<td nowrap class="FileLabel" align="right"><cf_translate  key="LB_Hasta">Hasta</cf_translate> :&nbsp;</td>
		<td nowrap class="" align="left">#LSDateFormat(HRCalculoNomina.RChasta,'dd/mm/yyyy')#</td>
	</tr>
</table>
</cfoutput>
<br>
<!--- ========================= Informacion Resumida ========================= ---> 
<cfquery name="rsSalarioEmpleado" datasource="#Session.DSN#">
	select 	SEsalariobruto, SEincidencias, SErenta, SEcargasempleado, 
	SEcargaspatrono,  SEdeducciones, SEliquido
	from HSalarioEmpleado 
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
</cfquery>


<table width="97%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;" align="center">
	<tr><td nowrap colspan="9" class="<cfoutput>#Session.Preferences.Skin#_thcenter</cfoutput>"><div align="center"><font size="2">
	<cf_translate  key="LB_InformacionResumida">Informaci&oacute;n  Resumida</cf_translate></font></div></td></tr>
	<cfoutput>   
		<cfif rsSalarioEmpleado.RecordCount gt 0 >
			<tr> 
				<td nowrap class="FileLabel"><div align="right"><cf_translate  key="LB_SalarioBruto">Salario Bruto</cf_translate>:&nbsp;</div></td>

				 <cfif rsMostrarSalarioNominal.Pvalor eq 1>
					<cfif HRCalculoNomina.Tcodigo neq 3>
						<td nowrap class="FileLabel"><div align="right"><cf_translate  key="LB_Salario">Salario</cf_translate>&nbsp;#HRCalculoNomina.descripcion#:&nbsp;</div></td>
					</cfif>
				 </cfif>
				<cfif not UnificaSalarioB><td nowrap class="FileLabel"><div align="right"><cf_translate  key="LB_Incidencias">Incidencias</cf_translate>:&nbsp;</div></td></cfif>
				<td nowrap class="FileLabel"><div align="right"><cf_translate  key="LB_Renta">Renta</cf_translate>:&nbsp;</div></td>
				<td nowrap class="FileLabel"><div align="right"><cf_translate  key="LB_CargasEmpleado">Cargas Empleado</cf_translate>:&nbsp;</div></td>
				<td nowrap class="FileLabel"><div align="right"><cf_translate  key="LB_Deducciones">Deducciones</cf_translate>:&nbsp;</div></td>
				<td nowrap class="FileLabel"><div align="right"><cf_translate  key="LB_SalarioLIquido">Salario Líquido</cf_translate>:&nbsp;</div></td>
			</tr>

			<tr>
				<td nowrap align="right">#rsMoneda.Msimbolo# <cfif not UnificaSalarioB>#LSCurrencyFormat(rsSalarioEmpleado.SEsalariobruto,'none')#<cfelse>#LSCurrencyFormat(rsSalarioEmpleado.SEsalariobruto+rsSalarioEmpleado.SEincidencias,'none')#</cfif></td>

				<cfif rsMostrarSalarioNominal.Pvalor eq 1>
					<cfif HRCalculoNomina.Tcodigo neq 3>
						<cfquery name="rsLineaTiempo" datasource="#Session.DSN#">
							select LTsalario from LineaTiempo
							where <cfqueryparam cfsqltype="cf_sql_date" value="#HRCalculoNomina.RCdesde#"> 
								   between LTdesde and LThasta
							and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
						</cfquery>
						<cfif rsLineaTiempo.recordCount EQ 0>
							<cfquery name="rsLineaTiempo" datasource="#Session.DSN#">
								select LTsalario from LineaTiempo
								where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
								and LThasta =    (select max(LThasta) from LineaTiempo  where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">)
							</cfquery>
						</cfif>
						<cfinvoke component="rh.Componentes.RH_Funciones" 
							method="salarioTipoNomina"
							salario = "#rsLineaTiempo.LTsalario#"
							Tcodigo = "#HRCalculoNomina.Tcodigo#"
							returnvariable="var_salarioTipoNomina">
							<td nowrap align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(var_salarioTipoNomina,'none')#</td>
					</cfif>
				 </cfif>				
				<cfif not UnificaSalarioB><td nowrap align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEincidencias,'none')#</td></cfif>
				<td nowrap align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SErenta,'none')#</td>
				<td nowrap align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEcargasempleado,'none')#</td>
				<td nowrap align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEdeducciones,'none')#</td>
				<td nowrap align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(rsSalarioEmpleado.SEliquido,'none')#</td>
			</tr>
			<cfelse>
			<tr><td colspan="6" align="center"><cf_translate  key="LB_NoHayPagosAsociadosAlEmpleado">No hay Pagos asociados al empleado</cf_translate></td></tr>
		</cfif>	
	</cfoutput>			
</table>
<!--- ========================= Informacion Resumida - FIN ========================= ---> 

<cfif isDefined("Url.Regresar")>
	<form action="<cfoutput>#Url.Regresar#</cfoutput>" method="post" name="form1">
<cfelse>
	<form action="<cfif isdefined("form.regresar") and len(trim(form.regresar))><cfoutput>#form.regresar#</cfoutput><cfelse>HistoricoPagos.cfm</cfif>" method="post" name="form1">
</cfif>

  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;" align="center">
    <tr><td nowrap colspan="9" class="<cfoutput>#Session.Preferences.Skin#_thcenter</cfoutput>"><div align="center"><font size="2">
	<cf_translate  key="LB_InformacionDetallada">Informaci&oacute;n Detallada</cf_translate></font></div></td></tr>

    <!--- ======================= Salarios ======================== --->
	<cfset vDias = 1 >
	
	<cfquery name="rsDias" datasource="#Session.DSN#">
		select <cf_dbfunction name="to_number" args="FactorDiasSalario"> as dias, r.RChasta
		from TiposNomina t, HRCalculoNomina r
		where t.Ecodigo = r.Ecodigo
		  and t.Tcodigo = r.Tcodigo
		  and r.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">

	</cfquery>
	
	<cfif len(trim(rsDias.dias)) eq 0 >
		<cfquery name="rsDias" datasource="#Session.DSN#">
			select Pvalor as dias
			from RHParametros 
			where Pcodigo = 80 --Numero de días para el Calculo de la Nomina Mensual
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>
	
	<cfif rsDias.recordCount gt 0 and len(trim(rsDias.dias))>
		<cfset vDias = rsDias.dias >
	</cfif>

	<cfquery name="rsPagosEmpleado" datasource="#Session.DSN#">
		select 	a.PEdesde, a.PEhasta, a.PEsalario, 
				<!----round((a.PEsalario/<cfqueryparam cfsqltype="cf_sql_numeric" value="#vDias#">),2) as PEdiario,---->
				case when a.PEcantdias > 0 then
						round((a.PEmontores/a.PEcantdias),2)
				else 0
				end	as PEdiario,
				a.PEcantdias, a.PEmontores, a.PEtiporeg, b.RHTcodigo
		from HPagosEmpleado a, RHTipoAccion b 
		where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	    and a.RHTid=b.RHTid
		order by a.PEdesde, a.PEhasta
	</cfquery>

	<cfquery name="rsPagosEmpleado_0" dbtype="query">
		select * from rsPagosEmpleado where PEtiporeg = 0
	</cfquery>
	<cfquery name="rsPagosEmpleado_1" dbtype="query">
		select * from rsPagosEmpleado where PEtiporeg = 1
	</cfquery>
	<cfquery name="rsPagosEmpleado_2" dbtype="query">
		select * from rsPagosEmpleado where PEtiporeg = 2
	</cfquery>

	<cfset vHorasDiarias = 0 >
	<cfquery name="rsHoras" datasource="#session.DSN#" >
		select RHJhoradiaria, RHJornadahora
		from RHJornadas a, LineaTiempo b
		where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		and a.Ecodigo = b.Ecodigo
		
		and a.RHJid = b.RHJid
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDias.RChasta#"> between LTdesde and LThasta 
	</cfquery>
	<cfif rsHoras.Recordcount>
		<cfset vHorasDiarias = rsHoras.RHJhoradiaria >
		<cfset vSalarioporHora = rsHoras.RHJornadahora>
	<cfelse>
		<cfset vHorasDiarias = 0 >
		<cfset vSalarioporHora = 0>
	</cfif>

	<tr><td nowrap colspan="9" class="tituloAlterno2"><cf_translate  key="LB_Salarios">Salarios</cf_translate></td></tr>

	<cfif rsPagosEmpleado_0.RecordCount gt 0>
		<tr >
			<td nowrap align="left" class="FileLabel"><cf_translate  key="LB_FechaDesde">Fecha Desde</cf_translate></td>
			<td nowrap align="left" class="FileLabel"><cf_translate  key="LB_FechaHasta">Fecha Hasta</cf_translate></td>
			<td nowrap align="left" class="FileLabel"><cf_translate  key="LB_CodigoAccion">C&oacute;digo Acci&oacute;n</cf_translate></td>
			<td nowrap align="right" class="FileLabel"><cf_translate  key="LB_Salario">Salario</cf_translate></td>
			<td nowrap align="right" class="FileLabel"><cf_translate  key="LB_SalarioDiario">Salario Diario</cf_translate></td>
			<cfif len(trim(vSalarioporHora)) and vSalarioporHora gt 0>
				<td nowrap align="right"  colclass="FileLabel"><cf_translate  key="LB_SalarioHora" xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml">Salario por Hora</cf_translate></td>
			<cfelse>
				<td nowrap align="right" >&nbsp;</td>
			</cfif>
			<td nowrap align="right" class="FileLabel"><cf_translate  key="LB_Dias">Días</cf_translate></td>
			<td nowrap align="right" class="FileLabel"><cf_translate  key="LB_Monto">Monto</cf_translate></td>
			<td nowrap align="right" >&nbsp;</td>
		</tr>
	
		<cfoutput query="rsPagosEmpleado_0">
			<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
				<td nowrap align="left" >#LSDateFormat(PEdesde,'dd/mm/yyyy')#</td>
				<td nowrap align="left" >#LSDateFormat(PEhasta,'dd/mm/yyyy')#</td>
				<td nowrap align="left" >#RHTcodigo#</td>
				<td nowrap align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(PEsalario,'none')# </td>
				<td nowrap align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(PEdiario,'none')# </td>
				<cfif len(trim(vSalarioporHora)) and vSalarioporHora gt 0>
					<td nowrap align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(PEdiario/vHorasDiarias,'none')#</td>
					<cfelse>
					<td nowrap align="right" >&nbsp;</td>
				</cfif>
				<td nowrap align="right" >#PEcantdias#</td>
				<td nowrap align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(PEmontores,'none')# </td>
				<td nowrap align="right" >&nbsp;</td>
			</tr>
		</cfoutput>
	<cfelse>		
		<tr><td colspan="9" align="center"><b><cf_translate  key="LB_NoHayPagosAsociadosAlEmpleado">No hay Pagos asociados al empleado</cf_translate></b></td></tr>
	</cfif>
    <!--- ======================= Salarios - FIN ======================== --->
	
	 <!--- ======================= Retroactivos - INI ======================== --->
	<cfif rsPagosEmpleado_1.RecordCount GT 0>
		<tr>
			<td nowrap colspan="9" class="<cfoutput>#Session.Preferences.Skin#_thcenter</cfoutput>"><div align="center"><strong><cf_translate  key="LB_RetroactivosRecalculados">Retroactivos Recalculados</cf_translate></strong></div></td>
		</tr>
		<cfoutput query="rsPagosEmpleado_1">
			<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
				<td nowrap align="left" >#LSDateFormat(PEdesde,'dd/mm/yyyy')#</td>
				<td nowrap align="left" >#LSDateFormat(PEhasta,'dd/mm/yyyy')#</td>
				<td nowrap align="left" >#RHTcodigo#</td>
				<td nowrap align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(PEsalario,'none')# </td>
				<td nowrap align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(PEdiario,'none')# </td>
				<td nowrap align="right" >&nbsp;</td>
				<td nowrap align="right" >#PEcantdias#</td>
				<td nowrap align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(PEmontores,'none')# </td>
				<td nowrap align="right" >&nbsp;</td>
			</tr>
		</cfoutput>
	</cfif>
	<cfif rsPagosEmpleado_2.RecordCount gt 0>
		<tr>
			<td nowrap colspan="9" class="<cfoutput>#Session.Preferences.Skin#_thcenter</cfoutput>"><div align="center"><strong><cf_translate  key="LB_RetroactivosYaPagados">Retroactivos ya Pagados</cf_translate></strong></div></td>
		</tr>
		<cfoutput query="rsPagosEmpleado_2">
			<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
				<td nowrap align="left">#LSDateFormat(PEdesde,'dd/mm/yyyy')#</td>
				<td nowrap align="left">#LSDateFormat(PEhasta,'dd/mm/yyyy')#</td>
				<td nowrap align="left">#RHTcodigo#</td>
				<td nowrap align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(PEsalario,'none')# </td>
				<td nowrap align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(PEdiario,'none')# </td>
				<td nowrap align="right" >&nbsp;</td>
				<td nowrap align="right">#PEcantdias#</td>
				<td nowrap align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(PEmontores,'none')# </td>
				<td nowrap align="right">&nbsp;</td>
			</tr>
		</cfoutput>
	</cfif>
	 <!--- ======================= Retroactivos - FIN ======================== --->

    <!--- ======================= Incidencias ======================== --->
    <tr valign="top"> 
      <td nowrap colspan="9">&nbsp;</td>
    </tr>
	<cfquery name="rsIncidenciasCalculo" datasource="#Session.DSN#">		   
		select <cf_dbfunction name="to_char" args="ICid"> as ICid, b.CIdescripcion, a.ICfecha, 
			   (case when CItipo < 2 then a.ICvalor else null end) as ICvalor, 
			   (case when (CItipo < 2 and a.ICvalor > 0) then round(a.ICmontores/(a.ICvalor*1.00), 2) else null end) as ICvalorcalculado, 
			   a.ICmontores, a.ICcalculo
		   			   
		from HIncidenciasCalculo a, CIncidentes b
		where a.CIid = b.CIid
		and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
		and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		and CIcarreracp = 0		<!--- considera conceptos de pago por carrera profesional --->		
	    order by b.CIdescripcion, a.ICfecha,  b.CIcodigo
	</cfquery>
	<cfquery name="rsIncidenciasCarreraP" datasource="#Session.DSN#">
		select ICid as ICid, b.CIdescripcion, a.ICfecha, 
			   (case when CItipo < 2 then a.ICvalor else null end) as ICvalor, 
			   (case when (CItipo < 2 and a.ICvalor > 0) then round(a.ICmontores/(a.ICvalor*1.00), 2) else null end) as ICvalorcalculado, 
			   a.ICmontores, a.ICcalculo,
				CCPid, CCPacumulable, CCPprioridad, TCCPid
		from HIncidenciasCalculo a, CIncidentes b, ConceptosCarreraP c
		where a.CIid = b.CIid
		and c.CIid = b.CIid
		and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
		and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		and CIcarreracp = 1		<!--- considera conceptos de pago por carrera profesional --->
		order by a.ICfecha
	</cfquery>
	
	
	<tr><td colspan="9" class="tituloAlterno2"><cf_translate  key="LB_Incidencias">Incidencias</cf_translate></td></tr>
	
	<cfif rsIncidenciasCalculo.RecordCount gt 0>
		<!--- Parametro general de RH para determinar si se pinta o no las columnas de "Unidades" y "Valor" --->
			<cfquery name="rsParamRH" datasource="#Session.DSN#">
				select Pvalor
				from RHParametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Pcodigo = 550
			</cfquery>				
			<cfset cantCols = 5>
			<cfset tamColDescr = 50>
			
			<cfif isdefined('rsParamRH') and rsParamRH.recordCount GT 0>
				<cfif rsParamRH.Pvalor EQ 1>
					<cfset cantCols = 5>
					<cfset tamColDescr = 50>
				<cfelse>
					<cfset cantCols = 3>
					<cfset tamColDescr = 75>
				</cfif>
			</cfif>
				
		<tr> 
			<td align="left" class="FileLabel" ><cf_translate  key="LB_Fecha">Fecha</cf_translate></td>
			<td nowrap align="right" >&nbsp;</td>
			<td align="left" class="FileLabel" ><cf_translate  key="LB_Concepto">Concepto</cf_translate></td>
			<td nowrap align="right" colspan="3">&nbsp;</td>
			<cfif isdefined('rsParamRH') and rsParamRH.Pvalor EQ 1>
				<td align="right" class="FileLabel"><cf_translate  key="LB_Monto">Valor</cf_translate></td>
			<cfelse>
				<td align="right" class="FileLabel">&nbsp;</td>
			</cfif>
			<td align="right" class="FileLabel"><cf_translate  key="LB_Monto">Monto</cf_translate></td>
			<td align="right" class="FileLabel">&nbsp;</td>
		</tr>
		<cfoutput query="rsIncidenciasCalculo">
			<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
				<td align="left" colspan="2">#LSDateFormat(ICfecha,'dd/mm/yyyy')#</td>
				<td align="left" >#CIdescripcion#</td>
				<td nowrap align="right" colspan="3">&nbsp;</td>
					<cfif isdefined('rsParamRH') and rsParamRH.Pvalor EQ 1>
						<td align="right"><cfif Len(Trim(ICvalor))>#LSCurrencyFormat(ICvalorcalculado, 'none')#</cfif></td>	
					<cfelse>
						<td align="right">&nbsp;</td>				
					</cfif>				
				<td align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(ICmontores,'none')# </td>
				<cfif ICcalculo eq 1>
						<td align="right"><img border="0" src="/cfmx/rh/imagenes/Cferror.gif"></td>
				<cfelse>	
					<td align="right">&nbsp;</td>		
				</cfif>
			</tr>
		</cfoutput>
	
	  	<cfif rsIncidenciasCarreraP.recordCount GT 0 >
			<tr><td>&nbsp;</td></tr>
		  	<tr><td colspan="9" bgcolor="#EAEAEA" style="padding-left:10px;" ><strong><cf_translate key="LB_Carerra_Profesional" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Carrera Profesional</cf_translate></strong></td></tr>
			<tr> 
				<td align="left" class="FileLabel"><cf_translate  key="LB_Fecha">Fecha</cf_translate></td>
				<td align="left" class="FileLabel" colspan="3"><cf_translate  key="LB_Concepto">Concepto</cf_translate></td>
				<td align="left" class="FileLabel" >&nbsp;</td>
				<td align="right" class="FileLabel" ><cf_translate key="LB_Puntos">Puntos</cf_translate></td>
				<cfif isdefined('rsParamRH') and rsParamRH.Pvalor EQ 1>
						<td align="right" class="FileLabel">	<cf_translate  key="LB_Valor">Valor</cf_translate></td>
					<cfelse>
						<td align="right" class="FileLabel">&nbsp;</td>			
					</cfif>
				</td>
				<td align="right" class="FileLabel"><cf_translate  key="LB_Monto">Monto</cf_translate></td>
				<td align="right" class="FileLabel">&nbsp;</td>
			</tr>
		  <cfoutput query="rsIncidenciasCarreraP">
			<cfinvoke component="rh.Componentes.RH_CalculoCP" method="AcumulaConceptos" returnvariable="Conceptos" conexion="#session.DSN#"
				ecodigo = "#session.Ecodigo#" ccpid = "#rsIncidenciasCarreraP.CCPid#" acumula = "#rsIncidenciasCarreraP.CCPacumulable#" tccpid="#rsIncidenciasCarreraP.TCCPid#"
				prioridad="#rsIncidenciasCarreraP.CCPprioridad#" rcdesde="#HRCalculoNomina.RCdesde#" rchasta="#HRCalculoNomina.RChasta#" deid = "#Form.DEid#"/>
		  <tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif>>
			<td align="left"  nowrap>#LSDateFormat(ICfecha,'dd/mm/yyyy')#</td>
			<td align="left" colspan="3"  nowrap>#CIdescripcion#</td>
			<td align="left">&nbsp;</td>
			<td align="right">#LSCurrencyFormat(Conceptos.valor, 'none')#</td>
			<td align="right">
				<cfif isdefined('rsParamRH') and rsParamRH.Pvalor EQ 1>
					<cfif Len(Trim(ICvalor))>#LSCurrencyFormat(ICvalorcalculado, 'none')#</cfif>
				<cfelse>
					&nbsp;
				</cfif>
			</td>								
			<td align="right"  nowrap>#LSNumberFormat(ICmontores,'(___,___,___,___,___.__)')#</td>
			<cfif ICcalculo eq 1>
				<td align="right">	<img border="0" src="/cfmx/rh/imagenes/Cferror.gif"></td>
			<cfelse>
				<td align="right">&nbsp;</td>	
			</cfif>			
		  </tr>
		  </cfoutput>
	  </cfif>
		
		
		
		
	<cfelse>		
		<tr><td colspan="9" align="center"><b><cf_translate  key="LB_NoHayIncidenciasAsociadasAlEmpleado">No hay Incidencias asociadas al Empleado</cf_translate></b></td></tr>
	</cfif>
    <!--- ======================= Incidencias - FIN ======================== --->

    <!--- ======================= Cargas ======================== --->

    <tr valign="top"> 
      <td nowrap colspan="9">&nbsp;</td>
    </tr>

	<cfquery name="rsCargasCalculo" datasource="#Session.DSN#">
		select 	a.DClinea, CCvaloremp, CCvalorpat, DCdescripcion, ECauto, ECresumido, c.ECid, b.DCnomostrar as DCnomostrar
		from HCargasCalculo a
		
		inner join DCargas b
		on a.DClinea = b.DClinea
		
		inner join ECargas c
	    on b.ECid = c.ECid

		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		order by c.ECid  
	</cfquery>

	<tr><td colspan="9" class="tituloAlterno2"><cf_translate  key="LB_Cargas">Cargas</cf_translate></td></tr>
    <cfset idBandera= "" >	
	<cfif rsCargasCalculo.RecordCount gt 0>
		<tr>
			<td align="left" class="FileLabel" colspan="6"><cf_translate  key="LB_Descripcion">Descripci&oacute;n</cf_translate></td>
			<td align="right" class="FileLabel"><cf_translate  key="LB_MontoPatrono">Monto Patrono</cf_translate></td>
			<td align="right" class="FileLabel"><cf_translate  key="LB_MontoEmpleado">Monto Empleado</cf_translate></td>						
			<td align="right" class="FileLabel">&nbsp;</td>
		</tr>
		<cfoutput query="rsCargasCalculo">
            <cfif rsCargasCalculo.ECresumido is  1 >										            
				<cfif idBandera neq #rsCargasCalculo.ECid#> 	
				
						<cfquery name = "rsCargasCalculoResumido" datasource="#Session.DSN#">
						   		 select e.ECdescripcion as descripcion, sum(cc.CCvaloremp) as empleado,
								 sum(coalesce(CCvalorpat,0)) as patrono
								 from HCargasCalculo cc, ECargas e, DCargas d
								 where cc.RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
				  				 and cc.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
								 and e.ECid = #rsCargasCalculo.ECid#
				  				 and cc.DClinea = d.DClinea
				  	        	 and e.ECid = d.ECid  
				  				 and e.Ecodigo = #Session.Ecodigo#					
                    		     <!---and cc.CCvaloremp is not null
		            			 and cc.CCvaloremp <> 0--->					
								 group by e.ECdescripcion, e.ECid 																					
				         </cfquery>							   
					   	 <cfset idBandera=#rsCargasCalculo.ECid# >	
														
							<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
								<td align="left" colspan="6">#rsCargasCalculoResumido.descripcion#</td>
								<td align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(rsCargasCalculoResumido.patrono,'none')# </td>
								<td align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(rsCargasCalculoResumido.empleado,'none')# </td>
								<td align="right" >&nbsp;</td>
							</tr>		
							
				    	</cfif>	
				<cfelse>		 
					<cfif rsCargasCalculo.DCnomostrar is  1 >
						<cfquery name = "rsmostrarGrupoCargas" datasource="#Session.DSN#">
						 select  1
							from HCargasCalculo a
							
							inner join DCargas b
							on a.DClinea = b.DClinea
							
							inner join ECargas c
							on b.ECid = c.ECid
					
							where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
							  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
							  and b.ECid = #rsCargasCalculo.ECid#						  
							  and CCvaloremp > 0 
							order by c.ECid  														 
						 </cfquery> 
						
						<cfif isdefined('rsmostrarGrupoCargas') and rsmostrarGrupoCargas.recordCount GT 0>			   
							<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
								<td align="left" colspan="6">#DCdescripcion#</td>
								<td align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(CCvalorpat,'none')# </td>
								<td align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(CCvaloremp,'none')# </td>
								<td align="right" >&nbsp;</td>
							</tr>						
						</cfif>
						
					<cfelse>
							<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
								<td align="left" colspan="6">#DCdescripcion#</td>
								<td align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(CCvalorpat,'none')# </td>
								<td align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(CCvaloremp,'none')# </td>
								<td align="right" >&nbsp;</td>
							</tr>	
															
					</cfif>	
				</cfif>		
								
		</cfoutput>
	<cfelse>		
		<tr><td colspan="9" align="center"><b><cf_translate  key="LB_NoHayCargasAsociadasAlEmpleado">No hay Cargas asociadas al Empleado</cf_translate></b></td></tr>
	</cfif>
    <!--- ======================= Cargas - FIN ======================== --->

    <!--- ======================= Deducciones ======================== --->
    <tr valign="top"> 
      <td nowrap colspan="9">&nbsp;</td>
    </tr>

	<cfquery name="rsDeduccionesCalculo" datasource="#Session.DSN#">
		select  a.Did, a.DCvalor, a.DCinteres, a.DCcalculo, b.Ddescripcion, b.Dvalor, b.Dmetodo, a.DCsaldo, b.Dcontrolsaldo, b.Dreferencia
		from HDeduccionesCalculo a
		
		inner join DeduccionesEmpleado b
		on a.Did = b.Did
		
		where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
		  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		order by b.Dreferencia  
	</cfquery>

	<tr><td colspan="9" class="tituloAlterno2"><cf_translate  key="LB_Deducciones">Deducciones</cf_translate></td></tr>

	<cfif rsDeduccionesCalculo.RecordCount gt 0 >
		<tr>
			<td align="left" class="FileLabel" colspan="5"><cf_translate  key="LB_Descripcion">Descripci&oacute;n</cf_translate></td>
			<td align="left" class="FileLabel"><cf_translate  key="LB_Referencia">Referencia</cf_translate></td>
			<td align="right" class="FileLabel"><cf_translate  key="LB_SaldoPosterior">Saldo posterior</cf_translate></td>
			<td align="right" class="FileLabel"><cf_translate  key="LB_Monto">Monto</cf_translate></td>
			<td align="right" class="FileLabel">&nbsp;</td>
		</tr>
	
		<cfoutput query="rsDeduccionesCalculo">
			<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
				<td align="left" colspan="5">#Ddescripcion#</td>
				<td align="left" >#Dreferencia#</td>
				<cfif Dcontrolsaldo EQ 1>
					<td align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(DCsaldo-DCvalor,'none')#</td>
				<cfelse>
					<td align="right" class="FileLabel">&nbsp;</td>
				</cfif>
				<td align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(DCvalor,'none')# 
				<cfif DCcalculo eq 1>
					<td align="right" ><img border="0" src="/cfmx/rh/imagenes/Cferror.gif"></td>
				<cfelse>
					<td align="right" class="FileLabel">&nbsp;</td>
				</cfif> 
			</tr>
		</cfoutput>
	<cfelse>		
		<tr><td colspan="9" align="center"><b><cf_translate  key="LB_NoHayDeduccionesAsociadasAlEmpleado">No hay Deducciones asociadas al Empleado</cf_translate></b></td></tr>
	</cfif>
    <!--- ======================= Deducciones - FIN ======================== --->	
	
    <tr valign="top"><td nowrap colspan="9">&nbsp;</td></tr>
  </table>
  
  <table width="97%">
      <tr>
	  	<td align="center">
	<cfoutput> 
				<cfif not isdefined("url.Archivo")>
				  <tr valign= "top"> 
					<td nowrap colspan="9" align="center">
					
					
					  <input type="submit" name="Regresar" value="#BTN_Regresar#" > 
					</td>
				  </tr>
				</cfif> 
	
				<tr valign="top"> 
					<td nowrap colspan="9" align="center">
						<cfif isDefined("Url.Regresar")>
							<input name="Tcodigo" type="hidden" value="#Url.Tcodigo#">
							<input name="CPcodigo" type="hidden" value="#Url.CPcodigo#">
							<cfif isdefined("Url.chkIncidencias")>
								<input name="chkIncidencias" type="hidden" value="#Url.chkIncidencias#">
							</cfif>
							<cfif isdefined("Url.chkCargas")>
								<input name="chkCargas" type="hidden" value="#Url.chkCargas#">
							</cfif>
							<cfif isdefined("Url.chkDeducciones")>
								<input name="chkDeducciones" type="hidden" value="#Url.chkDeducciones#">
							</cfif>
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							key="BTN_Filtrar"
							default="Filtrar"
							xmlfile="/rh/generales.xml"
							returnvariable="BTN_Filtrar"/>
							<input type="hidden" name="DEid" value="#Form.DEid#">
							<input name="butFiltrar" type="hidden" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
						<cfelse>
							<input type="hidden" name="RCNid" value="#Form.RCNid#">
							<input type="hidden" name="DEid" value="#Form.DEid#">
							<input type="hidden" name="Tcodigo" value="#Form.Tcodigo#">
							<input type="hidden" name="sel" value="1">
						</cfif>
					</td>
				</tr>
	</cfoutput> 
		</td>
	</tr>			
  </table>
</form>
<!--- </cf_sifHTML2Word> --->

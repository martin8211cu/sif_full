<!--- 
	Modificado por: Gustavo Fonseca H.
		Fecha: 25-2-2006.
		Motivo: Se usa el componente de listas, por que la navegación que tenía no funcionaba y la lista estaba pintada 
		a pie.
	Modificado por: Gustavo Fonseca H.
		Fecha: 9-3-2006.
		Motivo: Se agrega el botón de regresar.
	
 --->
<cfif isdefined("url.Periodo")>
	<cfparam name="Form.Periodo" default="#url.Periodo#">
	<cfparam name="Form.PeriodoLista" default="#url.PeriodoLista#">
	<cfparam name="Form.Ccuenta" default="#url.Ccuenta#"> 
	<cfparam name="Form.Oficina" default="#url.Oficina#">
	<cfparam name="Form.Mes" default="#url.Mes#">
	<cfparam name="Form.MesCierre" default="#url.MesCierre#">
</cfif>

<cfquery name="rsCuenta" datasource="#Session.DSN#">
	select Cformato, Cdescripcion ,Cmovimiento
	from CContables 
	where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">
</cfquery>

<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Odescripcion 
	from Oficinas 
	where Ecodigo = #Session.Ecodigo#
	  and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Oficina#">
</cfquery>

<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select '-1' as value, '-- todos --' as description, 0 as ord from dual
	union
	select Mnombre as value, Mnombre as description, 1 as ord
	from Monedas
	where Ecodigo = #Session.Ecodigo#
	order by ord
</cfquery>

<cfquery name="rsCentroFuncional" datasource="#Session.DSN#">
	select -1 as value, '-- todos --' as description, 0 as ord from dual
	union
	select CFid as value, CFdescripcion as description, 1 as ord
	from CFuncional
	where Ecodigo = #Session.Ecodigo#
	order by description
</cfquery>

<cfinvoke key="LB_Poliza" 			default="Póliza" 			returnvariable="LB_Poliza" 				component="sif.Componentes.Translate" method="Translate" xmlfile="formsaldosymov02.xml"/>
<cfinvoke key="LB_Lote" 			default="Lote" 			returnvariable="LB_Lote" 				component="sif.Componentes.Translate" method="Translate" xmlfile="formsaldosymov02.xml"/>
<cfinvoke key="LB_Documento" 			default="Documento" 			returnvariable="LB_Documento" 				component="sif.Componentes.Translate" method="Translate" xmlfile="formsaldosymov02.xml"/>
<cfinvoke key="LB_Descripcion" 			default="Descripción" 			returnvariable="LB_Descripcion" 				component="sif.Componentes.Translate" method="Translate" xmlfile="formsaldosymov02.xml"/>
<cfinvoke key="LB_CentroFuncional" 			default="Centro Funcional" 			returnvariable="LB_CentroFuncional" 				component="sif.Componentes.Translate" method="Translate" xmlfile="formsaldosymov02.xml"/>
<cfinvoke key="LB_Moneda" 			default="Moneda" 			returnvariable="LB_Moneda" 				component="sif.Componentes.Translate" method="Translate" xmlfile="formsaldosymov02.xml"/>
<cfinvoke key="LB_Debitos" 			default="Débitos" 			returnvariable="LB_Debitos" 				component="sif.Componentes.Translate" method="Translate" xmlfile="formsaldosymov02.xml"/>
<cfinvoke key="LB_Creditos" 			default="Créditos" 			returnvariable="LB_Creditos" 				component="sif.Componentes.Translate" method="Translate" xmlfile="formsaldosymov02.xml"/>
<cfinvoke key="CMB_Enero" 			default="Enero" 			returnvariable="CMB_Enero" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Febrero" 		default="Febrero"			returnvariable="CMB_Febrero"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Marzo" 			default="Marzo" 			returnvariable="CMB_Marzo" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Abril" 			default="Abril"				returnvariable="CMB_Abril"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Mayo" 			default="Mayo"				returnvariable="CMB_Mayo"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Junio" 			default="Junio" 			returnvariable="CMB_Junio" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Julio" 			default="Julio"				returnvariable="CMB_Julio"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Agosto" 			default="Agosto" 			returnvariable="CMB_Agosto" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Setiembre"		default="Setiembre"			returnvariable="CMB_Setiembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Octubre" 		default="Octubre"			returnvariable="CMB_Octubre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Noviembre" 		default="Noviembre" 		returnvariable="CMB_Noviembre" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Diciembre" 		default="Diciembre"			returnvariable="CMB_Diciembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfset meses="Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">

<cfset LvarPeriodoConsulta = form.PeriodoLista>
<cfset LvarMesConsulta = Form.Mes>

<cfif form.MesCierre>
	<cfset LvarPeriodoConsulta = LvarPeriodoConsulta>
	<cfset LvarMesConsulta = LvarMesConsulta - 1>
	<cfif LvarMesConsulta LT 1>
		<cfset LvarPeriodoConsulta = LvarPeriodoConsulta - 1>
		<cfset LvarMesConsulta = 12>
	</cfif>
	
	<cfquery name="rsSalMon" datasource="#Session.DSN#">
		  select 
			b.Mcodigo, 
			b.Mnombre, 

			a.SOinicial + a.DOdebitos - a.COcreditos as SOfinal, 
			a.SLinicial + a.DLdebitos - a.CLcreditos as SLfinal, 
			a.SLinicial + a.DLdebitos - a.CLcreditos as SLinicial, 
			a.SOinicial + a.DOdebitos - a.COcreditos as SOinicial, 

			coalesce((
				select sum(det.Dlocal)
				from HDContables det
					inner join HEContables enc
					on enc.IDcontable = det.IDcontable
					and enc.ECtipo    = 1
				where det.Ccuenta     = a.Ccuenta
				  and det.Eperiodo    = a.Speriodo
				  and det.Emes        = a.Smes
				  and det.Ocodigo     = a.Ocodigo
				  and det.Ecodigo     = a.Ecodigo
				  and det.Mcodigo     = a.Mcodigo
				  and det.Dmovimiento = 'D'
				  ), 0.00) as DLdebitos,

			coalesce((
				select sum(det.Dlocal)
				from HDContables det
					inner join HEContables enc
					on enc.IDcontable = det.IDcontable
					and enc.ECtipo    = 1
				where det.Ccuenta     = a.Ccuenta
				  and det.Eperiodo    = a.Speriodo
				  and det.Emes        = a.Smes
				  and det.Ocodigo     = a.Ocodigo
				  and det.Ecodigo     = a.Ecodigo
				  and det.Mcodigo     = a.Mcodigo
				  and det.Dmovimiento = 'C'
				  ), 0.00) as CLcreditos,

			coalesce((
				select sum(det.Doriginal)
				from HDContables det
					inner join HEContables enc
					on enc.IDcontable = det.IDcontable
					and enc.ECtipo    = 1
				where det.Ccuenta     = a.Ccuenta
				  and det.Eperiodo    = a.Speriodo
				  and det.Emes        = a.Smes
				  and det.Ocodigo     = a.Ocodigo
				  and det.Ecodigo     = a.Ecodigo
				  and det.Mcodigo     = a.Mcodigo
				  and det.Dmovimiento = 'D'
				  ), 0.00) as DOdebitos,

			coalesce((
				select sum(det.Doriginal)
				from HDContables det
					inner join HEContables enc
					on enc.IDcontable = det.IDcontable
					and enc.ECtipo    = 1
				where det.Ccuenta     = a.Ccuenta
				  and det.Eperiodo    = a.Speriodo
				  and det.Emes        = a.Smes
				  and det.Ocodigo     = a.Ocodigo
				  and det.Ecodigo     = a.Ecodigo
				  and det.Mcodigo     = a.Mcodigo
				  and det.Dmovimiento = 'C'
				  ), 0.00) as COcreditos
				  
			from SaldosContables a
				inner join Monedas b
				on b.Mcodigo = a.Mcodigo
			where a.Ccuenta  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">
			  and a.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPeriodoConsulta#">
			  and a.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarMesConsulta#">
			  and a.Ecodigo  = #SESSION.Ecodigo#
			  and a.Ocodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Oficina#">
			order by b.Mnombre 
	</cfquery>
	<cfloop query="rsSalMon">
		<cfset querysetcell(rsSalMon, "SOfinal", rsSalMon.SOinicial + rsSalMon.DOdebitos - rsSalMon.COcreditos, rsSalMon.currentrow)>
		<cfset querysetcell(rsSalMon, "SLfinal", rsSalMon.SLinicial + rsSalMon.DLdebitos - rsSalMon.CLcreditos, rsSalMon.currentrow)>
	</cfloop>
<cfelse>
	<cfquery name="rsSalMon" datasource="#Session.DSN#">
		  select 
			b.Mcodigo, 
			b.Mnombre, 
			a.SLinicial, 
			a.DLdebitos, 
			a.CLcreditos, 
			a.SOinicial, 
			a.SLinicial + a.DLdebitos - a.CLcreditos as SLfinal, 
			a.SOinicial + a.DOdebitos - a.COcreditos as SOfinal, 
			a.DOdebitos, 
			a.COcreditos 
			from SaldosContables a
				inner join Monedas b
				on b.Mcodigo = a.Mcodigo
			where a.Ccuenta  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">
			  and a.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPeriodoConsulta#">
			  and a.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarMesConsulta#">
			  and a.Ecodigo    = #SESSION.Ecodigo#
			  and a.Ocodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Oficina#">
			order by b.Mnombre 
	</cfquery>
</cfif>

<cfquery name="rsTot" dbtype="query">
	select sum(SLfinal) as SaldoF, sum(DLdebitos) as Debitos, sum(CLcreditos) as Creditos, sum(SLinicial)  as SaldoI
	from rsSalMon
</cfquery>

<cfquery name="Empresas" datasource="#Session.DSN#">
	select Ecodigo, Edescripcion from Empresas where Ecodigo = #SEssion.Ecodigo#
</cfquery>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset PolizaE = t.Translate('PolizaE','P&oacute;liza')>

<cfflush interval="32">
<form name="form1" method="post"  action="saldosymov02.cfm">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<!--- ******************************************************************************* --->
		<tr class="area"> 
			<td  align="center" colspan="8" nowrap class="tituloAlterno"><cfoutput>#Empresas.Edescripcion#</cfoutput></td>
		</tr>
		<!--- ******************************************************************************* --->
		<tr class="area"> 
			<td align="center" colspan="8" nowrap><strong><cf_translate key=LB_Titulo>Saldos y Movimientos</cf_translate></strong></td>
		</tr>
		<!--- ******************************************************************************* --->
		<tr> 
			<td nowrap><strong><cf_translate key=LB_Cuenta>Cuenta</cf_translate>:</strong></td>
			<td colspan="5" nowrap>
					&nbsp;&nbsp;&nbsp;<cfoutput>#rsCuenta.Cdescripcion#-#rsCuenta.Cformato#</cfoutput> <cfif rsCuenta.Cmovimiento eq 'N'>(<cf_translate key=LB_NivelNoAceptaMov>Este nivel no acepta mov.</cf_translate>)</cfif>
			</td>
			<td colspan="2" align="right"><strong><cf_translate key=LB_Fecha>Fecha</cf_translate>: <font color="#006699"><cfoutput>#LSDateFormat(Now(),'DD/MM/YYYY')#</cfoutput></font></strong></td>
		</tr>
		<!--- ******************************************************************************* --->
		<tr> 
			<td nowrap><strong><cf_translate key=LB_Periodo>Per&iacute;odo</cf_translate>:</strong></td>
			<td colspan="5" nowrap>
					&nbsp;&nbsp;&nbsp;<cfoutput>#LvarPeriodoConsulta#</cfoutput>
			</td>		
			<td colspan="2" align="right" class="noprint">
				<cfif not isdefined("url.impr")>
					<input name="btnRegresar" type="button" value="#BTN_Regresar#" onclick="FuncRegresar();">
				</cfif>
			</td>

		</tr>
		<!--- ******************************************************************************* --->
		<tr>
			<td nowrap><strong><cf_translate key=LB_Mes>Mes</cf_translate>:</strong></td>
			<cfif form.MesCierre>
			<td colspan="7" nowrap>
					&nbsp;&nbsp;&nbsp;<cf_translate key=LB_Cierre>Cierre</cf_translate>
			</td>	
			<cfelse>
			<td colspan="7" nowrap>
					&nbsp;&nbsp;&nbsp;<cfoutput>#ListGetAt(meses, Form.Mes, ',')#</cfoutput>
			</td>	
			</cfif>
		</tr>
		<!--- ******************************************************************************* --->
		<tr>
			<td nowrap><strong><cf_translate key=LB_Oficina>Oficina</cf_translate>:</strong></td>
			<td colspan="7" nowrap>
					&nbsp;&nbsp;&nbsp;<cfoutput>#rsOficinas.Odescripcion#</cfoutput>
			</td>	
		</tr>
		<tr><td colspan="8">&nbsp;</td></tr>
		<tr> 
			<td colspan="3">&nbsp;</td>
			<td nowrap align="right"><strong><cf_translate key=LB_SaldoInicial>Saldo Inicial</cf_translate></strong></td>
			<td nowrap align="right"><strong><cf_translate key=LB_Debitos>D&eacute;bitos</cf_translate></strong></td>
			<td nowrap align="right"><strong><cf_translate key=LB_Creditos>Cr&eacute;ditos</cf_translate></strong></td>
			<td nowrap align="right"><strong><cf_translate key=LB_SaldoFinal>Saldo Final</cf_translate></strong></td>
			<td nowrap align="right"><strong>&nbsp;</strong></td>
		</tr>
		<tr> 
			<cfoutput>
			<td colspan="3" ><strong><strong>Local</strong></font></td>
			<td nowrap align="right">#LSCurrencyFormat(rsTot.SaldoI,'none')#</td>
			<td nowrap align="right">#LSCurrencyFormat(rsTot.Debitos,'none')#</td>
			<td nowrap align="right">#LSCurrencyFormat(rsTot.Creditos,'none')#</td>
			<td nowrap align="right">#LSCurrencyFormat(rsTot.SaldoF,'none')#</td>
			<td nowrap align="right">&nbsp;</td>
			</strong>
            </cfoutput>
		</tr>
		<tr><td colspan="8">&nbsp;</td></tr>
		<tr> 
			<td colspan="8" align="center" nowrap bgcolor="lightgrey" ><font size="3"><strong><cf_translate key=LB_ResumenMoneda>Resumen por Moneda</cf_translate></strong></font></td>
		</tr>
		<!--- ******************************************************************************* --->		
		<tr> 
			<td colspan="3" ><strong><cf_translate key=LB_Moneda>Moneda</cf_translate></strong></td>
			<td nowrap align="right"><strong><cf_translate key=SaldoInicial>Saldo Inicial</cf_translate></strong></td>
			<td nowrap align="right"><strong><cf_translate key=LB_Debitos>D&eacute;bitos</cf_translate></strong></td>
			<td nowrap align="right"><strong><cf_translate key=LB_Creditos>Cr&eacute;ditos</cf_translate></strong></td>
			<td nowrap align="right"><strong><cf_translate key=LB_saldoFinal>Saldo Final</cf_translate></strong></td>
			<td nowrap align="right"><strong>Local</strong></td>
		</tr>
		<!--- ******************************************************************************* --->		
		<cfloop query="rsSalMon"> 
			<tr <cfif rsSalmon.CurrentRow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>> 
				<cfoutput>
				<td colspan="3" >#rsSalmon.Mnombre#</td>
				<td nowrap align="right">#LSCurrencyFormat(rsSalmon.SOinicial,'none')#</td>
				<td nowrap align="right">#LSCurrencyFormat(rsSalmon.DOdebitos,'none')#</td>
				<td nowrap align="right">#LSCurrencyFormat(rsSalmon.COcreditos,'none')#</td>
				<td nowrap align="right">#LSCurrencyFormat(rsSalmon.SOfinal,'none')#</td>
				<td nowrap align="right">#LSCurrencyFormat(rsSalmon.SLfinal,'none')#</td>
				</cfoutput>
			</tr>
		</cfloop> 
		<cfquery name="TotLocal" dbtype="query">
			select sum(SLfinal) as TotalLocal from rsSalMon 
		</cfquery>
		<!--- ******************************************************************************* --->		
		<tr> 
			<td colspan="6" <cfif rsSalmon.CurrentRow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>>&nbsp;</td>
			<td nowrap align="right"><strong>Total:</strong></td>
			<td nowrap align="right"><strong><cfoutput>#LSCurrencyFormat(TotLocal.TotalLocal,'none')#</cfoutput></strong></td>
		</tr>
		<!--- ******************************************************************************* --->		

	</table>
	
	<cfif isdefined("url.filtro_cconcepto")>
		<cfset form.filtro_cconcepto = url.filtro_cconcepto>
	</cfif>
	<cfif isdefined("url.filtro_ddescripcion")>
		<cfset form.filtro_ddescripcion = url.filtro_ddescripcion>
	</cfif>
	<cfif isdefined("url.filtro_ddocumento")>
		<cfset form.filtro_ddocumento = url.filtro_ddocumento>
	</cfif>
	<cfif isdefined("url.filtro_edocumento")>
		<cfset form.filtro_edocumento = url.filtro_edocumento>
	</cfif>
	<cfif isdefined("url.filtro_mnombre")>
		<cfset form.filtro_mnombre = url.filtro_mnombre>
	</cfif>	
	<cfif isdefined("url.filtro_CentroFuncional")>
		<cfset form.filtro_CentroFuncional = url.filtro_CentroFuncional>
	</cfif>
	
	
	<cfset navegacion = ''>
	<cfif isdefined("form.id")>
		<cfset navegacion = navegacion & "&id=#form.id#">
	</cfif>
	<cfif isdefined("form.Ccuenta")>
		<cfset navegacion = navegacion & "&Ccuenta=#form.Ccuenta#">
	</cfif>
	<cfif isdefined("form.mes")>
		<cfset navegacion =  navegacion &"&mes=#form.mes#">
	</cfif>
	<cfif isdefined("form.oficina")>
		<cfset navegacion = navegacion & "&oficina=#form.oficina#">
	</cfif>
	<cfif isdefined("form.periodo")>
		<cfset navegacion = navegacion & "&periodo=#form.periodo#">
	</cfif>
	<cfif isdefined("form.periodoLista")>
		<cfset navegacion = navegacion & "&periodoLista=#form.periodoLista#">
	</cfif>
	<cfif isdefined("form.MesCierre")>
		<cfset navegacion = navegacion & "&MesCierre=#form.MesCierre#">
	</cfif>
	
	<!--- Para sostener los filtroa en la navegación --->
	<cfif isdefined("form.filtro_cconcepto")>
		<cfset navegacion = navegacion & "&filtro_cconcepto=#form.filtro_cconcepto#">
	</cfif>
	<cfif isdefined("form.filtro_ddescripcion")>
		<cfset navegacion = navegacion & "&filtro_ddescripcion=#form.filtro_ddescripcion#">
	</cfif>
	<cfif isdefined("form.filtro_ddocumento")>
		<cfset navegacion = navegacion & "&filtro_ddocumento=#form.filtro_ddocumento#">
	</cfif>
	<cfif isdefined("form.filtro_edocumento")>
		<cfset navegacion = navegacion & "&filtro_edocumento=#form.filtro_edocumento#">
	</cfif>
	<cfif isdefined("form.filtro_mnombre")>
		<cfset navegacion = navegacion & "&filtro_mnombre=#form.filtro_mnombre#">
	</cfif>
	<cfif isdefined("form.filtro_CentroFuncional")>
		<cfset navegacion = navegacion & "&filtro_CentroFuncional=#form.filtro_CentroFuncional#">
	</cfif>	
	
	
	<cfset Filtro =          " a.Ecodigo = #session.Ecodigo#">
	<cfset Filtro = Filtro & " and Ccuenta = #Form.Ccuenta#">
	<cfset Filtro = Filtro & " and a.Ocodigo =  #Form.Oficina#">
	<cfset Filtro = Filtro & " and a.Eperiodo = #LvarPeriodoConsulta#">
	<cfset Filtro = Filtro & " and a.Emes = #LvarMesConsulta#">
	<cfif form.MesCierre>
		<cfset Filtro = Filtro & " and e.ECtipo = 1">
	<cfelse>
		<cfset Filtro = Filtro & " and e.ECtipo <> 1">
	</cfif>
	

	<cfif isdefined("form.filtro_cconcepto") and form.filtro_cconcepto neq "">
		<cfset Filtro = Filtro & " and upper(rtrim(a.Cconcepto)) like '#form.filtro_cconcepto#'">
	</cfif>
	<cfif isdefined("form.filtro_ddescripcion") and form.filtro_ddescripcion neq "">
		<cfset Filtro = Filtro & " and upper(rtrim(a.Ddescripcion)) like '#form.filtro_ddescripcion#%'">
	</cfif>
	<cfif isdefined("form.filtro_ddocumento") and form.filtro_ddocumento neq "">
		<cfset Filtro = Filtro & " and upper(rtrim(a.Ddocumento)) like '#form.filtro_ddocumento#%'">
	</cfif>
	<cfif isdefined("form.filtro_edocumento") and form.filtro_edocumento neq "">
		<cfset Filtro = Filtro & " and upper(rtrim(a.Edocumento)) like '#form.filtro_edocumento#'">
	</cfif>
	<cfif isdefined("form.filtro_mnombre") and form.filtro_mnombre neq "-1">
		<cfset Filtro = Filtro & " and upper(rtrim(m.Mnombre)) = '#form.filtro_mnombre#'">
	</cfif>
	<cfif isdefined("form.filtro_CentroFuncional") and form.filtro_CentroFuncional neq "-1">
		<cfset Filtro = Filtro & " and cf.CFid = #form.filtro_CentroFuncional#">
	</cfif>
	
	
	<cfset Filtro = Filtro & "	group by">
	<cfset Filtro = Filtro & "	a.IDcontable, a.Ccuenta, a.Edocumento, a.Cconcepto, a.Ddocumento, a.Ddescripcion,cf.CFid,cf.CFcodigo, cf.CFdescripcion, m.Mnombre, a.Eperiodo, a.Emes">
	<cfset Filtro = Filtro & "	order by">
	<cfset Filtro = Filtro & "	a.Edocumento, a.Cconcepto">
	
	<cfif not isdefined("url.impr")>
		<cfset Lvarmostrar_filtro = true>
		<cfset Lvarmaxrows = 25>
		<cfset LvarshowLink = true>
		<cfset LvarPoliza = 'Poliza'>
	<cfelse>
		<cfset Lvarmostrar_filtro = false>
		<cfset Lvarmaxrows = 0>
		<cfset LvarshowLink = false>
		<cfset LvarPoliza = ''>
	</cfif>
	<cfflush interval="1024">

	<cfif isdefined("url.filtro_cconcepto")>
		<cfset form.filtro_cconcepto = url.filtro_cconcepto>
	</cfif>
	<cfif isdefined("url.filtro_ddescripcion")>
		<cfset form.filtro_ddescripcion = url.filtro_ddescripcion>
	</cfif>
	<cfif isdefined("url.filtro_ddocumento")>
		<cfset form.filtro_ddocumento = url.filtro_ddocumento>
	</cfif>
	<cfif isdefined("url.filtro_edocumento")>
		<cfset form.filtro_edocumento = url.filtro_edocumento>
	</cfif>
	<cfif isdefined("url.filtro_mnombre")>
		<cfset form.filtro_mnombre = url.filtro_mnombre>
	</cfif>
	<cfif isdefined("url.filtro_CentroFuncional")>
		<cfset form.filtro_CentroFuncional = url.filtro_CentroFuncional>
	</cfif>
	
	<cf_dbfunction name="OP_CONCAT" returnvariable="_CAT">
	<cfquery name="rsQrySaldMov" datasource="#Session.DSN#">
		Select 	a.IDcontable as id, 
				a.Ccuenta as Cuenta, 
				a.Edocumento, 
				a.Cconcepto, 
				a.Ddocumento, 
				a.Ddescripcion, 
				m.Mnombre, 
				sum(case when a.Dmovimiento='D' then a.Dlocal else 0.00 end) as Debitos, 
				sum(case when a.Dmovimiento='C' then a.Dlocal else 0.00 end) as Creditos, 
				a.Eperiodo, 
				a.Emes, 
				' ' as truco,
				case when cf.CFid is not null then
					rtrim(cf.CFcodigo) #_CAT# '-' #_CAT# rtrim(cf.CFdescripcion)
				else
					''
				end
				as CentroFuncional
		from HDContables a 
				inner join Monedas m 
					on m.Mcodigo = a.Mcodigo 
				inner join HEContables e 
					on e.IDcontable = a.IDcontable
				left outer join CFuncional  cf
						on cf.CFid = a.CFid
		where #preservesinglequotes(Filtro)#
	</cfquery>

	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
		<cfinvokeargument name="query" value="#rsQrySaldMov#"/>
		<cfinvokeargument name="desplegar" value="Edocumento, Cconcepto, Ddocumento, Ddescripcion, Mnombre, CentroFuncional, Debitos, Creditos, truco"/>
		<cfinvokeargument name="etiquetas" value="Póliza, Lote, Documento, Descripción, Moneda, Centro Funcional, Débitos, Créditos, &nbsp;"/>
		<cfinvokeargument name="formatos" value="S, S, S, S, S, S, UM, UM, U"/>
		<cfinvokeargument name="align" value="left, left, left, left, left, left, right, right, left"/>
		<cfinvokeargument name="checkboxes" value="N"/>
		<cfinvokeargument name="keys" value="id"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="showLink" value="false"/>
		<cfinvokeargument name="MaxRows" value="#Lvarmaxrows#"/>
		<cfinvokeargument name="maxrowsquery" value="3000"/>
		<cfinvokeargument name="incluyeForm" value="false"/>
		<cfinvokeargument name="formName" value="form1"/>
		<cfinvokeargument name="mostrar_filtro" value="#Lvarmostrar_filtro#"/>
		<cfinvokeargument name="rsMnombre" value="#rsMonedas#"/>
		<cfinvokeargument name="rsCentroFuncional" value="#rsCentroFuncional#"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		<cfinvokeargument name="funcion" value="#LvarPoliza#"/>
		<cfinvokeargument name="fparams" value="id,Eperiodo,Emes,Cuenta"/>
		<cfinvokeargument name="debug" value="N"/>
	</cfinvoke>	
	<cfoutput>
        <input type="hidden" name="Periodo" value="#Form.Periodo#">
        <input type="hidden" name="PeriodoLista" value="#Form.PeriodoLista#">
        <input type="hidden" name="MesCierre" value="#Form.MesCierre#">
        <input type="hidden" name="Oficina" value="#Form.Oficina#">
        <input type="hidden" name="Mes" value="#Form.Mes#">
        <input type="hidden" name="Ccuenta" value="#Form.Ccuenta#">
        <input type="hidden" name="Direccion" value="">
        <input type="hidden" name="IDcontable" value="">
        <input name="Mcodigo" value="<cfif isdefined("form.Mcodigo")>#form.Mcodigo#</cfif>" type="hidden">
        <input name="McodigoOpt" value="<cfif isdefined("form.McodigoOpt")>#form.McodigoOpt#</cfif>" type="hidden">
	</cfoutput>
</form>

<script language="javascript" type="text/javascript">
	function Poliza(xidcontable, periodo, mes, cuenta){
		<cfoutput>
			document.form1.IDcontable.value=xidcontable;
			document.form1.Mes.value=mes;
			document.form1.Ccuenta.value=cuenta;
			document.form1.action = "SQLPolizaConta.cfm?Saldoymov='s'&Periodo=#Form.Periodo#&PeriodoLista=#Form.PeriodoLista#&Oficina=#Form.Oficina#&Mes=#Form.Mes#&Cuenta=#Form.Ccuenta#";
			document.form1.submit();
		</cfoutput>
	}
	function buscar(){
		document.form1.Direccion.value = '';
		document.form1.Pagina.value =  '1';
		document.form1.submit();
	}		
	function FuncRegresar(){
		<cfoutput>
			document.form1.Oficina.value = ' ';
			document.form1.Mes.value =' ';
			document.form1.action = 'saldosymov01.cfm?Ccuenta=#form.Ccuenta#&Periodos=#form.periodo#';
			document.form1.submit();
		</cfoutput>
	}
	function nextREG(){
		document.form1.Direccion.value = 'next';
		var pagina = new Number(document.form1.Pagina.value) + 1;
		document.form1.Pagina.value =  pagina;
		document.form1.submit();
	}
	function backREG(){
		history.back();
		<!---
		document.form1.Direccion.value = 'back';
		var pagina = new Number(document.form1.Pagina.value) - 1;
		document.form1.Pagina.value =  pagina ;
		document.form1.submit();--->
	}	
</script>	

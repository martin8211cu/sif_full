<cfif not isdefined("form.LISTANOMINA") or not len(trim(form.LISTANOMINA))>
	<br>
	<br>
	<cf_translate  key="LB_NoSeGeneroUnReporteSegunLosFiltrosDados">No se generó un reporte según los filtros dados. Intente de nuevo!</cf_translate>
	<br>
	<br>
    <cfabort>
</cfif>
<cf_dbfunction name="op_concat" returnvariable="concat">
<cf_translatedata name="get" tabla="CFuncional" col="CF.CFdescripcion" returnvariable="LvarCFdescripcion">  

<STYLE>
	H1.SaltoDePagina
	{
		PAGE-BREAK-AFTER: always
	}
</STYLE>

<cfset pre=''>
<cfset nomina=form.LISTANOMINA>
<cfif isDefined("chk_NominaAplicada")>
	 <cfset pre='H'>
</cfif> 

<!----- realiza el filtro a las nominas seleccionadas---->
<cf_dbfunction name="today" returnvariable="hoy">

 <cf_dbtemp name="ReporteFirmasAdelantoSQL" returnvariable="LvarSalarios" datasource="#session.dsn#">
	<cf_dbtempcol name="DEid" type="numeric">
	<cf_dbtempcol name="bruto" type="money">
</cf_dbtemp>

<cfquery datasource="#session.dsn#">
	insert into #LvarSalarios# (DEid, bruto)
	select lt.DEid, (dlt.DLTmonto * (lt.LTporcsal/100)) as DLTmonto
	from LineaTiempo lt
		inner join CalendarioPagos cp2
			on lt.Tcodigo=cp2.Tcodigo
			and lt.Ecodigo=cp2.Ecodigo
			and lt.LTdesde <= cp2.CPhasta
            and lt.LThasta >= cp2.CPdesde
			and lt.LTdesde = (select max(l1.LTdesde)
								from LineaTiempo l1
								where lt.DEid=l1.DEid
									and l1.LTdesde <= cp2.CPhasta
									and l1.LThasta >= cp2.CPdesde
							  ) 
		inner join DLineaTiempo dlt
			on lt.LTid=dlt.LTid
		inner join ComponentesSalariales cs
			on dlt.CSid=cs.CSid
			and cs.CSsalariobase=1
		inner join RHTipoAccion rh
			on lt.RHTid = rh.RHTid	
			<!---and rh.RHTpaga=1--->
	where cp2.CPid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#nomina#" list="yes">)		
</cfquery>

<cfif pre EQ  'H'>
	<cfquery name="rsReporte" datasource="#session.dsn#">
		SELECT  coalesce(sum(salario.bruto) ,0) as salariobruto,
				coalesce(sum(case when de.DEporcAnticipo <>40  then salario.bruto else 0 end),0) as salariodistinto40,
				coalesce(sum(case when de.DEporcAnticipo = 40 then salario.bruto else 0 end),0) as salarioigual40,
				coalesce(sum(case when de.DEporcAnticipo = 40 then dr.#pre#DRNliquido else 0 end),0) as adelanto40,
				coalesce(sum(case when de.DEporcAnticipo <> 40 then dr.#pre#DRNliquido else 0 end),0) as adelantodistinto40,
				coalesce(sum(case when dr.Bid is not null and dr.#pre#DRNcuenta is not null and dr.CBTcodigo = 0 then dr.#pre#DRNliquido  else 0 end),0) as depositocuentacorriente,
				<!---coalesce(sum(case when de.Bid is not null and de.DEcuenta is not null and de.CBTcodigo = 1 and dr.#pre#DRNcuenta is not null then dr.#pre#DRNliquido else 0 end),0) as depositocuentaahorro,--->
				coalesce(sum(case when dr.Bid is not null and dr.CBTcodigo = 1 then dr.#pre#DRNliquido else 0 end),0) as depositocuentaahorro,
				<!---coalesce(sum(case when dr.#pre#DRNcuenta is null then dr.#pre#DRNliquido else 0 end),0) as totalCheque,--->
				coalesce(sum(case when dr.Bid is null  then dr.#pre#DRNliquido else 0 end),0) as totalCheque,
	
				<!----- hoja 2------------->
				coalesce(max(cn.RCtc),1) as tipocambio,
				coalesce(sum(dr.#pre#DRNliquido),0) as adelantosalario,
				<!---coalesce(sum(case when dr.#pre#DRNcuenta is null then dr.#pre#DRNliquido else 0 end),0) as pagoencheque,--->
				coalesce(sum(case when dr.Bid is null then dr.#pre#DRNliquido else 0 end),0) as pagoencheque,
				
				<!------ hoja 3------------>
				coalesce(sum(case when de.DEporcAnticipo <> 0 then salario.bruto else 0 end),0) as sueldos,
				coalesce(sum(dr.#pre#DRNliquido),0) as adelantos,
				coalesce(count(1),0) as numeroempleados,
				coalesce((sum(case when salario.bruto > 0 then 1 else 0 end)),0) as numeroempleadosconsalario,
				coalesce(sum(case when coalesce(de.DEporcAnticipo,0) <> 0 then 1 else 0 end),0) as numeroempleadoconadelanto, 
				coalesce(max(cp.CPfpago),#hoy#) as fechapago,
				coalesce(max(cp.CPmes),#month(now())#) as mes,
				coalesce(max(cp.CPperiodo),#year(now())#) as periodo
		
		FROM #LvarSalarios# salario
			inner join DatosEmpleado de
				on salario.DEid=de.DEid
			left join #pre#DRNomina dr
					inner join #pre#ERNomina er
						inner join CalendarioPagos cp
							inner join #pre#RCalculoNomina cn
						on cp.CPid = cn.RCNid
					on er.RCNid = cp.CPid
					and er.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#nomina#" list="yes">)
				on  er.ERNid = dr.ERNid
			on  dr.DEid=de.DEid			
	</cfquery>
<cfelse>
 	<cfquery name="rsReporte" datasource="#session.dsn#">
		SELECT  coalesce(sum(salario.bruto) ,0) as salariobruto,
				coalesce(sum(case when de.DEporcAnticipo <>40  then salario.bruto else 0 end),0) as salariodistinto40,
				coalesce(sum(case when de.DEporcAnticipo = 40 then salario.bruto else 0 end),0) as salarioigual40,
				coalesce(sum(case when de.DEporcAnticipo = 40 then se.SEliquido else 0 end),0) as adelanto40,
				coalesce(sum(case when de.DEporcAnticipo <> 40 then se.SEliquido else 0 end),0) as adelantodistinto40,
				coalesce(sum(case when de.Bid is not null and de.DEcuenta is not null and de.CBTcodigo = 0 then se.SEliquido  else 0 end),0) as depositocuentacorriente,
				coalesce(sum(case when de.Bid is not null and de.CBTcodigo = 1 then se.SEliquido else 0 end),0) as depositocuentaahorro,
				coalesce(sum(case when de.Bid is null  then se.SEliquido else 0 end),0) as totalCheque,
	
				<!----- hoja 2------------->
				coalesce(max(cn.RCtc),1) as tipocambio,
				coalesce(sum(se.SEliquido),0) as adelantosalario,
				coalesce(sum(case when de.Bid is null  then se.SEliquido else 0 end),0) as pagoencheque,
				
				<!------ hoja 3------------>
				coalesce(sum(case when de.DEporcAnticipo <> 0 then salario.bruto else 0 end),0) as sueldos,
				coalesce(sum(se.SEliquido),0) as adelantos,
				coalesce(count(1),0) as numeroempleados,
				coalesce((sum(case when salario.bruto > 0 then 1 else 0 end)),0) as numeroempleadosconsalario,
				coalesce(sum(case when coalesce(de.DEporcAnticipo,0) <> 0 then 1 else 0 end),0) as numeroempleadoconadelanto, 
				coalesce(max(cp.CPfpago),#hoy#) as fechapago,
				coalesce(max(cp.CPmes),#month(now())#) as mes,
				coalesce(max(cp.CPperiodo),#year(now())#) as periodo
		
		FROM #LvarSalarios# salario
			inner join DatosEmpleado de
				on salario.DEid=de.DEid
			left join #pre#SalarioEmpleado se
				inner join CalendarioPagos cp
						inner join #pre#RCalculoNomina cn
					on cp.CPid = cn.RCNid
				on se.RCNid = cp.CPid
			on  se.DEid=de.DEid	
			and se.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#nomina#" list="yes">)			
	</cfquery>
</cfif>

<cfif rsReporte.recordcount EQ 0>
	<br>
	<br>
	<cf_translate  key="LB_NoSeGeneroUnReporteSegunLosFiltrosDados">No se generó un reporte según los filtros dados. Intente de nuevo!</cf_translate>
	<br>
	<br>
	<cfabort>
<cfelseif rsReporte.recordcount NEQ 0>
	<cfif isDefined("form.Exportar")>
		<cfdocument format="PDF"> 
			<cfdocumentsection>
				<cfset getHTML1()>
			</cfdocumentsection>
			<cfdocumentsection>
				<cfset getHTML2()>
			</cfdocumentsection>
			<cfdocumentsection>
				<cfset getHTML3()>
			</cfdocumentsection>
		</cfdocument>		
	<cfelse>
		<cfset LvarFileName = "ReporteFirmasAdelanto_#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
		<cf_htmlReportsHeaders filename="#LvarFileName#" irA="ReporteFirmasAdelanto.cfm">
		<cfset getHTML1()>
		<cfset getHTML2()>
		<cfset getHTML3()>
	</cfif>
</cfif><!---- fin de si tiene datos---->


<cffunction name="getHTML1">
		
	<cfset t = createObject("component","sif.Componentes.Translate")> 
	<cfset LB_Cuenta= t.translate('LB_Cuenta','Cuenta','/rh/generales.xml')/> 
	<cfset LB_ReporteParaElPagoDelAdelantoSalarial = t.translate('LB_ReporteParaElPagoDelAdelantoSalarial','Reporte Para El Pago del Adelanto Salarial')>
	<cfset LB_TotalSalarios = t.translate('LB_TotalSalarios','Total salarios')>
	<cfset LB_Menos = t.translate('LB_Menos','Menos')>
	<cfset LB_SalarioConAdelantoDistintoAl = t.translate('LB_SalarioConAdelantoDistintoAl','Salario con adelanto distinto al')>
	<cfset LB_TotalDeSalariosAplicablesAl = t.translate('LB_TotalDeSalariosAplicablesAl','Total de salarios aplicables al')>
	<cfset LB_CalculoDelAdelantoSalarial = t.translate('LB_CalculoDelAdelantoSalarial','Cáculo del adelanto salarial')>
	<cfset LB_AdelantoDel = t.translate('LB_AdelantoDel','Adelanto del')>
	<cfset LB_AdelantoDistintoAl = t.translate('LB_AdelantoDistintoAl','Adelanto distinto al')>
	<cfset LB_TotalAdelanto = t.translate('LB_TotalAdelanto','Total adelanto')>
	<cfset LB_DesembolsoDeTransferencia = t.translate('LB_DesembolsoDeTransferencia','Desembolso de transferencia')>
	<cfset LB_DepositosCuentaCorriente = t.translate('LB_DepositosCuentaCorriente','Depósitos cuenta corriente')>
	<cfset LB_DepositosCuentaAhorro = t.translate('LB_DepositosCuentaAhorro','Depositos cuenta ahorro')>
	<cfset LB_TotalDeposito = t.translate('LB_TotalDeposito','Total de depósito')>
	<cfset LB_PagoCheque = t.translate('LB_PagoCheque','Pago por cheque')>
	<cfset LB_ElaboradoPor = t.translate('LB_ElaboradoPor','Elaborado por')>
	<cfset LB_DireccionDeFinanzas = t.translate('LB_DireccionDeFinanzas','Dirección de Finanzas')>
	<cfset LB_FinanzasRepresentante = t.translate('LB_FinanzasRepresentante','Finanzas / Representante')>
	<cfset LB_AprobadoPor = t.translate('LB_AprobadoPor','Aprobado por')>
	<cfset LB_RevisadoPor = t.translate('LB_RevisadoPor','Revisado por')>
	<cfset LB_Tesoreria = t.translate('LB_Tesoreria','Tesorería')>
	<cfset LB_CoordinadorUnidadDeOperaciones = t.translate('LB_CoordinadorUnidadDeOperaciones','Coordinador Unidad de Operaciones')>
	<cfset LB_CoordinadorUnidadDeTesoreria= t.translate('LB_CoordinadorUnidadDeTesoreria','Coordinador Unidad de Tesorería')>
	<cfset LB_TipoDeCambio= t.translate('LB_TipoDeCambio','Tipo de cambio','/rh/generales.xml')>
	<cfset LB_AdelantoDeSalario= t.translate('LB_AdelantoDeSalario','Adelanto de salario')>
	<cfset LB_DepositoEnCuentaCorriente= t.translate('LB_DepositoEnCuentaCorriente','Deposito en cuenta corriente')>
	<cfset LB_DepositoEnCuentaAhorro= t.translate('LB_DepositoEnCuentaAhorro','Deposito en cuenta ahorro')>
	<cfset LB_PagoEnCheque= t.translate('LB_PagoEnCheque','Pago en cheque')>
	<cfset LB_Concepto= t.translate('LB_Concepto','Concepto')>
	<cfset LB_Totales= t.translate('LB_Totales','Totales')>
	<cfset LB_Sueldos= t.translate('LB_Sueldos','Sueldos')>
	<cfset LB_Adelantos= t.translate('LB_Adelantos','Adelantos')>
	<cfset LB_NumeroRegistros= t.translate('LB_NumeroRegistros','Número de registros')>
	<cfset LB_NO_Empleados= t.translate('LB_NO_Empleados','No. Empleados')>
	<cfset LB_NO_EmpleadosConAdelanto= t.translate('LB_NO_EmpleadosConAdelanto','No. Empleados con adelanto')>
	<cfset LB_NO_EmpleadosConSalario= t.translate('LB_NO_EmpleadosConSalario','No. Empleados con salario')>
    <cfset LB_IICA= t.translate('LB_IICA','Instituto Interamericano de Cooperación para la Agricultura')>
	<cfset LB_Diferencia= t.translate('LB_Diferencia','Diferencia')>
	<cfset LB_TotalPagar= t.translate('LB_TotalPagar','Total a Pagar')>
	

	<cfquery datasource="sifcontrol" name="rsMeses">
		select VSdesc from VSidioma where VSgrupo=1 and Iid =(select Iid from Idiomas where Icodigo='#session.Idioma#') order by <cf_dbfunction name="to_number" args="VSvalor">
	</cfquery>
	<cfset meses=arraynew(1)>
	<cfloop query="rsMeses">
		<cfset arrayAppend(meses, VSdesc)>
	</cfloop>
     
     <cfquery name="rsEmpresas" datasource="#session.DSN#">
     	select Edescripcion from Empresas 
        where
        	<cfif isdefined("form.JTREELISTAITEM") and len(trim(form.JTREELISTAITEM))> 
        	Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JTREELISTAITEM#" list="yes">)
            <cfelse>
            Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            </cfif>
     </cfquery>
	
	<cf_templatecss/>
 
	 	<cfoutput> 
		<!----------------------    HOJA 1  -----------------------------> 
		<cf_HeadReport
        Titulo="#LB_ReporteParaElPagoDelAdelantoSalarial#"
        addTitulo1="#LB_IICA#"
        filtro1="Empresas: #valueList(rsEmpresas.Edescripcion)#"	
        filtro2="#meses[rsReporte.mes]# #rsReporte.periodo#"	
        Color="##E3EDEF"
        showline="false"
		showEmpresa="false">
       <br /><br />
        <table>
			<!---<tr>
				<td colspan="4" align="center"><b><cf_translate key="LB_IICA" xmlFile="/rh/generales.xml">Instituto Interamericano de Cooperación para la Agricultura</cf_translate></b></td>
			</tr>
			<tr>
				<td colspan="4" align="center"><b>#LB_ReporteParaElPagoDelAdelantoSalarial# <cf_locale name="date" value="#rsReporte.fechapago#"/></b></td>
			</tr>
			<tr>
				<td colspan="4" align="center"><b>#meses[rsReporte.mes]# #rsReporte.periodo#</b></td>
			</tr>--->

		  <tr>
		  	<td nowrap="nowrap"  align="left">#LB_TotalSalarios#</td>
		  	<td colspan="2" align="center">___________</td>
		    <td align="right"><cf_locale name="number" value ="#rsReporte.salariobruto#"/></td>
	      </tr>
		  <tr>
            <td colspan="4">&nbsp;</td>
          </tr>
          <tr>
		  	<td nowrap="nowrap"  align="left"  colspan="4">#LB_Menos#:</td>
	      </tr>
		  <tr>
		  	<td nowrap="nowrap"  align="left">#LB_SalarioConAdelantoDistintoAl# 40%</td>
		  	<td colspan="2" align="center">___________</td>
		    <td align="right"><cf_locale name="number" value ="#rsReporte.salariodistinto40#"/></td>
	      </tr>
		  <tr>
		  	<td nowrap="nowrap"  align="left">#LB_TotalDeSalariosAplicablesAl# 40%</td>
		  	<td colspan="2" align="center">___________</td>
		    <td align="right"><cf_locale name="number" value ="#rsReporte.salarioigual40#"/></td>
	      </tr>
		  <tr>
            <td colspan="4">&nbsp;</td>
          </tr>
          <tr>
		  	<td nowrap="nowrap"  align="left"  colspan="4">#LB_CalculoDelAdelantoSalarial#:</td>
	      </tr>
		  <tr>
		  	<td nowrap="nowrap"  align="left">#LB_AdelantoDel# 40%</td>
		  	<td colspan="2" align="center">___________</td>
		    <td align="right"><cf_locale name="number" value ="#rsReporte.adelanto40#"/></td>
	      </tr>
		  <tr>
		  	<td nowrap="nowrap"  align="left">#LB_AdelantoDistintoAl# 40%</td>
		  	<td colspan="2" align="center">___________</td>
		    <td align="right"><cf_locale name="number" value ="#rsReporte.adelantodistinto40#"/></td>
	      </tr>
		  <tr>
		  	<td nowrap="nowrap"  align="left">#LB_TotalAdelanto#</td>
		  	<td colspan="2" align="center">___________</td>
		    <td align="right"><cf_locale name="number" value ="#rsReporte.adelanto40+rsReporte.adelantodistinto40#"/></td>
	      </tr>
          <tr>
            <td colspan="4">&nbsp;</td>
          </tr>
		  <tr>
		  	<td nowrap="nowrap"  align="left"  colspan="4">#LB_DesembolsoDeTransferencia#:</td>
	      </tr>
		  <tr>
		  	<td nowrap="nowrap"  align="left">#LB_DepositosCuentaCorriente#</td>
		  	<td colspan="2" align="center">___________</td>
		    <td align="right"><cf_locale name="number" value ="#rsReporte.depositocuentacorriente#"/></td>
	      </tr>
		  <tr>
		  	<td nowrap="nowrap"  align="left">#LB_DepositosCuentaAhorro#</td>
		  	<td colspan="2" align="center">___________</td>
		    <td align="right"><cf_locale name="number" value ="#rsReporte.depositocuentaahorro#"/></td>
	      </tr>
		  <tr>
		  	<td nowrap="nowrap"  align="left">#LB_TotalDeposito#</td>
		  	<td colspan="2" align="center">___________</td>
		    <td align="right"><cf_locale name="number" value ="#rsReporte.depositocuentacorriente+rsReporte.depositocuentaahorro#"/></td>
	      </tr>
		  <tr>
            <td colspan="4">&nbsp;</td>
          </tr>
		  <tr>
		  	<td nowrap="nowrap"  align="left">#LB_PagoCheque#</td>
		  	<td colspan="2" align="center">___________</td>
		    <td align="right"><cf_locale name="number" value ="#rsReporte.totalCheque#"/></td>
	      </tr>
		   <tr>
            <td colspan="4">&nbsp;</td>
          </tr>
          <tr>
		  	<td nowrap="nowrap"  align="left">#LB_TotalPagar#</td>
		  	<td colspan="2" align="center">___________</td>
		    <td align="right"><cf_locale name="number" value ="#rsReporte.totalCheque + rsReporte.depositocuentaahorro + rsReporte.depositocuentacorriente#"/></td>
	      </tr>
		  <tr>
            <td colspan="4">&nbsp;</td>
          </tr>
          <tr>
		  	<td nowrap="nowrap"  align="left">#LB_Diferencia#</td>
		  	<td colspan="2" align="center">___________</td>
		    <td align="right"><cf_locale name="number" value ="#(rsReporte.adelanto40+rsReporte.adelantodistinto40) - (rsReporte.totalCheque + rsReporte.depositocuentaahorro + rsReporte.depositocuentacorriente)#"/></td>
	      </tr>
          
	     </table>

	     <table>
		      <!--------- firmas---------->
			  <tr>
			  	<td colspan="4">&nbsp;</td>
		      </tr>
			  <tr>
			  	<td colspan="4">&nbsp;</td>
		      </tr>
			  <tr>
			  	<td colspan="4">&nbsp;</td>
		      </tr>
			  <tr>
			  	<td colspan="4">&nbsp;</td>
		      </tr>
              <tr>
			  	<td colspan="4">&nbsp;</td>
		      </tr>
			  <tr>
			  	<td align="right" nowrap="nowrap"><cf_translate key="LB_Elaboradopor">#LB_ElaboradoPor#</cf_translate>:</td>
			  	<td>_______________________________</td>
			    <td align="right" nowrap="nowrap">#LB_AprobadoPor#: </td>
			    <td>_______________________________</td>
		      </tr>
			  <tr>
			  	<td align="right">&nbsp;</td>
			  	<td>&nbsp;</td>
			    <td align="right">&nbsp;</td>
			    <td align="center"><cf_translate key="LB_DireccionDeFinanzas">#LB_FinanzasRepresentante#</cf_translate></td>
		      </tr>
			  <tr>
			  	<td colspan="4">&nbsp;</td>
		      </tr>
		      <tr>
			  	<td colspan="4">&nbsp;</td>
		      </tr><tr>
			  	<td colspan="4">&nbsp;</td>
		      </tr>
			  <tr>
			  	<td colspan="4">&nbsp;</td>
		      </tr>
              <tr>
			  	<td colspan="4">&nbsp;</td>
		      </tr>
			  <tr>
			  	<td align="right" nowrap="nowrap"><cf_translate key="LB_Revisadopor">#LB_RevisadoPor#</cf_translate>:</td>
			  	<td>_______________________________</td>
			    <td align="right" nowrap="nowrap"><cf_translate key="LB_Tesoreria">#LB_Tesoreria#</cf_translate>: </td>
			    <td>_______________________________</td>
		      </tr> 
			  <tr>
			  	<td></td>
			  	<td><!---#LB_CoordinadorUnidadDeOperaciones#---></td>
			    <td></td>
			    <td><!---#LB_CoordinadorUnidadDeTesoreria#---></td>
		      </tr>
              <tr>
			  	<td colspan="4">&nbsp;</td>
		      </tr>
			  <tr>
			  	<td colspan="4">&nbsp;</td>
		      </tr> 
              <tr>
			  	<td colspan="4">&nbsp;</td>
		      </tr>
			  <tr>
			  	<td colspan="4">&nbsp;</td>
		      </tr>
		 </table>
	 </cfoutput>
</cffunction>
<cffunction name="getHTML2">	 
	<cfoutput>
		<H1 class=SaltoDePagina> </H1>	
	  	<!----------------------    HOJA 2  -----------------------------> 
	   <cf_HeadReport
        Titulo="#LB_ReporteParaElPagoDelAdelantoSalarial#"
        addTitulo1="#LB_IICA#"
        filtro1="Empresas: #valueList(rsEmpresas.Edescripcion)#"	
        filtro2="#meses[rsReporte.mes]# #rsReporte.periodo#"	
        Color="##E3EDEF"
        showline="false"
		showEmpresa="false">
		
        <br><br>
        <table>
		
		  <tr>
		  	<td nowrap="nowrap"  align="left">#LB_TipoDeCambio#</td>
		  	<td align="center"><cf_locale name="number" value ="#rsReporte.tipocambio#"/></td>
		    <td align="right" colspan="2"></td>
	      </tr>
		  <tr>
		  	<td align="center" colspan="2"></td>
		    <td align="right">Colones</td>
		    <td align="right">USD Dollars</td>
	      </tr>
		  <tr>
		  	<td nowrap="nowrap"  align="left">#LB_AdelantoDeSalario#</td>
		  	<td align="center"></td>
		  	<td align="right"><cf_locale name="number" value ="#rsReporte.adelantosalario#"/></td>
		    <td align="right"><cf_locale name="number" value ="#rsReporte.adelantosalario/rsReporte.tipocambio#"/></td>
	      </tr>
           <tr>
            <td colspan="4">&nbsp;</td>
          </tr>
           <tr>
            <td colspan="4">&nbsp;</td>
          </tr>
	      <cfset total=0>
		  <tr>
		  	<td nowrap="nowrap"  align="left">#LB_DepositoEnCuentaCorriente#</td>
		  	<td align="center"></td>
		    <td align="right"><cf_locale name="number" value ="#rsReporte.depositocuentacorriente#"/></td><cfset total+=rsReporte.depositocuentacorriente>
		    <td align="right"><cf_locale name="number" value ="#rsReporte.depositocuentacorriente/rsReporte.tipocambio#"/></td>
	      </tr>
		  <tr>
		  	<td nowrap="nowrap"  align="left">#LB_DepositoEnCuentaAhorro#</td>
		  	<td align="center"></td>
		    <td align="right"><cf_locale name="number" value ="#rsReporte.depositocuentaahorro#"/></td><cfset total+=rsReporte.depositocuentaahorro>
		    <td align="right"><cf_locale name="number" value ="#rsReporte.depositocuentaahorro/rsReporte.tipocambio#"/></td>
	      </tr>
		  <tr>
		  	<td nowrap="nowrap"  align="left">#LB_PagoEnCheque#</td>
		  	<td align="center"></td>
		    <td align="right"><cf_locale name="number" value ="#rsReporte.pagoencheque#"/></td><cfset total+=rsReporte.pagoencheque>
		    <td align="right"><cf_locale name="number" value ="#rsReporte.pagoencheque/rsReporte.tipocambio#"/></td>
	      </tr>
		  <tr>
		  	<td align="center" colspan="2"></td>
		  	<td align="center">___________</td>
		  	<td align="center">___________</td>
	      </tr>
		  <tr>
		  	<td nowrap="nowrap"  align="left">Total</td>
		  	<td align="center"></td>
		    <td align="right"><cf_locale name="number" value ="#total#"/></td>
		    <td align="right"><cf_locale name="number" value ="#total/rsReporte.tipocambio#"/></td>
	      </tr>
	     </table>
	    </cfoutput> 
</cffunction>
<cffunction name="getHTML3">	
	<cfoutput>
		<br><br><br><br>
		<br><br><br><br>
		
        <table>
		
		  <tr>
		  	<td nowrap="nowrap"  align="left">#LB_Concepto#</td>
		  	<td colspan="2" align="center"></td>
		    <td nowrap="nowrap"  align="left">#LB_Totales#</td>
	      </tr>
		  <tr>
		  	<td nowrap="nowrap"  align="left">#LB_Sueldos#</td>
		  	<td colspan="2" align="center"></td>
		    <td align="right"><cf_locale name="number" value ="#rsReporte.salariobruto#"/></td>
	      </tr>
		  <tr>
		  	<td nowrap="nowrap"  align="left">#LB_Adelantos#</td>
		  	<td colspan="2" align="center"></td>
		    <td align="right"><cf_locale name="number" value ="#rsReporte.adelantos#"/></td>
	      </tr>
		<tr>
			<td colspan="4" align="center"><b>#LB_NumeroRegistros#</b></td>
		</tr>
		<tr>
			<td colspan="4" align="center">&nbsp;</td>
		</tr>
		<tr>
			<td nowrap="nowrap"  align="left">#LB_NO_Empleados#</td>
			<td colspan="2" align="center"></td>
		<td align="right"><cf_locale name="number" value ="#rsReporte.numeroempleados#"/></td>
		</tr>
		<tr>
			<td nowrap="nowrap"  align="left">#LB_NO_EmpleadosConSalario#</td>
			<td colspan="2" align="center"></td>
		<td align="right"><cf_locale name="number" value ="#rsReporte.numeroempleadosconsalario#"/></td>
		</tr>
		<tr>
			<td nowrap="nowrap"  align="left">#LB_NO_EmpleadosConAdelanto#</td>
			<td colspan="2" align="center"></td>
		<td align="right"><cf_locale name="number" value ="#rsReporte.numeroempleadoconadelanto#"/></td>
		</tr>
		<tr>
			<td colspan="4" align="center">&nbsp;</td>
		</tr>
		<cfset total=0>
		<tr>
			<td nowrap="nowrap"  align="left">#LB_DepositoEnCuentaCorriente#</td>
			<td align="center">_______________</td>
			<td align="right"><cf_locale name="number" value ="#rsReporte.depositocuentacorriente#"/></td><cfset total+=rsReporte.depositocuentacorriente>
			<td align="right"><cf_locale name="number" value ="#rsReporte.depositocuentacorriente/rsReporte.tipocambio#"/></td>
		</tr>
		<tr>
			<td nowrap="nowrap"  align="left">#LB_DepositoEnCuentaAhorro#</td>
			<td align="center">_______________</td>
			<td align="right"><cf_locale name="number" value ="#rsReporte.depositocuentaahorro#"/></td><cfset total+=rsReporte.depositocuentaahorro>
			<td align="right"><cf_locale name="number" value ="#rsReporte.depositocuentaahorro/rsReporte.tipocambio#"/></td>
		</tr>
		<tr>
			<td nowrap="nowrap"  align="left">#LB_PagoEnCheque#</td>
			<td align="center">_______________</td>
			<td align="right"><cf_locale name="number" value ="#rsReporte.pagoencheque#"/></td><cfset total+=rsReporte.pagoencheque>
			<td align="right"><cf_locale name="number" value ="#rsReporte.pagoencheque/rsReporte.tipocambio#"/></td>
		</tr>
		<tr>
			<td align="center" colspan="2"></td>
			<td align="center">___________</td>
			<td align="center">___________</td>
		</tr>
		<tr>
			<td nowrap="nowrap"  align="left">Total</td>
			<td align="center"></td>
			<td align="right"><cf_locale name="number" value ="#total#"/></td>
			<td align="right"><cf_locale name="number" value ="#total/rsReporte.tipocambio#"/></td>
		</tr>

	    </table>

	</cfoutput>
</cffunction> 
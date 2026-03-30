<!---------
	Modificado por: Ana Villavicencio
	Fecha de modificación: 25 de mayo del 2005
	Motivo: Se corrigió la consulta ya q no filtraba por la fecha
	Modificado por: Gustavo Fonseca H.
		Fecha de modificación: 18-11-2005
		Motivo: Se modificó para poner la columna de la Fecha de primero y se hace que si el parámetro CBid
		viene por url, lo guarde en el form (esto por que no servía el icono de imprimir).
----------->

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Consulta de Saldos por fechas" returnvariable="LB_Titulo" xmlfile="formSaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cuenta" default="Cuenta" returnvariable="LB_Cuenta" xmlfile="formSaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ConsultaSaldosTCE" default="Consulta de Saldos de TCE" returnvariable="LB_ConsultaSaldosTCE" xmlfile="formSaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TarjetaCredito" default="Tarjeta de Cr&eacute;dito" returnvariable="LB_TarjetaCredito" xmlfile="formSaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ReporteSaldoActual" default="Reporte de Saldos a la fecha actual" returnvariable="LB_ReporteSaldoActual" xmlfile="formSaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ReporteSaldoPeriodoMes" default="Reporte de Saldos por Periodo - Mes" returnvariable="LB_ReporteSaldoPeriodoMes" xmlfile="formSaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ReporteSaldoRangoFechas" default="Reporte de Saldos por Rango de Fechas" returnvariable="LB_ReporteSaldoRangoFechas" xmlfile="formSaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Periodo" default="Periodo" returnvariable="LB_Periodo" xmlfile="formSaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mes" default="Mes" returnvariable="LB_Mes" xmlfile="formSaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" xmlfile="formSaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaInicial" default="Fecha Inicial" returnvariable="LB_FechaInicial" xmlfile="formSaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FechaFinal" default="Fecha Final" returnvariable="LB_FechaFinal" xmlfile="formSaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Documento" default="Documento" returnvariable="LB_Documento" xmlfile="formSaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" xmlfile="formSaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TipoGarantia" default="Tipo Garant&iacute;a" returnvariable="LB_TipoGarantia" xmlfile="formSaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Debitos" default="D&eacute;bitos" returnvariable="LB_Debitos" xmlfile="formSaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Creditos" default="Cr&eacute;ditos" returnvariable="LB_Creditos" xmlfile="formSaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Saldo" default="Saldo" returnvariable="LB_Saldo" xmlfile="formSaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Contrato" default="Contrato" returnvariable="LB_Contrato" xmlfile="formSaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_NoHayDatosParaReportar" default="No existen Movimientos" returnvariable="MSG_NoHayDatosParaReportar" xmlfile="formSaldoFechas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FinReporte" default="Fin del Reporte" returnvariable="LB_FinReporte" xmlfile="formSaldoFechas.xml"/>


<!--- Filtro para utilizar este fuente desde TCE o de Bancos --->
<cfset LvarTitulo = "#LB_Titulo#">
<cfset LvarNombreArchivo = "MB_SaldoFechas.xls">
<cfset LvarMenu = "../MenuMB.cfm">
<cfset LvarformSaldoFechas = "formSaldoFechas.cfm">
<cfset LvarIrA = "SaldoFechas.cfm">
<cfset LbelCuenta = "#LB_Cuenta#:">
<cfif isdefined("LvarFormSaldoFechasTCE")>
    <cfset LvarformSaldoFechas = "../../tce/consultas/formSaldoFechasTCE.cfm">
    <cfset LvarTitulo = "#LB_ConsultaSaldosTCE#">
    <cfset LvarMenu = "../../tce/MenuTCE.cfm">
    <cfset LvarNombreArchivo = "TCE_SaldoFechas.xls">
    <cfset LvarIrA = "SaldoFechasTCE.cfm">
    <cfset LbelCuenta = "#LB_TarjetaCredito#:">
</cfif>
<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
<cfif isdefined("url.CBid") and len(trim(#url.CBid#))>
	<cfparam name="form.CBid" default="#url.CBid#">
</cfif>
<cfif isdefined("url.fechai")>
	<cfparam name="form.fechai" default="#url.fechai#">
</cfif>

<cfif isdefined("url.fechaf")>
	<cfparam name="form.fechaf" default="#url.fechaf#">
</cfif>

<cfif isdefined("url.tipo")>
	<cfparam name="form.tipo" default="#url.tipo#">
</cfif>
<cfset vparams ="">
<cfset vparams = vparams & "&fechai=" & form.fechai & "&fechaf=" & form.fechaf >
<!--- compara las fechas y modifica las mismas (les da vuelta), de manera que fecha inicial sea menor a fecha final >--->
<cf_dbfunction name="datediff"			args="form.fechai, form.fechaf" returnvariable="DiasDiferencia">
<cfif #DiasDiferencia# eq 1 >
	<cfset fecha_tmp = form.fechai>
	<cfset form.fechai = form.fechaf >
	<cfset form.fechaf = fecha_tmp >
</cfif>

<!--- CONSULTAS --->
<!--- 1. Datos de la empresa --->
<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo =  #Session.Ecodigo#
</cfquery>

<!--- 2. Funcion principal, filtrada por compañía, fecha inicial, fecha final  y dependiendo de quien la llame por la cuenta bancaria--->
<cffunction name="get_datos" access="public" returntype="query">
	<cfargument name="cbid"     type="numeric" required="false"  default="<!--- Código de la línea de Título --->">
	<cfargument name="fechai"   type="string"  required="false"  default="<!--- Código de la línea de Título --->">
	<cfargument name="fechaf"   type="string"  required="false"  default="<!--- Código de la línea de Título --->">
	<cfargument name="Periodo"  type="numeric" required="false"  default="0">
	<cfargument name="Mes"      type="numeric" required="false"  default="0">

        <cfif isdefined("LvarFormSaldoFechasTCE") and isdefined("form.RangoP") and len(trim(form.RangoP)) >
			<cfset per = true>
        <cfelse>
			<cfset fecha1 = LSParseDateTime(Arguments.fechai)>
            <cfset fecha2 = LSParseDateTime(Arguments.fechaf)>
            <cfset fecha2 = dateadd("d", 1, fecha2)>
		</cfif>

        <cfquery name="rsFDatos" datasource="#session.DSN#"  >
			select
            	ml.MLid,
                ml.Ecodigo,
                ml.CBid,
                ml.MLdocumento,
                ml.MLdescripcion,
                cb.CBcodigo,
                ml.MLmonto,
                ml.MLmontoloc,
                ml.MLperiodo,
                ml.MLmes,
                ml.MLtipomov,
                (case ml.MLtipomov when 'C' then 'Crédito' when 'D' then 'Débito' end) as dMLtipomov,
                ml.MLfecha as fMLfechamov,
                ml.MLfecha,
                cb.Ocodigo,
                o.Odescripcion,
                cb.Bid,
                b.Bdescripcion,
                cb.Mcodigo,
                m.Mnombre
			from  MLibros ml
				inner join CuentasBancos cb
					on ml.CBid=cb.CBid

					inner join Oficinas o
						on cb.Ocodigo=o.Ocodigo
						and cb.Ecodigo=o.Ecodigo

					inner join Bancos b
						on cb.Bid=b.Bid
						and cb.Ecodigo=b.Ecodigo

					inner join Monedas m
						on cb.Mcodigo=m.Mcodigo

			where cb.Ecodigo= #Session.Ecodigo#
			<cfif cbid neq -1>
				and ml.CBid = #Arguments.cbid#
                <cfif isdefined("per") and per>
                	and ml.MLperiodo = #Arguments.Periodo#
                    and ml.MLmes = #Arguments.Mes#
                <cfelse>
                    and ml.MLfecha >= #fecha1#
                    and ml.MLfecha < #fecha2#
                </cfif>
                order by ml.MLfecha, ml.MLid
			<cfelse>
				order by cb.Ocodigo, cb.Bid, cb.Mcodigo, ml.CBid
			</cfif>
		</cfquery>
	<cfreturn #rsFDatos#>
</cffunction>

<cffunction name="get_saldo" access="public" returntype="numeric">
	<cfargument name="cbid"     type="numeric" required="true"  default="<!--- Código de la línea de Título --->">
	<cfargument name="fechai"   type="string"  required="false" default="<!--- Código de la línea de Título --->">
	<cfargument name="fechaf"   type="string"  required="false" default="<!--- Código de la línea de Título --->">
	<cfargument name="Periodo"  type="numeric" required="false"  default="0">
	<cfargument name="Mes"      type="numeric" required="false"  default="0">

    <cfif isdefined("LvarFormSaldoFechasTCE") and isdefined("form.RangoP") and len(trim(form.RangoP))>
		<cfset per = true>
        <cfif Arguments.Mes eq 1>
        	<cfset Arguments.Periodo = (Arguments.Periodo - 1)>
  		    <cfset Arguments.Mes = 12>
        <cfelse>
        	<cfset Arguments.Mes = (Arguments.Mes - 1)>
        </cfif>
    </cfif>

	<!--- Cambio para reportar por fecha de documento y no fecha de transaccion o registro --->
	<cfquery name="rsget_saldo" datasource="#session.dsn#">
		select count(1) as Cantidad, sum(MLmonto * case when MLtipomov = 'D' then 1.00 else -1.00 end) as Saldo
		from MLibros
		where CBid = #Arguments.CBid#
          <cfif isdefined("per") and per>
		  	and MLperiodo = #Arguments.Periodo#
            and MLmes = #Arguments.Mes#
          <cfelse>
          	and MLfecha < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(fechai)#">
          </cfif>
	</cfquery>
	<cfif rsget_saldo.Cantidad GT 0>
		<cfset saldoi=rsget_saldo.Saldo>
	<cfelse>
			<cfset saldoi=0.00>
	</cfif>
	<cfreturn saldoi>

</cffunction>

<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 10px;
		padding-bottom: 10px;
	}
	.encabReporte2 {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 3px;
		padding-bottom: 3px;

	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold;
		font-size: x-small;
		background-color: #F5F5F5;
	}
}
</style>




<cf_htmlreportsheaders title="#LvarTitulo#"
    filename="#LvarNombreArchivo#"
    download='true'
    ira="#LvarIrA#?1=1#paramsuri#"><!--- ir a  »»SaldoFechas.cfm«« en Bancos o TCE »»SaldoFechasTCE.cfm««--->

<form name="form1" method="post">
    <center><span class="tituloAlterno"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></span></center>
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 1px; " align="center">
		<!--- ============================================================================================================ --->
		<!---                                            Encabezado del Reporte                                            --->
		<!--- ============================================================================================================ --->
			<tr>
				<td colspan="2" align="right"><cfoutput>#LSDateFormat(Now(), 'dd/mm/yyyy')#</cfoutput></td>
			</tr>
			<tr>
				<td colspan="2" class="tituloAlterno" align="center">&nbsp;</td>
			</tr>

			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<cfif isdefined("form.tipo") and form.tipo eq 1>
					<td colspan="2" align="center"><b><cfoutput>#LB_ReporteSaldoActual#</cfoutput></b></td>
				<cfelseif isdefined("LvarFormSaldoFechasTCE") and isdefined("form.RangoP") and len(trim(form.RangoP))>
                	<td colspan="2" align="center"><b><cfoutput>#LB_ReporteSaldoPeriodoMes#</cfoutput></b></td>
                <cfelse>
					<td colspan="2" align="center"><b><cfoutput>#LB_ReporteSaldoRangoFechas#</cfoutput></b></td>
				</cfif>
			</tr>

			<tr> <cfoutput>
			        <cf_dbfunction name="datediff" args="form.fechai, form.fechaf" returnvariable="DiasDiferencia2">
					<cfif isdefined("LvarFormSaldoFechasTCE") and isdefined("form.RangoP") and len(trim(form.RangoP)) >
                    	<td colspan="2" align="center"><b><cfoutput>#LB_Perido#</cfoutput>:</b> #form.Periodo# &nbsp; <b><cfoutput>#LB_Mes#</cfoutput>:&nbsp;</b>#form.Mes#</td>
                    <cfelse>
						<cfif DiasDiferencia2 eq 0 >
                            <td colspan="2" align="center"><b><cfoutput>#LB_Fecha#</cfoutput>:</b> #form.fechai# </td>
                        <cfelse>
                            <td colspan="2" align="center"><b><cfoutput>#LB_FechaInicial#</cfoutput>:</b> #form.fechai# &nbsp; <b><cfoutput>#LB_FechaFinal#</cfoutput>:&nbsp;</b>#form.fechaf#</td>
                        </cfif>
                    </cfif>
				</cfoutput>
			</tr>

			<tr><td colspan="2">&nbsp;</td></tr>

		<!--- ============================================================================================================ --->
		<!---                                                Datos del Reporte                                             --->
		<!--- ============================================================================================================ --->
			<cfoutput>
			<tr><td colspan="2">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 1px; " align="center">
					<!--- Recupera el resulset de datos --->
                    <cfif isdefined("LvarFormSaldoFechasTCE") and isdefined("form.RangoP") and len(trim(form.RangoP)) >
						<cfset rsDatos = get_datos(form.CBid, '0', '0',form.Periodo, form.Mes) >
                    <cfelse>
						<cfset rsDatos = get_datos(form.CBid, form.fechai, form.fechaf) >
					</cfif>
					<!--- 1. Query para obtener las diferentes Oficinas  --->
					<cfquery name="rsOficinas" dbtype="query" >
						select distinct Ocodigo, Odescripcion from rsDatos order by Odescripcion
					</cfquery>

					<!--- 2. Cortes por Oficina --->
					<cfloop query="rsOficinas">
						<cfset oficina = Ocodigo>
						<tr><td colspan="13" class="bottomline">&nbsp;</td></tr>

						<tr>
							<cfif isdefined("form.chkDetallado") AND #form.chkDetallado# EQ 1>
								<td class="tituloListas" align="left" colspan="14">
							<cfelse>
								<td class="tituloListas" align="left" colspan="13">
							</cfif>

								<div align="center"><font size="3">#Odescripcion#</font></div>
							</td>
						</tr>

								<!--- 2.2.1. Query para Monedas, segun Oficina y Banco--->
								<cfquery name="rsMonedas" dbtype="query">
									select distinct Mcodigo, Mnombre from rsDatos where Ocodigo = #oficina# order by Mnombre
								</cfquery>

								<!--- 2.2.2. Cortes por Oficina - Bancos - Monedas --->
								<cfloop query="rsMonedas">
									<cfset moneda = Mcodigo>
									<tr>
										<td width="1%" class="listaCorte">&nbsp;</td>
										<cfif isdefined("form.chkDetallado") AND #form.chkDetallado# EQ 1>
											<td class="listaCorte" align="left" colspan="13">#Mnombre#</td>
										<cfelse>
											<td class="listaCorte" align="left" colspan="12">#Mnombre#</td>
										</cfif>
									</tr>

									<!--- 2.2.2.1. Query para datos de los detalles, segun Oficina, Banco y Moneda --->
									<cfquery name="rsCuentas" dbtype="query" >
										select distinct CBid, CBcodigo
										from rsDatos
										where Ocodigo=#oficina#
										  and Mcodigo=#moneda#
									</cfquery>

									<!--- 2.2.2.2. calculo del Saldo Inicial--->
									<cfset cuenta = "" >
									<cfloop query="rsCuentas">
										<cfif isdefined("LvarFormSaldoFechasTCE") and isdefined("form.RangoP") and len(trim(form.RangoP)) >
											<cfset saldoi = get_saldo(CBid, '0', '0',form.Periodo, form.Mes) >
                                        <cfelse>
											<cfset saldoi = get_saldo(CBid, form.fechai, form.fechaf) >
										</cfif>
										<!--- datos del corte por cuenta --->
										<cfif CBid neq cuenta >
											<tr>
												<td class="listaCorte" width="1%"></td>
												<td class="listaCorte" width="1%"></td>
												<cfif isdefined("form.chkDetallado") AND #form.chkDetallado# EQ 1>
													<td class="listaCorte" colspan="12"><cfoutput>#LbelCuenta#</cfoutput> #CBcodigo# </td>
												<cfelse>
													<td class="listaCorte" colspan="11"><cfoutput>#LbelCuenta#</cfoutput> #CBcodigo# </td>
												</cfif>
											</tr>

											<!--- Titulos --->
											<tr>
												<td class="encabReporte2" width="1%"></td>
												<td class="encabReporte2" width="1%"></td>
												<td class="encabReporte2" width="1%"></td>
												<td class="encabReporte2">#LB_Fecha#</td>
												<td class="encabReporte2">#LB_Documento#</td>
												<td class="encabReporte2">#LB_Descripcion#</td>
												<cfif isdefined("form.chkDetallado") AND #form.chkDetallado# EQ 1>
													<td class="encabReporte2" align="center">#LB_Cuenta#</td>
												</cfif>
												<td class="encabReporte2" align="center">#LB_TipoGarantia#</td>
												<td class="encabReporte2" align="right">#LB_Debitos#</td>
												<td class="encabReporte2" align="right">&nbsp;</td>
												<td class="encabReporte2" align="right">#LB_Creditos#</td>
												<td class="encabReporte2" align="right">&nbsp;</td>
												<td class="encabReporte2" align="right">#LB_Saldo#</td>
												<td class="encabReporte2" align="center">#LB_Contrato#</td>
											</tr>

										</cfif>

										<!--- control de la cuenta --->
										<cfset cuenta = #CBid# >

										<!--- Movimientos a incluir en el reporte --->
										<cfif isdefined("LvarFormSaldoFechasTCE") and isdefined("form.RangoP") and len(trim(form.RangoP)) >
											<cfset rsDetalles = get_datos(form.CBid, '0', '0',form.Periodo, form.Mes) >
                                        <cfelse>
                                            <cfset rsDetalles = get_datos(form.CBid, form.fechai, form.fechaf) >
                                        </cfif>

										<cfset saldo_aux = saldoi >
										<cfif rsDetalles.RecordCount gt 0 >
											<cfloop query="rsDetalles">

												<cfif MLtipomov  eq 'D' >
													<cfset saldo_aux = saldo_aux + MLmonto >
												<cfelse>
													<cfset saldo_aux = saldo_aux - MLmonto >
												</cfif>

                                            <cfquery datasource="#session.DSN#" name="COHDGarantia">
                               			    	SELECT count(1) from  COHDGarantia
                                            </cfquery>

                                            <cfif COHDGarantia.recordcount gt 0>
                                                <cfquery datasource="#session.DSN#" name="rsProveedor">
                                                   Select ltrim(rtrim(ltrim(rtrim(sn.SNidentificacion))  #_Cat# ' ' #_Cat# ltrim(rtrim(sn.SNnombre))))
                                                     from MLibros mlq
                                                        inner join COHDGarantia z
                                                              on z.CODGNumDeposito  = mlq.MLdocumento
                                                            and z.Bid  = mlq.Bid
                                                            and z.CBid = mlq.CBid
                                                        inner join COHEGarantia ze
                                                              on ze.COEGid = z.COEGid
                                                            and ze.Ecodigo = z.Ecodigo
                                                        inner join SNegocios sn
                                                              on sn.SNid =  ze.SNid
                                                            and sn.Ecodigo = ze.Ecodigo
                                                    where mlq.MLid = #MLid#
                                               </cfquery>

                                               <cfquery datasource="#session.DSN#" name="rsContrato">
                                                Select pc.CMPProceso as CMProceso
                                                    from MLibros mlq
                                                        inner join COHDGarantia z
                                                              on z.CODGNumDeposito  = mlq.MLdocumento
                                                            and z.Bid  = mlq.Bid
                                                            and z.CBid = mlq.CBid
                                                        inner join COHEGarantia ze
                                                              on ze.COEGid = z.COEGid
                                                            and ze.Ecodigo = z.Ecodigo
                                                        inner join CMProceso pc
                                                              on pc.CMPid = ze.CMPid
                                                            and pc.Ecodigo = ze.Ecodigo
                                                    where mlq.MLid = #MLid#
                                                </cfquery>
                                                <cfquery datasource="#session.DSN#" name="rsTipoGarantia">
                                                     Select
                                                     case ze.COEGTipoGarantia
                                                        when 1 then 'Garantía participacion '
                                                        when 2 then 'Garantía cumplimiento '
                                                     end as garantiaTipo
                                                        from MLibros mlq
                                                            inner join COHDGarantia z
                                                                  on z.CODGNumDeposito  = mlq.MLdocumento
                                                                and z.Bid  = mlq.Bid
                                                                and z.CBid = mlq.CBid
                                                            inner join COHEGarantia ze
                                                                  on ze.COEGid = z.COEGid
                                                                and ze.Ecodigo = z.Ecodigo
                                                        where mlq.MLid = #MLid#
                                                </cfquery>
                                            </cfif>
												<cfif rsDetalles.CurrentRow eq 1>
													<tr>
														<td width="1%">&nbsp;</td>
														<td width="1%">&nbsp;</td>
														<td width="1%">&nbsp;</td>
														<td ><b>#Bdescripcion#</b></td>
														<cfif isdefined("form.chkDetallado") AND #form.chkDetallado# EQ 1>
															<td colspan="9"  align="right"><b><font color="<cfif saldoi lt 0>##FF0000<cfelse>##000000</cfif>">#LSNumberFormat( saldoi,',9.00')#</font></b></td>
														<cfelse>
															<td colspan="8"  align="right"><b><font color="<cfif saldoi lt 0>##FF0000<cfelse>##000000</cfif>">#LSNumberFormat( saldoi,',9.00')#</font></b></td>
														</cfif>
													</tr>
												</cfif>
												<tr>
													<td width="1%">&nbsp;</td>
													<td width="1%">&nbsp;</td>
													<td width="1%">&nbsp;</td>
													<td nowrap>#LSDateFormat(fMLfechamov,'dd/mm/yyyy')#</td>
													<td nowrap>#MLdocumento#</td>
													<td nowrap>#MLdescripcion#</td>
													<cfif isdefined("form.chkDetallado") AND #form.chkDetallado# EQ 1>
														<td nowrap>&nbsp;</td>
													</cfif>
													<cfif isdefined("rsTipoGarantia.garantiaTipo") and len(trim(rsTipoGarantia.garantiaTipo)) gt 0>
   													  <td nowrap> #rsTipoGarantia.garantiaTipo# </td>
													<cfelse>
													  <td nowrap> ---- </td>
													</cfif>
													<td align="right" nowrap> <font color="<cfif MLmonto lt 0>##FF0000<cfelse>##000000</cfif>"><cfif MLtipomov  eq 'D' > #LSNumberFormat( MLmonto,',9.00')# <cfelse> 0.00 </cfif></font></td>
													<td align="right" nowrap>&nbsp; </td>
                                                    <td align="right" nowrap> <font color="<cfif MLmonto lt 0>##FF0000<cfelse>##000000</cfif>"><cfif MLtipomov  eq 'C' > #LSNumberFormat( MLmonto,',9.00')# <cfelse> 0.00 </cfif></font></td>
													<td align="right" nowrap>&nbsp; </td>
													<td align="right" nowrap> <font color="<cfif saldo_aux lt 0>##FF0000<cfelse>##000000</cfif>">#LSNumberFormat( saldo_aux,',9.00')# </font></td>
												    <cfif isdefined("rsContrato.CMProceso") and len(trim(rsContrato.CMProceso)) gt 0>
													   <td nowrap align="center"> #rsContrato.CMProceso# </td>
													<cfelse>
													  <td nowrap align="center"> ---- </td>
													</cfif>
												</tr>
												<cfif isdefined("form.chkDetallado") AND #form.chkDetallado# EQ 1>
													<cfquery datasource="#session.DSN#" name="rsGetDetalleMB">
														SELECT d.*,
														       cf.CFdescripcion AS Cuenta
														FROM HDMovimientos d
														INNER JOIN HEMovimientos e ON d.EMid = e.EMid
														INNER JOIN CFinanciera cf ON cf.CFcuenta = d.CFcuenta
														AND cf.CFmovimiento = 'S'
														AND e.MLid = <cfqueryparam value="#rsDetalles.MLid#" cfsqltype="cf_sql_integer">
														AND e.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
													</cfquery>
													<cfif rsGetDetalleMB.RecordCount GT 0>
														<cfloop query="rsGetDetalleMB">
															<tr>
																<td colspan="5">&nbsp;</td>
																<td>#rsGetDetalleMB.DMdescripcion#</td>
																<td>#rsGetDetalleMB.Cuenta#</td>
																<td>&nbsp;</td>
																<td align="right"><cfif rsDetalles.MLtipomov eq 'D'>#LSNumberFormat(rsGetDetalleMB.DMmonto,',9.00')#<cfelse>0.00</cfif></td>
																<td>&nbsp;</td>
																<td align="right"><cfif rsDetalles.MLtipomov eq 'C'>#LSNumberFormat(rsGetDetalleMB.DMmonto,',9.00')#<cfelse>0.00</cfif></td>
																<td colspan="3">&nbsp;</td>
															</tr>
														</cfloop>
													</cfif>
												</cfif>
											</cfloop> <!--- rsDetalles --->
										<cfelse>
											<tr bgcolor="##F5F5F5">
                                            	<td width="1%"></td>
												<td width="1%"></td>
												<td width="1%"></td>
												<td colspan="7"  align="right"><b><font color="<cfif saldoi lt 0>##FF0000<cfelse>##000000</cfif>">#LSNumberFormat( saldoi,',9.00')#</font></b></td>
											</tr>

											<tr bgcolor="##F5F5F5">
												<td width="1%"></td>
												<td width="1%"></td>
												<td width="1%"></td>
												<td colspan="8" align="center"><b><cfoutput>#MSG_NoHayDatosParaReportar#</cfoutput></b></td>
											</tr>
										</cfif>
										<td colspan="10" align="center">&nbsp;</td>
									</cfloop> <!--- rsCuentas --->
								</cfloop> <!--- rsMonedas --->
						<tr><td colspan="10">&nbsp;</td></tr>
						<tr><td class="topline" colspan="11">&nbsp;</td></tr>
					</cfloop> <!--- rsOficinas --->
				</table>
			</td></tr>
			</cfoutput>
		<!--- ============================================================================================================ --->
		<!---                                               Pie del Reporte                                                --->
		<!--- ============================================================================================================ --->
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td colspan="2"><div align="center">------------------ <cfoutput>#LB_FinReporte#</cfoutput> ------------------</div></td>
			</tr>
		<!--- ============================================================================================================ --->
		<!--- ============================================================================================================ --->
    </table>
</form>

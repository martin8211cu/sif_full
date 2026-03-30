<cfsetting requesttimeout="600">
<!--- Asigna variables default --->
<cfif isdefined ("form.TIPOFORMATO") or len(trim(form.TIPOFORMATO))>
	<cfset TipoFormato = form.TIPOFORMATO>
<cfelse> 
	<cfset TipoFormato = 4>
</cfif>

<cfif isdefined("form.ID_REPORTE") and len(trim(form.ID_REPORTE))>
	<cfset Id_Reporte = form.ID_REPORTE>
<cfelse>
	<cfset Id_Reporte = 1>	
</cfif> 

<cfif isdefined("form.ASIECONTIDLIST") and len(trim(form.ASIECONTIDLIST))>
	<cfset AsieContidList = form.ASIECONTIDLIST>
<cfelse>
	<cfset AsieContidList = "">	
</cfif> 

<cfif isdefined("form.ID_INCSUCURSAL") and len(trim(form.ID_INCSUCURSAL))>
	<cfset incsucursal = 1>
<cfelse>
	<cfset incsucursal = 0>
</cfif>

<cfset TituloReporte = "Reporte de Saldos por Cuenta">
<cfswitch expression="#Id_Reporte#">
	<cfcase value="1"> 
		<cfset TituloReporte = "Reporte de Saldos por Cuenta">
	</cfcase>
	<cfcase value="2"> 
		<cfset TituloReporte = "Reporte de Saldos por Rango de Cuentas">
	</cfcase>
	<cfcase value="3"> 
		<cfset TituloReporte = "Reporte de Saldos por Lista de Cuentas">
	</cfcase>
</cfswitch>	


<!--- Se cambia el valor numerico del mes inicial y mes final a letras --->
<cfif isdefined("form.MesInicial") and len(trim(form.MesInicial))>
	
	<cfif form.MesInicial EQ 1>
		<cfset MesInicial = "Enero">
	</cfif>
	<cfif form.MesInicial EQ 2 >
		<cfset MesInicial = "Febrero">
	</cfif>
	<cfif form.MesInicial EQ 3 >
		<cfset MesInicial = "Marzo">
	</cfif>
	<cfif form.MesInicial EQ 4 >
		<cfset MesInicial = "Abril">
	</cfif>
	<cfif form.MesInicial EQ 5 >
		<cfset MesInicial = "Mayo">
	</cfif>
	<cfif form.MesInicial EQ 6 >
		<cfset MesInicial = "Junio">
	</cfif>
	<cfif form.MesInicial EQ 7 >
		<cfset MesInicial = "Julio">
	</cfif>
	<cfif form.MesInicial EQ 8 >
		<cfset MesInicial = "Agosto">
	</cfif>
	<cfif form.MesInicial EQ 9 >
		<cfset MesInicial = "Septiembre">
	</cfif>
	<cfif form.MesInicial EQ 10 >
		<cfset MesInicial = "Octubre">
	</cfif>
	<cfif form.MesInicial EQ 11 >
		<cfset MesInicial = "Noviembre">
	</cfif>
	<cfif form.MesInicial EQ 12 >
		<cfset MesInicial = "Diciembre">
	</cfif>
</cfif>

<cfif isdefined("form.MesFinal") and len(trim(form.MesFinal))>
	
	<cfif form.MesFinal EQ 1>
		<cfset MesFinal = "Enero">
	</cfif>
	<cfif form.MesFinal EQ 2>
		<cfset MesFinal = "Febrero">
	</cfif>
	<cfif form.MesFinal EQ 3>
		<cfset MesFinal = "Marzo">
	</cfif>
	<cfif form.MesFinal EQ 4>
		<cfset MesFinal = "Abril">
	</cfif>
	<cfif form.MesFinal EQ 5>
		<cfset MesFinal = "Mayo">
	</cfif>
	<cfif form.MesFinal EQ 6>
		<cfset MesFinal = "Junio">
	</cfif>
	<cfif form.MesFinal EQ 7>
		<cfset MesFinal = "Julio">
	</cfif>
	<cfif form.MesFinal EQ 8>
		<cfset MesFinal = "Agosto">
	</cfif>
	<cfif form.MesInicial EQ 9>
		<cfset MesFinal = "Septiembre">
	</cfif>
	<cfif form.MesFinal EQ 10>
		<cfset MesFinal = "Octubre">
	</cfif>
	<cfif form.MesInicial EQ 11>
		<cfset MesFinal = "Noviembre">
	</cfif>
	<cfif form.MesFinal EQ 12>
		<cfset MesFinal = "Diciembre">
	</cfif>
</cfif>

<cfset contador = 10>
<cfoutput> 
<script language="javascript1.2" type="text/javascript">
	function regresar() {
		if (#Id_Reporte# == 1) {
			document.location = "../reportes/cmn_SaldosCuentas.cfm";
		}
		if (#Id_Reporte# == 2) {
			document.location = "../reportes/cmn_SaldosRangoCuentas.cfm";
		}
		if (#Id_Reporte# == 3) {
			document.location = "../reportes/cmn_SaldosAsientoCuentas.cfm";
		}
	}

	function imprimir() {
		/*
		var imprimir = document.getElementById("imprimir");
		var Regresar = document.getElementById("Regresar");
		var EXCEL = document.getElementById("EXCEL");*/
		var tablabotones = document.getElementById("tablabotones");
		/*
		EXCEL.style.visibility='hidden';
		imprimir.style.visibility='hidden';
		Regresar.style.visibility='hidden';*/
        tablabotones.style.display = 'none';
		window.print()	
		/*
		EXCEL.style.visibility='visible';
		imprimir.style.visibility='visible';
		Regresar.style.visibility='visible';*/
        tablabotones.style.display = ''

	}

	function SALVAEXCEL() {
		var EXCEL = document.getElementById("EXCEL");
		EXCEL.style.visibility='hidden';
		var file =  "../reportes/cmn_excel.cfm" ;
		var string=  "width=400,height=200,toolbar=no,directories=no,menubar=yes,resizable=yes,dependent=yes"    
		hwnd = window.open(file,'excel',string) ;                    
		if (navigator.appName == "Netscape") {   
			 hwnd.focus()   
        }   
	}


</script>
</cfoutput>
<cfoutput>
<table  id="tablabotones" width="100%" cellpadding="0" cellspacing="0" border="0" >
	<tr>
		<td align="right" nowrap>
			<input type="button"  id="EXCEL" name="EXCEL" value="Exportar a Excel" onClick="SALVAEXCEL();">
			<input type="button"  id="Regresar" name="Regresar" value="Regresar" onClick="regresar();">
			<input type="button"  id="Imprimir" name="Imprimir" value="Imprimir" onClick="imprimir();">
		</td>
	</tr>
	<tr><td><hr></td></tr>
</table>
<!--- <cfsavecontent variable="micontenido"> --->
<style>
H1.Corte_Pagina
{
PAGE-BREAK-AFTER: always
}
<!--table
	{mso-displayed-decimal-separator:"\.";
	mso-displayed-thousand-separator:"\,";}
@page
	{margin:1.0in .75in 1.0in .75in;
	mso-header-margin:.5in;
	mso-footer-margin:.5in;}
tr
	{mso-height-source:auto;}
col
	{mso-width-source:auto;}
br
	{mso-data-placement:same-cell;}
.style0
	{mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	white-space:nowrap;
	mso-rotate:0;
	mso-background-source:auto;
	mso-pattern:auto;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Arial;
	mso-generic-font-family:auto;
	mso-font-charset:0;
	border:none;
	mso-protection:locked visible;
	mso-style-name:Normal;
	mso-style-id:0;}
td
	{mso-style-parent:style0;
	padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Arial;
	mso-generic-font-family:auto;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	border:none;
	mso-background-source:auto;
	mso-pattern:auto;
	mso-protection:locked visible;
	white-space:nowrap;
	mso-rotate:0;}
.xl24
	{mso-style-parent:style0;
	mso-number-format:Standard;}
.xl25
	{mso-style-parent:style0;
	font-size:9.0pt;
	font-weight:700;
	text-align:center;
	background:silver;
	mso-pattern:auto none;
	white-space:normal;}
.xl26
	{mso-style-parent:style0;
	font-weight:700;
	font-family:Arial, sans-serif;
	mso-font-charset:0;}
.xl27
	{mso-style-parent:style0;
	font-size:8.0pt;
	font-weight:bold;
	font-family:Arial, sans-serif;
	mso-font-charset:0;}
.xl28
	{mso-style-parent:style0;
	font-size:8.0pt;
	font-family:Arial, sans-serif;
	mso-font-charset:0;}
.xl29
	{mso-style-parent:style0;
	font-size:8.0pt;
	font-family:Arial, sans-serif;
	mso-number-format:"\@";}
-->
</style>
<table width="100%" cellpadding="0" cellspacing="0" border="0" >
	<tr>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0" border="0" >
				<tr><td  colspan="6" align="center" class="xl25">INSTITUTO COSTARRICENSE DE ELECTRICIDAD</td></tr>
				<tr><td  colspan="6" align="center" class="xl25">#TituloReporte#</td></tr>
				<tr><td  colspan="6" align="center" class="xl25">De #MesInicial# #form.AnoInicial# a #MesFinal# #form.AnoInicial#</td></tr>
			</table>
		</td>
	</tr>
	<tr><td><hr></td></tr>
	<tr>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0" border="0" >
				<cfif form.segmento neq 'T'>
					<cfquery name="rsDesSeg1" datasource="#session.Conta.dsn#">
							select a.CGE5DES as CGE5DES
							from CGE005 a, CGE000 b
							where a.CGE1COD = b.CGE1COD
							and a.CGE5COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Segmento#">
							union all
							select CGE5DES  as CGE5DES
							from anex_sucursal
							where cod_suc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Segmento#">
					</cfquery>
					
					<cfif rsDesSeg1.RecordCount GT 0>
						<cfset DesSegmento = #rsDesSeg1.CGE5DES#>
					<cfelse>
						<cfset DesSegmento = "***">
					</cfif>
					
				</cfif>					
					
				<tr><td align="center" colspan="6"  class="xl26">
					<cfif TipoFormato EQ 1>
						Reporte Detallado
					<cfelseif TipoFormato EQ 2>
						Reporte Detallado por Mes
					<cfelseif TipoFormato EQ 3>
						Reporte Detallado por Asiento
					<cfelse>
						Reporte Resumido
					</cfif></td></tr>
				<tr><td  align="center" colspan="6"  class="xl26">Segmento:&nbsp;<cfif form.segmento eq 'T'>Todos<cfelse>#form.segmento# - #DesSegmento#</cfif></td></tr>
			</table>
		</td>
	</tr>
	<tr><td><hr></td></tr>
	<tr>
		<td nowrap>
			<table width="100%" cellpadding="0" cellspacing="0" border="0" >
				<tr>
					<td nowrap class="xl25">Cuenta</td>
					<td nowrap class="xl25">Descripci&oacute;n</td>
					<td nowrap align="right" class="xl25">Inicial</td>
					<td nowrap align="right" class="xl25">D&eacute;bitos</td>
					<td nowrap align="right" class="xl25">Cr&eacute;ditos</td>
					<td nowrap align="right" class="xl25">Final</td>
				</tr>
				<cfflush interval="1024"> 
				<!---  Primer consulta  del ciclo --->			
				<cfloop query="rsCuentasContables">
					<cfif len(strAsientos) GT 0>
						<cfquery name="rsDatos" datasource="#session.Conta.dsn#">
						select 	
								isnull((
										select sum(CTSSAN)
										from #archivotbl# ct, CGM007 s (index CGM00700)
										where ct.rptid = #llave#
										  and ct.CuentaMayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentasContables.CuentaMayor#">
										  and s.CGM1ID = ct.CuentaDetalle
										  and s.CTSPER = #anoini#
										  and s.CTSMES = #mesini#
										  and s.CG5CON in (#strAsientos#)
										<cfif sucursal NEQ "T">
											and s.CGE5COD in (#PreserveSingleQuotes(strSucursales)#)
										</cfif>
								), 0.00) as SaldoIncial,
								isnull((
										select sum(CTSDEB)
										from #archivotbl# ct, CGM007 s (index CGM00700)
										where ct.rptid = #llave#
											and ct.CuentaMayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentasContables.CuentaMayor#">
											and s.CGM1ID = ct.CuentaDetalle
											and s.CTSPER = #anoini#
											and s.CTSMES >= #mesini#
											and s.CTSMES <= #mesfin#
											and s.CG5CON in (#strAsientos#)
											<cfif sucursal NEQ "T">
												and s.CGE5COD in (#PreserveSingleQuotes(strSucursales)#)
											</cfif>
								), 0.00) as Debitos,
								isnull((
										select sum(CTSCRE)
										from #archivotbl# ct, CGM007 s (index CGM00700)
										where ct.rptid = #llave#
											and ct.CuentaMayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentasContables.CuentaMayor#">
											and s.CGM1ID = ct.CuentaDetalle
											and s.CTSPER = #anoini#
											and s.CTSMES >= #mesini#
											and s.CTSMES <= #mesfin#
											and s.CG5CON in (#strAsientos#)
											<cfif sucursal NEQ "T">
												and s.CGE5COD in (#PreserveSingleQuotes(strSucursales)#)
											</cfif>
								), 0.00) as Creditos
								at isolation 0
						</cfquery>
					<cfelse>
						<cfquery name="rsDatos" datasource="#session.Conta.dsn#">
						select 	
								isnull((
										select sum(CTSSAN)
										from #archivotbl# ct, CGM004 s (index CGM00400)
										where ct.rptid = #llave#
										and ct.CuentaMayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentasContables.CuentaMayor#">
										  and s.CGM1ID = ct.CuentaDetalle
										  and s.CTSPER = #anoini#
										  and s.CTSMES = #mesini#
										<cfif sucursal NEQ "T">
											and s.CGE5COD in (#PreserveSingleQuotes(strSucursales)#)
										</cfif>
								), 0.00) as SaldoIncial,
								isnull((
										select sum(CTSDEB)
										from #archivotbl# ct, CGM004 s (index CGM00400)
										where ct.rptid = #llave#
											and ct.CuentaMayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentasContables.CuentaMayor#">
											and s.CGM1ID = ct.CuentaDetalle
											and s.CTSPER = #anoini#
											and s.CTSMES >= #mesini#
											and s.CTSMES <= #mesfin#
											<cfif sucursal NEQ "T">
												and s.CGE5COD in (#PreserveSingleQuotes(strSucursales)#)
											</cfif>
								), 0.00) as Debitos,
								isnull((
										select sum(CTSCRE)
										from #archivotbl# ct, CGM004 s (index CGM00400)
										where ct.rptid = #llave#
											and ct.CuentaMayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentasContables.CuentaMayor#">
											and s.CGM1ID = ct.CuentaDetalle
											and s.CTSPER = #anoini#
											and s.CTSMES >= #mesini#
											and s.CTSMES <= #mesfin#
											<cfif sucursal NEQ "T">
												and s.CGE5COD in (#PreserveSingleQuotes(strSucursales)#)
											</cfif>
								), 0.00) as Creditos
								at isolation 0
						</cfquery>
					</cfif>

					<cfif rsDatos.SaldoIncial NEQ 0.00 or rsDatos.Debitos NEQ 0.00 or rsDatos.Creditos NEQ 0.00>					
						<cfset contador = contador + 1>
						<!--- <cfdump var="#contador#"> --->
						 <tr>
							<cfif #rsCuentasContables.Detalle# EQ 0>
								<td nowrap class="xl27">#rsCuentasContables.FormatoCuenta#</td>
								<td nowrap class="xl27">#rsCuentasContables.Descripcion#</td>
								<td nowrap align="right" class="xl27">#LSCurrencyFormat(rsDatos.SaldoIncial,'none')#</td>
								<td nowrap align="right" class="xl27">#LSCurrencyFormat(rsDatos.Debitos,'none')#</td>
								<td nowrap align="right" class="xl27">#LSCurrencyFormat(rsDatos.Creditos,'none')#</td>
								<td nowrap align="right" class="xl27">#LSCurrencyFormat(rsDatos.SaldoIncial + rsDatos.Debitos - rsDatos.Creditos,'none')#</td>
							<cfelse>
								<td nowrap class="xl28">#rsCuentasContables.FormatoCuenta#</td>
								<td nowrap class="xl28" >#rsCuentasContables.Descripcion#</td>
								<td nowrap align="right" class="xl28">#LSCurrencyFormat(rsDatos.SaldoIncial,'none')#</td>
								<td nowrap align="right" class="xl28">#LSCurrencyFormat(rsDatos.Debitos,'none')#</td>
								<td nowrap align="right" class="xl28">#LSCurrencyFormat(rsDatos.Creditos,'none')#</td>
								<td nowrap align="right" class="xl28">#LSCurrencyFormat(rsDatos.SaldoIncial + rsDatos.Debitos - rsDatos.Creditos,'none')#</td>
							</cfif>
						</tr> 
					<cfif rsCuentasContables.Detalle EQ 1 and TipoFormato NEQ 4>
						 <cfquery name="rsDetalle" datasource="#session.Conta.dsn#">
							select <cfswitch expression="#TipoFormato#">
									<cfcase value="1">
										<cfif incsucursal EQ 1>
											t.CGE5COD as Segmento,
										</cfif>
										t.CGTPER as Ano, t.CGTMES as Mes, t.CG5CON as Asiento, t.CGTBAT as Consecutivo, 
										sum(case when t.CGTTIP = 'D' then t.CGTMON else 0.00 end) as Debitos,
										sum(case when t.CGTTIP = 'C' then t.CGTMON else 0.00 end) as Creditos
										from 	#archivotbl# c, CGT002 t (index CGT00202)
									</cfcase>
									<cfcase value="2">
										<cfif incsucursal EQ 1>
											t.CGE5COD as Segmento,
										</cfif>
										t.CTSPER as Ano, t.CTSMES as Mes, 
										sum(CTSDEB) as Debitos, sum(CTSCRE) as Creditos
										from 	#archivotbl# c, CGM007 t (index CGM00700)
									</cfcase>
									<cfcase value="3">
										<cfif incsucursal EQ 1>
											t.CGE5COD as Segmento,
										</cfif>
										t.CTSPER as Ano, t.CTSMES as Mes, t.CG5CON as Asiento, 
										sum(CTSDEB) as Debitos, sum(CTSCRE) as Creditos
										from 	#archivotbl# c, CGM007 t (index CGM00700)
										</cfcase>
								</cfswitch>	
							where 	c.rptid = #llave#
							  and c.CuentaMayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentasContables.CuentaMayor#">
							  and t.CGM1ID = c.CuentaDetalle
							<cfif TipoFormato EQ "1">
							  and t.CGTPER = <cfqueryparam cfsqltype="cf_sql_integer" value="#anoini#">
							  and t.CGTMES >= <cfqueryparam cfsqltype="cf_sql_integer" value="#mesini#"> 
							  and t.CGTMES <= <cfqueryparam cfsqltype="cf_sql_integer" value="#mesfin#">
							  and t.CGTPER * 100 + t.CGTMES between <cfqueryparam cfsqltype="cf_sql_integer" value="#anoini#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#mesini#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#anofin# "> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#mesfin#">
							<cfelse>
							  and t.CTSPER = <cfqueryparam cfsqltype="cf_sql_integer" value="#anoini#">
							  and t.CTSMES >= <cfqueryparam cfsqltype="cf_sql_integer" value="#mesini#"> 
							  and t.CTSMES <= <cfqueryparam cfsqltype="cf_sql_integer" value="#mesfin#">
							  and t.CTSPER * 100 + t.CTSMES between <cfqueryparam cfsqltype="cf_sql_integer" value="#anoini#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#mesini#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#anofin# "> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#mesfin#">
							</cfif>  
							<cfif len(strAsientos) GT 0>
								and t.CG5CON in (#strAsientos#)
							</cfif>
							<cfif len(strSucursales) GT 0>
									and t.CGE5COD in (#preservesinglequotes(strSucursales)#)
							</cfif>	
							<cfswitch expression="#TipoFormato#">
									<cfcase value="1">
										group by 
										<cfif incsucursal EQ 1>
											t.CGE5COD,
										</cfif>
										t.CGTPER, t.CGTMES, t.CG5CON, t.CGTBAT
									</cfcase>
									<cfcase value="2">
										group by 
										<cfif incsucursal EQ 1>
											t.CGE5COD,
										</cfif>
										t.CTSPER, t.CTSMES
										having sum(CTSDEB) != 0.00 or sum(CTSCRE) != 0.00
									</cfcase>										
									<cfcase value="3">
										group by 
										<cfif incsucursal EQ 1>
											t.CGE5COD,
										</cfif>
										t.CTSPER, t.CTSMES, t.CG5CON
										having sum(CTSDEB) != 0.00 or sum(CTSCRE) != 0.00
									</cfcase>										
							</cfswitch>
							at isolation 0
						</cfquery>	
						<cfif TipoFormato NEQ 4>
							<cfif rsDetalle.RecordCount GT 0>
								<tr>
									<td nowrap>&nbsp;</td>
									<td nowrap  align="right" colspan="4">
										<table width="80%" cellpadding="0" cellspacing="0" border="1" >
											<cfset contador = contador + 1>
											<!--- <!--- <cfdump var="#contador#"> ---> --->
											<tr>
												<cfswitch expression="#TipoFormato#">
													<cfcase value="1">
														<cfif incsucursal EQ 1>
															<td nowrap width="10%" align="right" class="xl25">Seg</td>
														</cfif>
														<td nowrap  width="10%" align="right" class="xl25">A&ntilde;o</td>
														<td nowrap  width="10%" align="right" class="xl25">Mes</td>
														<td nowrap  width="10%" align="right" class="xl25">Asiento</td>
														<td nowrap  width="10%" align="right" class="xl25">Consecutivo</td>
														<td nowrap  width="20%" align="right" class="xl25">D&eacute;bitos</td>
														<td nowrap  width="25%" align="right" class="xl25">Cr&eacute;ditos</td>
													</cfcase>
													<cfcase value="2">
														<cfif incsucursal EQ 1>
															<td nowrap width="10%" align="right" class="xl25">Seg</td>
														</cfif>
														<td nowrap  width="20%" align="right" class="xl25">A&ntilde;o</td>
														<td nowrap  width="20%" align="right" class="xl25">Mes</td>
														<td nowrap  width="20%" align="right" class="xl25">D&eacute;bitos</td>
														<td nowrap  width="20%"align="right" class="xl25">Cr&eacute;ditos</td>
													</cfcase>
													<cfcase value="3">
														<cfif incsucursal EQ 1>
															<td nowrap  width="10%" align="right" class="xl25">Seg</td>
														</cfif>
														<td nowrap  width="10%" align="right" class="xl25">A&ntilde;o</td>
														<td nowrap  width="10%" align="right" class="xl25">Mes</td>
														<td nowrap  width="20%" align="right" class="xl25">Asiento</td>
														<td nowrap  width="20%"align="right" class="xl25">D&eacute;bitos</td>
														<td nowrap  width="20%"align="right" class="xl25">Cr&eacute;ditos</td>
													</cfcase>
												</cfswitch>	
											</tr>
											<cfloop query="rsDetalle">
												<cfset contador = contador + 1>
												<!--- <cfdump var="#contador#"> --->
												<tr>
													<cfswitch expression="#TipoFormato#">
														<cfcase value="1">
															<cfif incsucursal EQ 1>
																<td nowrap align="right" class="xl29">#rsDetalle.Segmento#</td>
															</cfif>
															<td nowrap align="right" class="xl28">#rsDetalle.Ano#</td>
															<td nowrap align="right" class="xl28">#rsDetalle.Mes#</td>
															<td nowrap align="right" class="xl28">#rsDetalle.Asiento#</td>														
															<td nowrap align="right" class="xl28">#rsDetalle.Consecutivo#</td>														
															<td nowrap align="right" class="xl28">#LSCurrencyFormat(rsDetalle.Debitos,'none')#</td>
															<td nowrap align="right" class="xl28">#LSCurrencyFormat(rsDetalle.Creditos,'none')#</td>
														</cfcase>
														<cfcase value="2">
															<cfif incsucursal EQ 1>
																<td nowrap align="right" class="xl29">#rsDetalle.Segmento#</td>
															</cfif>
															<td nowrap align="right" class="xl28">#rsDetalle.Ano#</td>
															<td nowrap align="right" class="xl28">#rsDetalle.Mes#</td>
															<td nowrap align="right" class="xl28">#LSCurrencyFormat(rsDetalle.Debitos,'none')#</td>
															<td nowrap align="right" class="xl28">#LSCurrencyFormat(rsDetalle.Creditos,'none')#</td>
														</cfcase>
														<cfcase value="3">
															<cfif incsucursal EQ 1>
																<td nowrap align="right" class="xl29">#rsDetalle.Segmento#</td>
															</cfif>
															<td nowrap align="right" class="xl28">#rsDetalle.Ano#</td>
															<td nowrap align="right" class="xl28">#rsDetalle.Mes#</td>
															<td nowrap align="right" class="xl28">#rsDetalle.Asiento#</td>														
															<td nowrap align="right" class="xl28">#LSCurrencyFormat(rsDetalle.Debitos,'none')#</td>
															<td nowrap align="right" class="xl28">#LSCurrencyFormat(rsDetalle.Creditos,'none')#</td>
														</cfcase>
													</cfswitch>	
												</tr>
												<cfif contador GT 60>
													<tr><td><H1 class=Corte_Pagina></H1></td></tr>
													<cfset contador = 1>
													<!--- <cfdump var="#contador#"> --->
													<tr>
														<cfswitch expression="#TipoFormato#">
															<cfcase value="1">
																<cfif incsucursal EQ 1>
																	<td nowrap width="10%" align="right" class="xl25">Seg</td>
																</cfif>
																<td nowrap  width="10%" align="right" class="xl25">A&ntilde;o</td>
																<td nowrap  width="10%" align="right" class="xl25">Mes</td>
																<td nowrap  width="10%" align="right" class="xl25">Asiento</td>
																<td nowrap  width="10%" align="right" class="xl25">Consecutivo</td>
																<td nowrap  width="20%" align="right" class="xl25">D&eacute;bitos</td>
																<td nowrap  width="25%" align="right" class="xl25">Cr&eacute;ditos</td>
															</cfcase>
															<cfcase value="2">
																<cfif incsucursal EQ 1>
																	<td nowrap width="10%" align="right" class="xl25">Seg</td>
																</cfif>
																<td nowrap  width="20%" align="right" class="xl25">A&ntilde;o</td>
																<td nowrap  width="20%" align="right" class="xl25">Mes</td>
																<td nowrap  width="20%" align="right" class="xl25">D&eacute;bitos</td>
																<td nowrap  width="20%"align="right" class="xl25">Cr&eacute;ditos</td>
															</cfcase>
															<cfcase value="3">
																<cfif incsucursal EQ 1>
																	<td nowrap  width="10%" align="right" class="xl25">Seg</td>
																</cfif>
																<td nowrap  width="10%" align="right" class="xl25">A&ntilde;o</td>
																<td nowrap  width="10%" align="right" class="xl25">Mes</td>
																<td nowrap  width="20%" align="right" class="xl25">Asiento</td>
																<td nowrap  width="20%"align="right" class="xl25">D&eacute;bitos</td>
																<td nowrap  width="20%"align="right" class="xl25">Cr&eacute;ditos</td>
															</cfcase>
														</cfswitch>	
													</tr>
												</cfif>
												<cfflush interval="1024"> 
											</cfloop>
										</table>
									</td>
									<td nowrap>&nbsp;</td>
								</tr>
							</cfif>
						</cfif>
					</cfif>
					</cfif>
					<cfif contador GT 60>
						<tr><td><H1 class=Corte_Pagina></H1></td></tr>						
						<cfset contador = 1>
						<!--- <cfdump var="#contador#"> --->
						<tr>
							<td nowrap class="xl25">Cuenta</td>
							<td nowrap class="xl25">Descripci&oacute;n</td>
							<td nowrap align="right" class="xl25">Inicial</td>
							<td nowrap align="right" class="xl25">D&eacute;bitos</td>
							<td nowrap align="right" class="xl25">Cr&eacute;ditos</td>
							<td nowrap align="right" class="xl25">Final</td>
						</tr>
					</cfif>
					<cfflush interval="1024"> 
				</cfloop>
			</table>
		</td>
	</tr>
	<tr><td><hr></td></tr>
	<tr>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0" border="0" >
				<tr><td  colspan="6"  align="center" class="xl25">Par&aacute;metros</td></tr>
				<tr>
					<td colspan="3"  align="left"   class="xl25">Cuentas:</td>
					<td colspan="3"   align="right" class="xl25">Asientos Fijos:</td>
				</tr>

				<cfset LarrAsientos = ListToarray(AsieContidList)>
				<cfset cantAsientos = ArrayLen(LarrAsientos)>
				<cfif Id_Reporte neq 3>
						<cfset LarrCuentas = ListToarray(CUENTASLIST)>
				<cfelse>
						<cfset LarrCuentas = ListToarray(CUENTAIDLIST)>
				</cfif>
				<cfset cantCuentas = ArrayLen(LarrCuentas)>
				<cfif cantAsientos gt cantCuentas>
					<cfset cantmax = cantAsientos>
				<cfelse>
					<cfset cantmax = cantCuentas>
				</cfif>

				<cfloop index="i" from="1" to="#cantmax#">
					<cfif i lte cantAsientos>
						<cfquery name="rsDesAsiento" datasource="#session.Conta.dsn#">
							select CG5DES
							from CGM005
							where CG5CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#LarrAsientos[i]#">
						</cfquery> 	
					</cfif>
				
					<tr>
						<td width="11%">&nbsp;</td>
						<cfif i lte cantCuentas>
							<cfif Id_Reporte eq 3>
								<td colspan="3"  align="left" class="xl28">#mid(LarrCuentas[i],1,3)# #mid(LarrCuentas[i],4,len(LarrCuentas[i]))#</td>
							<cfelse>
								<cfset arreglo = listtoarray(LarrCuentas[i],"¶")>	
								<cfset cuenta = "#arreglo[1]#">
								<td colspan="3"  align="left" class="xl28">#mid(cuenta,1,3)# #mid(cuenta,4,len(cuenta))#</td>
							</cfif>
						<cfelse>
							<td colspan="3"  align="left" >&nbsp;</td>
						</cfif>
						
						<cfif i lte cantAsientos>
							<td width="41%">
								<table width="100%" cellpadding="0" cellspacing="0" border="0">
									<tr>
										<td   align="right" colspan="3" nowrap class="xl28">#LarrAsientos[i]#&nbsp;-&nbsp;#rsDesAsiento.CG5DES#</td>
									</tr>
								</table>
							</td>
						<cfelse>
							<td width="41%">&nbsp;</td>
						</cfif>
					</tr>
				</cfloop>	
			</table>
		</td>
	</tr>
	<tr><td><hr></td></tr>
	<tr><td>&nbsp;</td></tr>
</table>
<!--- </cfsavecontent>
<cfoutput>#micontenido#</cfoutput>
<cfset tempfile = GetTempDirectory()>
<cffile action="write" file="#tempfile#/#session.usuario#.xls" output="#micontenido#" >
 ---></cfoutput>
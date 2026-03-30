<cfsetting requesttimeout="600">
<!---******************************************************************************************** --->
<!--- AREA DE QUERY´S --->
<cfquery name="rsDesSeg0" datasource="#session.Conta.dsn#">
		select a.CGE5COD as CGE5COD, a.CGE5DES as CGE5DES 
		from CGE005 a, CGE000 b
		where a.CGE1COD = b.CGE1COD
		<cfif form.segmento neq 'T'>			
			and a.CGE5COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Segmento#">
		</cfif>
		union all
		select cod_suc as CGE5COD, CGE5DES as CGE5DES
		from anex_sucursal a
		<cfif form.segmento neq 'T'>			
		  where cod_suc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Segmento#">
		</cfif>
</cfquery>
<cfquery name="rsDesSeg1" datasource="#session.Conta.dsn#">
		select a.CGE5COD as CGE5COD, a.CGE5DES as CGE5DES 
		from CGE005 a, CGE000 b
		where a.CGE1COD = b.CGE1COD
		<cfif form.segmento neq 'T'>			
			and a.CGE5COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Segmento#">
		</cfif>
		<cfif form.segmento neq 'T'>			
			union all
			select a.CGE5COD, CGE5DES as CGE5DES
			from anex_sucursald a, CGE005 b, CGE000 c
			where a.CGE5COD = b.CGE5COD  
			  and b.CGE1COD = c.CGE1COD
			  and cod_suc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Segmento#">
		</cfif>
</cfquery>
<cfset strSucursales = "">
<cfset strarreglo = "">
<cfif not isdefined ("form.ID_incsucursal")>
	<cfloop query="rsDesSeg1" >
		<cfset strSucursales = "#strSucursales#" & "'" & #rsDesSeg1.CGE5COD# & "'" >
		<cfif rsDesSeg1.currentrow lt rsDesSeg1.recordcount>
			<cfset strSucursales = strSucursales & ",">
		</cfif>	
	</cfloop>
	<cfset strarreglo = "xxx">
<cfelse>
	<cfloop query="rsDesSeg1" >
		<cfset strarreglo = "#strarreglo#" & #rsDesSeg1.CGE5COD# & "¶"  & #rsDesSeg1.CGE5DES# >
		<cfif rsDesSeg1.currentrow lt rsDesSeg1.recordcount>
			<cfset strarreglo = strarreglo & ",">
		</cfif>	
	</cfloop>
</cfif>
<cfset arrSucursales = ListToarray(strarreglo)>

<cfquery name="rscuentas" datasource="#session.Conta.dsn#">
	select 
		a.CGM1IM as Mayor, 
		substring(a.CTADES, 1, 50) as Nombre,
		a.CGM1ID as Cuenta
	from CGM001 a
	where a.CGM1CD is null
	order by CGM1IM
	at isolation 0
</cfquery>

<cfif form.segmento neq 'T'>
	<cfif rsDesSeg1.RecordCount GT 0>
		<cfset DesSegmento = #rsDesSeg0.CGE5DES#>
	<cfelse>
		<cfset DesSegmento = "">
	</cfif>
</cfif>
<!---******************************************************************************************** --->
<!--- Asigna variables default --->
<cfif isdefined("form.ID_INCSUCURSAL") and len(trim(form.ID_INCSUCURSAL))>
	<cfset incsucursal = 1>
<cfelse>
	<cfset incsucursal = 0>
</cfif>

<cfset TituloReporte = "Reporte Balance de Comprobación">

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

<cfset contador 		= 10>
<cfset TOTALSALDOINI 	= 0>
<cfset TOTALDEBITOS 	= 0>
<cfset TOTALCREDITOS 	= 0>
<cfset TOTALSALDOFIN 	= 0>
<cfset TOTALSALDOINIPER = 0>
<cfset TOTALSALDOFINPER = 0>

<cfoutput> 
<script language="javascript1.2" type="text/javascript">
	function regresar() {
		document.location = "../reportes/cmn_Comprobacion.cfm";
	}

	function imprimir() {
		var tablabotones = document.getElementById("tablabotones");
        tablabotones.style.display = 'none';
		window.print()	
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
 <cfsavecontent variable="micontenido">
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
	font-size:8.0pt;
	font-weight:700;
	text-align:center;
	background:silver;
	mso-pattern:auto none;
	white-space:normal;}
.xl25L
	{mso-style-parent:style0;
	font-size:8.0pt;
	font-weight:700;
	text-align:left;
	background:silver;
	mso-pattern:auto none;
	white-space:normal;}
.xl25R
	{mso-style-parent:style0;
	font-size:8.0pt;
	font-weight:700;
	text-align:right;
	background:silver;
	mso-pattern:auto none;
	white-space:normal;}
.xl26
	{mso-style-parent:style0;
	font-size:8.0pt;
	font-weight:700;
	text-align: center;
	font-family:Arial, sans-serif;
	mso-font-charset:0;}
.xl27
	{mso-style-parent:style0;
	font-size:7.5pt;
	font-weight:bold;
	text-align:right;
	font-family:Arial, sans-serif;
	mso-font-charset:0;}
.xl28R
	{mso-style-parent:style0;
	font-size:7.5pt;
	text-align:right;
	font-family:Arial, sans-serif;
	mso-font-charset:0;}


.xl28L
	{mso-style-parent:style0;
	font-size:7.5pt;
	text-align: left;
	font-family:Arial, sans-serif;
	mso-number-format:"\@";}
.xl28LS
	{mso-style-parent:style0;
	font-size:6.0pt;
	text-align: left;
	font-family:Arial, sans-serif;
	mso-number-format:"\@";}	
	
.xl29
	{mso-style-parent:style0;
	font-size:7.5pt;
	font-family:Arial, sans-serif;
	mso-number-format:"\@";}
.xl30
	{mso-style-parent:style0;
	font-size:8.0pt;
	font-weight:bold;
	text-align:left;
	mso-pattern:auto none;
	white-space:normal;}
-->
</style>
<table width="100%" cellpadding="0" cellspacing="0" border="0" >

	<tr><td  colspan="8" align="center" class="xl25">INSTITUTO COSTARRICENSE DE ELECTRICIDAD</td></tr>
	<tr><td  colspan="8" align="center" class="xl25">#TituloReporte#</td></tr>
	<tr><td  colspan="8" align="center" class="xl25">De #MesInicial# #form.AnoInicial# a #MesFinal# #form.AnoInicial#</td></tr>
	<tr><td colspan="8"><hr></td></tr>
	<tr><td  align="center" colspan="8"  class="xl26">Segmento:&nbsp;<cfif form.segmento eq 'T'>Todos<cfelse>#form.segmento# - #DesSegmento#</cfif></td></tr>
	<cfif not isdefined ("form.ID_incsucursal")>
			<tr>
				<td colspan="6" class="xl25"></td>
				<td colspan="1" class="xl25R">Débitos</td>
				<td colspan="1" class="xl25R">Créditos</td>
			</tr>		
			<tr>
				<td width="10%" colspan="2" class="xl25L" >Cuenta</td>
				<td width="13%"  colspan="1" class="xl25R" >Inicial</td>
				<td width="10%"  colspan="1" class="xl25R" >Débitos</td>
				<td width="10%"  colspan="1" class="xl25R" >Créditos</td>
				<td width="13%"  colspan="1" class="xl25R" >Final</td>
				<td width="12%"  colspan="1" class="xl25R" >#form.AnoInicial#</td>
				<td width="12%"  colspan="1" class="xl25R" >#form.AnoInicial#</td>
		</tr>
	</cfif>

	<cfloop from="1" to ="#arraylen(arrSucursales)#" index="i">
		<cfset TOTALSALDOINI 	= 0.00>
		<cfset TOTALDEBITOS 	= 0.00>
		<cfset TOTALCREDITOS 	= 0.00>
		<cfset TOTALSALDOFIN 	= 0.00>
		<cfset TOTALSALDOINIPER = 0.00>
		<cfset TOTALSALDOFINPER = 0.00>
		<cfset arreglo2 = listtoarray(arrSucursales[i],"¶")>
		<cfif isdefined ("form.ID_incsucursal")>
			<tr>
				<td colspan="1" class="xl30" >#arreglo2[1]#</td>
				<td colspan="1" class="xl30" >#arreglo2[2]#</td>
			</tr>
			<tr>
				<td colspan="6" class="xl25"></td>
				<td colspan="1" class="xl25R">Débitos</td>
				<td colspan="1" class="xl25R">Créditos</td>
			</tr>
			<tr>
				<td width="10%" colspan="2" class="xl25L" >Cuenta</td>
				<td width="13%"  colspan="1" class="xl25R" >Inicial</td>
				<td width="10%"  colspan="1" class="xl25R" >Débitos</td>
				<td width="10%"  colspan="1" class="xl25R" >Créditos</td>
				<td width="13%"  colspan="1" class="xl25R" >Final</td>
				<td width="12%"  colspan="1" class="xl25R" >#form.AnoInicial#</td>
				<td width="12%"  colspan="1" class="xl25R" >#form.AnoInicial#</td>
			</tr>
		</cfif>
		<cfloop query="rscuentas">
			<cfquery name="rsDatos" datasource="#session.Conta.dsn#">
				select 
					coalesce((
						select sum(s.CTSSAN) 
						from CGM004 s
						where s.CGM1ID = #rscuentas.Cuenta#
						  and s.CTSPER = #form.AnoInicial#
						  and s.CTSMES = #form.MesInicial#
						  <cfif not isdefined ("form.ID_incsucursal")>
						  		and s.CGE5COD in (#PreserveSingleQuotes(strSucursales)#)
						  <cfelse>
						  		and s.CGE5COD = '#arreglo2[1]#'
						  </cfif>
						),0.00) SaldoInicial,
		
					coalesce((
						select sum(s.CTSDEB) 
						from CGM004 s
						where s.CGM1ID = #rscuentas.Cuenta#
						  and s.CTSPER = #form.AnoInicial#
						  and s.CTSMES >= #form.MesInicial#
						  and s.CTSMES <= #form.MesFinal#
						  <cfif not isdefined ("form.ID_incsucursal")>
						  		and s.CGE5COD in (#PreserveSingleQuotes(strSucursales)#)
						  <cfelse>
						  		and s.CGE5COD = '#arreglo2[1]#'
						  </cfif>
						), 0.00) Debitos,
		
		
					coalesce((
						select sum(s.CTSCRE) 
						from CGM004 s
						where s.CGM1ID = #rscuentas.Cuenta#
						  and s.CTSPER = #form.AnoInicial#
						  and s.CTSMES >= #form.MesInicial#
						  and s.CTSMES <= #form.MesFinal#
						  <cfif not isdefined ("form.ID_incsucursal")>
						  		and s.CGE5COD in (#PreserveSingleQuotes(strSucursales)#)
						  <cfelse>
						  		and s.CGE5COD = '#arreglo2[1]#'
						  </cfif>
						), 0.00) Creditos,
		
					coalesce((
						select sum(s.CTSDEB) 
						from CGM004 s
						where s.CGM1ID = #rscuentas.Cuenta#
						  and s.CTSPER = #form.AnoInicial#
						  and s.CTSMES <= #form.MesFinal#
						  <cfif not isdefined ("form.ID_incsucursal")>
						  		and s.CGE5COD in (#PreserveSingleQuotes(strSucursales)#)
						  <cfelse>
						  		and s.CGE5COD = '#arreglo2[1]#'
						  </cfif>
						), 0.00) DebitosPer,
		
		
					coalesce((
						select sum(s.CTSCRE) 
						from CGM004 s
						where s.CGM1ID = #rscuentas.Cuenta#
						  and s.CTSPER = #form.AnoInicial#
						  and s.CTSMES <= #form.MesFinal#
						  <cfif not isdefined ("form.ID_incsucursal")>
						  		and s.CGE5COD in (#PreserveSingleQuotes(strSucursales)#)
						  <cfelse>
						  		and s.CGE5COD = '#arreglo2[1]#'
						  </cfif>
						), 0.00) CreditosPer
				at isolation 0
			</cfquery>
			<cfif rsDatos.SaldoInicial NEQ 0.00 or rsDatos.Debitos NEQ 0.00 or rsDatos.Creditos NEQ 0.00 or rsDatos.DebitosPer NEQ 0.00 or rsDatos.CreditosPer NEQ 0.00>					
				<tr>			
					<td colspan="1" class="xl28L" >#rscuentas.Mayor#</td>
					<td colspan="1" class="xl28L" >#rscuentas.Nombre#</td>
					<td colspan="1" class="xl28R" >#LSCurrencyFormat(rsDatos.SaldoInicial,'none')#</td>
					<td colspan="1" class="xl28R" >#LSCurrencyFormat(rsDatos.Debitos,'none')#</td>
					<td colspan="1" class="xl28R" >#LSCurrencyFormat(rsDatos.Creditos,'none')#</td>
					<td colspan="1" class="xl28R" >#LSCurrencyFormat(rsDatos.SaldoInicial +(rsDatos.Debitos-rsDatos.Creditos),'none')#</td>
					<td colspan="1" class="xl28R" >#LSCurrencyFormat(rsDatos.DebitosPer,'none')#</td>
					<td colspan="1" class="xl28R" >#LSCurrencyFormat(rsDatos.CreditosPer,'none')#</td>
				</tr>
				<cfset TOTALSALDOINI 	= TOTALSALDOINI 	+ rsDatos.SaldoInicial>
				<cfset TOTALDEBITOS 	= TOTALDEBITOS 		+ rsDatos.Debitos>
				<cfset TOTALCREDITOS 	= TOTALCREDITOS 	+ rsDatos.Creditos>
				<cfset TOTALSALDOFIN 	= TOTALSALDOFIN 	+ rsDatos.SaldoInicial + rsDatos.Debitos  - rsDatos.Creditos>
				<cfset TOTALSALDOINIPER = TOTALSALDOINIPER 	+ rsDatos.DebitosPer>
				<cfset TOTALSALDOFINPER = TOTALSALDOFINPER 	+ rsDatos.CreditosPer>		
				<cfset contador = contador + 1>
				<cfif contador GT 60>
					<tr><td><H1 class=Corte_Pagina></H1></td></tr>
					<cfset contador = 10>
					<cfif isdefined ("form.ID_incsucursal")>
						<tr>
							<td colspan="1" class="xl30" >#arreglo2[1]#</td>
							<td colspan="1" class="xl30" >#arreglo2[2]#</td>
						</tr>
					</cfif>
					<tr> 
						<td colspan="6" class="xl25"></td>
						<td colspan="1" class="xl25R">Periodo</td>
						<td colspan="1" class="xl25R">Periodo</td>
					</tr>
					<tr>
						<td width="10%" colspan="1" class="xl25L" >Cta. Mayor</td>
						<td width="20%" colspan="1" class="xl25L" >Descripción</td>
						<td width="10%"  colspan="1" class="xl25R" >Inicial</td>
						<td width="10%"  colspan="1" class="xl25R" >Débitos</td>
						<td width="10%"  colspan="1" class="xl25R" >Créditos</td>
						<td width="10%"  colspan="1" class="xl25R" >Final</td>
						<td width="10%"  colspan="1" class="xl25R" >Débitos</td>
						<td width="10%"  colspan="1" class="xl25R" >Créditos</td>
					</tr>
				</cfif>
			</cfif>
		</cfloop>
		<tr>			
			<td colspan="2" class="xl25L" >Total</td>
			<td colspan="1" class="xl25R" >#LSCurrencyFormat(TOTALSALDOINI,'none')#</td>
			<td colspan="1" class="xl25R" >#LSCurrencyFormat(TOTALDEBITOS,'none')#</td>
			<td colspan="1" class="xl25R" >#LSCurrencyFormat(TOTALCREDITOS,'none')#</td>
			<td colspan="1" class="xl25R" >#LSCurrencyFormat(TOTALSALDOFIN,'none')#</td>
			<td colspan="1" class="xl25R" >#LSCurrencyFormat(TOTALSALDOINIPER,'none')#</td>
			<td colspan="1" class="xl25R" >#LSCurrencyFormat(TOTALSALDOFINPER,'none')#</td>
		</tr>
		<tr><td colspan="8"><hr></td></tr>
		<tr><td><H1 class=Corte_Pagina></H1></td></tr>
		<cfset contador =10>
	</cfloop>
	<tr><td>&nbsp;</td></tr>
</table>
</cfsavecontent>
#micontenido# 
<cfset tempfile = GetTempDirectory()>

<cffile action="write" file="#tempfile#/tmp_#session.usuario#.xls" output="#micontenido#" nameconflict="overwrite">
</cfoutput>
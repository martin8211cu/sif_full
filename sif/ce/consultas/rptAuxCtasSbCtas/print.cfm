<cfset navegacion = "">
<cfif isdefined("url.modo") and len(trim(url.modo)) >
	<cfset navegacion = navegacion & "modo=#url.modo#">
</cfif>
<cfif isdefined("url.periodo") and len(trim(url.periodo)) >
	<cfset navegacion = navegacion & "&periodo=#url.periodo#">
</cfif>
<cfif isdefined("url.mes") >
	<cfset navegacion = navegacion & "&mes=#url.mes#">
</cfif>
<cfif isdefined("url.ctainicial") >
	<cfset navegacion = navegacion & "&ctainicial=#url.ctainicial#">
</cfif>
<cfif isdefined("url.ctafinal") >
	<cfset navegacion = navegacion & "&ctafinal=#url.ctafinal#">
</cfif>
<cfif isdefined("url.sinsaldoscero") >
	<cfset navegacion = navegacion & "&sinsaldoscero=true">
</cfif>
<cfif isdefined("url.fechaIni")>
	<cfset navegacion = navegacion & "&fechaIni=#url.fechaIni#">
</cfif>
<cfif isdefined("url.fechaFin")>
	<cfset navegacion = navegacion & "&fechaFin=#url.fechaFin#">
</cfif>

<cfset LvarLineasPagina = 55>
<cfset LvarPAg = 1>
<cfset LvarContL = 5>
<cfset LvarMeses = arrayNew(1)>
<cfset LvarMeses[1] = "ENERO">
<cfset LvarMeses[2] = "FEBRERO">
<cfset LvarMeses[3] = "MARZO">
<cfset LvarMeses[4] = "ABRIL">
<cfset LvarMeses[5] = "MAYO">
<cfset LvarMeses[6] = "JUNIO">
<cfset LvarMeses[7] = "JULIO">
<cfset LvarMeses[8] = "AGOSTO">
<cfset LvarMeses[9] = "SETIEMBRE">
<cfset LvarMeses[10] = "OCTUBRE">
<cfset LvarMeses[11] = "NOVIEMBRE">
<cfset LvarMeses[12] = "DICIEMBRE">

<cf_htmlReportsHeaders
	title="Reporte Auxiliar de Cuentas y/o Subcuentas"
	filename="rptAuxiliarCtas_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls"
	irA="/cfmx/sif/ce/consultas/rptAuxCtasSbCtas/list.cfm"
	>
<cf_templatecss>

	<cfset navegacion = navegacion & "&periodo=#form.periodo#">
	<cfset navegacion = navegacion & "&mes=#form.mes#">
	<cfquery name="rsConsulta" datasource="#Session.DSN#">
		SELECT cc.Ccuenta, cc.Cformato as cuenta,
		       det.SLinicial as saldoInicial,
		       (det.SLinicial + det.DLdebitos - det.CLcreditos) as saldoFinal,
		       det.CEBperiodo, det.CEBmes
		FROM CContables cc,
		     CEBalanzaSAT ba,
		     CEBalanzaDetSAT det,
		     HEContables he,
		     HDContables hd
		WHERE cc.Ccuenta = det.Ccuenta
		  AND cc.Ccuenta = hd.Ccuenta
  	      AND hd.IDcontable = he.IDcontable
		  AND det.CEBalanzaId = ba.CEBalanzaId
		  AND ba.CEBperiodo = det.CEBperiodo
		  AND ba.CEBmes = det.CEBmes
		  AND ba.CEBperiodo = he.Eperiodo
		  AND ba.CEBmes = he.Emes
		  AND ba.CEBperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.periodo#">
		  AND ba.CEBmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mes#">
		  and ba.GEid = -1
		  <cfif isDefined("form.ctainicial") AND #form.ctainicial# NEQ "">
		    AND cc.Cformato >= <cfqueryparam value="#Trim(form.ctainicial)#" cfsqltype="cf_sql_varchar">
		  	<cfset navegacion = navegacion & "&ctainicial=#form.ctainicial#">
		  </cfif>
		  <cfif isDefined("form.ctafinal") AND #form.ctafinal# NEQ "">
		  	AND cc.Cformato <= <cfqueryparam value="#Trim(form.ctafinal)#" cfsqltype="cf_sql_varchar">
		  	<cfset navegacion = navegacion & "&ctafinal=#form.ctafinal#">
		  </cfif>
		  <cfif isDefined("form.sinsaldoscero") AND #form.sinsaldoscero# EQ "on">
		  	AND det.SLinicial != 0 AND (det.SLinicial + det.DLdebitos - det.CLcreditos) != 0
		  	<cfset navegacion = navegacion & "&sinsaldoscero=true">
		  </cfif>
		  <cfif isDefined("form.fechaIni") AND #form.fechaIni# NEQ "">
		  	AND he.ECfechacreacion >= <cfqueryparam value="#form.fechaIni#" cfsqltype="cf_sql_date">
		  	<cfset navegacion = navegacion & "&fechaIni=#form.fechaIni# ">
		  </cfif>
		  <cfif isDefined("form.fechaFin") AND #form.fechaFin# NEQ "">
		  	AND he.ECfechacreacion <= <cfqueryparam value="#form.fechaFin#" cfsqltype="cf_sql_date">
		  	<cfset navegacion = navegacion & "&fechaFin=#form.fechaFin#">
		  </cfif>
		GROUP BY cc.Ccuenta,
         cc.Cformato,
         det.SLinicial,
         (det.SLinicial + det.DLdebitos - det.CLcreditos),
         det.CEBperiodo,
         det.CEBmes
		ORDER BY cc.Cformato
	</cfquery>

<cfoutput>
	<div align="center">
		<!--- <cfset sbGeneraEstilos()> --->
	<cfset Encabezado()>
	<br>
	<cfset Creatabla()>
	<cfset titulos()>
	<cfflush interval="512">
	<cfset LvarCtaAnt = "">
	<cfloop query="rsConsulta" >
			<cfset sbCortePagina()>
			<tr>
				<td align="center" width="50%" class="Datos">#rsConsulta.cuenta#</td>
				<td align="right" class="Datos" >#LSNumberFormat(rsConsulta.saldoInicial,',9.00')#</td>
				<td align="right" class="Datos" >#LSNumberFormat(rsConsulta.saldoFinal,',9.00')#</td>
			</tr>
	</cfloop>
		<cfset Cierratabla()>
		</body>
	</html>
	</div>
</cfoutput>

<cffunction name="Encabezado" output="true">
	<table width="100%" border="0">
		<tr>
			<td  class="Header1" colspan="3" align="center">
				<strong>#ucase(session.Enombre)#</strong>
			</td>
		</tr>
		<tr>
			<td  class="Header1" colspan="3" align="center"><strong>REPORTE AUXILIAR DE CUENTAS Y/O SUBCUENTAS</strong></td>
		</tr>
		<tr>
			<td class="Header" colspan="3" align="center"><strong>PERIODO: #form.periodo#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			MES: #LvarMeses[form.mes]#</strong></td>
		</tr>
		<!--- <cfdump var="#form.sinsaldoscero#"> --->
		<cfif isDefined("form.sinsaldoscero") AND #form.sinsaldoscero# EQ "on">
			<tr>
			<td class="Header" colspan="3" align="center"><strong>SIN SALDOS CERO</strong></td>
		</tr>
		</cfif>
		<cfif isDefined("form.ctainicial") AND #form.ctainicial# NEQ "">
			<tr>
			<td class="Header" colspan="3" align="center"><strong>CUENTA INICIAL: #Trim(form.ctainicial)#</strong></td>
		</tr>
		</cfif>
		<cfif isDefined("form.ctafinal") AND #form.ctafinal# NEQ "">
			<tr>
			<td class="Header" colspan="3" align="center"><strong>CUENTA FINAL: #Trim(form.ctafinal)#</strong></td>
		</tr>
		</cfif>
		<cfif isDefined("form.fechaIni") AND #form.fechaIni# NEQ "">
			<tr>
			<td class="Header" colspan="3" align="center"><strong>FECHA INICIAL: #Trim(form.fechaIni)#</strong></td>
		</tr>
		</cfif>
		<cfif isDefined("form.fechaFin") AND #form.fechaFin# NEQ "">
			<tr>
			<td class="Header" colspan="3" align="center"><strong>FECHA FINAL: #Trim(form.fechaFin)#</strong></td>
		</tr>
		</cfif>
	</table>
</cffunction>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cffunction name="Creatabla" output="true">
	<table width="70%" border="0">
</cffunction>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cffunction name="Cierratabla" output="true">
	</table>
</cffunction>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cffunction name="titulos" output="true">
	<tr>
		<td align="center" class="ColHeader"><strong>Cuenta</strong></td>
		<td align="center" class="ColHeader"><strong>Saldo Inicial</strong></td>
		<td align="center" class="ColHeader"><strong>Saldo Final</strong></td>
	</tr>
</cffunction>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cffunction name="sbGeneraEstilos" output="true">
	<style type="text/css">
		H1.Corte_Pagina
		{
		PAGE-BREAK-AFTER: always
		}

		.ColHeader
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		8px;
			font-weight: 	bold;
			padding-left: 	0px;
			border:		1px solid ##CCCCCC;
			background-color:##CCCCCC
		}

		.Header
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		12px;
			font-weight: 	bold;
			padding-left: 	0px;
			text-align:	center;
		}

		.Header1
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		19px;
			font-weight: 	bold;
			padding-left: 	0px;
		}

		.Corte1
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		14px;
			font-weight: 	bold;
			padding-left: 	0px;
		}

		.Corte2
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		7px;
			font-weight: 	bold;
			padding-left: 	10px;
		}

		.Corte3
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		10px;
			font-weight: 	bold;
			padding-left: 	20px;
		}

		.Corte4
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		10px;
			font-weight: 	none;
			padding-left: 	30px;
		}

		.Datos
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		7px;
			font-weight: 	none;
			white-space:nowrap;
		}

		body
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		11px;
		}
	</style>
</cffunction>

<cffunction name="sbCortePagina" output="true">
	<cfif isdefined("LvarNoCortes")>
		<cfreturn>
	</cfif>
	<cfif LvarContL GTE LvarLineasPagina>
		<tr><td><H1 class=Corte_Pagina></H1></td></tr>
		<cfset Cierratabla()>
		<cfset LvarPAg   = LvarPAg + 1>
		<cfset LvarContL = 5>
		<cfset Encabezado()>
		<cfset Creatabla()>
		<cfset titulos()>
	</cfif>
	<cfset LvarContL = LvarContL + 1>
</cffunction>
<cfinclude template="Funciones.cfm">
<cfsetting enablecfoutputonly="yes">
<cfquery datasource="#Session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
	from Empresas a, Monedas b 
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and a.Mcodigo = b.Mcodigo
</cfquery>



<cfset LvarUnidades = 1>
<cfif isdefined("form.Unidades") and form.Unidades GT 1>
	<cfset LvarUnidades = form.Unidades>
</cfif>

<cfif isdefined("chkMonCon")>
	<cfquery name="rsMoneda" datasource="#session.DSN#">
		select Mnombre
		from Monedas 
		where Mcodigo = (
			select min(<cf_dbfunction name="to_number" args="Pvalor">)
			from Parametros 
			where Ecodigo = #session.Ecodigo#
			and Pcodigo = 660
			)
	</cfquery>

	<cfset LvarTabla = 'SaldosContablesConvertidos'>
	<cfif isdefined("rsMoneda") and rsMoneda.recordcount gt 0>
		<cfset LvarMoneda = rsMoneda.Mnombre>
	<cfelse>
		<cfset LvarMoneda = ' '>
	</cfif>
<cfelse>
	<cfset LvarTabla = 'SaldosContables'>
	<cfset LvarMoneda = rsMonedaLocal.Mnombre>
</cfif>
	


<cfif LvarUnidades EQ 1>
	<cfset moneda ='Montos en ' & LvarMoneda>
<cfelseif LvarUnidades EQ 1000 >
	<cfset moneda ='Montos en miles de ' & LvarMoneda>
<cfelseif LvarUnidades EQ 1000000 >
	<cfset moneda ='Montos en Millones de ' & LvarMoneda>
</cfif>

<cfif isdefined("url.periodo")>
	<cfparam name="Form.periodo" default="#url.periodo#">
</cfif>
<cfif isdefined("url.mes")>
	<cfparam name="Form.mes" default="#url.mes#">
</cfif>
<cfif isdefined("url.nivel")>
	<cfparam name="Form.nivel" default="#url.nivel#">
</cfif>

<cfif isdefined("Form.Nivel") and Form.Nivel neq "-1">
	<cfset varNivel = Form.Nivel>
<cfelse>
	<cfset varNivel = 0>
</cfif>

<cfif isdefined("Form.CorteNivel") and Form.CorteNivel neq "-1">
	<cfset varCorteNivel = Form.CorteNivel>
<cfelse>
	<cfset varCorteNivel = 0>
</cfif>

<cfif varCorteNivel GT varNivel or varNivel LT 2>
	<cfset varCorteNivel = 0>
</cfif>


<cfif isdefined("url.Cmayor")>
	<cfparam name="Form.Cmayor" default="#url.Cmayor#">
</cfif>

<cfset LvarSigno = 1.00>
<cfquery name="rsTipoCuentaMayor" datasource="#Session.DSN#">
	select m.Cdescripcion, m.Ctipo as Tipo
	from CtasMayor m
	where m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and m.Cmayor  = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
</cfquery>

<cfif rsTipoCuentaMayor.Tipo EQ "P" or rsTipoCuentaMayor.Tipo EQ "C" or rsTipoCuentaMayor.Tipo EQ "I">
	<cfset LvarSigno = -1.00>
</cfif>

<cfquery name="rsProc" datasource="#Session.DSN#" maxrows="10001">
	select 
		  m.Cdescripcion 
		<cfif form.CorteNivel GT 0>
		, (coalesce(( 
				select min(c2.Cformato)
				from PCDCatalogoCuenta cc2
					inner join CContables c2
					on c2.Ccuenta = cc2.Ccuentaniv
				where cc2.Ccuenta = cc.Ccuenta
				  and cc2.PCDCniv = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCorteNivel#">
			), ' '))
		<cfelse>
		, ' '
		</cfif>
		as FormatoCorte
		, c.Cformato as FormatoDetalle
		, c.Cdescripcion as Descripcion
		, c.Ccuenta as Ccuenta
		, coalesce((
				select sum((s.SLinicial + s.DLdebitos - s.CLcreditos) *  #LvarSigno# / #LvarUnidades#)
				from #LvarTabla# s
				where s.Ccuenta = c.Ccuenta
				  and Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.periodo#">
				  and Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.mes#">
				  ), 0.00)
		  as Saldo
	from CtasMayor m
		inner join CContables c
			inner join PCDCatalogoCuenta cc
				on cc.Ccuentaniv = c.Ccuenta
				and cc.PCDCniv = <cfqueryparam cfsqltype="cf_sql_integer" value="#varNivel#">
		on c.Cmayor = m.Cmayor
		and c.Ecodigo = m.Ecodigo
	where m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and m.Cmayor =  <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.Cmayor#">
	group by m.Cdescripcion, c.Cformato, c.Cdescripcion, c.Ccuenta <cfif form.CorteNivel GT 0> , cc.Ccuenta </cfif>
	<cfif not isdefined('form.ChkCero')>
	having coalesce((
				select sum((s.SLinicial + s.DLdebitos - s.CLcreditos) *  #LvarSigno# / #LvarUnidades#)
				from #LvarTabla# s
				where s.Ccuenta = c.Ccuenta
				  and Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.periodo#">
				  and Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.mes#">
				  ), 0.00) <> 0
	</cfif>
	order by c.Cformato

</cfquery>

<cfif isdefined("rsProc") and rsProc.recordcount gt 10000>
	<cf_errorCode	code = "50238" msg = "La consulta excede los 10,000 registros">
	<cfabort>
</cfif>

<cfif isdefined("form.botonsel") and len(trim(form.botonsel)) and form.botonsel eq "Exportar">
	<cf_exportQueryToFile query="#rsProc#" separador="#chr(9)#" filename="SaldoCuenta_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="false">
</cfif>

<cfset meses="Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre">
<cfoutput>
<style type="text/css">
	.encabReporte {
		background-color: ##006699;
		font-weight: bold;
		color: ##FFFFFF;
		padding-top: 2px;
		padding-bottom: 2px;
		font-size:12px;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: ##CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: ##CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: ##F5F5F5;
	}
	.tituloLeyenda {
		font-weight: bold;
		font-size:16px;
		color:##0000FF; 
	}
</style>
</cfoutput>
<cfoutput>
<form name="form1" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 10px" align="center">
    	<tr><td colspan="4" class="tituloAlterno" align="center">#rsEmpresa.Edescripcion#</td></tr>
    	<tr><td colspan="4">&nbsp;</td></tr>
    	<tr>
    	  <td colspan="4" align="center"><b><font size="2">Intregraci&oacute;n de cuenta de mayor</font></b></td>
    	</tr>
		<tr>
		  <td colspan="4" align="center"><b><font size="2">#rsTipoCuentaMayor.Cdescripcion#</font></b></td>
		</tr>		
		<tr>
			<td colspan="4" align="center" style="padding-right: 20px">
				A &nbsp;#ListGetAt(meses, Form.mes, ',')#
				de &nbsp;#Form.periodo#
			</td>
		</tr>
		<tr>
			<td colspan="4" align="center" style="padding-right: 20px">
				<b>#moneda#</b>
			</td>
		</tr>		
		<tr><td colspan="4" class="bottomline">&nbsp;</td></tr>
		<tr><td colspan="4" class="tituloListas">&nbsp;</td></tr>
		<tr class="encabReporte"> 
			<td colspan="2" align="left" nowrap >Cuenta</td>
			<td >&nbsp;</td>
			<td align="right" nowrap >Importe</td>
		</tr>
   		<cfif rsProc.recordCount GT 0>
			<cfset ControlCorte = false>
			<cfset saldototal = 0>
			<cfset saldocorte = 0>
			<cfset LvarCorte = " ">
			<cfloop query="rsProc">
				<cfif rsProc.FormatoCorte NEQ LvarCorte>
					<cfif ControlCorte>
						<tr>
							<td colspan="3"><strong>SubTotal #LvarCorte# - #rsObtieneCuentaCorte.NombreCorte#</strong></td>
							<td align="right">
								<strong>
								<font size="2">
									<cfif saldocorte GTE 0>
										#LSNumberFormat(saldocorte,'999,999,999,999,999.00')# 
									<cfelse>
										<font color="##FF0000">#LSNumberFormat(saldocorte,'999,999,999,999,999.00()')#</font> 
									</cfif>
								</font>
								</strong>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>	
						<cfset saldocorte = 0>
					</cfif>
					<cfquery name="rsObtieneCuentaCorte" datasource="#Session.dsn#">
						select c.Ccuenta as CuentaCorte, c.Cdescripcion as NombreCorte
						from CContables c
						where c.Ecodigo = #session.Ecodigo#
						  and c.Cformato = <cfqueryparam cfsqltype="cf_sql_char" value="#rsProc.FormatoCorte#">
					</cfquery>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td colspan="4">
							<font size="2"><strong>#rsProc.FormatoCorte# - #rsObtieneCuentaCorte.NombreCorte#</strong></font>
						</td>
					</tr>
					<cfset LvarCorte = rsProc.FormatoCorte>
					<cfset ControlCorte = true>
				</cfif>
				<tr>
					<td style="width:5%">&nbsp;</td>
					<td colspan="2">
						<font size="2">#rsProc.FormatoDetalle# - #rsProc.Descripcion#</font>
					</td>
					<td align="right">
						<font size="2">
							<cfif rsProc.saldo GTE 0>
								#LSNumberFormat(rsProc.saldo,'999,999,999,999,999.00')# 
							<cfelse>
								<font color="##FF0000">#LSNumberFormat(RsProc.saldo,'999,999,999,999,999.00()')#</font> 
							</cfif>
						</font>
					</td>
				</tr>
				<cfset saldototal = saldototal + rsProc.saldo>
				<cfset saldocorte = saldocorte + rsProc.saldo>
			</cfloop>
			<cfif ControlCorte and LvarCorte NEQ ' '>
				<tr>
					<td colspan="3"><strong>SubTotal #LvarCorte# - #rsObtieneCuentaCorte.NombreCorte#</strong></td>
					<td align="right">
						<strong>
						<font size="2">
							<cfif saldocorte GTE 0>
								#LSNumberFormat(saldocorte,'999,999,999,999,999.00')# 
							<cfelse>
								<font color="##FF0000">#LSNumberFormat(saldocorte,'999,999,999,999,999.00()')#</font> 
							</cfif>
						</font>
						</strong>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</cfif>			
			<tr class="encabReporte"> 
				<td colspan="2" align="left" nowrap >Total</td>
				<td>&nbsp;</td>
				<td align="right" nowrap >
					<cfif saldototal GTE 0>
						#LSNumberFormat(saldototal,'999,999,999,999,999.00')# 
					<cfelse>
						<font color="##FF0000">#LSNumberFormat(saldototal,'999,999,999,999,999.00()')#</font> 
					</cfif>
				</td>
			</tr>
		<cfelse>
			  <td colspan="4"><div align="center">La Consulta no retorno datos</div></td>
		</cfif>	
		<tr> 
		  <td colspan="4"><div align="center">------------------ Fin del Reporte ------------------</div></td>
		</tr>
  </table>
</form>
</cfoutput>
<cfsetting enablecfoutputonly="no">



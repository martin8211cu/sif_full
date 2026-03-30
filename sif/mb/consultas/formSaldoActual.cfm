<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ReporteSaldoActualCuentas" default="Reporte de Saldo Actual de Cuentas" returnvariable="LB_ReporteSaldoActualCuentas" xmlfile="formSaldoActual.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Saldo" default="Saldo" returnvariable="LB_Saldo" xmlfile="formSaldoActual.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Imprimir" default="Imprimir" returnvariable="LB_Imprimir" xmlfile="formSaldoActual.xml"/>


<!--- 1. Datos de la empresa --->
<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

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
		padding-top: 2px;
		padding-bottom: 2px;
		
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
<cfoutput>
	<cfif isdefined("url.fechai")>
		<cfparam name="form.fechai" default="#url.fechai#">
	</cfif>
	
	<cfif isdefined("url.tipo")>
		<cfparam name="form.tipo" default="#url.tipo#">
	</cfif>

</cfoutput>
<cfset FECHA = LSDateFormat(Now(),'DD/MM/YYYY') >
<cfset vparams ="">
<cfset vparams = vparams & "&fechai=" & form.fechai >
<!--- *************************************************** --->
<!--- ****      Query de la consulta                 **** --->
<!--- *************************************************** --->

	<cfquery name="rsDatos" datasource="#session.DSN#"  >			

		select 
			cb.Ocodigo as Ocodigo, 
			o.Odescripcion as Odescripcion, 
			cb.Mcodigo as Mcodigo, 
			m.Mnombre as Mnombre, 
			b.Bid as Bid, 
			b.Bdescripcion as Bdescripcion, 
			cb.CBid as CBid, 
			cb.CBcodigo as CBcodigo, 
			cb.CBdescripcion as CBdescripcion
		from CuentasBancos cb
			inner join Bancos b
			   on b.Bid  = cb.Bid 

			inner join Monedas m
			   on m.Mcodigo  = cb.Mcodigo

			inner join Oficinas o
			   on o.Ecodigo = cb.Ecodigo
			  and o.Ocodigo = cb.Ocodigo

		where cb.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">  
		<cfif isdefined("Form.Ocodigo")  and  len(Form.Ocodigo)>
			and cb.Ocodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">	
		</cfif>	

		<cfif isdefined("Form.Mcodigo") and  len(Form.Mcodigo)>
			and cb.Mcodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">	
		</cfif>

		order by  cb.Ocodigo, cb.Mcodigo, b.Bdescripcion, cb.CBcodigo

	</cfquery>	

<!--- *************************************************** --->
<!--- ****      Area de pintado de la consulta       **** --->
<!--- *************************************************** --->

	<cfquery name="rsOficinasC" dbtype="query" >
		select 
			distinct Ocodigo, Odescripcion 
		from rsDatos 
		order by Odescripcion
	</cfquery>

	<cfset TotalMoneda	= 0>

	<cfoutput>

	<table width="100%" border="0" cellspacing="0" align="center">
	    <cfif not isdefined("url.imprimir")>
			<tr>
				<td colspan="2" align="right">
					<table width="100%" cellpadding="2" cellspacing="0">
						<tr>
							<td valign="top">
								<cf_rhimprime datos="/sif/mb/consultas/formSaldoActual.cfm" paramsuri="#vparams#">
							</td>	
						</tr>
					</table>
				</td>
			</tr>
		</cfif>
		<tr> 
		<td colspan="2" align="right"><cfoutput>#LSDateFormat(Now(), 'dd/mm/yyyy')#</cfoutput></td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>			

			<tr> 
	    <tr> 
				<td colspan="2" class="tituloAlterno" align="center"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td>
		</tr>
	
		<tr><td colspan="2">&nbsp;</td></tr>
	
		<tr><td colspan="2" align="center"><b>#LB_ReporteSaldoActualCuentas#</b></td></tr>
	
		<tr><td colspan="2">&nbsp;</td></tr>

		<tr>
			<td  nowrap   bgcolor="##98B1C4">&nbsp;</td>
			<td  nowrap   align="right" bgcolor="##98B1C4"><b><font size="1">#LB_Saldo#</font></b></td>
			<td nowrap  align="right" bgcolor="##98B1C4">&nbsp;</td>
		</tr>

		<cfloop query="rsOficinasC">
			<cfset oficina = #Ocodigo#>	
			<tr>
				<td width="70%"  colspan="1" bgcolor="lightslategray"><b><font size="2">#rsOficinasC.Odescripcion#</font></b></td>
				<td width="28%" nowrap  align="right" bgcolor="lightslategray">&nbsp;</td>
				<td width="2%" nowrap  align="right" bgcolor="lightslategray">&nbsp;</td>
			</tr>
			<cfquery name="rsMonedasC" dbtype="query" >
				select distinct Mcodigo, Mnombre 
				from rsDatos 
				where Ocodigo = #oficina# 
				order by Mnombre
			</cfquery>
			<cfloop query="rsMonedasC">
				<cfset TotalMoneda	= 0>
				<cfset moneda = #Mcodigo#>	
				<tr>
					<td   colspan="1" bgcolor="##98B1C4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><font size="1">#rsMonedasC.Mnombre#</font></b></td>
					<td nowrap align="right" >&nbsp;</td>
					<td nowrap  align="right" >&nbsp;</td>
				</tr>
				<cfquery name="rsBancosC" dbtype="query" >
					select distinct Bid, Bdescripcion
					from rsDatos
					where Ocodigo=#oficina#
					  and Mcodigo=#moneda#
					 order by  Bdescripcion
				</cfquery>
				<cfloop query="rsBancosC">
					<cfset Banco = #Bid#>
					<tr>
						<td  class="leftline" colspan="1" bgcolor="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><font size="1">#rsBancosC.Bdescripcion#</font></b></td>
						<td nowrap class="" align="right" bgcolor="">&nbsp;</td>
						<td nowrap class="" align="right" bgcolor="">&nbsp;</td>

					</tr>	
					<cfquery name="rsCuentasC" dbtype="query">
						select distinct CBid, CBcodigo,CBdescripcion
						from rsDatos
						where Ocodigo=#oficina#
						  and Mcodigo=#moneda#
						  and Bid =#Banco#
						 order by  CBcodigo
					</cfquery>			
					<cfloop query="rsCuentasC">
						<cfset saldoi = get_saldo(CBid, FECHA) >
						<cfset TotalMoneda	= TotalMoneda + saldoi>
						<tr>
							<td  class="leftline" colspan="1" bgcolor="">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<font size="1">#TRIM(rsCuentasC.CBdescripcion)#&nbsp;&nbsp;</font><font color="dimgray" size="1">[#rsCuentasC.CBcodigo#]</font></td>
							<td nowrap class="leftline" align="right" bgcolor=""><font color="<cfif saldoi lt 0>##FF0000<cfelse>##000000</cfif>">#LSNumberFormat( saldoi,',9.00')#</font></td>
							<td nowrap class="rightline" align="right" bgcolor="">&nbsp;</td>
						</tr>						
					</cfloop>
				</cfloop>
				<tr>
					<td nowrap class="leftline"  colspan="1" bgcolor="">&nbsp;</td>
					<td nowrap class=""  align="right" bgcolor=""><B><font size="1" color="<cfif TotalMoneda lt 0>##FF0000<cfelse>##000000</cfif>">#LSNumberFormat( TotalMoneda,',9.00')#</font></B></td>
					<td nowrap class="" align="right" bgcolor="">&nbsp;</td>
				</tr>					
			</cfloop>
		</cfloop>
	</table>
	</cfoutput>
	
	<!--- **************************************************** --->
	<!--- ****      Area de funciones de Saldo por Cuenta **** --->
	<!--- **************************************************** --->

	<cffunction name="get_saldo" access="public" returntype="numeric">

		<cfargument name="cbid"     type="numeric" required="true"  default="<!--- Codigo de la lnea de Titulo --->">

		<cfargument name="fechai"   type="string"  required="false" default="<!--- Codigo de la lnea de Titulo --->">
	
		<cfset saldoi      = 0.00>
		<cfset lvarPeriodo = 0>
		<cfset lvarMes     = 0>

		<cfquery name = "rsget_saldo1" datasource="#session.DSN#">

			select max(Periodo) as Periodo
			from SaldosBancarios
			where CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.cbid#">

		</cfquery>

		<cfif rsget_saldo1.recordcount GT 0 and len(trim(rsget_saldo1.Periodo)) gt 0>

			<cfset lvarPeriodo = rsget_saldo1.Periodo>

			<cfquery name = "rsget_saldo2" datasource="#session.DSN#">

				select max(Mes) as Mes
				from SaldosBancarios
				where CBid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.cbid#">
				  and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarPeriodo#">

			</cfquery>

			<cfset lvarMes = rsget_saldo2.Mes>

			<cfquery name = "rsget_saldoi" datasource="#session.DSN#">

				select coalesce(Sinicial, 0.00) as saldoi
				from SaldosBancarios
				where CBid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.cbid#">
				  and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarPeriodo#">
				  and Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarMes#">


			</cfquery>


			<cfif len(rsget_saldoi.saldoi) NEQ 0>		
				<cfset saldoi = rsget_saldoi.saldoi>
			</cfif>

		</cfif>
	
		<!--- Le agrega al saldo inicial los movimientos en la fecha actual --->
		
		<cfquery name="rsget_saldoactual" datasource="#session.DSN#">

			select coalesce(sum(MLmonto * case when MLtipomov = 'D' then 1.00 else -1.00 end), 0.00) as SaldoMov
			from MLibros
			where CBid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.cbid#">
			  and MLperiodo >= <cfqueryparam cfsqltype = "cf_sql_integer" value = "#lvarPeriodo#">
			  and MLmes     >= <cfqueryparam cfsqltype = "cf_sql_integer" value = "1">
			  and MLperiodo * 100 + MLmes >= <cfqueryparam cfsqltype = "cf_sql_integer" value = "#lvarPeriodo * 100 + lvarMes#">

		</cfquery>
		
		<cfset saldomov = 0.00 >

		<cfif rsget_saldoactual.recordcount GT 0>
			<cfset saldomov = rsget_saldoactual.SaldoMov>
		</cfif>

		<cfset saldoi = saldoi + saldomov >	
		
		<cfreturn #saldoi#>
	</cffunction>	
<!--- Metodo traduccion de Etiquetas--->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Oficina" default="Oficina" returnvariable="LB_Oficina" xmlfile="MenuConsulta.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Todas" default="Todas" returnvariable="LB_Todas" xmlfile="MenuConsulta.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda" default="Moneda" returnvariable="LB_Moneda" xmlfile="MenuConsulta.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SaldoActual" default="Saldo Actual de Cuentas" returnvariable="LB_SaldoActual" xmlfile="MenuConsulta.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Saldo" default="Saldo" returnvariable="LB_Saldo" xmlfile="MenuConsulta.xml"/>


<!--- *************************************************** --->
<!--- ****      Area de style                        **** --->
<!--- *************************************************** --->
	<style type="text/css">
		.topline {
			border-top-width: 1px;
			border-top-style: solid;
			border-top-color: #000000;
			border-right-style: none;
			border-bottom-style: none;
			border-left-style: none;
		}
		.leftline {
			border-left-width: 1px;
			border-left-style: solid;
			border-left-color: #000000;
			border-right-style: none;
			border-bottom-style: none;
			border-top-style: none;
		}	
		.rightline {
			border-right-width: 1px;
			border-right-style: solid;
			border-right-color: #000000;
			border-left-style: none;
			border-bottom-style: none;
			border-top-style: none;
		}		
		.bottomline {
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-bottom-color: #000000;
			border-right-style: none;
			border-top-style: none;
			border-left-style: none;
		}
		.Lbottomline {
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-bottom-color: #000000;
			border-left-width: 1px;
			border-left-style: solid;
			border-left-color: #000000;		
			border-top-style: none;
			border-right-style: none;
		}	
		.Rbottomline {
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-bottom-color: #000000;
			border-right-width: 1px;
			border-right-style: solid;
			border-right-color: #000000;		
			border-top-style: none;
			border-left-style: none;
		}		
		.RLbottomline {
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-bottom-color: #000000;
			border-right-width: 1px;
			border-right-style: solid;
			border-right-color: #000000;	
			border-left-width: 1px;
			border-left-style: solid;
			border-left-color: #000000;				
			border-top-style: none;
		}		
		.RLline {
			border-bottom-style: none;
			border-right-width: 1px;
			border-right-style: solid;
			border-right-color: #000000;	
			border-left-width: 1px;
			border-left-style: solid;
			border-left-color: #000000;				
			border-top-style: none;
		}	
		.LbTottomline {
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-bottom-color: #000000;
			border-left-width: 1px;
			border-left-style: solid;
			border-left-color: #000000;	
			border-top-width: 1px;
			border-top-style: solid;
			border-top-color: #000000;			
			border-right-style: none;
		}		
		.RLTbottomline {
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-bottom-color: #000000;
			border-right-width: 1px;
			border-right-style: solid;
			border-right-color: #000000;	
			border-left-style: none;
			border-top-width: 1px;
			border-top-style: solid;
			border-top-color: #000000			
		}		
	</style>
<!--- *************************************************** --->
<!--- ****      Area de querys para filtros          **** --->
<!--- *************************************************** --->
	<cfset FECHA = LSDateFormat(Now(),'DD/MM/YYYY') >
	
	<cfquery datasource="#Session.DSN#" name="rsOficinas">
		select Ocodigo, Odescripcion
		from Oficinas
		where Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" > 
		order by Odescripcion	
	</cfquery>
	
	<cfquery datasource="#Session.DSN#" name="rsMonedas">
		select Mcodigo,Mnombre from Monedas
		where Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" > 
		order by Mnombre
	</cfquery>

	<cfquery name="rsMonedaEmpresa" datasource="#Session.DSN#">
		select Mcodigo from Empresas 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>	
<!--- *************************************************** --->
<!--- ****      Pintado de filtros y titulo          **** --->
<!--- *************************************************** --->
	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		<form action="/cfmx/sif/mb/MenuMB.cfm" method="post" name="sql">	
			<tr>
            	<cfoutput>
				<td width="65%" align="right"  bgcolor="gainsboro">&nbsp;#LB_Oficina#:</td>
                </cfoutput>
				<td width="15%" align="right"  bgcolor="gainsboro">
					<select name="Ocodigo" onChange="this.form.submit();">
						<option value=""><cfoutput>#LB_Todas#</cfoutput></option>
						<cfoutput query="rsOficinas">
							<option value="#Ocodigo#" <cfif isdefined("Form.Ocodigo") and  Form.Ocodigo EQ rsOficinas.Ocodigo>selected</cfif>>#Odescripcion#</option>
						</cfoutput>
					</select>
				</td>
				<td width="10%" align="right"  bgcolor="gainsboro">&nbsp;<cfoutput>#LB_Moneda#</cfoutput>:</td>
				<td width="15%" align="right"  bgcolor="gainsboro">
					<select name="Mcodigo" onChange="this.form.submit();">
						<option value=""><cfoutput>#LB_Todas#</cfoutput></option>
						<cfoutput query="rsMonedas">
							<option value="#Mcodigo#" <cfif isdefined("Form.Mcodigo") and  Form.Mcodigo EQ rsMonedas.Mcodigo>selected</cfif>>#Mnombre#</option>
						</cfoutput>
					</select>			
				</td>
			</tr>
			<tr>
				<td  colspan="4" bgcolor="gainsboro" align="Center">
					<b><font size="2"><cfoutput>#LB_SaldoActual#</cfoutput></font></b>
				</td>
			</tr>		
		</form>
	</table>

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

		<tr>
			<td  nowrap class="LbTottomline"  bgcolor="##98B1C4">&nbsp;</td>
			<td  nowrap  class="LbTottomline" align="right" bgcolor="##98B1C4"><b><font size="1"><cfoutput>#LB_Saldo#</cfoutput></font></b></td>
			<td nowrap class="RLTbottomline" align="right" bgcolor="##98B1C4">&nbsp;</td>
		</tr>

		<cfloop query="rsOficinasC">
			<cfset oficina = #Ocodigo#>	
			<tr>
				<td width="70%" class="leftline" colspan="1" bgcolor="lightslategray"><b><font size="2">#rsOficinasC.Odescripcion#</font></b></td>
				<td width="28%" nowrap class="leftline" align="right" bgcolor="lightslategray">&nbsp;</td>
				<td width="2%" nowrap class="rightline" align="right" bgcolor="lightslategray">&nbsp;</td>
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
					<td  class="leftline" colspan="1" bgcolor="##98B1C4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><font size="1">#rsMonedasC.Mnombre#</font></b></td>
					<td nowrap class="leftline" align="right" bgcolor="##98B1C4">&nbsp;</td>
					<td nowrap class="rightline" align="right" bgcolor="##98B1C4">&nbsp;</td>
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
						<td  class="leftline" colspan="1" bgcolor="##C8D7E3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><font size="1">#rsBancosC.Bdescripcion#</font></b></td>
						<td nowrap class="leftline" align="right" bgcolor="gainsboro">&nbsp;</td>
						<td nowrap class="rightline" align="right" bgcolor="gainsboro">&nbsp;</td>

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
							<td  class="leftline" colspan="1" bgcolor="##C8D7E3">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<font size="1">#TRIM(rsCuentasC.CBdescripcion)#&nbsp;&nbsp;</font><font color="dimgray" size="1">[#rsCuentasC.CBcodigo#]</font></td>
							<td nowrap class="leftline" align="right" bgcolor="gainsboro"><font color="<cfif saldoi lt 0>##FF0000<cfelse>##000000</cfif>">#LSNumberFormat( saldoi,',9.00')#</font></td>
							<td nowrap class="rightline" align="right" bgcolor="gainsboro">&nbsp;</td>
						</tr>						
					</cfloop>
				</cfloop>
				<tr>
					<td nowrap class="leftline"  colspan="1" bgcolor="##C8D7E3">&nbsp;</td>
					<td nowrap class="leftline"  align="right" bgcolor="gainsboro"><B><font size="1" color="<cfif TotalMoneda lt 0>##FF0000<cfelse>##000000</cfif>">#LSNumberFormat( TotalMoneda,',9.00')#</font></B></td>
					<td nowrap class="rightline" align="right" bgcolor="gainsboro">&nbsp;</td>
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


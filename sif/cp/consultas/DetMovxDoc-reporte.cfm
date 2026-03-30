<cfif isdefined("url.Documento") and not isdefined("Form.Documento")>
	<cfparam name="Form.Documento" default="#url.Documento#">
</cfif>
<cfif isdefined("url.SNcodigo") and not isdefined("Form.SNcodigo")>
	<cfparam name="Form.SNcodigo" default="#url.SNcodigo#">
</cfif>
<cfif isdefined("url.CPTcodigo") and not isdefined("Form.CPTcodigo")>
	<cfparam name="Form.CPTcodigo" default="#url.CPTcodigo#">
</cfif>

<cfquery datasource="#Session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfquery name="rsconsulta1" datasource="#session.dsn#">
	select e.SNcodigo as Proveedor,
		   s.SNnombre, 
		   m.Mnombre as Moneda, 
		   e.CPTcodigo as Transaccion,
		   e.Ddocumento as Documento, 
		   e.Dtotal as SaldoInicial,
		   e.Dtipocambio as TipoCambio,
		   e.IDdocumento as IDdocumento,
		   e.Dfecha as Fecha,
		   e.Dfechavenc as Fechavenc
	from EDocumentosCP e
	
		inner join SNegocios s
		on s.Ecodigo = e.Ecodigo
		and s.SNcodigo = e.SNcodigo

		inner join Monedas m
		on m.Mcodigo = e.Mcodigo
		
	where e.Ecodigo = #session.ecodigo#
	  and e.Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Documento#">
	  and e.CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CPTcodigo#">
	  and e.SNcodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
	order by e.SNcodigo, e.Dfecha
</cfquery>

<cfif rsconsulta1.recordcount LT 1>
	<cfquery name="rsconsulta1" datasource="#session.dsn#">
		select e.SNcodigo as Proveedor,
			   s.SNnombre, 
			   m.Mnombre as Moneda, 
			   e.CPTcodigo as Transaccion,
			   e.Ddocumento as Documento, 
			   e.Dtotal as SaldoInicial,
			   e.Dtipocambio as TipoCambio,
			   e.IDdocumento as IDdocumento,
			   e.Dfecha as Fecha,
			   e.Dfechavenc as Fechavenc
		from HEDocumentosCP e
		
			inner join SNegocios s
			on s.SNcodigo = e.SNcodigo
			and s.Ecodigo = e.Ecodigo
	
			inner join Monedas m
			on m.Mcodigo = e.Mcodigo
			
		where e.Ecodigo = #session.ecodigo#
		  and e.Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Documento#">
		  and e.CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CPTcodigo#">
		  and e.SNcodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
		order by e.SNcodigo, e.Dfecha
	</cfquery>
</cfif>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Meses 	= t.Translate('LB_Meses','Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre')>
<cfset LB_ConsDoct 	= t.Translate('LB_ConsDoct','Consulta de Documento')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_FecEmi 	= t.Translate('LB_FecEmi','Fecha Emisión')>
<cfset LB_FecVenc 	= t.Translate('LB_FecVenc','Fecha Vencimiento')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Monto 	= t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_SaldoAct 	= t.Translate('LB_SaldoAct','Saldo Actual')>
<cfset LB_SaldoActL	= t.Translate('LB_SaldoActL	','Saldo Actual Local')>
<cfset MGS_FinDelReporte	= t.Translate('MGS_FinDelReporte','Fin del Reporte','/sif/generales.xml')>
<cfset LB_Fecha_Final	= t.Translate('LB_Fecha_Final','Fecha Final','/sif/generales.xml')>
<cfset LB_PROVEEDOR		= t.Translate('LB_PROVEEDOR','Proveedor','/sif/generales.xml')>



<cfset meses="#LB_Meses#">
	<style type="text/css">
		.encabReporte {
			background-color: #006699;
			font-weight: bold;
			color: #FFFFFF;
			padding-top: 5px;
			padding-bottom: 5px;
		}
		.tbline {
			border-width: 1px;
			border-style: solid;
			border-color: #CCCCCC;
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
	

<form name="form1" method="post">
<cfif isdefined("form.toexcel")>
	<cfcontent type="application/msexcel">
	<cfheader 	name="Content-Disposition" 
				value="attachment;filename=Movimientos_x_Documento_#session.Usucodigo#_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls" >
</cfif>		  
  <table width="100%" border="0" cellpadding="2" cellspacing="0">
    <tr> 
      <td align="center"><strong><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong></td>
    </tr>
    <tr>
      <td align="center"><cfoutput><b>#LB_ConsDoct#</b></cfoutput></td>
    </tr>
	<cfoutput>
	<tr>
		<td align="center">
			<!---<b>Desde:</b> Inicio &nbsp; --->
			<b>#LB_Fecha_Final#:</b> #LSDateFormat(Now(),'dd/mm/yyyy')# 
		</td>
	</tr>
	<tr>
		<td align="center" >
			<b>#LB_PROVEEDOR#:</b>
			<cfif isdefined("rsconsulta1") and Len(Trim(rsconsulta1.SNnombre)) gt 0>
				#rsconsulta1.SNnombre#
			</cfif>
		</td>
	</tr>
	</cfoutput>
	<cfif rsconsulta1.recordcount GT 0>
      <tr> 
        <td> 
          <table width="100%" border="0" cellspacing="0" cellpadding="2">
            <cfloop query="rsconsulta1">
              <cfoutput> 
				<cfset Proveedor = rsconsulta1.SNnombre>
				<tr><td>&nbsp;</td></tr>
                <cfquery name="rsMonedasConsulta" dbtype="query">
					select distinct Moneda 
					from rsconsulta1 
					where Proveedor = <cfqueryparam cfsqltype="cf_sql_integer" value="#Proveedor#">
				</cfquery>
				<cfloop query="rsMonedasConsulta">
                  <cfset MonedaL = rsMonedasConsulta.Moneda>
                  <tr> 
                    <td class="encabReporte" colspan="7">#MonedaL#</td>
                  </tr>
					<tr>
						<td class="tbline" style="background-color: ##F5F5F5; font-weight: bold" nowrap>#LB_Documento#</td>
						<td class="tbline" align="center" style="background-color: ##F5F5F5; font-weight: bold" nowrap>#LB_FecEmi#</td>
						<td class="tbline" align="center" style="background-color: ##F5F5F5; font-weight: bold" nowrap>#LB_FecVenc#</td>
						<td class="tbline" align="right" style="background-color: ##F5F5F5; font-weight: bold" nowrap>#LB_Moneda#</td>
						<td class="tbline" align="right" style="background-color: ##F5F5F5; font-weight: bold" nowrap>#LB_Monto#</td>
						<td class="tbline" align="right" style="background-color: ##F5F5F5; font-weight: bold" nowrap>#LB_SaldoAct#</td>
						<td class="tbline" align="right" style="background-color: ##F5F5F5; font-weight: bold" nowrap>#LB_SaldoActL#</td>
					</tr>
					<cfset LvarSaldoActual = 0>
					<cfset LvarTCultrev = rsconsulta1.TipoCambio>
					<!--- Obtener el saldo actual y el tipo de cambio de la última revaluación, si existe.  Si no existe, se asume saldo en CERO --->
					<cfquery name="rsconsulta2" datasource="#session.dsn#">
						select 
							act.Dtotal as Total,
							act.EDsaldo as SaldoActual,
							act.EDtcultrev as TCultrev
						from EDocumentosCP act
						where act.IDdocumento = #rsconsulta1.IDdocumento#
					</cfquery>
					<cfif rsconsulta2.recordcount GT 0>
						<cfset LvarSaldoActual = rsconsulta2.SaldoActual>
						<cfset LvarTCultrev = rsconsulta2.TCultrev>
					</cfif>
					<cfset LvarSaldoActualLocal = LvarSaldoActual * LvarTCultrev>
					<tr>
						<td class="bottomline">#rsconsulta1.Transaccion# - #rsconsulta1.Documento#</td>
						<td class="bottomline" align="center">#dateformat(rsconsulta1.Fecha, "DD/MM/YYYY")#</td>
						<td class="bottomline" align="center">#dateformat(rsconsulta1.FechaVenc,"DD/MM/YYYY")#</td>
						<td class="bottomline" align="right">#rsconsulta1.Moneda#&nbsp;</td>
						<td class="bottomline" align="right">#LSCurrencyFormat(rsconsulta1.SaldoInicial, 'none')#&nbsp;</td>
						<td class="bottomline" align="right">#LSCurrencyFormat(LvarSaldoActual, 'none')#&nbsp;</td>
						<td class="bottomline" align="right">#LSCurrencyFormat(LvarSaldoActualLocal, 'none')#&nbsp;</td>
					</tr>
				</cfloop>
              </cfoutput> 
            </cfloop>
          </table>
        </td>
      </tr>
    </cfif>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <cfoutput> 
    <tr> 
      <td align="center"> ------------------ #MGS_FinDelReporte# ------------------ 
      </td>
    </tr>
    </cfoutput> 
  </table>
</form>
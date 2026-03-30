<!--- Rango de fechas --->
<cfparam name="Form.ETfechai" default="">
<cfparam name="Form.ETfechaf" default="">

<!--- Codigo de Tipo y Titulo --->
<cfparam name="Form.tipo" default=""> 
<cfparam name="Form.titulo" default="">

<!--- Código de Cajas --->
<cfparam name="Form.FCajas" default="">

<!--- Definición de parametros del Form --->
<cfif isdefined('url.ETfechai') and Len(Trim(url.ETfechai)) GT 0>
	<cfset Form.ETfechai = url.ETfechai>
</cfif>
<cfif isdefined('url.ETfechaf') and Len(Trim(url.ETfechaf)) GT 0>
	<cfset Form.ETfechaf = url.ETfechaf>
</cfif>
<cfif isdefined('url.FCajas') and Len(Trim(url.FCajas)) GT 0>
	<cfset Form.FCajas = url.FCajas>
</cfif>
<cfif isdefined('url.tipo') and Len(Trim(url.tipo)) GT 0>
	<cfset Form.Tipo = url.tipo>
</cfif>
<cfif isdefined('url.titulo') and Len(Trim(url.titulo)) GT 0>
	<cfset Form.titulo = url.titulo>
</cfif>

<!--- Asignación de valores a las fechas --->
<cfset ETfechai = Form.ETfechai>
<cfset ETfechaf = Form.ETfechaf>

<!--- Empresa --->
<cfquery name="rsEmpresa" datasource="#Session.DSN#">
	select Edescripcion 
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!--- Máximos y mínimos --->
<cfquery name="rsmaxmin" datasource="#Session.DSN#">
	select convert(varchar,max(ETfecha),103) as maxETfecha, convert(varchar,min(ETfecha),103) as minETfecha
	from ETransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!--- Verifican que si no viene el dato, tome los rangos mínimo y máximos --->
<cfif Len(Trim(ETfechai)) EQ 0>
	<cfset ETfechai = rsmaxmin.minETfecha>
</cfif>
<cfif Len(Trim(ETfechaf)) EQ 0>
	<cfset ETfechaf = rsmaxmin.maxETfecha>
</cfif>

<!--- compara las fechas y modifica las mismas (les da vuelta), de manera que fecha inicial sea menor a fecha final >--->
<cfif LSDateFormat(ETfechai,'YYYYMMDD') GT LSDateFormat(ETfechaf,'YYYYMMDD')>	
	<cfset temp = ETfechai>
	<cfset ETfechai = ETfechaf>
	<cfset ETfechaf = temp>	
</cfif> 

<!--- Query de Cajas --->
<cfquery name="rsCajas" datasource="#Session.DSN#">
	select distinct convert(varchar,a.FCid) as FCid, a.FCcodigo, convert(varchar,b.Mcodigo) as Mcodigo
	from FCajas a, ETransacciones b, CCTransacciones c
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">	
	<cfif Len(Trim(Form.FCajas)) GT 0>
		and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCajas#"> 
	</cfif>
	and b.ETfecha between convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#ETfechai#">,103)
		and convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#ETfechaf#">,103)
	and a.Ecodigo = b.Ecodigo
	and b.CCTcodigo = c.CCTcodigo 
	and b.Ecodigo = c.Ecodigo
	and a.FCid = b.FCid
	 
	<cfif Form.tipo EQ "CO">
		<!--- muestra transacciones de contado --->
		and isnull(c.CCTvencim, 1) = -1
	</cfif>
	<cfif Form.tipo EQ "CR">
		<!--- muestra transacciones de credito --->
		and isnull(c.CCTvencim, 1) != -1
		and c.CCTtipo='D'
	</cfif>
	<cfif Form.tipo EQ "NC">
		<!---  muestra transacciones de notas de credito --->
		and isnull(c.CCTvencim, 1) != -1
		and c.CCTtipo='C'
	</cfif>
	<cfif Form.tipo EQ "AN">
		<!---  muestra transacciones anuladas --->
		and b.ETestado = 'A'		
	</cfif>
	order by a.FCid 	
</cfquery>

<!--- Query de Monedas --->
<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select distinct convert(varchar,a.Mcodigo) as Mcodigo, a.Mnombre 
	from Monedas a, ETransacciones b 
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif Len(Trim(Form.FCajas)) GT 0>
		and b.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCajas#">
	</cfif>
	and a.Ecodigo = b.Ecodigo 
	and a.Mcodigo = b.Mcodigo 
</cfquery>

<cf_sifHTML2Word Titulo="Reporte de Transacciones <cfoutput>#Form.titulo#</cfoutput>">

<style type="text/css">
 .encabReporte {
  background-color: #006699;
  font-weight: bold;
  color: #FFFFFF;
  padding-top: 10px;
  padding-bottom: 10px;
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

<script language="JavaScript1.2" type="text/javascript">
	function detalle(ETnumero, FCid){
		location.href = "/cfmx/sif/fa/consultas/SQLTransaccion.cfm?ETnumero=" + ETnumero + "&FCid=" + FCid;
	}
</script>

<cfoutput>
	<table width="99%"  border="0" cellspacing="0" cellpadding="0" align="center">
		<tr> 
		  	<td colspan="8"><hr size="1" color="##000000"><div align="center"><strong><font size="4">#rsEmpresa.Edescripcion#</font></strong></div></td>
		</tr>
		<tr> 
		  	<td colspan="8"><div align="center"><strong><font size="3">Reporte de Transacciones #Form.titulo#</font></strong></div></td>
		</tr>

		<cfif Len(Trim(Form.ETfechai)) GT 0 or Len(Trim(Form.ETfechaf)) GT 0>
			<tr><td colspan="8"><div align="center"><strong> Del</strong>#LSDateFormat(ETfechai,'DD/MM/YYYY')#&nbsp;<strong>&nbsp;Al</strong>&nbsp;#LSDateFormat(ETfechaf,'DD/MM/YYYY')#</div></td></tr>
		</cfif>

			<tr> 	
				<td colspan="8">
					<table width="100%" cellpadding="3" cellspacing="0" >
						<tr>
							<td colspan="3" align="right" ><b>Usuario: </b>#Session.Usuario#</td>
							<td colspan="1" align="center"><b>Fecha: </b>#DateFormat(Now(),'DD/MM/YYYY')#</td>
							<td colspan="2" align="left"><b>Hora: </b>#TimeFormat(Now(),'medium')#</td>
						</tr>
					</table>
				</td>
			</tr>

		<tr> 
		  	<td colspan="8"><hr size="1" color="##000000">&nbsp;</td>
		</tr>

		<cfif rsCajas.RecordCount GT 0>
			<tr><td>&nbsp;</td></tr>
    		<cfset Caja = "">
			<!--- Inicio del cfloop de rsCajas --->
    		<cfloop query="rsCajas">
				<cfset ptotal = 0 >
				
      			<cfif Caja NEQ rsCajas.FCcodigo>
        			<cfset FCid = rsCajas.FCid>
					
					<cfif rsMonedas.RecordCount GT 0>
					 
						<tr bgcolor="##cccccc"> 
							<td colspan="9"><font size="2"><strong>Caja: #rsCajas.FCcodigo#</strong></font></td>
						</tr>
						<cfset Moneda = "">
						<!--- Inicio del cfloop de rsCajas --->
						<cfloop query="rsMonedas">
          					<cfif Moneda NEQ rsMonedas.Mnombre>
            					<cfset Mcodigo = rsMonedas.Mcodigo>
								
								<!--- Query de Transacciones --->
								<cfquery name="rsTransacciones" datasource="#Session.DSN#">
									select convert(varchar, a.FCid) as FCid, convert(varchar,a.ETdocumento)+a.ETserie 
									as Transaccion, a.ETnumero, a.CCTcodigo +'-' +convert(varchar, a.ETnumero) 
									as Factura, a.SNcodigo, b.SNnombre, convert(varchar, a.ETfecha, 103) 
									as ETfecha, a.ETimpuesto, a.ETmontodes, a.ETtotal, a.ETobs, a.ETtc
									from ETransacciones a, SNegocios b, CCTransacciones c 
									where a.SNcodigo=b.SNcodigo 
									and a.Ecodigo = b.Ecodigo
									and a.CCTcodigo = c.CCTcodigo 
									and a.Ecodigo = c.Ecodigo 
									<!--- and a.ETestado='C' --->
									and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#">
									and a.ETfecha between convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#ETfechai#">,103)
										and convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#ETfechaf#">,103)
									and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
								
									<cfif Form.tipo EQ "CO">
										<!--- muestra transacciones de contado --->
										and isnull(c.CCTvencim, 1) = -1
									</cfif>
									<cfif Form.tipo EQ "CR">
										<!--- muestra transacciones de credito --->
										and isnull(c.CCTvencim, 1) != -1
										and c.CCTtipo='D'
									</cfif>
									<cfif Form.tipo EQ "NC">
										<!---  muestra transacciones de notas de credito --->
										and isnull(c.CCTvencim, 1) != -1
										and c.CCTtipo='C'
									</cfif>
									<cfif Form.tipo EQ "AN">
										<!--- muestra transacciones anuladas --->
										and a.ETestado = 'A'
									</cfif>

									order by a.FCid 
								</cfquery>

								<!--- Query del Total de Monedas --->
								<cfquery name="rsTotalMoneda" dbtype="query">
									select sum(ETtotal) as ETtotal from rsTransacciones 
								</cfquery>
												
								<!--- Query del Total de Cajas --->
								<cfquery name="rsTotalCaja" dbtype="query">
									select sum(ETtotal*ETtc) as Total from rsTransacciones 				
								</cfquery>
								
								<cfif rsTotalCaja.RecordCount GT 0 >
									<cfset ptotal = ptotal + rsTotalCaja.Total >
								<cfelse>
									<cfset ptotal = ptotal + 0 >
								</cfif>

								<cfif rsTransacciones.RecordCount GT 0 >
									<tr> 
										<td colspan="8"><blockquote><p><strong>Moneda: #rsMonedas.Mnombre#</strong></td>
									</tr>
									<tr valign="top"> 
										<td nowrap >&nbsp;</td>
										<td nowrap class="tituloListas"><strong>Transacción</strong></td>
										<td nowrap class="tituloListas"><div align="center"><strong>Factura</strong></div></td>
										<td nowrap class="tituloListas"><div align="center"><strong>Cliente</strong></div></td>
										<td nowrap class="tituloListas"><div align="center"><strong>Fecha</strong></div></td>
										<td nowrap class="tituloListas"><div align="right"><strong>Impuesto</strong></div></td>
										<td nowrap class="tituloListas"><div align="right"><strong>Descuento</strong></div></td>
										<td nowrap class="tituloListas"><div align="right"><strong>Total</strong></div></td></td>
									</tr>
									<!--- Inicio del cfloop de rsTransacciones --->
									<cfloop query="rsTransacciones">
										<tr onClick="javascript:detalle(#rsTransacciones.ETnumero#, #rsTransacciones.FCid#);" class="<cfif rsTransacciones.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>"> 
											<td width="10%" bgcolor="##FFFFFF">&nbsp;</td>
											<td width="10%"><div align="left">#rsTransacciones.Transaccion#</a></div></td>
											<td width="12%"><div align="center"><a href="javascript:detalle(#rsTransacciones.ETnumero#, #rsTransacciones.FCid#);" title="Mostrar detalle de la transacci&oacute;n">#rsTransacciones.Factura#</a></div></td>
											<td width="30%"><div align="left"><a href="javascript:detalle(#rsTransacciones.ETnumero#, #rsTransacciones.FCid#);"   title="Mostrar detalle de la transacci&oacute;n">#rsTransacciones.SNnombre#</a></div></td>
											<td width="12%"><div align="center"><a href="javascript:detalle(#rsTransacciones.ETnumero#, #rsTransacciones.FCid#);" title="Mostrar detalle de la transacci&oacute;n">#rsTransacciones.ETfecha#</a></div></td>
											<td width="12%"><div align="right"><a href="javascript:detalle(#rsTransacciones.ETnumero#, #rsTransacciones.FCid#);"  title="Mostrar detalle de la transacci&oacute;n">#LSCurrencyFormat(rsTransacciones.ETimpuesto,'none')#</a></div></td>
											<td width="12%"><div align="right"><a href="javascript:detalle(#rsTransacciones.ETnumero#, #rsTransacciones.FCid#);"  title="Mostrar detalle de la transacci&oacute;n">#LSCurrencyFormat(rsTransacciones.ETmontodes,'none')#</a></div></td>
											<td width="12%"><div align="right"><a href="javascript:detalle(#rsTransacciones.ETnumero#, #rsTransacciones.FCid#);"  title="Mostrar detalle de la transacci&oacute;n">#LSCurrencyFormat(rsTransacciones.ETtotal,'none')#</a></div></td>
										</tr>
									</cfloop>
									<tr> 
										<td colspan="">&nbsp;</td>
										<td colspan="3"><hr color="##CCCCCC" size="1">&nbsp;</td>
										<td colspan="3"><hr color="##CCCCCC" size="1"><strong>Totales por Moneda en #rsMonedas.Mnombre#</strong></td>
										<td colspan=""><hr color="##CCCCCC" size="1"><div align="right"><strong><cfif rsTotalMoneda.Recordcount GT 0>#LSCurrencyFormat(rsTotalMoneda.ETtotal,'none')#</cfif></strong></div></td> 
									</tr>
									<tr>
										<td colspan="">&nbsp;</td> 
										<td colspan="7">&nbsp;</td>
									</tr>
								</cfif>
								
          					</cfif>
          					<cfset Moneda = rsMonedas.Mnombre>
						</cfloop>
					</cfif>
      			</cfif>
				<cfif ptotal GT 0 >
					<tr><td colspan="8"><hr color="##CCCCCC" size="1"></td></tr>
					<tr>
						<td colspan="">&nbsp;</td> 
						<td colspan="3">&nbsp;</td>
            			<td colspan="3"><strong>Totales por Caja #rsCajas.FCcodigo#:</strong></td>
						<td colspan=""><div align="right"><strong>#LSCurrencyFormat(ptotal,'none')#</strong></div></td> 
					</tr>
				</cfif>
					<tr>
					<td colspan="">&nbsp;</td> 
      				<td colspan="7">&nbsp;</td>
   	 		</tr>
      			<cfset Caja = rsCajas.FCcodigo>
    		</cfloop>
			<tr>
				<td height="35" colspan="8">
					<div align="center"> 
					<strong> ---------- FIN DEL REPORTE ----------</strong> 
					</div>
				</td>
			</tr>
		<cfelse>
			<tr>
				<td height="35" colspan="8">
					<div align="center"> 
					<strong>---------- NO HAY DATOS ----------</strong>
					</div> 
				</td>
			</tr>
  		</cfif> 
  	</table>
</cfoutput>
</cf_sifHTML2Word>


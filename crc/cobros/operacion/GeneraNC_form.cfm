<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Title 		= t.Translate('LB_SNegocio','Confirmacion de Orden de Pago Manual')>

<cfoutput>

<!--- Validar la definicion del Concepto de servicio en Parametros CRC--->
<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
<cfset val = objParams.GetParametroInfo('30200505')>
<cfif val.valor eq ''><cfthrow message="El parametro [30200505 - Concepto de Servicio por Pronto Pago] no esta definido"></cfif>

<!--- Obtener Concepto de Servicio --->
<cfquery name="rsConcepto" datasource="#session.DSN#">
	select Cid, Ccodigo, Cdescripcion from Conceptos where Ecodigo = #Session.Ecodigo#
	and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#val.valor#">
	order by Ccodigo
</cfquery>

<!--- Obtener Cuenta Financiera Asociada al concepto de servicio --->
<cfquery name="rsCformato" datasource="#session.dsn#">
	select '' as ccuenta, '' as cdescripcion, Cformato from Conceptos where Ecodigo = #Session.Ecodigo#
	and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#val.valor#">
</cfquery>

<cf_templateheader title="#LB_Title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Title#'>
	<form name="form1" method="post" action="GeneraNC_sql.cfm">
		<cfif isdefined("form.chk")>
			<input name="chk" type="hidden" value="#form.chk#">
		</cfif>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td colspan="2">
					<cfinclude template="/home/menu/pNavegacion.cfm">
				</td>
			</tr>
			<tr>
				<td align="right">
					<font size="2">Total de Comision: </font>
				</td>
				<td align="left">
					<cfquery name="q_totalDescuento" datasource="#session.dsn#">
						select round(sum(d.DTdeslinea),2) DTdeslinea
						from ETransacciones e
								inner join DTransacciones d
									on d.ETnumero = e.ETnumero
								<!--- inner join FPAgos f
									on e.ETnumero = f.ETnumero --->
								inner join CRCCuentas c
									on d.CRCCuentaid = c.id
								inner join SNegocios s
									on c.SNegociosSNid = s.SNid
						where e.Ecodigo=#session.Ecodigo# and e.ETestado = 'C' and d.DTborrado = 0 and e.ETnumero in (#form.chk#)
					</cfquery>
					<input type="text"  value="#lsCurrencyFormat(q_totalDescuento.DTdeslinea)#" readonly>
				</td>
				
				<td>
					<input type="hidden" name="comisionTotal" value="#q_totalDescuento.DTdeslinea#">
					<input type="hidden" name="ETnumeros" value="#form.chk#">
					<cf_botones values="Aplicar,Regresar">
				</td>
			</tr>
			<tr style="display:none;">
				<td align="right"><font size="2">Concepto de Servicio:&nbsp;</font> <td>
				<cf_sifconceptos form="form1" query=#rsConcepto# size="22"  tabindex="1" readonly>
				
			</tr>
			<tr>
				<td align="right"><font size="2">Centro Funcional:&nbsp;</font> <td>
				<cf_cboCFid form="form1" tabindex="1">
			</tr>
			<tr>
				<td colspan="3">
					<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
						tabla="ETransacciones e 
								inner join ( 
									select d.CRCCuentaid, d.ETnumero, d.Ecodigo, round(sum(d.DTpreciou),2) DTtotal, round(sum(d.DTtotal),2) DTSubTotal,round(sum(d.DTdeslinea),2) DTdeslinea 
									from DTransacciones d
									where d.DTborrado = 0 and d.DTdeslinea > 0
									group by d.CRCCuentaid, d.ETnumero, d.Ecodigo
								) d on d.ETnumero = e.ETnumero and e.Ecodigo = d.Ecodigo
								inner join (
									select distinct ETnumero from  FPAgos 
								) f on e.ETnumero = f.ETnumero
								inner join CRCCuentas c on d.CRCCuentaid = c.id
								inner join SNegocios s on c.SNegociosSNid = s.SNid"
						columnas="e.ETnumero, e.Ecodigo,e.ETestado, e.ETfecha,
									DTtotal,DTSubTotal,DTdeslinea, 
									c.SNegociosSNid,s.SNnombre"
						desplegar="ETfecha,SNnombre,DTtotal,DTSubTotal,DTdeslinea"
						etiquetas="Fecha,Socio de Negocio,Total,SubTotal,Descuento"
						formatos="S,S,S,S,M,M"
						filtro="e.Ecodigo=#session.Ecodigo# and e.ETnumero in (#form.chk#)
									and e.ETestado = 'C' 
									and e.ETnumero not in (select distinct(ETnumero) from CRCGenerarNC)
									order by e.ETfecha"
						align="left,left,right,right,right"
						ajustar="S"
						showlink="false">
					</cfinvoke>
				</td>
			</tr>
			<tr>
				<td>
				</td>
			</tr>		
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
</cfoutput>

<script>
	function funcRegresar(){
		document.form1.action = "GeneraNC.cfm?"
	}
	function funcAplicar(){
		return confirm("Esta seguro que desea generar esta Nota de Credito?");
	}
</script>
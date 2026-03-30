<cfparam name="url.cobros">
<cfparam name="url.id_pago">
<cfquery datasource="#session.dsn#" name="pago">
	select * from sa_pagos
	where id_pago = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_pago#">
	  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

				<cfquery datasource="#session.dsn#" name="cobros">
	select
		p.Pnombre, p.Papellido1, p.Papellido2, p.Pid,
		r.nombre_programa,
		v.nombre_vigencia,
		c.fecha_cobro, c.moneda,
		c.importe,
		pa.importe_doc, pa.moneda_doc,
		pa.importe_pago, pa.moneda_pago,
		g.importe as importe_total_pago,
		g.moneda  as moneda_total_pago
	from sa_cobros c
		join sa_afiliaciones a
			on  a.id_persona = c.id_persona
			and a.id_programa = c.id_programa
			and a.id_vigencia = c.id_vigencia
		join sa_vigencia v
			on  v.id_programa = c.id_programa
			and v.id_vigencia = c.id_vigencia
		join sa_programas r
			on  r.id_programa = c.id_programa
		join sa_personas p
			on  p.id_persona = c.id_persona
		join sa_pago_aplicado pa
			on  pa.id_persona = c.id_persona
			and pa.id_programa = c.id_programa
			and pa.id_vigencia = c.id_vigencia
			and pa.id_cobro    = c.id_cobro
		join sa_pagos g
			on  g.id_pago     = pa.id_pago
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and pa.id_pago = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_pago#" list="yes">
</cfquery>
<cf_template>
<cf_templatearea name=title>Pago registrado</cf_templatearea>
<cf_templatearea name=body>

<table width="100%" border="0">
        <!--DWLayoutTable-->
        <tr> 
          <td valign="top">
          <table align="center" border="0" cellspacing="2" style="border:solid 1px #000000; text-shadow: 6px;">
              <!--DWLayoutTable-->
			  <cfoutput>
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">Cobros No. <span class="orderno">#HTMLEditFormat(url.cobros)#</span></td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">Pago No. <span class="orderno">#HTMLEditFormat(url.id_pago)#</span></td>
              </tr>
              <tr>
                <td colspan="3" align="right" style="border-bottom:solid 2px ##c0c0c0;padding-bottom:4px;"><!--DWLayoutEmptyCell-->&nbsp;</td>
                </tr>
              <tr>
                <td colspan="3"> <strong>La transacci&oacute;n ha sido completada con &eacute;xito</strong></td>
                </tr>
              <tr>
                <td colspan="2"><!--DWLayoutEmptyCell-->&nbsp;</td>
                <td><!--DWLayoutEmptyCell-->&nbsp;</td>
              </tr>
              <tr>
                <td colspan="3" valign="top" align="center" class="tituloListas">Detalle del pago realizado </td>
              </tr>
              <tr>
                <td colspan="3">
Cobros seleccionados:
<cfinvoke component="sif.rh.Componentes.pListas" method="pListaQuery"
	query="#cobros#"
	desplegar="Pnombre,Papellido1,Papellido2,Pid,nombre_programa,nombre_vigencia,fecha_cobro,moneda,importe,importe_doc"
	etiquetas="Nombre,Apellidos, ,C&eacute;dula,Programa,Vigencia,Fecha, ,Importe,Pago"
	align="left,left,left,left,left,left,left,right,right,right"
	formatos="S,S,S,S,S,S,D,S,M,M"
	irA="javascript:void(0)"
	MAXROWS="0"
	totales="importe,importe_doc" />

				</td>
              </tr>
<tr><td colspan="3" class="subTitulo tituloListas">Pago recibido: &nbsp; #cobros.moneda_total_pago# #NumberFormat(cobros.importe_total_pago,',0.00')#</td></tr>
			  </cfoutput>
              <tr>
                <td colspan="3" valign="top"><!--DWLayoutEmptyCell-->&nbsp;      </td>
              </tr>
              <tr>
                <td colspan="3" valign="top" >
			<cfif pago.forma_pago is 'T'>
				<cf_tarjeta action="display" key="#pago.id_tarjeta#">
				
				
				<cfelseif pago.forma_pago is 'C'>
					
			<cfquery datasource="#session.dsn#" name="bancos">
				select Bid, Bdescripcion
				from Bancos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pago.cheque_Bid#">
			</cfquery>
			<cfoutput>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr align="center">
				<td colspan="3" class="tituloListas">Pago con cheque</td>
			  </tr>
			  <tr>
				<td width="200" align="right"><strong>N&uacute;mero de cheque:</strong></td>
				<td width="5">&nbsp;</td>
				<td width="364">#HTMLEditFormat(pago.cheque_numero)#
				</td>
			  </tr>
			  <tr>
				<td align="right"><strong>N&uacute;mero de cuenta cliente: </strong></td>
				<td>&nbsp;</td>
				<td>#HTMLEditFormat(pago.cheque_cuenta)#</td>
			  </tr>
			  <tr>
				<td align="right"><strong>Banco:</strong></td>
				<td>&nbsp;</td>
				<td>#HTMLEditFormat(bancos.Bdescripcion)#</td>
			  </tr>
			</table></cfoutput>
		<cfelseif pago.forma_pago is 'E'>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr align="center">
				<td colspan="3" class="tituloListas subTitulo">Pago en efectivo</td>
			  </tr></table>
		<cfelse>
			<cfthrow message="Forma de pago inválida: #pago.forma_pago#">
		</cfif>
				
				</td>
              </tr>
              <tr>
                <td colspan="3" align="center" valign="top" >
				<form name="form1" method="get" action="index.cfm">
                  <input type="submit" name="Submit" value="Listo">
                </form></td>
              </tr>
          </table>          
          </td>
        </tr>
</table>
</cf_templatearea>
</cf_template>

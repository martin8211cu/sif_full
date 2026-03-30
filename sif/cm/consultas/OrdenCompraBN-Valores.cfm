<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfset max_lineas = 9>
<!---==Obtener el ID de la Orden de Compra==--->
<cfif isdefined("url.EOidorden") and len(trim(url.EOidorden)) and not isdefined("form.EOidorden")>
	<cfset form.EOidorden = url.EOidorden >
</cfif>
<cfif not isdefined("form.EOidorden") >
	<cfif isdefined("url.EOnumero") and len(trim(url.EOnumero))>
		<cfquery name="rsOrden" datasource="#session.DSN#">
			select EOidorden
			from EOrdenCM
			where Ecodigo =  #Session.Ecodigo# 
			and EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOnumero#">
		</cfquery>
		<cfset form.EOidorden = rsOrden.EOidorden >
	</cfif>
</cfif>
<cfif not (isdefined("form.EOidorden") and len(trim(form.EOidorden)))>
	<cf_errorCode	code = "50272" msg = "No ha sido definida la Orden que desa imprimir.">
</cfif>
<!---===Estilos===--->
<cf_templatecss>
<style type="text/css">
	
	.LetraDetalle{
		font-size:9;
		px;
	}
	.LetraEncab{
		font-size:10px;
		font-weight:bold;
	}
	.visible{
	border:1;
	}
.style3 {
	font-size: 8px;
	font-weight: bold;
}
</style> 
<cfquery name="Empresa" datasource="asp">
		select Efax, Etelefono1 from Empresa where Ecodigo = #session.Ecodigo#
</cfquery>
<cfquery name="data" datasource="#session.DSN#">
	select 
	 rtrim(c.Edescripcion) as TituloEmpresa, 
	 f.SNidentificacion as CedulaJuridica,
	 coalesce(f.SNFax,'No disponible') as FaxProveedor, 
	 coalesce('#Empresa.Efax#','') as FaxEmpresa,
	 coalesce('#Empresa.Etelefono1#','') as TelEmpresa,
	 f.SNnumero,
	 (select min(SNCnombre) from SNContactos where Ecodigo = f.Ecodigo and SNcodigo = f.SNcodigo) as contacto, 
	 a.EOfecha as FechaOC, 
	 b.DOconsecutivo,
	 b.DOcantidad,
	 coalesce(ltrim(rtrim(b.DOdescripcion)),'') #_Cat#
	 	case coalesce(rtrim(b.DOalterna),' ') when ' ' then '' else ' /'#_Cat# b.DOalterna end  #_Cat#
		case coalesce(rtrim(b.DOobservaciones),' ') when ' ' then '' else ' /'#_Cat# b.DOobservaciones end 
	  as DescripcionDetalle,	
	 #LvarOBJ_PrecioU.enSQL_AS("b.DOpreciou")#,
	 b.DOtotal,
	 (select Msimbolo from Monedas where Ecodigo = a.Ecodigo and Mcodigo = a.Mcodigo) as codMoneda, 
	 a.EOnumero,   
	 a.EOtotal + a.EOdesc - a.Impuesto as SubtotalOC,
	 a.EOdesc as DescuentoOC,
	 a.EOtotal - a.Impuesto as SubTotalConDescOC,
	 a.Impuesto as ImpuestoOC,
	 a.EOtotal as TotalOC, 
	 a.EOplazo,
	 coalesce(a.Observaciones,'') as DescripcionE,
	 a.EOidorden,
	 a.CMCid,
	 b.Icodigo,
	 a.EOImpresion, 
     f.SNdireccion as Direccion,
     f.SNnombre as NombreProveedor,
	 h.Ucodigo, 
	 b.DOfechareq as fechaRequerida,
	 b.DOfechaes as fechaest,
	 case coalesce(I.Iporcentaje,0.00) when 0.00 then 'S' else '&nbsp;' end  exento,
	 (select min(Coalesce(CMCnombre,'')) from CMCompradores where Ecodigo = a.Ecodigo and CMCid = a.CMCid) NombreComprador
	 
		from EOrdenCM a 
		inner join DOrdenCM b
		  			 left join Almacen al <!--- Se pone un left por que el campo Alm_Aid acepta nulos --->
						on al.Aid  = b.Alm_Aid
					on a.Ecodigo = b.Ecodigo
					and a.EOidorden = b.EOidorden
		left outer join DCotizacionesCM r
					on b.DClinea = r.DClinea
		left outer join CMProcesoCompra s
					on r.CMPid = s.CMPid
		inner join Empresas c 
					on a.Ecodigo = c.Ecodigo
		inner join SNegocios f
					on a.Ecodigo = f.Ecodigo
					and a.SNcodigo = f.SNcodigo
		inner join Unidades h
					on  b.Ecodigo = h.Ecodigo
					and b.Ucodigo = h.Ucodigo
		left outer join DSolicitudCompraCM g
					on  g.Ecodigo = b.Ecodigo
					and g.ESidsolicitud = b.ESidsolicitud 
					and g.DSlinea = b.DSlinea 
		left outer join Articulos j
				   on b.Aid=j.Aid
				   and b.Ecodigo=j.Ecodigo 
		left outer join Conceptos k
				   on b.Cid=k.Cid
				   and b.Ecodigo=k.Ecodigo 
		left outer join AClasificacion ac
				   on b.Ecodigo = ac.Ecodigo
				   and b.ACcodigo = ac.ACcodigo
				   and b.ACid = ac.ACid  
		left outer join ACategoria atl
				   on b.Ecodigo = atl.Ecodigo
				   and b.ACcodigo = atl.ACcodigo
		left outer join CMFormasPago cmf
				   on a.CMFPid = cmf.CMFPid
		inner join Impuestos I
				   on b.Ecodigo = I.Ecodigo
				   and b.Icodigo = I.Icodigo
		where a.Ecodigo =  #Session.Ecodigo# 
   		  and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		order by b.DOconsecutivo
</cfquery>

<cfif data.recordCount EQ 0>
	<cf_errorCode	code = "50273" msg = "No se encontraron datos para el detalle de la Orden de Compra">
</cfif>

<cfquery name="rsAutoriza" datasource="#session.DSN#">
	select count(1) as cantidad
	from CMAutorizaOrdenes
	where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.EOidorden#">
</cfquery>

<cfif rsAutoriza.cantidad gt 0 >
	<!---
		CMAestado (Estado por cada comprador): 
			0 = En Proceso, 1 = Rechazado, 2 = Aprobado
		CMAestadoproceso (Estado general de la orden de Compra): 
			0 = En Proceso, 5 = Rechazado con posibilidad de revivir, 10 = Rechazado sin opcion de revivir, 15 = Aprobado
		Nivel (Jerarquía de Compradores, el último en autorizar debe ser el que tiene el MAYOR nivel)
	--->

	<!--- ME DICE EL ULTIMO COMPRADOR QUE AUTORIZO O RECHAZO LA ORDEN --->
	<cfquery name="dataComprador" datasource="#session.DSN#" maxrows="1">
		select CMAid, CMCid, Nivel, coalesce(CMAestadoproceso,0) as CMAestadoproceso
		from CMAutorizaOrdenes 
		where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.EOidorden#">
		and CMAestado in (1,2)
		and CMAestadoproceso <> 10
		and Nivel = ( select max(Nivel)
					  from CMAutorizaOrdenes 
					  where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.EOidorden#">
						and CMAestadoproceso <> 10
						and CMAestado in (1,2) )
	</cfquery>
	<cfif dataComprador.recordCount gt 0 and dataComprador.CMAestadoproceso eq 15>
		<cfquery name="rsComprador" datasource="#session.dsn#" >
			select CMCnombre 
			from CMCompradores 
			where CMCid = #dataComprador.CMCid#
		</cfquery>
		<cfset NombreAprobador = rsComprador.CMCnombre>
	</cfif>
<cfelse>
	<cfset NombreAprobador= #data.NombreComprador#>
</cfif>
	<cfoutput>
	 <cfset contador= 0>
		<cfloop query="data">	
			<cfset contador = contador+1>	
			<cfif contador EQ 1>
				<cfset fnColcarEncabezado()>
				<cfset fnColocarEDetalle()>
			</cfif>
			<cfset fnColocarDDetalle()>
			<cfif (isdefined("Url.imprimir") and contador eq max_lineas)>
				<cfset fnCambioPagina()>
				<cfset contador= 0>	
			</cfif>
		</cfloop>
				<cfset FinLineasDetalle()>
				<cfset fnColocarResumen()>
				<cfset fnColocarPiePagina()>
	</cfoutput>

<!---Verificar el estado de la impresion de la orden actualmente
	'I' = Impresa la primera vez 
	' ' = Nunca se ha impreso
	'R' = Reimpresion ----->
<cfquery name="rsEstadoImpresion" datasource="#session.DSN#">
	select ltrim(rtrim(EOImpresion)) as EOImpresion from EOrdenCM 
	where Ecodigo =  #Session.Ecodigo# 
		and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
</cfquery>
<!----ACTUALIZAR EL ESTADO DE LA IMPRESION DE LA OC----->
<cfif isdefined("url.Imprimir") and len(trim(rsEstadoImpresion.EOImpresion)) EQ 0><!----Si la OC todavia no ha sido impresa por primera vez---->
	<cfquery datasource="#session.DSN#">
		update EOrdenCM
		set EOImpresion='I'
		where Ecodigo =  #Session.Ecodigo# 
			and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	</cfquery>	
<cfelseif isdefined("url.Imprimir")>
	<cfquery datasource="#session.DSN#">
		update EOrdenCM
		set EOImpresion='R'
		where Ecodigo =  #Session.Ecodigo# 
			and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	</cfquery>
</cfif>


<cffunction name="fnColcarEncabezado" output="true">
	<table width="100%" cellpadding="2" cellspacing="0" align="center" >
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
		<!---	<tr><td align="center" class="LetraEncab">#data.TituloEmpresa#</td></tr>
			<tr><td align="center" class="LetraEncab">Cedula Jurídica: #data.CedulaJuridica#</td></tr>
			<tr><td nowrap align="center" class="LetraEncab">Tel&eacute;fono: #data.TelEmpresa#   Fax:#data.FaxEmpresa#</td></tr>
			<tr><td>&nbsp;</td></tr>--->
			<tr><td align="center"><strong><font size="2">Orden de Compra #data.EOnumero#</font></strong></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td>
				<table width="80%" border="0" align="center" cellpadding="2" cellspacing="0">
					<tr>
						<td width="8%" nowrap class="LetraEncab">Proveedor:</td>
						<td width="50%" nowrap class="LetraDetalle">#data.NombreProveedor#</td>
						<td width="7%"  nowrap class="LetraEncab">Fax:</td>
						<td width="35%" nowrap class="LetraDetalle">#data.FaxProveedor#</td>
					</tr>
					<tr>
						<td nowrap class="LetraEncab">Contacto:</td>
						<td nowrap class="LetraDetalle">#data.contacto#</td>
						<td nowrap class="LetraEncab">Fecha:</td>
						<td nowrap class="LetraDetalle">#LSDateFormat(data.FechaOC,'dd/mm/yyyy')#</td>
					</tr>
				</table>
			</td></tr>
		</table>
</cffunction>

<cffunction name="fnColocarEDetalle" output="true">
	<table width="100%" border="1" bordercolor="000000" cellspacing="0">
	<tr>
		<td align="center" colspan="6">Detalle de la Orden de Compra</td>
	</tr>
	<tr class="titulolistas">
		<td width="5%" class="LetraEncab"  align="center">L&iacute;n.</td>
		<td width="8%" class="LetraEncab"  align="center">Cantidad</td>
		<td width="56%" class="LetraEncab" align="center">Descripción</td>
		<td width="13%" class="LetraEncab" align="center">Precio Unit</td>
		<td width="20%" class="LetraEncab" align="center">Costo Total</td>
		<td width="4%" class="LetraEncab"  align="center">Exento.</td>
	</tr>
</cffunction>
<cffunction name="fnColocarDDetalle" output="true">
	<cfif isdefined ('data.fechaRequerida')>
		<cfset Label="Fecha Requerida">
		<cfset date= DateFormat(data.fechaRequerida,'dd/mm/yyyy')>
	<cfelse>
		<cfset Label="Fecha Estimada">
		<cfset date= DateFormat(data.fechaest,'dd/mm/yyyy')>
	</cfif>
	<tr>
		<td class="LetraDetalle">#data.DOconsecutivo#</td>
		<td class="LetraDetalle">#LSNumberFormat(data.DOcantidad,',9.00')# #data.Ucodigo#</td>
		<td class="LetraDetalle">#data.DescripcionDetalle# &nbsp;&nbsp;#Label#:&nbsp;#date#</td>
		<td class="LetraDetalle" align="right">#LvarOBJ_PrecioU.enCF_RPT(data.DOpreciou)#</td>
		<td class="LetraDetalle" align="right">#LSNumberFormat(data.DOtotal,',9.00')#</td>
		<td class="LetraDetalle" align="center">#data.exento#</td>
	</tr>
</cffunction>
<cffunction name="FinLineasDetalle" output="true">
	<tr><td colspan="6">
		<div align="center">******************************última Línea******************************</div>
	</td></tr>
</cffunction>
<cffunction name="fnCambioPagina" output="true">
	</table>
	<BR style="page-break-after:always;">	
</cffunction>
<cffunction name="fnColocarResumen" output="true">
  	 <tr><td colspan="3">
	     <table width="100%">
			 <tr>
			   <td>#data.DescripcionE#</td>
			    <td>&nbsp;</td>
			 </tr>
	     </table>
	<td colspan="3">
		<table>
		<tr>
		<td width="7%" nowrap="nowrap" class="LetraEncab">Subtotal:</td>
		<td width="18%" class="LetraDetalle">#data.codMoneda##LSNumberFormat(data.SubtotalOC,',9.00')#</td>
		</tr>
		<tr>
		<td class="LetraEncab">Descuento:</td>
		<td class="LetraDetalle">#data.codMoneda##LSNumberFormat(data.DescuentoOC,',9.00')#</td>
		</tr>
		<tr>
		<td class="LetraEncab">TOTAL:</td>
		<td class="LetraDetalle">#data.codMoneda##LSNumberFormat(data.SubTotalConDescOC,',9.00')#</td>
		</tr>
		<tr>
		<td class="LetraEncab">Impuestos:</td>
		<td class="LetraDetalle">#data.codMoneda##LSNumberFormat(data.ImpuestoOC,',9.00')#</td>
		</tr>
		<tr>
		<td class="LetraEncab">TOTAL:</td>
		<td class="LetraDetalle">#data.codMoneda##LSNumberFormat(data.TotalOC,',9.00')#</td>
	</tr>
	</table>
</cffunction>
<cffunction name="fnColocarPiePagina" output="true">
<!--- <tr><td colspan="6" class="LetraDetalle">
		Tiempo de Entrega #data.EOplazo# días.
	</td></tr>--->
  	<tr><td colspan="6">
  		<p class="LetraDetalle">Nota: En caso de atraso por parte de la empresa adjudicada en la entrega del producto adquirido con respecto a la fecha establecida en la Orden de Compra, BN VALORES PUESTO DE BOLSA S.A cobrara un 2% del monto total de la contratación por cada día de atraso, hasta lograr un total del 25% del total de la misma.</p>
		<p class="LetraDetalle">Los pagos se realizan 100% contra la entrega del producto o servicio. La Factura sé tramita luego de recibido el producto y servicio a entera satisfacción de BN Valores, y para ello BN Valores contará con un plazo de 30 días naturales para realizar el pago.</p>
	</td></tr>
	<tr><td colspan="6">
			<!---=========Firmas========--->	
			<table width="100%" align="center"cellpadding="2" cellspacing="1" border="0">
				<tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
				<tr>
					<td><div align="center">Realizado por:</div></td>
					<td><div align="center">Aprobado por:</div></td>
				</tr>
				<tr><td>&nbsp;</td><td>&nbsp;</td></tr>
				<tr>
					<td><div align="center">____________________</div></td>
					<td><div align="center">____________________</div></td>
				</tr>
				<tr>
					<td><div align="center">#data.NombreComprador#</div></td>
					<td><div align="center">#NombreAprobador#</div></td>
				</tr>
			 </table>
	</td></tr>
	</table>
	<table align="right">
	<tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
		<cfif (len(trim(data.EOImpresion)) EQ 0) or (isdefined("url.primeravez"))>
			<tr><td class="LetraEncab"><div align="right">ORIGINAL - PROVEEEDOR</div></td></tr>	
		<cfelseif len(trim(data.EOImpresion))>
			<tr><td class="LetraEncab"><div align="right">(COPIA NO NEGOCIABLE)</div></td></tr>
		</cfif>
		<cfif isdefined("Url.imprimir") and data.recordCount>
			<tr><td align="right" class="LetraDetalle"><strong>Pág. #Ceiling(data.recordCount / max_lineas)#/#Ceiling(data.recordCount / max_lineas)#</strong></td></tr>
		</cfif>
 </table>

</cffunction>



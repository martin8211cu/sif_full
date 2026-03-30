<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfif isdefined("url.ESidsolicitud") and not isdefined("form.ESidsolicitud")>
	<cfset form.ESidsolicitud = Url.ESidsolicitud>
</cfif>
<!------ Query con los datos del encabezado de la solicitud seleccionada ------>
<cfquery name = "rsSolicitud" datasource="#session.DSN#" >
	select 	a.ESnumero,a.ESfecha,a.ESestado,a.EStotalest,a.EStipocambio,
			b.CMScodigo,b.CMSnombre,
			c.CMTSdescripcion,
			d.Mnombre		 		
	
	from ESolicitudCompraCM a
		inner join CMSolicitantes b
			on a.CMSid = b.CMSid
			and a.Ecodigo = b.Ecodigo
		inner join CMTiposSolicitud c
			on a.CMTScodigo = c.CMTScodigo
			and a.Ecodigo = c.Ecodigo
		inner join Monedas d
			on a.Mcodigo = d.Mcodigo
			and a.Ecodigo = d.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
</cfquery>

<!---Query con las ordenes de compra que pertencen a la solicitud --->
<cfquery name = "rsOrdenes" datasource="#session.DSN#">
	select 	a.EOnumero, a.EOfecha, a.Observaciones,a.EOestado,a.EOidorden,
			b.ESidsolicitud, b.DOconsecutivo, b.DOcantidad, b.DOcantsurtida, b.DOfechaes, b.DOlinea,
			m.CMCcodigo,m.CMCnombre,
			b.Ucodigo,
			n.CFcodigo,n.CFdescripcion,
			r.Almcodigo,r.Bdescripcion,
			b.CMtipo,
			case CMtipo when 'A' then Acodigo#_Cat#'-'#_Cat#Adescripcion
						when 'S' then h.Ccodigo#_Cat#'-'#_Cat#Cdescripcion				
						when 'F' then j.ACdescripcion#_Cat#'/'#_Cat#k.ACdescripcion end as Item
	
	from 	EOrdenCM a
		
		inner join CMCompradores m
			on a.CMCid = m.CMCid
			and a.Ecodigo = m.Ecodigo
			
		inner join DOrdenCM b
			on a.EOidorden = b.EOidorden
		
		<!---Articulos--->
		left outer join Articulos f
			on b.Aid=f.Aid
			and b.Ecodigo=f.Ecodigo	
		  
		<!---Conceptos--->
		left outer join Conceptos h
			on b.Cid=h.Cid
			and b.Ecodigo=h.Ecodigo
		
		<!---Activos--->
		left outer join ACategoria j
			on b.ACcodigo=j.ACcodigo
			and b.Ecodigo=j.Ecodigo
	 
		left outer join AClasificacion k
			on b.ACcodigo=k.ACcodigo
			and b.ACid=k.ACid
			and b.Ecodigo=k.Ecodigo
		
		inner join CFuncional	n
			on b.CFid = n.CFid
			and b.Ecodigo = n.Ecodigo	
		
		left outer join Almacen r
			on b.Alm_Aid = r.Aid
			and b.Ecodigo = r.Ecodigo
	
	where 	a.Ecodigo = #session.Ecodigo#	
		and b.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
	order by a.EOnumero, b.DOlinea
</cfquery>

<!---Query con las cotizaciones que pertenecen a la solicitud seleccionada --->
<cfquery name="rsCotizaciones" datasource="#session.DSN#">
	select  m.ESidsolicitud,
			d.ECnumero,
			p.Mnombre,
			n.SNnombre,
			a.DSconsecutivo,
			e.DCcantidad,
			#LvarOBJ_PrecioU.enSQL_AS("e.DCpreciou")#,	
			a.Ucodigo,	
			case a.DStipo 	when 'A' then Acodigo#_Cat#'-'#_Cat#Adescripcion
						  	when 'S' then h.Ccodigo#_Cat#'-'#_Cat#Cdescripcion				
							when 'F' then j.ACdescripcion#_Cat#'/'#_Cat#k.ACdescripcion end as Item		
	from 	
		DSolicitudCompraCM a
		
		<!---Articulos--->
		left outer join Articulos f
			on a.Aid=f.Aid
			and a.Ecodigo=f.Ecodigo	
		  
		<!---Conceptos--->
		left outer join Conceptos h
			on a.Cid=h.Cid
			and a.Ecodigo=h.Ecodigo
		
		<!---Activos--->
		left outer join ACategoria j
			on a.ACcodigo=j.ACcodigo
			and a.Ecodigo=j.Ecodigo
	 
		left outer join AClasificacion k
			on a.ACcodigo=k.ACcodigo
			and a.ACid=k.ACid
			and a.Ecodigo=k.Ecodigo	
	
		inner join ESolicitudCompraCM m
			on a.ESidsolicitud = m.ESidsolicitud
			and a.Ecodigo = m.Ecodigo 
	
		inner join CMLineasProceso b
			on a.DSlinea = b.DSlinea
		
		inner join CMProcesoCompra c
			on b.CMPid = c.CMPid		
			and c.CMPestado in (10,50)
	
		inner join ECotizacionesCM d
			on c.CMPid = d.CMPid
			and c.Ecodigo = d.Ecodigo
			and d.ECestado = 10
		
		inner join Monedas p 
			on d.Mcodigo = p.Mcodigo
			and d.Ecodigo = p.Ecodigo
	
		inner join SNegocios n
			on d.SNcodigo = n.SNcodigo
			and d.Ecodigo =n.Ecodigo
	
		inner join DCotizacionesCM e
			on d.ECid = e.ECid
			and d.Ecodigo = e.Ecodigo
			and e.DSlinea = a.DSlinea
			
	where a.Ecodigo = #session.Ecodigo#
		and m.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
		and m.ESestado in (20,25,40,50)
	order by d.ECnumero
</cfquery>


<cfoutput>
<!------------------------- Pintado del reporte ------------------------------------>
<!----- Pintado Encabezado ----->
<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
  <tr><td colspan="3" align="center" class="tituloAlterno"><strong><font size="3">#session.enombre#</font></strong></td></tr>
  <tr><td  nowrap colspan="3">&nbsp;</td></tr>
  <tr><td colspan="3" align="center"><strong><font size="3">Consulta de Seguimiento de Solicitudes</font></strong></td></tr>
  <tr><td colspan="3" align="center"><strong><font size="2">Fecha de la Consulta:&nbsp;</font></strong><font size="2">#LSDateFormat(Now(),'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(Now(),'medium')#</font></td></tr>
  <tr><td colspan="3" nowrap>&nbsp;</td></tr>
</table>


	  <table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
		  <tr bgcolor="##cccccc">  
			<td nowrap width="17%" style="border-top:2px solid black; border-left:2px solid black;"><strong>&nbsp;N° Solicitud:</strong> #rsSolicitud.ESnumero#&nbsp;</td>
			<td nowrap width="19%" style="border-top:2px solid black;"><strong>&nbsp;Tipo:</strong> &nbsp;#rsSolicitud.CMTSdescripcion#</td>
			<td nowrap width="17%" style="border-top:2px solid black;"><strong>&nbsp;Fecha: </strong>&nbsp;#LSDateFormat(rsSolicitud.ESfecha,'dd/mm/yyy')#&nbsp;</td>
			<cfif rsSolicitud.ESestado EQ -10>
			  <td nowrap style="border-top:2px solid black;"><strong>&nbsp;Estado:</strong>&nbsp;Pendiente&nbsp;</td>
			  <cfelseif rsSolicitud.ESestado EQ 10>
			  <td nowrap style="border-top:2px solid black;"><strong>&nbsp;Estado:</strong>&nbsp;En espera de Aprobación&nbsp;</td>
			  <cfelseif rsSolicitud.ESestado EQ 20>
			  <td nowrap style="border-top:2px solid black;"><strong>&nbsp;Estado:</strong>&nbsp;Aplicada &nbsp;</td>
			  <cfelseif rsSolicitud.ESestado EQ 25>
			  <td nowrap style="border-top:2px solid black;"><strong>&nbsp;Estado:</strong>&nbsp;OC Directa&nbsp;</td>
			  <cfelseif rsSolicitud.ESestado EQ 40>
			  <td nowrap style="border-top:2px solid black;"><strong>&nbsp;Estado:</strong>&nbsp;Parcialmente Atendida&nbsp;</td>
			  <cfelseif rsSolicitud.ESestado EQ 50>
			  <td nowrap style="border-top:2px solid black;"><strong>&nbsp;Estado:</strong>&nbsp;Atendida&nbsp;</td>
			  <cfelse>
			  <td width="0%" nowrap >&nbsp;</td>
			</cfif>
			<td style="border-right:2px solid black; border-top:2px solid black;">&nbsp;</td>
		  </tr>
		
		  <tr bgcolor="##cccccc">
			<td nowrap width="17%" style="border-bottom:2px solid black; border-left:2px solid black;"><strong>&nbsp;Solicitante:</strong>&nbsp;#rsSolicitud.CMSnombre#&nbsp;</td>
			<td nowrap width="19%" style="border-bottom:2px solid black;"><strong>&nbsp;Total Estimado: </strong>&nbsp;#LSCurrencyFormat(rsSolicitud.EStotalest,'none')#&nbsp;</td>
			<td nowrap width="19%" style="border-bottom:2px solid black;"><strong>&nbsp;Moneda: </strong>&nbsp;#rsSolicitud.Mnombre#&nbsp;</td>
			<td nowrap width="19%" style="border-bottom:2px solid black;"><strong>&nbsp;Tipo Cambio: </strong>&nbsp;#rsSolicitud.EStipocambio#&nbsp;</td>
			<td style="border-right:2px solid black; border-bottom:2px solid black;">&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="5">&nbsp;</td>
		  </tr>
		
		  <tr align="center">
			<td colspan="5" class="titulolistas"><strong><font size="2">&nbsp;Ordenes de Compra Asociadas&nbsp;</font></strong></td>
		  </tr>		
	</table><!--- Cierre de la table encabezado Solicitud--->

<!---------- Pintado del Detalle ------------>
<!--- Pintado de ordenes de compra --->
	<cfset corte = ''>
	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="2">
	  <cfif rsOrdenes.recordcount EQ 0>
		<tr><td colspan="8" align="center" style="text-align:center; border-top:1px solid black; border-bottom:1px solid black;"> ------------------- No hay registros -------------------</td></tr>
	  <cfelse>		  
		  <cfloop query="rsOrdenes">
			<cfif corte neq rsOrdenes.EOnumero >
			  <tr><td colspan="8">&nbsp;</td></tr>
			  <!---Encabezado de la orden de compra --->
			  <tr class="titulolistas">
			  	<td colspan="8">
					<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
				    	<tr>       
							<td width="20%" class = "titulolistas"><a href="javascript: doConlis(#rsOrdenes.EOidorden#);"><strong>&nbsp;&nbsp;&nbsp;N° Orden:&nbsp;#rsOrdenes.EOnumero#</strong></a></td>
							<td width="20%" nowrap><strong>&nbsp;Fecha:</strong> &nbsp;#LSDateFormat(rsOrdenes.EOfecha,'dd/mm/yyy')#</td>
							<cfif rsOrdenes.EOestado EQ 0>
								<td nowrap width="40%"><strong>&nbsp;Estado:</strong> Pendiente &nbsp;</td>
							<cfelseif rsOrdenes.EOestado EQ 5>
								<td nowrap width="40%"><strong>&nbsp;Estado:</strong> Pendiente Vía Proceso &nbsp;</td>
							<cfelseif rsOrdenes.EOestado EQ 7>
								<td nowrap width="40%"><strong>&nbsp;Estado:</strong> Pendiente OC Directa &nbsp;</td>
							<cfelseif rsOrdenes.EOestado EQ 8>
								<td nowrap width="40%"><strong>&nbsp;Estado:</strong> Pendiente Vía Contrato &nbsp;</td>
							<cfelseif rsOrdenes.EOestado EQ -10>
								<td nowrap width="40%"><strong>&nbsp;Estado:</strong> Pendiente de Aprobación &nbsp;</td>
							<cfelseif rsOrdenes.EOestado EQ 10>
								<td nowrap width="40%"><strong>&nbsp;Estado:</strong> Aplicada &nbsp;</td>
							<cfelseif rsOrdenes.EOestado EQ 60>
								<td nowrap width="40%"><strong>&nbsp;Estado:</strong> Cancelada &nbsp;</td>
							</cfif>		
							<td>&nbsp;</td>
						</tr>
						  <tr class="titulolistas">				
							<td nowrap><strong>&nbsp;&nbsp;&nbsp;Comprador:</strong>&nbsp;#trim(rsOrdenes.CMCcodigo)# - #trim(rsOrdenes.CMCnombre)#</td>			  	 
							<td width="40%" nowrap><strong>&nbsp;Observaciones:</strong> &nbsp;#rsOrdenes.Observaciones#</td>
							<td width="40%" nowrap><strong>&nbsp;Ctro Funcional:</strong> &nbsp;#trim(rsOrdenes.CFcodigo)# - #trim(rsOrdenes.CFdescripcion)#</td>
							<td nowrap>&nbsp;</td>
						</tr>			
					 </table>
				</td>
			  </tr>				
			  </cfif> <!---Fin del corte por orden de compra ---> 
			  <!--- Detalle de la orden de compra --->
			<cfif corte neq rsOrdenes.EOnumero >						  
				<tr>
				  <td style="border-top:1px solid black; border-bottom:1px solid black;" nowrap  width="9%" ><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Línea</strong></td>
				  <td style="border-top:1px solid black; border-bottom:1px solid black;" nowrap  width="30%" ><strong>&nbsp;Item</strong></td>
				  <td style="border-top:1px solid black; border-bottom:1px solid black;" nowrap  width="24%" ><strong>&nbsp;Almacén</strong></td>				  
				  <td style="border-top:1px solid black; border-bottom:1px solid black;" nowrap  width="8%"  align="right"><strong>&nbsp;Cant.Solic.</strong></td>
				  <td style="border-top:1px solid black; border-bottom:1px solid black;" nowrap  width="7%"  align="right"><strong>&nbsp;Unidad</strong></td>
				  <td style="border-top:1px solid black; border-bottom:1px solid black;" nowrap  width="8%" ><strong>&nbsp;Cant.Surtida</strong></td>
				  <td style="border-top:1px solid black; border-bottom:1px solid black;" nowrap  width="7%"  align="right"><strong>&nbsp;Unidad</strong></td>
				  <td style="border-top:1px solid black; border-bottom:1px solid black;" nowrap  width="7%" ><strong>&nbsp;Fecha Entrega</strong></td>
				</tr>	
			</cfif><!---Fin del corte por orden de compra del detalle--->						
			<tr onClick="javascript: goTracking('#rsOrdenes.DOlinea#');" style="cursor: pointer; " title="Ver Seguimiento de Embarque">
				<td width="9%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#rsOrdenes.DOconsecutivo#&nbsp;</td>
				<td width="30%" nowrap>&nbsp;#rsOrdenes.Item#&nbsp;</td>
				<td width="24%" nowrap>&nbsp;#trim(rsOrdenes.Almcodigo)# - #trim(rsOrdenes.Bdescripcion)#&nbsp;</td>
				<td align="right" width="8%">&nbsp;#rsOrdenes.DOcantidad#&nbsp;</td>
				<td align="right" width="7%">&nbsp;#rsOrdenes.Ucodigo#&nbsp;</td>
				<td align="right" width="8%">&nbsp;#rsOrdenes.DOcantsurtida#&nbsp;</td>
				<td align="right" width="7%">&nbsp;#rsOrdenes.Ucodigo#&nbsp;</td>
				<td width="7%" align="right">&nbsp;#LSDateFormat(rsOrdenes.DOfechaes,'dd/mm/yyy')#&nbsp;</td>
			</tr>				
			<cfset corte=rsOrdenes.EOnumero>
		  </cfloop> <!--- Fin del loop rsOrdenes (las ordenes de compra) --->
		</cfif>	<!--- Fin del if si hay datos en rsOrdenes (hay ordenes de compra) --->
	</table><!--- Cierre de la tabla de las ordenes de compra --->	
	
	<!--------- Pintado de las Cotizaciones ------------->
	<cfset corte = ''>  
	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="2">
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr align="center">
			<td colspan="4" class="titulolistas"><strong><font size="2">&nbsp;Cotizaciones Asociadas&nbsp;</font></strong></td>
		</tr>
	
	  <cfif rsCotizaciones.recordcount EQ 0>
		<tr><td colspan="4" align="center" style="text-align:center;border-bottom:1px solid black; border-top:1px solid black;"> ------------------- No hay registros -------------------</td></tr>
	  <cfelse>		  		
		<cfloop query="rsCotizaciones">
			<cfif corte neq rsCotizaciones.ECnumero>
				<tr><td colspan="5">&nbsp;</td></tr>						
				<!--- Encabezado de la cotizacion --->			  
				<tr class="titulolistas">        
					<td>
						<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="20%" class = "titulolistas"><strong>&nbsp;&nbsp;&nbsp;N° Cotización:&nbsp;</strong> #rsCotizaciones.ECnumero#</td>				
								<td width="40%" ><strong>&nbsp;Proveedor:&nbsp;</strong>#rsCotizaciones.SNnombre#</td>
								<td width="33%" ><strong>&nbsp;Moneda:&nbsp;</strong>#rsCotizaciones.Mnombre#</td>
								<td width="3%" class = "titulolistas" >&nbsp;</td>
								<td width="4%" class = "titulolistas" >&nbsp;</td>											
							</tr>
						</table>
					</td>		
				</tr>
			</cfif> <!---Fin del corte por cotizacion --->
			<!--- Detalle de la cotizacion --->		 			 
			<tr>
				<td>
				<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
					<cfif corte neq rsCotizaciones.ECnumero>								
						<tr>		
						  <td style="border-top:1px solid black; border-bottom:1px solid black;" nowrap  width="10%" ><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Línea</strong></td>
						  <td style="border-top:1px solid black; border-bottom:1px solid black;" nowrap  width="40%" ><strong>Item</strong></td>
						  <td style="border-top:1px solid black; border-bottom:1px solid black;" nowrap  width="5%"  align="right"><strong>Cantidad</strong></td>
						  <td style="border-top:1px solid black; border-bottom:1px solid black;" nowrap  width="5%"  align="right"><strong>Unidad</strong></td>							  
						  <td style="border-top:1px solid black; border-bottom:1px solid black;" nowrap  width="20%" align="right"><strong>Precio Unit.</strong></td>
						</tr>
					</cfif><!---Fin del corte por cotizacion --->															
					<tr>
						<td width="10%" nowrap>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#rsCotizaciones.DSconsecutivo#&nbsp;</td>
						<td width="40%" nowrap>&nbsp;#rsCotizaciones.Item#</td>
						<td  align="right" width="5%" nowrap>&nbsp;#rsCotizaciones.DCcantidad#&nbsp;</td>
						<td  align="right" width="5%" nowrap>&nbsp;#rsCotizaciones.Ucodigo#&nbsp;</td>
						<td  align="right" width="20%" nowrap>&nbsp;#LvarOBJ_PrecioU.enCF_RPT(rsCotizaciones.DCpreciou)#&nbsp;</td>
					</tr>
				</table>
				</td>
			 </tr>				
		  </td>		  	
	    </tr>
	   <cfset corte=rsCotizaciones.ECnumero>
	  </cfloop> <!--- Fin del loop rsCotizaciones (las cotizaciones) --->					
	</cfif>	<!--- Fin del if si hay datos en rsCotizaciones (hay cotizaciones) --->
</table>

</cfoutput> 

<script language='javascript' type='text/JavaScript' >
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis(valor) {
		var params ="";
		popUpWindow("/cfmx/sif/cm/consultas/OrdenesCompra-vista.cfm?EOidorden="+valor,10,10,1000,550);
	}
	
	function goTracking(linea) {
		location.href = "/cfmx/sif/cm/consultas/trackingLineaOrden.cfm?DOlinea="+linea;
	}
</script>	
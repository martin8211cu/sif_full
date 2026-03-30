<!---►►Estilos CSS◄◄--->
<style type="text/css">
	.letra { font-size:11px; }
	.LetraDetalle{ font-size:11px; }
</style>
<CF_NAVEGACION name="CMPid">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<!---►►Proceso de compra◄◄--->
<cfquery name="rsProcesoCompra" datasource="#Session.DSN#">
		select 
			a.CMPid,   							 <!---ID del Proceso --->
			a.CMPdescripcion, 					 <!---Descripcion del proceso--->
			Coalesce(a.GCcritid,-1) as GCcritid, <!---grupo de Criterios--->
			a.CMPfechapublica, 					 <!---Fecha de Publicacion--->
			a.CMPfmaxofertas, 					 <!---Fecha Maxima para Ofertas--->
			a.CMPestado, 						 <!---Estado del Proceso--->
			a.CMPnumero,						 <!---Numero de Documento--->
			Coalesce(a.CMFPid,-1) as CMFPid,	 <!---Forma de Pago--->
			Coalesce(a.CMIid, -1) as CMIid,		 <!---Incoterm--->
			Coalesce(a.CMTPid, -1) as CMTPid,    <!---Tipo de proceso--->
            case a.CMPestado 
            	when 0 then 'No Publicado' 
                when 10 then 'Publicado' 
                when 50 then 'Orden de Compra' 
                when 79 then 'Pediente de Aprobación Solicitante' 
                when 81 then 'Aprobado por Solicitante' 
                when 83 then 'Rechazado por Solicitante' 
                when 85 then 'Cancelado' 
                else 'Sin Categorizar' end as Estado
		from CMProcesoCompra a
		where a.CMPid = #form.CMPid#
		and a.Ecodigo = #Session.Ecodigo#
</cfquery>
<!---=============Tipo de Proceso de compra============================--->
<cfquery name="TipoProceso" datasource="#Session.DSN#">
	select CMTPid, CMTPCodigo, CMTPDescripcion 
	 from CMTipoProceso
	where Ecodigo = #Session.Ecodigo#
	  and CMTPid  = #rsProcesoCompra.CMTPid#
	  and #rsProcesoCompra.CMTPid# <> -1
</cfquery>
<cfif isdefined('TipoProceso') and TipoProceso.recordcount GT 0>
	<cfset TipoProceso = " #TipoProceso.CMTPCodigo#-#TipoProceso.CMTPDescripcion#">
<cfelse>
	<cfset TipoProceso =" Ninguno">
</cfif>
<!---==============Grupo de Criterios===============================--->
<cfquery name="rsGruposCriteriosTodo" datasource="#Session.DSN#">
	select a.GCcritid, a.GCcritdesc, b.CCid, b.CGpeso
	 from GruposCriteriosCM a
		inner join CriteriosGrupoCM b
			on a.GCcritid = b.GCcritid
	where a.Ecodigo  = #Session.Ecodigo#
	  and a.GCcritid = #rsProcesoCompra.GCcritid#
	  and #rsProcesoCompra.GCcritid# <> -1
</cfquery>
<cfif isdefined('rsGruposCriteriosTodo') and rsGruposCriteriosTodo.recordcount GT 0>
	<cfset GrupoCriterio = " #rsGruposCriteriosTodo.GCcritdesc#">
<cfelse>
	<cfset GrupoCriterio =" Ninguno">
</cfif>
<!---=================Forma de Pago===============================--->
<cfquery name="rsCMFormasPago" datasource="#session.dsn#">
	select CMFPid, CMFPcodigo, CMFPdescripcion, CMFPplazo
	from CMFormasPago
	where Ecodigo = #session.Ecodigo#
	and CMFPid = #rsProcesoCompra.CMFPid#
</cfquery>
<cfif isdefined('rsCMFormasPago') and rsCMFormasPago.recordcount GT 0>
	<cfset TipoPago = " #rsCMFormasPago.CMFPcodigo#-#rsCMFormasPago.CMFPdescripcion#">
<cfelse>
	<cfset TipoPago =" Ninguno">
</cfif>
<!---=============================Incoterm======================--->
<cfquery name="rsCMIncoterm" datasource="#session.dsn#">
	select CMIid, CMIcodigo, CMIdescripcion, CMIpeso
	from CMIncoterm
	where Ecodigo = #session.Ecodigo#
	and CMIid = #rsProcesoCompra.CMIid#
</cfquery>
<cfif isdefined('rsCMIncoterm') and rsCMIncoterm.recordcount GT 0>
	<cfset Incoterm = " #rsCMIncoterm.CMIcodigo#-#rsCMIncoterm.CMIdescripcion#">
<cfelse>
	<cfset Incoterm =" Ninguno">
</cfif>
<!---========================Criterios==================--->
<cfquery name="rsCriterios" datasource="#Session.DSN#">
	select CCid, CCdesc
	from CCriteriosCM
	order by CCid
</cfquery>
<!---======================Valor de los Criterios=========--->
<cfquery name="rsCondicionesProceso" datasource="#Session.DSN#">
	select CCid, CPpeso
	from CMCondicionesProceso
	where CMPid = #rsProcesoCompra.CMPid#
</cfquery>
<cfset condicionId = ValueList(rsCondicionesProceso.CCid, ',')>
<cfset condicionPeso = ValueList(rsCondicionesProceso.CPpeso, ',')>
<!---====================Socios Invitados==================--->
<cfquery name="rsProveedores" datasource="#Session.DSN#">
		select a.CMPlinea, b.SNcodigo, b.SNnumero, b.SNnombre
		from CMProveedoresProceso a
			inner join SNegocios b
				on a.Ecodigo = b.Ecodigo
			   and a.SNcodigo = b.SNcodigo	
		where a.CMPid = #rsProcesoCompra.CMPid#
		and a.Ecodigo  = #Session.Ecodigo#
		and b.SNtiposocio <> 'C'
		order by b.SNnumero
	</cfquery>
<!---==============lineas de Detalle======================--->
<cfquery name="rsItemsProceso" datasource="#Session.DSN#">
			select DSlinea
			from CMLineasProceso
			where CMPid = #rsProcesoCompra.CMPid#
			order by ESidsolicitud, DSlinea
</cfquery>	
<cfif isdefined('rsItemsProceso') and rsItemsProceso.recordcount GT 0>	
	<cfset LineasDetalle = ValueList(rsItemsProceso.DSlinea, ',')>
</cfif>
<cfif isdefined('LineasDetalle')>	
	<cfset iCount = 1>
	<cfquery name="rsDetalleProcesoCompra" datasource="#Session.DSN#">
		select a.ESidsolicitud, b.CMTSdescripcion, a.ESnumero, a.ESobservacion, a.ESfecha, c.CFcodigo, c.CFdescripcion, d.CMSnombre, 
			   e.DSlinea, e.DSdescripcion, e.DScant, f.Udescripcion, e.DSdescalterna, e.DSobservacion,
			   g.CFcodigo as CFcodigoDet, g.CFdescripcion as CFdescripcionDet,
			   case e.DStipo when 'A' then (select min(Acodigo) from Articulos x where x.Ecodigo = e.Ecodigo and x.Aid = e.Aid) 
							 when 'S' then (select min(Ccodigo) from Conceptos x where x.Ecodigo = e.Ecodigo and x.Cid = e.Cid) 
							 else ''
			   end as CodigoItem,
			   e.DScant - e.DScantsurt as CantDisponible
		from ESolicitudCompraCM a
			 inner join CMTiposSolicitud b
				on a.Ecodigo = b.Ecodigo
				and a.CMTScodigo = b.CMTScodigo
			 inner join CFuncional c
				on a.Ecodigo = c.Ecodigo
				and a.CFid = c.CFid
			 inner join CMSolicitantes d
				on a.Ecodigo = d.Ecodigo
				and a.CMSid = d.CMSid
			 inner join DSolicitudCompraCM e
				on a.Ecodigo = e.Ecodigo
				and a.ESidsolicitud = e.ESidsolicitud
				and e.DSlinea in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#LineasDetalle#" list="yes" separator=",">)
			 inner join Unidades f
				on e.Ecodigo = f.Ecodigo
				and e.Ucodigo = f.Ucodigo
			left outer join CFuncional g
				on e.CFid = g.CFid
		where a.Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfquery name="rsSolicitudes" dbtype="query">
		select distinct ESidsolicitud, CMTSdescripcion, ESnumero, ESobservacion, ESfecha, CFcodigo, CFdescripcion, CMSnombre
		from rsDetalleProcesoCompra
		order by ESnumero
	</cfquery>
</cfif>
<!---►►Cotizaciones de la orden de compra◄◄--->
	<cfquery name="rsCotizaciones" datasource="#session.DSN#">					
		select 	distinct b.CMPid, d.ECid,d.ECtotal,d.ECnumero,e.SNidentificacion#_Cat#' - '#_Cat#e.SNnombre as rsSocio, f.CMFPplazo,<!---g.EOnumero,--->z.NotaGlobal
        	
                
	      from ECotizacionesCM d
          
          	LEFT OUTER JOIN DCotizacionesCM b
				on b.CMPid = d.CMPid
                
			LEFT OUTER JOIN CMProcesoCompra c
				on c.CMPid	   = b.CMPid
               
            LEFT OUTER JOIN CMResultadoEval z
				on z.ECid	 = d.ECid
			   and z.CMPid   = d.CMPid 
			   and z.Ecodigo = d.Ecodigo 
                  
          	LEFT OUTER JOIN SNegocios e
				on e.SNcodigo = d.SNcodigo
			   and e.Ecodigo  = d.Ecodigo
             
            LEFT OUTER JOIN CMFormasPago f
				on f.CMFPid  = d.CMFPid
			   and f.Ecodigo = d.Ecodigo
                  
		where d.CMPid    = #rsProcesoCompra.CMPid#
          and d.ECtotal != 0	
	</cfquery>
<cfoutput>
		<!---Titulo--->
		<table width="100%" border="0" cellspacing="0" cellpadding="1" style="padding-left: 5px; padding-right: 10px" align="center">
			<tr> 
			<td colspan="6" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#session.Enombre#</strong></td>
			</tr>
			<tr> 
			<td colspan="6" class="letra" align="center"><b>Reporte de Publicaciónes de Compra</b></td>
			</tr>
			<tr>
			<td colspan="6" align="center" class="letra"><p><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</p>
			  <p>&nbsp;</p></td>
			</tr>
		</table>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr><td nowrap valign="top">
				<table width="100%"  border="0" cellspacing="0" cellpadding="2">
				  <!---Numero--->
				  <tr>
				     <td class="fileLabel" align="right">N&uacute;mero:</td>  
					 <td colspan="2">#rsProcesoCompra.CMPnumero#</td>
				  </tr>
				  <!---Tipo Proceso--->
				  <tr>
					  <td class="fileLabel" align="right">Tipo Proceso:</td>
					  <td colspan="2">#TipoProceso#</td>
				  </tr>
				  <!---Descripcion--->
				  <tr>
					<td class="fileLabel" align="right">Descripci&oacute;n:</td>
					<td colspan="2">#rsProcesoCompra.CMPdescripcion#</td>
				  </tr>
				  <!---Fecha publicacion--->
				  <tr>
				    <td class="fileLabel" align="right">Fecha de Publicaci&oacute;n:</td>
				    <td colspan="2"> #LSDateFormat(rsProcesoCompra.CMPfechapublica, 'dd/mm/yyyy')#</td>
			      </tr>
				  <!---Fecha Maxima de Publicaciones--->
				  <tr>
				    <td class="fileLabel" align="right">Fecha M&aacute;xima para Cotizaci&oacute;n:</td>
				    <td>#LSDateFormat(rsProcesoCompra.CMPfmaxofertas, 'dd/mm/yyyy')# &nbsp; - &nbsp; #LSTimeFormat(rsProcesoCompra.CMPfmaxofertas,"hh:mm tt")#</td>
				  </tr>
				  <!---Tipo Pago--->
				  <tr>
				  	<td class="fileLabel" align="right">Forma de pago:</td>
					<td colspan="2">#TipoPago#</td>
				  </tr>
				  <!---Incoterm--->
				  <tr>
				  	<td class="fileLabel" align="right">Incoterm:</td>
					<td colspan="2">#Incoterm#</td>
				  </tr>
                  <tr>
				  	<td class="fileLabel" align="right">Estado:</td>
					<td colspan="2">#rsProcesoCompra.Estado#</td>
				  </tr>
				</table>
			</td>
			<td valign="top">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <!---Grupos de Criterios--->
				  <tr>
					<td class="fileLabel" align="right" nowrap>Grupo de Criterios:</td>
				    <td nowrap>#GrupoCriterio#</td>
				  </tr>
				  <tr>
					<td colspan="2" nowrap>
						<fieldset>
							<legend><strong>Peso seleccionado para cada criterio</strong></legend>
							<table width="100%"  border="0" cellspacing="0" cellpadding="2">
							  <cfloop query="rsCriterios">
							  <tr>
								<td nowrap>#rsCriterios.CCdesc#</td>
								<td nowrap>
								<cfset pos = ListFind(condicionId, rsCriterios.CCid, ',')>
								<cfif pos NEQ 0>
										<cfset valorcriterio = LSNumberFormat(ListGetAt(condicionPeso, pos, ','), ',9.00')>
								<cfelse>
										<cfset valorcriterio = "0.00">
								</cfif>
									    #valorcriterio#
								</td>
							  </tr>
							  </cfloop>
							</table>
						</fieldset>
					</td>
				  </tr>
				</table>			
			</td>
		  </tr>
		  <tr>
			<td nowrap>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
	  </table>	
	  <!---Lista de Proveedores Invitados a Participar--->
	  <cfset Pcount=1>
	  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  	 <tr><td colspan="6">&nbsp;</td></tr>
		 <tr><td  colspan="6" class="tituloListas">Lista de Proveedores Invitados a Participar</td></tr>
			<cfif rsProveedores.recordCount EQ 0>
		<tr><td colspan="2" align="center"><strong>TODOS LOS PROVEEDORES ESTAN INVITADOS A PARTICIPAR</strong></td></tr>
		   <cfelse>
		  <tr>
			<td style="padding-right: 5px;" class="tituloListas" width="20%" nowrap>N&uacute;mero</td>
			<td style="padding-right: 5px;" nowrap class="tituloListas">Nombre</td>
		  </tr>
			<cfloop query="rsProveedores">
			  <tr class=<cfif (Pcount MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
				<td style="padding-right: 5px;" nowrap>#rsProveedores.SNnumero#</td>
				<td style="padding-right: 5px;" nowrap>#rsProveedores.SNnombre#</td>
			  </tr>
			  <cfset Pcount = Pcount + 1>
			</cfloop>
		</cfif>
		 <tr><td colspan="6">&nbsp;</td></tr>
	  </table></cfoutput>
	  <!---Lista de Cotizaciones--->
	   <table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  	 <tr><td  colspan="6" class="tituloListas">Lista de Cotizaciones</td></tr>
		<tr>
			<td width="1%" class="listaCorte">&nbsp;</td>
			<td class="listaCorte" width="13%"><strong>Elecci&oacute;n del Sistema</strong></td>
			<td class="listaCorte" width="10%"><strong>No. Cotizaci&oacute;n</strong></td>
			<td class="listaCorte" width="30%"><strong>Proveedor</strong></td>
			<td class="listaCorte" width="10%"><strong>Total Cotizaci&oacute;n</strong></td>
			<td class="listaCorte" width="10%" align="center"><strong>Plazo Cr&eacute;dito</strong></td>
			<td class="listaCorte" width="7%"><strong>Nota Global</strong></td>
			<!---<td class="listaCorte" width="7%"><strong>Numero OC</strong></td>--->
			<td class="listaCorte" width="15%"><strong>Elecci&oacute;n manual</strong></td>
			<td width="1%" class="listaCorte">&nbsp;</td>
		</tr>
		<cfif rsCotizaciones.RecordCount NEQ 0>		
		<cfoutput query="rsCotizaciones">
			<cfset vnECid = rsCotizaciones.ECid>    <!---Variable con el Id de la cotizacin---->
			<cfset vnCMPid = rsCotizaciones.CMPid>  <!---Variable con el Id del proceso en que esta la cotizacin---->
			<cfset vnSugerido =''>	                <!---Variable con ECid sugerido por el sistema--->
			<cfset vnSeleccionado=''>               <!---Variable con el ECid que fue seleccionado por el usuario---->
			
			<cfquery name="rsSugerido" datasource="#Session.DSN#"><!----Cotizacin sugerida por el sistema--->							
				select CMRseleccionado, CMRsugerido, ECid
				from CMResultadoEval 
				where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnCMPid#">
					and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnECid#">
					and Ecodigo = #Session.Ecodigo#
					and CMRsugerido = 1							
			</cfquery>	
			<cfset vnSugerido = rsSugerido.ECid>
			<cfquery name="rsSeleccionado" datasource="#session.DSN#"><!----Cotización donde una lnea fue seleccionada por el usuario---->
				select CMRseleccionado, CMRsugerido, ECid
				from CMResultadoEval 	
				where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnCMPid#">		
					and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnECid#">
					and Ecodigo = #Session.Ecodigo#
					and CMRseleccionado = 1
					and CMRsugerido = 0								
			</cfquery>
			<cfset vnSeleccionado = rsSeleccionado.ECid>
			<tr  onClick="javascript: funcDetalleCotizacion(#rsCotizaciones.ECid#,#rsCotizaciones.CMPid#)" class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif currentRow>listaNon<cfelse>listaPar</cfif>';" style="cursor: hand;">		
				<td width="1%">&nbsp;</td>
				<td align="center" width="13%">
					<cfif isdefined("vnSugerido") and trim(vnECid) EQ trim(vnSugerido)>
						<img src="../../imagenes/checked.gif">
					<cfelse>
						<img src="../../imagenes/unchecked.gif">
					</cfif>
				</td>
				<td>#rsCotizaciones.ECnumero#</td>
				<td>#rsCotizaciones.rsSocio#</td>
				<td align="right">#LSCurrencyFormat(rsCotizaciones.ECtotal,'none')#</td>
				<td align="center">#rsCotizaciones.CMFPplazo#</td>
				<td width="7%">#LSNumberFormat(rsCotizaciones.NotaGlobal,',9.00')#</td>
				<td>
					<cfif isdefined("vnSeleccionado") and trim(vnECid) EQ trim(vnSeleccionado)>
						Existe justificaci&oacute;n asociada</td>
					</cfif>
				<td width="1%">&nbsp;</td>
			</tr>
			</cfoutput>
			<cfelse>
					<tr><td colspan="9">&nbsp;</td></tr>
					<tr><td colspan="9" align="center" class="LetraDetalle">------------------ No hay Cotizaciones ------------------</td></tr>
			</cfif>			
			 <tr><td colspan="6">&nbsp;</td></tr>
		</table>
		<cfoutput>
	    <!---Lista de Itemes de Compra--->
	  <table width="100%"  border="0" cellspacing="0" cellpadding="2" align="center">

		  <tr>
		    <td class="tituloListas" colspan="5">Lista de Itemes de Compra</td>
	      </tr>
		  <tr>
			<td nowrap class="tituloListas" style="padding-right: 5px;">Tipo de Solicitud</td>
			<td align="right" nowrap class="tituloListas" style="padding-right: 5px;">No. Solicitud</td>
			<td align="center" nowrap class="tituloListas" style="padding-right: 5px;">Fecha</td>
			<td nowrap class="tituloListas" style="padding-right: 5px;">Centro Funcional</td>
			<td nowrap class="tituloListas">Solicitante</td>
		  </tr>
		  <cfif isdefined("rsSolicitudes") and rsSolicitudes.recordcount GT 0>
		  <cfloop query="rsSolicitudes">
			  <cfset solicitud = rsSolicitudes.ESidsolicitud>
			  <tr class=<cfif (iCount MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
				<td nowrap style="border-top: 1px solid black; padding-right: 5px;">#rsSolicitudes.CMTSdescripcion#</td>
				<td align="right" nowrap  style="border-top: 1px solid black; padding-right: 5px;">#rsSolicitudes.ESnumero#</td>
				<td align="center" nowrap style="border-top: 1px solid black; padding-right: 5px;">#LSDateFormat(rsSolicitudes.ESfecha, 'dd/mm/yyyy')#</td>
				<td nowrap style="border-top: 1px solid black; padding-right: 5px;">#rsSolicitudes.CFcodigo# - #rsSolicitudes.CFdescripcion#</td>
				<td style="border-top: 1px solid black;">#rsSolicitudes.CMSnombre#</td>
			  </tr>
			  <tr class=<cfif (iCount MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
			    <td colspan="5">#rsSolicitudes.ESobservacion#</td>
		      </tr>
			  <cfset iCount = iCount + 1>
			  <cfquery name="rsSolicitudesDetalle" dbtype="query">
				select distinct DSlinea, CodigoItem, DSdescripcion, DScant,CantDisponible, Udescripcion, DSobservacion, DSdescalterna, ESidsolicitud, CFcodigoDet, CFdescripcionDet
				from rsDetalleProcesoCompra
				where ESidsolicitud = #rsSolicitudes.ESidsolicitud#
				order by DSlinea
			  </cfquery>
			  <tr>
				<td colspan="5" nowrap>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td style="padding-right: 5px;" class="tituloListas" width="1%" nowrap>&nbsp;</td>
						<td style="padding-right: 5px;" class="tituloListas" width="47%" nowrap>Item</td>
						<td style="padding-right: 5px;" width="5%" align="right" nowrap class="tituloListas">Cantidad</td>
						<td style="padding-right: 5px;" class="tituloListas" width="20%" >Unidad</td>
						<td style="padding-right: 5px;" class="tituloListas" width="50%" nowrap>Ctro.Funcional</td>
					  </tr>
					<cfloop query="rsSolicitudesDetalle">
					  <tr class=<cfif (iCount MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
						<td style="padding-right: 5px;" nowrap>-</td>
						<td style="padding-right: 5px;" nowrap>#rsSolicitudesDetalle.CodigoItem# - #rsSolicitudesDetalle.DSdescripcion#</td>
						<td style="padding-right: 5px;" align="right" nowrap>#rsSolicitudesDetalle.CantDisponible#</td>
						<td style="padding-right: 5px;">#rsSolicitudesDetalle.Udescripcion#</td>
						<td style="padding-right: 5px;">
							<cfif Len(Trim(rsSolicitudesDetalle.CFcodigoDet))>
								#rsSolicitudesDetalle.CFcodigoDet# - #rsSolicitudesDetalle.CFdescripcionDet#
							<cfelse>
								---
							</cfif>
						</td>
					  </tr>
					  <cfset iCount = iCount + 1>
					</cfloop>							
				  </table>
				</td>
			  </tr>
		  </cfloop>
		  <tr>
		  	<td colspan="5">&nbsp;</td>
		  </tr>
		<cfelse>
	<tr><td colspan="9" align="center" class="LetraDetalle">------------------ No hay lineas de Detalle ------------------</td></tr>
	</cfif>
	<tr><td colspan="9" align="center">&nbsp;</td></tr>
		<tr><td colspan="9" align="center" class="LetraDetalle">------------------ Fin del Reporte ------------------</td></tr>
	</table>	
</cfoutput>
<script language="javascript1.2" type="text/javascript">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function funcDetalleCotizacion(paramIDcotizacion,paramProceso){
		var parametros = '?CMPid='+paramProceso+'&ECid='+paramIDcotizacion;
		<cfoutput>
			popUpWindow("/cfmx/sif/cm/operacion/autorizaOrden-detallecotizacion.cfm"+parametros,10,10,950,600);
		</cfoutput>
	}
</script>
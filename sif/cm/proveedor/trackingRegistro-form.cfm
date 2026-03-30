<cfif isdefined("Form.ETidtracking")>
	<cfset modo = "CAMBIO">
<cfelse>
	<cflocation url="trackingRegistro-lista.cfm">
</cfif>

<cfquery name="rsCourier" datasource="sifcontrol">
	select CRid, CRcodigo, CRdescripcion
	 from Courier
	where CEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  and Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.EcodigoSDC#">
	union
	select CRid, CRcodigo, CRdescripcion
	 from Courier
	where CEcodigo   is null
	  and Ecodigo    is null
	  and EcodigoSDC is null
	order by 2
</cfquery>

<cfquery name="rsEstadoInicial" datasource="sifpublica">
	select ETcodigo, ETdescripcion, ETorden
	 from EstadosTracking
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by ETorden
</cfquery>

<cfif modo EQ "CAMBIO">
	<cfquery name="data" datasource="sifpublica">
		select a.ETidtracking, a.ETconsecutivo, a.ETnumtracking, a.CEcodigo, a.EcodigoASP, a.Ecodigo, a.ETcodigo, a.cncache, a.EOidorden, 
			   a.ETnumreferencia, a.CRid, a.ETfechagenerado, a.ETfechaestimada, a.ETfechaentrega, a.ETfechasalida, 
			   a.ETnumembarque, a.ETrecibidopor, a.ETmediotransporte, 
			   a.BMUsucodigo, a.ETestado, a.ETcampousuario, a.ETcampopwd, b.ETdescripcion, *
		from ETracking a
        	inner join EstadosTracking b
            	on a.Ecodigo  = b.Ecodigo
			   and a.ETcodigo = b.ETcodigo
		  where a.Ecodigo      = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETidtracking#">
	</cfquery>
	
    <cfquery name="rsOrdenes" datasource="#session.dsn#">
        select distinct d.EOnumero
        from ETrackingItems a  
            inner join DOrdenCM d
                on d.DOlinea = a.DOlinea
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 	 
            and a.ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETidtracking#"> 	  	 
            and a.ETIestado = 0 	 
        group by d.EOnumero
     </cfquery>
	<cfset cont = 0>
    <cfset LvarOrdenes = "">
    <cfloop query="rsOrdenes">
		 <cfif LvarOrdenes neq "" and rsOrdenes.recordcount gt 0>
         	<cfif cont LT 4>
            	<cfset LvarOrdenes = LvarOrdenes&"|"&rsOrdenes.EOnumero>
            	<cfset cont = cont+1>
            <cfelse>
            	    <cfset LvarOrdenes = LvarOrdenes&"<br>"&rsOrdenes.EOnumero>
            		<cfset cont = 0>
            </cfif>
        <cfelse>
            <cfset LvarOrdenes = LvarOrdenes&rsOrdenes.EOnumero>    
            <cfset cont = cont+1>
        </cfif> 
    </cfloop>
    
    <cfif rsOrdenes.recordcount gt 1>
    	<cfset LvarObservacion = "M&uacute;ltiples Ordenes de Compra">
    <cfelse>
        <cfquery name="dataOrden" datasource="#data.cncache#">
            select Observaciones
             from EOrdenCM
            where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.EOidorden#">
        </cfquery>
        <cfset LvarObservacion = dataOrden.Observaciones>
    </cfif>
	
	<cfquery name="items" datasource="sifpublica">
		select ETidtracking, DOlinea, Ecodigo, CEcodigo, EcodigoASP, cncache, ETIcantidad, ETIdescripcion, Usucodigo, ETcantrecibida, ETcantfactura,ETIiditem,
			(ETcostodirecto + ETcostoindfletes + ETcostoindseg + ETcostoindsegpropio + ETcostoindgastos + ETcostoindimp + ETcostoindfletesPoliza + ETcostoindsegPoliza) as MontoTransito
		from ETrackingItems
		 where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		   and ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETidtracking#">
		   and ETIestado 	= 0
		order by DOlinea
	</cfquery>
	
	<cfquery name="sumTransito" datasource="sifpublica">
		select sum(ETcostodirecto + ETcostoindfletes + ETcostoindseg + ETcostoindsegpropio + ETcostoindgastos + ETcostoindimp + ETcostoindfletesPoliza + ETcostoindsegPoliza) as TotalTransito
		from ETrackingItems
		where Ecodigo 	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETidtracking#">
		  and ETIestado = 0
	</cfquery>
	
	<cfquery name="itemsTotales" datasource="sifpublica">
		select sum(ETcantfactura) as ETcantfactura, sum(ETIcantidad + ETcantrecibida) as ETIcantidad
		from ETrackingItems
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking#">
			and ETIestado = 0
	</cfquery>
	
	<cfquery name="monedaLocal" datasource="#session.dsn#">
		select m.Mnombre
		from Monedas m
		where m.Mcodigo = (select e.Mcodigo from Empresas e where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">)
	</cfquery>
</cfif>

<script src="/cfmx/sif/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="javascript" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama el conlis de Ordenes de Compra
	function doConlisOrdenCM() {
		var w = 800;
		var h = 500;
		var l = (screen.width-w)/2;
		var t = (screen.height-h)/2;
		popUpWindow("/cfmx/sif/cm/proveedor/ConlisOrdenCompra.cfm",l,t,w,h);
	}

	//Llama el conlis de Trackings
	function doConlisTrackings() {
		var trackingActual = document.form1.ETidtracking.value;
		var w = 800;
		var h = 450;
		var l = (screen.width-w)/2;
		var t = (screen.height-h)/2;
		popUpWindow("/cfmx/sif/cm/proveedor/ConlisTrackings.cfm?validaFacturado=1&validaPoliza=1&ETidtrackingActual="+trackingActual,l,t,w,h);
	}
	
	function habilitarCamposMover(t) {
		if (t == '2') {
			document.form1.ETnumtracking_move.disabled = false;
		} else {
			document.form1.ETnumtracking_move.disabled = true;
		}
	}
	
	function ContinuarMover() {
		var continuar = false;
		<cfif items.RecordCount gt 0>
			<cfloop query="items">
				<cfoutput>
				if (!continuar && new Number(qf(document.form1.ETIcantidad_#items.DOlinea#.value)) > 0) {
					continuar = true;
				}
				</cfoutput>
			</cfloop>
			if(!continuar)
				alert('Debe seleccionar al menos un item');
		<cfelse>
			alert('No existen itemes en este tracking');
		</cfif>
		// chequear que se haya escogido un tracking para mover
		if (continuar && document.form1.chk[1].checked && document.form1.ETidtracking_move.value == '') {
			continuar = false;
			alert('Debe Escoger el tracking destino a donde va a mover los itemes')
		}
		
		return continuar;
	}
	
	//-->
</script>

<cfoutput>
<form name="form1" method="post" action="trackingRegistro-sql.cfm" onSubmit="javascript: return validar();">
  <cfif modo EQ "CAMBIO">
  	<input type="hidden" name="ETidtracking" value="#Form.ETidtracking#">
  </cfif>
	<table width="100%" cellpadding="2" cellspacing="0" border="0">
    	<tr>
			<!---►►Numero de Tracking◄◄--->
            <td align="right" nowrap class="fileLabel">No. Tracking:</td>
            <td nowrap>
                <cfif modo EQ "CAMBIO">
                    #data.ETconsecutivo#
                <cfelse>
                    &nbsp;
                </cfif>
            </td>
      		<!---►►Numero de Embarque◄◄--->
            <td align="right" nowrap class="fileLabel">No. Embarque: </td>
            <td nowrap>
            	<input name="ETnumembarque" type="text" id="ETnumembarque" tabindex="1" onFocus="this.select();" value="<cfif modo neq 'ALTA'>#data.ETnumembarque#</cfif>" size="30" maxlength="25">
            </td>
            <!---►►Fecha Salida◄◄--->
            <td align="right" nowrap class="fileLabel">Fecha Salida:</td>
            <td nowrap>
				<cfset fechasalida = ''>
                <cfif modo neq 'ALTA' and len(trim(data.ETfechasalida)) >
                  <cfset fechasalida = LSDateFormat(data.ETfechasalida,'dd/mm/yyyy') >
                </cfif>
                <cf_sifcalendario name="ETfechasalida" value="#fechasalida#"> 
            </td>
   		</tr>
   		<tr>
			<!---►►No. Control◄◄--->
            <td align="right" nowrap class="fileLabel">No. Control:</td>
            <td nowrap>
				<cfif modo EQ "CAMBIO">
                    #data.ETnumtracking#
                <cfelse>
                    &lt;GENERADO&gt;
                </cfif>
            </td>
            <!---►►Courier del tracking◄◄--->
            <td align="right" nowrap class="fileLabel">Courier:</td>
            <td nowrap>
                <select name="CRid">
                  <option value="-1">--- Niguno ---</option>
                  <cfloop query="rsCourier">
                    <option value="#rsCourier.CRid#" <cfif modo neq 'ALTA' and data.CRid eq rsCourier.CRid>selected</cfif> >#trim(rsCourier.CRcodigo)# - #trim(rsCourier.CRdescripcion)#</option>
                  </cfloop>
                </select>
            </td>
            <!---►►Fecha Estimada◄◄--->
            <td align="right" nowrap class="fileLabel">Fecha Estimada:</td>
            <td nowrap>
				<cfset fechaest = '' >
                <cfif modo neq 'ALTA' and len(trim(data.ETfechaestimada)) >
                <cfset fechaest = LSDateFormat(data.ETfechaestimada,'dd/mm/yyyy') >
                </cfif>
                <cf_sifcalendario name="ETfechaestimada" value="#fechaest#"> 
           </td>
   		</tr>
   		<tr>
			<!---►►No. de Orden◄◄--->
            <td align="right" nowrap class="fileLabel">No. Orden:</td>
            <td nowrap>
				<cfif modo EQ "CAMBIO">
                    #LvarOrdenes#
                <cfelse>
                    &nbsp;
                </cfif>
            </td>
            <!---►►Tracking Courier◄◄--->
            <td align="right" nowrap class="fileLabel">Tracking Courier:</td>
            <td nowrap>
            	<input type="text" size="30" maxlength="50" name="ETnumreferencia" onFocus="this.select();" tabindex="1" value="<cfif modo neq 'ALTA'>#data.ETnumreferencia#</cfif>">
            </td>
            <!----►►Fecha de llegada◄◄--->
            <td align="right" nowrap class="fileLabel">Fecha Llegada:</td>
            <td nowrap>
				<cfset fechallegada = '' >
                <cfif modo neq 'ALTA' and len(trim(data.ETfechaentrega)) >
                  <cfset fechallegada = LSDateFormat(data.ETfechaentrega,'dd/mm/yyyy') >
                </cfif>
                <cf_sifcalendario name="ETfechaentrega" value="#fechallegada#">
            </td>
   		</tr>
   		<tr>
        	<!----►►Orden de Compra◄◄--->
            <td class="fileLabel" align="right" nowrap>Orden de Compra:</td>
            <td nowrap>
                <input type="hidden" name="EOidorden" id="EOidorden" value="<cfif modo EQ 'CAMBIO'>#data.EOidorden#</cfif>">
                <input type="text" size="50" readonly style="border:0;" name="Observaciones" id="Observaciones" value="<cfif modo EQ 'CAMBIO'>#LvarObservacion#</cfif>">
                <cfif modo NEQ "CAMBIO">
                  <a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de &Oacute;rdenes de Compra" name="img" width="18" height="14" border="0" align="absmiddle" onClick="javascript: doConlisOrdenCM();"></a>
                </cfif>	  
            </td>
            <!----►►Recibido por◄◄--->
            <td align="right" nowrap class="fileLabel">Recibido por: </td>
     		<td nowrap>
	  			<input name="ETrecibidopor" type="text" id="ETrecibidopor" tabindex="1" onFocus="this.select();" value="<cfif modo neq 'ALTA'>#data.ETrecibidopor#</cfif>" size="25" maxlength="80">
	  		</td>
            <!----►►Medio Transporte◄◄--->
            <td align="right" nowrap class="fileLabel">Medio Transporte: </td>
            <td nowrap>
                <select name="ETmediotransporte">
                <option value="0"<cfif modo EQ 'CAMBIO' and data.ETmediotransporte EQ 0> selected</cfif>>Tierra</option>
                <option value="1"<cfif modo EQ 'CAMBIO' and data.ETmediotransporte EQ 1> selected</cfif>>A&eacute;reo</option>
                <option value="2"<cfif modo EQ 'CAMBIO' and data.ETmediotransporte EQ 2> selected</cfif>>Barco</option>
                <option value="3"<cfif modo EQ 'CAMBIO' and data.ETmediotransporte EQ 3> selected</cfif>>Primera Clase</option>
                <option value="4"<cfif modo EQ 'CAMBIO' and data.ETmediotransporte EQ 4> selected</cfif>>Prioridad</option>
                <option value="5"<cfif modo EQ 'CAMBIO' and data.ETmediotransporte EQ 5> selected</cfif>>Otro</option>
                </select>
            </td>
	</tr>
	<tr>
		<!---►►Estado actual del tracking◄◄--->
  	    <td align="right">Estado actual:</td>
        <td align="left">
			<cfif modo EQ "CAMBIO">		  
            	<cfif data.ETestado eq 'P'>
                        <input name="ETestado" type="hidden" value="P">
                        En Proceso
				<cfelseif data.ETestado eq 'T'>
                        <input name="ETestado" type="hidden" value="T">
                        En Tránsito
                <cfelse>
                        <input name="ETestado" type="hidden" value="E">
                        Entregado
                </cfif>
            <cfelse>
            	<input name="ETestado" type="hidden" value="P">
            	En Proceso
            </cfif>      
	  </td>
      <!---►►Estado Tracking◄◄--->
      <td align="right" nowrap class="fileLabel">Estado Tracking:</td>
      <td nowrap>
        <cfif modo EQ "CAMBIO">
   	 		#data.ETdescripcion#
      	<cfelse>
    		#rsEstadoInicial.ETdescripcion#
        </cfif>
      </td>
    </tr>
    <tr>
      <td colspan="9" align="center">
        <cfif modo eq 'ALTA'>
          <input type="submit" name="Alta" value="Agregar" class="btnGuardar">
          <cfelse>
          <input type="submit" name="Cambio" value="Modificar" class="btnGuardar">
        </cfif>
      </td>
    </tr>
	<cfif modo EQ "CAMBIO">
    <tr>
      <td colspan="9">&nbsp;</td>
    </tr>
    <!---►►Items del Embarque◄◄--->
    <tr>
      <td colspan="9" align="center" nowrap class="tituloAlterno">Items del Embarque</td>
    </tr>
    <tr>
      <td colspan="9">
		<table width="100%"  >
              <tr>
                <td class="tituloListas" align="center">No. Orden</td>
                <td class="tituloListas" align="center">Linea</td>
                <td class="tituloListas" align="center">Estado</td>	
                <td class="tituloListas" align="center">Póliza Actual</td>	
                <td class="tituloListas" align="center">Cantidad</td>				
                <td class="tituloListas" align="center">Cant. Consolidar</td>
                <td class="tituloListas" align="center">Afectación al Tránsito<br />(#monedaLocal.Mnombre#)</td>
              </tr>
              <cfset LvarTotalLineas = 0>
			 <cfloop query="items">
				  <!--- Chequear si parte o toda la línea se encuentra en una póliza abierta --->
					<cfquery name="rscheckPoliza" datasource="#data.cncache#">
						select b.EPDnumero,
                        		 a.DPDcantidad, 
                                 doc.EOnumero, 
                                 b.EPDestado, 
                                 a.DPDvalordeclarado, 
                                 doc.DOconsecutivo
						from DPolizaDesalmacenaje a
                        	inner join EPolizaDesalmacenaje b
                            	on a.EPDid = b.EPDid
                            LEFT OUTER JOIN DOrdenCM doc
                            	on doc.DOlinea = a.DOlinea
						where a.DOlinea     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#items.DOlinea#">
						  and b.EPembarque  = <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.ETidtracking#">
                         
                         UNION ALL
                         
                         select 'Ninguna' as EPDnumero, TER.ETIcantidad as DPDcantidad, doc.EOnumero, 3 as EPDestado,
                            (TER.ETcostodirecto + TER.ETcostoindfletes + TER.ETcostoindseg + TER.ETcostoindsegpropio + 
                             TER.ETcostoindgastos + TER.ETcostoindimp + TER.ETcostoindfletesPoliza + TER.ETcostoindsegPoliza) as DPDvalordeclarado, doc.DOconsecutivo
                        from ETrackingItems TER
                        	 LEFT OUTER JOIN DOrdenCM doc
                            	on doc.DOlinea = TER.DOlinea
                         where TER.ETIiditem   = #items.ETIiditem#
                           and (select count(1) from EPolizaDesalmacenaje where EPembarque = <cf_dbfunction name="to_char"	args="TER.ETidtracking">) = 0
					</cfquery>
					
				  <tr>
					<td colspan="7" align="center">
                    	<strong>#items.ETIdescripcion#</strong><br />Cantidad en Tracking #LSNumberFormat(items.ETIcantidad, ',9.00')#&nbsp;<strong>|</strong>&nbsp;Cantidad Recibida #LSNumberFormat(items.ETcantrecibida, ',9.00')#
                    </td>
				  </tr>
                 <cfloop query="rscheckPoliza">
                 	<cfset LvarTotalLineas = LvarTotalLineas + rscheckPoliza.DPDvalordeclarado>
				  <tr <cfif rscheckPoliza.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>>
					<!--- Orden de Compra de donde provino la línea --->
					<td align="center">
						#rscheckPoliza.EOnumero#
					</td>
                    <td align="center">
						#rscheckPoliza.DOconsecutivo#
					</td>
					<!--- Cantidad recibida en las pólizas --->
					<td align="center">
                    	<cfif rscheckPoliza.EPDestado EQ 0>
                        	En Desalmacenaje
                         <cfelseif rscheckPoliza.EPDestado EQ 10>
                         	Recibida
                         <cfelseif rscheckPoliza.EPDestado EQ 3>
                         	Sin Poliza
                         <cfelse>
                         	Desconocido
                         </cfif>
					</td>
					<td align="center">
						#rscheckPoliza.EPDnumero#
					</td>
					<td align="center">
						#rscheckPoliza.DPDcantidad#
					</td>
					<!--- Cantidad a consolidar a otro tracking --->
					<td align="center">
                    	<cfif listFind("0,3",rscheckPoliza.EPDestado)>
                            <input type="hidden" name="DOlinea" value="#items.DOlinea#">
                            <input type="hidden" name="cantmax_#items.DOlinea#" value="#items.ETIcantidad#">
                            <input type="text" name="ETIcantidad_#items.DOlinea#" size="18" maxlength="18"
                                value="<cfif rscheckPoliza.RecordCount gt 0 or items.ETcantfactura eq 0 or items.ETIcantidad eq 0 or itemsTotales.RecordCount eq 0 or itemsTotales.ETcantfactura neq itemsTotales.ETIcantidad>#LSNumberFormat(0, ',9.00')#<cfelse>#LSNumberFormat(items.ETIcantidad, ',9.00')#</cfif>"
                                onFocus="this.value=qf(this); this.select();"
                                onBlur="javascript: fm(this,2);"
                                onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
                                style="text-align: right;"
                                <cfif rscheckPoliza.EPDnumero NEQ 'Ninguna' or items.ETcantfactura eq 0 or items.ETIcantidad eq 0 or itemsTotales.RecordCount eq 0 or itemsTotales.ETcantfactura neq itemsTotales.ETIcantidad>readonly</cfif>>
                        </cfif>
                    </td>
					<!--- Total que ha afectado la línea al tránsito de acuerdo a todas las distribuciones de facturas --->
					<td align="center">
						#LSNumberFormat(rscheckPoliza.DPDvalordeclarado, ',9.00')#
					</td>
				  </tr>
                  </cfloop>
				  </cfloop>
				  <cfif items.RecordCount gt 0>
				   <tr>
				  	<td class="tituloListas" colspan="6"><strong>Total:</strong></td>
				  	<td align="center" class="tituloListas">
						#LSNumberFormat(LvarTotalLineas, ',9.00')#
					</td>
				  </tr>
                  <tr>
				  	<td class="tituloListas" colspan="6"><strong>Monto Tracking:</strong></td>
				  	<td align="center" class="tituloListas">
						#LSNumberFormat(sumTransito.TotalTransito, ',9.00')#
					</td>
				  </tr>
				  </cfif>
				</table>			
			</td>
            </tr>
            <tr>
			<!--- Opciones de Consolidacion --->
			<cfif data.ETestado NEQ 'E'>
			<td valign="top" colspan="9">
				<table width="100%"  border="0" cellspacing="0" cellpadding="2">
				  <tr>
					<td class="tituloAlterno" colspan="3">Consolidar Items Seleccionados</td>
				  </tr>
				  <tr>
					<td width="1%" nowrap><input name="chk" type="radio" value="1" onClick="javascript: habilitarCamposMover(this.value);" checked></td>
				    <td width="1%" nowrap>a Nuevo Tracking de Embarque</td>
				    <td nowrap>&nbsp;</td>
				  </tr>
				  <tr>
					<td nowrap><input name="chk" type="radio" value="2" onClick="javascript: habilitarCamposMover(this.value);"></td>
					<td nowrap>a Tracking de Embarque Existente </td>
					<td nowrap>
						<input type="hidden" name="ETidtracking_move" value="">
						<input type="hidden" name="ETconsecutivo_move" value="">
						<input type="text" name="ETnumtracking_move" size="30" value="" readonly>
						<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Trackings de Embarque" name="img" width="18" height="14" border="0" align="absmiddle" onClick="javascript: if (document.form1.chk[1].checked) { doConlisTrackings(); }"></a>
					</td>
				  </tr>
				  <tr align="center">
				    <td colspan="3" nowrap>
						<input name="btnConsolidar" class="btnAplicar" type="submit" id="btnConsolidar" value="Consolidar" onClick="javascript: if (ContinuarMover() && confirm('¿Está seguro de que desea consolidar los itemes seleccionados?')) {return true} else {return false}">
					</td>
			      </tr>
				</table>
			</td>
			</cfif>
		  </tr>
	
	</cfif>
  
  </table>
</form>
</cfoutput>

<script language="javascript" type="text/javascript">
	function validar() {
		return true;
	}

	function __isCantidad() {
		var sufix = this.name.split("_")[1];
		/*if (this.required && ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) == 0))) {
			this.error = "El campo " + this.description + " no puede ser cero!";
		}*/
		if (this.required && (this.value != "") && (this.value != " ") && (new Number(qf(this.value)) > new Number(this.obj.form["cantmax_"+sufix].value))) {
			this.error = "El campo " + this.description + " no puede ser mayor a " + this.obj.form["cantmax_"+sufix].value;
		}
	}

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	_addValidator("isCantidad", __isCantidad);

	objForm.EOidorden.required = true;
	objForm.EOidorden.description = "Orden de Compra";

	<cfoutput>
		<cfif modo neq 'ALTA'>
			<cfloop query="items">
				objForm.ETIcantidad_#items.DOlinea#.required = true;
				objForm.ETIcantidad_#items.DOlinea#.description = "Cantidad del item #JSStringFormat(items.ETIdescripcion)#";
				objForm.ETIcantidad_#items.DOlinea#.validateCantidad();
			</cfloop>
		</cfif>
	</cfoutput>
	
</script>
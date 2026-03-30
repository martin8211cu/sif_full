<cfloop collection="#Form#" item="i">
    <cfif FindNoCase("chkHijo_", i) NEQ 0 and Form[i] NEQ 0>
        	<cfset Lineas = Form[i]>
            <cfset LvarDet = #ListToArray(Lineas, ",")#>
         <cfloop from="1" to="#ArrayLen(LvarDet)#" index="n">
			 <cfset LvarDetalle = #ListToArray(LvarDet[n], "|")#>
				<cfset LvarDSlinea = LvarDetalle[1]>
                <cfset LvarEOidorden = LvarDetalle[2]>

           <cftransaction>
               <!--- ►►Obtiene cada una de las lineas de la solicitud de compra◄◄--->
                <cfquery name="rsDatos" datasource="#Session.DSN#">
                    SELECT DSlinea,
                           ESidsolicitud,
                           Ecodigo,
                           ESnumero,
                           DSconsecutivo,
                           DScant,
                           DScantsurt,
                           DScantcancel,
                           DStipo,
                           Aid,
                           Alm_Aid,
                           Cid,
                           ACcodigo,
                           ACid,
                           PCGDid,
                           CMCid,
                           Icodigo,
                           Ucodigo,
                           CFcuenta,
                           CFid,
                           OBOid,
                           FPAEid,
                           CFComplemento,
                           DSdescripcion,
                           DSdescalterna,
                           DSobservacion,
                           DSreflin,
                           DSmontoest,
                           DStotallinest,
                           DSfechareq,
                           DSformatocuenta,
                           DSespecificacuenta,
                           CFidespecifica,
                           DSconsecutivoOri,
                           DScontratos,
                           DSimpuestoCF,
                           DSimpuestoCosto,
                           DSnoPresupuesto,
                           DSmodificable,
                           DScantidadNAP,
                           DSmontoOriNAP,
                           DScontrolCantidad,
                           CPDClinea,
                           CPDCid,
                           BMUsucodigo,
                           ts_rversion,
						<!---JMRV. Inicio de cambio. 30/04/2014--->
						   CPDCid,
						   case
						   	when (DScant - DScantsurt) > 0 then (DScant - DScantsurt)
						   	else 0
						   end as cantidadDisponible
						<!---JMRV. Fin de cambio. 30/04/2014--->,
						codIEPS,
						coalesce(DSMontoIeps,0) as DSMontoIeps
                   FROM DSolicitudCompraCM
                  WHERE DSlinea = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#LvarDSlinea#">
             </cfquery>

               <!--- ►►ID de la Orden de compra que se esta llenado◄◄--->
                <cfquery name="rsOrdenCompra" datasource="#session.dsn#">
                    select  EOnumero, EOidorden
                        from ERemisionesFA
                     where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEOidorden#">
                </cfquery>

                <!---Inserta linea de detalle de la orden de compra--->
                <cfinvoke component="sif.Componentes.FAP_AplicaPedidos"  method="insert_DOrdenCM">
                    <cfinvokeargument name="Ecodigo" 			value="#rsDatos.Ecodigo#">
                    <cfinvokeargument name="EOidorden" 			value="#rsOrdenCompra.EOidorden#">
                    <cfinvokeargument name="EOnumero" 			value="#rsOrdenCompra.EOnumero#">
                    <cfinvokeargument name="CMtipo" 			value="#rsDatos.DStipo#">
                    <cfinvokeargument name="ESidsolicitud" 		value="#rsDatos.ESidsolicitud#">
                    <cfinvokeargument name="DSlinea" 			value="#rsDatos.DSlinea#">
                    <cfinvokeargument name="Cid" 				value="#rsDatos.Cid#">
                    <cfinvokeargument name="Aid" 				value="#rsDatos.Aid#">
                    <cfinvokeargument name="Alm_Aid" 			value="#rsDatos.Alm_Aid#">
                    <cfinvokeargument name="ACcodigo" 			value="#rsDatos.ACcodigo#">
                    <cfinvokeargument name="ACid" 				value="#rsDatos.ACid#">
                    <cfinvokeargument name="DOdescripcion" 		value="#rsDatos.DSdescripcion#">
                    <cfinvokeargument name="DOobservaciones" 	value="#rsDatos.DSobservacion#">
                    <cfinvokeargument name="DOalterna" 			value="#rsDatos.DSdescalterna#">
                    <cfinvokeargument name="DOcantidad" 		value="#rsDatos.cantidadDisponible#">
                    <cfinvokeargument name="DOcantsurtida" 		value="#rsDatos.DScantsurt#">
                    <cfinvokeargument name="DOpreciou" 			value="#rsDatos.DSmontoest#">
                    <cfinvokeargument name="DOfechaes" 			value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
                    <!---<cfinvokeargument name="DOgarantia" 	value="">--->
                    <cfinvokeargument name="CFid" 				value="#rsDatos.CFid#">
                    <cfinvokeargument name="Icodigo" 			value="#rsDatos.Icodigo#">
                    <cfinvokeargument name="Ucodigo" 			value="#rsDatos.Ucodigo#">
                    <cfinvokeargument name="DOfechareq" 		value="#LSDateFormat(rsDatos.DSfechareq,'dd/mm/yyyy')#">
                    <!---<cfinvokeargument name="Ppais" 		value="CR">--->
                    <cfinvokeargument name="Ucodigo" 			value="#rsDatos.Ucodigo#">
                    <cfinvokeargument name="tipo" 				value="#rsDatos.DStipo#">
                    <!---<cfinvokeargument name="DOmontodesc" 	value="">--->
                    <!---<cfinvokeargument name="DOporcdesc" 	value="">--->
                    <cfinvokeargument name="PCGDid" 			value="#rsDatos.PCGDid#">
                    <!---<cfinvokeargument name="CPDDid" 		value="">--->
                    <cfif LEN(TRIM(rsDatos.FPAEid))>
                        <cfinvokeargument name="FPAEid" 			value="#rsDatos.FPAEid#">
                    </cfif>
                    <cfinvokeargument name="CFComplemento" 		value="#rsDatos.CFComplemento#">
					<!---JMRV. Inicio de cambio. 30/04/2014--->
					<cfif rsDatos.DStipo eq "A" and rsDatos.CPDCid neq ""><cfinvokeargument name="PlantillaDistribucion" value="#rsDatos.CPDCid#">
					<cfelse><cfinvokeargument name="PlantillaDistribucion" value="0"></cfif>
					<cfif rsDatos.DStipo eq "A" and rsDatos.CPDCid neq ""><cfinvokeargument name="CheckDistribucionHidden" value="1">
					<cfelse><cfinvokeargument name="CheckDistribucionHidden" value="0"></cfif>
					<!---JMRV. Fin de cambio. 30/04/2014--->
					<cfinvokeargument name="codIEPS" 		    value="#rsDatos.codIEPS#">
                </cfinvoke>

               <!--- calcula Monto--->
                <cfinvoke component="sif.Componentes.FAP_AplicaPedidos" method="calculaTotalesEOrdenCM">
                    <cfinvokeargument name="ecodigo"   value="#rsDatos.Ecodigo#">
                    <cfinvokeargument name="eoidorden" value="#LvarEOidorden#">
                </cfinvoke>
            </cftransaction>
		</cfloop>
	</cfif>
</cfloop>

<script language="JavaScript" type="text/javascript">
	//llama a la funcion de cambio de orden de compra
	if (window.opener.document.form1.Cambio)
		window.opener.document.form1.Cambio.click();
	else if (window.opener.document.form1.CambioDet)
		window.opener.document.form1.CambioDet.click();
	window.close();
</script>
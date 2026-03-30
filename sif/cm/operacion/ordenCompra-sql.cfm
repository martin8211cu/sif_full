<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<!---
	Cantidades:
		DOcantidad:			Cantidad ordenada Original
		DOcantsurtida:		(Cantidad Recibida o Cantidad CxP) - Exceso - Cantidad Devuelta
		DOcantexceso:		Cantidad Original - Cantidad Recibida cuando es Recibida > DOcantidad
		Saldo Cantidad:		DOcantidad - DOcantsurtida
		DOcantliq:			Saldo al liquidar
		Cantidad Cancelada:	Cantidad no surtida al momento de la cancelación (DOcantidad-DOcantsurtida)
--->
<cfset lvarProvCorp = false>

<cfif isdefined("form.chk") and len(trim(form.chk))>
  <cfset  form.Ecodigo_f = #trim(listGetAt(form.chk,3,'|'))#>
<cfelse>
	<cfparam name="form.Ecodigo_f" default="#session.Ecodigo#">
</cfif>
<cfset lvarFiltroEcodigo = form.Ecodigo_f>
<!--- Verifica si esta activa la Probeduria Corporativa --->
<cfquery name="rsProvCorp" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo=#session.Ecodigo#
	and Pcodigo=5100
</cfquery>
<cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
	<cfset lvarProvCorp = true>
</cfif>

<cfset Request.Error.Backs = 1>
<!---Para Agregar parámetros a la dirección de regreso --->
<cfset params = "">
<cfset vnCMCid = "">
<cfif NOT ISDEFINED('form.ActividadId') OR NOT LEN(TRIM(form.ActividadId))>
	<CFSET form.ActividadId = -1>
</cfif>
<cfparam name="form.Actividad" 	 default="">

<cfif isdefined("form.vnCMCid") and len(trim(form.vnCMCid))>
	<cfset vnCMCid = form.vnCMCid>
<cfelseif isdefined("session.compras.comprador") and len(trim(session.compras.comprador))>
	<cfset vnCMCid = session.compras.comprador>
</cfif>

<!--- Se le quita el indicador de 1/0 para saber si tenia q ir a jerarquia,
    se deja el form.chk con solo el valor del EOidorden ---->
<cfif isdefined("form.chk") and len(trim(form.chk))>
  <cfset form.chk = listGetAt(form.chk,1,'|')>
</cfif>

<!---►►Agrega el Encabezado de la Orden de Compra◄◄--->
<cfif isdefined("form.Alta")>
    <cfinvoke component="sif.Componentes.CM_AplicaOC" method="insert_EOrdenCM" returnvariable="LvarEOidorden">
        <cfinvokeargument name="ecodigo" 			value="#lvarFiltroEcodigo#"/>
        <cfinvokeargument name="sncodigo" 			value="#form.SNcodigo#"/>
        <cfinvokeargument name="cmcid" 				value="#vnCMCid#"/>
        <cfinvokeargument name="mcodigo" 			value="#form.Mcodigo#"/>
        <cfinvokeargument name="rcodigo" 			value="#form.Rcodigo#"/>
        <cfinvokeargument name="cmtocodigo" 		value="#form.CMTOcodigo#"/>
        <cfinvokeargument name="eofecha" 			value="#form.EOfecha#"/>
        <cfinvokeargument name="cmcid" 				value="#vnCMCid#"/>
        <cfinvokeargument name="rcodigo" 			value="#form.Rcodigo#"/>
        <cfinvokeargument name="cmtocodigo" 		value="#form.CMTOcodigo#"/>
        <cfinvokeargument name="eofecha" 			value="#form.EOfecha#"/>
        <cfinvokeargument name="observaciones" 		value="#form.Observaciones#"/>
        <cfinvokeargument name="eotc" 				value="#form.EOtc#"/>
        <cfinvokeargument name="impuesto" 			value="#form.EOdesc#"/>
        <cfinvokeargument name="eodesc" 			value="#form.EOdesc#"/>
        <cfinvokeargument name="eototal" 			value="0.00"/>
        <cfinvokeargument name="eoplazo" 			value="#form.EOplazo#"/>
        <cfinvokeargument name="eohabiles" 			value="#form.EOhabiles#"/>
        <cfinvokeargument name="eoporcanticipo" 	value="#form.EOporcanticipo#"/>
        <cfinvokeargument name="CMFPid" 			value="#form.CMFPid#"/>
        <cfinvokeargument name="CMIid" 				value="#Iif(Len(Trim(form.CMIid)), DE(form.CMIid), DE('-1'))#"/>
        <cfinvokeargument name="EOdiasEntrega" 		value="#Iif(Len(Trim(form.EOdiasEntrega)), DE(form.EOdiasEntrega), DE('0'))#"/>
        <cfinvokeargument name="EOtipotransporte" 	value="#form.EOtipotransporte#"/>
        <cfinvokeargument name="EOlugarentrega" 	value="#form.EOlugarentrega#"/>
        <cfinvokeargument name="CRid" 				value="#Iif(Len(Trim(form.CRid)), DE(form.CRid), DE('-1'))#"/>
    </cfinvoke>
	<cfset params = AddParam(params,'EOidorden',LvarEOidorden)>
    <cfset params = AddParam(params,'Ecodigo_f',lvarFiltroEcodigo)>

<!---►►Modifica el Encabezado de la Orden de Compra◄◄--->
<cfelseif isdefined("form.Cambio")>
	<cfparam name="lvarFiltroEcodigo" default="#Session.Ecodigo#">
    <cfif lvarProvCorp>
    	<cfquery name="rsEcodigo" datasource="#session.DSN#">
            select Ecodigo
            from EOrdenCM
            where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		</cfquery>
        <cfset lvarFiltroEcodigo = rsEcodigo.Ecodigo>
    </cfif>
	<cfset ActualizarEncabezado(lvarFiltroEcodigo)>
	<cfset calculaMonto(form.EOidorden,lvarFiltroEcodigo)>
	<cfset params = AddParam(params,'EOidorden',form.EOidorden)>
    <cfset params = AddParam(params,'Ecodigo_f',lvarFiltroEcodigo)>
    <cf_cboFormaPago TESOPFPtipoId="2" TESOPFPid="#Form.EOidorden#" Ecodigo="#lvarFiltroEcodigo#" SQL="update">

<!---►►Elimina toda la Orden de Compra◄◄--->
<cfelseif isdefined("form.Baja")>
	<cfset lvarFiltroEcodigo = Session.Ecodigo>
    <cfif lvarProvCorp>
    	<cfquery name="rsEcodigo" datasource="#session.DSN#">
            select Ecodigo
            from EOrdenCM
            where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		</cfquery>
        <cfset lvarFiltroEcodigo = rsEcodigo.Ecodigo>
    </cfif>

	<cfquery name="rsdel" datasource="#Session.DSN#">
		select * from DOrdenCM
		where Ecodigo = #lvarFiltroEcodigo#
			and EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EOnumero#">
	</cfquery>
	<cfloop query="rsdel">
		<cfinvoke component="sif.Componentes.CM_AplicaOC" method="delete_DOrdenCM">
	        <cfinvokeargument name="dolinea" 		value="#rsdel.DOlinea#">
	        <cfinvokeargument name="eoidorden" 		value="#form.EOidorden#">
	        <cfinvokeargument name="ecodigo" 		value="#lvarFiltroEcodigo#">
		</cfinvoke>
	</cfloop>

	<cfquery name="rsdel" datasource="#Session.DSN#">
		delete from DOrdenCM
		where Ecodigo = #lvarFiltroEcodigo#
			and EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EOnumero#">
	</cfquery>

	<cfinvoke component="sif.Componentes.CM_AplicaOC" method="delete_EOrdenCM">
    	<cfinvokeargument name="eoidorden" value="#form.EOidorden#">
        <cfinvokeargument name="ecodigo"   value="#lvarFiltroEcodigo#">
    </cfinvoke>

    <cf_cboFormaPago TESOPFPtipoId="2" TESOPFPid="#Form.EOidorden#" Ecodigo="#lvarFiltroEcodigo#" SQL="delete">

<!---►►Agrega detalles de la Orden de Compra◄◄--->
<cfelseif isdefined("form.AltaDet")>
	<cfif form.CMtipo eq "A">
		<cfset form.Cid = -1>
		<cfset form.ACid = -1>
		<cfset form.ACcodigo = -1>
	<cfelseif form.CMtipo eq "S">
		<cfset form.Aid = -1>
		<cfset form.ACid = -1>
		<cfset form.ACcodigo = -1>
	<cfelseif form.CMtipo eq "F">
		<cfset form.Aid = -1>
		<cfset form.Cid = -1>
	</cfif>
    <cfset lvarFiltroEcodigo = Session.Ecodigo>
    <cfif lvarProvCorp>
    	<cfquery name="rsEcodigo" datasource="#session.DSN#">
            select Ecodigo
            from EOrdenCM
            where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		</cfquery>
        <cfset lvarFiltroEcodigo = rsEcodigo.Ecodigo>
    </cfif>
	<cfset vbHayContrato = VerificaContrato(form.SNcodigo, form.Aid, form.Cid, form.ACid, form.EOfecha, form.Ucodigo, lvarFiltroEcodigo)>

	<cfif not vbHayContrato>

		<cfinvoke component="sif.Componentes.CM_AplicaOC" method="insert_DOrdenCM">
        	<cfinvokeargument name="eoidorden" 			value="#form.EOidorden#">
            <cfinvokeargument name="eonumero" 			value="#form.EOnumero#">
            <cfinvokeargument name="ecodigo" 			value="#lvarFiltroEcodigo#">
            <cfinvokeargument name="cmtipo" 			value="#form.CMtipo#">
            <cfinvokeargument name="cid" 				value="#form.Cid#">
            <cfinvokeargument name="aid" 				value="#form.Aid#">
            <cfinvokeargument name="alm_aid" 			value="#form.Almacen#">
            <cfinvokeargument name="accodigo" 			value="#form.ACcodigo#">
            <cfinvokeargument name="acid" 				value="#form.ACid#">
            <cfinvokeargument name="dodescripcion" 		value="#Mid(form.DOdescripcion,1,255)#">
            <cfinvokeargument name="doobservaciones" 	value="#Mid(form.DOobservaciones,1,255)#">
            <cfinvokeargument name="doalterna" 			value="#Mid(form.DOalterna,1,1024)#">
            <cfinvokeargument name="docantidad" 		value="#form.DOcantidad#">
            <cfinvokeargument name="dopreciou" 			value="#LvarOBJ_PrecioU.enCF(form.DOpreciou)#">
            <cfinvokeargument name="dofechaes" 			value="#form.DOfechaes#">
            <cfinvokeargument name="dogarantia"	 		value="#form.DOgarantia#">
            <cfinvokeargument name="cfid" 				value="#form.CFid#">
            <cfinvokeargument name="icodigo" 			value="#form.Icodigo#">
            <cfinvokeargument name="ucodigo" 			value="#form.Ucodigo#">
            <cfinvokeargument name="ppais" 				value="#form.Ppais#">
            <cfinvokeargument name="dofechareq" 		value="#form.DOfechareq#">
            <cfinvokeargument name="DOmontodesc" 		value="#form.DOmontodesc#">
            <cfinvokeargument name="DOporcdesc" 		value="#form.DOporcdesc#">
            <cfinvokeargument name="FPAEid" 			value="#form.ActividadId#">
            <cfinvokeargument name="CFComplemento" 		value="#form.Actividad#">
			<!---JMRV. Inicio de cambio. 30/04/2014--->
			<cfif isdefined("form.PlantillaDistribucion") and isdefined("form.CheckDistribucionHidden") and form.CheckDistribucionHidden eq 1 and form.PlantillaDistribucion eq -1>
				<cfthrow message="No ha seleccionado una distribucion.">
			<cfelseif isdefined("form.PlantillaDistribucion") and isdefined("form.CheckDistribucionHidden")>
				<cfinvokeargument name="PlantillaDistribucion" 	value="#form.PlantillaDistribucion#">
				<cfinvokeargument name="CheckDistribucionHidden" 	value="#form.CheckDistribucionHidden#">
			<cfelse>
				<cfinvokeargument name="PlantillaDistribucion" 	value="0">
				<cfinvokeargument name="CheckDistribucionHidden" 	value="0">
			</cfif>
			<!---JMRV. Fin de cambio. 30/04/2014--->
			<cfinvokeargument name="codIEPS" 			value="#form.codIEPS#">
        </cfinvoke>

		<cfif form.EncabezadoCambiado EQ 1>
			<cfset ActualizarEncabezado(lvarFiltroEcodigo)>
		</cfif>
		<cfset calculaMonto(form.EOidorden, lvarFiltroEcodigo)>
		<cfset params = AddParam(params,'EOidorden',form.EOidorden)>
        <cfset params = AddParam(params,'Ecodigo_f',lvarFiltroEcodigo)>
	<cfelse>
		<cf_errorCode	code = "50308" msg = "El bien de la línea esta asociada a un contrato, por lo tanto no puede ser agregado a la orden de compra">
	</cfif>
<!---►►Modifica detalles de la Orden de Compra◄◄--->
<cfelseif isdefined("form.CambioDet")>
	<cfif not isdefined('form.EOestado') OR form.EOestado EQ 5>
		<cfif form.CMtipo eq "A">
			<cfset form.Cid = -1>
			<cfset form.ACid = -1>
			<cfset form.ACcodigo = -1>
		<cfelseif form.CMtipo eq "S">
			<cfset form.Aid = -1>
			<cfset form.ACid = -1>
			<cfset form.ACcodigo = -1>
		<cfelseif form.CMtipo eq "F">
			<cfset form.Aid = -1>
			<cfset form.Cid = -1>
		</cfif>
		<cfset lvarFiltroEcodigo = Session.Ecodigo>
		<cfif lvarProvCorp>
            <cfquery name="rsEcodigo" datasource="#session.DSN#">
                select Ecodigo
                from EOrdenCM
                where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
            </cfquery>
            <cfset lvarFiltroEcodigo = rsEcodigo.Ecodigo>
        </cfif>
		<cfset vbHayContrato = VerificaContrato(form.SNcodigo, form.Aid, form.Cid, form.ACid, form.EOfecha, form.Ucodigo, lvarFiltroEcodigo)>

		<cfif not vbHayContrato>
            <cfinvoke component="sif.Componentes.CM_AplicaOC" method="update_DOrdenCM">
                <cfinvokeargument name="dolinea" 			value="#form.DOlinea#">
                <cfinvokeargument name="eoidorden" 			value="#form.EOidorden#">
                <cfinvokeargument name="eonumero" 			value="#form.EOnumero#">
                <cfinvokeargument name="ecodigo" 			value="#lvarFiltroEcodigo#">
                <cfinvokeargument name="cmtipo" 			value="#form.CMtipo#">
                <cfinvokeargument name="cid" 				value="#form.Cid#">
                <cfinvokeargument name="aid" 				value="#form.Aid#">
                <cfinvokeargument name="alm_aid" 			value="#form.Almacen#">
                <cfinvokeargument name="accodigo" 			value="#form.ACcodigo#">
                <cfinvokeargument name="acid" 				value="#form.ACid#">
                <cfinvokeargument name="dodescripcion" 		value="#Mid(form.DOdescripcion,1,255)#">
                <cfinvokeargument name="doobservaciones" 	value="#Mid(form.DOobservaciones,1,255)#">
                <cfinvokeargument name="doalterna" 			value="#Mid(form.DOalterna,1,1024)#">
                <cfinvokeargument name="docantidad" 		value="#form.DOcantidad#">
                <cfinvokeargument name="dopreciou" 			value="#LvarOBJ_PrecioU.enCF(form.DOpreciou)#">
                <cfinvokeargument name="dofechaes" 			value="#form.DOfechaes#">
                <cfinvokeargument name="dogarantia" 		value="#form.DOgarantia#">
                <cfinvokeargument name="cfid" 				value="#form.CFid#">
                <cfinvokeargument name="icodigo" 			value="#form.Icodigo#">
                <cfinvokeargument name="ucodigo" 			value="#form.Ucodigo#">
                <cfinvokeargument name="ppais" 				value="#form.Ppais#">
                <cfinvokeargument name="dofechareq" 		value="#form.DOfechareq#">
                <cfinvokeargument name="DOmontodesc" 		value="#form.DOmontodesc#">
                <cfinvokeargument name="DOporcdesc" 		value="#form.DOporcdesc#">
                <cfinvokeargument name="FPAEid" 			value="#form.ActividadId#">
            	<cfinvokeargument name="CFComplemento" 		value="#form.Actividad#">
				<!---JMRV. Inicio de cambio.  30/04/2014.--->
				<cfquery name="ObtenerDatos" datasource="#session.dsn#">
					select ESidsolicitud,CPDCid,CPDDid,CTDContid
	  				from DOrdenCM
					where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
					and DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DOlinea#">
				</cfquery>
                <!---Si la linea viene de una solicitud entonces no se cambian los datos de la distribucion--->
				<cfif isdefined("ObtenerDatos") and not (ObtenerDatos.ESidsolicitud neq "" and ObtenerDatos.ESidsolicitud gt 0)
                    and not (ObtenerDatos.CPDDid neq "" and ObtenerDatos.CPDDid gt 0)
                    and not (ObtenerDatos.CTDContid neq "" and ObtenerDatos.CTDContid gt 0)>
					<cfif isdefined("form.PlantillaDistribucion") and isdefined("form.CheckDistribucionHidden") and form.CheckDistribucionHidden eq 1 and form.PlantillaDistribucion eq -1>
						<cfthrow message="No ha seleccionado una distribucion.">
					<cfelseif isdefined("form.PlantillaDistribucion") and isdefined("form.CheckDistribucionHidden")>
						<cfinvokeargument name="PlantillaDistribucion" 	value="#form.PlantillaDistribucion#">
						<cfinvokeargument name="CheckDistribucionHidden" 	value="#form.CheckDistribucionHidden#">
                    </cfif>
                </cfif>
                <!---JMRV. Fin de cambio. 30/04/2014--->
            </cfinvoke>
		<cfelse>
				<cfquery name="rsActualizaFechaReq" datasource="#session.dsn#">
					update DOrdenCM set DOfechaes = <cfif len(trim(form.DOfechaes)) ><cfqueryparam cfsqltype="cf_sql_timestamp"	value="#LSParseDateTime(form.DOfechaes)#"><cfelse>null</cfif>
					where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
						and DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DOlinea#">
				</cfquery>
		</cfif>
	</cfif>

	<cfif form.EncabezadoCambiado EQ 1>
		<cfset ActualizarEncabezado(lvarFiltroEcodigo)>
	</cfif>
	<cfset calculaMonto(form.EOidorden,lvarFiltroEcodigo)>
	<cfset params = AddParam(params,'DOlinea',form.DOlinea)>
	<cfset params = AddParam(params,'EOidorden',form.EOidorden)>
    <cfset params = AddParam(params,'Ecodigo_f',lvarFiltroEcodigo)>

<!---►►Eliminación detalles de la Orden de Compra◄◄--->
<cfelseif isdefined("form.BajaDet")>

    <cfset lvarFiltroEcodigo = Session.Ecodigo>
    <cfif lvarProvCorp>
    	<cfquery name="rsEcodigo" datasource="#session.DSN#">
            select Ecodigo
            from EOrdenCM
            where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		</cfquery>
        <cfset lvarFiltroEcodigo = rsEcodigo.Ecodigo>
    </cfif>
	<cfinvoke component="sif.Componentes.CM_AplicaOC" method="delete_DOrdenCM">
        <cfinvokeargument name="dolinea" 		value="#form.DOlinea#">
        <cfinvokeargument name="eoidorden" 		value="#form.EOidorden#">
        <cfinvokeargument name="ecodigo" 		value="#lvarFiltroEcodigo#">
	</cfinvoke>

	<cfif form.EncabezadoCambiado EQ 1>
		<cfset ActualizarEncabezado(lvarFiltroEcodigo)>
	</cfif>
	<cfset calculaMonto(form.EOidorden, lvarFiltroEcodigo)>
	<cfset params = AddParam(params,'EOidorden',form.EOidorden)>
    <cfset params = AddParam(params,'Ecodigo_f',lvarFiltroEcodigo)>

<!---►►Nuevo detalles de la Orden de Compra◄◄--->
<cfelseif isdefined("form.NuevoDet")>
	<cfset params = AddParam(params,'EOidorden',form.EOidorden)>
    <cfset params = AddParam(params,'Ecodigo_f',lvarFiltroEcodigo)>

<!---►►Aplicacion de la Orden de Compra◄◄--->
<cfelseif isdefined("Form.btnAplicar")>
	<cfif isdefined("form.chk") and len(trim(form.chk))>
		<cfset form.EOidorden = form.chk>
	</cfif>
	<cfif lvarProvCorp>
    	<cfquery name="rsEcodigo" datasource="#session.DSN#">
            select Ecodigo
            from EOrdenCM
            where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		</cfquery>
        <cfset lvarFiltroEcodigo = rsEcodigo.Ecodigo>
    </cfif>
	<cfset calculaMonto(form.EOidorden,lvarFiltroEcodigo)>

	<!--- Valida que el monto de la orden de compra sea mayor a cero --->
	<cfquery name="dataMonto" datasource="#session.DSN#">
		select EOtotal
		from EOrdenCM
		where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		  and Ecodigo   = #lvarFiltroEcodigo#
	</cfquery>

	<cfif dataMonto.EOtotal lte 0>
		<cf_errorCode	code = "50309" msg = "El monto de la orden debe ser mayor a cero!">
	</cfif>

	<cfinvoke component="sif.Componentes.CM_AplicaOC" method ="fnAplicaOC" returnvariable ="LvarNap">
    	<cfinvokeargument name="EOidorden"  value="#form.EOidorden#">
        <cfinvokeargument name="CMCid" 		value="#vnCMCid#">
        <cfinvokeargument name="Ecodigo" 	value="#lvarFiltroEcodigo#">
    </cfinvoke>

	<cfif LvarNAP LT 0>
		<cfquery datasource="#session.DSN#">
			update EOrdenCM
			set EOestado = -10,
				NRP         = #abs(LvarNAP)#
			where EOidorden = #form.EOidorden#
			  and Ecodigo   = #lvarFiltroEcodigo#
		</cfquery>
		<cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(LvarNAP)#">
	</cfif>
<!---►►Cambio de Campos Editables◄◄--->
<cfelseif isdefined("Form.CambioDetM")>
	<cfquery name="rsModificables" datasource="#Session.DSN#">
        select CMTOModDescripcion, CMTOModFechaEntrega, CMTOModFechaRequerida, CMTOModImpuesto,
        1 as CMTOModobservaciones, 1 as CMTOModalterna
        from CMTipoOrden
        where Ecodigo    = #lvarFiltroEcodigo#
     	  and CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.CMTOcodigo)#">
    </cfquery>
	<cfquery datasource="#session.DSN#">
        update DOrdenCM set
        	BMUsucodigo 	= #session.usucodigo#
         <cfif rsModificables.CMTOModobservaciones EQ 1>
        	, DOobservaciones = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DOobservaciones#">
        </cfif>
         <cfif rsModificables.CMTOModalterna EQ 1>
        	, DOalterna = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DOalterna#">
        </cfif>
        <cfif rsModificables.CMTOModDescripcion EQ 1>
        	, DOdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DOdescripcion#">
        </cfif>
        <cfif rsModificables.CMTOModFechaEntrega EQ 1>
        	, DOfechaes = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSdateFormat(form.DOfechaes)#">
        </cfif>
        <cfif rsModificables.CMTOModFechaRequerida EQ 1>
        	, DOfechareq = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSdateFormat(form.DOfechareq)#">
        </cfif>
        <cfif rsModificables.CMTOModImpuesto EQ 1>
        	, Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Icodigo#">
        </cfif>
        where EOidorden = #form.EOidorden#
          and DOlinea   = #form.DOlinea#
          and Ecodigo   = #lvarFiltroEcodigo#
    </cfquery>
 	<cfif form.EncabezadoCambiado EQ 1>
		<cfset ActualizarEncabezado(lvarFiltroEcodigo)>
	</cfif>
	<cfset calculaMonto(form.EOidorden,lvarFiltroEcodigo)>
    <cfset params = AddParam(params,'EOidorden',form.EOidorden)>
    <cfset params = AddParam(params,'Ecodigo_f',lvarFiltroEcodigo)>
<!---►►Reiniciar Proceso de Aprobación, volver a enviar al aprobador◄◄--->
<cfelseif isdefined('form.btnReiniciar')>
	<cfinvoke component="sif.Componentes.CM_OrdenCompra" method="ReiniciaAutorizacion">
    	<cfinvokeargument name="EOidorden" value="#form.EOidorden#">
        <cfinvokeargument name="Ecodigo" value="#lvarFiltroEcodigo#">
    </cfinvoke>
    <cflocation url="listaOrdenCM.cfm">
</cfif>

<!---Regresa al Form--->
<cfif not isdefined("form.action")>
	<cfif not isdefined("form.btnAplicar") and not isdefined("form.Baja")>
		<cflocation url="ordenCompra.cfm#params#">
	<cfelseif isdefined("form.btnAplicar") and LvarNAP GTE 0>
		<cflocation url="listaOrdenCM.cfm?Imprimir=true&EOidorden=#form.EOidorden#&tipoImpresion=1">
	<cfelse>
		<cflocation url="listaOrdenCM.cfm">
	</cfif>
<cfelse>
	<cfif not isdefined("form.btnAplicar") and not isdefined("form.Regresar")>
		<cflocation url="ordenCompraRechazada-form.cfm#params#">
	<cfelseif isdefined("form.btnAplicar") and LvarNAP GTE 0>
		<cflocation url="ordenCompraRechazada.cfm?Imprimir=true&EOidorden=#form.EOidorden#&tipoImpresion=1">
	<cfelse>
		<cflocation url="ordenCompraRechazada.cfm">
	</cfif>
</cfif>

<cffunction name="AddParam" returntype="string" output="no">
	<cfargument name="params" type="string" required="yes">
	<cfargument name="paramname" type="string" required="yes">
	<cfargument name="paramvalue" type="string" required="yes">
	<cfset separador = iif(len(trim(arguments.params)),DE('&'),DE('?'))>
	<cfset nuevoparam = arguments.paramname & '=' & arguments.paramvalue>
	<cfreturn arguments.params & separador & nuevoparam>
</cffunction>

<!---Actualiza Montos del Encabezado--->
<cffunction name="calculaMonto" access="private" output="no">
	<cfargument name="EOidorden" required="yes" type="numeric">
	<cfargument name="Ecodigo" required="no" type="numeric" default="#session.Ecodigo#">

	<cfinvoke 	component	= "sif.Componentes.CM_AplicaOC"
				method		= "calculaTotalesEOrdenCM"

				ecodigo="#Arguments.Ecodigo#"
				eoidorden="#Arguments.EOidorden#"
	/>
</cffunction>

<cffunction name="VerificaContrato" returntype="boolean" access="private" output="no">
	<!---=============================================================================================================
			Función "VerificaContrato" para verificar si ese bien(articulo/servicio) esta dentro de algun contrato:
				a) Para el proveedor de la OC.
				b) Este vigente aún (segun la fecha de la OC).
				c) Este en la misma unidad de medida que el bien en la OC.
	=============================================================================================================------>
	<cfargument name="SNcodigo" type="numeric" 	required="yes">		<!----Codigo del socio de negocio--->
	<cfargument name="Aid" 		required="no" 	type="numeric" >	<!---ID del articulo, si no es un articulo recibe -1---->
	<cfargument name="Cid" 		required="no" 	type="numeric" >	<!---ID del servicio, si no es un servicio recibe -1---->
	<cfargument name="ACid" 	type="numeric" 	required="no" >		<!---ID de la categoria, si no es un categoria recibe -1---->
	<cfargument name="EOfecha" 	type="string" 	required="yes" >	<!---Fecha de la orden de compra---->
	<cfargument name="Ucodigo" 	type="string" 	required="yes" >	<!---Unidad de medida del bien (articulo, servicio o activo---->
	<cfargument name="Ecodigo" 	type="numeric" 	required="no" >

   	<cfif not isdefined('Arguments.Ecodigo')>
    	<cfset Arguments.Ecodigo = Session.Ecodigo>
	</cfif>

	<cfquery name="rsContratos" datasource="#session.DSN#">
		select 	1
		from DContratosCM a
			inner join EContratosCM b
				on a.ECid = b.ECid
				and a.Ecodigo = b.Ecodigo
				and b.SNcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.SNcodigo#">
		where a.Ecodigo = #Arguments.Ecodigo#
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.EOfecha#"> between b.ECfechaini and b.ECfechafin
			and a.Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ucodigo#">
		<cfif trim(arguments.Aid) NEQ -1>
			and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Aid#">
		<cfelseif trim(arguments.Cid) NEQ -1>
			and a.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Cid#">
		<cfelse>
			and a.ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ACid#">
		</cfif>
	</cfquery>
	<cfif rsContratos.RecordCount NEQ 0>
		<cfset vbHayContrato = true>
	<cfelse>
		<cfset vbHayContrato = false>
	</cfif>

	<cfreturn vbHayContrato>

</cffunction>

<cffunction name="ActualizarEncabezado" access="private" output="no">
	<cfargument name="Ecodigo" required="no" type="numeric">
	<!---
		Actualiza el encabezado
		NOTA: PONE LOS MONTOS EN CERO
	--->

    <cfif not isdefined('Arguments.Ecodigo')>
    	<cfset Arguments.Ecodigo = Session.Ecodigo>
	</cfif>
	<cfinvoke 	component="sif.Componentes.CM_AplicaOC"
				method			= "update_EOrdenCM"

				eoidorden="#form.EOidorden#"
				eonumero="#form.EOnumero#"
				ecodigo="#Arguments.Ecodigo#"
				sncodigo="#form.SNcodigo#"
				cmcid="#vnCMCid#"
				mcodigo="#form.Mcodigo#"
				rcodigo="#form.Rcodigo#"
				cmtocodigo="#form.CMTOcodigo#"
				eofecha="#form.EOfecha#"
				observaciones="#form.Observaciones#"
				eotc="#form.EOtc#"
				impuesto="0.00"
				eodesc="0.00"
				eototal="0.00"
				eoplazo="#form.EOplazo#"
				eohabiles="#form.EOhabiles#"
				eoporcanticipo="#form.EOporcanticipo#"
				CMFPid="#form.CMFPid#"
				CMIid="#Iif(Len(Trim(form.CMIid)), DE(form.CMIid), DE('-1'))#"
				EOdiasEntrega="#Iif(Len(Trim(form.EOdiasEntrega)), DE(form.EOdiasEntrega), DE('0'))#"
				EOtipotransporte="#form.EOtipotransporte#"
				EOlugarentrega="#form.EOlugarentrega#"
				CRid="#Iif(Len(Trim(form.CRid)), DE(form.CRid), DE('-1'))#"
				Ieps="0.00"
	/>
</cffunction>

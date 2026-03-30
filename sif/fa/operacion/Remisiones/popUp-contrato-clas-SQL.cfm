<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<!--- <cf_dump var="#form#"> --->
<cfset request.error.backs = 1>
<cfset params = "">
<!--- <cfdump var="#url#">
<cf_dump var="#form#"> --->
<cfif isdefined ('url.Icodigo') and len(trim(#url.Icodigo#))>
	<cfset Icodigo =#url.Icodigo#>
</cfif>


<cfif isdefined ('Form.Regresar')>
	<cflocation url="popUp-contrato.cfm?EOidorden=#Form.EOidorden#">

<cfelseif isdefined("Form.Alta")>
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

	<cfquery name="rsSQL" datasource="#session.dsn#">
           select d.CTDCmontoTotal,
			isnull(d.CTDCmontoTotal,0) - isnull(d.CTDCmontoConsumido,0) as SaldoTotal
           from CTContrato e
               inner join CTDetContrato d
                   on d.CTContid = e.CTContid
               left join Conceptos c
                   on c.Cid=d.Cid
			left join ACategoria ca on
				ca.ACcodigo = d.ACcodigo
			left join AClasificacion cl
				on cl.ACid = d.ACid
           where e.Ecodigo=#session.Ecodigo#
           and d.CTDCont in (#form.Contid#)
    </cfquery>
	<cfset LvarMontoTotal = fnRedondear(rsSQL.CTDCmontoTotal)>
    <cfset LvarSaldoTotal = fnRedondear(rsSQL.SaldoTotal)>

	<cfset vbHayContrato = false <!--- VerificaContrato(form.SNcodigo, form.Aid, form.Cid, form.ACid, form.EOfecha, form.Ucodigo, lvarFiltroEcodigo) --->>

	<cfif not vbHayContrato>
	<cfset LvarCPDDid 	= form.Contid>
		<cfinvoke component="sif.Componentes.FAP_AplicaPedidos" method="insert_DOrdenCM">
        	<cfinvokeargument name="eoidorden" 			value="#form.EOidorden#">
			<cfinvokeargument name="CTDContid" 			value="#LvarCPDDid#">
            <cfinvokeargument name="eonumero" 			value="#form.EOnumero#">
            <cfinvokeargument name="ecodigo" 			value="#lvarFiltroEcodigo#">
            <cfinvokeargument name="cmtipo" 			value="#form.CMtipo#">
            <cfinvokeargument name="cid" 				value="#form.Cid#">
			<cfinvokeargument name="dodescripcion" 		value="#Mid(form.DOdescripcion,1,255)#">
			<cfinvokeargument name="docantidad" 		value="#form.DOcantidad#">
			<cfinvokeargument name="dopreciou" 			value="#LvarOBJ_PrecioU.enCF(form.DOpreciou)#">
			<cfinvokeargument name="dofechaes" 			value="#form.DOfechaes#">
            <cfinvokeargument name="cfid" 				value="#form.CFid#">
            <cfinvokeargument name="icodigo" 			value="#form.Icodigo#">
            <cfinvokeargument name="ucodigo" 			value="#form.Ucodigo#">
            <cfinvokeargument name="dofechareq" 		value="#form.DOfechareq#">
            <cfinvokeargument name="aid" 				value="#form.Aid#">
            <cfinvokeargument name="alm_aid" 			value="#form.Almacen#">
            <cfinvokeargument name="accodigo" 			value="#form.ACcodigo#">
            <cfinvokeargument name="acid" 				value="#form.ACid#">
            <cfinvokeargument name="dodescripcion" 		value="#Mid(form.DOdescripcion,1,255)#">
            <cfinvokeargument name="doobservaciones" 	value="#Mid(form.DOobservaciones,1,255)#">
            <cfinvokeargument name="doalterna" 			value="#Mid(form.DOalterna,1,1024)#">
            <cfinvokeargument name="dogarantia"	 		value="#form.DOgarantia#">
            <cfinvokeargument name="ppais" 				value="#form.Ppais#">
            <cfinvokeargument name="DOmontodesc" 		value="#form.DOmontodesc#">
            <cfinvokeargument name="DOporcdesc" 		value="#form.DOporcdesc#">

			<cfif isdefined("form.PlantillaDistribucion") and isdefined("form.CheckDistribucionHidden") and form.CheckDistribucionHidden eq 1>
				<cfinvokeargument name="PlantillaDistribucion" 	value="#form.PlantillaDistribucion#">
				<cfinvokeargument name="CheckDistribucionHidden" 	value="#form.CheckDistribucionHidden#">
			<!--- <cfelse>
				<cfinvokeargument name="PlantillaDistribucion" 	value="0">
				<cfinvokeargument name="CheckDistribucionHidden" 	value="0"> --->
			</cfif>
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
<cfelseif isdefined("form.Cambio")>
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
		<!--- <cfif lvarProvCorp>
            <cfquery name="rsEcodigo" datasource="#session.DSN#">
                select Ecodigo
                from EOrdenCM
                where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
            </cfquery>
            <cfset lvarFiltroEcodigo = rsEcodigo.Ecodigo>
        </cfif> --->
		<cfset vbHayContrato = false <!--- VerificaContrato(form.SNcodigo, form.Aid, form.Cid, form.ACid, form.EOfecha, form.Ucodigo, lvarFiltroEcodigo) --->>

		<cfif not vbHayContrato>
            <cfinvoke component="sif.Componentes.FAP_AplicaPedidos" method="update_DOrdenCM">
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

				<cfquery name="ObtenerESidsolicitud" datasource="#session.dsn#">
					select ESidsolicitud
	  				from DRemisionesFA
					where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
					and DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DOlinea#">
				</cfquery>
				<cfquery name="ObtenerDatos" datasource="#session.dsn#">
					select CPDCid
	  				from DRemisionesFA
					where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
					and DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DOlinea#">
				</cfquery>
			</cfinvoke>
		<cfelse>
				<cfquery name="rsActualizaFechaReq" datasource="#session.dsn#">
					update DRemisionesFA set DOfechaes = <cfif len(trim(form.DOfechaes)) ><cfqueryparam cfsqltype="cf_sql_timestamp"	value="#LSParseDateTime(form.DOfechaes)#"><cfelse>null</cfif>
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
<cfelseif isdefined("form.Baja")>

    <cfset lvarFiltroEcodigo = Session.Ecodigo>
    <!--- <cfif lvarProvCorp>
    	<cfquery name="rsEcodigo" datasource="#session.DSN#">
            select Ecodigo
            from EOrdenCM
            where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		</cfquery>
        <cfset lvarFiltroEcodigo = rsEcodigo.Ecodigo>
    </cfif> --->
	<cfinvoke component="sif.Componentes.FAP_AplicaPedidos" method="delete_DOrdenCM">
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
<cfelseif isdefined("form.Nuevo")>
	<cflocation url="popUp-contrato-clas.cfm?EOidorden=#form.EOidorden#&Contid=#form.Contid#">
<cfelse>
	<cflocation url="popUp-contrato-dist.cfm">
</cfif>

<!--- refresca opener --->
<cfoutput>
	<script language="JavaScript" type="text/javascript">
		if (window.opener.funcRefrescar) {window.opener.funcRefrescar()};
		window.location="popUp-contrato-clas.cfm?EOidorden=#form.EOidorden#&Contid=#form.Contid#";
    </script>
</cfoutput>

<cffunction name="fnRedondear" returntype="numeric">
	<cfargument name="Numero" type="numeric">
	<cfreturn round(Numero*100)/100>
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

<cffunction name="AddParam" returntype="string" output="no">
	<cfargument name="params" type="string" required="yes">
	<cfargument name="paramname" type="string" required="yes">
	<cfargument name="paramvalue" type="string" required="yes">
	<cfset separador = iif(len(trim(arguments.params)),DE('&'),DE('?'))>
	<cfset nuevoparam = arguments.paramname & '=' & arguments.paramvalue>
	<cfreturn arguments.params & separador & nuevoparam>
</cffunction>

<cffunction name="calculaMonto" access="private" output="no">
	<cfargument name="EOidorden" required="yes" type="numeric">
	<cfargument name="Ecodigo" required="no" type="numeric" default="#session.Ecodigo#">

	<cfinvoke 	component	= "sif.Componentes.FAP_AplicaPedidos"
				method		= "calculaTotalesEOrdenCM"

				ecodigo="#Arguments.Ecodigo#"
				eoidorden="#Arguments.EOidorden#"
	/>
</cffunction>
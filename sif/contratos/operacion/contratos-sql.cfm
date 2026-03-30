<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>

<cfset lvarProvCorp = false>


<cfif isdefined("form.chk") and len(trim(form.chk))>
  <cfset  form.Ecodigo_f = #trim(listGetAt(form.chk,2,'|'))#>
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

<cfif isdefined("form.CTCid") and len(trim(form.CTCid))>
	<cfset CTCid = #form.CTCid#>
<cfelseif isdefined("form.chk") and len(trim(form.chk))>
		<cfquery name="rsComprador" datasource="#session.DSN#">
        	select * from CTCompradores cm
			where cm.Usucodigo   = #Session.Usucodigo#
        </cfquery>

  <cfset   CTCid = #rsComprador.CTCid#>
</cfif>
<cfquery name="rsCompradores" datasource="#session.DSN#">
    	select CTCid,CTCnombre,CTCactivo,CTCarticulo,CTCservicio,CTCactivofijo,CTCobra,CTCmontomax from CTCompradores
        where Ecodigo=#session.Ecodigo#
        and Usucodigo = #session.Usucodigo#
        and CTCactivo = 1
</cfquery>

<cfif isdefined("form.chk") and len(trim(form.chk))>
  <cfset form.chk = listGetAt(form.chk,1,'|')>
</cfif>

<!---►►Agrega el Encabezado del Contrato◄◄--->
<cfif isdefined("form.Alta")>



	<cfquery name="rsNegocios" datasource="#session.DSN#">
    	select SNcodigo,SNid from SNegocios
        where Ecodigo=#session.Ecodigo#
        and SNcodigo = #form.SNcodigo#
	</cfquery>

    <cfquery name="rsMesAuxiliar" datasource="#session.DSN#">
        select Pvalor
        from Parametros
        where Ecodigo=#session.Ecodigo#
        and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="60">
	</cfquery>

    <cfquery name="rsPeriodoAuxiliar" datasource="#session.DSN#">
        select Pvalor
        from Parametros
        where Ecodigo=#session.Ecodigo#
        and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="50">
    </cfquery>

        <cfset Fecha = rsPeriodoAuxiliar.Pvalor*100 +rsMesAuxiliar.Pvalor>

    <cfquery name="rsPeriodoPresupuestal" datasource="#session.DSN#">
    	select CPPid from CPresupuestoPeriodo
        where CPPestado = 1
        and CPPanoMesDesde <= #Fecha#
        and CPPanoMesHasta >= #Fecha#
        and Ecodigo=#session.Ecodigo#
	</cfquery>

<cfif rsCompradores.recordcount EQ 1>


	<cftransaction>
		<cfquery datasource="#session.dsn#" name="insert">
				insert into CTContrato
						 (
								Ecodigo,
								CTCnumContrato,
								CTCdescripcion,
								CTTCid,
								CTFLid,
								CTPCid,
								CTCid,
								SNid,
                                CTfecha,
                                CTfechaFirma,
                                CTfechaIniVig,
                                CTfechaFinVig,
                                CTMcodigo,
                                CTtipoCambio,
                                CTmonto,
                                Ocodigo,
                                CTCestatus,
                                Usucodigo,
                                BMUsucodigo,
                                CPPid
						)
				values (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NumContrato#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TipoContrato#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FundamentoLegal#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcedimientoContratacion#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCompradores.CTCid#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNegocios.SNid#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_date" 	value="#LSDateFormat(Form.FechaContrato,'YYYY/MM/DD')#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_date" 	value="#LSDateFormat(Form.FechaFirma,'YYYY/MM/DD')#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_date" 	value="#LSDateFormat(Form.VigenciaInicio,'YYYY/MM/DD')#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_date" 	value="#LSDateFormat(Form.VigenciaFin,'YYYY/MM/DD')#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
                            <cfqueryparam cfsqltype="cf_sql_money" value="#form.TC#">,
                            <cfqueryparam cfsqltype="cf_sql_money" value="#form.Importe#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="0">,<!--- Cero sin Aplicar --->
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodoPresupuestal.CPPid#">
						)
		<cf_dbidentity1 datasource="#session.DSN#" name="insert">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="CTContid">

	</cftransaction>

<cflocation url="registroContratos.cfm?CTContid=#CTContid#">

<cfelse>
	<cfquery name="rsUsuarios" datasource="#session.DSN#">
    	select Usulogin from Usuario
        where  Usucodigo = #session.Usucodigo#
	</cfquery>

	<cfthrow message="El Usuario #rsUsuarios.Usulogin# No es comprador">
</cfif>

<cfelseif isdefined("form.CambioDet") and form.CambioDet EQ 'Modificar'>
  	<cfquery name="rsLineaModifica" datasource="#session.DSN#">
    	select b.CTtipoCambio,a.CTDCont,a.CTContid,a.CPCmes, a.CPCano from CTDetContrato a
        inner join CTContrato b
        	on a.CTContid = b.CTContid
        where  a.CTContid = #form.CTContid#
        and a.CTDCont = #form.CTDCont#
        and a.Ecodigo = #session.Ecodigo#
	</cfquery>

	<cfquery name="rsSQL" datasource="#session.dsn#">
            select sum(round(CPDDsaldo,2)) as SaldoTotal
            from CPDocumentoE e
                inner join CPDocumentoD d
                    on d.CPDEid = e.CPDEid
                inner join CTDetContrato cont
                	on d.CPDEid = cont.CPDEid
                left join Conceptos c
                    on c.Cid=d.Cid
				left join ACategoria ca on
					ca.ACcodigo = d.ACcodigo
				left join AClasificacion cl
					on cl.ACid = d.ACid
            where e.Ecodigo=#session.Ecodigo#
            and CTDCont = #rsLineaModifica.CTDCont#
            and  CTContid = #rsLineaModifica.CTContid#
            and d.CPCmes = #rsLineaModifica.CPCmes#
            and d.CPCano = #rsLineaModifica.CPCano#
     </cfquery>

    	<cfset LvarMontoTotal = #form.CTDCmontoTotal#>
        <cfset LvarSaldoTotal = #rsSQL.SaldoTotal#>

	<cfif LvarMontoTotal GT LvarSaldoTotal>
        	<cfthrow message="El Monto indicado a Utilizar (#numberformat(LvarMontoTotal,9.99)#)es mayor al Saldo de las Suficiencias seleccionadas (#numberformat(LvarSaldoTotal,9.99)#)">
	<cfelse>

        <cfquery name="rsModificaLinea" datasource="#session.DSN#">
            update CTDetContrato
            set CTDCmontoTotalOri = #form.CTDCmontoTotal#,
                CTDCmontoTotal = #form.CTDCmontoTotal# * #rsLineaModifica.CTtipoCambio#
             where CTContid = #rsLineaModifica.CTContid#
             and CTDCont = #rsLineaModifica.CTDCont#
        </cfquery>

        <cfset ActualizarEncabezado(#session.Ecodigo#)>

		<cflocation url="registroContratos.cfm?CTContid=#form.CTContid#">
</cfif>
<!---►►Modifica el Encabezado del Contrato◄◄--->
<cfelseif isdefined("form.Cambio")>

            <cfif isdefined("form.TC") and form.TC NEQ "">
            	<cfset TipoCambio = "#form.TC#" >
            <cfelseif isdefined("url.TC")and url.TC NEQ "">
            	<cfset TipoCambio = #url.TC#>
            <cfelseif  isdefined("form.TipoCambio") and  form.TipoCambio NEQ "">
				<cfset TipoCambio = #form.TipoCambio#>
             <cfelseif  isdefined("url.TipoCambio") and url.TipoCambio NEQ "" >
				<cfset TipoCambio = #url.TipoCambio# >
            </cfif>

    	<cfquery name="rsCambiaEncabezado" datasource="#session.DSN#">
            update CTContrato
            set CTTCid = #form.TipoContrato#,
            	CTfechaFirma = <cf_jdbcquery_param cfsqltype="cf_sql_date" 	value="#LSDateFormat(Form.FechaFirma,'YYYY/MM/DD')#">,
                CTfechaIniVig = <cf_jdbcquery_param cfsqltype="cf_sql_date" 	value="#LSDateFormat(Form.VigenciaInicio,'YYYY/MM/DD')#">,
                CTfechaFinVig = <cf_jdbcquery_param cfsqltype="cf_sql_date" 	value="#LSDateFormat(Form.VigenciaFin,'YYYY/MM/DD')#">,
                CTMcodigo	  = #form.Mcodigo#,
                CTtipoCambio  = #TipoCambio#,
                Ocodigo		  = #form.Ocodigo#,
                CTPCid		  = #form.ProcedimientoContratacion#,
                CTFLid		  = #form.FundamentoLegal#,
                CTCdescripcion= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion#">
            where CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTContid#">
            and Ecodigo = #session.Ecodigo#
		</cfquery>



    <cflocation url="registroContratos.cfm?CTContid=#form.CTContid#">

<!---►►Elimina todo el contrato◄◄--->
<cfelseif isdefined("form.Baja")>

        <cfquery name="rsEliminaDetalles" datasource="#session.DSN#">
        	delete from CTAnotaciones
            where CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTContid#">
            and Ecodigo = #session.Ecodigo#
        </cfquery>
		<cfquery name="rsEliminaAgrupaciones" datasource="#session.DSN#">
        	delete from CTDetContratoAgr
            where CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTContid#">
            and Ecodigo = #session.Ecodigo#
        </cfquery>
    	<cfquery name="rsEliminaDetalles" datasource="#session.DSN#">
        	delete from CTDetContrato
            where CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTContid#">
            and Ecodigo = #session.Ecodigo#
        </cfquery>
        <cfquery name="rsEliminaEncabezado" datasource="#Session.DSN#">
            delete from CTContrato
			where CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTContid#">
            and Ecodigo = #session.Ecodigo#
        </cfquery>
    <cflocation url="listaContratos.cfm">
<!---►►Eliminación detalles del Contrato◄◄--->
<cfelseif isdefined("form.BajaDet")>

    <cfset lvarFiltroEcodigo = Session.Ecodigo>
    <cfif lvarProvCorp>
    	<cfquery name="rsEcodigo" datasource="#session.DSN#">
            select Ecodigo
            from CTContrato
            where CTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTCid#">
		</cfquery>
        <cfset lvarFiltroEcodigo = rsEcodigo.Ecodigo>
    </cfif>
	<cfinvoke component="sif.Componentes.CT_AplicaCon" method="delete_LineaContrato">
        <cfinvokeargument name="CTContid" 		value="#form.CTContid#">
        <cfinvokeargument name="CTDCont" 		value="#form.CTDCont#">
        <cfinvokeargument name="ecodigo" 		value="#lvarFiltroEcodigo#">
	</cfinvoke>


		<cfset ActualizarEncabezado(lvarFiltroEcodigo)>
    <cflocation url="registroContratos.cfm?CTContid=#form.CTContid#">

<!---►►Nuevo detalles del contrato◄◄--->
<cfelseif isdefined("form.NuevoDet")>
	<cfset params = AddParam(params,'CTContid',form.CTContid)>
    <cfset params = AddParam(params,'Ecodigo_f',lvarFiltroEcodigo)>

<!---►►Aplicacion del contrato◄◄--->
<cfelseif isdefined("Form.btnAplicar")>
	<cfif isdefined("form.chk") and len(trim(form.chk))>
		<cfset form.CTContid = form.chk>
	</cfif>
	<cfif lvarProvCorp>
    	<cfquery name="rsEcodigo" datasource="#session.DSN#">
            select Ecodigo
            from CTContrato
            where CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTContid#">
		</cfquery>
        <cfset lvarFiltroEcodigo = rsEcodigo.Ecodigo>
    </cfif>


	<!--- Valida que el monto del contrato sea mayor a cero --->
	<cfquery name="dataMonto" datasource="#session.DSN#">
		select CTmonto
		from CTContrato
		where CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTContid#">
		  and Ecodigo   = #lvarFiltroEcodigo#
	</cfquery>

	<cfif dataMonto.CTmonto lte 0>
		<cf_errorCode	code = "50309" msg = "El monto del Contrato debe ser mayor a cero!">
	</cfif>

	<cfinvoke component="sif.Componentes.CT_AplicaCon" method ="fnAplicaContrato" returnvariable ="LvarNap">
    	<cfinvokeargument name="CTContid"  value="#form.CTContid#">
        <cfinvokeargument name="CTCid" 		value="#CTCid#">
        <cfinvokeargument name="Ecodigo" 	value="#lvarFiltroEcodigo#">
    </cfinvoke>


	<cfif LvarNAP GT 0>
		<cfquery datasource="#session.DSN#">
			update CTContrato
			set CTCestatus = 1
			where CTContid = #form.CTContid#
			  and Ecodigo   = #lvarFiltroEcodigo#
		</cfquery>
	</cfif>

    <cfset params = AddParam(params,'CTContid',form.CTContid)>
    <cfset params = AddParam(params,'Ecodigo_f',lvarFiltroEcodigo)>

</cfif>

<!---Regresa al Form--->
<cfif not isdefined("form.action")>
	<cfif not isdefined("form.btnAplicar") and not isdefined("form.Baja")>
		<cflocation url="registroContratos.cfm#params#">
	<cfelseif isdefined("form.btnAplicar") and LvarNAP GTE 0>
		<cflocation url="listaContratos.cfm?Imprimir=true&CTContid=#form.CTContid#&tipoImpresion=1">

	<cfelse>
		<cflocation url="listaContratos.cfm">
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


<cffunction name="ActualizarEncabezado" access="private" output="no">
	<cfargument name="Ecodigo" required="no" type="numeric">

	<cfquery name="rsContratos" datasource="#session.DSN#">
		select sum(CTDCmontoTotalOri) as TotalOrigen from CTDetContrato a
        where a.Ecodigo = #Session.Ecodigo#
        and a.CTContid = #form.CTContid#
	</cfquery>
    <cfif rsContratos.TotalOrigen EQ "">
    	<cfset TotalOrigen = 0.00>
    <cfelse>
    	<cfset TotalOrigen = #rsContratos.TotalOrigen#>
    </cfif>

    <cfif not isdefined('Arguments.Ecodigo')>
    	<cfset Arguments.Ecodigo = Session.Ecodigo>
	</cfif>
	<cfinvoke 	component="sif.Componentes.CT_AplicaCon"
				method			= "update_CTContrato"

				CTContid="#form.CTContid#"
				CTCnumContrato="#form.NumContrato#"
				Ecodigo="#Arguments.Ecodigo#"
				CTmonto="#TotalOrigen#"

	/>

</cffunction>

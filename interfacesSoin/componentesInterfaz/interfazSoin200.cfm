<!---
1 Inclusion de vale 
2 traslados 
3 Retiros--->

<cfsetting requesttimeout="3600">
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<cftransaction isolation="read_uncommitted">
	<cfquery name="rsDatos" datasource="sifinterfaces">
		select  ID, Ecodigo, Placa, TipoTransaccion, Descripcion, DescDetallada, Tipo, Modelo, DescDetallada, Clase, Serie, Fecha, TipoDocumento, Empleado,   
				Lote, CentroFuncional, Categoria, TipoCompra, Documento, Marca, CentroCustodia, Monto,
				CASE TipoTransaccion WHEN 1 THEN 'INCLUSIÓN VALE' WHEN 2 THEN 'TRASLADO' WHEN 3 THEN 'RETIRO' ELSE 'TRANSACCIÓN' END AS labelTrans  
		from IE200 
		where ID = #GvarID#
	</cfquery>
</cftransaction>
<cfif rsDatos.recordCount eq 0>
	<cfthrow message="Error en Interfaz 200. No existen datos de Entrada para el ID ='#GvarID#'. Proceso Cancelado!.">
</cfif>
	
<!---Validaciones de traslados y Retiros--->
<cfif listfind('2,3',rsDatos.TipoTransaccion)>
	<cftry>
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_ExisteAF" Aplaca="#rsDatos.Placa#" Ecodigo="#session.Ecodigo#" returnvariable="Aid"/>
		<cfcatch type="any">
			<cfset RegistrarError('ERROR EN #rsDatos.labelTrans#: #cfcatch.message# #cfcatch.detail#')>
			<cfset verificarErrores()>
		</cfcatch>
	</cftry>
	<cftry>
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Documentos" Aid="#Aid#" Ecodigo="#session.Ecodigo#" returnvariable="AFRid"/> 	
	<cfcatch type="any">
			<cfset RegistrarError('ERROR EN #rsDatos.labelTrans#: #cfcatch.message# #cfcatch.detail#')>
			<cfset verificarErrores()>
		</cfcatch>
	</cftry>
</cfif>
<!---==============Registro de Documentos de responsablilidad del Activos Fijos=========================--->
<cfif rsDatos.TipoTransaccion eq 1>
	<cfif NOT LEN(TRIM(rsDatos.Monto))>
		<cfset RegistrarError('ERROR EN #rsDatos.labelTrans#: El monto de Adquisición del Activo es requerido')>
		<cfset verificarErrores()>
	</cfif>
	<cftry>
		<cftransaction>
			<cfinvoke component="sif.Componentes.AF_DocumentoResponsable" method="AltaDocTransito">
					<cfinvokeargument name="Conexion" 			value="#Session.Dsn#">
					<cfinvokeargument name="Ecodigo"  			value="#Session.Ecodigo#">
					<cfinvokeargument name="Usucodigo"  		value="#Session.Usucodigo#">
					<cfinvokeargument name="CRDRfalta"  		value="#Now()#">
					<cfinvokeargument name="CRDRestado"  		value="10">
					<cfinvokeargument name="CRDRutilaux"  		value="1">
					<cfinvokeargument name="CRTDcodigo"  		value="#rsDatos.TipoDocumento#">
					<cfinvokeargument name="DEidentificacion"	value="#rsDatos.Empleado#">
					<cfinvokeargument name="Categoria"  		value="#rsDatos.Categoria#">
					<cfinvokeargument name="Clase"  			value="#rsDatos.Clase#">
					<cfinvokeargument name="AFMcodigo"  		value="#rsDatos.Marca#">
					<cfinvokeargument name="AFMMcodigo"  		value="#rsDatos.Modelo#">
					<cfinvokeargument name="CFcodigo"  			value="#rsDatos.CentroFuncional#">
					<cfinvokeargument name="CRDRplaca"  		value="#rsDatos.Placa#">
					<cfinvokeargument name="CRCCcodigo"  		value="#rsDatos.CentroCustodia#">
					<cfinvokeargument name="AFCcodigoclas"  	value="#rsDatos.Tipo#">
					<cfinvokeargument name="CRDRdescripcion"  	value="#rsDatos.Descripcion#">
					<cfinvokeargument name="CRDRdescdetallada"	value="#rsDatos.DescDetallada#">
					<cfinvokeargument name="CRDRserie"  		value="#rsDatos.Serie#">
					<cfinvokeargument name="Monto"  			value="#rsDatos.Monto#">
					<cfinvokeargument name="CRTCcodigo"  		value="#rsDatos.TipoCompra#">
					<cfinvokeargument name="CRDRdocori"  		value="#rsDatos.Documento#">
					
				<cfif LEN(TRIM(rsDatos.fecha))>
					<cfinvokeargument name="CRDRfdocumento"  	value="#rsDatos.fecha#">
				</cfif>
			</cfinvoke>	
		</cftransaction>
		<cfcatch type="any">
			<cftransaction action="rollback">
			<cfset RegistrarError('ERROR EN #rsDatos.labelTrans#: #cfcatch.message# #cfcatch.detail#')>
			<cfset verificarErrores()>
		</cfcatch>
	</cftry>			
<!---==============Traslado de reponsable del Activos Fijos=========================--->
<cfelseif rsDatos.TipoTransaccion eq 2>
	<cfif NOT LEN(TRIM(rsDatos.Empleado))>
		<cfset RegistrarError('ERROR EN #rsDatos.labelTrans#: Se debe indicar el nuevo Empleado')>
		<cfset verificarErrores()>
	</cfif>
	<cftry>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Empleado"  DEidentificacion="#rsDatos.Empleado#" returnvariable="rsEmpleado"/> 
	<cfcatch type="any">
			<cfset RegistrarError('ERROR EN #rsDatos.labelTrans#: #cfcatch.message# #cfcatch.detail#')>
			<cfset verificarErrores()>
		</cfcatch>
	</cftry>
	<cftry>
		<cfif LEN(TRIM(rsDatos.CentroCustodia))>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_CentroCustodia"  CRCCcodigo="#rsDatos.CentroCustodia#" returnvariable="rsCentroC"/> 
		</cfif>
	<cfcatch type="any">
			<cfset RegistrarError('ERROR EN #rsDatos.labelTrans#: #cfcatch.message# #cfcatch.detail#')>
			<cfset verificarErrores()>
		</cfcatch>
	</cftry>
    <cftry>
		<cfif LEN(TRIM(rsDatos.TipoDocumento))>
			<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_TipoDocumento"  CRTDcodigo="#rsDatos.TipoDocumento#" returnvariable="rsTipoDoc"/> 
		</cfif>
	<cfcatch type="any">
			<cfset RegistrarError('ERROR EN #rsDatos.labelTrans#: #cfcatch.message# #cfcatch.detail#')>
			<cfset verificarErrores()>
		</cfcatch>
	</cftry>
	<cftry>
		<!---<cftransaction>--->
			<cfinvoke component="sif.Componentes.AF_CambioResponsable" method="Transferir" returnvariable="AFRTid">												
					<cfinvokeargument name="AFRid" 				value="#AFRid#">
				<cfif LEN(TRIM(rsDatos.Empleado))>	
					<cfinvokeargument name="DEid" 				value="#rsEmpleado.DEid#">
				</cfif>
				<cfif LEN(TRIM(rsDatos.CentroCustodia))>	
					<cfinvokeargument name="CRCCid" 			value="#rsCentroC.CRCCid#">
				</cfif>
                <cfif LEN(TRIM(rsDatos.TipoDocumento))>	
					<cfinvokeargument name="CRTDid" 			value="#rsTipoDoc.CRTDid#">
				</cfif>
				<cfif len(trim(rsDatos.fecha))>
					<cfinvokeargument name="Fecha" 				value="#rsDatos.fecha#">
				</cfif>
                	<!---a peticion de corrales
					El usuario que se va a utilizar en la interface entre SIME y Control de responsables es el del señor :
         					Nombre    :	Ronald Gerardo Sánchez Vargas
                            Usuario   : rosanc
                            Usucodigo : 1358
					--->
					<cfinvokeargument name="Usucodigo" 			value="1358">
					<cfinvokeargument name="TransaccionActiva" 	value="false">
			</cfinvoke>
			<cfinvoke component="sif.Componentes.AF_CambioResponsable" method="Procesar">
				<cfinvokeargument name="AFTRid" 			value="#AFRTid#">
				<cfinvokeargument name="AprobarTrasCenCust"	value="true">
                <!---a peticion de corrales
					El usuario que se va a utilizar en la interface entre SIME y Control de responsables es el del señor :
         					Nombre    :	Ronald Gerardo Sánchez Vargas
                            Usuario   : rosanc
                            Usucodigo : 1358
					--->
                <cfinvokeargument name="Usucodigo" 			value="1358">    
			</cfinvoke>	
		<!---</cftransaction>--->
	<cfcatch type="any">
		
			<cfset RegistrarError('ERROR EN #rsDatos.labelTrans#: #cfcatch.message# #cfcatch.detail#')>
			<cfset verificarErrores()>
		</cfcatch>
	</cftry>			
<!---==============Retiro de Activos Fijos=========================--->
<cfelseif rsDatos.TipoTransaccion eq 3>	
	<cftry>
		<cftransaction>
			<cfinvoke component="sif.Componentes.AF_RetiroActivos" method="AltaRelacion" returnvariable="AGTPid">
				<cfinvokeargument name="AGTPdescripcion" 	value="#rsDatos.Descripcion#">
				<cfinvokeargument name="AGTPrazon" 			value="#rsDatos.DescDetallada#">
				<cfinvokeargument name="RetiroCR" 			value="true">		
				<cfinvokeargument name="TransaccionActiva" 	value="true">	
			</cfinvoke>
			<cfinvoke component="sif.Componentes.AF_RetiroActivos" method="AltaActivo" returnvariable="rsResultadosRE">
				<cfinvokeargument name="AGTPid" 			value="#AGTPid#">
				<cfinvokeargument name="ADTPrazon" 			value="#rsDatos.DescDetallada#">
				<cfinvokeargument name="Aid" 				value="#Aid#">
				<cfinvokeargument name="TransaccionActiva"  value="true">
			</cfinvoke>
			<cfinvoke component="sif.Componentes.AF_ContabilizarRetiro" method="AF_ContabilizarRetiro" returnvariable="rsResultadosRT">
				<cfinvokeargument name="AGTPid" 			value="#AGTPid#">
				<cfinvokeargument name="debug" 				value="false">
				<cfinvokeargument name="TransaccionActiva" 	value="true">
			</cfinvoke>
	</cftransaction>
	<cfcatch type="any">
			<cftransaction action="rollback">
			<cfset RegistrarError('ERROR EN #rsDatos.labelTrans#: #cfcatch.message# #cfcatch.detail#')>
			<cfset verificarErrores()>
		</cfcatch>
	</cftry>
</cfif>	
<cffunction access="private" output="false" name="RegistrarError">
	<cfargument name="mensaje"   type="string" required="yes">
	<cfquery datasource="sifinterfaces">
		insert into ERR200(ID, placa, tipoTrans, mensaje) 
		values(
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.ID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Placa#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.TipoTransaccion#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.mensaje#">
		)
	</cfquery>
</cffunction>
<cffunction access="private" output="true" name="verificarErrores">
	
	<cfquery datasource="sifinterfaces" name="ERR">
		select mensaje from  ERR200 where ID = #rsDatos.ID#
	</cfquery>
	<cfif ERR.RecordCount EQ 1>
		<cfthrow message="#ERR.mensaje#">
	<cfelseif ERR.RecordCount GT 0>
		<cfthrow message="La transaccion Presento #ERR.cantidad# Error(es)">
	</cfif>
</cffunction>
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
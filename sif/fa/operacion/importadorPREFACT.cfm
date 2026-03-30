<!-- Querys AFGM-SPR CONTROL DE VERSIONES-->
        <cfquery name="rsPCodigoOBJImp" datasource = "#Session.DSN#">
        	select Pvalor from Parametros where Pcodigo = '17200' and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>

        <cfset value = "#rsPCodigoOBJImp.Pvalor#">
<!-- Fin Querys AFGM-SPR -->
<cfoutput>
<cftransaction isolation="read_uncommitted">
	<!--- Lee encabezado y detalles por procesar. --->
 	        <cfquery name="readPrefact" datasource="#session.DSN#">
	        	select 
                        IDPrefact as ID, 
                	#Session.Ecodigo# as Ecodigo, 
                        NumeroSocio, 
                        CodigoTransaccion,
                        Documento, 
                        CodigoMoneda, 
                        FechaTipoCambio, 
                        TipoCambio, 
                        <!---Descuento,---> 
                        Vendedor, 
                        FechaDocumento,
                        DiasVigencia, 
                        FechaVencimiento, 
                        CodigoOficina, 
                        CodigoDireccionFacturacion, 
                        NumeroOrdenCompra, 
                        Observaciones, 
                        'E' as Origen,
                        Consecutivo, 
                        TipoItem, 
                        CodigoItem, 
                        PrecioUnitario, 
                        CantidadTotal, 
                        CodigoImpuesto, 
                        ImporteDescuento, 
                        CodigoAlmacen,
                        CentroFuncional, 
                        CuentaFinancieraDet, 
                        PrecioTotal=0, 
                        Descripcion, 
                        Descripcion_Alt,
                        #session.usucodigo# as BMUsucodigo,
                        Ordendeservicio
                        <cfif value eq '4.0'>
                                ,ObjImpuesto
                                ,Exportacion
                        </cfif>
	        	from #table_name#
	        </cfquery> 


    	
        <!--- Valida que vengan datos --->
        <cfif readPrefact.recordcount eq 0>
                <cfthrow message="Error en Interfaz 22. No existen datos de Entrada para el ID='' o no tiene detalles definidos. Proceso Cancelado!.">
        </cfif>
</cftransaction>
<cfset existen="">
<cfquery name="existentes" datasource="#session.dsn#">
        select distinct Documento, CodigoTransaccion from #table_name#
</cfquery>
<cfloop query="existentes">
        <cfquery name="valida" datasource="#session.dsn#">
                select * from FAPreFacturaE where Ecodigo = #Session.ecodigo# and PFTcodigo = '#existentes.CodigoTransaccion#' and PFDocumento = '#existentes.Documento#'
        </cfquery>
        <cfif valida.recordCount GT 0>
                <cfset existen=ListAppend(existen," #valida.PFDocumento#")>
        </cfif>
</cfloop>
<cfif len(trim(existen)) GT 1>
<cfthrow message="Error en Importador de Prefacturas. Los Documentos:' <strong>#existen#</strong> ' ya existe en el sistema.">
<cfelse>
        <cfif value eq '4.0'>
                <cfinvoke component="interfacesLDCOM.InterfazXX.PREFACT_InterfazDocumentos40" method="process" returnvariable="MSG" query="#readPrefact#" ModuloOrigen="Importador de Prefacturas"/>
        <cfelse>
                <cfinvoke component="interfacesLDCOM.InterfazXX.PREFACT_InterfazDocumentos" method="process" returnvariable="MSG" query="#readPrefact#" ModuloOrigen="Importador de Prefacturas"/>
        </cfif>
        
</cfif>
</cfoutput>
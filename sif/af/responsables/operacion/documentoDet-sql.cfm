<CF_NAVEGACION NAME="Asociar" DEFAULT="0">
<!--- <cf_dump var="#form#"> --->
<!---►►►Registro de un NUEVO Documentos de Responsabilidad◄◄--->
<cfif isdefined("form.BTNDOCUMENTOS") >
	<cfparam name="Form.DOlineas" 	   default="">
    <cfparam name="Form.DDlineas" 	   default="">
    <cfparam name="LvarCRDRfdocumento" default="#Now()#">
    
    <cfquery name="rsInfoDocOC" datasource="#session.DSN#">
           select 
            getdate() as fechaH,
            dcp.DDcantidad,
            dcp.DDpreciou,
            dcp.CFid,
            doc.ACcodigo,
            doc.ACid,
            dcp.DOlinea,
            doc.DOdescripcion,
            doc.EOidorden,
            (select top 1 CRCCid  from
            CRCentroCustodia) as CRCCid,
            (select top 1 cc.DEid
                    from CRCentroCustodia cc
                    inner join DatosEmpleado de
                    on de.DEid = cc.DEid) as DEid,
            (select top 1 CRTDcodigo from CRTipoDocumento) as CRTDcodigo

            from DDocumentosCxP dcp
            inner join DOrdenCM doc
            on doc.Ecodigo =dcp.Ecodigo
            and doc.DOlinea = dcp.DOlinea
            where dcp.IDdocumento=#Form.IDdocumento#
            and dcp.Ecodigo = #session.Ecodigo#
        </cfquery>

        <cfquery name="rsAFClas" datasource="#session.DSN#">
            select top 1 * from  AFClasificaciones
        </cfquery>

	<cftransaction>
        <cfloop query="rsInfoDocOC">
        <cfloop index="i" from="1" to="#rsInfoDocOC.DDcantidad#" >
            <cfquery name="rs_insert" datasource="#session.DSN#">
            insert into CRDocumentoResponsabilidad 
                    (   
                        Ecodigo, 
                        CRTDid, 
                        DEid, 
                        CFid, 
                        ACcodigo, 
                        ACid, 
                        CRCCid, 
                        CRDRdescripcion, 
                        CRDRdescdetallada, 
                        CRDRfdocumento, 
                        CRTCid, 
                        AFCcodigo, 
                        CRDRfalta, 
                        BMUsucodigo, 
                        CRDRestado,
                        Monto, 
                        CRDRutilaux,
                        CRDRdocori,
                        DOlineas,
                        AFCMejora,
                        EOidorden,
                        CRDR_TipoReg        
                    )
                values 
                (
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#session.Ecodigo#">,            <!---Empresa--->
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="1">,       <!---Tipo de Documento--->
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsInfoDocOC.DEid#">,              <!---Empleado--->
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsInfoDocOC.CFid#">,            <!---Centro Funcional--->
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#rsInfoDocOC.ACcodigo#">,         <!---Categoria--->
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#rsInfoDocOC.ACid#">,                 <!---Clase--->
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsInfoDocOC.CRCCid#">,             <!---Centro de Custodia--->
                <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#rsInfoDocOC.DOdescripcion#">,    <!---Descripcion--->
                <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#rsInfoDocOC.DOdescripcion#">,  <!---Descripcion detallada--->
                <cf_jdbcquery_param cfsqltype="cf_sql_timestamp"    value="#rsInfoDocOC.fechaH#">,     <!---Fecha del Documento--->
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="1">,             <!---Tipo de Compra--->
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#rsAFClas.AFCcodigo#">,           <!---Clasificacion(Tipo)--->
                <cf_jdbcquery_param cfsqltype="cf_sql_timestamp"    value="#rsInfoDocOC.fechaH#">,          <!---Fecha de Alta del Registro--->    
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#session.Usucodigo#">,          <!---Usucodigo para Log del Portal--->
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="0">,         <!---Estado--->
                <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#rsInfoDocOC.DDpreciou#">,              <!---Monto de Adquisicion--->
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="0">,        <!---Proveniente de un Sistema Auxiliar--->
                <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#form.EDdocumento#">,         <!---Documento que Origino la Adquisicion(CXP)--->
                <cf_jdbcquery_param cfsqltype="cf_sql_varchar"    value="#rsInfoDocOC.DOlinea#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_bit"        value="0">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsInfoDocOC.EOidorden#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">
                )
                <cf_dbidentity1 datasource="#session.DSN#" name="rs_insert">
        </cfquery>
        </cfloop><!--- Cantidad Pieza --->
    </cfloop><!--- Lineas Factura --->
    </cftransaction>

    <cfset params = 'CRDRdocori='&form.EDdocumento>
   <cflocation url="documentoDet.cfm?#params#">
<!---►►►Registro de un NUEVO Documentos de Responsabilidad◄◄--->
<cfelseif isdefined("form.cambio") >

    <cfquery name="rs_info" datasource="#session.DSN#">
            select              
                    CRDRid,
                    Ecodigo, 
                    CRTDid, 
                    DEid, 
                    CFid, 
                    ACcodigo, 
                    ACid, 
                    CRCCid, 
                    CRDRdescripcion, 
                    CRDRdescdetallada, 
                    CRDRfdocumento, 
                    CRTCid, 
                    AFCcodigo, 
                    CRDRfalta, 
                    BMUsucodigo, 
                    CRDRestado,
                    Monto, 
                    CRDRutilaux,
                    CRDRdocori,
                    DOlineas,
                    AFCMejora,
                    EOidorden,
                    CRorigen,
                    CRDRtipodocori,
                    CRDR_TipoReg
            from CRDocumentoResponsabilidad a 
            where a.CRDRdocori =<cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#form.EDdocumento#">
            and a.CRDRestado = 0  
            and a.CRDR_TipoReg =<cf_jdbcquery_param cfsqltype="cf_sql_numeric"     value="#form.IDDOCUMENTO#"> 
    </cfquery>
<!--- <cf_dump var="#form#"> --->

    <cfloop query="rs_info">

        <cfset formCRDRid = 'CRDRid'&'#rs_info.CRDRid#'>
        <cfif StructKeyExists(form, formCRDRid)><!--- revisa si existe el  CRDRid en el form evita hacer loop de mas--->
            
        <cfset formDEid = 'DEid'&'#rs_info.CRDRid#'>
        <cfset formAFMid = 'AFMid'&'#rs_info.CRDRid#'>
        <cfset formAFMMid = 'AFMMid'&'#rs_info.CRDRid#'>
        <cfset formCRDRserie = 'CRDRserie'&'#rs_info.CRDRid#'>
        <cfset stDEid = 0>
        <cfset stAFMid = 0>
        <cfset stAFMMid = 0>
        <cfset stCRDRserie = ''>

        <cfif StructKeyExists(form, formDEid)>
            <cfset stDEid = StructFind(form, formDEid)>
        </cfif>
        <cfif StructKeyExists(form, formAFMid)>
            <cfset stAFMid = StructFind(form, formAFMid)>
        </cfif>
        <cfif StructKeyExists(form, formAFMMid)>
            <cfset stAFMMid = StructFind(form, formAFMMid)>
        </cfif>
        <cfif StructKeyExists(form, formCRDRserie)>
            <cfset stCRDRserie = StructFind(form, formCRDRserie)>
        </cfif>


        <cfset formEOidorden = 'EOidorden'&'#rs_info.CRDRid#'>
        <cfset stEOidorden = 0>
        <cfif StructKeyExists(form, formEOidorden)>
            <cfset stEOidorden = StructFind(form, formEOidorden)>
        </cfif>
        <cfset formDDlineas = 'DDlineas'&'#rs_info.CRDRid#'>
        <cfset stDDlineas = 0>
        <cfif StructKeyExists(form, formDDlineas)>
            <cfset stDDlineas = StructFind(form, formDDlineas)>
        </cfif>
        <cfset formDOlineas = 'DOlineas'&'#rs_info.CRDRid#'>
        <cfset stDOlineas = 0>
        <cfif StructKeyExists(form, formDOlineas)>
            <cfset stDOlineas = StructFind(form, formDOlineas)>
        </cfif>


        <cfset formCRCCid = 'CRCCid'&'#rs_info.CRDRid#'>
        <cfset stCRCCid = 0>
        <cfif StructKeyExists(form, formCRCCid)>
            <cfset stCRCCid = StructFind(form, formCRCCid)>
        </cfif>

        <cfset formCRDRid = 'CRDRid'&'#rs_info.CRDRid#'>
        <cfset stCRDRid = 0>
        <cfif StructKeyExists(form, formCRDRid)>
            <cfset stCRDRid = StructFind(form, formCRDRid)>
        </cfif>

        <cfset formACcodigo = 'ACcodigo'&'#rs_info.CRDRid#'>
        <cfset stACcodigo = 0>
        <cfif StructKeyExists(form, formACcodigo)>
            <cfset stACcodigo = StructFind(form, formACcodigo)>
        </cfif>

        <cfset formACid = 'ACid'&'#rs_info.CRDRid#'>
        <cfset stACid = 0>
        <cfif StructKeyExists(form, formACid)>
            <cfset stACid = StructFind(form, formACid)>
        </cfif>

        <cfset formCRDRdescripcion = 'CRDRdescripcion'&'#rs_info.CRDRid#'>
        <cfset stCRDRdescripcion = 0>
        <cfif StructKeyExists(form, formCRDRdescripcion)>
            <cfset stCRDRdescripcion = StructFind(form, formCRDRdescripcion)>
        </cfif>

        <cfset formCRDRdescdetallada = 'CRDRdescdetallada'&'#rs_info.CRDRid#'>
        <cfset stCRDRdescdetallada = 0>
        <cfif StructKeyExists(form, formCRDRdescdetallada)>
            <cfset stCRDRdescdetallada = StructFind(form, formCRDRdescdetallada)>
        </cfif>

        <cfset formAFCcodigo = 'AFCcodigo'&'#rs_info.CRDRid#'>
        <cfset stAFCcodigo = 0>
        <cfif StructKeyExists(form, formAFCcodigo)>
            <cfset stAFCcodigo = StructFind(form, formAFCcodigo)>
        </cfif>

        <cfset formCRTDid = 'CRTDid'&'#rs_info.CRDRid#'>
        <cfset stCRTDid = 0>
        <cfif StructKeyExists(form, formCRTDid)>
            <cfset stCRTDid = StructFind(form, formCRTDid)>
        </cfif>

        <cfset formCRTCid = 'CRTCid'&'#rs_info.CRDRid#'>
        <cfset stCRTCid = 0>
        <cfif StructKeyExists(form, formCRTCid)>
            <cfset stCRTCid = StructFind(form, formCRTCid)>
        </cfif>

<!--- <cfdump var="#stAFMMid#">
        <cf_dump var="#stAFMid#----#stAFMMid# --- #len("stAFMid")#"> --->

        <cfinvoke component="sif.Componentes.AF_DocumentoResponsable" method="CambioDocTransito">
            
            <cfinvokeargument name="Monto"             value="#Replace(rs_info.Monto,',','','all')#"> 
            <cfinvokeargument name="CROrigen"          value="#rs_info.CROrigen#">
            <cfinvokeargument name="AFCMejora"         value="#rs_info.AFCMejora#">
            <cfinvokeargument name="CRDRtipodocori"    value="#rs_info.CRDRtipodocori#">
            <cfinvokeargument name="CRDRfdocumento"    value="#rs_info.CRDRfdocumento#">
            <cfinvokeargument name="CFid"              value="#rs_info.CFid#">
            <cfinvokeargument name="CRDRdocori"        value="#form.EDdocumento#">

            <cfif stCRCCid gt 0 and stCRCCid NEQ ''>
                <cfinvokeargument name="CRCCid"             value="#stCRCCid#">
            </cfif>

            <cfif stCRDRid gt 0 and stCRDRid NEQ ''>
                <cfinvokeargument name="CRDRid"             value="#stCRDRid#">
            </cfif>

            <cfif stACcodigo gt 0 and stACcodigo NEQ ''>
                <cfinvokeargument name="ACcodigo"             value="#stACcodigo#">
            </cfif>

            <cfif stACid gt 0 and stACid NEQ ''>
                <cfinvokeargument name="ACid"             value="#stACid#">
            </cfif>

            <cfif stCRDRdescripcion gt 0 and stCRDRdescripcion NEQ ''>
                <cfinvokeargument name="CRDRdescripcion"             value="#stCRDRdescripcion#">
            </cfif>

            <cfif stCRDRdescdetallada gt 0 and stCRDRdescdetallada NEQ ''>
                <cfinvokeargument name="CRDRdescdetallada"             value="#stCRDRdescdetallada#">
            </cfif>

            <cfif stAFCcodigo gt 0 and stAFCcodigo NEQ ''>
                <cfinvokeargument name="AFCcodigo"             value="#stAFCcodigo#">
            </cfif>

            <cfif stCRTDid gt 0 and stCRTDid NEQ ''>
                <cfinvokeargument name="CRTDid"             value="#stCRTDid#">
            </cfif>

            <cfif stCRTCid gt 0 and stCRTCid NEQ ''>
                <cfinvokeargument name="CRTCid"             value="#stCRTCid#">
            </cfif>

            <cfinvokeargument name="DEid"              value="#stDEid#">
            <cfif stAFMid gt 0 and stAFMid NEQ ''>
                <cfinvokeargument name="AFMid"             value="#stAFMid#">
            </cfif>
            <cfif stAFMMid gt 0 and stAFMMid NEQ ''>
                <cfinvokeargument name="AFMMid"            value="#stAFMMid#">
            </cfif>
            <cfif stCRDRserie gt 0 and stCRDRserie NEQ ''>
                <cfinvokeargument name="CRDRserie"         value="#stCRDRserie#">
            </cfif>

            <cfinvokeargument name="EOidorden"         value="#stEOidorden#">
            <cfinvokeargument name="DDlineas"         value="#stDDlineas#">
            <cfinvokeargument name="DOlineas"         value="#stDOlineas#">
        </cfinvoke>
        </cfif><!--- fin CRDRid --->
    </cfloop>
    <cfset params = 'CRDRdocori='&form.EDdocumento>
    <cflocation url="documentoDet.cfm?#params#">

<cfelseif isdefined("form.baja")>
    <cfquery name="rs_info" datasource="#session.DSN#">
        select  CRDRid
        from CRDocumentoResponsabilidad a 
        where a.CRDRdocori =<cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#form.EDdocumento#">
        and a.CRDRestado = 0  
        and a.CRDR_TipoReg =<cf_jdbcquery_param cfsqltype="cf_sql_numeric"     value="#form.IDDOCUMENTO#"> 
    </cfquery>

    <cfloop query="rs_info">
    	<cfinvoke component="sif.Componentes.AF_DocumentoResponsable" method="BajaDocTransito">
    		<cfinvokeargument name="CRDRid" value="#rs_info.CRDRid#">
    	</cfinvoke>
    </cfloop>
</cfif>

<!---►►►Registro de un NUEVO Documentos de Responsabilidad◄◄--->
<cfif isdefined("form.aplicar") or isdefined("form.btnaplicar")>
	<cftransaction>
    	<!---SML. 27/02/2014. Parametro para la generación de mascara automatica---> 
		<cfquery name="rsMascaraAut" datasource="#session.DSN#">
			select Pvalor
			from Parametros 
			where Ecodigo = #session.Ecodigo#
		  		and Pcodigo = '200050'
		</cfquery>

         <cfquery name="rs_infoVal" datasource="#session.DSN#">
            select  count(1) as reg
            from CRDocumentoResponsabilidad a 
            where a.CRDRdocori =<cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#form.EDdocumento#">
            and a.CRDR_TipoReg =<cf_jdbcquery_param cfsqltype="cf_sql_numeric"     value="#form.IDDOCUMENTO#"> 
            and a.CRDRestado = 0 
            and (AFMid is null or AFMMid is null )
        </cfquery>


        <cfif isdefined("rs_infoVal") and rs_infoVal.reg gt 0>
            <cfinvoke component="sif.Componentes.Translate"
                method="Translate"
                Key="MSG_ProcesoCan1"
                Default="Existen detalles sin Marca o Modelo!"
                returnvariable="MSG_ProcesoCan1"/>
            <cfthrow message="#MSG_ProcesoCan1#">
        </cfif>

		
        <cfquery name="rs_info" datasource="#session.DSN#">
            select  CRDRid
            from CRDocumentoResponsabilidad a 
            where a.CRDRdocori =<cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#form.EDdocumento#">
            and a.CRDRestado = 0  
            and a.CRDR_TipoReg =<cf_jdbcquery_param cfsqltype="cf_sql_numeric"     value="#form.IDDOCUMENTO#"> 
        </cfquery>

		<cfif isdefined("rs_info") and rs_info.recordcount gt 0>
            <cfset lista = ValueList(rs_info.CRDRid)>
        <cfelseif isdefined("form.CRDRid")>
            <cfset lista = form.CRDRid>
        <cfelse>
            <cfinvoke component="sif.Componentes.Translate"
                method="Translate"
                Key="MSG_NoDeDocumentoNoPudoSerDeterminadoProcesoCancelado"
                Default="No. de Documento no pudo ser determinado. Proceso Cancelado!"
                returnvariable="MSG_NoDeDocumentoNoPudoSerDeterminadoProcesoCancelado"/>
            <cfthrow message="#MSG_NoDeDocumentoNoPudoSerDeterminadoProcesoCancelado#">
        </cfif>
        

        <cfloop list="#lista#" index="item">           
            <!--- Verifica si trae la placa, si no la trae da error. --->
            <cfquery name="rsCRDR" datasource="#session.dsn#">
                select CRDRplaca, CRDRdescripcion, coalesce(DDlineas,DOlineas) as  lineas
                from CRDocumentoResponsabilidad
                where CRDRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">
                and CRDRestado <> 10
            </cfquery>
            <cfif (len(rsCRDR.CRDRplaca) and len(trim(rsCRDR.lineas))) or (isdefined("rsMascaraAut.Pvalor") and rsMascaraAut.Pvalor EQ 1)>
                <!--- Se elimino validación de si la placa existe porque ahora si existe o no no importa en esta sección,
                quien toma en cuenta si la placa existe es la aplcación de la adquisición para hacer una adquisicion o 
                una mejora, tanto del Activo como del Documento. --->
                <cfquery name="rs_update" datasource="#session.dsn#">
                    update CRDocumentoResponsabilidad
                    set <!--- Estado--->
                        CRDRestado = 10,
                        <!--- Datos de Monitoreo Modificables --->
                        BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
                    where CRDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">
                </cfquery>
                <!---******* Aqui se hace el alta a la tabla de bitacoras ******--->
                <cfquery datasource="#session.dsn#" name="rsinsertabitacora">
                        insert into CRBitacoraTran(
                            Ecodigo, 
                            CRBfecha,
                            Usucodigo,
                            CRBmotivo,
                            CRBPlaca,  
                            CRDRid,         
                            BMUsucodigo)
                        values(
                            #Session.Ecodigo#,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                            6,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsCRDR.CRDRplaca)#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
                        )	
                </cfquery>				
            <cfelseif rsCRDR.recordcount eq 0>
                <cfinvoke component="sif.Componentes.Translate"
                    method="Translate"
                    Key="MSG_ErrorElDocumentoPorAplicarNoExisteProcesoCancelado"
                    Default="Error, el documento por aplicar no existe. Proceso Cancelado!"
                    returnvariable="MSG_ErrorElDocumentoPorAplicarNoExisteProcesoCancelado"/>
                    
                <cfthrow message="#MSG_ErrorElDocumentoPorAplicarNoExisteProcesoCancelado#">
            <cfelseif not len(trim(rsCRDR.lineas))>
                <cfinvoke component="sif.Componentes.Translate"
                    method="Translate"
                    Key="MSG_ErrorElDocumentoNoTieneLineaDetalleProcesoCancelado"
                    Default="Error, el documento por aplicar no tiene lineas de detalle. Proceso Cancelado!"
                    returnvariable="MSG_ErrorElDocumentoNoTieneLineaDetalleProcesoCancelado"/>
                    
                <cfthrow message="#MSG_ErrorElDocumentoNoTieneLineaDetalleProcesoCancelado#">
            <cfelseif isdefined("rsMascaraAut.Pvalor") and rsMascaraAut.Pvalor NEQ 1>
			<!---SML. 06/03/2014 Validacion para que no muestre el error de que falta la placa cuando esta se selecciona automaticamente--->
                    <cfinvoke component="sif.Componentes.Translate"
                    	method="Translate"
                    	Key="MSG_ErrorElDocumento"
                    	Default="Error, el documento"
                    	returnvariable="MSG_ErrorElDocumento"/>
                	<cfinvoke component="sif.Componentes.Translate"
                    	method="Translate"
                   	 	Key="MSG_NoTieneDefinidaUnaPlaca.ProcesoCancelado"
                    	Default="no tiene definida una placa. Proceso Cancelado!"
                    	returnvariable="MSG_NoTieneDefinidaUnaPlaca"/>
                    
                	<cf_errorCode	code = "50131"
                    	     msg  = "@errorDat_1@ @errorDat_2@ @errorDat_3@"
                             errorDat_1="#MSG_ErrorElDocumento#"
                             errorDat_2="#rsCRDR.CRDRdescripcion#"
                             errorDat_3="#MSG_NoTieneDefinidaUnaPlaca#">
           </cfif>
        </cfloop>
	</cftransaction>
    <cflocation url="documentoDet.cfm">
<cfelseif isdefined("form.btnEliminar")>
	<cfif isdefined("form.chk")>
		<cfloop list="#chk#" delimiters="," index="indchk">
			<cfinvoke component="sif.Componentes.AF_DocumentoResponsable" method="BajaDocTransito">
				<cfinvokeargument name="CRDRid" value="#indchk#">
			</cfinvoke>
		</cfloop>
	</cfif>
    <cflocation url="documentoDet.cfm">
</cfif>

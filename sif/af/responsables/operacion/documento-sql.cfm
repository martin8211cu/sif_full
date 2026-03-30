<CF_NAVEGACION NAME="Asociar" DEFAULT="0">

<!---►►►Registro de un NUEVO Documentos de Responsabilidad◄◄--->
<cfif isdefined("form.alta")>
	<cfparam name="Form.DOlineas" 	   default="">
    <cfparam name="Form.DDlineas" 	   default="">
    <cfparam name="LvarCRDRfdocumento" default="#Now()#">
    
	<cfif ISDEFINED('Form.CRDRfdocumento') AND LEN(TRIM(Form.CRDRfdocumento))>
    	<cfset LvarCRDRfdocumento = LSParseDateTime(Form.CRDRfdocumento)>
    </cfif>
	<cftransaction>
        <cfinvoke component="sif.Componentes.AF_DocumentoResponsable" method="AltaDocTransito" returnvariable="CRDRid">
                <cfinvokeargument name="CRDRfdocumento"    value="#LvarCRDRfdocumento#">
                <cfinvokeargument name="CRDRestado"        value="0">
                <cfinvokeargument name="CRTDcodigo" 	   value="#Form.CRTDcodigo#">
                <cfinvokeargument name="DEidentificacion"  value="#Form.DEidentificacion#">
                <cfinvokeargument name="Categoria" 		   value="#Form.ACcodigodesc#">
                <cfinvokeargument name="Clase" 			   value="#Form.Cat_ACcodigodesc#">
                <cfinvokeargument name="AFMcodigo" 		   value="#Form.AFMcodigo#">
                <cfinvokeargument name="AFMMcodigo" 	   value="#Form.AFMMcodigo#">
                <cfinvokeargument name="CFcodigo" 	       value="#Form.CFcodigo#">
                <cfif isdefined("chkMejora")>
                <cfinvokeargument name="CRDRplaca" 		   value="#Form.CRDRplacaA#">
                <cfelse>
                <cfinvokeargument name="CRDRplaca" 		   value="#Form.CRDRplaca#">
                </cfif>
                <cfinvokeargument name="CRCCid" 		   value="#Form.CRCCid#">
                <cfinvokeargument name="AFCcodigoclas" 	   value="#Form.AFCcodigoclas#">
                <cfinvokeargument name="CRDRdescripcion"   value="#Form.CRDRdescripcion#">
                <cfinvokeargument name="CRDRdescdetallada" value="#Form.CRDRdescdetallada#">
                <cfinvokeargument name="CRDRserie" 		   value="#Form.CRDRserie#">
                <cfinvokeargument name="Monto" 		   	   value="#Replace(Form.Monto,',','','all')#">
                <cfinvokeargument name="CRTCcodigo" 	   value="#Form.CRTCcodigo#">
                <CFIF Asociar EQ 1>
                	<cfinvokeargument name="CRDRdocori" 	   value="#Form.CRDRdocori#">
                    <cfinvokeargument name="DDlineas"    	   value="#Form.DDlineas#">
                <CFELSEIF Asociar EQ 2>
                	<cfinvokeargument name="CRDRdocori" 	   value="#Form.CRDRdocori2#">
                    <cfinvokeargument name="EOidorden"    	   value="#Form.EOidorden#">
                    <cfinvokeargument name="DOlineas"    	   value="#Form.DOlineas#">
                </CFIF>
                <cfinvokeargument name="CROrigen"    	   value="#Form.CROrigen#">
                <cfif isdefined("Form.AFCMejora") and len(trim(Form.AFCMejora))>
                	<cfinvokeargument name="AFCMejora"    	   value="#Form.AFCMejora#">
                </cfif>
                <cfif isdefined("Form.AFCMid") and len(trim(Form.AFCMid))>
                	<cfinvokeargument name="AFCMid"    	       value="#Form.AFCMid#">
                </cfif>
        </cfinvoke>
    </cftransaction>
    <cfset params = 'CRDRid='&CRDRid>
   <cflocation url="documento.cfm?#params#">
<!---►►►Registro de un NUEVO Documentos de Responsabilidad◄◄--->
<cfelseif isdefined("form.cambio") or isdefined("form.aplicar")>
	<!---<cf_dump var = "form">--->
	<cftransaction>
	<cfif ISDEFINED('Form.CRDRfdocumento') AND LEN(TRIM(Form.CRDRfdocumento))>
    	<cfset LvarCRDRfdocumento = LSParseDateTime(Form.CRDRfdocumento)>
    <cfelse>
    	<cfset LvarCRDRfdocumento = Now()>
    </cfif>
	
	<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Transito" ExcluirCRTDid="#Form.CRTDid#" CRDRid = "#Form.CRDRid#"/>
  	<!----Se agrego CRDRid = "#Form.CRDRid#" RVD 07/04/2014--->
    
	<cf_dbtimestamp
		table="CRDocumentoResponsabilidad" 
		redirect="documento.cfm"
		timestamp="#Form.ts_rversion#"
		field1="CRDRid,numeric,#Form.CRDRid#">
    <cfif isdefined("Form.DDlineas") and len(trim(Form.DDlineas))>
		<cfset sortedDDlineas = ListSort("#Form.DDlineas#","Numeric", "ASC")>
    <cfelseif isdefined("Form.DOlineas") and len(trim(Form.DOlineas))>
		<cfset sortedDOlineas = ListSort("#Form.DOlineas#","Numeric", "ASC")>
    </cfif>
    
	<cfinvoke component="sif.Componentes.AF_DocumentoResponsable" method="CambioDocTransito">
        <cfinvokeargument name="CRDRid"  		   value="#Form.CRDRid#">
        <cfinvokeargument name="CRTDid"  		   value="#Form.CRTDid#">
        <cfinvokeargument name="DEid"	           value="#Form.DEid#">
        <cfinvokeargument name="CFid"  		       value="#Form.CFid#">
        <cfinvokeargument name="ACcodigo"  	       value="#Form.ACcodigo#">
        <cfinvokeargument name="ACid"  	           value="#ACid#">
        <cfinvokeargument name="CRCCid"  	       value="#Form.CRCCid#">
        <cfinvokeargument name="AFMid"  	       value="#Form.AFMid#">
        <cfinvokeargument name="AFMMid"  	       value="#Form.AFMMid#">
        <cfinvokeargument name="CRDRdescripcion"   value="#Form.CRDRdescripcion#">
        <cfif isdefined("chkMejora")>
        <cfinvokeargument name="CRDRplaca" 		   value="#Form.CRDRplacaA#">
        <cfelseif isdefined ("#Form.CRDRplacaA#")>
        <cfinvokeargument name="CRDRplaca" 		   value="#Form.CRDRplaca#">
        </cfif>
        <cfinvokeargument name="CRDRdescdetallada" value="#Form.CRDRdescdetallada#">
        <cfinvokeargument name="CRDRserie"  	   value="#Form.CRDRserie#">
        <cfinvokeargument name="CRDRfdocumento"    value="#LvarCRDRfdocumento#">
        <cfinvokeargument name="CRTCid"  	       value="#Form.CRTCid#">
        <cfinvokeargument name="CRDRdocori"  	   value="#Form.CRDRdocori#">
        <cfinvokeargument name="Monto"  		   value="#Replace(Form.Monto,',','','all')#">  
        <cfif Asociar EQ 1>
        	<cfinvokeargument name="CRDRdocori"  	   value="#Form.CRDRdocori#">
            <cfinvokeargument name="CRDRtipodocori"    value="#Form.CRDRtipodocori#">
            <cfif isdefined("sortedDDlineas")>
            	<cfinvokeargument name="DDlineas"    	   value="#sortedDDlineas#">
            </cfif>
        <cfelseif Asociar EQ 2>
        	<cfinvokeargument name="CRDRdocori"  	   value="#Form.CRDRdocori2#">
            <cfinvokeargument name="EOidorden"    	   value="#Form.EOidorden#">
            <cfif isdefined("sortedDOlineas")>
            	<cfinvokeargument name="DOlineas"    	   value="#sortedDOlineas#">
            </cfif>
        </cfif>
        <cfinvokeargument name="CROrigen"    	   value="#Form.CROrigen#">
        <cfinvokeargument name="AFCcodigo"    	   value="#Form.AFCcodigo#">
        <cfinvokeargument name="AFCMejora"    	   value="#Form.AFCMejora#">
        <cfif isdefined("Form.AFCMid")>
        	<cfinvokeargument name="AFCMid"    	       value="#Form.AFCMid#">
        </cfif>
    </cfinvoke>
    
	<!---Modificación de los Datos Variables--->
	<cfset Tipificacion = StructNew()>
	<cfset temp = StructInsert(Tipificacion, "AF", "")> 
	<cfset temp = StructInsert(Tipificacion, "AF_CATEGOR", "#form.AF_CATEGOR#")> 
	<cfset temp = StructInsert(Tipificacion, "AF_CLASIFI", "#form.AF_CLASIFI#")> 
	
	<cfinvoke component="sif.Componentes.DatosVariables" method="GETVALOR" returnvariable="CamposForm">
		<cfinvokeargument name="DVTcodigoValor" value="AF">
		<cfinvokeargument name="Tipificacion"   value="#Tipificacion#">
		<cfinvokeargument name="DVVidTablaVal"  value="#form.CRDRid#">
		<cfinvokeargument name="DVVidTablaSec" 	value="1"> 
	</cfinvoke>
    
	<cfparam name="valor" default="0">
	<cfloop query="CamposForm">
		<cfif isdefined('form.#CamposForm.DVTcodigoValor#_#CamposForm.DVid#')>
			<cfset valor = #Evaluate('form.'&CamposForm.DVTcodigoValor&'_'&CamposForm.DVid)#>
		</cfif>
		<cfinvoke component="sif.Componentes.DatosVariables" method="SETVALOR">
			<cfinvokeargument name="DVTcodigoValor" value="AF">
			<cfinvokeargument name="DVid" 		    value="#CamposForm.DVid#">
			<cfinvokeargument name="DVVidTablaVal"  value="#form.CRDRid#">
			<cfinvokeargument name="DVVvalor" 	  	value="#valor#">
			<cfinvokeargument name="DVVidTablaSec" 	value="1"><!---(0=Activos)(1=CRDocumentoResponsabilidad) (2=DSActivosAdq)--->
		</cfinvoke>
	</cfloop>
	</cftransaction>
<!---►►►Registro de un NUEVO Documentos de Responsabilidad◄◄--->
<cfelseif isdefined("form.baja")>
	<cfinvoke component="sif.Componentes.AF_DocumentoResponsable" method="BajaDocTransito">
		<cfinvokeargument name="CRDRid" value="#form.CRDRid#">
	</cfinvoke>
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
		
		<cfif isdefined("form.chk")>
            <cfset lista = form.chk>
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
<cfelseif isdefined("form.btnEliminar")>
	<cfif isdefined("form.chk")>
		<cfloop list="#chk#" delimiters="," index="indchk">
			<cfinvoke component="sif.Componentes.AF_DocumentoResponsable" method="BajaDocTransito">
				<cfinvokeargument name="CRDRid" value="#indchk#">
			</cfinvoke>
		</cfloop>
	</cfif>
</cfif>

<!--- variable para enviar parámetros por get a la pantalla--->
<cfset params = "">
<!--- envío de la llave --->
<cfif isdefined("form.alta")>
	<!---<cfset params = params & iif(len(params),DE("&"),DE("?")) & "btnnuevo=nuevo">--->
	 <cfset params = params & iif(len(params),DE("&"),DE("?")) & "CRDRid=#rs_insert.identity#"> 
<cfelseif isdefined("form.cambio")>
	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "CRDRid=#form.CRDRid#">
<cfelseif isdefined("form.nuevo")>
	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "btnnuevo=nuevo">
</cfif>
<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "Pagina="&Form.PageNum>
<cfelseif isdefined("form.Pagina") and len(trim(form.Pagina))>
	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "Pagina="&Form.Pagina>
</cfif>
<cfif isdefined("form.Filtro_FechasMayores") and len(trim(form.Filtro_FechasMayores))>
	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "Filtro_FechasMayores="&Form.Filtro_FechasMayores & "&HFiltro_FechasMayores="&Form.Filtro_FechasMayores>
</cfif>
<cfif isdefined("form.Filtro__CRTipoDocumento") and len(trim(form.Filtro__CRTipoDocumento))>
	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "Filtro__CRTipoDocumento="&Form.Filtro__CRTipoDocumento& "&HFiltro__CRTipoDocumento="&Form.Filtro__CRTipoDocumento>
</cfif>
<cfif isdefined("form.Filtro__DatosEmpleado") and len(trim(form.Filtro__DatosEmpleado))>
	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "Filtro__DatosEmpleado="&Form.Filtro__DatosEmpleado& "&HFiltro__DatosEmpleado="&Form.Filtro__DatosEmpleado>
</cfif>
<cfif isdefined("form.Filtro_CRDRplaca") and len(trim(form.Filtro_CRDRplaca))>
	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "Filtro_CRDRplaca="&Form.Filtro_CRDRplaca& "&HFiltro_CRDRplaca="&Form.Filtro_CRDRplaca>
</cfif>
<cfif isdefined("form.Filtro_Usulogin") and len(trim(form.Filtro_Usulogin))>
	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "Filtro_Usulogin="&Form.Filtro_Usulogin& "&HFiltro_Usulogin="&Form.Filtro_Usulogin>
</cfif>
<cfif isdefined("form.Filtro_CRDRfdocumento") and len(trim(form.Filtro_CRDRfdocumento))>
	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "Filtro_CRDRfdocumento="&Form.Filtro_CRDRfdocumento& "&HFiltro_CRDRfdocumento="&Form.Filtro_CRDRfdocumento>
</cfif>

<cfparam name="form.Autogestion" default="">
<cflocation url="documento#form.Autogestion#.cfm#params#">
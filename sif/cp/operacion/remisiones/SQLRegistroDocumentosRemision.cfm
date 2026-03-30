<cfif isDefined('form.Calcular') || isDefined('form.BTNAPLICAR')>
    <cfif isdefined("form.chk")>

        <cfloop list="#form.chk#" item="d" index="i">
            <cfset validacionIEPSEscalonado(listToArray(form.chk)[i])>
        </cfloop>
    <cfelse>
        <cfset validacionIEPSEscalonado(form.IDDOCUMENTO)>
    </cfif>

</cfif>
<cffunction name="validacionIEPSEscalonado">
    <cfargument name="IDDOCUMENTO" type="numeric">

    <cfset NoEscalonado = false>
    <cfset SiEscalonado = false>
    <cfquery name="detalleImpuestos" datasource="#Session.DSN#">
        Select b.ieps, b.IEscalonado from DDocumentosCPR a
            inner join Impuestos b
                on a.CODIEPS = b.ICODIGO
            where a.IDdocumento = #arguments.IDDOCUMENTO# and a.ecodigo = #session.ecodigo#
    </cfquery>
    <cfloop query="#detalleImpuestos#">
        <cfif detalleImpuestos.IEPS eq 1>
            <cfif detalleImpuestos.IEscalonado eq 1>
                <cfset SiEscalonado = true>
            <cfelse>
                <cfset NoEscalonado = true>
            </cfif>
        </cfif>
    </cfloop>
    <cfif NoEscalonado && SiEscalonado>
        <cfthrow message="NO SE PUEDE APLICAR - Porfavor agrupe las lineas con IEPS escalonado en un documento y las lineas con IEPS simple en otro Documento.">
    </cfif>
</cffunction>



<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfset Request.error.backs = 1 >
<cfparam name="Form.EDfechaarribo" 	default="">
<!---ABG: solucion temporal, se debe corregir para solo ocupar el CFcomplemento cuando se seleccione armar la cuenta con CF--->
<cfparam name="url.CFComplemento"  	default="null">
<cfparam name="existe"  			default="false">
<cfparam name="cambioEncab"  		default="false">
<cfparam name="params"  			default="">
<cf_navegacion name="tipo">
<cf_navegacion name="TipDoc">

<cfquery name="rsValores" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200089 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<cfset valValores = "N">
<cfif #rsValores.RecordCount#  neq 0>
	<cfset valValores = rsValores.Pvalor>
</cfif>
<cfquery name="rsvalTolerancia" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200090 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<cfset varCEDif = 0>
<cfif #rsvalTolerancia.RecordCount#  neq 0>
	<cfset varCEDif = rsvalTolerancia.Pvalor>
</cfif>

<cfif isdefined('form.fecha') and len(trim(form.fecha))><cfset params = params & '&fecha=#form.fecha#' ></cfif>
<cfif isdefined('form.transaccion') and len(trim(form.transaccion))><cfset params = params & '&transaccion=#form.transaccion#' ></cfif>
<cfif isdefined('form.documento') and len(trim(form.documento))><cfset params = params & '&documento=#form.documento#' ></cfif>
<cfif isdefined('form.usuario') and len(trim(form.usuario))><cfset params = params & '&usuario=#form.usuario#' ></cfif>
<cfif isdefined('form.moneda') and len(trim(form.moneda))><cfset params = params & '&moneda=#form.moneda#' ></cfif>
<cfif isdefined('form.pageNum_lista') and len(trim(form.pageNum_lista))><cfset params = params & '&pageNum_lista=#form.pageNum_lista#' ></cfif>
<cfif isdefined('form.registros') and len(trim(form.registros))><cfset params = params & '&registros=#form.registros#' ></cfif>
<cfif isdefined('form.tipo') and len(trim(form.tipo))><cfset params = params & '&tipo=#form.tipo#' ></cfif>

<cfif (ISDEFINED('Form.CambiarD') OR ISDEFINED('Form.Cambiar') OR ISDEFINED('Form.AgregarD')) AND(
       not (isDefined("Form.EDfecha") 		and isDefined("Form._EDfecha") 		and Trim(Form.EDfecha) 		 EQ Trim(Form._EDfecha)
	   and isDefined("Form.EDfechaarribo") 	and Trim(Form.EDfechaarribo) EQ Trim(Form._EDfechaarribo)
	   and isDefined("Form.Mcodigo") 		and Trim(Form.Mcodigo) 		 EQ Trim(Form._Mcodigo)
	   and isDefined("Form.EDtipocambio") 	and Trim(Form.EDtipocambio)  EQ Trim(Form._EDtipocambio)
	   and isDefined("Form.Ocodigo") 		and Trim(Form.Ocodigo) 		 EQ Trim(Form._Ocodigo)
	   and isDefined("Form.Rcodigo") 		and Trim(Form.Rcodigo) 		 EQ Trim(Form._Rcodigo)
	   and isDefined("Form.EDdescuento") 	and Trim(Form.EDdescuento) 	 EQ Trim(Form._EDdescuento)
	   and isDefined("Form.EDdocumento") 	and Trim(Form.EDdocumento) 	 EQ Trim(Form._EDdocumento)
	   and isDefined("Form.Ccuenta") 		and Trim(Form.Ccuenta) 		 EQ Trim(Form._Ccuenta)
	   and isDefined("Form.EDimpuesto") 	and Trim(Form.EDimpuesto) 	 EQ Trim(Form._EDimpuesto)
	   and isDefined("Form.EDtotal") 		and Trim(Form.EDtotal) 		 EQ Trim(Form._EDtotal)
	   and isDefined("Form.id_direccion") 	and Trim(Form.id_direccion)  EQ Trim(Form._id_direccion)
	   and isDefined("Form.EDdocref") 		and Trim(Form.EDdocref) 	 EQ Trim(Form._EDdocref)
	   and isDefined("Form.TESRPTCid") 		and Trim(Form.TESRPTCid) 	 EQ Trim(Form._TESRPTCid)

	   and isDefined("Form.EDvencimiento") 			and Trim(Form.EDvencimiento) 		EQ Trim(Form._EDvencimiento)
	   and isDefined("Form.EDretencionVariable") 	and Trim(Form.EDretencionVariable) 	EQ Trim(Form._EDretencionVariable)))>
	<cfset cambioEncab = true>
</cfif>

<cfset LvarEstadoReg = 0>

<!---►►Forma de Construcción de Cuentas S=Normal, N=Por Origen Contable◄◄--->
<cfquery name="rsParam" datasource="#session.DSN#">
    select *
    from Parametros
    where Ecodigo =  #Session.Ecodigo#
      and Pcodigo = 2
</cfquery>

<cfset LvarComplementoXorigen = (rsParam.Pvalor EQ 'N')>

<!---►►OP◄◄--->
<cfif isdefined("url.OP") AND url.OP EQ "GENCF">
    <cfobject component="sif.Componentes.AplicarMascara" name="mascara">
    <cfset LvarCFformato = mascara.fnComplementoItem(url.Ecodigo, url.CFid, url.SNid, "S", "", url.Cid, "", "",url.CFComplemento)>
    <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
            <cfinvokeargument name="Lprm_CFformato" 		value="#LvarCFformato#"/>
            <cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>
            <cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
            <cfinvokeargument name="Lprm_Ecodigo" 			value="#url.Ecodigo#"/>
    </cfinvoke>

    <cfif LvarError EQ 'NEW' OR LvarError EQ 'OLD'>
        <cfquery name="rsTraeCuenta" datasource="#session.DSN#">
            select a.CFcuenta, a.Ccuenta, a.CFformato, a.CFdescripcion
            from CFinanciera a
                inner join CPVigencia b
                     on a.CPVid     = b.CPVid
                    and <cf_dbfunction name="now"> between b.CPVdesde and b.CPVhasta
            where a.Ecodigo   = #url.Ecodigo#
              and a.CFformato = '#LvarCFformato#'
        </cfquery>
    </cfif>

	<cfoutput>
        <script language="javascript" type="text/javascript">
            <cfif LvarError neq 'NEW' and LvarError neq 'OLD'>
                window.parent.fnSetCuenta ("","","#LvarCFformato#","#JSStringFormat(LvarError)#");
            <cfelseif rsTraeCuenta.CFcuenta EQ "">
                window.parent.fnSetCuenta ("","","#LvarCFformato#","No existe Cuenta de Presupuesto");
            <cfelse>
                window.parent.fnSetCuenta ("#rsTraeCuenta.CFcuenta#","#rsTraeCuenta.Ccuenta#","#trim(rsTraeCuenta.CFformato)#","#trim(rsTraeCuenta.CFdescripcion)#");
            </cfif>
        </script>
    </cfoutput>
    <cfabort>
</cfif>

<!---►►Ver Asiento◄◄--->
<cfif isdefined('url.pintar')>

    <cfinvoke component="sif.Componentes.CP_PosteoDocumentoRemision" method="PosteoDocumento">
        <cfinvokeargument name="IDdoc" 			value="#url.IDdocumento#">
        <cfinvokeargument name="Ecodigo" 		value="#Session.Ecodigo#">
        <cfinvokeargument name="usuario" 		value="#Session.usuario#">
        <cfinvokeargument name="PintaAsiento" 	value="true">
		<cfinvokeargument name="esCancelacion"  value="#url.cancelacion#">
		<cfinvokeargument name="esDevolucion"  value="#url.devolucion#">
    </cfinvoke>
    <cfset form.tipo = url.tipo>
    <cfabort>
    <cfthrow>
</cfif>

<!---►►Agregar Encabezado◄◄--->
<cfif isdefined("Form.AgregarE") >
    <cfquery name="rsExisteEncab" datasource="#Session.DSN#">
        select count(*) as valor
          from EDocumentosCPR
         where Ecodigo     =  #Session.Ecodigo#
           and CPTcodigo   = <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.CPTcodigo#">
           and EDdocumento = <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.EDdocumento#">
           and SNcodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
    </cfquery>

	<cfif rsExisteEncab.valor NEQ 0>
        <cfset existe = true> <script>alert("El documento ya existe");</script>
    <cfelse>
        <cfquery name="rsExisteEncabEnBitacora" datasource="#Session.DSN#">
            select count(1) as valor
              from BMovimientosCxP
             where Ecodigo =  #Session.Ecodigo#
               and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPTcodigo#">
               and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EDdocumento#">
               and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
        </cfquery>

        <cfif rsExisteEncabEnBitacora.valor NEQ 0>
            <cfset existe = true> <script>alert("El documento ya existe en la bitácora");</script>
        </cfif>
    </cfif>

	<cfif not existe>
        <cfquery name="TransaccionCP" datasource="#Session.DSN#">
            select CPTtipo
              from CPTransacciones
            where Ecodigo  =  #Session.Ecodigo#
             and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPTcodigo#">
        </cfquery>



        <cfparam name="form.TESRPTCid" 	  default="-1">
        <cfparam name="Form.EDdocref"  	  default="">
        <cfparam name="form.id_direccion" default="-1">
        <cfparam name="form.Rcodigo" 	  default="-1">
        <cfparam name="Form.Folio" 	 	  default="-1">
      	<cftransaction>
            <cfquery name="rsInsertEDocCP" datasource="#session.DSN#">
                insert into EDocumentosCPR (Ecodigo, CPTcodigo, EDdocumento, SNcodigo, Mcodigo, EDtipocambio,
                                            EDdescuento, EDporcdescuento, EDimpuesto, EDtotal, Ocodigo, Ccuenta, EDfecha,
                                            Rcodigo, EDusuario, EDselect, EDdocref, EDfechaarribo, id_direccion, TESRPTCid, BMUsucodigo,TESRPTCietu,
                                            folio,EDvencimiento,EVestado, FolioReferencia
											<cfif form.Rcodigo neq "-1" and listGetAt(form.Rcodigo, 2, '|') gt 0>
												,EDretencionVariable
											</cfif>
											<cfif isdefined("form.Timbre") AND LEN(form.Timbre) GT 0>
												,TimbreFiscal
											</cfif>
											)
                values ( 	 #Session.Ecodigo# ,
                            <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Form.CPTcodigo#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#Form.EDdocumento#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_integer" 	value="#Form.SNcodigo#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Form.Mcodigo#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_float" 	value="#Form.EDtipocambio#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_money" 	value="#Form.EDdescuento#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="0">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_money" 	value="#Form.EDimpuesto#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_money" 	value="#Form.EDtotal#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_integer" 	value="#Form.Ocodigo#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#form.Ccuenta#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_date" 	value="#LSDateFormat(Form.EDfecha,'YYYY/MM/DD')#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#trim(listGetAt(form.Rcodigo, 1, '|'))#" voidnull null="#Form.Rcodigo EQ -1#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#Session.usuario#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="0">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#Form.EDdocref#" voidnull null="#Form.EDdocref EQ -1#">,
                            <cfif isdefined("Form.EDfechaarribo") and len(trim(Form.EDfechaarribo))>
                                <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDfechaarribo,'YYYY/MM/DD')#">,
                            <cfelse>
                                <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDfecha,'YYYY/MM/DD')#">,
                            </cfif>
                            <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.id_direccion#" voidnull null="#form.id_direccion EQ -1#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#" voidnull null="#form.TESRPTCid EQ -1#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                            <cfif TransaccionCP.CPTtipo EQ 'C'>		<!--- 1=Documento Normal CR, 0=Documento Contrario DB --->
                                ,1
                            <cfelse>
                                ,0
                            </cfif>
                            ,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.Folio#" voidnull null="#Form.Folio EQ -1#">
                            ,<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDvencimiento,'YYYY/MM/DD')#" voidnull>
                            ,<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#LvarEstadoReg#" voidnull null="#LvarEstadoReg EQ -1#">
							<cfif form.Rcodigo neq "-1" and listGetAt(form.Rcodigo, 2, '|') gt 0>
								,<cfqueryparam cfsqltype="cf_sql_money" value="#LSParseNumber(Form.EDretencionVariable)#">
							</cfif>
							,<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.FolioReferencia#">
							<cfif isdefined("form.Timbre") AND LEN(form.Timbre) GT 0>
								, <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.Timbre#">
							</cfif>
                            )
                <cf_dbidentity1 datasource="#session.DSN#">
            </cfquery>
        		<cf_dbidentity2 datasource="#session.DSN#" name="rsInsertEDocCP" returnvariable="IdEDocCP">

		<!--- Se asocia el CFDI --->
		<cfif isdefined("form.ce_nombre_xTMP") and form.ce_nombre_xTMP NEQ "">
			<cfinvoke component="sif.ce.Componentes.RepositorioCFDIs"  method="AsignaCFDI" >
				<cfinvokeargument name="Documento" 		value="#form.EDDocumento#">
				<cfinvokeargument name="idDocumento" 	value="#IdEDocCP#">
				<cfinvokeargument name="idLinea" 		value="-1">
				<cfinvokeargument name="cod" 			value="#form.ce_nombre_xTMP#">
				<cfinvokeargument name="SNcodigo" 		value="#Form.SNcodigo#">
				<cfinvokeargument name="origen"			value="#form.ce_origen#">
			</cfinvoke>
		</cfif>

		<cfset modo		= "CAMBIO">
        <cfset modoDet	= "ALTA">
      	</cftransaction>
	</cfif>
<!---►►Borrar◄◄--->
<cfelseif isdefined("Form.BorrarE")>
    <cfquery name="parametroRec" datasource="#session.DSN#">
        select coalesce(Pvalor, '1') as Pvalor
        from Parametros
        where Ecodigo = #Session.Ecodigo#
          and Pcodigo = 880
    </cfquery>
	<cfif NOT parametroRec.RecordCount OR NOT LEN(TRIM(parametroRec.Pvalor))>
    	<cfthrow message="El parametro 'No permitir el mismo doc. recurrente para varias fac. en un mismo período y mes' no esta definido">
    </cfif>
    <cfif parametroRec.Pvalor neq 0>
		<!--- Si usa documento recurrente, limpia su ultima fecha de uso --->
        <cfquery name="recurrente" datasource="#session.DSN#">
            select IDdocumentorec
             from EDocumentosCPR
            where Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
              and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
        </cfquery>
        <cfif len(trim(recurrente.IDdocumentorec))>
            <cfquery name="rsDeleteEDocCP" datasource="#session.DSN#">
                update HEDocumentosCP
                set HEDfechaultuso = null
                where Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                  and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#recurrente.IDdocumentorec#">
            </cfquery>
        </cfif>
    </cfif>
	<cftransaction>
    	<cfquery name="rsDeleteEDocCP" datasource="#session.DSN#">
            delete from CERepoTMP
            where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
              and ID_Documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
        </cfquery>
		<cfquery name="rsDeleteLineaOrden" datasource="#session.DSN#">
		    UPDATE DOrdenCM
			SET DRemisionlinea = null
			FROM DDocumentosCPR dcpr
			INNER JOIN DOrdenCM dorden ON dcpr.linea = dorden.dremisionlinea
			WHERE dcpr.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
		</cfquery>
        <cfquery name="rsDeleteEDocCP" datasource="#session.DSN#">
            delete from DDocumentosCPR
            where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
              and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
        </cfquery>

        <cfquery name="rsDeleteDDocCP" datasource="#session.DSN#">
            delete from EDocumentosCPR
            where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
              and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
        </cfquery>

         <cf_cboFormaPago TESOPFPtipoId="4" TESOPFPid="#Form.IDdocumento#" SQL="delete">
	</cftransaction>
		<cfset modo    ="ALTA">
        <cfset modoDet ="ALTA">
<!---►►Agregar Detalles◄◄--->
<cfelseif isdefined("Form.AgregarD")>

	<cfif cambioEncab>
        <cf_dbtimestamp
            datasource="#session.dsn#"
            table="EDocumentosCPR"
            redirect="#URLira#"
            timestamp="#Form.timestampE#"
            field1="IDdocumento,numeric,#Form.IDdocumento#">


       <cfparam name="form.TESRPTCid" 	 default="-1">
       <cfparam name="Form.EDdocref"  	 default="">
       <cfparam name="form.id_direccion" default="-1">
       <cfparam name="form.Rcodigo" 	 default="-1">
	   <cfparam name="form.FolioReferencia" 	 default="-1">

       <cftransaction>
            <cfquery name="rsUpdateEDocCP" datasource="#session.DSN#">
                update EDocumentosCPR
                set	Mcodigo       = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#Form.Mcodigo#">,
                    EDtipocambio  = <cf_jdbcquery_param cfsqltype="cf_sql_float"    value="#Form.EDtipocambio#">,
                    EDdescuento   = <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.EDdescuento#">,
                    EDimpuesto    = <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#Form.EDimpuesto#">,
                    EDtotal       = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#Form.EDtotal#" scale="2">,
                    Rcodigo       = <cf_jdbcquery_param cfsqltype="cf_sql_char" 	value="#trim(listGetAt(form.Rcodigo, 1, '|'))#" voidnull null="#form.Rcodigo EQ -1#">,
                    Ocodigo       = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Form.Ocodigo#">,
                    Ccuenta       = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#Form.Ccuenta#">,
                    EDusuario     = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#Session.usuario#">,
                    EDfecha       = <cf_jdbcquery_param cfsqltype="cf_sql_date"     value="#LSDateFormat(Form.EDfecha,'YYYY/MM/DD')#">,
                    EDdocref      = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Form.EDdocref#" 	voidnull>,
                    id_direccion  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#form.id_direccion#" voidnull null="#form.id_direccion EQ -1#">,
                    TESRPTCid	  =	<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#form.TESRPTCid#" 	voidNull null="#form.TESRPTCid EQ -1#">,
                    BMUsucodigo   = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">,
                    EDvencimiento = <cf_jdbcquery_param cfsqltype="cf_sql_date" 	value="#LSDateFormat(Form.EDvencimiento,'YYYY/MM/DD')#" voidnull>,
                    EVestado 	  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#LvarEstadoReg#" voidnull null="#LvarEstadoReg EQ -1#">,
					FolioReferencia = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#Form.FolioReferencia#">,
                    <cfif isdefined("Form.EDfechaarribo") and len(trim(Form.EDfechaarribo))>
                        EDfechaarribo = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDfechaarribo,'YYYY/MM/DD')#">
                    <cfelse>
                        EDfechaarribo = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDfecha,'YYYY/MM/DD')#"><!--- EDfecha es obigatorio --->
                    </cfif>
					<cfif isdefined("form.Timbre") AND LEN(form.Timbre) GT 0>
						,TimbreFiscal = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.Timbre#">
					</cfif>
                    <!---,TimbreFiscal = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#Form.TimbreFiscal#">--->

                where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
             </cfquery>
         </cftransaction>
	</cfif>

	<cfset LvarAlm_Aid = "">
    <cfif find(Form.DDtipo, "A,T")>
        <cfset LvarAlm_Aid = form.almacen>
        <cfquery name="rsConsultaDepto" datasource="#session.DSN#">
            select Dcodigo
            from Almacen
            where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.almacen#">
        </cfquery>
    </cfif>

    <cfparam name="Form.DDtipo" default="">
    <cfif LvarComplementoXorigen>
        <!--- Cuando la cuenta no es digitada: AF = Cta Transito, sino ArmaCta Por Origenes y Complementos Financieros --->
        <cfif Form.DDtipo EQ "F">
            <cfquery name="rsCuentaActivo" datasource="#Session.DSN#">
                select <cf_dbfunction name="to_char" args="a.Pvalor"> as Pvalor, b.Cformato, b.Cdescripcion
                from Parametros a inner join CContables b
                  on a.Ecodigo = b.Ecodigo and
                     <cf_dbfunction name="to_char" args="a.Pvalor"> = <cf_dbfunction name="to_char" args="b.Ccuenta">
                where a.Ecodigo =  #Session.Ecodigo#
                  and a.Pcodigo = 240
            </cfquery>
            <cfset cuentaDetalle = rsCuentaActivo.Pvalor>
            <cfset cuentaFDetalle = "">
        <cfelse>
            <cfif isdefined('form.Cid') and LEN(TRIM(form.Cid))>
                <cfquery name="rsCCid" datasource="#session.DSN#">
                    select CCid
                    from Conceptos
                    where Ecodigo =  #Session.Ecodigo#
                      and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">
                </cfquery>
                <cfset Cconcepto = rsCCid.CCid>
            <cfelse>
                <cfset Cconcepto = "">
            </cfif>
            <cfinvoke returnvariable="Cuentas" component="sif.Componentes.CG_Complementos" method="TraeCuenta">
                <cfinvokeargument name="Oorigen" 		 value="CPFC">
                <cfinvokeargument name="Ecodigo" 		 value="#Session.Ecodigo#">
                <cfinvokeargument name="Conexion" 		 value="#Session.DSN#">
                <cfinvokeargument name="Oficinas" 		 value="#form.Ocodigo#">
                <cfinvokeargument name="SNegocios" 		 value="#form.SNcodigo#">
                <cfinvokeargument name="CPTransacciones" value="#form.CPTcodigo#">
                <cfinvokeargument name="Articulos" 		 value="#Form.Aid#">
                <cfinvokeargument name="Almacen" 		 value="#Form.Almacen#">
                <cfinvokeargument name="Conceptos" 		 value="#form.Cid#">
                <cfinvokeargument name="CFuncional" 	 value="#Form.CFid#">
                <cfinvokeargument name="Monedas" 		 value="form.Mcodigo">
                <cfinvokeargument name="Clasificaciones" value="">
                <cfinvokeargument name="CConceptos" 	 value="#Cconcepto#">
            </cfinvoke>
			<cfset cuentaDetalle = Cuentas.Ccuenta>
            <cfset cuentaFDetalle = Cuentas.CFcuenta>
		</cfif>
	<cfelse>
		<cfset cuentaDetalle = form.CcuentaD>
        <cfset cuentaFDetalle = form.CFcuentaD>
        <!---ERBG Inicia--->
		<cfset cuentaFComplemento = "">
        <cfif isdefined('form.DDtipo') and form.DDtipo eq 'A'>
        	 <cfobject component="sif.Componentes.AplicarMascara" name="mascara">

    		<cfset LvarCFformato = mascara.fnComplementoItem(#Session.Ecodigo# , #form.CFid#, #form.SNid#, "A", #Form.Aid#, #form.Cid#, "", "",
															 #CFComplemento#)>

            <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
                    <cfinvokeargument name="Lprm_CFformato" 		value="#LvarCFformato#"/>
                    <cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>
                    <cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
                    <cfinvokeargument name="Lprm_Ecodigo" 			value="#Session.Ecodigo#"/>
            </cfinvoke>

            <cfif LvarError EQ 'NEW' OR LvarError EQ 'OLD'>
                <cfquery name="rsTraeCtaFDet" datasource="#session.DSN#">
                    select a.CPcuenta, a.Ccuenta, a.CFformato, a.CFdescripcion
                    from CFinanciera a
                        inner join CPVigencia b
                             on a.CPVid     = b.CPVid
                            and <cf_dbfunction name="now"> between b.CPVdesde and b.CPVhasta
                    where a.Ecodigo   = #Session.Ecodigo#
                      and a.CFformato = '#LvarCFformato#'
                </cfquery>
        		<cfset cuentaFComplemento = #rsTraeCtaFDet.CPcuenta#>
            </cfif>
        </cfif>
        <!---ERBG fin--->
	</cfif>

    <cfif isdefined('cuentaDetalle') and len(trim(#cuentaDetalle#)) eq 0>
       <cfthrow message="Favor  verificar que la cuenta financiera sea valida.Proceso Cancelado!!">
    </cfif>
	<cfquery name = "rsConceptoGenerico" datasource="#session.dsn#">
	    select Cid, Cformato from Conceptos where Ccodigo = 'COMPRAS' and 
			Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>

	<cfif len(trim(rsConceptoGenerico.Cid)) EQ 0>
	   <cfthrow message="No se ha definido el concepto con el código 'COMPRAS'.">
	<cfelse>
	  <cfif len(trim(rsConceptoGenerico.Cformato)) EQ 0>
		  <cfthrow message="El concepto de 'COMPRAS' no tiene asociada una cuenta contable.">
		</cfif>
	</cfif>
	<cfquery name="rsExistImpAndIEPS" datasource="#Session.DSN#">
		select * from DDocumentosCPR 
			where Icodigo = '#Form.Icodigo#' and 
			<cfif len(trim(Form.codIEPS)) EQ 0>
				codIEPS is null
			<cfelse>
				codIEPS = '#Form.codIEPS#'
			</cfif>
			and IDdocumento	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">;
	</cfquery>
	<cfset LINEA_REMISION_GLOBAL = 0>
	<cftransaction>
			<cfif rsExistImpAndIEPS.recordCount EQ 0>
			    <!--- Insertar en la linea de la remision --->
				<cfquery name="rsInsert" datasource="#session.DSN#" result="resultInsert">
					insert into DDocumentosCPR
						(	IDdocumento,
							Aid,
							Cid,
							DDdescripcion,
							DDdescalterna,
							CFid,
							Alm_Aid,  Dcodigo,
							DDcantidad,
							DDpreciou,
							DDdesclinea,
							DDporcdesclin,
							DDtotallinea,
							DDtipo,
							Ccuenta,
							CFcuenta,
							Ecodigo,
							OCTtipo,
							OCTtransporte,
							OCTfechaPartida,
							OCTobservaciones,
							OCCid,
							OCid,
							Icodigo,
							BMUsucodigo,
							DSespecificacuenta,
							FPAEid,
							CFComplemento,
							codIEPS,
							DDMontoIeps,
							CPDCid)
					values	 (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">,
						<cfif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'A'>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">,
						<cfelseif isDefined("Form.DDtipo") and  Form.DDtipo eq 'T'>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AidT#">,
						<cfelseif isDefined("Form.DDtipo") and  Form.DDtipo eq 'O'>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AidOD#">,
						<cfelse>
							<CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
						</cfif>
						#rsConceptoGenerico.Cid#,
						'COMPRAS',
						null,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">,

						<cfif LvarAlm_Aid NEQ "">
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAlm_Aid#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsConsultaDepto.Dcodigo#">,
						<cfelse>
							<CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">, 	<CF_jdbcquery_param cfsqltype="cf_sql_integer" value="null">,
						</cfif>
						1,
						#LvarOBJ_PrecioU.enCF(Form.DDpreciou * Form.DDcantidad)#,
						<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DDdesclinea#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#Form.DDporcdesclin#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#numberFormat(Form.DDtotallinea,"9.00")#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.DDtipo#">,
						(
							select cfin.Ccuenta from CFinanciera cfin
							where cfin.CFformato = '#rsConceptoGenerico.Cformato#'
							and cfin.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						),
						(select cfin.CFcuenta from CFinanciera cfin
							where cfin.CFformato = '#rsConceptoGenerico.Cformato#'
							and cfin.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						),
						<cfif isdefined('form.Ecodigo_CcuentaD') and form.Ecodigo_CcuentaD neq -1>
							#form.Ecodigo_CcuentaD#,
						<cfelse>
							#Session.Ecodigo# ,
						</cfif>
						<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTtipo#">,
						<cfelse>
							<CF_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
						</cfif>
						<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTtransporte#">,
						<cfelse>
							<CF_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
						</cfif>
						<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
							<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.OCTfechaPartida,'YYYY/MM/DD')#">,
						<cfelse><CF_jdbcquery_param cfsqltype="cf_sql_timestamp" value="null">,</cfif>
						<cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTobservaciones#">,
						<cfelse><CF_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
						</cfif>
						<cfif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'O'>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCCid#">,
						<cfelse><CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
						</cfif>
						<cfif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'O'>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid#">,
						<cfelse>
							<CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
						</cfif>
						<cfif isDefined("Form.Icodigo") and Len(Trim(Form.Icodigo)) GT 0 >
							<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Icodigo#">,
						<cfelse>
							<CF_jdbcquery_param cfsqltype="cf_sql_char" value="null">,
						</cfif>
						<cfif isDefined("session.Usucodigo") and Len(Trim(session.Usucodigo)) GT 0 >
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfelse>
							<CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
						</cfif>
						<cfif isDefined("Form.chkEspecificarcuenta") and  len(trim(Form.chkEspecificarcuenta)) gt 0>
							1,
						<cfelse>
							0,
						</cfif>
						<cfif isdefined("form.FPAEid") and len(trim(form.FPAEid))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPAEid#">,
						<cfelse>
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
						</cfif>
					<cfif isdefined("form.DDtipo") and Form.DDtipo eq 'A'>
						<cfif len(trim(cuentaFComplemento))>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cuentaFComplemento#">,
						<cfelse>
							<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
						</cfif>
					<cfelse>
						<cfif isdefined("form.CFComplemento") and len(trim(form.CFComplemento))>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFComplemento#">,
						<cfelse>
							<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
						</cfif>
					</cfif>
					<cfif isDefined("Form.codIEPS") and Len(Trim(Form.codIEPS)) GT 0 >
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.codIEPS#">
					<cfelse>
						<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">
					</cfif>,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DDMieps#">,
				    <!---JMRV. Inicio del Cambio. 30/04/2014 --->
					<cfif isdefined("form.DDtipo") and Form.DDtipo eq 'A' and isdefined("form.CheckDistribucionHidden") and form.CheckDistribucionHidden is 1 and isdefined("form.PlantillaDistribucion") and form.PlantillaDistribucion is -1>
						<cfthrow message="No ha seleccionado una distribucion.">
					<cfelseif isdefined("form.DDtipo") and Form.DDtipo eq 'A' and isdefined("form.CheckDistribucionHidden") and form.CheckDistribucionHidden is 1>
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.PlantillaDistribucion#">
					<cfelse>
							0
					</cfif>
				    <!---JMRV. Fin del Cambio. 30/04/2014 --->
				    )

				    SELECT SCOPE_IDENTITY() as lastLineaOrden
				</cfquery>
				<cfset LINEA_REMISION_GLOBAL = #rsInsert.lastLineaOrden#>
			<cfelse>
			    <!--- Actualizar linea de remision --->
				<!--- Sumar los valores de la linea de la remision con la de la orden--->
				<cfquery name = "rsUpdateLineaRemision" datasource="#Session.DSN#">
					update DDocumentosCPR set DDDESCLINEA = (DDDESCLINEA + #Form.DDdesclinea#),
						DDMONTOIEPS = (DDMONTOIEPS + #Form.DDMieps#), 
						DDPORCDESCLIN = (DDPORCDESCLIN + #Form.DDporcdesclin#),
						DDPRECIOU = (DDPRECIOU + (#Form.DDpreciou# * #Form.DDcantidad#))
						where Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExistImpAndIEPS.Linea#">
				</cfquery>
				<cfset LINEA_REMISION_GLOBAL = #rsExistImpAndIEPS.Linea#>
				<!--- Elimina el descuento si es mayor que el total linea --->
				<cfquery datasource="#session.DSN#">
					update 
						DDocumentosCPR 
					set DDdesclinea		= 0
						, DDporcdesclin	= 0
					where IDdocumento	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">
					and Linea 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LINEA_REMISION_GLOBAL#">
					and DDdesclinea 	> DDcantidad * DDpreciou
				</cfquery>
				<!--- Calcula el total linea --->
				<cfquery datasource="#session.DSN#">
					update 
						DDocumentosCPR 
					set DDtotallinea		= round((DDcantidad * DDpreciou)- DDdesclinea,2)
					where IDdocumento	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">
					and Linea 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LINEA_REMISION_GLOBAL#">
				</cfquery>
			</cfif>
		</cftransaction>
		<cfset modo="CAMBIO">
        <cfset modoDet="ALTA">
<!---►►Borrar Detalle◄◄--->
<cfelseif isdefined("Form.BorrarD")>
        <cfquery name="getOrden" datasource="#session.DSN#">
			select * from DDocumentosCPR
			where Linea  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.Linea#">
			  and IDdocumento  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.IDdocumento#">
		</cfquery>
		<cfif getOrden.recordCount GT 0 >
			<!--- si el detalle viene de un contrato --->
			<cfif getOrden.CTDContid NEQ ''>
				<cfquery name="rstcCxp" datasource="#session.dsn#">
					select Mcodigo,EDtipocambio from EDocumentosCPR where IDdocumento  = #Form.IDdocumento#
				</cfquery>
				<cfset tcCxP = #rstcCxp.EDtipocambio#>
				<cfquery name="updDetContrato" datasource="#session.dsn#">
					update CTDetContrato set CTDCmontoConsumido = round(isnull(CTDCmontoConsumido,0) - #getOrden.DDtotallinea*tcCxP#,2)
					where CTDCont = #getOrden.CTDContid#
				</cfquery>
			</cfif>
			<cfquery name="rsDeleteDDocCxP" datasource="#session.DSN#">
	            delete from DDocumentosCPR
	            where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
	              and Linea 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Linea#">
	    	</cfquery>
			<cfquery name="rsDeleteLineaOrden" datasource="#session.DSN#">
			    update DOrdenCM set DRemisionlinea = null
				where DRemisionlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Linea#">
			</cfquery>
		</cfif>

		<cfset modo="CAMBIO">
        <cfset modoDet="ALTA">
<!---►►Modificar Encabezado◄◄--->
<cfelseif isdefined("Form.Cambiar")>
	<cfif cambioEncab>
        <cfset cambiarEncabezado()>
    </cfif>

    <cf_cboFormaPago TESOPFPtipoId="4" TESOPFPid="#Form.IDdocumento#" SQL="update">

    <cfset modo="CAMBIO">
    <cfset modoDet="ALTA">
<!---►►Cambiar Detalle◄◄--->
<cfelseif isdefined("Form.CambiarD")>
	<cfif cambioEncab>
        <cfset cambiarEncabezado()>
    </cfif>

    <cfset LvarAlm_Aid = "">
    <cfif find(Form.DDtipo, "A,T")>
        <cfset LvarAlm_Aid = form.almacen>
        <cfquery name="rsConsultaDepto" datasource="#session.DSN#">
            select Dcodigo
            from Almacen
            where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.almacen#">
        </cfquery>
    </cfif>

    <cfparam name="Form.DDtipo" default="">
    <cfif LvarComplementoXorigen>
        <!--- Cuando la cuenta no es digitada: AF = Cta Transito, sino ArmaCta Por Origenes y Complementos Financieros --->
        <cfif Form.DDtipo EQ "F">
            <cfquery name="rsCuentaActivo" datasource="#Session.DSN#">
                select <cf_dbfunction name="to_char" args="a.Pvalor"> as Pvalor, b.Cformato, b.Cdescripcion
                from Parametros a
                  inner join CContables b
                    on a.Ecodigo = b.Ecodigo
                    and <cf_dbfunction name="to_char" args="a.Pvalor"> = <cf_dbfunction name="to_char" args="b.Ccuenta">
                where a.Ecodigo =  #Session.Ecodigo#
                  and a.Pcodigo = 240
            </cfquery>
            <cfset cuentaDetalle = rsCuentaActivo.Pvalor>
            <cfset cuentaFDetalle = "">
        <cfelse>
            <cfif isdefined('form.DDtipo') and form.DDtipo eq 'S'>
                <cfquery name="rsCCid" datasource="#session.DSN#">
                    select CCid
                    from Conceptos
                    where Ecodigo = #Session.Ecodigo#
                      and Cid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">
                </cfquery>
            <cfelse>
                <cfset rsCCid.CCid = "">
            </cfif>
            <cfinvoke returnvariable="Cuentas" component="sif.Componentes.CG_Complementos" method="TraeCuenta">
             	<cfinvokeargument name="Oorigen" 		 value="CPFC">
                <cfinvokeargument name="Ecodigo" 		 value="#Session.Ecodigo#">
                <cfinvokeargument name="Conexion" 		 value="#Session.DSN#">
                <cfinvokeargument name="Oficinas" 		 value="#form.Ocodigo#">
                <cfinvokeargument name="SNegocios" 		 value="#form.SNcodigo#">
                <cfinvokeargument name="CPTransacciones" value="#form.CPTcodigo#">
                <cfinvokeargument name="Articulos" 		 value="#Form.Aid#">
                <cfinvokeargument name="Almacen" 		 value="#Form.Almacen#">
                <cfinvokeargument name="CFuncional" 	 value="#Form.CFid#">
                <cfinvokeargument name="Monedas" 		 value="form.Mcodigo">
                <cfinvokeargument name="Clasificaciones" value="">
                <cfinvokeargument name="Conceptos" 		 value="#form.Cid#">
                <cfinvokeargument name="CConceptos" 	 value="#rsCCid.CCid#">
            </cfinvoke>

            <cfset cuentaDetalle = Cuentas.Ccuenta>
            <cfset cuentaFDetalle = Cuentas.CFcuenta>
        </cfif>
    <cfelse>
        <!--- Se mantiene la cuenta que viene del form --->
        <cfset cuentaDetalle = form.CcuentaD>
        <cfset cuentaFDetalle = form.CFcuentaD>
        <!---ERBG Inicia--->
		<cfset cuentaFComplemento = "">
        <cfif isdefined('form.DDtipo') and form.DDtipo eq 'A'>
        	 <cfobject component="sif.Componentes.AplicarMascara" name="mascara">

    		<cfset LvarCFformato = mascara.fnComplementoItem(#Session.Ecodigo# , #form.CFid#, #form.SNid#, "A", #Form.Aid#, #form.Cid#, "", "",
															 #CFComplemento#)>

            <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
                    <cfinvokeargument name="Lprm_CFformato" 		value="#LvarCFformato#"/>
                    <cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>
                    <cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
                    <cfinvokeargument name="Lprm_Ecodigo" 			value="#Session.Ecodigo#"/>
            </cfinvoke>

            <cfif LvarError EQ 'NEW' OR LvarError EQ 'OLD'>
                <cfquery name="rsTraeCtaFDet" datasource="#session.DSN#">
                    select a.CPcuenta, a.Ccuenta, a.CFformato, a.CFdescripcion
                    from CFinanciera a
                        inner join CPVigencia b
                             on a.CPVid     = b.CPVid
                            and <cf_dbfunction name="now"> between b.CPVdesde and b.CPVhasta
                    where a.Ecodigo   = #Session.Ecodigo#
                      and a.CFformato = '#LvarCFformato#'
                </cfquery>
        		<cfset cuentaFComplemento = #rsTraeCtaFDet.CPcuenta#>
            </cfif>

        </cfif>
        <!---ERBG fin--->

        <cfif cuentaDetalle eq "" and isdefined('form.DDtipo') and form.DDtipo eq 'F'>
            <!---
            En caso de que por alguna razón a la hora de seleccionar un activo, no se haya obtenido la cuenta en tránsito,
            se ejecuta la siguiente consulta para obtenerla y actualizarla.
             --->
            <cfquery name="rsCuentaActivo" datasource="#Session.DSN#">
                select <cf_dbfunction name="to_char" args="a.Pvalor"> as Pvalor, b.Cformato, b.Cdescripcion
                from Parametros a
                  inner join CContables b
                    on a.Ecodigo = b.Ecodigo
                    and <cf_dbfunction name="to_char" args="a.Pvalor"> = <cf_dbfunction name="to_char" args="b.Ccuenta">
                where a.Ecodigo =  #Session.Ecodigo#
                  and a.Pcodigo = 240
            </cfquery>
            <cfset cuentaDetalle = rsCuentaActivo.Pvalor>

        </cfif>
    </cfif>
    <cfif isdefined('cuentaDetalle') and len(trim(#cuentaDetalle#)) eq 0>
       <cfthrow message="Favor  verificar que la cuenta financiera sea valida.Proceso Cancelado!!">
    </cfif>
    <cf_dbtimestamp
        datasource="#session.dsn#"
        table="DDocumentosCPR"
        redirect="#URLira#"
        timestamp="#Form.timestampD#"
        field1="IDdocumento,numeric,#Form.IDdocumento#"
        field2="Ecodigo,numeric,#session.Ecodigo#"
        field3="Linea,numeric,#Form.Linea#">
	<cftransaction>

<!---JMRV. Inicio del Cambio. 30/04/2014 --->
				<cfquery name="ObtenerDOlinea" datasource="#session.dsn#">
					select DOlinea, DDtotallinea,CTDContid
	  				from DDocumentosCPR
					where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
                	and Ecodigo =  #Session.Ecodigo#
              		and Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Linea#">
				</cfquery>
				<cfquery name="ObtenerDatos" datasource="#session.dsn#">
					select isnull(CPDCid,0) CPDCid
	  				from DDocumentosCPR
					where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
                	and Ecodigo =  #Session.Ecodigo#
              		and Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Linea#">
				</cfquery>
<!---JMRV. Fin del Cambio. 30/04/2014 --->

        <cfquery name="rsUpdateDDocCxP" datasource="#session.DSN#">
            update DDocumentosCPR set
            <cfif  isDefined("Form.DDdescripcion") and  len(trim(form.DDdescripcion)) neq 0>
                DDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DDdescripcion#">,
            </cfif>
                <cfif Form.DDtipo eq 'A'>
                     Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">,
                <cfelseif Form.DDtipo eq 'T'>
                     Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AidT#">,
                <cfelseif Form.DDtipo eq 'O'>
                     Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AidOD#">,
                <cfelseif Form.DDtipo eq 'S'>
                     Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">	,
                </cfif>
                <cfif  isDefined("Form.DDdescalterna") and  len(trim(form.DDdescalterna)) neq 0>
                     DDdescalterna = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DDdescalterna#">,
                </cfif>
                 DDcantidad    = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.DDcantidad#">,
                 DDpreciou     = #LvarOBJ_PrecioU.enCF(Form.DDpreciou)#,
                 DDdesclinea   = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DDdesclinea#">,
                 DDporcdesclin = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.DDporcdesclin#">,
                <cfif isDefined("Form.CFid") and LEN(Trim(Form.CFid)) NEQ 0>
                     CFid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">,
                <cfelse>
                     CFid = null,
                </cfif>
                <cfif LvarAlm_Aid NEQ "">
                     Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAlm_Aid#">,
                     Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsConsultaDepto.Dcodigo#">,
                <cfelse>
                     Alm_Aid = null,
                     Dcodigo = null,
                </cfif>

                 DDtotallinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#numberFormat(Form.DDtotallinea,"9.00")#" scale="2">,
                 DDtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.DDtipo#">,

                 Ecodigo =  #Session.Ecodigo#,

                Ccuenta  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuentaDetalle#">,
                CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuentaFDetalle#" null="#cuentaFDetalle EQ ""#">,

                <cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
                    OCTtipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTtipo#">,
                <cfelse>
                    OCTtipo =  null,
                </cfif>
                <cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
                    OCTtransporte = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTtransporte#">,
                <cfelse>
                    OCTtransporte = null,
                </cfif>
                <cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
                    OCTfechaPartida = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.OCTfechaPartida,'YYYY/MM/DD')#">,
                <cfelse>
                    OCTfechaPartida = null,
                </cfif>
                <cfif  isDefined("Form.DDtipo") and (Form.DDtipo eq 'T' or Form.DDtipo eq 'O')>
                    OCTobservaciones =<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTobservaciones#">,
                <cfelse>
                    OCTobservaciones = null,
                </cfif>
                <cfif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'O'>
                    OCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCCid#">,
                <cfelse>
                    OCCid =  null,
                </cfif>
                <cfif  isDefined("Form.DDtipo") and  Form.DDtipo eq 'O'>
                    OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid#">,
                <cfelse>
                    OCid = null,
                </cfif>
                <cfif isDefined("Form.Icodigo") and Len(Trim(Form.Icodigo)) GT 0 >
                    Icodigo =	<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Icodigo#">,
                <cfelse>
                     Icodigo =	 null,
                </cfif>
                <cfif isdefined("form.rsModDet") and form.rsModDet eq 0>
                	BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                </cfif>
                <cfif isDefined("Form.chkEspecificarcuenta") and  len(trim(Form.chkEspecificarcuenta)) gt 0>
                    DSespecificacuenta= 1,
                <cfelse>
                    DSespecificacuenta= 0,
                </cfif>
                <cfif isdefined("form.FPAEid") and len(trim(form.FPAEid))>
                    FPAEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPAEid#">,
                <cfelse>
                    FPAEid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
                </cfif>
                <cfif isdefined("form.rsModDet") and form.rsModDet eq 1 and (form.ModTipo neq form.DDtipo or form.ModCuenta neq cuentaFDetalle)>
                	UsucodigoModifica = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                </cfif>
                <cfif isdefined("form.DDtipo") and Form.DDtipo eq 'A'>
                	<cfif len(trim(cuentaFComplemento))>
                    	CFComplemento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cuentaFComplemento#">,
                    <cfelse>
                    	CFComplemento = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
                    </cfif>
                <cfelse>
					<cfif isdefined("form.CFComplemento") and len(trim(form.CFComplemento))>
                        CFComplemento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFComplemento#">,
                    <cfelse>
                        CFComplemento = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
                    </cfif>
              	</cfif>
                codIEPS = <cfif isDefined("Form.codIEPS") and Len(Trim(Form.codIEPS)) GT 0 >
                    <cfqueryparam cfsqltype="cf_sql_char" value="#Form.codIEPS#">
                <cfelse>
                    <cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">
                </cfif>,
                DDMontoIeps = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DDMieps#">,
				<!---Si la linea viene de una orden entonces no se cambian los datos de la distribucion--->
				<cfif isdefined("ObtenerDOlinea.DOlinea") and ObtenerDOlinea.DOlinea gt 0>
					CPDCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#ObtenerDatos.CPDCid#">,
				<cfelse>
					<cfif isdefined("form.DDtipo") and Form.DDtipo eq 'A' and isdefined("form.CheckDistribucionHidden") and form.CheckDistribucionHidden is 1 and isdefined("form.PlantillaDistribucion") and form.PlantillaDistribucion is -1>
						<cfthrow message="No ha seleccionado una distribucion.">
					<cfelseif isdefined("form.DDtipo") and Form.DDtipo eq 'A' and isdefined("form.CheckDistribucionHidden") and form.CheckDistribucionHidden is 1>
						CPDCid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.PlantillaDistribucion#">,
					<cfelse>
						CPDCid = 0,
					</cfif>
				</cfif>
			<!---JMRV. Fin del Cambio. 30/04/2014 --->
			 <cfif  isDefined("form.chkEspecificarCF") and  len(trim(form.chkEspecificarCF)) neq 0>
                CambioCF = 1
			<cfelse>
				CambioCF = 0
            </cfif>
                where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
                and Ecodigo =  #Session.Ecodigo#
              and Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Linea#">
        </cfquery>

		<cfif ObtenerDOlinea.recordCount GT 0 and ObtenerDOlinea.CTDContid NEQ ''>
			<!--- si el detalle viene de un contrato --->
			<cfquery name="rstcCxp" datasource="#session.dsn#">
				select Mcodigo,EDtipocambio from EDocumentosCPR where IDdocumento = #Form.IDdocumento#
			</cfquery>
			<cfset tcCxP = #rstcCxp.EDtipocambio#>

            <cfquery name="vDetContrato" datasource="#session.dsn#">
                        select CTDCmontoTotal,isnull(CTDCmontoConsumido,0) - #(ObtenerDOlinea.DDtotallinea + LSParseNumber(Form.DDtotallinea))*tcCxP# as CTDCmontoConsumido from CTDetContrato
                        where CTDCont = #ObtenerDOlinea.CTDContid#
            </cfquery>
            <cfif  vDetContrato.CTDCmontoConsumido GT vDetContrato.CTDCmontoTotal>
                <cfthrow message="El monto consumido es mayor que el monto del Contrato">
            </cfif>
			<cfif ObtenerDOlinea.CTDContid NEQ ''>
				<cfquery name="updDetContrato" datasource="#session.dsn#">
					update CTDetContrato set CTDCmontoConsumido = round(CTDCmontoConsumido - #ObtenerDOlinea.DDtotallinea# + #LSParseNumber(Form.DDtotallinea)*tcCxP#,2)
					where CTDCont = #ObtenerDOlinea.CTDContid#
				</cfquery>
			</cfif>
		</cfif>
	</cftransaction>

	<cfset modo="CAMBIO">
    <cfset modoDet="ALTA">

<!---►►Nueva Encabezado◄◄--->
<cfelseif isdefined("Form.btnNuevo")>
				<cflocation addtoken="no" url="#URLira#?LvarIDdocumento=true#params#">
<!---►►Nuevo Detalle◄◄--->
<cfelseif isdefined("form.NuevoD")>
			<cfset modo="CAMBIO">
			<cfset modoDet="ALTA">
<!---►►Cancelar remision◄◄--->
<cfelseif isdefined("Form.BTNCANCELAR")>
    <cfset aplicarGenerarPoliza()>
<!---►►Cancelar remision (masivo)◄◄--->
<cfelseif isdefined("Form.btnCancelar_Remisión")>
    <cfset aplicarGenerarPoliza()>
<!---►►Aplicar devolucion remision (masivo)◄◄--->
<cfelseif isdefined("Form.btnAplicar_Devolución")>
    <cfset aplicarGenerarPoliza()>
</cfif>
<!---►►PROCESO DE ACTUALIZACION DEL TOTAL DEL DOCUMENTO Y TOTAL DE IMPUESTOS◄◄--->
<cfif isdefined('form.AgregarD') or isdefined('form.BorrarD') or isdefined('form.CambiarD') or isdefined('form.Cambiar')>
    <cfquery name="rsSQL" datasource="#session.DSN#">
        select  a.EDdescuento,
                coalesce(
                    (
                        select sum(DDtotallinea)
                          from DDocumentosCPR
                         where IDdocumento = a.IDdocumento
                    )
                ,0.00) as SubTotal
          from EDocumentosCPR a
         where a.IDdocumento	= #Form.IDdocumento#
    </cfquery>

	<cfif rsSQL.EDdescuento GT rsSQL.Subtotal>
		<cfquery datasource="#session.DSN#">
			update EDocumentosCPR
			   set EDdescuento = 0
		   where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
			 and Ecodigo =  #Session.Ecodigo#
		</cfquery>
	</cfif>

	<!--- CALCULO DEL TOTAL DE IMPUESTO y Descuento a nivel de documento POR LINEA DEL DOCUMENTO --->
	<!---ACTUALIZA EL ENCABEZADO DEL DOCUMENTO CON LOS TOTALES --->
	<!--- DDtotallin	= precio * cantidad - DDdesclinea --->
	<!--- EDtotal		= sum(DDtotallin) + Impuestos - EDdescuento --->


    <!---►►Crea las tablas temporales de trabajo◄◄--->
	<cfinvoke component="sif.Componentes.CP_PosteoDocumentoRemision" method="fnCreaTablasTemp">
    </cfinvoke>
<!--- validamos que este escalonado
    <cfset Escalonado = 1>
        <cfif isdefined('form.cid') and len(trim('form.cid'))>
            <cfquery name = "rsIEPSiva" datasource="#session.dsn#">
                select coalesce(afectaIVA,0) as Escalonado
                from Conceptos
                where Cid = #form.cid#
            </cfquery>
            <cfset Escalonado =  #rsIEPSiva.Escalonado#>
        </cfif>

        <cfif isdefined('form.Aid') and len(trim('form.Aid'))>
            <cfquery name = "rsIEPSiva" datasource="#session.dsn#">
                select coalesce(afectaIVA,0) as Escalonado
                from Articulos
                where Aid = #form.Aid#
            </cfquery>
            <cfset Escalonado =  #rsIEPSiva.Escalonado#>
        </cfif>--->
<!--- -------------------- --->
    <!---►►Calcula impuestos, descuentos y totales y los Actualiza en el Encabezado de la poliza◄◄--->

	<cfinvoke component="sif.Componentes.CP_PosteoDocumentoRemision"  method="CP_CalcularDocumento">
		   <cfinvokeargument name="IDdoc" 			  value="#Form.IDdocumento#">
		   <cfinvokeargument name="CalcularImpuestos" value="true">
		   <cfinvokeargument name="Ecodigo"			  value="#session.Ecodigo#">
		   <cfinvokeargument name="conexion"	 	  value="#session.DSN#">
   </cfinvoke>
	<cfinvoke component="sif.ce.Componentes.RepositorioCFDIs"  method="AsignaCFDI" >
		<cfinvokeargument name="idDocumento" 	value="#Form.IDdocumento#">
		<cfinvokeargument name="idLinea" 		value="-1">
		<cfinvokeargument name="origen"			value="CPFC">
	</cfinvoke>
</cfif>
<!---►►Calcular◄◄--->
	<cfif isdefined('form.Calcular')>

    	<!---►►Crea las tablas temporales de trabajo◄◄--->
        <cfinvoke component="sif.Componentes.CP_PosteoDocumentoRemision" method="fnCreaTablasTemp">
        </cfinvoke>

        <!---►►Calcula impuestos, descuentos y totales y los Actualiza en el Encabezado de la poliza◄◄--->
        <cfinvoke component="sif.Componentes.CP_PosteoDocumentoRemision" method="CP_CalcularDocumento">
            <cfinvokeargument name="IDdoc" 				value="#Form.IDdocumento#">
            <cfinvokeargument name="CalcularImpuestos" 	value="false">
            <cfinvokeargument name="Ecodigo" 			value="#session.Ecodigo#">
            <cfinvokeargument name="conexion" 			value="#session.DSN#">
            <cfinvokeargument name="conexion"           value="#session.DSN#">
        </cfinvoke>

		<!--- Forma de Cálculo de Impuesto (0: Desc/Imp, 1: Imp/Desc.) --->
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = #session.Ecodigo#
			  and Pcodigo = 420
		</cfquery>
		<cfset LvarImpuestosAntesDescuento = rsSQL.Pvalor EQ "1">

		<cfset LB_Prorrateo = t.Translate('LB_Prorrateo','PRORRATEO DE DESCUENTO DE DOCUMENTO Y CALCULO DE IMPUESTOS')>
		<cfset Msg_ManDescNivDoct = t.Translate('Msg_ManDescNivDoct','Manejo del Descuento a nivel de Documento para calcular Impuestos')>
		<cfset Msg_primImp = t.Translate('Msg_primImp','primero Impuestos y luego DescuentoDoc')>
		<cfset Msg_primDesc = t.Translate('Msg_primDesc','primero DescuentoDoc y luego Impuestos')>
		<cfset LB_Lin = t.Translate('LB_Lin','Lin','/sif/cp/operacion/PagosCxP.xml')>
		<cfset LB_Tipo 	= t.Translate('LB_Tipo','Tipo','/sif/generales.xml')>
		<cfset LB_Descripcion 	= t.Translate('LB_Descripcion','Descripcion','/sif/generales.xml')>
		<cfset LB_Subtotal 	= t.Translate('LB_Subtotal','Subtotal','/sif/generales.xml')>
		<cfset LB_DescuenDoc = t.Translate('LB_DescuenDoc','Descuen.Doc')>
		<cfset LB_Prorrateado = t.Translate('LB_Prorrateado','Prorrateado')>
		<cfset LB_Basedel = t.Translate('LB_Basedel','Base del')>
        <cfset LB_iEPS = t.Translate('LB_iEPS','IEPS')>
		<cfset LB_Impuesto = t.Translate('LB_Impuesto','Impuesto')>
		<cfset LB_alCosto = t.Translate('LB_alCosto','al Costo')>
		<cfset LB_Fiscal = t.Translate('LB_Fiscal','Fiscal')>
		<cfset LB_Total 	= t.Translate('LB_Total','Total','/sif/generales.xml')>
		<cfset LB_Linea = t.Translate('LB_Linea','L&iacute;nea')>
		<cfset LB_Costo = t.Translate('LB_Costo','Costo')>
		<cfset LB_TotalNeto = t.Translate('LB_TotalNeto','Total Neto')>
		<cfset LB_DescDoc = t.Translate('LB_DescDoc','Descuento Documento')>
		<cfset LB_TotalDoc = t.Translate('LB_TotalDoc','Total Documento')>
		<cfset LB_Retenc = t.Translate('LB_Retenc','Retención')>
		<cfset LB_RUBRO = t.Translate('LB_RUBRO','RUBRO')>
		<cfset LB_DEBITOS = t.Translate('LB_DEBITOS','DEBITOS')>
		<cfset LB_CREDITOS = t.Translate('LB_CREDITOS','CREDITOS')>
		<cfset LB_CtaXPag = t.Translate('LB_CtaXPag','Cuenta por Pagar')>
		<cfset LB_CostLin = t.Translate('LB_CostLin','Costos de las Lineas')>
		<cfset LB_ImpxPag = t.Translate('LB_ImpxPag','Impuestos por Pagar')>
		<cfset LB_VerAsiento = t.Translate('LB_VerAsiento','Ver Asiento')>


		<cf_templatecss>
		<cfoutput>
		<table width="100%">
			<tr>
				<td colspan="10"><strong>#LB_Prorrateo#</strong></td>
			</tr>
			<tr>
				<td colspan="10">(#Msg_ManDescNivDoct#: <cfif LvarImpuestosAntesDescuento>#Msg_primImp# <cfelse>#Msg_primDesc#</cfif>)</strong></td>
			</tr>
			<tr>
				<td><strong>#LB_Lin#</strong></td>
				<td><strong>#LB_Tipo#</strong></td>
				<td><strong>#LB_Descripcion#</strong></td>
				<td align="right"><strong>#LB_Subtotal#</strong></td>

                <td align="right"><strong>#LB_iEPS#<br>#LB_alCosto#</strong></td>
                <td align="right"><strong>#LB_iEPS#<br>#LB_Fiscal#</strong></td>
			<cfif NOT LvarImpuestosAntesDescuento>
				<td align="right"><strong>#LB_DescuenDoc#<BR>#LB_Prorrateado#</strong></td>
			</cfif>
				<td align="right"><strong>#LB_Basedel#<br>#LB_Impuesto#</strong></td>

				<td><strong>&nbsp;&nbsp;Tipo<br>&nbsp;&nbsp;#LB_Impuesto#</strong></td>
				<td align="right"><strong>#LB_Impuesto#<br>#LB_alCosto#</strong></td>
				<td align="right"><strong>#LB_Impuesto#<br>#LB_Fiscal#</strong></td>
				<td align="right"><strong>#LB_Total#<br>#LB_Impuesto#</strong></td>
			<cfif LvarImpuestosAntesDescuento>
				<td align="right"><strong>#LB_DescuenDoc#<BR>#LB_Prorrateado#</strong></td>
			</cfif>
				<td align="right"><strong>#LB_Costo#<br>#LB_Linea#</strong></td>
				<td align="right"><strong>#LB_TotalNeto#<br>#LB_Linea#</strong></td>
			</tr>

		<cfquery name="rsSQL" datasource="#session.DSN#">
			select *
			from #request.CP_calculoLin# l
				inner join DDocumentosCPR d
				   on d.IDdocumento 	= l.iddocumento
				  and d.Linea			= l.linea
				left join #request.CP_impLinea# i
				  on i.linea = l.linea
		</cfquery>

		<cfset LvarLinea = "">
		<cfset LvarNumLinea			= 0>
		<cfset LvarSubtotal			= 0>
		<cfset LvarTotDescDoc		= 0>
		<cfset LvarTotImpuesto		= 0>
		<cfset LvarTotImpuestoCO	= 0>
		<cfset LvarTotImpuestoCF	= 0>
		<cfset LvarTotCosto			= 0>
		<cfset LvarTotLinea			= 0>
        <cfset LvarIeps             = 0>
        <cfset LvarIepsCosto        = 0>
        <cfset LvarTotIepsCosto     = 0>

		<cfloop query="rsSQL">
			<cfif LvarLinea NEQ rsSQL.linea>

				<cfset LvarLinea = rsSQL.linea>
				<cfset LvarNumLinea ++>
				<cfset LvarCostoLinea		=  (rsSQL.costoLinea)>
				<cfset LvarTotalLinea		=  (rsSQL.totalLinea)>

				<cfset LvarSubtotal			+= rsSQL.subtotalLinea>
				<cfset LvarTotDescDoc		+= rsSQL.descuentoDoc>
				<cfset LvarTotImpuesto		+= (rsSQL.impuestoCosto+rsSQL.impuestoCF)>
				<cfset LvarTotImpuestoCO	+= (rsSQL.impuestoCosto)>
				<cfset LvarTotImpuestoCF	+= (rsSQL.impuestoCF)>
				<cfset LvarTotCosto			+= LvarCostoLinea>
                <cfset LvarIeps             += (rsSQL.IEPS)>
                <cfset LvarIepsCosto        += (rsSQL.CostoIEPS)>
                <cfset LvarTotIepsCosto     += (rsSQL.IEPS + rsSQL.CostoIEPS)>

				<cfset LvarTotLinea			+= LvarTotalLinea>

				<tr>
					<td>#LvarNumLinea#</td>
					<td>#rsSQL.DDtipo#</td>
					<td>#rsSQL.DDdescripcion#</td>
					<td align="right">#numberFormat(rsSQL.subtotalLinea,",9.99")#</td>
                <cfif rsSQL.CostoIEPS EQ 0>
                    <td align="right">-</td>
                <cfelse>
                    <td align="right">#numberFormat(rsSQL.CostoIEPS,",9.99")#</td>
                </cfif>
                <cfif rsSQL.IEPS EQ 0>
                    <td align="right">-</td>
                <cfelse>
                    <td align="right">#numberFormat(rsSQL.IEPS,",9.99")#</td>
                </cfif>
				<cfif NOT LvarImpuestosAntesDescuento>
					<td align="right">#numberFormat(rsSQL.descuentoDoc,",9.99")#</td>
				</cfif>
					<td align="right">#numberFormat(rsSQL.impuestoBase,",9.99")#</td>
					<td>
						&nbsp;&nbsp;#trim(rsSQL.Icodigo)#
                    	<cfif rsSQL.impuestoBase EQ 0>
                        	= 0.00%
                        <cfelseif Icompuesto EQ '1'>
							<cfquery name="rsCompuesto" datasource="#session.DSN#">
								select sum(DIporcentaje) as porcentaje
								from DImpuestos
								where Ecodigo	= #session.Ecodigo#
								  and Icodigo	= '#rsSQL.Icodigo#'
							</cfquery>
	                    	= #numberFormat(rsCompuesto.porcentaje,",9.99")#%
						<cfelse>
	                    	= #numberFormat(porcentaje,",9.99")#%
                        </cfif>
                    </td>
					<cfif rsSQL.impuestoCosto EQ 0>
						<td align="right">-</td>
					<cfelse>
						<td align="right">#numberFormat(rsSQL.impuestoCosto,",9.99")#</td>
					</cfif>
					<cfif rsSQL.impuestoCF EQ 0>
						<td align="right">-</td>
					<cfelse>
						<td align="right">#numberFormat(rsSQL.impuestoCF,",9.99")#</td>
					</cfif>
					<td align="right">#numberFormat(rsSQL.impuestoCosto+rsSQL.impuestoCF,",9.99")#</td>
				<cfif LvarImpuestosAntesDescuento>
					<td align="right">#numberFormat(rsSQL.descuentoDoc,",9.99")#</td>
				</cfif>
                    <td align="right">#numberFormat(rsSQL.costoLinea,",9.99")#</td>
					<td align="right">#numberFormat(rsSQL.totalLinea,",9.99")#</td>
				</tr>
			</cfif>
			<cfif rsSQL.Icompuesto EQ '1'>
				<cfset LvarLinea = rsSQL.linea>

				<tr>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				<cfif NOT LvarImpuestosAntesDescuento>
					<td></td>
				</cfif>
					<td></td>
					<td style="font-size:10px; color:##666666">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#trim(rsSQL.DIcodigo)#=#rsSQL.porcentaje#%</td>
					<cfif rsSQL.creditoFiscal EQ "0">
						<td align="right" style="font-size:10px; color:##666666;">#numberFormat(rsSQL.impuesto,",9.99")#</td>
						<td></td>
					<cfelse>
						<td></td>
						<td align="right" style="font-size:10px; color:##666666;">#numberFormat(rsSQL.impuesto,",9.99")#</td>
					</cfif>
					<td align="right" style="font-size:10px; color:##666666;">#numberFormat(rsSQL.impuesto,",9.99")#</td>
				</tr>
			</cfif>
		</cfloop>
				<tr>
					<td></td>
					<td></td>
					<td></td>
					<td align="right"><strong>#numberFormat(LvarSubtotal,",9.99")#</strong></td>
				<cfif NOT LvarImpuestosAntesDescuento>
					<td align="right"><strong>#numberFormat(LvarTotDescDoc,",9.99")#</strong></td>
				</cfif>
					<td align="right"><strong>#numberFormat(LvarIepsCosto,",9.99")#</strong></td>
					<td align="right"><strong>#numberFormat(LvarIeps,",9.99")#</strong></td>
					<td></td>
					<td></td>
					<td align="right"><strong>#numberFormat(LvarTotImpuestoCO,",9.99")#</strong></td>
					<td align="right"><strong>#numberFormat(LvarTotImpuestoCF,",9.99")#</strong></td>
					<td align="right"><strong>#numberFormat(LvarTotImpuesto,",9.99")#</strong></td>
				<cfif LvarImpuestosAntesDescuento>
					<td align="right"><strong>#numberFormat(LvarTotDescDoc,",9.99")#</strong></td>
				</cfif>
					<td align="right"><strong>#numberFormat(LvarTotCosto,",9.99")#</strong></td>
					<td align="right"><strong>#numberFormat(LvarTotLinea,",9.99")#</strong></td>
				</tr>

				<tr>
					<td>&nbsp;</td>
				</tr>

				<tr>
					<td colspan="11" align="right"><strong>#LB_Subtotal#</strong></td>
					<td></td>
					<td align="right"><strong>#numberFormat(LvarSubtotal,",9.99")#</strong></td>
				</tr>
			<cfif NOT LvarImpuestosAntesDescuento>
				<tr>
					<td colspan="11" align="right"><strong>#LB_DescDoc#</strong></td>
					<td></td>
					<td align="right"><strong>#numberFormat(LvarTotDescDoc,",9.99")#</strong></td>
				</tr>
			</cfif>
				<tr>
                    <td colspan="11" align="right"><strong>#LB_iEPS#</strong></td>
					<td></td>
                    <td align="right"><strong>#numberFormat(LvarTotIepsCosto,",9.99")#</strong></td>
                </tr>
				<tr>
					<td colspan="11" align="right"><strong>#LB_Impuesto#</strong></td>
					<td></td>
					<td align="right"><strong>#numberFormat(LvarTotImpuesto,",9.99")#</strong></td>
				</tr>
			<cfif LvarImpuestosAntesDescuento>
				<tr>
					<td colspan="11" align="right"><strong>#LB_DescDoc#</strong></td>
					<td></td>
					<td align="right"><strong>#numberFormat(LvarTotDescDoc,",9.99")#</strong></td>
				</tr>
			</cfif>
				<tr>
					<td colspan="11" align="right"><strong>#LB_TotalDoc#</strong></td>
					<td></td>
					<td align="right"><strong>#numberFormat(LvarTotLinea,",9.99")#</strong></td>
				</tr>
				<tr>
					<cfquery name="rsRetencion" datasource="#session.dsn#">
						select 	coalesce(r.Rporcentaje,0) / 100.0 *
								coalesce(
								(
									select sum(DDtotallinea)
									  from DDocumentosCPR d
									 inner join Impuestos i
										 on i.Ecodigo = d.Ecodigo
										and i.Icodigo = d.Icodigo
									 where d.IDdocumento = e.IDdocumento
									   and i.InoRetencion = 0

								)
							,0.00) + coalesce(e.EDretencionVariable,0) as Monto
						from EDocumentosCPR e
							left join Retenciones r
							 on r.Ecodigo = e.Ecodigo
							and r.Rcodigo = e.Rcodigo
						where e.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
					</cfquery>
					<td colspan="11" align="right"><strong>#LB_Retenc#</strong></td>
					<td></td>
					<td align="right"><strong>#numberFormat(rsRetencion.Monto,",9.99")#</strong></td>
				</tr>
		</table>
        <table>
        	<tr>
            	<td>
                	<strong>#LB_RUBRO#</strong>&nbsp;&nbsp;
                </td>
            	<td>
                	<strong>#LB_DEBITOS#</strong>&nbsp;&nbsp;
                </td>
            	<td>
                	<strong>#LB_CREDITOS#</strong>&nbsp;
                </td>
			</tr>
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select CPTtipo
				 from EDocumentosCPR e
				inner join CPTransacciones t
					 on t.Ecodigo	= e.Ecodigo
					and t.CPTcodigo	= e.CPTcodigo
				where e.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and e.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
			</cfquery>
			<cfset LvarCPTtipo = rsSQL.CPTtipo>
        	<tr>
            	<td>
                	#LB_CtaXPag#
                </td>
				<cfif LvarCPTtipo EQ "C">
					<td></td>
					<td align="right">
						#numberFormat(LvarTotLinea,",9.99")#
					</td>
				<cfelse>
					<td align="right">
						#numberFormat(LvarTotLinea,",9.99")#
					</td>
					<td></td>
				</cfif>
			</tr>
        	<tr>
            	<td>
                	#LB_CostLin#&nbsp;&nbsp;
                </td>
				<cfif LvarCPTtipo EQ "C">
					<td align="right">
						#numberFormat(LvarTotCosto,",9.99")#
					</td>
					<td></td>
				<cfelse>
					<td></td>
					<td align="right">
						#numberFormat(LvarTotCosto,",9.99")#
					</td>
				</cfif>
			</tr>
        	<tr>
            	<td>
                    #LB_iEPS#&nbsp;&nbsp;
                </td>
                <cfif LvarCPTtipo EQ "C">
                    <td align="right">
                        #numberFormat(LvarIeps,",9.99")#
                    </td>
                    <td></td>
                <cfelse>
                    <td></td>
                    <td align="right">
                        #numberFormat(LvarIeps,",9.99")#
                    </td>
                </cfif>
            </tr>
        	<tr>
            	<td>
                	#LB_ImpxPag#&nbsp;&nbsp;
                </td>
				<cfif LvarCPTtipo EQ "C">
					<td align="right">
						#numberFormat(LvarTotImpuestoCF,",9.99")#
					</td>
					<td></td>
				<cfelse>
					<td></td>
					<td align="right">
						#numberFormat(LvarTotImpuestoCF,",9.99")#
					</td>
				</cfif>
			</tr>
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select dicodigo,
              case when porcjeIeps > 0 then
                  porcjeIeps
              else porcentaje
              end as porcentaje,
              case when IEPS = 0  then
                sum(impuesto)
              else
                sum(IEPS)
              end as impuesto
				from #request.CP_impLinea# i
				where creditofiscal = 1
				group by dicodigo, porcentaje,IEPS,porcjeIeps
			</cfquery>




			<cfloop query="rsSQL">
				<tr>
					<td style="font-size:10px; color:##666666">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#trim(rsSQL.DIcodigo)#=#rsSQL.porcentaje#%</td>
				<cfif LvarCPTtipo NEQ "C">
					<td></td>
				</cfif>
					<td align="right" style="font-size:10px; color:##666666;">#numberFormat(rsSQL.impuesto,",9.99")#</td>
				</tr>
			</cfloop>
		</table>
		<cfset esCancelacion = false>
		<cfset esDevolucion = false>
		<cfif isDefined("form.esCancelacion")>
		    <cfset esCancelacion = true>
		</cfif>
		<cfif isDefined("form.esDevolucion")>
		    <cfset esDevolucion = true>
		</cfif>
		<input type="button" value="#LB_VerAsiento#" onClick="location.href='SQLRegistroDocumentosRemision.cfm?Pintar&TipDoc=#TipDoc#&IDdocumento=#Form.IDdocumento#&tipo=#form.tipo#&cancelacion=#esCancelacion#&devolucion=#esDevolucion#';" />
		</cfoutput>
		<cfabort>
	</cfif>
<cfif isdefined("form.IDdocumento") and len(trim(form.IDdocumento)) and not isdefined("Form.BorrarE")>
	<cfquery name="RScuenta" datasource="#session.DSN#">
		select *
		from EDocumentosCPR
		where Ecodigo =  #Session.Ecodigo#
		and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">
	</cfquery>
	<cfif rscuenta.recordcount EQ 1>
		<cfquery name="rsSocioN_SQL" datasource="#session.DSN#">
			select SNidentificacion, SNcodigo, SNnumero, SNid, id_direccion
			from SNegocios
			where Ecodigo =  #Session.Ecodigo#
			and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#RScuenta.SNcodigo#">
		</cfquery>
	</cfif>
</cfif>
<cfif isdefined("form.btnAgregar")>
    <cfif isdefined('form.chk')>
	<cfset arr = ListToArray(form.chk, ',', false)>
	<cfset LvarLen = ArrayLen(arr)>
	<cfset LvarIdEDocumento = url.Edocumento>
		  <cfloop index="i" from="1" to="#LvarLen#">
			<cfset LvarLineaNum = "#ListGetAt(arr[i], 5 ,'|')#">  <!---Id de la linea de la factura --->
			<cfset LvarLineaDoc  = "#ListGetAt(arr[i], 11 ,'|')#">  <!---Id del documento --->

            <cftransaction>
			<cfquery name="rsLineaFact" datasource="#session.dsn#">
			 select     IDdocumento,
						DDlinea,
						Dcodigo,
						Ccuenta,
						Aid,
						DOlinea,
						CFid,
						DDescripcion,
						DDdescalterna,
						DDcantidad,
						DDpreciou,
						DDdesclinea,
						DDtotallin,
						DDcoditem,
						DDtipo,
						Icodigo,
						Ucodigo,
						DDtransito,
						DDembarque,
						DDfembarque,
						DDobservaciones,
						ContractNo,
						CFcuenta,
						PCGDid,
						FPAEid,
						CFComplemento,
						OBOid,
						codIEPS,
                        DDMontoIeps
				from DDocumentosCP
				  where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLineaDoc#">
				    and DDlinea     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLineaNum#">
				and Ecodigo = #session.ecodigo#
			 </cfquery>
			<cfquery name="rsInsLineasFact" datasource="#session.DSN#">
				insert into DDocumentosCPR
					(	IDdocumento,
					    Cid,
						Ecodigo,
						Dcodigo,
						Ccuenta,
						Aid,
						Alm_Aid,
						DOlinea,
						CFid,
						DDdescripcion,
						DDdescalterna,
						DDcantidad,
						DDpreciou,
						DDdesclinea,
						DDporcdesclin,
						DDtotallinea,
						DDtipo,
						BMUsucodigo,
						Icodigo,
						Ucodigo,
						DDtransito,
						DDfembarque,
						DDembarque,
						DDobservaciones,
						ContractNo,
						CFcuenta,
						PCGDid,
						FPAEid,
						CFComplemento,
						OBOid,
						codIEPS,
                        DDMontoIeps
						)
				values
				   (
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#LvarIdEDocumento#">,
					<cfif rsLineaFact.DDtipo eq 'S'>
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsLineaFact.DDcoditem#" voidNull>,
					<cfelse>
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="null">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric"  value="#session.ecodigo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#rtrim(rsLineaFact.Dcodigo)#" voidNull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsLineaFact.Ccuenta#">,
					<cfif rsLineaFact.DDtipo eq 'A'>
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsLineaFact.DDcoditem#" voidNull>,
					<cfelse>
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="null">,
					</cfif>
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsLineaFact.Aid#" 		voidNull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsLineaFact.DOlinea#"   voidNull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsLineaFact.CFid#"	    voidNull>,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rsLineaFact.DDescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rsLineaFact.DDdescalterna#">,
					<cfqueryparam cfsqltype="cf_sql_float"    value="#rsLineaFact.DDcantidad#">,
					<cfqueryparam cfsqltype="cf_sql_float"    value="#rsLineaFact.DDpreciou#">,
					<cfqueryparam cfsqltype="cf_sql_money"    value="#rsLineaFact.DDdesclinea#">,
					0,
					<cfqueryparam cfsqltype="cf_sql_numeric"  value="#rsLineaFact.DDtotallin#" scale="2">,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rsLineaFact.DDtipo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric"  value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rsLineaFact.Icodigo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#rsLineaFact.Ucodigo#"  voidNull>,
					<cfqueryparam cfsqltype="cf_sql_bit"  	  value="#rsLineaFact.DDtransito#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp"  value="#rsLineaFact.DDfembarque#" voidNull>,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rsLineaFact.DDembarque#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#rsLineaFact.DDobservaciones#"   voidNull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#rsLineaFact.ContractNo#"  voidNull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsLineaFact.CFcuenta#" 	  voidNull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsLineaFact.PCGDid#" 	  voidNull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsLineaFact.FPAEid#" 	  voidNull>,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rsLineaFact.CFComplemento#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"  value="#rsLineaFact.OBOid#" 	   voidNull>,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rsLineaFact.codIEPS#">,
                    <cfqueryparam cfsqltype="cf_sql_money"    value="#rsLineaFact.DDMontoIeps#">
				   )
			</cfquery>
			 </cftransaction>

		 </cfloop>

		 <cfquery name="rsTotalLineas" datasource="#session.dsn#">
		   select sum(DDtotallinea) as TotalDet
           from DDocumentosCPR
		   where IDdocumento=  <cfqueryparam cfsqltype="cf_sql_numeric"  value="#LvarIdEDocumento#">
		   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#session.ecodigo#">
		 </cfquery>


		 <cfquery name="rsImpuestoLinea" datasource="#session.dsn#">
		   select sum(case when (a.DStipo = 'S' or a.DStipo = 'A') and (e.afectaIVA = 1 or f.afectaIVA = 1) THEN
            round(a.DDtotallinea * b.Iporcentaje/100,2)
                      when d.IEscalonado = 0 then
            round(a.DDtotallinea * b.Iporcentaje/100,2)
                      else
            round((a.DDtotallinea + round(a.DDtotallinea * COALESCE(d.ValorCalculo/100,0),2)) * b.Iporcentaje/100,2)
                      end) as Impuestos
            from DDocumentosCPR a
		     inner join Impuestos b
			    on a.Icodigo =  b.Icodigo
				and a.Ecodigo =  b.Ecodigo
             left join Impuestos d
                on a.Ecodigo=d.Ecodigo
                and a.codIEPS=d.Icodigo
             left join Conceptos e
                on e.Cid = a.Cid
             left join Articulos f
                on f.Aid= a.Aid
		   where IDdocumento=  <cfqueryparam cfsqltype="cf_sql_numeric"  value="#LvarIdEDocumento#">
		   and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#session.ecodigo#">
		 </cfquery>


         <cfquery name="rsImpuestoIeps" datasource="#session.dsn#">
           select sum(round( a.DDtotallinea * COALESCE(d.ValorCalculo/100,0),2)) as MotoIEPS
            from DDocumentosCPR a
             inner join Impuestos b
                on a.Icodigo = b.Icodigo
                and a.Ecodigo = b.Ecodigo
             left join Impuestos d
                on a.Ecodigo=d.Ecodigo
                and a.codIEPS=d.Icodigo
           where IDdocumento=  <cfqueryparam cfsqltype="cf_sql_numeric"  value="#LvarIdEDocumento#">
           and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#session.ecodigo#">
         </cfquery>


		  <cfquery name="rsUpdate" datasource="#session.dsn#">
		    update EDocumentosCPR
			   set EDtotal    = #rsTotalLineas.TotalDet# + #rsImpuestoLinea.Impuestos# + #rsImpuestoIeps.MotoIEPS#,
			   EDimpuesto     = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#rsImpuestoLinea.Impuestos#" scale="2">,
               EDTiEPS        = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#rsImpuestoLinea.Impuestos#" scale="2">
			where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#rsImpuestoIeps.MotoIEPS#">
		  </cfquery>


	</cfif>
	<script language="javascript1.2" type="text/javascript">
		window.opener.location.reload();
		window.close();
	</script>
</cfif>

<form action="<cfoutput>#URLira#</cfoutput>" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="modoDet" type="hidden" value="<cfif isdefined("modoDet")><cfoutput>#modoDet#</cfoutput></cfif>">
	<input name="tipo" type="hidden" value="<cfoutput>#form.tipo#</cfoutput>">

	<cfif isdefined("rsInsertEDocCP.identity")>
	   	<input name="IDdocumento" type="hidden" value="<cfif isdefined("rsInsertEDocCP.identity")><cfoutput>#rsInsertEDocCP.identity#</cfoutput></cfif>">
	<cfelse>
	   	<input name="IDdocumento" type="hidden" value="<cfif isdefined("Form.IDdocumento") and not isDefined("Form.BorrarE")><cfoutput>#Form.IDdocumento#</cfoutput></cfif>">
	</cfif>

	<cfif isdefined("Form.Linea")>
   		<input name="Linea" type="hidden" value="<cfif isdefined("Form.Linea")><cfoutput>#Form.Linea#</cfoutput></cfif>">
	</cfif>

	<cfif isdefined("Form.SNnumero") and len(trim(form.SNnumero)) and not isdefined("Form.BorrarE")>
   		<input name="SNnumero" type="hidden" value="<cfif isdefined("Form.SNnumero") and len(trim(form.SNnumero))><cfoutput>#Form.SNnumero#</cfoutput></cfif>">
	<cfelse>
		<input name="SNnumero" type="hidden" value="<cfif isdefined("rsSocioN_SQL") and rsSocioN_SQL.recordcount EQ 1><cfoutput>#rsSocioN_SQL.SNnumero#</cfoutput></cfif>">
	</cfif>

	<cfif isdefined("Form.id_direccion") and len(trim(form.id_direccion)) and not isdefined("Form.BorrarE")>
   		<input name="id_direccion" type="hidden" value="<cfif isdefined("Form.id_direccion") and len(trim(form.id_direccion))><cfoutput>#Form.id_direccion#</cfoutput></cfif>">
	<cfelse>
   		<input name="id_direccion" type="hidden" value="<cfif isdefined("rsSocioN_SQL") and rsSocioN_SQL.recordcount EQ 1><cfoutput>#rsSocioN_SQL.id_direccion#</cfoutput></cfif>">
	</cfif>


	<cfif isdefined("Form.SNidentificacion") and len(trim(form.SNidentificacion)) and not isdefined("Form.BorrarE")>
   		<input name="SNidentificacion" type="hidden" value="<cfif isdefined("Form.SNidentificacion") and len(trim(form.SNidentificacion))><cfoutput>#Form.SNidentificacion#</cfoutput></cfif>">
	<cfelse>
   		<input name="SNidentificacion" type="hidden" value="<cfif isdefined("rsSocioN_SQL") and rsSocioN_SQL.recordcount EQ 1><cfoutput>#rsSocioN_SQL.SNidentificacion#</cfoutput></cfif>">
	</cfif>

<!---►►►►►►►►►►APLICAR◄◄◄◄◄◄◄◄◄◄ --->
<cfif isDefined("Form.btnAplicar")>
	<cfset aplicarGenerarPoliza()>
</cfif>
	<!--- NAVEGACION --->
	<cfoutput>
	<input type="hidden" name="fecha" value="<cfif isdefined('form.fecha') and len(trim(form.fecha)) >#form.fecha#</cfif>" />
	<input type="hidden" name="transaccion" value="<cfif isdefined('form.transaccion') and len(trim(form.transaccion))>#form.transaccion#</cfif>" />
	<input type="hidden" name="documento" value="<cfif isdefined('form.documento') and len(trim(form.documento))>#form.documento#</cfif>" />
	<input type="hidden" name="usuario" value="<cfif isdefined('form.usuario') and len(trim(form.usuario))>#form.usuario#</cfif>" />
	<input type="hidden" name="moneda" value="<cfif isdefined('form.moneda') and len(trim(form.moneda))>#form.moneda#</cfif>" />
	<input type="hidden" name="pageNum_lista" value="<cfif isdefined('form.pageNum_lista') >#form.pageNum_lista#</cfif>" />
	<input type="hidden" name="registros" value="<cfif isdefined('form.registros')>#form.registros#</cfif>" />
	<input type="hidden" name="FolioReferencia" value="<cfif isdefined('form.FolioReferencia')>#form.FolioReferencia#</cfif>" />
	</cfoutput>
	<!--- ======================================================================= --->
</form>

<HTML><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>

<cffunction  name="aplicarGenerarPoliza" returntype="void">
    <cfset esCancelacion = false>
	<cfset esDevolucion = false>
	<cfif isDefined("url.esCancelacion")>
		<cfset esCancelacion = true>
	</cfif>
	<cfif isDefined("url.esDevolucion")>
	    <cfset esDevolucion = true>
	</cfif>
	<cfif isDefined("form.esCancelacion")>
		<cfset esCancelacion = true>
	</cfif>
	<cfif isDefined("form.esDevolucion")>
	    <cfset esDevolucion = true>
	</cfif>

	<cfif (NOT ISDEFINED('form.chk') OR NOT LEN(TRIM(form.chk))) AND (ISDEFINED('form.IDdocumento') AND LEN(TRIM(form.IDdocumento)))>
    	<CFSET form.chk = form.IDdocumento>
    </cfif>

	<cfif isdefined("Form.IDdocumento") and len(trim(Form.IDdocumento))>
		<cfparam name="Form.chk" default="#Form.IDdocumento#">
	</cfif>

	<cfif isDefined("Form.chk")>
		<cfset chequeados = ListToArray(Form.chk)>
		<cfset cuantos = ArrayLen(chequeados)>

		<!--- mismo doc.recurrente en varias facturas --->
		<cfquery name="parametroRec" datasource="#session.DSN#">
			select coalesce(Pvalor, '1') as Pvalor
			 from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 880
		</cfquery>
        <cfif NOT parametroRec.RecordCount OR NOT LEN(TRIM(parametroRec.Pvalor))>
			<cfset Msg_ElParam = t.Translate('Msg_ElParam','El parametro')>
			<cfset Msg_NoestaDef = t.Translate('Msg_NoestaDef','no esta definido')>
			<cfset Msg_NoPermMismoDoc = t.Translate('Msg_NoPermMismoDoc','No permitir el mismo doc. recurrente para varias fac. en un mismo período y mes')>
        	<cfthrow message="#Msg_ElParam# '#Msg_NoPermMismoDoc#' #Msg_NoestaDef#">
        </cfif>

		<!--- mes auxiliar --->
		<cfquery name="mes" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 60
		</cfquery>
		<!--- periodo auxiliar --->
		<cfquery name="periodo" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 50
		</cfquery>
		<cfif len(trim(mes.pvalor)) and len(trim(periodo.pvalor))>
			<cfset fecha = createdate(periodo.pvalor, mes.pvalor , 1) >
			<cfset fechaaplic = createdate( periodo.pvalor, mes.pvalor, DaysInMonth(fecha) ) >
		</cfif>

		<cfloop index="CountVar" from="1" to="#cuantos#">
			<cfset valores = ListToArray(chequeados[CountVar],"|")>

			<!--- Valida las garantias, si la factura lo requiere--->
			<cfinvoke component="conavi.Componentes.garantia" method="fnProcesarGarantias" returnvariable="LvarAccion"
				Ecodigo	= "#session.Ecodigo#"
				tipo 	= "C"
				ID		= "#valores[1]#"
			/>

			<cfquery name="rsSQL" datasource="#session.dsn#">
				select
					a.EDdocumento as Ddocumento,
					b.DDcantidad,
					round(b.DDtotallinea * a.EDtipocambio,2)	as TotalLineaUnitLocal,
					b.DOlinea,coalesce(a.EDAdquirir,1) as EDAdquirir,
					Interfaz
				from EDocumentosCPR a
					inner join DDocumentosCPR b
					 on b.IDdocumento = a.IDdocumento
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				  and a.IDdocumento = #valores[1]#
			</cfquery>

			<!---►►Realiza la Aplicación de la factura, adquiere en recepcion de Documentos cuando vienen de una OC de Importacion◄◄--->
			<cfinvoke component="sif.Componentes.CP_PosteoDocumentoRemision" method="PosteoDocumento">
                    <cfinvokeargument name="IDdoc" 	 value="#valores[1]#">
                    <cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">
                    <cfinvokeargument name="usuario" value="#Session.usuario#">
                    <cfinvokeargument name="debug" 	 value="N">
					<cfinvokeargument name="esCancelacion"  value="#esCancelacion#">
					<cfinvokeargument name="esDevolucion"  value="#esDevolucion#">
				<cfif isdefined("rsSQL") AND rsSQL.RecordCount GT 0 AND rsSQL.Interfaz EQ 1>
					<cfinvokeargument name="CalcularImpuestos" 	 value="true">
				</cfif>
			    <cfif NOT rsSQL.EDAdquirir>
                    <cfinvokeargument name="EntradasEnRecepcion" value="true">
                </cfif>
            </cfinvoke>

			<!--- INTERFAZ --->
			<cfquery name="rsDatos" datasource="#Session.Dsn#">
				select CPTcodigo as CXTcodigo, EDdocumento as Ddocumento, SNcodigo
				from EDocumentosCPR
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[1]#">
			</cfquery>
		</cfloop>
	</cfif>
	<cflocation addtoken="no" url="#urlira#?sqlDone=ok#params#">
</cffunction>

<cffunction name="cambiarEncabezado" returntype="void">

	<cfquery name="rsExisteEncab" datasource="#Session.DSN#">
        select count(1) as valor
          from EDocumentosCPR
         where Ecodigo     =  #Session.Ecodigo#
           and CPTcodigo   = <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.CPTcodigo#">
           and EDdocumento = <cfqueryparam cfsqltype="cf_sql_char"    value="#Form.EDdocumento#">
		   and SNcodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
		   and IDdocumento != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
    </cfquery>

	<cfif rsExisteEncab.valor NEQ 0>
        <cfset existe = true> <script>alert("El documento ya existe");</script>
    </cfif>
	<cfif not existe>
		<cf_dbtimestamp
				datasource="#session.dsn#"
				table="EDocumentosCPR"
				redirect="<cfoutput>#URLira#</cfoutput>"
				timestamp="#Form.timestampE#"
				field1="IDdocumento,numeric,#Form.IDdocumento#">

		<cfif isDefined("Form.EDdocref") and Trim(Form.EDdocref) NEQ "">
			<cfquery name="rsE" datasource="#session.dsn#">
				select  EDdocref from EDocumentosCPR where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
			</cfquery>
			<cfif rsE.EDdocref NEQ Trim(Form.EDdocref)>
			    <cfquery name="rsDeleteLineaOrden" datasource="#session.DSN#">
					UPDATE DOrdenCM
					SET DRemisionlinea = null
					FROM DDocumentosCPR dcpr
					INNER JOIN DOrdenCM dorden ON dcpr.linea = dorden.dremisionlinea
					WHERE dcpr.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
				</cfquery>
				<cfquery name="rsborrarLinea" datasource="#session.dsn#">
					delete from DDocumentosCPR where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
				</cfquery>
			</cfif>
		</cfif>
		<cfquery name="rsUpdateEDocCxP" datasource="#session.DSN#">
			update EDocumentosCPR set
				Mcodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
				EDtipocambio = <cfqueryparam cfsqltype="cf_sql_float"   value="#LSParseNumber(Form.EDtipocambio)#">,
				EDdocumento  = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#trim(Form.EDdocumento)#">,
				EDdescuento  = <cfqueryparam cfsqltype="cf_sql_money"   value="#LSParseNumber(Form.EDdescuento)#">,
				EDimpuesto   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LSParseNumber(Form.EDimpuesto)#" scale="2">,
				EDtotal      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LSParseNumber(Form.EDtotal)#"    scale="2">,
				Rcodigo      =
					<cfif isDefined("Form.Rcodigo") and Trim(Form.Rcodigo) NEQ "-1">
						<cfqueryparam cfsqltype="cf_sql_char" value="#trim(listGetAt(form.Rcodigo, 1, '|'))#">,
					<cfelse>
						null,
					</cfif>
				Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
				Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">,
				EDusuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
				EDfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDfecha,'YYYY/MM/DD')#">,
				FolioReferencia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FolioReferencia#">,
				EDdocref =
					<cfif isDefined("Form.EDdocref") and Trim(Form.EDdocref) NEQ "">
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDdocref#">,
					<cfelse>
						null,
					</cfif>
				id_direccion =
					<cfif isdefined("form.id_direccion") and len(trim(form.id_direccion))>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">,
					<cfelse>
						null,
					</cfif>
				<cfif isdefined("Form.EDfechaarribo") and len(trim(Form.EDfechaarribo))>
					EDfechaarribo = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDfechaarribo,'YYYY/MM/DD')#">,
				<cfelse>
					EDfechaarribo = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDfecha,'YYYY/MM/DD')#">,<!--- EDfecha es obigatorio --->
				</cfif>
				TESRPTCid =
				<cfif isdefined("form.TESRPTCid") and len(trim(form.TESRPTCid))>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCid#">,
				<cfelse>
					null,
				</cfif>
				BMUsucodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			,EDvencimiento = <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EDvencimiento,'YYYY/MM/DD')#" voidnull>
			,EDretencionVariable = <cfif form.Rcodigo neq "-1" and listGetAt(form.Rcodigo, 2, '|') gt 0>
										<cfqueryparam cfsqltype="cf_sql_money" value="#LSParseNumber(Form.EDretencionVariable)#">
									<cfelse>
										0
									</cfif>
			<!---- Aqui  agrego  el  timbre --->
			<!--- ,TimbreFiscal  = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="#Form.TimbreFiscal#"> --->
			where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="fnEmail" access="private" returntype="string">
	<cfargument name="Nombre" 		type="string" 	required="yes">
    <cfargument name="EDdocumento" 	type="string" 	required="yes">
    <cfargument name="Lineas" 		type="query" 	required="yes">

    <cfset rsLineasD = Arguments.Lineas>
    <cfsavecontent variable="email_body">
    <html>
        <head>
            <style type="text/css">
                .tituloIndicacion {
                    font-size: 10pt;
                    font-variant: small-caps;
                    background-color: #CCCCCC;
                }
                .tituloListas {
                    font-weight: bolder;
                    vertical-align: middle;
                    padding: 2px;
                    background-color: #F5F5F5;
                }
                body,td {
                    font-size: 12px;
                    background-color: #f8f8f8;
                    font-family: Verdana, Arial, Helvetica, sans-serif;
                }
            </style>
        </head>

		<cfset LB_De = t.Translate('LB_De','De')>
		<cfset Msg_InfRecBodFac = t.Translate('Msg_InfRecBodFac','Le informamos que ya se recibio en bodega la factura')>
		<cfset Msg_SolCC = t.Translate('Msg_SolCC','solicitado por el centro funcional')>
		<cfset Msg_porloSig = t.Translate('Msg_porloSig','por lo siguiente')>
		<cfset LB_Solicitud = t.Translate('LB_Solicitud','Solicitud')>
		<cfset LB_OrdenComp = t.Translate('LB_OrdenComp','Orden Compra')>
		<cfset LB_Cantidad = t.Translate('LB_Cantidad','Cantidad')>
		<cfset Msg_Nota = t.Translate('Msg_Nota','Nota: Favor indicar al personal de inventarios el n&uacute;mero de solicitud de compra, para realizar la recepci&oacute;n del producto.')>

        <body>
            <table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
                <tr>
                    <td colspan="4">
                        <table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
                            <tr>
                                <td nowrap width="6%"><strong>#LB_De#:</strong></td>
                                <td width="94%"><cfoutput>#session.Enombre#</cfoutput></td>
                            </tr>
                            <tr>
                                <td><strong>Sr(a):</strong></td>
                                <td><cfoutput>#Arguments.Nombre#</cfoutput></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr><td>&nbsp;</td></tr>
                <tr><td><table width="100%" border="1">
                	<cfoutput>
                    <tr><td colspan="4">#Msg_InfRecBodFac# #Arguments.EDdocumento#,
                    								#Msg_SolCC# #rsLineasD.CFdescripcion#, #Msg_porloSig#:</td></tr>
                    <tr>
                        <td class="tituloListas"><strong>#LB_Solicitud#</strong></td>
                        <td class="tituloListas"><strong>#LB_OrdenComp#</strong></td>
                        <td class="tituloListas"><strong>#LB_Descripcion#/strong></td>
                        <td class="tituloListas"><strong>#LB_Cantidad#</strong></td>
                    </tr>
                    </cfoutput>
                    <cfloop query="rsLineasD">
                        <tr>
                            <td><cfoutput>#rsLineasD.ESnumero#</cfoutput></td>
                            <td><cfoutput>#rsLineasD.EOnumero#</cfoutput></td>
                            <td><cfoutput>#rsLineasD.Descripcion#</cfoutput></td>
                            <td><cfoutput>#rsLineasD.DOcantidad#</cfoutput></td>
                        </tr>
                    </cfloop>
                    <tr>
              	</tr></table>
                <td colspan="4">&nbsp;</td></tr>
                <cfoutput>
                <tr  ><td colspan="4">#Msg_Nota#
				</td>
                </tr></cfoutput>

            </table>
        </body>
    </html>
	</cfsavecontent>
    <cfreturn email_body>
</cffunction>
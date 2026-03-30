
<cfparam name="modo" default="ALTA">

<!---
	Validador para los casos en que la transaccion se realiza
	desde la opcion de bancos o desde tarjetas de credito. 
 --->

<cfset LvarPagina = "TCECatalogo.cfm">

<cfif not isdefined("Form.Nuevo")>

	<cftry>
			<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2010" default="" returnvariable="InterfazCatalogos"/>
			<cfif isdefined("Form.Alta")>
            	<cftransaction>
                	<cfset validTCE = VALID_TCE(1)>
					<cfset valoresTCE = ALTA_TCE()>
                    <cfset valoresCB = ALTA_CB()>     
                </cftransaction>
                
            	<cfset modo="ALTA">
				
			<cfelseif isdefined("Form.Baja")>			
				<cftransaction>
                    <!--- Verificar que el tipo de Tarjeta no este relacionado con ninguna tarjeta de Credito --->
                    <cfquery name="rsCuentasSQL" datasource="#session.dsn#">
                        select count(1) as cantidad
                        from ECuentaBancaria
                        where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
                        	and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">
                    </cfquery>
                    <cfif rsCuentasSQL.cantidad EQ 0>
                    <!---borrar el tipo de tarjeta--->
                        <cfquery name="CuentasBDetele" datasource="#session.DSN#">
                            delete from CuentasBancos
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                              and CBTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBTCid#">
                              and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
                        </cfquery>
                        
                        <cfquery name="TarjetasCDetele" datasource="#session.DSN#">
                            delete from CBTarjetaCredito
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                              and CBTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBTCid#">
                              and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
                        </cfquery>
                    <cfelse>
                        <cf_errorCode	code = "90210" msg = "La Tarjeta de Cr&eacute;dito seleccionada, esta asociada a un Importador! Proceso Cancelado!">
                    </cfif> 
                </cftransaction>
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Cambio")>
				
                <cftransaction>
                
                <!--- PASO 1: Validar que no se ingresa una misma Tarjeta para un mismo Banco --->
				
				<cfset validTCE = VALID_TCE(2)>
                
				<!--- PASO 2: Eliminar las Cuentas Bancarias cuyas monedas no fueron seleccionadas --->
                
                <cfquery name="rsMonedasBorrar" datasource="#session.DSN#">
                Select Mcodigo
                from CuentasBancos
                where CuentasBancos.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
                  and CuentasBancos.CBTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBTCid#">
                  and CuentasBancos.Mcodigo not in (#form.chkmoneda#)
                  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">                
                </cfquery>
                
                <cfif rsMonedasBorrar.recordcount gt 0>
                
                    <cfloop query="rsMonedasBorrar">
                    
                        <cftry>
                            <cfquery name="DelCtasBancarias" datasource="#session.DSN#">
                                Delete CuentasBancos                    
                                where CuentasBancos.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
                                  and CuentasBancos.CBTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBTCid#">
                                  and CuentasBancos.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedasBorrar.Mcodigo#">
                                  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                            </cfquery>
                        
                            <cfcatch type="database">
                                
                                <!--- Si no se pudo eliminar la cuenta, entonces se actualiza a estado inactivo 
                                
                                Esto debe implementarse a futuro incluyendo un campo de Estado en la tabla: CuentasBancos
                                
                                CBEstado:
                                        0- Inactivo
                                        1- Activo									
                                
                                <cfquery name="DelCtasBancarias" datasource="#session.DSN#">
                                    Update CuentasBancos                    
                                    set CBEstado = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                                    where CuentasBancos.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
                                      and CuentasBancos.CBTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBTCid#">
                                      and CuentasBancos.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarMoneda#">
                                      and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                                </cfquery>                        
                                --->
                                
                            </cfcatch>
                        </cftry>
                        
                    </cfloop>
                
                </cfif>
                
                
                <!--- PASO 3: Insertar Cuentas Bancarias para monedas seleccionadas nuevas --->
                <cfloop list="#form.chkmoneda#" index="LvarMoneda">
                    <cfquery name="rsCuentasNuevas" datasource="#session.DSN#">
                        Select count(1) as total
                        from CuentasBancos a 
                        where a.Bid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
                          and a.CBTCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBTCid#">
                          and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarMoneda#">
                          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">                    
                    </cfquery>
                    <cfif rsCuentasNuevas.total eq 0>
                    	<cfset valoresCB = ALTA_CBU(#LvarMoneda#)>
                    </cfif>
                </cfloop>
              
				<!--- PASO 4: Actualizar Cuentas Bancarias cuyas monedas fueron seleccionadas ---> 
                <cfloop list="#form.chkmoneda#" index="LvarMoneda">
                	<cfquery name="rsSelectMoneda1" datasource="#session.DSN#">
                        select Mcodigo, Miso4217 
                        from Monedas 
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                        and Mcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarMoneda#">
                    </cfquery>
                    
					<cfset descripcion1 = #Form.CBdescripcion#>
                    <cfset descrip1_= "#rsSelectMoneda1.Miso4217# #descripcion1#"> 
                                          >
                    <cfquery name="CuentasBUpdate" datasource="#session.DSN#">
                        update CuentasBancos set
                            Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">,
                            Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
                            Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarMoneda#">,
                            Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">,
                            Ccuentacom = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentacom#" null="#Len(Trim(Form.Ccuentacom)) eq 0#">,
							Ccuentaint = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentaint#" null="#Len(Trim(Form.Ccuentaint)) eq 0#">,
							<cfif isdefined("form.chkCuentaTCE")>
								CFormatoTCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Cmayor_CFformato#-#Form.CFFORMATO#">,
							<cfelse>
								CFormatoTCE = null,
							</cfif>
							CBcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBTarjeta#">,
                            CBdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#descrip1_#">,
                            CBcc = null,
                            CBidioma = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CBidioma#">,
                            EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#" null="#Len(Form.EIid) eq 0#">
                            <cfif LEN(TRIM(InterfazCatalogos)) and InterfazCatalogos EQ 1>
                            ,CBclave=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBclave#">
                            ,CBcodigoext=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBcodigoext#">
                            </cfif>
                            ,CcuentaintPag =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentaintpag#" null="#Len(Trim(Form.Ccuentaintpag)) eq 0#">
                        where 
                          CBTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBTCid#">
                          and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                          and Mcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarMoneda#">   
                    </cfquery>
               </cfloop>
                
               <cf_dbtimestamp datasource="#session.dsn#"
			 			table="CBTarjetaCredito"
			 			redirect="TCECatalogo.cfm"
			 			timestamp="#form.ts_rversion#"
						field1="CBTCid" 
						type1="numeric" 
						value1="#form.CBTCid#"
						>
				 <cfquery name="CuentasTCpdate" datasource="#session.DSN#">
                 	update CBTarjetaCredito set
                    	Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">,
                        CBTCDescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBdescripcion#">,
                        CBTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value=" #Form.TipoTarjeta#">,
                        CBSTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Status#">,
                        DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">,
                        CBTCfechainico = <cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(Form.fechaIV)#">,
                        CBTCfechacorte = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fechaCorte#">,
                        CBTCfechacancelacion = <cfif isdefined('Form.fechaCancelacion') and LEN(Form.fechaCancelacion) GT 0>
                                                    <cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(Form.fechaCancelacion)#">,
                                                <cfelse>
                                                    null,
                                                </cfif>
                        CBTCfechapago = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fechaPago#">,
                        CBTCfechavencimiento = <cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(Form.fechaVencimiento)#">,
                        EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#" null="#Len(Form.EIid) eq 0#">,
                        CBTNumTarjeta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBTarjeta#">,
                        CBTMid = <cfif isdefined('Form.MarcaTarjeta') and LEN(Form.MarcaTarjeta) GT 0>
                               		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MarcaTarjeta#">
                                <cfelse>
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="null">
                                </cfif>
					where CBTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBTCid#">
                    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
				</cfquery>
                </cftransaction>
                
				<cfset modo="CAMBIO">								  				  
			</cfif>			
		<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
<cfelse>
	<cfset modo="ALTA">		
</cfif>

<!--- Funcion de ALTA para Tarjetas de Credito --->
<cffunction name="ALTA_TCE" access="public" returntype="numeric">
    <cfset LvarEIid = "null">
	<cfif isdefined('Form.EIid') and LEN(Form.EIid) GT 0>
        <cfset LvarEIid = Form.EIid>
    </cfif> 
	<cfquery name="TarjetaCreInsert" datasource="#session.DSN#">
    insert into CBTarjetaCredito (Bid, CBTCDescripcion, CBTTid, CBSTid, DEid, CBTCfechainico, CBTCfechacorte, 
                                  CBTCfechacancelacion, CBTCfechapago, CBTCfechavencimiento, EIid, Ecodigo, CBTNumTarjeta, CBTMid) 
    values (
        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBdescripcion#">,
        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TipoTarjeta#">,
        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Status#">,
        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(Form.fechaIV)#">,
        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fechaCorte#">,
        <cfif isdefined('Form.fechaCancelacion') and LEN(Form.fechaCancelacion) GT 0>
            <cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(Form.fechaCancelacion)#">,
        <cfelse>
            null,
        </cfif>
        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fechaPago#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(Form.fechaVencimiento)#">,
        <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEIid#" null="#LvarEIid eq 'null'#">
        ,<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBTarjeta#">
        ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MarcaTarjeta#">
    )
    <cf_dbidentity1 datasource="#session.DSN#">				
    </cfquery>
    <cf_dbidentity2 datasource="#session.DSN#" name="TarjetaCreInsert">
    <cfset Request.key = TarjetaCreInsert.identity >
	<cfreturn Request.key>
</cffunction>

<cffunction name="ALTA_CB" access="public" returntype="boolean">
		<cfset LvarEIid = "null">
        <cfif isdefined('Form.EIid') and LEN(Form.EIid) GT 0>
            <cfset LvarEIid = Form.EIid>
        </cfif>
		<cfset LvarCcuentacom = "null">
		<cfif isDefined("Form.Ccuentacom") and Len(Trim(Form.Ccuentacom)) GT 0>
            <cfset LvarCcuentacom = Form.Ccuentacom>                
        </cfif>
        <cfset LvarCcuentaint = "null">
        <cfif isDefined("Form.Ccuentaint") and Len(Trim(Form.Ccuentaint)) GT 0>
             <cfset LvarCcuentaint = Form.Ccuentaint>
        </cfif>
         
        <cfset LvarCBclave = "null">
        <cfset LvarCBcodigoext = "null">                
        <cfif LEN(TRIM(InterfazCatalogos)) and InterfazCatalogos EQ 1>
            <cfset LvarCBclave = Form.CBclave>
            <cfset LvarCBcodigoext = Form.CBcodigoext>
        </cfif>
        <cfif isDefined("Form.CBTCid") and Len(Trim(Form.CBTCid)) GT 0>
            <cfset LvarCBTCid = Form.CBTCid>
        <cfelse>
        	<cfset LvarCBTCid = #Request.key#>
        </cfif>
        
	<cfloop list="#form.chkmoneda#" index="LvarMoneda">
            <cfquery name="rsSelectMoneda" datasource="#session.DSN#">
            	select Mcodigo, Miso4217 
                from Monedas 
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and Mcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarMoneda#">
            </cfquery>
            
            <cfset descripcion = #Form.CBdescripcion#>
            <cfset descrip_= "#rsSelectMoneda.Miso4217# #descripcion#">
            
            <cfquery name="CuentasBInsert" datasource="#session.DSN#">
            insert into CuentasBancos (CBTCid, Bid, Ecodigo, Ocodigo, Mcodigo, Ccuenta, Ccuentacom, Ccuentaint, CBcodigo, CBdescripcion, 
                                       CBcc, CBTcodigo, CBdato1, CBidioma, EIid, CBesTCE,CBclave,CBcodigoext,CcuentaintPag,CFormatoTCE) 
            values (
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCBTCid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarMoneda#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCcuentacom#" null="#LvarCcuentacom eq 'null'#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCcuentaint#" null="#LvarCcuentaint eq 'null'#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBTarjeta#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#descrip_#">,
                null,
                <cfqueryparam cfsqltype="cf_sql_integer" value="3">,
                null,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CBidioma#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEIid#" null="#LvarEIid eq 'null'#">
                ,<cfqueryparam cfsqltype="cf_sql_numeric" value="1">
                ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCBclave#">
                ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCBcodigoext#">
                ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentaintpag#" null="#Len(Trim(Form.Ccuentaintpag)) eq 0#">
                <cfif isdefined("form.chkCuentaTCE")>
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Cmayor_CFformato#-#Form.CFFORMATO#">
				<cfelse>
					,null
				</cfif>
            )
            </cfquery>
    </cfloop> 
    <cfreturn true>
</cffunction>


<cffunction name="ALTA_CBU" access="public" returntype="boolean">
		<cfargument name="LvarMoneda" type="numeric" required="no" default="-1">
		
        <cfquery name="rsSelectMoneda2" datasource="#session.DSN#">
            select Mcodigo, Miso4217 
            from Monedas 
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            and Mcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LvarMoneda#">
      	</cfquery>
            
        <cfset descripcion2 = #Form.CBdescripcion#>
        <cfset descrip2_= "#rsSelectMoneda2.Miso4217# #descripcion2#">
            
		<cfif LvarMoneda eq -1>
			<cfreturn true>            
        </cfif>

		<cfset LvarEIid = "null">
        <cfif isdefined('Form.EIid') and LEN(Form.EIid) GT 0>
            <cfset LvarEIid = Form.EIid>
        </cfif>
		<cfset LvarCcuentacom = "null">
		<cfif isDefined("Form.Ccuentacom") and Len(Trim(Form.Ccuentacom)) GT 0>
            <cfset LvarCcuentacom = Form.Ccuentacom>                
        </cfif>
        <cfset LvarCcuentaint = "null">
        <cfif isDefined("Form.Ccuentaint") and Len(Trim(Form.Ccuentaint)) GT 0>
             <cfset LvarCcuentaint = Form.Ccuentaint>
        </cfif>
         
        <cfset LvarCBclave = "null">
        <cfset LvarCBcodigoext = "null">                
        <cfif LEN(TRIM(InterfazCatalogos)) and InterfazCatalogos EQ 1>
            <cfset LvarCBclave = Form.CBclave>
            <cfset LvarCBcodigoext = Form.CBcodigoext>
        </cfif>
        <cfif isDefined("Form.CBTCid") and Len(Trim(Form.CBTCid)) GT 0>
            <cfset LvarCBTCid = Form.CBTCid>
        <cfelse>
        	<cfset LvarCBTCid = #Request.key#>
        </cfif>
        
       <cfquery name="CuentasBInsert" datasource="#session.DSN#">
        insert into CuentasBancos (CBTCid, Bid, Ecodigo, Ocodigo, Mcodigo, Ccuenta, Ccuentacom, Ccuentaint, CBcodigo, CBdescripcion, 
                                   CBcc, CBTcodigo, CBdato1, CBidioma, EIid, CBesTCE,CBclave,CBcodigoext,CcuentaintPag,CFormatoTCE) 
        values (
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCBTCid#">,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LvarMoneda#">,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">,
            
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCcuentacom#" null="#LvarCcuentacom eq 'null'#">,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCcuentaint#" null="#LvarCcuentaint eq 'null'#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBTarjeta#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#descrip2_#">,
            null,
            <cfqueryparam cfsqltype="cf_sql_integer" value="3">,
            null,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CBidioma#">,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEIid#" null="#LvarEIid eq 'null'#">
            ,<cfqueryparam cfsqltype="cf_sql_numeric" value="1">
            ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCBclave#">
            ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCBcodigoext#">
            ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentaintpag#" null="#Len(Trim(Form.Ccuentaintpag)) eq 0#">
			<cfif isdefined("form.chkCuentaTCE")>
				,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Cmayor_CFformato#-#Form.CFFORMATO#">
			<cfelse>
				,null
			</cfif>
        )
        </cfquery> 
    <cfreturn true>
</cffunction>
<!--- Funcion para validar que no se ingrese una misma Tarjeta para un mismo Banco --->
<cffunction name="VALID_TCE" access="public">
	<cfargument name="tipo" type="numeric" required="no" default="1">
	<cfset var = false>
	<cfif Arguments.tipo eq 2>
        <cfquery name="TarjetaCreSelect2" datasource="#session.DSN#">
            select * 
            from CBTarjetaCredito 
            where CBTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBTCid#">
                and CBTNumTarjeta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBTarjeta#">
                and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
        </cfquery>
        <cfif TarjetaCreSelect2.recordcount gt 0>
        	<cfset var = true>
        </cfif>
    </cfif>
    <cfif not var>
        <cfquery name="TarjetaCreSelect" datasource="#session.DSN#">
            select * 
            from CBTarjetaCredito 
            where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
                and CBTNumTarjeta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CBTarjeta#">
        </cfquery>
        <cfif TarjetaCreSelect.recordcount gt 0>
            <cf_errorCode	code = "90211" msg = "No se puede ingresar la misma tarjeta para el mismo Banco! Proceso Cancelado!">	
        </cfif>
    </cfif>
</cffunction>

<form action="<cfoutput>#LvarPagina#</cfoutput><cfif isdefined('url.desde') and Trim(url.desde) eq 'rh'>?desde=rh</cfif>" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">

	<cfif modo neq 'ALTA'>
		<input name="CBid" type="hidden" value="<cfif isdefined("Form.CBid")><cfoutput>#Form.CBid#</cfoutput></cfif>">
        <input name="CBTCid" type="hidden" value="<cfif isdefined("Form.CBTCid")><cfoutput>#Form.CBTCid#</cfoutput></cfif>">
	</cfif>
    
	<input name="Bid" type="hidden" value="<cfif isdefined("Form.Bid")><cfoutput>#Form.Bid#</cfoutput></cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">	
	<input name="desde" type="hidden" value="<cfif isdefined("form.desde")><cfoutput>#form.desde#</cfoutput></cfif>">
</form>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>


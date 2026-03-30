<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>

<!--- Maximos digitos para el numero del doc de recepcion --->
<cfquery name="rsMaxDig" datasource="#session.DSN#">
	select Pvalor
	 from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="720">
</cfquery>			

<cfparam name="action" default="EDocumentosI.cfm">

<cffunction name="TCHistorico" output="true" returntype="numeric" access="public">
	<cfargument name='Conexion' type='string' 	required='false'>
	<cfargument name='Mcodigo' 	type="numeric" 	required="yes">
    <cfargument name="Ecodigo" 	type="numeric"	required="no">
	
	<cfif not isdefined("arguments.Conexion")>
		<cfset arguments.Conexion = session.DSN>
	</cfif>
    <cfif NOT isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
		<cfset Arguments.Ecodigo = session.Ecodigo>
    </cfif>
	<cfset TCHist = 0>

	<cfquery name="rsTiposCambio" datasource="#arguments.Conexion#">
		select coalesce(TCventa,0.00) as TCventa
		from Htipocambio a
		where Ecodigo  = <cfqueryparam value="#Arguments.Ecodigo#" cfsqltype="cf_sql_integer">
		  and Mcodigo  = <cfqueryparam value="#Arguments.Mcodigo#" cfsqltype="cf_sql_numeric">
		  and Hfecha  >= <cf_dbfunction name="now">
		  and Hfechah <  <cf_dbfunction name="now">
	</cfquery>
	
	<cfif isdefined('rsTiposCambio') and rsTiposCambio.recordCount GT 0 and rsTiposCambio.TCventa GT 0>
		<cfset TCHist = rsTiposCambio.TCventa>
	</cfif>

	<cfreturn TCHist>
</cffunction>

<!---►►Reversar las Facturas de Importación◄◄--->
<cfif isdefined("form.btnReversar")>
	<cftransaction>
        <!---►►Elimina Facturas de Gasto por Item◄◄--->
        <cfquery datasource="#session.dsn#">
            delete from FacturasGastoItem 
            where FPid in (select FPid 
                            from FacturasPoliza 
                           where DDlinea in (select DDlinea 
                                                from DDocumentosI 
                                             where EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDIid#">))
        </cfquery>
        <!---►►Elimina CM Impuestos por Póliza◄◄--->
        <cfquery datasource="#session.dsn#">
         delete from CMImpuestosItem 
          where DDlinea in (select DDlinea 
                                            from DDocumentosI 
                                         where EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDIid#">)
		</cfquery>
        <!---►►Elimina Facturas por Póliza◄◄--->
        <cfquery datasource="#session.dsn#">
        	delete from FacturasPoliza 
            where DDlinea in (select DDlinea 
            					from DDocumentosI 
                              where EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDIid#">)
        </cfquery>
        <!---►►CM Impuestos por Póliza◄◄--->
        <cfquery datasource="#session.dsn#">
        	delete from CMImpuestosPoliza 
            where DDlinea in (select DDlinea 
            					from DDocumentosI 
                              where EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDIid#">)
        </cfquery>
        <!---►►Vuelve a poner en Digitacion el Documento de Importación◄◄--->
        <cfquery datasource="#session.dsn#">
        	update EDocumentosI 
            	set EDIestado = 0 
            where EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDIid#">
        </cfquery>
    </cftransaction>
<!---►►AGREGA EL ENCABEZADO DE LA FACTURA DEL REGISTRO DE TRANSACCIONES(EDocumentosI)◄◄--->
<cfelseif not isdefined("form.btnNuevoE")>
		<cfif isdefined("form.btnAgregarE")>
			<cfif isdefined('rsMaxDig') and rsMaxDig.recordCount GT 0 and rsMaxDig.Pvalor NEQ ''>
				<cfset numDoc = RepeatString('0', rsMaxDig.Pvalor - (Len(Trim(form.Ddocumento)))) & Trim(form.Ddocumento)>
            <cfelse>
                <cfset numDoc = Trim(form.Ddocumento)>
            </cfif>
           <cfquery name="valInsert" datasource="#session.DSN#">
				select 1
				from EDocumentosI
				where Ecodigo	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char"	value="#numDoc#">
				  and SNcodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
				union
				select 1
				 from EDocumentosI
				where Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" 	value="-#numDoc#">
				  and SNcodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">				  
			</cfquery>
			
			<cfif valInsert.recordCount GT 0>
				<cf_errorCode	code = "50297" msg = "El código de la factura ya existe para esta empresa y para este socio de negocio, favor digitar uno distinto.">
			</cfif>
            
				<cftransaction>
					
					<cfquery name="insert_EDIid" datasource="#session.DSN#" >
						insert into EDocumentosI 
						(Ecodigo, Ddocumento, EDItipo, Mcodigo, EDItc, SNcodigo, EOidorden, CPcodigo, EDIfecha, EDIfechaarribo, EDobservaciones, EDIimportacion, Usucodigo, fechaalta, EDIestado, EPDid, EDIidRef, BMUsucodigo, Ocodigo, CPTcodigo)
						values (
							<cfqueryparam value="#session.Ecodigo#" 	cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#numDoc#"  			cfsqltype="cf_sql_char">, 
							<cfqueryparam value="#form.EDItipo#"  		cfsqltype="cf_sql_char">, 
							<cfqueryparam value="#form.Mcodigo#" 		cfsqltype="cf_sql_numeric">, 
							<cfqueryparam value="#form.EDItc#" 	cfsqltype="cf_sql_float">, 
							<cfqueryparam value="#form.SNcodigo#" 		cfsqltype="cf_sql_integer">, 
							 <cfif isdefined('form.EOidorden') and form.EOidorden NEQ ''>
								 <cfqueryparam value="#form.EOidorden#" cfsqltype="cf_sql_numeric">,
							 <cfelse>
								null,
							 </cfif>						
							<cfqueryparam value="#form.CPcodigo#" cfsqltype="cf_sql_char">,
							<cfqueryparam value="#LSParseDateTime(form.EDIfecha)#" cfsqltype="cf_sql_timestamp">, 
                            <cfqueryparam value="#LSParseDateTime(form.EDIfechaarribo)#" cfsqltype="cf_sql_timestamp">, 
							<cfqueryparam value="#form.EDobservaciones#" cfsqltype="cf_sql_varchar">, 
							 1,
							<cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">, 
							<cf_dbfunction name='now'>, 
							 <cfif isdefined('form.EPDid_DP') and form.EPDid_DP NEQ ''>
								0,
								 <cfqueryparam value="#form.EPDid_DP#" cfsqltype="cf_sql_numeric">
							 <cfelse>
								 0,
								null
							 </cfif>,
							 <cfif isdefined('form.EDIidref') and len(trim(form.EDIidref))>
							 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDIidref#">,
							 <cfelse>
							 	null,
							 </cfif>
							 <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
                             <cfqueryparam value="#form.Ocodigo#" cfsqltype="cf_sql_integer">,
                             <cfqueryparam value="#form.CPTcodigo#" cfsqltype="cf_sql_char">
							)
						<cf_dbidentity1 datasource="#session.DSN#">
					</cfquery>	
					<cf_dbidentity2 datasource="#session.DSN#" name="insert_EDIid">

				</cftransaction>
				
				<cfset modo="CAMBIO">
			
		<cfelseif isdefined("form.btnAplicar")>
			<cfset trackingsGenerados = "">
			
			<cfif isdefined("form.chk") and form.chk NEQ ''>
				<cfloop list="#form.chk#" index="pkEDIid">
					<cfinvoke component="AplicaDocumentosI" method="aplicarTransaccion" returnvariable="trackingGenerado">
						<cfinvokeargument name="EDIid" 		 value="#pkEDIid#"/>
						<cfinvokeargument name="ParamAction" value="#action#"/>
					</cfinvoke>
					
					<cfif trackingsGenerados eq "">
						<cfset trackingsGenerados = trackingGenerado>
					<cfelse>
						<cfset trackingsGenerados = trackingsGenerados & ",#trackingGenerado#">
					</cfif>
				</cfloop>
			<cfelse>
				<cfinvoke component="AplicaDocumentosI" method="aplicarTransaccion" returnvariable="trackingGenerado">
					<cfinvokeargument name="EDIid"       value="#form.EDIid#"/>
					<cfinvokeargument name="ParamAction" value="#action#"/>
				</cfinvoke>
				
				<cfset trackingsGenerados = trackingGenerado>
			</cfif>

			<cfset modo="ALTA">
			<cfif trackingsGenerados eq "">
				<cfset action = 'EDocumentos-lista.cfm'>
			<cfelse>
				<cfset action = 'EDocumentos-lista.cfm?ImprimirTG=1&ListaTG=#trackingsGenerados#'>
			</cfif>
		</cfif>
			
		<!--- Caso 2: Borrar un Encabezado de factura --->
		<cfif isdefined("form.btnBorrarE")>
			<cftransaction>
				<cfquery name="delete" datasource="#session.DSN#">
					delete from DDocumentosI
					where EDIid = <cfqueryparam value="#form.EDIid#" cfsqltype="cf_sql_numeric">
					  and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				</cfquery>
						
				<cfquery name="deleted" datasource="#session.DSN#">
					delete from EDocumentosI
					where EDIid = <cfqueryparam value="#form.EDIid#" cfsqltype="cf_sql_numeric">
					  and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">	  
				</cfquery>
			</cftransaction>

			<cfset modo="ALTA">
			<cfset action = 'EDocumentos-lista.cfm' >
		</cfif>
		
		<!--- Caso 3: Modificar encabezado de DocumentosI --->  
		<cfif isdefined("form.btnModificar")>
			<cfquery name="valActual" datasource="#session.DSN#">
				select Ddocumento
				from EDocumentosI
				where Ecodigo=<cfqueryparam value="#session.Ecodigo#" 	cfsqltype="cf_sql_integer">
					and SNcodigo=<cfqueryparam value="#form.SNcodigo#" 	cfsqltype="cf_sql_integer">
					and EDIid=<cfqueryparam value="#form.EDIid#" 		cfsqltype="cf_sql_numeric">
			</cfquery>		
			
			<cfif isdefined('rsMaxDig') and rsMaxDig.recordCount GT 0 and rsMaxDig.Pvalor NEQ ''>
				<cfset numDoc = RepeatString('0', rsMaxDig.Pvalor - (Len(Trim(form.Ddocumento)))) & Trim(form.Ddocumento)>
			<cfelse>
				<cfset numDoc = Trim(form.Ddocumento)>
			</cfif>			
			
			<cfquery name="valInsert" datasource="#session.DSN#">
				select 1
				from EDocumentosI
				where Ecodigo=<cfqueryparam value="#session.Ecodigo#" 				cfsqltype="cf_sql_integer">
					and Ddocumento=<cfqueryparam value="#numDoc#" 					cfsqltype="cf_sql_char">
					and SNcodigo=<cfqueryparam value="#form.SNcodigo#" 				cfsqltype="cf_sql_integer">					
					and Ddocumento <> <cfqueryparam value="#valActual.Ddocumento#" 	cfsqltype="cf_sql_char">
			</cfquery>
			
			<!--- Validacion para verificar que no existan "Ddocumento" repetidos por Ecodigo --->			
			<cfif valInsert.recordCount EQ 0>
				<cf_dbtimestamp datasource="#session.dsn#"
								table="EDocumentosI"
								redirect="#action#"
								timestamp="#form.ts_rversion#"
								field1="EDIid" 
								type1="numeric" 
								value1="#form.EDIid#"
								field2="Ecodigo" 
								type2="integer" 
								value2="#session.Ecodigo#" >
				<cftransaction>			
					<cfquery name="update" datasource="#session.DSN#">
						update EDocumentosI set
							 Ddocumento=<cfqueryparam value="#numDoc#" cfsqltype="cf_sql_char">, 
							 EDItipo=<cfqueryparam value="#form.EDItipo#" cfsqltype="cf_sql_char">, 
							 Mcodigo=<cfqueryparam value="#form.Mcodigo#" cfsqltype="cf_sql_numeric">, 
							 EDItc=<cfqueryparam value="#form.EDItc#" cfsqltype="cf_sql_float">,
							 SNcodigo=<cfqueryparam value="#form.SNcodigo#" cfsqltype="cf_sql_integer">,
							 <cfif isdefined('form.EOidorden') and form.EOidorden NEQ ''>
								 EOidorden=<cfqueryparam value="#form.EOidorden#" cfsqltype="cf_sql_numeric">,
							<cfelse>
								EOidorden=null,
							 </cfif>
							 CPcodigo		 = <cfqueryparam cfsqltype="cf_sql_char"		value="#form.CPcodigo#" >,
							 EDIfecha		 = <cfqueryparam cfsqltype="cf_sql_timestamp"	value="#LSParseDateTime(form.EDIfecha)#" >,
                             EDIfechaarribo		 = <cfqueryparam cfsqltype="cf_sql_timestamp"	value="#LSParseDateTime(form.EDIfechaarribo)#" >,
							 EDobservaciones = <cfqueryparam cfsqltype="cf_sql_varchar"	 	value="#form.EDobservaciones#" >,
                             Ocodigo 		 = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#form.Ocodigo#">,
                             CPTcodigo 	 	 = <cfqueryparam cfsqltype="cf_sql_char" 		value="#form.CPTcodigo#">
						where EDIid=<cfqueryparam value="#form.EDIid#" cfsqltype="cf_sql_numeric">
					</cfquery>				
				</cftransaction>				
			<cfelse>
				<cf_errorCode	code = "50298" msg = "El código de la factura ya existe para esta empresa y para este socio de negocios, favor digitar uno distinto.">
				<cfset modo="ALTA">
			</cfif>

			<cfset modo="CAMBIO">
		</cfif>	

		<cfif isdefined("Form.btnNuevoD")>
		
			<cfset modo="CAMBIO">
        <!---►►AGREGA LOS DETALLES DE LA FACTURA DEL REGISTRO DE TRANSACCIONES DDocumentosI◄◄--->
		<cfelseif isdefined("Form.btnAgregarD") or (isdefined("Form.btnAgregar2") and form.btnAgregar2 EQ 1)>
			
			<cfquery name="selIDIconsecutivo" datasource="#session.DSN#">
				Select (coalesce(max(DDIconsecutivo), 0) + 1) as maxDDIconsec
				from DDocumentosI 
				where EDIid=<cfqueryparam value="#form.EDIid#" cfsqltype="cf_sql_numeric">
					and Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">						
			</cfquery>
			<cfif isdefined('selIDIconsecutivo') and selIDIconsecutivo.recordCount GT 0>
				<cftransaction>
					<cfif isdefined('form.DDIafecta') and form.DDIafecta NEQ '3'>
						<cfquery name="insert_DDlinea" datasource="#session.DSN#">
							insert into DDocumentosI 
							(DDIconsecutivo, EDIid, Ecodigo, DOlinea, Icodigo, DDIcantidad, DDItipo, Cid, Aid, DDIpreciou, cantidadrestante, montorestante, DDItotallinea, CFcuenta, DDIafecta, Usucodigo, fechaalta, ETidtracking, EPDid, DDIporcdesc)
							values ( 
								<cfqueryparam value="#selIDIconsecutivo.maxDDIconsec#" cfsqltype="cf_sql_numeric">,
								<cfqueryparam value="#form.EDIid#" cfsqltype="cf_sql_numeric">, 
								<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">, 
								<cfif isdefined('form.DOlinea') and form.DOlinea NEQ ''>
									<cfqueryparam value="#form.DOlinea#" cfsqltype="cf_sql_numeric">, 
								<cfelse>
									null,
								</cfif>
								<cfif isdefined('form.DDIafecta') and form.DDIafecta EQ '5'>
									<cfqueryparam value="#form.Icodigo#" cfsqltype="cf_sql_char">,
								<cfelse>
									null,
								</cfif>
								<cfqueryparam value="#form.DDIcantidad#" cfsqltype="cf_sql_float">, 
								<cfqueryparam value="#form.DDItipo#" cfsqltype="cf_sql_char">, 
								<cfif isdefined('form.DDItipo') and form.DDItipo NEQ 'A' and isdefined('form.Cid') and form.Cid NEQ '' >
									<cfqueryparam value="#form.Cid#" cfsqltype="cf_sql_numeric">, 
								<cfelse>
									null,
								</cfif>					
								<cfif isdefined('form.DDItipo') and form.DDItipo NEQ 'S' and isdefined('form.Aid') and form.Aid NEQ '' >
									<cfqueryparam value="#form.Aid#" cfsqltype="cf_sql_numeric">, 
								<cfelse>
									null,
								</cfif>	 
								#LvarOBJ_PrecioU.enCF(replace(form.DDIpreciou,',','','all'))#,
								#LvarOBJ_PrecioU.enCF(replace(form.DDIpreciou,',','','all'))#,
								<cfqueryparam value="#replace(form.DDItotallinea,',','','all')#" cfsqltype="cf_sql_money">,   
								<cfqueryparam value="#replace(form.DDItotallinea,',','','all')#" cfsqltype="cf_sql_money">,   
								<cfif isdefined('form.CFcuenta') and form.CFcuenta NEQ ''>
									<cfqueryparam value="#form.CFcuenta#" cfsqltype="cf_sql_numeric">, 
								<cfelse>
									null,
								</cfif>
								<cfqueryparam value="#form.DDIafecta#" cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">, 
								<cf_dbfunction name="now">,
								<cfif isdefined('form.ETidtracking_move1') and len(trim(form.ETidtracking_move1))>
									<cfqueryparam value="#form.ETidtracking_move1#" cfsqltype="cf_sql_numeric">,
								<cfelse>
									null,
								</cfif>				
								<!--- Impuestos y Gastos --->
								<cfif isdefined('form.DDIafecta') and (form.DDIafecta eq '1' or form.DDIafecta eq '2' or form.DDIafecta EQ '4' or form.DDIafecta EQ '5')>
									<cfif isdefined('form.EPDid') and form.EPDid NEQ ''><!--- Para Impuestos es requerido--->
										<cfqueryparam value="#form.EPDid#" cfsqltype="cf_sql_numeric">
									<cfelseif isdefined('form.EPDid_DP') and form.EPDid_DP NEQ ''>
										<!--- Para cuando se ha hecho un ALTA de detalle cuando se lleg[o a la pagina de facturas desde la pagina de Polizas --->
										<cfqueryparam value="#form.EPDid_DP#" cfsqltype="cf_sql_numeric">
									<cfelse>
										null									
									</cfif>
								<cfelse>
									null
								</cfif>	
								,<cfif isdefined("form.DDIporcdescTMP") and len(trim(form.DDIporcdescTMP)) and isdefined("form.DDIporcdesc")and len(trim(form.DDIporcdesc))>
									<cfif form.DDIporcdescTMP GT form.DDIporcdesc>
										<cfqueryparam value="#replace(form.DDIporcdescTMP,',','','all')#" cfsqltype="cf_sql_float">
									<cfelse>
										<cfqueryparam value="#replace(form.DDIporcdesc,',','','all')#" cfsqltype="cf_sql_float">									
									</cfif>
								<cfelse>
									0
								</cfif>												
								)
							<cf_dbidentity1 datasource="#session.DSN#">				
						</cfquery>
						<cf_dbidentity2 datasource="#session.DSN#" name="insert_DDlinea">
					</cfif>	<!--- Afecta --->
				</cftransaction>
			</cfif>
		<cfelseif isdefined("Form.btnModificarD")>
			<cftransaction>
				<cf_dbtimestamp datasource="#session.dsn#"
								table="DDocumentosI"
								redirect="#action#"
								timestamp="#form.ts_rversionDet#"
								field1="EDIid" 
								type1="numeric" 
								value1="#form.EDIid#"
								field2="Ecodigo" 
								type2="integer" 
								value2="#session.Ecodigo#" 
								field3="DDlinea" 
								type3="numeric" 
								value3="#form.DDlinea#">
	
				<cfquery name="update" datasource="#session.DSN#">
					update DDocumentosI set
							<cfif isdefined('form.DOlinea') and form.DOlinea NEQ ''>
								DOlinea=<cfqueryparam value="#form.DOlinea#" cfsqltype="cf_sql_numeric">, 
							<cfelse>
								DOlinea=null,							
							</cfif>
							<cfif isdefined('form.DDIafecta') and form.DDIafecta EQ '5'>
								Icodigo=<cfqueryparam value="#form.Icodigo#" cfsqltype="cf_sql_char">,  
							<cfelse>
								Icodigo=null,
							</cfif>
							<cfif isdefined("form.Cid") and (form.DDIafecta eq '1' or form.DDIafecta eq '2' or form.DDIafecta eq '4')>
								Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">,
							<cfelse>
								Cid = null,
							</cfif>
							<cfif isdefined("form.Ucodigo") and len(trim(form.Ucodigo)) gt 0>
								Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ucodigo#">,
							<cfelse>
								Ucodigo = null,
							</cfif>
							DDIcantidad	= <cfqueryparam value="#form.DDIcantidad#" cfsqltype="cf_sql_float">, 
							DDIpreciou		 = #LvarOBJ_PrecioU.enCF(replace(form.DDIpreciou,',','','all'))#,
							cantidadrestante = #LvarOBJ_PrecioU.enCF(replace(form.DDIpreciou,',','','all'))#,
							montorestante=<cfqueryparam value="#replace(form.DDItotallinea,',','','all')#" cfsqltype="cf_sql_money">,   
							DDItotallinea=<cfqueryparam value="#replace(form.DDItotallinea,',','','all')#" cfsqltype="cf_sql_money">,   
							<cfif isdefined('form.CFcuenta') and form.CFcuenta NEQ ''>
								CFcuenta=<cfqueryparam value="#form.CFcuenta#" cfsqltype="cf_sql_numeric">, 
							<cfelse>
								CFcuenta=null,
							</cfif>	
							Usucodigo=<cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
							<cfif isdefined('form.DDIobs') and form.DDIobs NEQ ''>
								DDIobs=<cfqueryparam value="#form.DDIobs#" cfsqltype="cf_sql_varchar">,
							<cfelse>
								DDIobs=null,
							</cfif>			
							<cfif isdefined('form.ETidtracking_move1') and len(trim(form.ETidtracking_move1))>
								ETidtracking=<cfqueryparam value="#form.ETidtracking_move1#" cfsqltype="cf_sql_numeric">,
							<cfelse>
								ETidtracking=null,
							</cfif>
							<!--- Impuestos y Gastos --->
							<cfif isdefined('form.DDIafecta') and (form.DDIafecta eq '1' or form.DDIafecta eq '2' or form.DDIafecta EQ '4' or form.DDIafecta EQ '5')>
								<cfif isdefined('form.EPDid') and form.EPDid NEQ ''><!--- Para Impuestos es requerido--->
									EPDid=<cfqueryparam value="#form.EPDid#" cfsqltype="cf_sql_numeric">
								<cfelseif isdefined('form.EPDid_DP') and form.EPDid_DP NEQ ''>
									<!--- Para cuando se ha hecho un ALTA de detalle cuando se lleg[o a la pagina de facturas desde la pagina de Polizas --->
									EPDid=<cfqueryparam value="#form.EPDid_DP#" cfsqltype="cf_sql_numeric">
								<cfelse>
									EPDid=null									
								</cfif>
							<cfelse>
								EPDid=null
							</cfif>	
							,DDIporcdesc = 
								<cfif isdefined("form.DDIporcdescTMP") and len(trim(form.DDIporcdescTMP)) and isdefined("form.DDIporcdesc")and len(trim(form.DDIporcdesc))>
									<cfif form.DDIporcdescTMP GT form.DDIporcdesc>
										<cfqueryparam value="#replace(form.DDIporcdescTMP,',','','all')#" cfsqltype="cf_sql_float">
									<cfelse>
										<cfqueryparam value="#replace(form.DDIporcdesc,',','','all')#" cfsqltype="cf_sql_float">									
									</cfif>
								<cfelse>
									0
								</cfif>		
					where DDlinea=<cfqueryparam value="#form.DDlinea#" cfsqltype="cf_sql_numeric">
				</cfquery>		
			</cftransaction>		

			<cfset modo="CAMBIO">
		<!--- Elimina linea de detalle --->
		<cfelseif isdefined("form.btnBorrarD")>
			<cftransaction>		
				<cfquery datasource="#session.DSN#">
					delete from DDocumentosI
					where DDlinea = <cfqueryparam value="#form.DDlinea#" cfsqltype="cf_sql_numeric">
				</cfquery>
			</cftransaction>		
		</cfif>
</cfif>

<cfoutput>

<form action="#action#" method="post" name="sql">
	<cfif not isdefined('form.btnNuevoE')>
		<input name="EDIid" type="hidden" value="<cfif isdefined("form.EDIid") and len(trim(form.EDIid))>#form.EDIid#<cfelseif isdefined("insert_EDIid")>#insert_EDIid.identity#</cfif>">
	</cfif>
	
	<cfif not isdefined('form.btnNuevoD') and not isdefined('form.btnBorrarD') and isdefined("form.DDlinea") and len(trim(form.DDlinea))>
		<input name="DDlinea" type="hidden" value="#form.DDlinea#">		
	</cfif>
	
	<cfif isdefined('form.EPDid_DP')>
		<input type="hidden" name="EPDid_DP" value="#Form.EPDid_DP#">	
		<cfif isdefined("form.btnBorrarE")>
			<cfset action = "polizaDesalmacenaje.cfm?EPDid=#form.EPDid_DP#">		
		</cfif>
	</cfif>	

	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>


<cfcomponent>
	<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
	<!--- 1 Métodos para inicializar y cambiar el contexto del componente --->
	<!--- 1.1 Init: define los valores de las variables globales del componente. --->
	<cffunction name="init" access="public" returntype="boolean">
		<cfargument name="Conexion" required="no" type="string" default="#Session.Dsn#">
		<cfargument name="Ecodigo" required="no" type="numeric" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">
		<cfif not isdefined("Request.CM_InterfazRecepcion.Initialized")>
			<cfset Request.CM_InterfazSolicitudes.Initialized = true>
			<cfset Request.CM_InterfazSolicitudes.GvarConexion = Arguments.Conexion>
			<cfset Request.CM_InterfazSolicitudes.GvarEcodigo = Arguments.Ecodigo>	
			<cfset Request.CM_InterfazSolicitudes.GvarUsucodigo = Arguments.Usucodigo>
			<cfset Request.CM_InterfazSolicitudes.GvarFecha = Arguments.Fecha>	
		</cfif>
		<cfreturn true>
	</cffunction>

	<!--- 2 Métodos para actualizar la base de datos de SIF --->
	<!--- 2.1 Alta de una recepción validando la integridad de los datos de entrada
		Respeta las siguientes reglas de las recepciones de compras:
			2.1.1 EDRid es autonumérico.
			2.1.2 EDRnumero se calcula.
			2.1.3 Guarda el Ecodigo definido para el componente.
			2.1.4 Guarda el Usucodigo y la fechaalta definidos para el componente.
			2.1.5 Guarda EDRestado en 0
			2.1.6 Requiere los datos:
				 TDRcodigo (Tipo Documento Recepción), 
				 Mcodigo (Moneda), 
				 EDRtc (Tipo de Cambio), 
				 Aid (Almacén), 
				 CFid (Centro Funcional), 
				 CPTcodigo (CPTransaccion), 
				 EDRfechadoc (Fecha de Dcomento), 
				 EDRfecharec (Fecha de Recepción), 
				 EDRreferencia (Documento de Referencia), 
				 EDRdescpro (Total Descuento), 
				 EDRimppro (Total Impuestos), 
				 EDRobs (Observaciones), 
				 EDRperiodo (Periodo), 
				 EDRmes (Mes),
				 EOnumero (NumeroOrdenCompra),
				 SNcodigo (Socio de Negocios).
				 
		 	2.1.7 Otros campos de la tabla, no tomados en cuenta en este insert: 
				EPDid (Poliza de Desalmacenaje),
				idBL.
	--->
	<cffunction name="validaImp_EDocumentosRecepcion" access="public" returntype="numeric">
		<cfargument name="EOnumero" type="string" required="true">
		<cfargument name="DOconsecutivo" type="string" required="true">	
		<cfargument name="DDRcantrec" type="string" required="true">
		<cfargument name="DDRpreciou" type="string" required="true">
				
		<cfset var LEOidorden = getEOidordenbyEOnumero(getNumeric(Arguments.EOnumero,'NumeroOrdenCompra','validaImp_EDocumentosRecepcion'),'validaImp_EDocumentosRecepcion')>
		<cfset var contImpuestos = 0>		
		<cfset var totLinea = 0>	
		
		<cfif not IsNumeric(Arguments.DDRcantrec)>
			<cfthrow message="validaImp_EDocumentosRecepcion: El valor del parámetro Cantidad Requerida es inválido. Proceso Cancelado!">
		</cfif>		
		<cfif not IsNumeric(Arguments.DDRpreciou)>
			<cfthrow message="validaImp_EDocumentosRecepcion: El valor del parámetro Precio Unitario es inválido. Proceso Cancelado!">
		</cfif>		
						
		<cfset totLinea = Arguments.DDRcantrec * Arguments.DDRpreciou>
		
		<cfquery name="rsImp" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select a.EOnumero, b.DOconsecutivo, a.Impuesto, a.EOdesc, c.Iporcentaje, coalesce(round(sum(<cfqueryparam cfsqltype="cf_sql_numeric" value="#totLinea#">*c.Iporcentaje/100),4),0) as DDRimplin
			from EOrdenCM a 
                            left outer join DOrdenCM b 
                                    left outer join Impuestos c 
                                        on c.Icodigo = b.Icodigo 
                                            and c.Ecodigo = b.Ecodigo 
                            on a.EOidorden = b.EOidorden 
                             and a.Ecodigo = b.Ecodigo
			where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
			  and a.EOidorden=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LEOidorden#">
			  and b.DOconsecutivo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DOconsecutivo#">			  
   			group by a.EOnumero, b.DOconsecutivo,a.Impuesto,  c.Iporcentaje, a.EOdesc					
		</cfquery>
		
		<cfloop query="rsImp">
			<cfset contImpuestos = contImpuestos + DDRimplin>	
		</cfloop>

		<cfreturn contImpuestos>
	</cffunction>	
	
	
	<cffunction name="Alta_EDocumentosRecepcion" access="public" returntype="query">
		<cfargument name="TDRcodigo" type="string" required="yes">
		<cfargument name="Miso" type="string" required="true">
		<cfargument name="EDRtc" type="string" required="true">
		<cfargument name="Almcodigo" type="string" required="true">
		<cfargument name="CFcodigo" type="string" required="true">
		<cfargument name="CPTcodigo" type="string" required="true">
		<cfargument name="EDRfechadoc" type="string" required="true">
		<cfargument name="EDRfecharec" type="string" required="true">
		<cfargument name="EDRreferencia" type="string" required="true">
		<cfargument name="EDRdescpro" type="string" required="true">
		<cfargument name="EDRimppro" type="string" required="true">
		<cfargument name="EDRobs" type="string" required="true">
		<cfargument name="EDRperiodo" type="string" required="true">
		<cfargument name="EDRmes" type="string" required="true">
		<cfargument name="EOnumero" type="string" required="true">
		<cfargument name="SNnumero" type="string" required="true">
		<cfset var LEDRnumero = 0>
		<cfset var LTDRcodigo = getTDRcodigo_vIntegridad(Arguments.TDRcodigo,'Alta_EDocumentosRecepcion')>
		<cfset var LMcodigo = getMcodigobyMiso(Arguments.Miso,'Alta_EDocumentosRecepcion')>
		<cfset var LEDRtc = gettipocambio_vIntegridad(LMcodigo,Arguments.EDRtc,'Alta_EDocumentosRecepcion')>
		<cfset var LCPTcodigo = getCPTcodigo_vIntegridad(Arguments.CPTcodigo,'Alta_EDocumentosRecepcion')>
		<cfset var LEDRperiodo = getEDRperiodo_vIntegridad(getNumeric(Arguments.EDRperiodo,'NumeroDocRecepcion','Alta_EDocumentosRecepcion'),'Alta_EDocumentosRecepcion')>
		<cfset var LEDRmes = getEDRmes_vIntegridad(getNumeric(Arguments.EDRmes, 'Mes','Alta_EDocumentosRecepcion'),'Alta_EDocumentosRecepcion')>
		<cfset var LEOidorden = getEOidordenbyEOnumero(getNumeric(Arguments.EOnumero,'NumeroOrdenCompra','Alta_EDocumentosRecepcion'),'Alta_EDocumentosRecepcion')>
		<cfset var LSNcodigo = getSNcodigobySNnumero(Arguments.SNnumero,'Alta_EDocumentosRecepcion')>
	
		<cfset LAlm_Aid = 0>
		<cfset LCFid = 0>

		<cfif len(trim(Arguments.Almcodigo))>
			<cfset LAlm_Aid = getAlm_AidbyAlmcodigo(Arguments.Almcodigo,'Alta_EDocumentosRecepcion')>
		</cfif>
		<cfif len(trim(Arguments.CFcodigo))>
			<cfset LCFid = getCFidbyCFcodigo(Arguments.CFcodigo,'Alta_EDocumentosRecepcion')>
		</cfif>
		<cfif LAlm_Aid EQ 0 and LCFid EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoCentroFuncional no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		
		<cflock scope="application" timeout="10">
			<cfset LEDRnumero = getNextEDRnumero()>
			<cfquery datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
				insert into EDocumentosRecepcion
					(Ecodigo, TDRcodigo, Mcodigo, EDRtc, 
					Aid, CFid, CPTcodigo, EDRnumero, SNcodigo, 
					EDRfechadoc, EDRfecharec, EDRreferencia, EDRdescpro, 
					EDRimppro, EDRobs, EDRperiodo, EDRmes, EOidorden, 
					Usucodigo, BMUsucodigo, fechaalta, EDRestado)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#LTDRcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LMcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_float" value="#LEDRtc#">, 
					<cfif LAlm_Aid EQ 0>
						null,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LAlm_Aid#">, 
					</cfif>
					<cfif LCFid EQ 0>
						null,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LCFid#">, 
					</cfif>				
					<cfqueryparam cfsqltype="cf_sql_char" value="#LCPTcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#LEDRnumero#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#LSNcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.EDRfechadoc#">, 
					<cfif isdefined('Arguments.EDRfecharec') and Arguments.EDRfecharec NEQ ''>
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.EDRfecharec#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.EDRfechadoc#">,
					</cfif>
					<cfif isdefined('Arguments.EDRreferencia') and Arguments.EDRreferencia NEQ ''>
						<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.EDRreferencia#">, 
					<cfelse>
						null, 
					</cfif>
					<cfif isdefined('Arguments.EDRdescpro') and Arguments.EDRdescpro NEQ ''>
						<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.EDRdescpro#">,
					<cfelse>
						0, 
					</cfif>				
					<cfif isdefined('Arguments.EDRimppro') and Arguments.EDRimppro NEQ ''>
						<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.EDRimppro#">,
					<cfelse>
						0, 
					</cfif>		
					<cfif isdefined('Arguments.EDRobs') and Arguments.EDRobs NEQ ''>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EDRobs#">,
					<cfelse>
						null, 
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#LEDRperiodo#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#LEDRmes#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LEOidorden#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CM_InterfazSolicitudes.GvarUsucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CM_InterfazSolicitudes.GvarUsucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#Request.CM_InterfazSolicitudes.GvarFecha#">,
					0
				)
			</cfquery>
			
			<cfquery name="rsObtieneNumeroEDRid" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
				select max(EDRid) as LEDRnumero
				from EDocumentosRecepcion
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">	
				  and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LEOidorden#">
			</cfquery>

			<cfset LEDRnumero = rsObtieneNumeroEDRid.LEDRnumero>

			<!--- Actualizar el numero de Documento si no concuerda con el que se grabo en la Base de Datos --->
			<cfquery datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
					update EDocumentosRecepcion
					set EDRnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#LEDRnumero#">
					where EdocumentosRecepcion.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LEDRnumero#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
					  and EDRnumero <> <cfqueryparam cfsqltype="cf_sql_char" value="#LEDRnumero#">
			</cfquery>		

			<cfquery name="result" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
				select EDRid, Ecodigo, TDRcodigo, Mcodigo, EDRtc, 
					Aid, CFid, CPTcodigo, EDRnumero, 
					EDRfechadoc, EDRfecharec, EDRdescpro, 
					EDRimppro, EDRobs, EDRperiodo, EDRmes,
					Usucodigo, BMUsucodigo, fechaalta, EDRestado
				  from EDocumentosRecepcion
				 where EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LEDRnumero#">
					<!---
				   and EDRnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#LEDRnumero#">
				   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
				   --->
			</cfquery>
		</cflock>

		<cfreturn result>
	</cffunction>
	<!--- 2.2 Alta de una recepción validando la integridad de los datos de entrada
		Respeta las siguientes reglas de las recepciones de compras:
			2.2.1 
			2.2.2 Requiere los datos:
				EDRid, 
				Ucodigo, 
				EOnumero, 
				DOconsecutivo, 
				DDRtipoitem, 
				Aid, 
				Cid, 
				DDRcantrec, 
				DDRpreciou, 
				DDRdesclinea.
				
		 	2.2.3 Otros campos de la tabla, tomados en cuenta en este insert, pero no requeridos: 
				DDRcantorigen, 
				DDRcantreclamo, 
				DDRprecioorig, 
				DDRtotallin, 
				DDRcostopro, 
				DDRcostototal.
				
			2.2.3 Otros campos de la tabla, NO tomados en cuenta en este insert: 				
				DDRobsreclamo, 
				DDRgenreclamo.
				
	--->
	<cffunction name="Alta_DDocumentosRecepcion" access="public" returntype="query">
		<cfargument name="EDRid" type="string" required="true">
		<cfargument name="Ucodigo" type="string" required="true">
		<cfargument name="EOnumero" type="string" required="true">
		<cfargument name="DOconsecutivo" type="string" required="true">
		<cfargument name="DDRtipoitem" type="string" required="true">
		<cfargument name="Acodigo" type="string" required="true">
		<cfargument name="Ccodigo" type="string" required="true">
		<cfargument name="DDRcantrec" type="string" required="true">
		<cfargument name="DDRpreciou" type="string" required="true">
		<cfargument name="DDRdesclinea" type="string" required="true">
		<cfargument name="DDRtotallin" type="string" required="true">
		<cfset var LEDRid = getEDRid_vIntegridad(getNumeric(Arguments.EDRid,'NumeroDocRecepcion','Alta_DDocumentosRecepcion'),'Alta_DDocumentosRecepcion')>
		<cfset var LUcodigo = getUcodigo_vIntegridad(Arguments.Ucodigo,'Alta_DDocumentosRecepcion')>
		<cfset var LDOlinea = getDOlineabyOL(getNumeric(Arguments.EOnumero,'NumeroOrdenCompra','Alta_DDocumentosRecepcion'),
											getNumeric(Arguments.DOconsecutivo,'LineaOrdenCompra','Alta_DDocumentosRecepcion'),
											'Alta_DDocumentosRecepcion')>
		<cfset var LDDRtipoitem = getDDRtipoitem_vIntegridad(Arguments.DDRtipoitem,'Alta_DDocumentosRecepcion')>
		<cfset var LDDRcantrec = getPositive_vIntegridad(Arguments.DDRcantrec,Arguments.EOnumero,Arguments.DOconsecutivo,'Alta_DSolicitudCompraCM')>
		<cfset var LDDRpreciou = Arguments.DDRpreciou>
		<cfset var LDDRdesclinea = Arguments.DDRdesclinea>
		<cfset var LDDRtotallin = Arguments.DDRtotallin>
		
		  <!--- si no viene el precio unitario --->
		<cfif (isdefined('LDDRtotallin') and len(LDDRtotallin) GT 0) and (len(LDDRpreciou) EQ 0 or LDDRpreciou EQ 0.00)>
			<cfif LDDRcantrec GT 0>
				<cfset LDDRpreciou = LDDRtotallin / LDDRcantrec>
			</cfif>
		</cfif>


		<cfif LDDRpreciou EQ '' or LDDRpreciou EQ 0>
			<cfthrow message="Alta_DDocumentosRecepcion: El precio unitario debe ser mayor que cero. Proceso Cancelado!">
		</cfif>
		<cfif LDDRdesclinea EQ ''>
			<cfset LDDRdesclinea = 0>
		</cfif>
		
		<cfset LDDRtotallin = getDDRtotallin_vIntegridad(Arguments.DDRtotallin,LDDRcantrec,LDDRpreciou,LDDRdesclinea,'Alta_DSolicitudCompraCM')>
		<cfswitch expression="#LDDRtipoitem#">
		<cfcase value="A">
			<cfset LAid = getAidbyAcodigo(Arguments.Acodigo,'Alta_DSolicitudCompraCM')>
		</cfcase>
		<cfcase value="S">
			<cfset LCid = getCidbyCcodigo(Arguments.Ccodigo,'Alta_DSolicitudCompraCM')>
		</cfcase>
		</cfswitch>
		<cfquery datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			insert into DDocumentosRecepcion
				(EDRid, Ecodigo, 
				Ucodigo, DOlinea, DDRtipoitem, 
				<cfswitch expression="#LDDRtipoitem#">
				<cfcase value="A">
					Aid, 
				</cfcase>
				<cfcase value="S">
					Cid, 
				</cfcase>
				</cfswitch>
				DDRcantrec, DDRcantorigen, DDRcantreclamo, 
				DDRpreciou, DDRprecioorig, DDRdesclinea, 
				DDRtotallin, DDRcostopro, DDRcostototal, 
				Usucodigo, BMUsucodigo, fechaalta)
			values
				(<cfqueryparam cfsqltype="cf_sql_numeric" value="#LEDRid#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#LUcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#LDOlinea#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#LDDRtipoitem#">, 
				<cfswitch expression="#LDDRtipoitem#">
				<cfcase value="A">
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LAid#">, 
				</cfcase>
				<cfcase value="S">
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LCid#">, 
				</cfcase>
				</cfswitch>
				<cfqueryparam cfsqltype="cf_sql_money" value="#LDDRcantrec#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#LDDRcantrec#">, 
				0.00, 
				#LvarOBJ_PrecioU.enCF(LDDRpreciou)#,
				#LvarOBJ_PrecioU.enCF(LDDRpreciou)#,
				<cfqueryparam cfsqltype="cf_sql_money" value="#LDDRdesclinea#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#LDDRtotallin#">, 
				0.00, 
				0.00, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CM_InterfazSolicitudes.GvarUsucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Request.CM_InterfazSolicitudes.GvarUsucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#Request.CM_InterfazSolicitudes.GvarFecha#">)
		</cfquery>
		<cfquery name="result" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select EDRid, Ecodigo, DDRlinea, 
				Ucodigo, DOlinea, DDRtipoitem, Aid, Cid, 
				DDRcantrec, DDRcantorigen, DDRcantreclamo, 
				#LvarOBJ_PrecioU.enSQL_AS("DDRpreciou")#, 
				#LvarOBJ_PrecioU.enSQL_AS("DDRprecioorig")#, 
				DDRdesclinea, 
				DDRtotallin, DDRcostopro, DDRcostototal, 
				Usucodigo, BMUsucodigo, fechaalta
			from DDocumentosRecepcion
			where EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LEDRid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfreturn result>
	</cffunction>

	<!--- 2.3 Baja de una Recepcion. --->
	<cffunction name="Baja_DDocumentosRecepcion" access="public" returntype="boolean">
		<cfargument name="EDRnumero" type="string" required="true">
		<cfset var LEDRid = getEDRidbyEDRnumero(getNumeric(Arguments.EDRnumero,'NumeroDocRecepcion','Baja_DDocumentosRecepcion'),'Baja_DDocumentosRecepcion')>
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select EDRid
			from EDocumentosRecepcion
			where EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LEDRid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="La Recepción #Arguments.ESidsolicitud# (NumeroRecepcion) no puede ser eliminada, porque no existe en la Base de Datos."/>
		</cfif>
		<cfquery datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			delete DDocumentosRecepcion
			where EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LEDRid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfquery datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			delete EDocumentosRecepcion
			where EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LEDRid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfreturn true>
	</cffunction>
	<cffunction access="private" name="getNextEDRnumero" output="false" returntype="numeric">
		<!--- No se hace con EDRnumero porque EDRnumero es char --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select coalesce(max(EDRid),0)+1 as next
			from EDocumentosRecepcion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfreturn rs.next>
	</cffunction>
	<cffunction access="private" name="getEDRidbyEDRnumero" output="false" returntype="numeric">
		<cfargument name="EDRnumero" type="numeric" required="yes">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select EDRid
			from EDocumentosRecepcion
			where rtrim(EDRnumero) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.EDRnumero)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro NumeroDocRecepcion no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.EDRid>
	</cffunction>
	<cffunction access="private" name="getEDRid_vIntegridad" output="false" returntype="numeric">
		<cfargument name="EDRid" type="numeric" required="yes">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select EDRid
			from EDocumentosRecepcion
			where EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EDRid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro NumeroDocRecepcion no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.EDRid>
	</cffunction>
	<cffunction access="private" name="getCFidbyCFcodigo" output="false" returntype="numeric">
		<cfargument name="CFcodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select CFid
			from CFuncional
			where CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CFcodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoCentroFuncional no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.CFid>		
	</cffunction>
	<cffunction access="private" name="getMcodigobyMiso" output="false" returntype="string">
		<cfargument name="Miso" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select Mcodigo
			from Monedas
			where Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.Miso)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoMoneda no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.Mcodigo>
	</cffunction>
	<cffunction access="private" name="gettipocambio_vIntegridad" output="false" returntype="numeric">
		<cfargument name="Mcodigo" required="yes" type="numeric">
		<cfargument name="tipocambio" required="yes" type="numeric">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<!--- Obtiene la moneda local, si la moneda es la moneda local, entonces valida que el tipo de cambio sea 1, sino valida que sea mayor que 0 --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select round(<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.tipocambio#">,4) as tipocambio
			from Empresas 
			where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 1 and Arguments.tipocambio neq 1.00>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro TipoCambio es incorrecto porque para la Moneda Local debe ser siempre 1.00. Proceso Cancelado!">
		<cfelseif rs.RECORDCOUNT EQ 0 and Arguments.tipocambio lte 0.00>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro TipoCambio es incorrecto porque debe ser siempre mayor que 0.00. Proceso Cancelado!">
		<cfelseif rs.RECORDCOUNT EQ 0 >
			<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
				select round(<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.tipocambio#">,4) as tipocambio
				from dual
			</cfquery>
		</cfif>
		<cfreturn rs.tipocambio>
	</cffunction>
	<cffunction access="private" name="getAlm_AidbyAlmcodigo" output="false" returntype="numeric">
		<cfargument name="Almcodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select Aid
			from Almacen
			where Almcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.Almcodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoAlmacen no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.Aid>
	</cffunction>
	<cffunction access="private" name="getTDRcodigo_vIntegridad" output="false" returntype="string">
		<cfargument name="TDRcodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select TDRcodigo
			from TipoDocumentoR
			where TDRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.TDRcodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro TipoDocumento no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.TDRcodigo>
	</cffunction>
	<cffunction access="private" name="getCPTcodigo_vIntegridad" output="false" returntype="string">
		<cfargument name="CPTcodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select CPTcodigo
			from CPTransacciones
			where CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CPTcodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoTransaccion no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.CPTcodigo>
	</cffunction>
	<cffunction access="private" name="getEOidordenbyEOnumero" output="false" returntype="numeric">
		<cfargument name="EOnumero" required="yes" type="numeric">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select EOidorden
			from EOrdenCM a
			where EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOnumero#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro NumeroOrdenCompra no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.EOidorden>
	</cffunction>
	<cffunction access="private" name="getSNcodigobySNnumero" output="false" returntype="numeric">
		<cfargument name="SNnumero" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select SNcodigo
			from SNegocios a
			where SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SNnumero#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoProveedor no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.SNcodigo>
	</cffunction>
	<cffunction access="private" name="getDOlineabyOL" output="false" returntype="numeric">
		<cfargument name="EOnumero" required="yes" type="numeric">
		<cfargument name="DOconsecutivo" required="yes" type="numeric">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select b.DOlinea
			from EOrdenCM a 
				inner join DOrdenCM b 
					on b.EOidorden = a.EOidorden 
					and b.DOconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DOconsecutivo#">
			where a.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOnumero#">
			  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor de los parámetros NumeroOrdenCompra Y LineaOrdenCompra no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.DOlinea>
	</cffunction>
	<cffunction access="private" name="getEDRperiodo_vIntegridad" output="false" returntype="numeric">
		<cfargument name="EDRperiodo" required="yes" type="numeric">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select Pvalor
			from Parametros
			where Pcodigo = 50
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0 
			OR (rs.RECORDCOUNT GT 0 AND NOT IsNumeric(rs.Pvalor)) 
			OR (rs.RECORDCOUNT GT 0 AND IsNumeric(rs.Pvalor) AND Arguments.EDRperiodo LT rs.Pvalor)>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro Periodo es inválido. Proceso Cancelado!">
		</cfif>
		<cfreturn Arguments.EDRperiodo>
	</cffunction>
	<cffunction access="private" name="getEDRmes_vIntegridad" output="false" returntype="numeric">
		<cfargument name="EDRmes" required="yes" type="numeric">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select Pvalor
			from Parametros
			where Pcodigo = 60
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0 
			OR (rs.RECORDCOUNT GT 0 AND NOT IsNumeric(rs.Pvalor)) 
			OR (rs.RECORDCOUNT GT 0 AND IsNumeric(rs.Pvalor) AND Arguments.EDRmes LT rs.Pvalor)>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro Mes es inválido. Proceso Cancelado!">
		</cfif>
		<cfreturn Arguments.EDRmes>
	</cffunction>
	<cffunction access="private" name="getNotNull_vIntegridad" output="false" returntype="string">
		<cfargument name="Value" required="yes" type="string">
		<cfargument name="Name" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfif len(trim(Arguments.Value)) EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro #Arguments.Name# es Requerido y no puede ser vacío. Proceso Cancelado!">
		</cfif>
		<cfreturn trim(Arguments.Value)>
	</cffunction>
	<cffunction access="private" name="getPositive_vIntegridad" output="false" returntype="string">
		<cfargument name="Value" required="yes" type="numeric">		<!--- Cantidad Recibida --->
		<cfargument name="EOnumero" required="yes" type="string">		
		<cfargument name="DOconsecutivo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		
		<cfif not IsNumeric(Arguments.EOnumero)>
			<cfthrow message="getPositive_vIntegridad: El valor del parámetro Numero de Orden de Compra es inválido. Proceso Cancelado!">
		</cfif>		
		<cfif not IsNumeric(Arguments.DOconsecutivo)>
			<cfthrow message="getPositive_vIntegridad: El valor del parámetro Numero de linea de la O.C es inválido. Proceso Cancelado!">
		</cfif>				
		
		<cfif len(trim(Arguments.Value)) EQ 0 OR Arguments.Value LTE 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro Cantidad Recibida es Requerido y debe ser mayor que 0. Proceso Cancelado!">
		<cfelse>
			<cfquery name="rsSaldo" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
				select  (b.DOcantidad - b.DOcantsurtida) as Saldo
				from EOrdenCM a 
								left outer join DOrdenCM b 
								on a.EOidorden = b.EOidorden 
								 and a.Ecodigo = b.Ecodigo
				where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
				  and a.EOnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOnumero#">
				  and b.DOconsecutivo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DOconsecutivo#">
			</cfquery>		

			<cfif Arguments.Value GT rsSaldo.Saldo>
				<cfthrow message="getPositive_vIntegridad: El saldo de la Orden de Compra es menor que la Cantidad Recibida (EOnumero-- #Arguments.EOnumero#  -*- DOconsecutivo -- #Arguments.DOconsecutivo#). Proceso Cancelado!">
			</cfif>
		</cfif>
				
		<cfreturn trim(Arguments.Value)>
	</cffunction>
	<cffunction access="private" name="getDDRtipoitem_vIntegridad" output="false" returntype="string">
		<cfargument name="DDRtipoitem" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfif NOT (Arguments.DDRtipoitem EQ 'A' OR Arguments.DDRtipoitem EQ 'S')>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro TipoItem no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn trim(Arguments.DDRtipoitem)>
	</cffunction>
	<cffunction access="private" name="getAidbyAcodigo" output="false" returntype="string">
		<cfargument name="Acodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select Aid
			from Articulos
			where Acodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.Acodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoArtiulo no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.Aid>
	</cffunction>
	<cffunction access="private" name="getCidbyCcodigo" output="false" returntype="string">
		<cfargument name="Ccodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select Cid
			from Conceptos
			where Ccodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.Ccodigo)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoServicio no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.Cid>
	</cffunction>
	<cffunction access="private" name="getUcodigo_vIntegridad" output="false" returntype="string">
		<cfargument name="Ucodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			select Ucodigo
			from Unidades
			where Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ucodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro CodigoUnidadMedida no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.Ucodigo>
	</cffunction>
	<cffunction access="private" name="getDDRtotallin_vIntegridad" output="false" returntype="string">
		<cfargument name="DDRtotallin" required="false" type="string">
		<cfargument name="DDRcantrec" required="yes" type="numeric">
		<cfargument name="DDRpreciou" required="yes" type="numeric">
		<cfargument name="DDRdesclinea" required="yes" type="numeric">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfset valRet = 0>

		<cfif isdefined('Arguments.DDRtotallin') and Arguments.DDRtotallin NEQ ''>
			<cfif not isNumeric(Arguments.DDRtotallin)>
				<cfthrow message="#Arguments.InvokerName#: El valor del parámetro #Arguments.DDRtotallin# debe ser Numérico. Proceso Cancelado!">
			<cfelse>
				<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
					select round(<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.DDRtotallin#">,2) as DDRtotallin
					from dual
					where round(<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.DDRtotallin#">,2) = 
						round(
						  (
							<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.DDRcantrec#">
							*
							<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.DDRpreciou#">
						  )
						  -
						  (
							<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.DDRdesclinea#">
						  )
						,2)
				</cfquery>			
				<cfif rs.RECORDCOUNT EQ 0>
					<cfthrow message="#Arguments.InvokerName#: El valor del parámetro TotalLinea es Inválido, debe ser iagual a '(CantidadRecibida * PrecioUnitario) - DescuentoLinea'. Proceso Cancelado!">		
				<cfelse>
					<cfset valRet = rs.DDRtotallin>				
				</cfif>
			</cfif>		
		<cfelse>
			<cfquery name="rs" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
				select round(
					  (
						<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.DDRcantrec#">
						*
						<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.DDRpreciou#">
					  )
					  -
					  (
						<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.DDRdesclinea#">
					  )
					,2) as DDRtotallin
				from dual
			</cfquery>			
			
			<cfset valRet = rs.DDRtotallin>		
		</cfif>
		
		<cfreturn valRet>
	</cffunction>
	
	<cffunction access="private" name="getNumeric" output="false" returntype="numeric">
		<cfargument name="Value" required="yes" type="string">
		<cfargument name="Name" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfif not isNumeric(Arguments.Value)>
			<cfthrow message="#Arguments.InvokerName#: El valor del parámetro #Arguments.Name# debe ser Numérico. Proceso Cancelado!">
		</cfif>
		<cfreturn Arguments.Value>
	</cffunction>
	
	<!--- Aplicacion de una Recepcion. --->
	<cffunction name="Aplica_Recepcion" access="public" returntype="numeric">
		<cfargument name="numOrdenC" required="yes" type="numeric">
		<cfargument name="DOconsec" required="yes" type="numeric">
		<cfargument name="uMedida" required="yes" type="string">		
		<cfargument name="llaveEdocum" required="yes" type="numeric">		
		<cfargument name="tipoDoc" required="yes" type="string">				
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->	
			
		<cfquery name="rsTipo" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
			Select TDRtipo
			from TipoDocumentoR
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
				and TDRcodigo= <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.tipoDoc#">	
		</cfquery>

		<cfif isdefined('rsTipo') and rsTipo.recordCount GT 0>
			<!--- Afectacion de Orden de Compra--->
			<cfquery datasource="#session.DSN#" name="dataOrden">
				select DDRlinea, DOlinea, DDRcantorigen, DDRgenreclamo,Ucodigo, DDRcantrec
				from DDocumentosRecepcion
				where EDRid=<cfqueryparam value="#Arguments.llaveEdocum#" cfsqltype="cf_sql_numeric">
				  and Ecodigo=<cfqueryparam value="#Request.CM_InterfazSolicitudes.GvarEcodigo#" cfsqltype="cf_sql_integer">
			</cfquery>				
			
			<cfquery name="rsOrden" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
				Select DOlinea, Ucodigo
				from DOrdenCM
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
					and EOnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.numOrdenC#">
					and DOconsecutivo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DOconsec#">
			</cfquery>
			
			<cfif isdefined('rsOrden') and rsOrden.recordCount GT 0>
				<cfif isdefined('dataOrden') and dataOrden.recordCount GT 0>
					<cfloop query="dataOrden">
						<cfif dataOrden.DDRcantorigen lte 0 >
							<cfset Request.Error.Backs = 1 >
							<cfthrow message="Error al aplicar documento de Recepci&oacute;n.<br>Existen l&iacute;neas del documento con cantidades en cero.">
						</cfif>			

						<!--- Calculo del factor de conversion --->
						<cfset factor = 0 >
						<cfif Arguments.uMedida EQ rsOrden.Ucodigo>
							<cfset factor = 1 >
						<cfelse>
							<cfquery name="rsConversion" datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
								select Ucodigo, Ucodigoref, CUfactor 
								from ConversionUnidades 
								where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
								and Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsOrden.Ucodigo#">
								and Ucodigoref = <cfqueryparam cfsqltype="cf_sql_char" value="#dataOrden.Ucodigo#">
							</cfquery>
				
							<cfif rsConversion.recordCount gt 0 and len(trim(rsConversion.CUfactor))>
								<cfset factor = rsConversion.CUfactor>
							<cfelse>
								<cfthrow message="#Arguments.InvokerName#: Error al aplicar documento de recepcion, no se encontro el factor de conversion de la unidad #rsOrden.Ucodigo# a la unidad #Arguments.uMedida#. Proceso Cancelado!">
							</cfif>	
						</cfif>	
			
						<!--- afectacion de inventario si factor es mayor o igual a 1--->
						<cfquery datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
							update DOrdenCM	set 
								<cfif rsTipo.TDRtipo EQ 'R'>	<!--- Recepcion --->
									DOcantsurtida = DOcantsurtida + (#dataOrden.DDRcantrec#/#factor#)						
								<cfelse>	<!--- Devolucion --->
									DOcantsurtida = DOcantsurtida - (#dataOrden.DDRcantrec#/#factor#)							
								</cfif>						
							where DOlinea=<cfqueryparam value="#dataOrden.DOlinea#" cfsqltype="cf_sql_numeric">
							  and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSolicitudes.GvarEcodigo#">
						</cfquery>			

						<!--- se guarda la cantidad convertida --->
						<cfquery datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
							update DDocumentosRecepcion
							set DDRcantordenconv = (#dataOrden.DDRcantrec#/#factor#)
							where DDRlinea = <cfqueryparam value="#dataOrden.DDRlinea#" cfsqltype="cf_sql_numeric">
							and Ecodigo = <cfqueryparam value="#Request.CM_InterfazSolicitudes.GvarEcodigo#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfloop>	<!--- Ciclo para recorrer linea por linea del detalle de la factura --->					
					
					<!--- Pase a Historicos --->
					<cfquery datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
						insert into HEDocumentosRecepcion( EDRid, Ecodigo, TDRcodigo, Mcodigo, EDRtc, Aid, CFid, EDRnumero, EDRfechadoc, EDRfecharec, EOidorden, SNcodigo, EDRreferencia, EDRdescpro, EDRimppro, EDRobs, EDRperiodo, EDRmes, HEDRestadoreclamo, idBL, Usucodigo, fechaalta )
						select EDRid, Ecodigo, TDRcodigo, Mcodigo, EDRtc, Aid, CFid, EDRnumero, EDRfechadoc, EDRfecharec, EOidorden, SNcodigo, EDRreferencia, EDRdescpro, EDRimppro, EDRobs, EDRperiodo, EDRmes, 0, idBL, Usucodigo, fechaalta 
						from EDocumentosRecepcion
						where EDRid=<cfqueryparam value="#Arguments.llaveEdocum#" cfsqltype="cf_sql_numeric">
					</cfquery>
		
					<cfquery datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
						insert into HDDocumentosRecepcion (DDRlinea, Ecodigo, EDRid, DOlinea, Usucodigo, fechaalta, Aid, Cid, DDRtipoitem, DDRcantrec, DDRcantorigen, DDRpreciou, DDRdesclinea, DDRtotallin, DDRcostopro, DDRcostototal)
						select DDRlinea, Ecodigo, EDRid, DOlinea, Usucodigo, fechaalta, Aid, Cid, DDRtipoitem, DDRcantrec, DDRcantorigen, DDRpreciou, DDRdesclinea, DDRtotallin, DDRcostopro, DDRcostototal
						from DDocumentosRecepcion
						where EDRid=<cfqueryparam value="#Arguments.llaveEdocum#" cfsqltype="cf_sql_numeric">
					</cfquery>			
					
					<cfif rsTipo.TDRtipo EQ 'D'>	<!--- Devolucion --->
						<cfquery datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
							update DDocumentosRecepcion
							set DDRcantrec = DDRcantrec*-1,
								DDRcantorigen = DDRcantorigen*-1,
								DDRpreciou = DDRpreciou*-1
							where EDRid=<cfqueryparam value="#Arguments.llaveEdocum#" cfsqltype="cf_sql_numeric">
						</cfquery>
		
						<cfquery datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
							update HDDocumentosRecepcion
							set DDRcantrec = DDRcantrec*-1,
								DDRcantorigen = DDRcantorigen*-1,
								DDRpreciou = DDRpreciou*-1
							where EDRid=<cfqueryparam value="#Arguments.llaveEdocum#" cfsqltype="cf_sql_numeric">
						</cfquery>
					</cfif>									
	
					<!--- CAMBIA ESTADO AL DOCUMENTO--->	
					<cfquery datasource="#Request.CM_InterfazSolicitudes.GvarConexion#">
						update EDocumentosRecepcion
						set EDRestado = 10
						where EDRid=<cfqueryparam value="#Arguments.llaveEdocum#" cfsqltype="cf_sql_numeric">
					</cfquery>			
				</cfif>			
			<cfelse>
				<cfthrow message="#Arguments.InvokerName#: No existe la orden de compra con EOnumero=#Arguments.numOrdenC# y DOconsecutivo=#Arguments.DOconsec# en la base de datos. Proceso Cancelado!">		
			</cfif>				
		<cfelse>
			<cfthrow message="#Arguments.InvokerName#: Error al aplicar documento de recepcion, no se encontro el tipo de documento #Arguments.tipoDoc# en el momento de aplicar. Proceso Cancelado!">		
		</cfif>				

		<cfreturn 1>
	</cffunction>	
</cfcomponent>
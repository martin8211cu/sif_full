<!--- 
	Interfaz 921: Registro de Movimientos Bancarios
	Dirección de la Inforamción: Sistema Externo - SIF
	Elaborado por: Maria de los Angeles Blanco López 
	Creacion: 26/04/2010
--->

<cfcomponent>
	<!--- Variables Globales --->
	<cfset GvarConexion  = Session.Dsn>
	<cfset GvarEcodigo   = Session.Ecodigo>	
	<cfset GvarUsuario   = Session.Usuario>
	<cfset GvarUsucodigo = Session.Usucodigo>
	<cfset GvarEcodigoSDC= Session.EcodigoSDC>
	<cfset GvarEnombre   = Session.Enombre>
	<cfset GvarMinFecha  = DateAdd('yyyy',-50,Now())>
	<cfset GvarCuentaManual = true> 
	
	<cffunction name="process" access="public" returntype="string" output="no">
	 	<!--- Argumentos --->
		<cfargument name="query" required="yes" type="query">
			
        <!---Valida los Registros--->
		<cfoutput query="query" group="ID">
			<!--- Variables Validadas de Documentos de Cancelación --->
            <cfset Valid_EcodigoSDC 		= getValidEcodigoSDC(query.EcodigoSDC)>
            <cfset Valid_Mcodigo 			= getValidMcodigo(query.Moneda)>
            <cfset Valid_FechaDocumento  	= getValidFechaDocumento(query.Fecha_Mov)>
            <cfset Valid_SNcodigo 			= getValidSNcodigo(query.NumeroSocio)>

			<cfif query.Tipo_Movimiento EQ 'D'>
				<cfif (isdefined("query.Banco_Origen") and trim(query.Banco_Origen EQ "")) or (isdefined("query.Cuenta_Origen") 																						                and trim(query.Cuenta_Origen) EQ "")>
					<cfthrow message="Error Interfaz 921. Debe definir el banco y cuenta Origen">
				<cfelse>
				    <cfset Valid_CuentaBanco  = getValid_CtaBanco(query.Banco_Origen,query.Cuenta_Origen)>
				</cfif>
			<cfelse>
				<cfthrow message="El tipo de movimiento es invalido">
			</cfif>
				
            <!---Valida el Tipo de Cambio--->
            <!--- Busca Moneda Local --->
            <cfquery name="rsMonedaL" datasource="#GvarConexion#">
                select m.Miso4217 
                from Empresas e 
                    inner join Monedas m 
                    on e.Ecodigo = m.Ecodigo and e.Mcodigo = m.Mcodigo
                where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
            </cfquery>
            <cfif isdefined("rsMonedaL") and rsMonedaL.Miso4217 EQ query.Moneda and query.Tipo_Cambio GT 1>
                <cfthrow message="Error Interfaz 921. Se ha dado un Tipo de cambio diferente de 1 para la moneda Local">
            </cfif>
            <cfif (query.Tipo_Cambio EQ 0 or query.Tipo_Cambio EQ "") and isdefined("rsMonedaL") and rsMonedaL.Miso4217 NEQ		query.Moneda> 
                <cfset Valid_TipoCambio		= getValidTipoCambio(Valid_Mcodigo.Mcodigo,Valid_FechaDocumento)>
            <cfelse>
                <cfset Valid_TipoCambio		= query.Tipo_Cambio>
            </cfif>
			
            <cfset Valid_Transaccion	= getValidTran(query.Tipo_Operacion)>
						
			<cfset Valid_Oficina  = getValid_Oficina(query.Cuenta_Origen,query.Banco_Origen)>
								
            <cfset Valid_NoRepetidos = getValid_NoRepetidos(Valid_CuentaBanco.CBid, Valid_Transaccion.BTid, query.Documento)>	
			<cfset Valid_CentroFuncional = getCentro_Funcional()>							 
            
        <!---<cfset Maximo = ExtraeMaximo(EMid, EMovimientos)>---->
		<cftry>
        
		<!--- Procesa Movimiento Bancario--->
		<cfquery name="InsertaEncabezado" datasource="#GvarConexion#">
			insert into EMovimientos
			(BTid,    
			 Ecodigo,
			 CBid,   
			 CFid,  
			 Ocodigo,
			 EMtipocambio,
			 EMdocumento,
	 		 EMtotal, 
			 EMreferencia,
			 EMfecha,  
			 EMdescripcion, 
			 EMusuario,  
			 TpoSocio,
			 Tipo,
			 SNcodigo,
			 id_direccion,
			 SNid,
			 TpoTransaccion
			 )
			 values 
			 (<cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_Transaccion.BTid#">,
			 <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
			 <cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_CuentaBanco.CBid#">,
			 null,
			 <cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_Oficina#">,
			 <cfqueryparam cfsqltype="cf_sql_double" value="#Valid_TipoCambio#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#query.Documento#">,
			 <cfqueryparam cfsqltype="cf_sql_double" value="#query.Importe_Total_Mov#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#query.Referencia#">,
			 <cfqueryparam cfsqltype="cf_sql_date" value="#query.Fecha_Mov#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(query.Descripcion_Mov,50)#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#GvarUsuario#">,
			 1,<cfqueryparam cfsqltype="cf_sql_char" value="#query.Tipo_Movimiento#">,
			 <cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_SNcodigo.SNcodigo#">,
			 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_SNcodigo.id_direccion#">,
			 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_SNcodigo.SNid#">,'')             
		</cfquery>	 	

		<cfquery datasource="sifinterfaces">
			update IE921
			set Estatus = 2
			where ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#query.ID#">
		</cfquery>
		
		
		<cfcatch>
				<cfif isdefined("cfcatch.Message")>
					<cfset Mensaje="#cfcatch.Message#">
                <cfelse>
                    <cfset Mensaje="">
                </cfif>
                <cfif isdefined("cfcatch.Detail")>
                    <cfset Detalle="#cfcatch.Detail#">
                <cfelse>
                    <cfset Detalle="">
                </cfif>
                <cfif isdefined("cfcatch.sql")>
                    <cfset SQL="#cfcatch.sql#">
                <cfelse>
                    <cfset SQL="">
                </cfif>
                <cfif isdefined("cfcatch.where")>
                    <cfset PARAM="#cfcatch.where#">
                <cfelse>
                    <cfset PARAM="">
                </cfif>
                <cfif isdefined("cfcatch.StackTrace")>
                    <cfset PILA="#cfcatch.StackTrace#">
                <cfelse>
                    <cfset PILA="">
                </cfif>
                <cfset MensajeError= #Mensaje# & #Detalle#>
				
				<cfif isdefined("EMid")>

				<cfquery datasource="#GvarConexion#">
					delete EMovimientos where EMid = <cfqueryparam cfsqltype="cf_sql_integer" value="#EMid#">
				</cfquery>
				</cfif>
				<cfthrow message="#MensajeError#">
		</cfcatch>
		</cftry>
	  </cfoutput>
    </cffunction>
		
		<!---
		Metodo: 
			getValidEcodigoSDC
		Resultado:
			Devuelve el codigo asociado al codigo de Empresa del portal dado por la interfaz.
			Si no se encuentra un registro para el codigo aborta el proceso.
	--->
	<cffunction name="getValidEcodigoSDC" access="private" returntype="numeric" output="no">
		<cfargument name="EcodigoSDC" required="true" type="numeric">
		<cfquery name="query" datasource="#GvarConexion#">
			select Ecodigo as EcodigoSDC
			from Empresa
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EcodigoSDC#">
			  and Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		</cfquery>
		<cfif not query.recordcount>
			<cfthrow message="Error en Interfaz 921. EcodigoSDC es inválido, El código de Empresa SDC debe coincidir con el código de empresa SDC que invoca la interfaz. Proceso Cancelado!.">
		</cfif>
		<cfreturn query.EcodigoSDC>
	</cffunction>
	

	<!---
		Metodo: 
			getValidMcodigo
		Resultado:
			Devuelve el id asociado al codigo Miso de la moneda dada por la interfaz.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidMcodigo" output="no" returntype="query">
		<cfargument name="miso" required="yes" type="string">
		
        <cfquery name="query" datasource="#GvarConexion#">
			select Mcodigo, Miso4217
			from Monedas
			where Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.miso)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		</cfquery>
		<cfif query.recordcount EQ 0 >
			<cfthrow message="Error en Interfaz 921. CodigoMoneda es inválido, El Código de la Moneda no corresponde con ninguna moneda en la Empresa #GvarEnombre#. Proceso Cancelado!.">
		</cfif>
		<cfreturn query>
	</cffunction>
	
	<!---
		Metodo: 
			getValidFechaDocumento
		Resultado:
			Devuelve una Fecha de Documento Valida
	--->
	<cffunction access="private" name="getValidFechaDocumento" output="no" returntype="date">
		<cfargument name="Fecha" required="yes" type="date">
		<cfif Arguments.Fecha lt GvarMinFecha or Arguments.Fecha gt DateAdd('yyyy',99,GvarMinFecha)>
			<cfthrow message="Error en Interfaz 921. FechaDocumeno es inválido, La Fecha del Documento no es válida en la Empresa #GvarEnombre#. Proceso Cancelado!.">
		</cfif>
		<cfreturn Arguments.Fecha>
	</cffunction>

	<!---
		Metodo:
			getValidSNcodigo
		Resultado:
			Devuelve el id asociado al codigo de socio de negocios dado por la interfaz.
			Si no se encuentra un registro para el codigo aborta el proceso.
	--->

	<cffunction access="private" name="getValidSNcodigo" output="no" returntype="query">
		<cfargument name="NumeroSocio" required="yes" type="string">

		<cfset var Lvar_SNid = 0>
		<cfset var Lvar_SNcodigo = 0>
		<cfset var Lvar_id_direccion_envio = 0>
		<cfset var Lvar_id_direccion_fact = 0>			
		
		<!--- 	Consulta Socio de Negocios
				SI Y SOLO SI no se pudo obtener el Socio por el campo de Dirección de Envío, Ni por el de Facturación.
		--->
		<cfif Lvar_SNid eq 0 and len(trim(NumeroSocio)) gt 0>
			<cfquery name="query3" datasource="#GvarConexion#" maxrows="1">
				select SNid,SNcodigo,id_direccion
				from SNegocios
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
				  and SNcodigoext = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.NumeroSocio#">
			</cfquery>
			<cfif query3.recordcount eq 0>
				<cfquery name="query3" datasource="#GvarConexion#" maxrows="1">
					select SNid,SNcodigo,id_direccion
					from SNegocios
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
					  and SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.NumeroSocio#">
				</cfquery>
			</cfif>			
			
			<cfif query3.recordcount eq 0>
				<cfthrow message="Error en Interfaz 921. El socio de Negocio con Código #Arguments.NumeroSocio#. No Existe!.">
		    </cfif>

			<cfreturn query3>
		</cfif>


	</cffunction>
		
	<!---
		Metodo:
			getTipoCambio
		Resultado:
			Obtiene el Tipo de cambio de la moneda indicada en la fecha indicada,
			la moneda esperada es en codigo Miso4217
	--->
	<cffunction access="private" name="getValidTipoCambio" output="no" returntype="numeric"> 
	  <cfargument name="Mcodigo" required="yes" type="numeric">
	  <cfargument name="Fecha" required="no" type="date" default="#now()#">
	  <cfset var retTC = 1.00>
	  <cfquery name="rsTC" datasource="#GvarConexion#">
		   select 
		   		coalesce(h.TCcompra,1) as TCcompra,
				coalesce(h.TCventa,1)  as TCventa
		   from Htipocambio h
		   where h.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		     and h.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">
		     and h.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">
		     and h.Hfecha = (
		     select max(h2.Hfecha)
		     from Htipocambio h2
		     where h2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		       and h2.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">
		       and h2.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">)
 
 	 </cfquery>
 	 <cfif isdefined('rsTC') and rsTC.recordCount GT 0>
	 	<cfset retTC = rsTC.TCcompra>
	 </cfif>
 	 <cfreturn retTC>
  </cffunction>

	<!---
		Metodo: 
			getValidCcodigo
		Resultado:
			Devuelve el Cconcepto Válido
	--->
	<cffunction access="private" name="getValidCcodigo" output="no" returntype="string">
		<cfargument name="Ccodigo" required="yes" type="string">
        <cfargument name="Modulo" required="yes" type="string">
		<cfargument name="TipoMovimiento" required="yes" type="string">
        
		<cfset var LvarCcodigo = "">
		<cfif len(Arguments.Ccodigo) gt 0>
			<cfquery name="query" datasource="#GvarConexion#">
			   select Ccodigo, Ctipo
			   from Conceptos
			   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
			   and upper(rtrim(ltrim(Ccodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(Arguments.Ccodigo))#">
			</cfquery>

			<cfif query.recordcount GT 0 and len(trim(query.Ccodigo) NEQ "")>
				<cfset LvarCcodigo = trim(query.Ccodigo)>
			<cfelse>
				<cfthrow message="Error en Interfaz 921. CodigoConcepto es inválido, El Código de Concepto no corresponde con ningún Concepto de la Empresa #GvarEnombre#. Proceso Cancelado!.">
			</cfif>
            <cfif Arguments.TipoMovimiento EQ "D">
            	<cfif query.Ctipo NEQ "I">
                	<cfthrow message="Error en Interfaz 921. El Código de Concepto corresponde a un concepto de tipo Gasto y no puede ser aplicado en un documento de deposito del banco. Proceso Cancelado!.">
                </cfif>
            <cfelse>
            	<cfif query.Ctipo NEQ "G">
                	<cfthrow message="Error en Interfaz 921. El Código de Concepto corresponde a un concepto de tipo Ingreso y no puede ser aplicado en un retiro del banco. Proceso Cancelado!.">
                </cfif>
            </cfif>
        <cfelse>
        	<cfthrow message="Error en Interfaz 921. CodigoConcepto es inválido. Proceso Cancelado!.">	    
		</cfif>
		<cfreturn LvarCcodigo>
	</cffunction>
	
	<!---Valida Transaccion--->
	<cffunction access="private" name="getValidTran" output="no" returntype="query">
    	<cfargument name="Tran" required="no" type="string">
		 		
		<cfquery name="rsTran" datasource="#GvarConexion#">
               select BTcodigo, BTtipo, BTid
			   from BTransacciones
			   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
               and BTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tran#">
        </cfquery> 
		
		<cfif isdefined("rsTran") and rsTran.recordcount EQ 1>
			<cfreturn rsTran>
	    <cfelse>
    	    <cfthrow message="Error Interfaz 921. Código de Transacción #Arguments.Tran# no corresponde con ninguna transaccion valida para la empresa #GvarEnombre#. Proceso Cancelado!">
        </cfif>		
	</cffunction>		
	

	<!---Valida Oficina--->
	<cffunction access="private" name="getValid_Oficina" output="no" returntype="string">
		<cfargument name="CtaBanco" required="yes" type="string">
		<cfargument name="Banco" required="yes" type="string">
			<cfquery name="rsOficina" datasource="#GvarConexion#">
				select CB.Ocodigo as Oficodigo
                from CuentasBancos CB
                inner join Bancos B
                on CB.Bid = B.Bid 
                	and CB.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
                    and CB.Ecodigo = B.Ecodigo
					and B.Iaba = <cfqueryparam cfsqltype="varchar" value="#Arguments.Banco#">
		     		and CB.CBcodigo = <cfqueryparam cfsqltype="varchar" value="#Arguments.CtaBanco#">
				inner join Oficinas  O 
                on CB.Ecodigo = O.Ecodigo 
                	and CB.Ocodigo = O.Ocodigo 
			</cfquery>
			
			<cfif isdefined("rsOficina") and rsOficina.recordcount EQ 0>
				<cfquery name="rsOficina" datasource="#GvarConexion#">
					select min(Oficodigo) as Oficodigo from Oficinas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 
					value="#GvarEcodigo#">
				</cfquery>
				<cfif isdefined("rsOficina") and rsOficina.recordcount EQ 0>
					<cfthrow message="Error Interfaz 921. No se pudo Obtener oficina Valida para el Documento de Cancelación. Compruebe que se ha registrado un banco y cuenta de banco validos. Proceso Cancelado!">
				</cfif>
			</cfif>
			
			<cfreturn rsOficina.Oficodigo>
	</cffunction>

	<!----Valida cuenta de banco--->
	<cffunction access="private" name="getValid_CtaBanco" output="no" returntype="query">
		<cfargument name="Banco" required="no" type="string">
		<cfargument name="CtaBanco" required="no" type="string">

			<cfquery name="rsCtaBanco" datasource="#GvarConexion#">
				select CB.CBid, CB.Ccuenta 
                from CuentasBancos CB 
				inner join Bancos B on CB.Bid = B.Bid
								   and CB.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
                                   and CB.Ecodigo = B.Ecodigo
					   			   and B.Iaba = <cfqueryparam cfsqltype="varchar" value="#Arguments.Banco#">
		     					   and CB.CBcodigo = <cfqueryparam cfsqltype="varchar" value="#Arguments.CtaBanco#">
			</cfquery>
			
			<cfif isdefined("rsCtaBanco") and rsCtaBanco.recordcount EQ 0>
				<cfthrow message="Error Interfaz 921. No se pudo validar la cuenta Bancaria en la empresa #GvarEnombre#">
			</cfif>
			
			<cfreturn rsCtaBanco>
	</cffunction>
	<!---Termina Funciion --->
	
    
	<!-----Valida que no se inserten registros duplicados----->
	 <cffunction access="private" name="getValid_NoRepetidos" output="no">
	    <cfargument name="Cuenta" required="yes" type="numeric">
        <cfargument name="Transaccion" required="yes" type="numeric">
		<cfargument name="Documento" required="yes" type="string">
      
	<cfquery name="rsInsertar" datasource="#session.DSN#">
		select 1
		from MLibros
		where Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
			and MLdocumento= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.Documento)#">
			and BTid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Transaccion#">
			and CBid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Cuenta#">
	</cfquery>
	
	<cfquery name="rsInsertarEM" datasource="#session.DSN#">
		select 1
		from EMovimientos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and EMdocumento= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.Documento)#">
			and BTid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Transaccion#">
			and CBid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Cuenta#">				
	</cfquery>			
		
	<cfif rsInsertar.recordcount gt 0 or rsInsertarEM.recordcount gt 0 >
		<cfquery name="transaccion" datasource="#session.DSN#">
			select BTdescripcion 
			from BTransacciones
			where BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Transaccion#">
		</cfquery>
		<cfquery name="cuenta" datasource="#session.DSN#">
			select CBdescripcion 
			from CuentasBancos
			where CBid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Cuenta#">				
		</cfquery>	
		
		<cfthrow message= "No se puede procesar el Movimiento pues ya existe uno con mismos datos: <br> -Documento: #Arguments.Documento# <br> -Transacción: #transaccion.BTdescripcion# <br> -Cuenta Bancaria: #cuenta.CBdescripcion#.">
		
	</cfif>
	</cffunction>
	
	<!------- Valida que el concepto enviado tenga su cuenta correspondiente---->
	<cffunction access="private" name="getValid_Ccuenta" output="no" returntype="string">
		<cfargument name="Ccodigo" required="yes" type="string">
		
		<cfset var LvarCformato = 0>
		<cfset LvarCcuenta = 0 >
		<cfif len(trim(Arguments.Ccodigo)) GT 0>
				<cfquery name="rsConceptos" datasource="#GvarConexion#">
					select Cformato, cuentac
					from Conceptos
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarEcodigo#">
					and upper(rtrim(ltrim(Ccodigo))) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(Trim(Arguments.Ccodigo))#">
				</cfquery>			    
								
				<cfif rsConceptos.recordcount GT 0 and len(trim(rsConceptos.cuentac)) NEQ "">
					<cfset LvarCformato = rsConceptos.Cformato>
					
					<cfquery name="rsCuenta" datasource="#GvarConexion#">
						select Ccuenta
						from CContables
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			 		    and Cformato = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarCformato#">
					</cfquery>
					<cfif len(trim(rsCuenta.Ccuenta))>
						<cfset LvarCcuenta = rsCuenta.Ccuenta>
					</cfif> 
				<cfelse>
					<cfthrow message="Error en Interfaz 921. Cuenta #LvarCformato#: Cuenta Inválida! para la empresa #Enombre#. Proceso Cancelado!">
				</cfif>	
		</cfif>		
		<cfreturn LvarCcuenta>
	</cffunction>
	
	<!--- Funcion Para extraer el centro funcional--->
	<cffunction name = 'getCentro_Funcional'> 
  	
		   	<cfquery name='rsCFuncional' datasource="#GvarConexion#">
       			select CFid from CFuncional 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">			
	       	</cfquery>
			    	    
        	<cfreturn rsCFuncional.CFid>
    </cffunction>
	
	
</cfcomponent>

<cfcomponent>
	<cffunction name="ReiniciaAutorizacion" access="public">
    	<cfargument name="EOidorden" 	type="numeric" required="yes">
        <cfargument name="Ecodigo" 		type="numeric" required="no">
        <cfargument name="conexion" 	type="string"  required="no">
        
        <cfif NOT isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif NOT isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        
    	<cftransaction>
            <cfquery datasource="#Arguments.conexion#">
                update CMAutorizaOrdenes
                set CMAestadoproceso = 10
                where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
                  and Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            </cfquery>
    
            <cfquery datasource="#Arguments.conexion#">
                insert into CMAutorizaOrdenes( EOidorden, CMCid, Ecodigo, CMAestado, CMAestadoproceso, Nivel, CMAfecha, BMUsucodigo, fechaalta)
                select distinct EOidorden, CMCid, Ecodigo, case Nivel when 0 then 2 else 0 end, case Nivel when 0 then 2 else 0 end, Nivel, CMAfecha, #session.Usucodigo#, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
                from CMAutorizaOrdenes
                where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
                  and Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            </cfquery>
            <cfquery datasource="#session.DSN#">
                update EPedido
                set EOestado = -7
                where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                  and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
			</cfquery>	
        </cftransaction>
    </cffunction>
    
    <!---►►Método que obtiene la cuenta de tránsito de una línea de una orden de compra◄◄--->
	<cffunction name="obtenerCuentaTransito" returntype="numeric" hint="Método que obtiene la cuenta de tránsito de una línea de una orden de compra">
		<cfargument name="DOlinea" 		required="yes" 	 type="numeric" hint="Linea de la Orden de Compra">
        <cfargument name="Ecodigo" 		required="no"  	 type="numeric" hint="Codigo Interno de la empresa donde se caiga la Factura de CXP">
		<cfargument name="Conexion" 	required="no" 	 type="string" 	hint="Nombre del DataSource">
        
        <CFIF NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('Session.Ecodigo')>
        	<CFSET Arguments.Ecodigo = Session.Ecodigo>
        </CFIF>
        <CFIF NOT ISDEFINED('Arguments.Conexion') AND ISDEFINED('Session.DSN')>
        	<CFSET Arguments.Conexion = Session.DSN>
        </CFIF>
        
        <!---►►Valida la empresa enviada◄◄--->
        <cfquery name="rsEmpresa" datasource="#Arguments.Conexion#">
        	select Edescripcion from Empresas where Ecodigo = #Arguments.Ecodigo#
        </cfquery>
        <cfif NOT rsEmpresa.RecordCount>
        	<cfthrow message="La empresa enviada no existe (Ecodigo = #Arguments.Ecodigo#)">
        </cfif>

		<!---►►Cuenta de Activos en Tránsito--->
		<cfquery name="CuentaActivoTransito" datasource="#Arguments.Conexion#">	
        	select Pvalor as Cuenta from Parametros where Pcodigo = 240 and Ecodigo = #Arguments.Ecodigo#
        </cfquery>
        
		<cfquery name="rsCuentaTransito" datasource="#Arguments.Conexion#">
			select do.CMtipo, do.DOdescripcion, coalesce(iac.IACtransito,-1) as Cuenta
			 from DPedido do
				left outer join Existencias e
					 on e.Aid     = do.Aid
					and e.Alm_Aid = do.Alm_Aid
                    
				left outer join IAContables iac
					on iac.IACcodigo = e.IACcodigo	
                    				
				left outer join AClasificacion ac
					on ac.Ecodigo   = iac.Ecodigo <!---No se usa el Ecodigo de la OC, ya que puede venir de otra empresa--->
					and ac.ACid     = do.ACid
					and ac.ACcodigo = do.ACcodigo
			where do.DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DOlinea#">
		</cfquery>
        <!---OJO, a la factura de CXP se envia la cuentas transito de la empresa solicitante
				en los tracking se guarda la cuenta en transito de la empresa compradora
				estas en teoria son el mismo formato, seria bueno validarlo, ya que de lo contrario los reportes
				Estaran Mintiendo (Empresa Solicitante esta en Arguments.Ecodigo la empresa compradora esta en session.Ecodigo)
		--->
        <cfif NOT rsCuentaTransito.RecordCount>
        	<cfthrow message="No se puedo recuperar la linea de la Orden de Compra">
        </cfif>
        <cfif ListFind('A',rsCuentaTransito.CMtipo)><!---►Artículo:Cuenta de tránsito asociada al grupo de cuenta de inventario del Acticulo/Almacen--->
        	<cfif rsCuentaTransito.Cuenta EQ -1>
            	<cf_errorCode code = "50876"
											msg  = "El ítem @errorDat_1@ no tiene una cuenta de tránsito asociada"
											errorDat_1="#rsCuentaTransito.DOdescripcion#"
							>
            <cfelse>
            	<cfreturn rsCuentaTransito.Cuenta>
            </cfif>
        <cfelseif ListFind('S,F', rsCuentaTransito.CMtipo)><!---►Activo y Servicios:Cuenta de Activos en transito--->
        	<cfif NOT CuentaActivoTransito.RecordCount>
        		<cfthrow message="La cuenta de activos en transito no esta Configurada en la empresa #rsEmpresa.Edescripcion#">
             <cfelse>
             	<cfreturn CuentaActivoTransito.Cuenta>
        	</cfif>
        <cfelse>
        	<cfthrow message="Tipo de Item no implementado (#rsCuentaTransito.CMtipo#)">
        </cfif>
	</cffunction>
</cfcomponent>
<!--- Interfaz Transformacion  de Notas de Remision  LD-SIF Ver. 1.0 --->
<!--- La interfaz de Remisiones, procesa todos las Compras con Notas de Remision y  las envia al  M´dulo  de CxP --->
<!--- La Interfaz LD-SIF solo funciona con versiones de Coldfusion 8.0 en adelante --->



<cfcomponent extends="Interfaz_Base">
    <cffunction name="Ejecuta" access="public" returntype="string" output="yes">
    	<cfargument name="Disparo" required="no" type="boolean" default="false"> <!---ABG--->
		
        <!---Invocar al GC para liberar memoria---> <!---ABG--->
        <cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
        <cfset javaRT.gc()><!--- invoca el GC --->
        
        <cfquery datasource="sifinterfaces" result="Rupdate">
            update top (300) ESIFLD_Facturas_Compra
			set Estatus = 10
            where 
            <cfif isdefined("Arguments.Disparo") and Arguments.Disparo>
                Estatus = 1
                and Remision = 1
                and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10, 11,94,92,99,100))
            <cfelse>
            	Estatus = 99
                and Remision = 1
                and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10, 11))
            </cfif>
        </cfquery>
		<cfquery name="rsRemisiones" datasource="sifinterfaces">
            Select Ecodigo, Origen,ID_DocumentoC,Tipo_Documento, Tipo_Compra, Fecha_Compra, Fecha_Arribo,
            Numero_Documento, Proveedor,Subtotal, Descuento,Impuesto,Total, Sucursal,Moneda,Fecha_Tipo_Cambio,
            Tipo_Cambio,Estatus,getdate() as Fecha_Inclusion 
            from  ESIFLD_Facturas_Compra 
            where Remision=1
            and Estatus=10
            <cfif Rupdate.recordcount EQ 0>
            	and 1 = 2
            </cfif>
        </cfquery>

		<cfif isdefined("rsRemisiones") and rsRemisiones.recordcount GT 0>
		<cfloop query="rsRemisiones">
		<cftry>
        	<cfset varBorraRegistro = false>
            <cfset varBorraDetalle = false>
            <cfset Maximus = 0>
        	<cfquery name="rsDRemisiones" datasource="sifinterfaces">
                select Ecodigo,ID_DocumentoC, ID_linea, Tipo_lin, Tipo_Item,'REMISION' AS Cod_Item,
                Cod_Impuesto, Cantidad,Precio_Unitario, Descuento_Lin, Subtotal_Lin, Impuesto_Lin,Total_Lin 
                from DSIFLD_Facturas_Compra
                where ID_DocumentoC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRemisiones.ID_DocumentoC#">
            </cfquery>
			<cfset Remision = rsRemisiones.ID_DocumentoC>
            
            <cfquery datasource="sifinterfaces">
                update ESIFLD_Facturas_Compra
                set Fecha_Inicio_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                where ID_DocumentoC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Remision#">
            </cfquery>
            
			<!---BUSCA EQUIVALENCIAS--->
			<!--- EMPRESAS --->
			<cfset Equiv = ConversionEquivalencia (rsRemisiones.Origen, 'CADENA', rsRemisiones.Ecodigo, rsRemisiones.Ecodigo, 'Cadena')>
			<cfset varEcodigo = Equiv.EQUidSIF>
			<cfset varEcodigoSDC = Equiv.EQUcodigoSIF>
			<cfset session.dsn = getConexion(varEcodigo)>
			<cfset varCEcodigo = getCEcodigo(varEcodigo)>
            
            <!--- MONEDA --->
            <cfif rsRemisiones.Moneda NEQ "" and len(rsRemisiones.Moneda) GT 0>
				<cfset Equiv = ConversionEquivalencia (rsRemisiones.Origen, 'MONEDA', rsRemisiones.Ecodigo, rsRemisiones.Moneda, 'Moneda')>
                <cfset varMoneda = Equiv.EQUcodigoSIF>
                <cfquery name="rsTC" datasource="#session.dsn#">
                    	select top 1 TCcompra from Htipocambio htc
                        inner join  Monedas m on htc.Ecodigo = m.Ecodigo and m.Mcodigo = htc.Mcodigo
		 				where htc.Ecodigo=#session.Ecodigo# 
                        and m.Miso4217='#Equiv.EQUcodigoSIF#'
						order by Hfecha desc
                    </cfquery>
                    <cfif rsTC.TCcompra GT 0>
                    	<cfset tipoCambio= rsTC.TCcompra>
                    <cfelse>
                    	<cfset tipoCambio= 1>    
                    </cfif>
            <cfelse>
            	<!--- Busca Moneda Local SIF ---> 
                <cfquery name="rsMoneda" datasource="#session.dsn#">
                    select e.Ecodigo, e.Edescripcion,m.Miso4217
                    from Monedas m
                        inner join Empresas e
                        on m.Ecodigo = e.Ecodigo and m.Mcodigo = e.Mcodigo
                    where e.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#"> 
                </cfquery>
                <cfif isdefined("rsMoneda") and rsMoneda.recordcount EQ 1>
                    <cfset varMoneda = rsMoneda.Miso4217>
                    <cfquery name="rsTC" datasource="#session.dsn#">
                    	select top 1 TCcompra from Htipocambio htc
                        inner join  Monedas m on htc.Ecodigo = m.Ecodigo and m.Mcodigo = htc.Mcodigo
		 				where htc.Ecodigo=#session.Ecodigo# 
                        and m.Miso4217='#rsMoneda.Miso4217#'
						order by Hfecha desc
                    </cfquery>
                    <cfif rsTC.TCcompra GT 0>
                    	<cfset tipoCambio= rsTC.TCcompra>
                    <cfelse>
                    	<cfset tipoCambio= 1>    
                    </cfif>
                <cfelse>
                    <cfthrow message="Error al Obtener la Moneda Local de la empresa: #rsMoneda.Enombre#">
                </cfif>
            </cfif>
            
            <!--- Busca Periodo en Minisif --->
			<cfquery name="BuscaPeriodo" datasource="#session.dsn#">
				select Pvalor from Parametros 
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
                and Pcodigo = 50
			</cfquery>
			<cfset Periodo = BuscaPeriodo.Pvalor>
			
			<!--- Busca Mes en Minisif --->
			<cfquery name="BuscaMes" datasource="#session.dsn#">
				select Pvalor from Parametros 
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
                and Pcodigo = 60
			</cfquery>
			<cfset Mes = BuscaMes.Pvalor>
            
            <!--- Obtiene el usuario de Interfaz --->
	        <cfset Usuario = UInterfaz (getCEcodigo(varEcodigo))>
			<cfset varUlogin = Usuario.Usulogin>
            <cfset varUcodigo = Usuario.Usucodigo>
            
			
				<!---OFICINA --->
                <cfset Equiv = ConversionEquivalencia (rsRemisiones.Origen, 'SUCURSAL', rsRemisiones.Ecodigo, rsRemisiones.Sucursal, 'Sucursal')>
                <cfset VarOcodigo = Equiv.EQUidSIF>
				<cfset VarOficina = Equiv.EQUcodigoSIF>
             
			
            
				<!--- CENTRO FUNCIONAL--->
                <cfset Equiv = ConversionEquivalencia (rsRemisiones.Origen, 'CENTRO_FUN', rsRemisiones.Ecodigo, rsRemisiones.Sucursal, 'Centro_Funcional')>
                <cfset varidCF = Equiv.EQUidSIF>
				<cfset varCF = Equiv.EQUcodigoSIF>
            
            	
                
            <!---<!--- Busca Tipo de Transaccion en Minisif --->
            <cfquery name="BuscaTipoTran" datasource="#session.dsn#">
            	select b.CPTcodigo
              	from CPTransacciones b
                where b.Ecodigo = #varEcodigo# 
                
            </cfquery>
            <cfif isdefined("BuscaTipoTran") and BuscaTipoTran.recordcount EQ 1>        
				<cfset TTranCP = #BuscaTipoTran.CPTcodigo#> <!--- Transaccion para CP --->
			<cfelse>
				<cfthrow message="Error al Obtener la Transaccion de CP">
			</cfif>--->
 			
            <!---Inserta en  las tablas de Remisiones los Datos  --->
            <cfquery name="insERemision" datasource="sifinterfaces">
            	insert into ESIFLD_Remisiones  values(
                #rsRemisiones.Ecodigo#,
                '#rsRemisiones.Origen#',
                #rsRemisiones.ID_DocumentoC#,
                '#rsRemisiones.Tipo_Documento#',
                '#rsRemisiones.Tipo_Compra#',
                '#rsRemisiones.Fecha_Compra#',
                '#rsRemisiones.Fecha_Arribo#',
                '#rsRemisiones.Numero_Documento#',
                '#rsRemisiones.Proveedor#',
                #rsRemisiones.Subtotal#,
                #rsRemisiones.Descuento#,
                #rsRemisiones.Impuesto#,
                #rsRemisiones.Total#,
                #rsRemisiones.Sucursal#,
                '#rsRemisiones.Moneda#',
                '#rsRemisiones.Fecha_Tipo_Cambio#',
                #rsRemisiones.Tipo_Cambio#,
                #rsRemisiones.Estatus#,
               '#rsRemisiones.Fecha_Inclusion#'
                )
            </cfquery>
            <cfloop query="rsDRemisiones">
            <!---  IMPUESTOS --->
            	<cfset Equiv = ConversionEquivalencia (rsRemisiones.Origen, 'IMPUESTO', rsRemisiones.Ecodigo, rsDRemisiones.Cod_Impuesto, 'Impuestos')>
                <cfset varidImp = Equiv.EQUidSIF>
				<cfset varImp = Equiv.EQUcodigoSIF>
                <cfquery name="insDRemision" datasource="sifinterfaces">
                    insert into DSIFLD_Remisiones values(
                    #rsDRemisiones.Ecodigo#,
                    #rsDRemisiones.ID_DocumentoC#,
                    #rsDRemisiones.ID_linea#,
                    '#rsDRemisiones.Tipo_lin#',
                    #rsDRemisiones.Tipo_Item#,
                    '#rsDRemisiones.Cod_Item#',
                    #rsDRemisiones.Cod_Impuesto#,
                    #rsDRemisiones.Cantidad#,
                    #rsDRemisiones.Precio_Unitario#,
                    #rsDRemisiones.Descuento_Lin#,
                    #rsDRemisiones.Subtotal_Lin#,
                    #rsDRemisiones.Impuesto_Lin#,
                    #rsDRemisiones.Total_Lin#
                    )
                </cfquery>
        	</cfloop>
			<!--- Marca o Borra las Tablas Origen Registro Procesado --->
			
            <cfset stMemInfo = javaRT.totalMemory()-javaRT.freeMemory()>
        	<cfquery datasource="sifinterfaces"> 
        		  update ESIFLD_Facturas_Compra
					set Estatus = 2,
					Fecha_Fin_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    ControlMem = #stMemInfo#,
                    Periodo = #Periodo#,
                    Mes = #Mes#
					where ID_DocumentoC = #Remision# 
        	</cfquery> 
		<cfcatch type="any"> <!---Error en Remisioness --->
			<!--- Marca El registro con Error--->
			<cfquery datasource="sifinterfaces">
				update ESIFLD_Facturas_Compra  
				set Estatus = 3,
                Fecha_Fin_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				where ID_DocumentoC = #Remision#
			</cfquery>

			<!--- Elimina Registros Insertados. Verifica si se grabo algo en las tablas --->
			<cfquery datasource="sifinterfaces">
                delete DSIFLD_Remisiones
                where  ID_DocumentoC   = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Remision#">
            </cfquery>
            <cfquery datasource="sifinterfaces">
                delete ESIFLD_Remisiones
                where  ID_DocumentoC   = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Remision#">
            </cfquery>
            
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
			<cfquery datasource="sifinterfaces">
				insert into SIFLD_Errores 
				(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam, MsgErrorPila, Ecodigo,Usuario)
				values 
				('Remisiones',
				 'ESIFLD_Facturas_Compra', 
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Remision#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,
                 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRemisiones.Ecodigo#">,
                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varUlogin#">) 
			</cfquery>
            
		</cfcatch>
		</cftry>
		</cfloop> <!--- Encabezados Remisiones --->

        
		</cfif>
	</cffunction>
</cfcomponent>
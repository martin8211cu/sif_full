
<cfcomponent>
	<cffunction name="MovInterAlmacenconAprobacion" access="public" returntype="string" output="no">
    	<cfargument name='Ecodigo'		type='numeric' 	required='false' default="#session.Ecodigo#">	 	<!--- Codigo empresa ---->
		<cfargument name='EMid' 		type='numeric' 	required='true'>	 								<!--- Codigo de la transferencia ---->
		<cfargument name='usuario' 		type='string' 	required='false'  default="#session.Usucodigo#">	<!--- Codigo del usuario ---->
        	<cfquery name="updEMinteralmacen" datasource="#session.DSN#">
                update EMinteralmacen
                set Eestado = <cfqueryparam cfsqltype="cf_sql_integer" value="2"> <!--- Cambio el estado para que aparesca en la proxima pantalla para aprobar ---->
                where Ecodigo = <cfqueryparam value="#Arguments.Ecodigo#" cfsqltype="cf_sql_integer">
                  and EMid = <cfqueryparam value="#Arguments.EMid#" cfsqltype="cf_sql_numeric">
            </cfquery>
    
	</cffunction>
	 
	<cffunction name="MovInterAlmacen" access="public" returntype="string" output="false">
		
		<!---- Definición de Parámetros --->
		<cfargument name='Ecodigo'		type='numeric' 	required='false' default="#session.Ecodigo#">	 	<!--- Codigo empresa ---->
		<cfargument name='EMid' 		type='numeric' 	required='true'>	 								<!--- Codigo de la transferencia ---->
		<cfargument name='usuario' 		type='string' 	required='false'  default="#session.Usucodigo#">	<!--- Codigo del usuario ---->
		<cfargument name='debug' 		type='string' 	required='false' default="N">	 					<!--- Ejecutra el debug (muestra los sqls) S= si  N= no---->
		<cfargument name='Conexion' 	type='string' 	required='false'>
        
		<cfset var LCostoTotal = 0.00>
		
        <cfinclude template="../Utiles/sifConcat.cfm">
		<!--- Definicion de variables ---->
		<cfset lin = 0>
		<cfset Periodo = 0>
		<cfset Mes = 0>
		<cfset Fecha = ''>
		<cfset descripcion =''>
		<cfset Monloc =0>
		<cfset edocbase =''>
		<cfset error =0>
		<cfset CuentaPuente =0>
		
		<cfif (not isdefined("arguments.Conexion"))>
			<cfset arguments.Conexion = session.dsn>
		</cfif>
				
		<!---  Creación de la tabla INTARC ----->
		<cfinvoke component="CG_GeneraAsiento" returnvariable="Intarc" method="CreaIntarc" ></cfinvoke>	
		<cfinvoke component="sif.Componentes.IN_PosteoLin" method="CreaIdKardex"  returnvariable="IDKARDEX"/>
		<cftransaction>
			<!--- Definicion de variables ---->
			<cfif Arguments.debug EQ 'N'>
				<cfset MyDebug = false>
			<cfelse>
				<cfset MyDebug = true>
			</cfif> 
			<cfset msg = ''>
			<cfset Periodo = 0>
			<cfset Mes = 0>
			<cfset FechaHoy = ''>
			<cfset descripcion =''>
			<cfset IACcodigo =0>
			
			<cfset Ocodigoini =0>
			<cfset Dcodigoini =0>
			<cfset Ocodigofin =0>
			<cfset Dcodigofin =0>
		
			<cfset Monloc =0>
			<cfset EMdocumento =''>
			<cfset EMreferencia =''>
			<cfset error =0>
			<cfset DMlinea =0>
			<cfset Fecha = ''>
			
			<!--- Posteo Lineas Inventario --->
			<cfset Aid =0>
			<cfset cant =0>
			<cfset costolin =0>
			<cfset costo =0>
			<cfset Alm_Aid =0>
			<cfset errorsp =0>
			
			<cfset documento =''>
			<cfset EAfecha =''>
			
			
			<cfif (not isdefined("arguments.Conexion"))>
				<cfset arguments.Conexion = session.dsn>
			</cfif>
			
			<!--- Carga de moneda local --->
			<cfquery name="rsMonloc" datasource="#Arguments.Conexion#">
				select Mcodigo
				from Empresas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
			
			<cfif isdefined("rsMonloc")>
				<cfset Montloc =  rsMonloc.Mcodigo>			
			</cfif>
			
			<!---- Carga del periodo --->
			<cfquery name="rsPeriodo" datasource="#Arguments.Conexion#">
				select <cf_dbfunction name="to_number" args="Pvalor"> as Periodo
				from Parametros
				Where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and Mcodigo = 'GN'
					and Pcodigo = 50		
			</cfquery>			
			
			<cfif isdefined("rsPeriodo")>
				<cfset Periodo =  rsPeriodo.Periodo>			
			</cfif>
			
			<!---- Carga del mes --->
			<cfquery name="rsMes" datasource="#Arguments.Conexion#">
				select <cf_dbfunction name="to_number" args="Pvalor"> as Mes
				from Parametros
				Where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and Mcodigo = 'GN'
					and Pcodigo = 60		
			</cfquery>			

			<!---- 741. Verifica Grupo de cuentas en el catalogo de articulos --->
			<cfquery name="rsVerGruCtas" datasource="#Arguments.Conexion#">
				select Pvalor
				from Parametros
				Where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and Pcodigo = 741		
			</cfquery>			

			<cfif isdefined("rsMes")>
				<cfset Mes =  rsMes.Mes>			
			</cfif>
			<!---- 1. Validaciones ---->
			<cfif Mes EQ 0 or Periodo EQ 0>
				<cf_errorCode	code = "50406" msg = "No se ha definido el parámetro de Período o Mes para los sistemas Auxiliares. El proceso ha sido cancelado">
			</cfif>
		
			<!--- Existe Movimiento --->
			<cfquery name="ExisteMovimiento" datasource="#Arguments.Conexion#">
				select 1 from DMinteralmacen 
				where EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">	
			</cfquery>	
			
			<cfif isdefined("ExisteMovimiento") and not  ExisteMovimiento.RecordCount GE 1>
				<cf_errorCode	code = "51184" msg = "No hay lineas de documento para procesar. El proceso ha sido cancelado">
			</cfif>
			
			<cf_dbfunction name="now"	returnvariable="FechaHoy">	
			<cfset msg = ''>
			<cfset descripcion = 'Movimiento Interalmacén'>
			
			
			<cfquery name="rsDMinteralmacen" datasource="#Arguments.Conexion#">
				select a.DMlinea, a.DMAid, a.DMcant
				from DMinteralmacen a
				where a.EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">	
			</cfquery>	
						
			<cfif rsDMinteralmacen.RecordCount gt 0>
	
				<cfloop query="rsDMinteralmacen">
					<cfset DMlinea = rsDMinteralmacen.DMlinea>
					<cfset Aid = rsDMinteralmacen.DMAid>
					<cfset cant = rsDMinteralmacen.DMcant>

					
                    <!---- Verifica Grupo de cuentas en el catalogo de articulos --->
                    <cfif rsVerGruCtas.Pvalor eq 1>
                        <cfquery name="rsAlmDestino" datasource="#Arguments.Conexion#">
                            select EMalm_Dest 
                            from EMinteralmacen 
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">	
                              and EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">	
                        </cfquery>	
                        
                        <cfquery name="rsExiCtaDest" datasource="#session.DSN#">
                            select Aid, Alm_Aid, IACcodigo, Eestante, Ecasilla, Eexistmin, Eexistmax, Eexistencia, Ecostou 
                            from Existencias
                            where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
                              and Aid = <cfqueryparam value="#Aid#" cfsqltype="cf_sql_numeric" >
                              and Alm_Aid = <cfqueryparam value="#rsAlmDestino.EMalm_Dest#" cfsqltype="cf_sql_numeric" >
                        </cfquery>
                        
                        <cfif rsExiCtaDest.recordCount eq 0>
                        	<cfquery datasource="#session.DSN#" name="rsAlmacen">
                                select Aid, Bdescripcion, ts_rversion 
                                from Almacen 
                                where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
                                and Aid=<cfqueryparam value="#rsAlmDestino.EMalm_Dest#" cfsqltype="cf_sql_numeric" >
                            </cfquery>
                            
                            <cfquery datasource="#session.DSN#" name="rsInfoArticulo">
                                select Acodigo, Adescripcion 
                                from Articulos
                                where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
                                and Aid = <cfqueryparam value="#Aid#" cfsqltype="cf_sql_numeric" >
                            </cfquery>


							<cfthrow message="No esta definida la cuenta contable del almacen destino:#rsAlmacen.Bdescripcion# para el articulo:#rsInfoArticulo.Adescripcion# 
                            ,Puede definir la cuenta en el catalo de articulos">
                    	</cfif>
                    </cfif>
                    
                    
				   <!--- Generar la Salida del Artículo del Almacén Origen --->
					<cfquery name="rsEMinteralmacen" datasource="#Arguments.Conexion#">
						select Dcodigo, Ocodigo, b.EMdoc, a.Aid, b.EMfecha
						from Almacen a
						inner join EMinteralmacen b
						  on a.Ecodigo = b.Ecodigo
						  and a.Aid = b.EMalm_Orig
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">	
						  and b.EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">	
						  
					</cfquery>	
					
					<cfif rsEMinteralmacen.RecordCount gt 0 >
						<cfset Dcodigoini = rsEMinteralmacen.Dcodigo>
						<cfset Ocodigoini = rsEMinteralmacen.Ocodigo>
						<cfset documento = rsEMinteralmacen.EMdoc>
						<cfset Alm_Aid = rsEMinteralmacen.Aid>
						<cfset EAfecha = rsEMinteralmacen.EMfecha>
						
						<cfset costolin = 0>

						<!--- 3.6 Ejecuta el PosteoLin para la requisición --->
						<cfinvoke component="sif.Componentes.IN_PosteoLin" method="IN_PosteoLin" returnvariable="LvarCOSTOS">
							<cfinvokeargument name="Aid"  				value="#Aid#">
							<cfinvokeargument name="Alm_Aid"  			value="#Alm_Aid#">
							<cfinvokeargument name="Tipo_Mov"  			value="M">
							<cfinvokeargument name="Cantidad"  			value="#cant#">
							<cfinvokeargument name="ObtenerCosto"  		value="true">
							<cfinvokeargument name="Tipo_ES"  			value="S">
							<cfinvokeargument name="Dcodigo"  			value="#Dcodigoini#">
							<cfinvokeargument name="Ocodigo"  			value="#Ocodigoini#">
							<cfinvokeargument name="Documento"  		value="#documento#">
							<cfinvokeargument name="FechaDoc"  			value="#EAfecha#">
							<cfinvokeargument name="Referencia"  		value="IA">
							<cfinvokeargument name="Conexion"  			value="#Arguments.Conexion#">
							<cfinvokeargument name="Ecodigo"  			value="#Arguments.Ecodigo#">
							<cfinvokeargument name="Debug"  			value="#MyDebug#">
							<cfinvokeargument name="transaccionactiva"  value="true">
                            <cfinvokeargument name="Usucodigo"  			value="#session.Usucodigo#">
						</cfinvoke>
					</cfif>
					
					<!--- 3.7 El costo de la Requisicion viene negativo cuando es salida, se invierte para efectos del asiento --->
					<cfset LvarCOSTOS.VALUACION.Costo 	= -(LvarCOSTOS.VALUACION.Costo)>
					<cfset LvarCOSTOS.LOCAL.Costo 		= -(LvarCOSTOS.LOCAL.Costo)>
					<!--- 3.8 Se lleva el acumulado del costo para efectos del asiento contable --->
					<cfset LCostoTotal = LCostoTotal + LvarCOSTOS.VALUACION.Costo>
				
					<cfif MyDebug >
						<cfquery name="rsDebug" datasource="#Arguments.Conexion#">
							select a.Aid, a.Ecodigo, a.Acodigo, a.Acodalterno, a.Ucodigo, a.Ccodigo, a.Adescripcion, 
							  a.Afecha, a.Acosto, a.Aconsumo, a.ts_rversion, c.Aid, c.Alm_Aid, c.Ecodigo, c.IACcodigo, 
							  c.Eexistencia, c.Ecostou, c.Epreciocompra, c.Ecostototal, c.Esalidas, c.Eestante, 
							  c.Ecasilla, c.Eexistmin, c.Eexistmax, c.ts_rversion, d.Ecodigo, d.IACcodigo, 
							  d.IACcodigogrupo, d.IACdescripcion, d.IACinventario, d.IACingajuste, d.IACgastoajuste, 
							  d.IACcompra, d.IACingventa, d.IACcostoventa, d.IACdescventa, d.IACtransito, d.ts_rversion 
							from Articulos a
							  inner join Existencias c
								on  c.Aid = a.Aid
								and c.Ecodigo = a.Ecodigo
							  left outer join IAContables d
								on d.Ecodigo = c.Ecodigo
								and d.IACcodigo = c.IACcodigo       
							where a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Aid#">
							  and a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
							  and c.Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Alm_Aid#">
							  
						</cfquery>
						<cfif isdefined("rsDebug") and rsDebug.RecordCount GT 0>
							<cfdump var="#rsDebug#" label="Articulos">
						</cfif>
					</cfif>
					<cfquery name="rsInsINTARC" datasource="#Arguments.Conexion#">
						<!--- Crédito al Almacén Origen --->
						insert into #Intarc# ( 	INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo, 
												Mcodigo, INTMOE, INTCAM, INTMON )
						select 
							'INIA',
							1,
							<cf_dbfunction name="sPart"	args="'#documento#'? 1?20" delimiters="?">,
							'IA', 
							'C',
							<cf_dbfunction name="sPart"	args="'Cuenta de Inventarios Articulo:' #_Cat# a.Adescripcion?1?80" delimiters="?">,
							<cf_dbfunction name="to_sdate"	args="#FechaHoy#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Periodo#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Mes#">,
							d.IACinventario,
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Ocodigoini#">,

							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarCOSTOS.VALUACION.Mcodigo#">, 
							<cf_jdbcquery_param cfsqltype="cf_sql_money"	 value="#LvarCOSTOS.VALUACION.Costo#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_float"	 value="#LvarCOSTOS.VALUACION.TC#">, 
							<cf_jdbcquery_param cfsqltype="cf_sql_money" 	 value="#LvarCOSTOS.LOCAL.Costo#">
						from Articulos a
						inner join Existencias c
						  on c.Aid = a.Aid
						  and c.Ecodigo = a.Ecodigo
						left outer join IAContables d
						  on d.Ecodigo = c.Ecodigo
						  and d.IACcodigo = c.IACcodigo     
						where a.Aid =      <cfqueryparam cfsqltype="cf_sql_numeric" value="#Aid#">
						  and a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
						  and c.Alm_Aid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Alm_Aid#"> 					
					 </cfquery>

				   <!--- Generar La Entrada del Artículo al Almacén Destino --->
				   <cfquery name="rsAlmacen" datasource="#Arguments.Conexion#">
						select Dcodigo, Ocodigo, a.Aid
						from Almacen a
						inner join EMinteralmacen b
						  on a.Ecodigo = b.Ecodigo
						  and a.Aid = b.EMalm_Dest
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
						  and b.EMid =    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#"> 
					</cfquery>
					
					<cfset Dcodigofin =rsAlmacen.Dcodigo>
					<cfset Ocodigofin =rsAlmacen.Ocodigo>
					<cfset Alm_Aid =rsAlmacen.Aid>
					 
					<!---►►3.7 Ejecuta el PosteoLin para la requisición◄◄--->
					<cfinvoke component="sif.Componentes.IN_PosteoLin" method="IN_PosteoLin" returnvariable="IN_PosteoLin_Ret">
						<cfinvokeargument 		name="Aid"		 			value="#Aid#">
						<cfinvokeargument 		name="Alm_Aid"		 		value="#Alm_Aid#">
						<cfinvokeargument 		name="Tipo_Mov"		 		value="M">
						<cfinvokeargument 		name="Cantidad"		 		value="#cant#">
						<cfinvokeargument 		name="ObtenerCosto"			value="false">
						<cfinvokeargument 		name="McodigoOrigen"		value="#LvarCOSTOS.VALUACION.Mcodigo#">
						<cfinvokeargument 		name="CostoOrigen"			value="#LvarCOSTOS.VALUACION.Costo#">
						<cfinvokeargument 		name="CostoLocal"			value="#LvarCOSTOS.LOCAL.Costo#">
						<cfinvokeargument 		name="Tipo_ES"		 		value="E">
						<cfinvokeargument 		name="Dcodigo"		 		value="#Dcodigofin#">
						<cfinvokeargument 		name="Ocodigo"		 		value="#Ocodigofin#">
						<cfinvokeargument 		name="Documento"			value="#documento#">
						<cfinvokeargument 		name="FechaDoc"		 		value="#EAfecha#">
						<cfinvokeargument 		name="Referencia"			value="IA">
						<cfinvokeargument 		name="Conexion"		 		value="#Arguments.Conexion#">
						<cfinvokeargument 		name="Ecodigo"		 		value="#Arguments.Ecodigo#">
						<cfinvokeargument 		name="Debug"		 		value="#MyDebug#">
						<cfinvokeargument 		name="transaccionactiva"	value="true">
                        <cfinvokeargument 		name="Usucodigo"			value="#session.Usucodigo#">
                     </cfinvoke>
						<cfset LvarCOSTOS.VALUACION.Costo = Abs(LvarCOSTOS.VALUACION.Costo)>
					<!--- 3.7 El costo de la Requisicion viene negativo cuando es salida, se invierte para efectos del asiento --->
					<cfset LvarCOSTOS.VALUACION.Costo = Abs(LvarCOSTOS.VALUACION.Costo)>
					<!--- 3.8 Se lleva el acumulado del costo para efectos del asiento contable --->
					<cfset LCostoTotal = LCostoTotal + LvarCOSTOS.VALUACION.Costo>
				
					<cfif MyDebug >
						<cfquery name="rsDebug" datasource="#Arguments.Conexion#">
							select a.Aid, a.Ecodigo, a.Acodigo, a.Acodalterno, a.Ucodigo, a.Ccodigo, a.Adescripcion, 
							  a.Afecha, a.Acosto, a.Aconsumo, a.ts_rversion, c.Aid, c.Alm_Aid, c.Ecodigo, c.IACcodigo, 
							  c.Eexistencia, c.Ecostou, c.Epreciocompra, c.Ecostototal, c.Esalidas, c.Eestante, 
							  c.Ecasilla, c.Eexistmin, c.Eexistmax, c.ts_rversion, d.Ecodigo, d.IACcodigo, 
							  d.IACcodigogrupo, d.IACdescripcion, d.IACinventario, d.IACingajuste, d.IACgastoajuste, 
							  d.IACcompra, d.IACingventa, d.IACcostoventa, d.IACdescventa, d.IACtransito, d.ts_rversion 
							from Articulos a
							  inner join Existencias c
								on  c.Aid = a.Aid
								and c.Ecodigo = a.Ecodigo
							  left outer join IAContables  d
								on d.Ecodigo = c.Ecodigo
								and d.IACcodigo = c.IACcodigo       
							where a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Aid#">
							  and a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
							  and c.Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Alm_Aid#">
						</cfquery>
						<cfif isdefined("rsDebug") and rsDebug.RecordCount GT 0>
							<cfdump var="#rsDebug#" label="Articulos">
						</cfif>
						
					</cfif>
					
					<!--- Débito al Almacén Origen --->
					<cfquery name="rsInsINTARC" datasource="#Arguments.Conexion#">
						<!--- Crédito al Almacén Origen --->
						insert into #Intarc# (	INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo,
												Mcodigo, INTMOE, INTCAM, INTMON )
						select 
							'INIA',
							1,
							<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#documento#">,
							'IA', 
							'D',
							'Cuenta de Inventarios Articulo:' #_Cat# a.Adescripcion,
							<cf_dbfunction name="to_sdate"	args="#FechaHoy#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Periodo#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Mes#">,
							d.IACinventario,
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Ocodigofin#">,

							<cf_jdbcquery_param cfsqltype="cf_sql_numeric"	value="#LvarCOSTOS.VALUACION.Mcodigo#">, 
							<cf_jdbcquery_param cfsqltype="cf_sql_money"		value="#LvarCOSTOS.VALUACION.Costo#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_float"		value="#LvarCOSTOS.VALUACION.TC#">, 
							<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#LvarCOSTOS.LOCAL.Costo#">						from Articulos a
						inner join Existencias c
						  on c.Aid = a.Aid
						  and c.Ecodigo = a.Ecodigo
						left outer join IAContables d
						  on d.Ecodigo = c.Ecodigo
						  and d.IACcodigo = c.IACcodigo     
						where a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Aid#">
						  and a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
						  and c.Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Alm_Aid#"> 					
					 </cfquery>
					
				</cfloop>
				
				<cfif MyDebug >
					<cfquery name="rsIntarc" datasource="#Arguments.Conexion#">
						select INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE
						from #Intarc#			
					</cfquery>	
					<cfif isdefined("rsIntarc") and rsIntarc.RecordCount GT 0>
						<cfdump var="#rsIntarc#" label="Intarc">
					</cfif>
				</cfif>
				
				<!---- 5. Ejecutar el Genera asiento ---->
				<cfquery name="rsDescripcion" datasource="#Arguments.Conexion#">
					select b.CBcodigo
					from EMovimientos a
						inner join CuentasBancos b
							on a.CBid = b.CBid
					where a.EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">
                    	and b.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">	
				</cfquery>
							
				<!---- Carga de descripcion ---->
				<cfif isdefined("rsDescripcion")>
					<cfset descripcion = descripcion & rsDescripcion.CBcodigo>
				</cfif>
				
				<cfquery name="rs_revisa_Intarc" datasource="#arguments.conexion#">
					select INTLIN, INTTIP, Mcodigo, INTMOE , INTMON 
					from #Intarc#
				</cfquery>			
				
				<cfif isdefined('rs_revisa_Intarc') and rs_revisa_Intarc.RecordCount GT 0>
                	<cfquery name="rsOfi" datasource="#Arguments.Conexion#">
                        select min(Ocodigo) as Ocodigo from #INTARC#
                    </cfquery>
                    <cfif NOT rsOfi.RecordCount>
                        <cfquery name="rsOfi" datasource="#Arguments.Conexion#">
                            select min(Ocodigo) as Ocodigo from Oficinas where Ecodigo = #Arguments.Ecodigo#
                        </cfquery>
                   </cfif>
                   <cfif NOT rsOfi.RecordCount>
                        <cfset rsOfi.Ocodigo = -1>
                   </cfif>
					<cfinvoke component="CG_GeneraAsiento" method="GeneraAsiento" returnvariable="IDcontable">
						<cfinvokeargument name="Ecodigo" 	  value="#arguments.Ecodigo#"/>
						<cfinvokeargument name="Oorigen" 	  value="INIA"/>
						<cfinvokeargument name="Eperiodo"     value="#Periodo#"/>
						<cfinvokeargument name="Emes" 		  value="#Mes#"/>
						<cfinvokeargument name="Efecha" 	  value="#rsEMinteralmacen.EMfecha#"/>
						<cfinvokeargument name="Edescripcion" value="#descripcion#"/>
						<cfinvokeargument name="Edocbase" 	  value="#trim(documento)#"/>
						<cfinvokeargument name="Ereferencia"  value="#documento#"/>
						<cfinvokeargument name="debug"     	  value="true"/>	
                        <cfinvokeargument name="Ocodigo" 	  value="#rsOfi.Ocodigo#">					
					</cfinvoke>
				</cfif>
							
					<!---- 6. Borrado de estructuras ----->
					<cftry>
						<cfquery name="deleteDMinteralmacen" datasource="#arguments.conexion#">
							delete from DMinteralmacen
							where EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">						
						</cfquery>			
						<cfcatch type="any">
							<cf_errorCode	code = "51185" msg = "No se pudo eliminar las lineas de detalle. El proceso ha sido cancelado (Tabla: DMinteralmacen)">
						</cfcatch>
					</cftry>		
					
					<cftry>
						<cfquery name="deleteEMovimientos" datasource="#arguments.conexion#">
							delete from EMinteralmacen
							where EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">						
						</cfquery>			
						<cfcatch type="any">
							<cf_errorCode	code = "51186" msg = "No se pudo eliminar el Encabezado del Movimiento. El proceso ha sido cancelado (Tabla: EMinteralmacen)">
						</cfcatch>
					</cftry>	
					
					<cfif MyDebug >
						<cf_abort errorInterfaz="">
					<cfelse>
						<cftransaction action="commit"/>			
					</cfif>															
			</cfif>
		</cftransaction>
	</cffunction>
</cfcomponent>


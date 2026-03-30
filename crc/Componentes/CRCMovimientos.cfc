<cfcomponent output="false">
	
	<cffunction name="creaMovimientoCuenta" access="public" return="numeric">
		
		<cfargument name="TransaccionID" 		required="yes" 		type="numeric">
		<cfargument name="CuentaID" 			required="yes" 		type="numeric">
		<cfargument name="Monto" 				required="yes" 		type="numeric">
		<cfargument name="Parcialidades" 		required="yes" 		type="numeric">
		<cfargument name="Fecha_Inicio_Pago" 	required="yes" 		type="string">
		<cfargument name="Codigo_Transaccion" 	required="yes" 		type="string">
		<cfargument name="Tipo_Producto" 		required="yes" 		type="string">
		
		<cfargument name="Observaciones" 		default='' 			type="string">
		<cfargument name="DSN" 					default="#Session#.DSN" type="string">
		<cfargument name="Ecodigo" 				default="#Session.Ecodigo#" type="string">
		
		<cfif arguments.TransaccionID eq 0> 
			<cfthrow type="TransaccionException" message = "No hay transaccion para desglosar">
		</cfif>
		
		<cftry>
			<cfdump var="InicioPago: #arguments.Fecha_Inicio_Pago#,  tipo=#arguments.Tipo_Producto#,  parcialidades=#arguments.Parcialidades# --- ">
			<cfset CRCCortes = createObject( "component","crc.Componentes.CRCCortes")>
			<cfset cortes = CRCCortes.CreaCortes(fecha='#arguments.Fecha_Inicio_Pago#',tipo='#arguments.Tipo_Producto#',parcialidades=#arguments.Parcialidades#)>
			<cfdump var="[#cortes#]">
			<cfset cortes = ListToArray(cortes,',',false,false)>
		<cfcatch>
			<cfthrow type="TransaccionException" message = "Falla al obtener lista de cortes [CRCMovimientos.cfc].[creaMovimientoCuenta]">
		</cfcatch>
		</cftry>
		<cfset desgloce_IDs = []>
		<cftry>
			<cfloop index='i' from='1' to='#arguments.Parcialidades#'>
				<cfset obsMsg = "(#i#/#arguments.Parcialidades#) #arguments.Observaciones#">
				<cfquery name="q_Desgloce" datasource="#arguments.DSN#">
					insert into CRCMovimientoCuenta (
					 CRCTransaccionid,		
					 TipoMovimiento,		
					 Corte,
					 MontoRequerido,		
					 MontoAPagar,						
					 Descripcion,		
					 Ecodigo,						
					 createdat
					 )
					values (
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#TransaccionID#">,	
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Codigo_Transaccion#">,	
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#cortes[i]#">,	
					 <cfqueryparam cfsqltype="cf_sql_money" value="#NumberFormat(arguments.Monto/arguments.Parcialidades, "00.00")#">,	
					 <cfqueryparam cfsqltype="cf_sql_money" value="#NumberFormat(0, "00.00")#">,	
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#obsMsg#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">,	
					 CURRENT_TIMESTAMP	
					)
					;
					<cf_dbidentity1 datasource="#arguments.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#arguments.DSN#" name="q_Desgloce">	
				<cfset ArrayAppend(desgloce_IDs, q_Desgloce.identity)>
			</cfloop>
			<cfcatch>
				<cfthrow type="TransaccionException" message = "Falla en insertar parcialidades [CRCMovimientos.cfc].[creaMovimientoCuenta] --- #cfcatch.message#">
			</cfcatch>
		</cftry>
		
		<cfset resumen = ResumenMovimientoCuenta(
				CuentaID = #arguments.CuentaID#
			,	DSN = #arguments.DSN#
			,	Ecodigo = #arguments.Ecodigo#
			,	Lista_Codigo_Cortes = #cortes#
		)>
		<cfif ArrayLen(desgloce_IDs) le 0> <cfthrow type="TransaccionException" message = "No se generaron las parcialidades"></cfif>
		
		<cfreturn 'DONE'>

	</cffunction>
	
	<cffunction name="ResumenMovimientoCuenta" access="public" return="numeric">
		
		<cfargument name="CuentaID" 				required="yes" 		type="numeric">
		<cfargument name="Lista_Codigo_Cortes" 		required="yes" 		type="array" >
		<cfargument name="DSN" 						default="#Session.DSN#" type="string">
		<cfargument name="Ecodigo" 					default="#Session.Ecodigo#" type="string">
		
		<!--- Resumen de los cortes actuales--->
		<cftry>
			<cfquery name="q_Cortes" datasource="#arguments.DSN#">
				select 
					B.CRCCuentasid, 
					A.Corte, 
					sum(A.MontoRequerido) MontoRequerido,
					sum(A.MontoAPagar) MontoAPagar,
					sum(A.Intereses) Intereses,
					sum(A.Descuento) Descuentos,
					sum(A.Condonaciones) Condonaciones,
					sum(A.Pagado) MontoPagado,
					sum(A.SaldoVencido) SaldoVencido
				from CRCMovimientoCuenta A
					inner join CRCTransaccion B
						on B.id = A.CRCTransaccionid
				where 
					B.CRCCuentasid = #CuentaID#
					and A.Corte in ('#ArrayToList(arguments.Lista_Codigo_Cortes,"','")#')
					and A.Ecodigo = #arguments.Ecodigo#
				group by B.CRCCuentasid, A.Corte;
			</cfquery>
		<cfcatch>
			<cfthrow type="TransaccionException" message = "Falla obtener info de Cortes [CRCMovimientos.cfc].[ResumenMovimientoCuenta]  --- #cfcatch.message#">
		</cfcatch>
		</cftry>
		
		<!--- Obtencion de informacion de los cortes--->
		<cfset fechas_corte = StructNew()>
			<cfquery name="q_infoCorte" datasource="#arguments.DSN#">
				select FechaFin,Codigo from CRCCortes where Codigo in ('#ArrayToList(arguments.Lista_Codigo_Cortes,"','")#');
			</cfquery>
			<cfloop query = "q_infoCorte">
				<cfset fechas_corte['#q_infoCorte.Codigo#'] = q_infoCorte.FechaFin>
			</cfloop>			
		
		<!--- INSERT OR UPDATE Resumen de Cuentas x Corte--->
		<cftry>
			<cfloop query = "q_Cortes">
				<cfquery name="q_Resumen" datasource="#arguments.DSN#">
					DECLARE
					  @cuenta_ID int = #CuentaID#,
					  @cod_corte varchar(255) = '#q_Cortes.Corte#'

					MERGE CRCMovimientoCuentaCorte trg
					USING (
						SELECT
						  @cuenta_ID newCuentaID,
						  @cod_corte newCorte
					  ) src
					ON trg.CRCCuentasid = src.newCuentaID AND trg.Corte = src.newCorte
					WHEN MATCHED THEN
					  UPDATE SET
						trg.MontoRequerido = #q_Cortes.MontoRequerido#,
						trg.MontoAPagar = #q_Cortes.MontoAPagar#,
						trg.Intereses = #q_Cortes.Intereses#,
						trg.Descuentos = #q_Cortes.Descuentos#,
						trg.Condonaciones = #q_Cortes.Condonaciones#,
						trg.MontoPagado = #q_Cortes.MontoPagado#,
						trg.SaldoVencido = #q_Cortes.SaldoVencido#,
						trg.updatedat = CURRENT_TIMESTAMP

					WHEN NOT MATCHED BY TARGET THEN
					  INSERT(
							CRCCuentasid
						,	Corte
						,	FechaLimite
						,	MontoRequerido
						,	MontoAPagar
						,	Intereses
						,	Descuentos
						,	Condonaciones
						,	MontoPagado
						,	SaldoVencido
						,	Ecodigo
					  ) VALUES (
							src.newCuentaID
						,	src.newCorte
						,	'#fechas_corte[q_Cortes.Corte]#'
						,	#q_Cortes.MontoRequerido#
						,	#q_Cortes.MontoAPagar#
						,	#q_Cortes.Intereses#
						,	#q_Cortes.Descuentos#
						,	#q_Cortes.Condonaciones#
						,	#q_Cortes.MontoPagado#
						,	#q_Cortes.SaldoVencido#
						,	#arguments.Ecodigo#
					  );
				</cfquery>
			</cfloop>
		<cfcatch>
			<cfthrow type="TransaccionException" message = "Falla actualizar resumen de corte [CRCMovimientos.cfc].[ResumenMovimientoCuenta]  --- #cfcatch.message#">
		</cfcatch>
		</cftry>
		
		<cfreturn 1>
		
	</cffunction>
	
</cfcomponent>
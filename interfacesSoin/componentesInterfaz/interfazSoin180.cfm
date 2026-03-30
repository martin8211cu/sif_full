<!--- 
La oprecion del proceso es la siguiente:
	
	- Se toman los datos de las tablas de interfaces, se completan y se incluyen primeramente en 
	las tablas EContablesImportacion y DContablesImportacion, luego se inserta en la tabla Intermedia, 
	los siguientes datos (ID,Iddocimportacion,Fecha,Periodo,Mes,Ecodigo) inicialmente

	- Luego de que se da lo anterior, se quedan los asientos en las tablas de importacion, hasta que los 
	mismos sean aplicados, momento en el cual se actualizan los campos restantes de la tabla intermedia, y
	fuera de la transaccion se dispara el SP de salida en caso de ser necesario.
	
	Modificaciones Mauricio Esquivel - 3 Abril 2008
		1. Se debe de buscar el nombre del datasource necesario para el proceso. no se debe de usar el nombre de base de datos fijo
		2. La tabla temporal TIENE que construirse fuera de la transacción
		3. La transacción debe de ser más atómica para evitar problemas de acceso
		4. Solamente se debe de leer el registro de IE18 en forma "uncommited"
		5. El timeout debe ser máximo de 15 minutos.
		
	Proceso:
		0. Generar las tablas temporales fuera de la transaccion
		1. Determinar el datasource requerido para no usar fijo el nombre de la base de daos
		2. Verificar si el registro ya fue procesado
		3. Corregir las cuentas que no tienen guiones ( si tienen guiones no se corrigen y se trasladan como llegan)
		4. Actualizar los registros de la tabla ID18 con la cuenta con guiones
		5. ABRIR TRANSACCION
		6. Grabar tabla EContablesImportacion
		7. Grabar tabla DContablesImportacion
		8. Grabar tabla de control ( EContablesInterfaz18 )
		9. CERRAR TRANSACCION
		10. Actualizar datos de la operación fuera de la transacción, pues está en otro DataSource
--->

<cfsetting requesttimeout="1800">
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<cf_dbtemp name="ID180tmp_V3" returnvariable="CFformatos" datasource="#session.DSN#">
	<cf_dbtempcol name="CFformatoSF" type="varchar(100)"  mandatory="yes">
	<cf_dbtempcol name="CmayorSF"    type="varchar(4)"    mandatory="no">
	<cf_dbtempcol name="CdetSF"      type="varchar(100)"  mandatory="no">
	<cf_dbtempcol name="CFcuenta"    type="numeric"       mandatory="no">
	<cf_dbtempcol name="Ccuenta"     type="numeric"       mandatory="no">
	<cf_dbtempcol name="CFformato"   type="varchar(100)"  mandatory="no">
</cf_dbtemp>			

<cf_dbdatabase table="ID180" returnvariable="LvarID180" datasource="sifinterfaces">

<cfquery name="rsverexistencia" datasource="#session.DSN#">
	select count(1) as Cantidad
	from EContablesInterfaz18
	where ID = #GvarID#
</cfquery>

<cfif rsverexistencia.Cantidad EQ 0>
	<cfquery name="rsVariables" datasource="sifinterfaces">
		select
			 Cconcepto
			,  Periodo
			,  Mes
			,  Fecha_Emision
			,  Descripcion_Nomina
			,  Num_Nomina
			,  '' as Ereferencia
			,  getdate() as Falta
			,  0 as ECIreversible
		from IE180 E
		where ID = #GvarID#
	</cfquery>
	
	<cfif rsVariables.recordcount EQ 0>
		<cfthrow message="Se envio un Asiento sin registro de control">
	</cfif>

	<cfset LvarCconcepto      = rsVariables.Cconcepto>
	<cfset LvarPeriodo       = rsVariables.Periodo>
	<cfset LvarMes           = rsVariables.Mes>
	<cfset LvarFecha         = createODBCdate(rsVariables.Fecha_Emision)>
	<cfset LvarDescripcion   = rsVariables.Descripcion_Nomina>
	<cfset LvarEdocbase       = rsVariables.Num_Nomina>
	<cfset LvarEreferencia    = rsVariables.Ereferencia>
	<cfset LvarFalta          = createODBCdatetime(rsVariables.Falta)>
	<cfset LvarECIreversible  = rsVariables.ECIreversible>
	
	<cfquery name="rsControl" datasource="sifinterfaces">
		Select count(1) as Cantidad
		from ID180
		where ID = #GvarID#
	</cfquery>
	
	<cfif rsControl.Cantidad EQ 0>
		<cfthrow message="Se envio a procesar un Asiento sin datos (en blanco)!">
	</cfif>

	<!--- 
		Procesar las cuentas que llegan sin cuenta financiera
		Si tienen cuenta financiera no se procesan en el ciclo, porque ya están listas! 
	--->

	<cfquery datasource="#session.dsn#">
		insert into #CFformatos# 
			(CFformatoSF, CFcuenta, Ccuenta)
		select 
			CFformato, 
			max(coalesce(CFcuenta, 0)), max(coalesce(Ccuenta, 0))
		from #LvarID180#
		where ID = #GvarID#
		group by CFformato
	</cfquery>

	<cfquery datasource="#session.dsn#">
		update #CFformatos# 
			set 
				CmayorSF = <cf_dbfunction name="sPart"	args="CFformato, 2, 3">, 
				CdetSF   = <cf_dbfunction name="sPart"	args="CFformato, 5, 100">
	</cfquery>

	<!--- Actualizar las cuentas que no tienen guiones. Formato similar a Versión 5 de SIF --->
	<cfquery datasource="#session.DSN#">
			update #CFformatos#
			set CFcuenta = ( 
					select min(cf.CFcuenta)
					from CFinanciera cf
					where cf.CmayorSF  = #CFformatos#.CmayorSF
					  and cf.CdetSF  = #CFformatos#.CdetSF 
					  and cf.Ecodigo =  #session.ecodigo# 
					)
		where CFformatoSF NOT LIKE '%-%'
		  and CFcuenta = 0
	</cfquery>

	<!--- Actualizar las cuentas que tienen guiones. Formato de Version 6 de SIF  --->
	<cfquery datasource="#session.DSN#">
			update #CFformatos#
			set CFcuenta = ( 
					select min(cf.CFcuenta)
					from CFinanciera cf
					where cf.CFformato  = #CFformatos#.CFformatoSF
					  and cf.Ecodigo    =  #session.ecodigo# 
					)
		where CFformatoSF LIKE '%-%'
		  and CFcuenta = 0
	</cfquery>

	<!--- Actualizar el campo Ccuenta de las cuentas que tienen CFcuenta --->
	<cfquery datasource="#session.DSN#">
		update #CFformatos#
		set Ccuenta = ( 
				select min(cf.Ccuenta)
				from CFinanciera cf
				where cf.CFcuenta  = #CFformatos#.CFcuenta
				)
		where CFcuenta is not null
		  and CFcuenta > 0
	</cfquery>

	<!--- Actualizar el campo Ccuenta de las cuentas que tienen CFcuenta --->
	<cfquery datasource="#session.DSN#">
		update #CFformatos#
		set CFformato = ( 
				select min(cf.CFformato)
				from CFinanciera cf
				where cf.CFcuenta  = #CFformatos#.CFcuenta
				)
		where CFcuenta is not null
	</cfquery>
					
	<!--- Actualiza Ccuenta y CFcuenta en la tabla ID18 --->
	<cfquery datasource="#session.dsn#">
		update #LvarID180#
		set  Ccuenta  = (( select min(cf.Ccuenta)  from #CFformatos# cf where cf.CFformatoSF = #LvarID180#.CFformato )),
			 CFcuenta = (( select min(cf.CFcuenta) from #CFformatos# cf where cf.CFformatoSF = #LvarID180#.CFformato ))
		where ID = #GvarID#
		  and CFcuenta is null
	</cfquery>			

	<!--- Actualiza CFformato en la tabla ID18 si la cuenta no es nula y el formato de cuenta no tiene guiones --->
	<cfquery datasource="#session.dsn#">
		update #LvarID180#
		set  CFformato  = (( select min(cf.CFformato) from #CFformatos# cf where cf.CFcuenta = #LvarID180#.CFcuenta ))
		where ID = #GvarID#
		  and CFcuenta is not null
	</cfquery>			
		
	<!--- 
		Verifica si algún CFcuenta esta en nulo y no tiene guiones en el formato...
		En este caso, coloca los guiones en la cuenta según la máscara de la cuenta
	--->
			
	<cfquery name="rsFormatos" datasource="sifinterfaces">
		select distinct CFformato
		from ID180
		where ID = #GvarID#
		  and CFcuenta is null
		  and CFformato NOT LIKE '%-%'
	</cfquery>

	<cfloop query="rsFormatos">

		<!--- Obtiene la cuenta mayor --->
		<cfset LvarCuentaMayor = Mid(rsFormatos.CFformato,1,4)>
		<cfset LvarCuentaControl = rsFormatos.CFformato>
		<cfset LvarCuentaTotal = rsFormatos.CFformato>
		
		<!--- OBTIENE LA MASCARA DE LA CUENTA --->
		<cfquery name="rsMascara" datasource="#session.DSN#">
			select  CPVformatoF 
			from CPVigencia
			where Ecodigo =   #session.ecodigo#
			  and Cmayor  =  '#LvarCuentaMayor#'
		</cfquery>
		
		<cfif rsMascara.recordcount eq 0>
			<cfthrow message="No existe mascara para la cuenta contable #LvarCuentaMayor#">
		</cfif>
		
		<cfset Mascara = rsMascara.CPVformatoF>
		<cfset Cuenta="">
		
		<cfloop condition="find('-',Mascara,1) GT 0">
		
			<cfset pos = find("-",Mascara,1)>
			<cfset subhilera = Mid(LvarCuentaTotal,1,pos-1)>
			<cfset LvarCuentaTotal = Mid(LvarCuentaTotal,pos,len(LvarCuentaTotal))>
			<cfset Mascara = Mid(Mascara,pos+1,len(Mascara))>
		
			<cfif Cuenta eq "">
				<cfset Cuenta = subhilera>
			<cfelse>
				<cfset Cuenta = Cuenta & "-" & subhilera>
			</cfif>
		
		</cfloop>

		<cfset Cuenta = Cuenta & "-" & LvarCuentaTotal>
		
		<cfloop condition="Mid(Cuenta,len(Cuenta),1) EQ '-'">
			<cfset Cuenta = Mid(Cuenta,1,len(Cuenta)-1)>			
		</cfloop>
		
		<cfquery datasource="sifinterfaces">
			update ID180
			set CFformato   = '#Cuenta#'
			where CFformato = '#LvarCuentaControl#'
			  and ID = #GvarID#
			  and CFcuenta is null
		</cfquery>
	</cfloop>

	<!--- Actualiza la Oficina --->
	<cfquery name="rsActualiza" datasource="sifinterfaces">
		select distinct Oficodigo
		from ID180
		where ID = #GvarID#
		  and Oficodigo is not null
	</cfquery>
	<cfloop query="rsActualiza">
		<cfset LvarOficodigo = rsActualiza.Oficodigo>
		<cfquery name="rsDatos" datasource="#session.DSN#">
			select Ocodigo
			from Oficinas
			where Ecodigo   = #session.Ecodigo#
			  and Oficodigo = '#LvarOficodigo#'
		</cfquery>
		<cfif rsDatos.recordcount GT 0>
			<cfset LvarOcodigo = rsDatos.Ocodigo>
			<!---<cfquery datasource="sifinterfaces">
				update ID180
				set Ocodigo = #LvarOcodigo#
				where ID = #GvarID#
				  and Oficodigo is not null
				  and Oficodigo = '#LvarOficodigo#'
			</cfquery>--->
		</cfif>
	</cfloop>

	<!--- Actualiza la Moneda --->
	<cfquery name="rsActualiza" datasource="sifinterfaces">
		select distinct Miso4217
		from ID180
		where ID = #GvarID#
		  and Miso4217 is not null
	</cfquery>
	<cfloop query="rsActualiza">
		<cfset LvarMiso4217 = rsActualiza.Miso4217>
		<cfquery name="rsDatos" datasource="#session.DSN#">
			select Mcodigo
			from Monedas
			where Ecodigo   = #session.Ecodigo#
			  and Miso4217  = '#LvarMiso4217#'
		</cfquery>
		<cfif rsDatos.recordcount GT 0>
			<cfset LvarMcodigo = rsDatos.Mcodigo>
			<!---<cfquery datasource="sifinterfaces">
				update ID180
				set Mcodigo = #LvarMcodigo#
				where ID = #GvarID#
				  and Miso4217 is not null
				  and Miso4217 = '#LvarMiso4217#'
			</cfquery>--->
		</cfif>
	</cfloop>

	<cfquery name="rsTotales" datasource="sifinterfaces">
		select
			sum(case when Tipo = 'D' then Total_Linea else 0.00 end) as Debitos,
			sum(case when Tipo = 'C' then Total_Linea else 0.00 end) as Creditos,
			count(1) as Cantidad
		from ID180
		where ID = #GvarID#
	</cfquery>
	<cfset LvarTotalDebitos = rsTotales.Debitos>
	<cfset LvarTotalCreditos = rsTotales.Creditos>
	<cfset LvarTotalRegistros = rsTotales.Cantidad>

	<cftransaction>
		<!--- Insercion en la Tabla de Interfaz de Asientos (Encabezado) --->
		<cfquery name="rsInput" datasource="#session.DSN#">
			insert into EContablesImportacion 
			(
				   Ecodigo
				,  Cconcepto
				,  Eperiodo
				,  Emes
				,  Efecha
				,  Edescripcion
				,  Edocbase
				,  Ereferencia
				,  BMfalta
				,  BMUsucodigo
				,  ECIreversible
			)
			values (
				   #Session.Ecodigo#
				,  #LvarCconcepto#
				,  #LvarPeriodo#
				,  #LvarMes#
				,  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">
				,  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarDescripcion#">
				,  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarEdocbase#">
				,  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarEreferencia#">
				,  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFalta#">
				,  #Session.Usucodigo#
				,  #LvarECIreversible#
				)
			<cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="rsInput" verificar_transaccion="false">
	
		<cfif rsInput.recordCount EQ 0>
			<cftransaction action="rollback">
			<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 180=Interfaz de Asientos Contables">
		</cfif>
		<cfset ECImp_id = rsInput.identity>
		
		<!--- Insercion en la Tabla de Interfaz de Asientos (Detalle) --->
		<cfquery name="rsInput" datasource="#session.DSN#">
			INSERT into DContablesImportacion (			  
				  ECIid, 				DCIconsecutivo,			  Ecodigo,				  DCIEfecha,
				  Eperiodo,				Emes,					  Ddescripcion,			  Ddocumento,
				  Dreferencia,			Dmovimiento,			  CFformato,			  Ccuenta,
				  CFcuenta,				Ocodigo,				  Mcodigo,				  Doriginal,
				  Dlocal,				Dtipocambio,			  Cconcepto,			  BMfalta,
				  BMUsucodigo,			EcodigoRef,				  Referencia1,			  Referencia2,
				  Referencia3, 			CFid, 					  CFcodigo
			)
			select	#ECImp_id#, 		a.DConsecutivo,		a.Ecodigo, 			#LvarFecha#
					, #LvarPeriodo#, 	#LvarMes#, 				a.Descripcion_Detalle, 	'#LvarEdocbase#'
					, null,				a.Tipo, 			    a.CFformato, 		a.Ccuenta
					, a.CFcuenta, 		#LvarOcodigo#, 			#LvarMcodigo#, 		a.Total_Linea
					, a.Total_Linea, 	1, 						a.CConcepto, 		#LvarFalta#
					, #Session.Usucodigo#, a.Ecodigo, 			null, 		 		null
					, null
					,    <cf_jdbcquery_param cfsqltype="cf_sql_decimal" value="null">,					null
			  from #LvarID180# a
			 where ID = #GvarID#
		</cfquery>

		<!--- **************************************** --->
		<!---      Insercion en la tabla intermedia.   --->
		<!--- **************************************** --->
		
		<cfquery name="rsEncInterfaz180" datasource="#session.DSN#">
			select count(1) as Cantidad
			from EContablesInterfaz18
			where ID = #GvarID#
		</cfquery>
		
		<cfif rsEncInterfaz180.Cantidad GT 0>
			<cfthrow message="Error, El ID #GvarID# ingresado ya existe!">
		</cfif>

	
		<cfquery datasource="#session.DSN#">
			insert into EContablesInterfaz18 ( ID,	ECIid,	Ecodigo,	ImpFecha,	ImpPeriodo,	ImpMes, BMUsucodigo, ASTPorProcesar)
			values
			(
				#GvarID#,
				#ECImp_id#,
				#session.ecodigo#,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				#LvarPeriodo#,
				#LvarMes#,
				#Session.Usucodigo#,
				1
			)
		</cfquery>
       
	   <!--- Consulta para verificar si se tiene que aplicar el asiento importado --->
       <cfquery name="rsPvalor" datasource="#session.DSN#">
	      select Pvalor from Parametros where Ecodigo = #session.Ecodigo# and Pcodigo = 2400
	   </cfquery>
	   <cfif rsPvalor.Pvalor eq 1>	   
	     <cfinvoke component="sif.Componentes.CG_AplicaImportacionAsiento" method="CG_AplicaImportacionAsiento">
			<cfinvokeargument name="ECIid" value="#ECImp_id#">
			<cfinvokeargument name="TransaccionActiva" value="true">
         </cfinvoke>	   
	   </cfif>
	   
	   
	   <!---Genera las ordenes de pago--->
	   <cfquery name="rsOrdenes" datasource="sifinterfaces">
	   		select * from ID180
			where 
			Genera_Orden = 1>
	   </cfquery>
	   
	   <cfloop query="rsOrdenes">
	   <cfif isdefined("rsOrdenes") and rsOrdenes GT 0>
	   		<cfinvoke component="interfacesSoin.Componentes.TS_GeneraSolicitudPago" method="TS_GeneraSolicitud">
			<cfinvokeargument name="Beneficiario" value="##LvarID180#.Empleado#">
			<cfinvokeargument name="Documento" value="#LvarID180#.DescripcionDetalle">
			<cfinvokeargument name="Moneda" value="#LvarMcodigo#">
			<cfinvokeargument name="Importe" value="#LvarID180#.Total_Linea">
			<cfinvokeargument name="Descripcion" value="#LvarEdocbase#'_'#LvarID180#.DConsecutivo">
			<cfinvokeargument name="Cuenta" value="#Ccuenta#">
			<cfinvokeargument name="Oficina" value="#LvarID180#.Total_Linea">
         </cfinvoke>	   	
	   </cfif>
	   </cfloop>
	</cftransaction>

	<cfquery name="rsControlInt" datasource="sifinterfaces">
		UPDATE ControlInterfaz18
		set ProcesoInt   = 1,
			DebitosInt   = #LvarTotalDebitos#,
			CreditosInt  = #LvarTotalCreditos#,
			NumLineasInt = #LvarTotalRegistros#
		where ID = #GvarID#
	</cfquery>

	<cfquery datasource="#session.DSN#">
		delete from #CFformatos#
	</cfquery>
</cfif>

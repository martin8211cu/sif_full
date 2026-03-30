<!--- 
La oprecion del proceso es la siguiente:
	
	- Se toman los datos de las tablas de interfaces, se completan y se incluyen primeramente en 
	las tablas EContablesImportacion y DContablesImportacion, luego se inserta en la tabla Intermedia, 
	los siguientes datos (ID,Iddocimportacion,Fecha,Periodo,Mes,Ecodigo) inicialmente

	- Luego de que se da lo anterior, se quedan los asientos en las tablas de importacion, hasta que los 
	mismos sean aplicados, momento en el cual se actualizan los campos restantes de la tabla intermedia, y
	fuera de la transaccion se dispara el SP de salida en caso de ser necesario.
--->

<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<cftransaction isolation="read_uncommitted">
<!--- ********************************************************** --->
<!--- Actualiza los campos en la tabla de detalle de la interfaz --->
<!--- ********************************************************** --->

	<!--- Actualiza el campo CFformato --->
	<cfquery name="rsFormatos" datasource="sifinterfaces">
	Select distinct CFformato
	from ID18
	Where ID = #GvarID#
	</cfquery>


	<cfoutput query="rsFormatos">
	
		<!--- Obtiene la cuenta mayor --->
		<cfset V_CMayor = Mid(rsFormatos.CFformato,1,4)>
		

		<!--- OBTIENE LA MASCARA DE LA CUENTA --->
		<cfquery name="rsMascara" datasource="sifinterfaces">
		select  CPVformatoF 
		from <cf_dbdatabase datasource="#session.DSN#" table="CPVigencia"> 
		where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and Cmayor  =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#V_CMayor#">
		</cfquery>

		<cfif rsMascara.recordcount eq 0>
			<cfthrow message="No existen mascaras para algunas de las cuentas contables">
		</cfif>

		<cfset Cuenta="">
		<cfset CuentaTotal = rsFormatos.CFformato>
		<cfset Mascara = rsMascara.CPVformatoF>

		<cfloop condition="find('-',Mascara,1) GT 0">

			<cfset pos = find("-",Mascara,1)>
			<cfset subhilera = Mid(CuentaTotal,1,pos-1)>
			<cfset CuentaTotal = Mid(CuentaTotal,pos,len(CuentaTotal))>
			<cfset Mascara = Mid(Mascara,pos+1,len(Mascara))>

			<cfif Cuenta eq "">
				<cfset Cuenta = subhilera>
			<cfelse>
				<cfset Cuenta = Cuenta & "-" & subhilera>
			</cfif>

		</cfloop>
		<cfset Cuenta = Cuenta & "-" & CuentaTotal>

		<cfloop condition="Mid(Cuenta,len(Cuenta),1) EQ '-'">
			<cfset Cuenta = Mid(Cuenta,1,len(Cuenta)-1)>			
		</cfloop>
		
		<cfset FormatoFinal = Cuenta>

		<cfquery datasource="sifinterfaces">
		Update ID18
		set CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FormatoFinal#">
		Where CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFormatos.CFformato#">
		  and ID = #GvarID#
		</cfquery>

	</cfoutput>


	<!--- Actualiza Ccuenta y CFcuenta --->
	<cfquery name="rsInput" datasource="sifinterfaces">
	Update ID18
	set  Ccuenta  = c.Ccuenta,
		 CFcuenta = c.CFcuenta
	from  <cf_dbdatabase datasource="#session.DSN#" table="CFinanciera c"> <!--- minisif..CFinanciera c --->
	Where ID18.CFformato = 	c.CFformato
	</cfquery>

	<!--- Actualiza la Oficina --->
	<cfquery name="rsInput" datasource="sifinterfaces">
	Update ID18
	set Ocodigo = a.Ocodigo
	from  <cf_dbdatabase datasource="#session.DSN#" table="Oficinas a"> <!--- minisif..Oficinas a --->
	Where ID18.Oficodigo = a.Oficodigo

	</cfquery>

	<!--- Actualiza la Monedas --->
	<cfquery name="rsInput" datasource="sifinterfaces">
	Update ID18
	set Mcodigo = a.Mcodigo
	from <cf_dbdatabase datasource="#session.DSN#" table="Monedas a"> <!--- minisif..Monedas a --->
	Where ID18.Miso4217 = a.Miso4217
	</cfquery>

<!--- ********************************************************** --->
<!---      Inserta en las tablas del Importador de Asientos.     --->
<!--- ********************************************************** --->

	<!--- Insercion en la Tabla de Interfaz de Asientos (Encabezado) --->
	<cfquery name="rsInput" datasource="sifinterfaces">
		<!--- INSERT minisif..EContablesImportacion( --->
		INSERT <cf_dbdatabase datasource="#session.DSN#" table="EContablesImportacion">(
			  Ecodigo,
			  Cconcepto,
			  Eperiodo,
			  Emes,
			  Efecha,
			  Edescripcion,
			  Edocbase,
			  Ereferencia,
			  BMfalta,
			  BMUsucodigo
		)
		Select
				   i.Ecodigo
				,  i.Cconcepto
				,  i.Eperiodo
				,  i.Emes
				,  i.Efecha
				,  i.Edescripcion
				,  i.Edocbase
				,  i.Ereferencia
				,  i.Falta
				,  #Session.Usucodigo#
		  from IE18 i
		 where ID = #GvarID#

		<cf_dbidentity1 datasource="sifinterfaces">
	</cfquery>
	<cf_dbidentity2 datasource="sifinterfaces" name="rsInput">

	<cfif rsInput.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 18=Interfaz de Asientos Contables">
	</cfif>

	<cfset ECImp_id = rsInput.identity>

	<!--- Insercion en la Tabla de Interfaz de Asientos (Detalle) --->
	<cfquery name="rsInput" datasource="sifinterfaces">
		<!--- INSERT minisif..DContablesImportacion( --->
		INSERT <cf_dbdatabase datasource="#session.DSN#" table="DContablesImportacion">(
			  ECIid,
			  DCIconsecutivo,
			  Ecodigo,
			  DCIEfecha,
			  Eperiodo,
			  Emes,
			  Ddescripcion,
			  Ddocumento,
			  Dreferencia,
			  Dmovimiento,
			  CFformato,
			  Ccuenta,
			  CFcuenta,
			  Ocodigo,
			  Mcodigo,
			  Doriginal,
			  Dlocal,
			  Dtipocambio,
			  Cconcepto,
			  BMfalta,
			  BMUsucodigo,
			  EcodigoRef
		)
		Select	#ECImp_id#
				, id.DCIconsecutivo
				, id.Ecodigo
				, id.DCIEfecha
				, id.Eperiodo
				, id.Emes
				, id.Ddescripcion
				, id.Ddocumento
				, id.Dreferencia
				, id.Dmovimiento
				, id.CFformato
				, id.Ccuenta
				, id.CFcuenta
				, id.Ocodigo
				, id.Mcodigo
				, id.Doriginal
				, id.Dlocal
				, id.Dtipocambio
				, id.Cconcepto
				, id.BMfalta
				, #Session.Usucodigo#
				, id.EcodigoRef
		  from ID18 id
		 where ID = #GvarID#
	</cfquery>

<!--- ********************************************************** --->
<!---      		  Insercion en la tabla intermedia.     		 --->
<!--- ********************************************************** --->
	
	<cfquery name="rsVariables" datasource="sifinterfaces">
		Select i.Eperiodo, i.Emes
		  from IE18 i
		 where ID = #GvarID#
	</cfquery>
	
	<cfset VPeriodo = rsVariables.Eperiodo>
	<cfset VMes = rsVariables.Emes>

	<cfquery datasource="sifinterfaces">
	<!--- INSERT minisif..EContablesInterfaz18( --->
	INSERT <cf_dbdatabase datasource="#session.DSN#" table="EContablesInterfaz18">(
		   ID,	ECIid,	Ecodigo,	ImpFecha,	ImpPeriodo,	ImpMes, BMUsucodigo)
	Values
	(
		<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarID#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#ECImp_id#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSdateformat(Now(),'dd/mm/yyyy')#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#VPeriodo#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#VMes#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	)
	</cfquery>
	
</cftransaction>
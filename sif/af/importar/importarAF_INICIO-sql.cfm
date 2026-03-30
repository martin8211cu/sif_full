<!---*********************************************************************************************************************************************************************************************************************************************************************************************
Importación de Saldos de Activos Fijos sin retirar
Fecha de Creación: 08/06/2006
Creado por: Dorian Abarca Gómez.
Columnas esperadas:
Ecodigo	Placa	Descripcion	Serie	Marca	Modelo	EmpResponsable	ValorRescate	FechaIniDepr	FechaIniRev	CFuncional	TipoAF	Categoria	Clase	PerUltRev	MesUltRev	 VidaUtilAdq 	 VidaUtilRev 	 SaldoVUAdq 	 SaldoVURev 	ValorAdq	ValorMej	ValorRev	DeprAcumAdq	DeprAcumMej	 DeprAcumRev 	Metodo	Depreciable	Revaluable	FechaAdq
Ejemplo de Archivo de Importación:
1	20-160601	Edificio de Oficinas 20-160601	EDF1606	00769	00769-001		56305973.42	19840101	19840101	01	02011	02	02-04	20040930	20040930	480	480	231	231	563059734.18	5167370.61	292087237.11	262878513.40	2680573.50	608266.08	L	S	S	19840101
1	20-160602	Edificio de Oficinas 20-160602	EDF1606	00769	00769-001		55714482.91	19840101	19840101	01	02011	02	02-04	20040930	20040930	480	480	231	231	557144829.10	5512417.94	289018880.10	260116992.09	2859566.81	601873.67	L	S	S	19840101
1	20-160603	Edificio de Oficinas 20-160603	EDF1606	00769	00769-001		55476788.99	19840101	19840101	01	02011	02	02-04	20040930	20040930	480	480	231	231	554767889.89	5299999.71	287785842.88	259007258.59	2749374.85	599304.84	L	S	S	19840101
Comentarios de Programación:
1. Este programa es de Importación de un Archivo de Texto, y será utilizado para importar los saldos de Activos Fijos en el Periodo y Mes de Auxiliares.
2. Primero se realizan las validaciones de cada dato, de manera masiva y si hay algún error será devuelto al usuario en una lista que indica, la Placa que contiene errores, y la lista de errores encontrados para esa Empresa/Placa por línea.
3. Si todos los datos en el archivo son válidos y existen en la Base de Datos, se inicia el proceso.
*********************************************************************************************************************************************************************************************************************************************************************************************--->
<cf_dbfunction name="OP_concat"	returnvariable="_Cat" >
<cfparam name="Lvar_Debug" default="false">
<cfparam name="Lvar_Retirados" default="false">
<cfif isdefined("form.Debug") and len(trim(form.Debug)) gt 0 and form.Debug>
	<cfset Lvar_Debug = true>
</cfif>
<cfif isdefined("form.Retirados") and len(trim(form.Retirados)) gt 0 and form.Retirados>
	<cfset Lvar_Retirados = true>
</cfif>
<cfif Lvar_Debug><cfdump var="#LSTimeFormat(now(),'HH:MM:SS')#"></cfif>
<!--- Consultas Generales --->
<!--- Nombre de la Corporación --->
<cfquery name="rsCE" datasource="asp">
	select CEnombre
	from CuentaEmpresarial
	where CEcodigo = #session.cecodigo#
</cfquery>
<!--- Funciona de Validación General de a existencia de un dato en la Base de Datos --->
<cffunction 
	access="private" 
	name="fnValida"
	output="false" 
	returntype="boolean">
	<cfargument name="Columna" 		required="true">
	<cfargument name="Type" 		required="false" default="S">
	<cfargument name="Tabla" 		required="true">
	<cfargument name="Filtro" 		required="true">
	<cfargument name="Mensaje" 		required="true">
	<cfargument name="ErrorNum" 	required="true"/>
	<cfargument name="filtroGral" 	required="false" default=""/>
	<cfargument name="joinEmpresas" required="false" default="false"><!--- true indica que haga join con Empresas, básicamente para obtener el nombre de la Empresa para el mensaje de error --->
	<cfargument name="exists" 		required="false" default="false"><!--- true indica que hay error cuando existe --->
	<cfargument name="permiteNulos" required="false" default="false" type="boolean"/>
	<cfargument name="debug" 		required="false" default="false" type="boolean"/>
	<cfif Arguments.debug>
		<cf_dumptable name="#table_name#" abort="false">
	</cfif>
		
	<cfquery datasource="#session.dsn#">
		insert into #AF_INICIO_ERROR# (Ecodigo, Placa, Mensaje, DatoIncorrecto, ErrorNum)		
		select 	#table_name#.Ecodigo, 
				#table_name#.Placa, 
				<cf_dbfunction name="concat" args="'#ErrorNum#. La Columna #Arguments.Columna# contiene un dato que ';#PreserveSingleQuotes(Arguments.Mensaje)#;'.'" delimiters=";"> as Mensaje, 
		<cfif Arguments.Type EQ 'D'>
			<cf_dbfunction name="date_format" args="#table_name#.#Arguments.Columna#,DD/MM/YYYY"> as DatoIncorrecto, 
		<cfelseif Arguments.Type EQ 'M'>
			<cf_dbfunction name="to_char_currency" args="#table_name#.#Arguments.Columna#"> as DatoIncorrecto, 
		<cfelse>
			<cf_dbfunction name="to_char" args="#table_name#.#Arguments.Columna#"> as DatoIncorrecto, 
		</cfif>
		#Arguments.ErrorNum# as ErrorNum
		from #table_name# <cfif joinEmpresas>inner join Empresas on Empresas.Ecodigo = #table_name#.Ecodigo</cfif>
		where #table_name#.Ecodigo is not null
		and #table_name#.Placa is not null
		<cfif len(trim(Arguments.Tabla)) GT 0>
			and <cfif not Arguments.exists> not </cfif>exists(
				select 1
				from #PreserveSingleQuotes(Arguments.Tabla)#
				where #PreserveSingleQuotes(Arguments.filtro)#
			)
		</cfif>
		<cfif len(trim(Arguments.filtroGral)) GT 0>
			and #PreserveSingleQuotes(Arguments.filtroGral)#
		</cfif>
		<cfif Arguments.permiteNulos>
			and #table_name#.#Arguments.Columna# is not null
		</cfif>
		<cfif Arguments.debug><cfabort></cfif>
	</cfquery>	
	<cfreturn true/>
</cffunction>
<!--- Tabla Temporal de Errores --->
<cf_dbtemp name="afInicioErr01" returnvariable="AF_INICIO_ERROR" datasource="#session.dsn#">
	<cf_dbtempcol name="Ecodigo" 		type="integer" 		mandatory="yes">
	<cf_dbtempcol name="Placa" 			type="char(20)" 	mandatory="no">
	<cf_dbtempcol name="Mensaje" 		type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="DatoIncorrecto" type="varchar(40)" 	mandatory="no">
	<cf_dbtempcol name="ErrorNum" 		type="integer" 		mandatory="yes">
</cf_dbtemp>

<!--- Tabla Temporal de Activos que ya tienen un vale creado --->
<cf_dbtemp name="AF_CONVALES" returnvariable="AF_CONVALES" datasource="#session.dsn#">
	<cf_dbtempcol name="Ecodigo" 	type="integer" 	mandatory="yes">
	<cf_dbtempcol name="Placa" 		type="char(20)" mandatory="no">
	<cf_dbtempcol name="Pasar" 	type="integer" 		mandatory="no">
</cf_dbtemp>
<!--- Crea la FechaAux a partir del periodo / mes y le pone el primer dia del mes --->
<cfquery name="Periodo" datasource="#session.dsn#">
    select Pvalor as  valor
	 from Parametros p
	 	inner join #table_name# tm
		on p.Ecodigo = tm.Ecodigo
		and p.Pcodigo = 50
</cfquery>
<cfquery name="Mes" datasource="#session.dsn#">
    select Pvalor as  valor
	 from Parametros p
	 	inner join #table_name# tm
		on p.Ecodigo = tm.Ecodigo
		and p.Pcodigo = 60
</cfquery>
<cfset rsFechaAux = CreateDate(Periodo.valor, mes.valor, 01)>

<!--- Sección de Validación de datos --->
<!--- 100. Ecodigo: Se valida que la Empresa exista para la Corporación. --->
<cfinvoke method="fnValida"
	Columna="Ecodigo"
	Tabla="Empresas"
	Filtro="Empresas.Ecodigo = #table_name#.Ecodigo
		and Empresas.cliente_empresarial = #session.cecodigo#"
	Mensaje="'no corresponde a ninguna Empresa de la Corporación #rsCE.CEnombre#'"
	ErrorNum="100"/>
	
<!---Se agregó una validación, para determinar si el activo se encuentra en tránsito líneas es decir si esta registrado en la tabla
CRDocumentoResponsabilidad, de igual manera si este se encuentra como activo en la tabla AFResponsables.
Si se da el primer caso: Aparecerá el mensaje representado por el error 3100, y en el caso del segundo por el error 3101.
Indicando ambos mensajes (el tipo de documento, el centro de custodia y la identificación del encargado).
Líneas (120-156)--->	

<cfquery name="rsTemp" datasource="#session.dsn#">
	select * from  #table_name#
</cfquery>

<cfquery name="rsTrans" datasource="#session.dsn#">
   insert into #AF_INICIO_ERROR# (Ecodigo, Placa, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Ecodigo,a.CRDRplaca,
     <cf_dbfunction name="concat" args="'La placa se encuentra en tránsito con el documento tipo: ',d.CRTDdescripcion,' asociado al Centro de Custodia: ' , b.CRCCdescripcion, 
	 ' y al Empleado con cedula: ', c.DEidentificacion">, a.CRDRplaca, 3100 
   from CRDocumentoResponsabilidad a
   		inner join #table_name# placas
		on a.CRDRplaca = placas.Placa
		inner join CRCentroCustodia b
		on b.CRCCid = a.CRCCid
			inner join DatosEmpleado c
			on a.DEid = c.DEid
				inner join CRTipoDocumento d
				on a.CRTDid = d.CRTDid
</cfquery>

<cfquery name="rsActiv" datasource="#session.dsn#">
   insert into #AF_INICIO_ERROR# (Ecodigo, Placa, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Ecodigo,a.Aplaca,
     <cf_dbfunction name="concat" args="'La placa se encuentra Activa con el documento tipo: ',b.CRTDdescripcion,' asociado al Centro de Custodia: ' , d.CRCCdescripcion, 
	 ' y al Empleado con cedula: ', e.DEidentificacion">, a.Aplaca, 3101 
   from Activos a
   	inner join #table_name# placas
   		on a.Aplaca  = rtrim(placas.Placa)
   	   and a.Ecodigo = placas.Ecodigo
   inner join AFResponsables r
   on	a.Aid = r.Aid
   and #Now()# between r.AFRfini and r.AFRffin
		inner join CRTipoDocumento b
			on r.CRTDid = b.CRTDid
				inner join CRCentroCustodia d
				on r.CRCCid = d.CRCCid
					inner join DatosEmpleado e
					on d.DEid = e.DEid
</cfquery>

<!--- 101. Ecodigo: Se valida que la Empresa nunca venga nula.--->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Ecodigo, Placa, Mensaje, DatoIncorrecto, ErrorNum)
	select -1 as Ecodigo, '' as Placa, '101. Existen ' #_Cat# <cf_dbfunction name="to_char" args="count(1)"> #_Cat# ' Registros con la Empresa en blanco.' as Mensaje, 
	<cf_dbfunction name="to_char" args="count(1)"> as DatoIncorrecto, 101 as ErrorNum
	from #table_name#
	where Ecodigo is null
	having count(1) > 0
</cfquery>
<!--- 102. Ecodigo: Se valida que la Placa nunca venga nula. --->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Ecodigo, Placa, Mensaje, DatoIncorrecto, ErrorNum)
	select #table_name#.Ecodigo, '' as Placa, ('102. Existen ' #_Cat# <cf_dbfunction name="to_char" args="count(1)"> #_Cat# ' Placas nulas para la Empresa ' #_Cat# Edescripcion #_Cat# '.') as Mensaje, 
	<cf_dbfunction name="to_char" args="#table_name#.Ecodigo"> as DatoIncorrecto, 102 as ErrorNum
	from #table_name# inner join Empresas on Empresas.Ecodigo = #table_name#.Ecodigo
	where Placa is null
	group by #table_name#.Ecodigo, Edescripcion
	having count(1) > 0
</cfquery>
<cfinvoke method="fnValida"
	Columna="Ecodigo"
	Tabla="Empresas
		inner join Parametros
		on Parametros.Ecodigo = Empresas.Ecodigo
		and Parametros.Pcodigo = 910
		and Pvalor is not null"
	Filtro="Empresas.Ecodigo = #table_name#.Ecodigo
		and Empresas.cliente_empresarial = #session.cecodigo#"
	Mensaje="'no tiene ningún tipo de documento de responsabilidad definido'"
	ErrorNum="103"/>
<!--- 200. Placa: Se valida que la Placa no exista para la Empresa. --->
<cfinvoke method="fnValida"
	Columna="Placa"
	Tabla="Activos"
	Filtro="Activos.Ecodigo = #table_name#.Ecodigo
		and Activos.Aplaca = rtrim(#table_name#.Placa)"
	Mensaje="'ya existe para la Empresa '#_Cat# Empresas.Edescripcion"
	joinEmpresas="true"
	exists="true"
	ErrorNum="200"/>
<!--- 201. Placa: Se valida que la Placa no venga en mas de una ocasión para la misma Empresa en el archivo. --->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Ecodigo, Placa, Mensaje, DatoIncorrecto, ErrorNum)
	select #table_name#.Ecodigo, Placa, '201. La Placa se encuentra ' #_Cat# <cf_dbfunction name="to_char" args="count(1)"> #_Cat# ' veces en el Archivo para la Empresa ' #_Cat# Edescripcion #_Cat# '.' as Mensaje, 
	<cf_dbfunction name="to_char" args="Placa"> as DatoIncorrecto, 201 as ErrorNum
	from #table_name# inner join Empresas on Empresas.Ecodigo = #table_name#.Ecodigo
	where #table_name#.Ecodigo is not null
	and #table_name#.Placa is not null
	group by #table_name#.Ecodigo, Placa, Edescripcion
	having count(1) > 1
</cfquery>
<!--- 300. Descripcion: se valida que no venga nula. --->
<cfinvoke method="fnValida"
	Columna="Descripcion"
	Tabla=""
	Filtro=""
	FiltroGral="Descripcion is null"
	Mensaje="'está en blanco'"
	joinEmpresas="false"
	ErrorNum="300"/>
<!--- 400. Serie: no se valida. --->
<!--- 500. Marca: Se valida que la marca exista para la Empresa. --->
<cfinvoke method="fnValida"
	Columna="Marca"
	Tabla="AFMarcas"
	Filtro="AFMarcas.Ecodigo = #table_name#.Ecodigo
		and AFMarcas.AFMcodigo = #table_name#.Marca"
	Mensaje="'no existe para la Empresa ' #_Cat#  Empresas.Edescripcion"
	joinEmpresas="true"
	ErrorNum="500"/>
<!--- 600. Modelo: Se valida que el modelo exista para la marca y para la Empresa. --->
<cfinvoke method="fnValida"
	Columna="Modelo"
	Tabla="AFMModelos
		inner join AFMarcas	
		on AFMarcas.Ecodigo = AFMModelos.Ecodigo
		and AFMarcas.AFMid = AFMModelos.AFMid"
	Filtro="AFMModelos.Ecodigo = #table_name#.Ecodigo
		and AFMModelos.AFMMcodigo = #table_name#.Modelo
		and AFMarcas.AFMcodigo = #table_name#.Marca"
 	Mensaje="'no existe para la marca ' #_Cat# #table_name#.Marca #_Cat# ' y la Empresa ' #_Cat# Empresas.Edescripcion"
	joinEmpresas="true"
	ErrorNum="600"/>
<!--- 700. EmpResponsable: Validación del empleado responsable: Se valida que el empleado exista para la Empresa. 
	Se deben permitir nulos, de ser nulo se busca el encargado del centro funcional y si no existe se debe dar error.
	Esta parte de obtener el ecargado del centro funcional para cuando no hay empleado se realiza en la sección de 
	validaciones especiales. --->
	
<!--- Verifica si hay cédulas que están en nulo --->	
<cfquery name="rs" datasource="#session.dsn#">
Select count(1) as esnulo from #table_name# where EmpResponsable is null
</cfquery>

<cfif rs.esnulo gt 0>

	<!--- Si hay cédulas en nulo, se verifica si existe un vale para el activo y se actualiza --->
	<cfquery datasource="#session.dsn#">
	INSERT into #AF_CONVALES#(Ecodigo, Placa, Pasar)
	Select t.Ecodigo, t.Placa, 0
	from #table_name# t, AFResponsables a, Activos b, DatosEmpleado c
	where b.Aplaca  = rtrim(t.Placa)
	  and b.Ecodigo = t.Ecodigo	  
	  and t.EmpResponsable is null	
      and a.Aid = b.Aid
	  and a.Ecodigo = b.Ecodigo
	  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between a.AFRfini and a.AFRffin	  
	  and a.DEid    = c.DEid
	  and a.Ecodigo = c.Ecodigo
	</cfquery>
	
	<!---Actuliza el responsables cuando vienen Null--->
	<cfquery datasource="#session.dsn#" name="PlacasSinRespon">
		select c.DEidentificacion, b.Aplaca, b.Ecodigo
			from AFResponsables a 
				inner join Activos b 
					on a.Aid = b.Aid
				   and a.Ecodigo = b.Ecodigo
				   and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between a.AFRfini and a.AFRffin	  
				inner join DatosEmpleado c
				   on a.DEid    = c.DEid
				  and a.Ecodigo = c.Ecodigo
				inner join #table_name# tm
				   on rtrim(tm.Placa) = b.Aplaca 
			      and tm.Ecodigo     = b.Ecodigo
			where tm.EmpResponsable is null
	</cfquery>
	<cfloop query="PlacasSinRespon">
		<cfquery datasource="#session.dsn#">
			UPDATE #table_name#
				 set EmpResponsable = #PlacasSinRespon.DEidentificacion#
			where '#PlacasSinRespon.Aplaca#'  = rtrim(Placa)
			  and #PlacasSinRespon.Ecodigo# = Ecodigo	  
			  and EmpResponsable is null
		</cfquery>
	</cfloop>
	
	
	<cfquery datasource="#session.dsn#">
	INSERT into #AF_CONVALES#(Ecodigo, Placa, Pasar)
	Select t.Ecodigo, t.Placa, 1
	from #table_name# t, CRDocumentoResponsabilidad a, DatosEmpleado b
	where a.DEid       = b.DEid
	  and a.Ecodigo    = b.Ecodigo
	  and a.CRDRplaca  = t.Placa
	  and a.Ecodigo    = t.Ecodigo
	  and t.EmpResponsable is null
	</cfquery>	
		
	<!---Actuliza el responsables cuando vienen Null--->
	<cfquery datasource="#session.dsn#" name="PlacasSinResponTrans">
		select b.DEidentificacion, a.CRDRplaca, a.Ecodigo
		  from CRDocumentoResponsabilidad a 			  
			inner join DatosEmpleado b
			   on a.DEid    = b.DEid
			  and a.Ecodigo = b.Ecodigo
			inner join #table_name# tm
			   on a.CRDRplaca  = tm.Placa
	          and a.Ecodigo    = tm.Ecodigo
		where tm.EmpResponsable is null
	</cfquery>
	<cfloop query="PlacasSinResponTrans">
		<cfquery datasource="#session.dsn#">
			UPDATE #table_name#
			set EmpResponsable = #PlacasSinResponTrans.DEidentificacion#
			where #PlacasSinResponTrans.CRDRplaca#  = Placa
			  and #PlacasSinResponTrans.Ecodig#o   = Ecodigo
			  and EmpResponsable is null
		</cfquery>	
	</cfloop>
</cfif>

	
<cfinvoke method="fnValida"
	Columna="EmpResponsable"
	Tabla="DatosEmpleado"
	Filtro="DatosEmpleado.Ecodigo = #table_name#.Ecodigo
		and DatosEmpleado.DEidentificacion = #table_name#.EmpResponsable"
	Mensaje="'no existe para la Empresa ' #_Cat# Empresas.Edescripcion"
	joinEmpresas="true"
	permiteNulos="true"
	ErrorNum="700"/>
<!--- 800. ValorRescate --->
<cfquery name="rs" datasource="#session.dsn#">
Select count(1) as esnulo from #table_name# where ValorRescate is null
</cfquery>

<cfif rs.esnulo gt 0>

	<!--- Actualiza el valor de rescate desde la categoria-clase--->
	<cfquery datasource="#session.dsn#" name="PorActClase">
		select b.ACvalorres, a.ACcodigodesc as Categoria, b.ACcodigodesc as Clase, a.Ecodigo
		from ACategoria a
		  inner join AClasificacion b
			 on a.ACcodigo = b.ACcodigo
			and a.Ecodigo  = b.Ecodigo 
		  inner join #table_name# tm
		  	on a.ACcodigodesc = tm.Categoria
		  and b.ACcodigodesc  = tm.Clase
		  and a.Ecodigo       = tm.Ecodigo
		where tm.ValorRescate is null
	</cfquery>
	<cfloop query="PorActClase">
		<cfquery datasource="#session.dsn#">
			UPDATE #table_name#
			set ValorRescate = #PorActClase.ACvalorres#
			where '#PorActClase.Categoria#' = Categoria
			  and '#PorActClase.Clase#'     = Clase
			  and #PorActClase.Ecodigo#   = Ecodigo
			  and ValorRescate is null
		</cfquery>
	</cfloop>
</cfif>

<cf_dbfunction name="to_char_currency" returnvariable="Lto_char_currency_ValorAdq" args="#table_name#.ValorAdq">
<cf_dbfunction name="to_char_currency" returnvariable="Lto_char_currency_DeprAcumAdq" args="#table_name#.DeprAcumAdq">
<cfinvoke method="fnValida"
	Columna="ValorRescate"
	Type="M"
	Tabla=""
	Filtro=""
	FiltroGral="ValorRescate>(ValorAdq-DeprAcumAdq)"
	Mensaje="'es mayor que el valor de Adquisición: ' #_Cat# #PreserveSingleQuotes(Lto_char_currency_ValorAdq)# #_Cat# ' menos su Depreciación Acumulada: ' #_Cat# #PreserveSingleQuotes(Lto_char_currency_DeprAcumAdq)#"
	joinEmpresas="false"
	ErrorNum="800"/>
<cfinvoke method="fnValida"
	Columna="ValorRescate"
	Type="M"
	Tabla=""
	Filtro=""
	FiltroGral="ValorRescate is null or ValorRescate<0"
	Mensaje="'es menor que cero'"
	joinEmpresas="false"
	ErrorNum="801"/>
<!--- 900. FechaIniDepr --->
<cfquery name="rs" datasource="#session.dsn#">
	select Ecodigo
	from #table_name#
	where not exists(
		select 1 
		from Parametros 
		where Ecodigo = #table_name#.Ecodigo
		and Pcodigo = 50)
	and #table_name#.Ecodigo is not null
	and #table_name#.Placa is not null
	union
	select Ecodigo
	from #table_name#
	where not exists(
		select 1 
		from Parametros 
		where Ecodigo = #table_name#.Ecodigo
		and Pcodigo = 60)
	and #table_name#.Ecodigo is not null
	and #table_name#.Placa is not null
</cfquery>
<cfif rs.recordcount gt 0>
	<cf_errorCode	code = "50081"
					msg  = "ERROR DE APLICACION. NO SE HA DEFINIDO PERIODO / MES DE AUXILIARES PARA LA(s) EMPRESA(s) @errorDat_1@."
					errorDat_1="#ValueList(rs.Ecodigo)#"
	>
</cfif>
<cf_dbfunction name="to_number" returnvariable="Lto_number_Pvalor" args="Parametros.Pvalor">
<cf_dbfunction name="datediff" returnvariable="Ldatediff_FechaIniDepr" args="#table_name#.FechaIniDepr|#rsFechaAux#|mm" delimiters="|">
<cf_dbfunction name="to_char" returnvariable="Lto_char_VidaUtilAdq" args="#table_name#.VidaUtilAdq">
<cf_dbfunction name="to_char" returnvariable="Lto_char_SaldoVUAdq" args="#table_name#.SaldoVUAdq">

<cfinvoke method="fnValida"
	Columna="FechaIniDepr"
	Type="D"
	Tabla="Parametros"
	Filtro="Parametros.Ecodigo = #table_name#.Ecodigo
		and Parametros.Pcodigo = 60
		and #table_name#.SaldoVUAdq > 0
		and (#PreserveSingleQuotes(Ldatediff_FechaIniDepr)#+1) > 0
		and (#PreserveSingleQuotes(Ldatediff_FechaIniDepr)#+1) - (#table_name#.VidaUtilAdq-#table_name#.SaldoVUAdq)> 0"
	FiltroGral="(#table_name#.Depreciable='S')"
	Mensaje="'no corresponde con la diferencia entre la vida util de adquisición: ' #_Cat# #PreserveSingleQuotes(Lto_char_VidaUtilAdq)# #_Cat# ', y su saldo: ' #_Cat# #PreserveSingleQuotes(Lto_char_SaldoVUAdq)#"
	joinEmpresas="false"
	exists="true"
	ErrorNum="900"/>
<cfinvoke method="fnValida"
	Columna="FechaIniDepr"
	Type="D"
	Tabla="Parametros"
	Filtro="Parametros.Ecodigo = #table_name#.Ecodigo
		and Parametros.Pcodigo = 60
		and (#PreserveSingleQuotes(Ldatediff_FechaIniDepr)#+1) <= 0
		and (#table_name#.VidaUtilAdq <> #table_name#.SaldoVUAdq)"
	FiltroGral="(#table_name#.Depreciable='S')"
	Mensaje="'es posterior a la fecha de auxiliares, y la vida útil y su saldo son distintos'"
	joinEmpresas="false"
	exists="true"
	ErrorNum="910"/>
<cfinvoke method="fnValida"
	Columna="FechaIniDepr"
	Type="D"
	Tabla="Parametros"
	Filtro="Parametros.Ecodigo = #table_name#.Ecodigo
		and Parametros.Pcodigo = 60
		and (#PreserveSingleQuotes(Ldatediff_FechaIniDepr)#+1) <= 0
		and ((#table_name#.DeprAcumAdq+#table_name#.DeprAcumMej+#table_name#.DeprAcumRev) > 0.00 )"
	FiltroGral="(#table_name#.Depreciable='S')"
	Mensaje="'es posterior a la fecha de auxiliares, y los saldos de depreciacion son mayores que cero'"
	joinEmpresas="false"
	exists="true"
	ErrorNum="920"/>
<cfinvoke method="fnValida"
	Columna="FechaIniDepr"
	Type="D"
	Tabla="Parametros"
	Filtro="Parametros.Ecodigo = #table_name#.Ecodigo
		and Parametros.Pcodigo = 60
		and #table_name#.SaldoVUAdq = 0
		and (#PreserveSingleQuotes(Ldatediff_FechaIniDepr)#+1) > 0
		and (#PreserveSingleQuotes(Ldatediff_FechaIniDepr)#+1) <> (#table_name#.VidaUtilAdq-#table_name#.SaldoVUAdq)
		and (#table_name#.ValorAdq+#table_name#.ValorMej+#table_name#.ValorRev) - 
			(#table_name#.DeprAcumAdq+#table_name#.DeprAcumMej+#table_name#.DeprAcumRev) <> coalesce(#table_name#.ValorRescate,0.00)"
	FiltroGral="(#table_name#.Depreciable='S')"
	Mensaje="'indica que el activo está totalmente depreciado pero su valor en libros no es igual al valor de rescate'"
	joinEmpresas="false"
	exists="true"
	ErrorNum="930"/>
<!--- 1000. FechaIniRev (En el datediff se puso la Fecha de Inicio de Dep. para que calcule el tiempo 
transcurrido en su totalidad en caso de Dep. Teorica, porque la Revaluacion debe morir con el AF) --->
<cf_dbfunction name="to_number" returnvariable="Lto_number_Pvalor" args="Parametros.Pvalor">
<cf_dbfunction name="datediff" returnvariable="Ldatediff_FechaIniRev" args="#table_name#.FechaIniDepr|#rsFechaAux#|mm" delimiters="|">
<cf_dbfunction name="to_char" returnvariable="Lto_char_VidaUtilRev" args="#table_name#.VidaUtilRev">
<cf_dbfunction name="to_char" returnvariable="Lto_char_SaldoVURev" args="#table_name#.SaldoVURev">
<cfinvoke method="fnValida"
	Columna="FechaIniRev"
	Type="D"
	Tabla=""
	Filtro=""
	FiltroGral="(#table_name#.SaldoVURev > 0) and (#PreserveSingleQuotes(Ldatediff_FechaIniRev)#+1) - (#table_name#.VidaUtilRev-#table_name#.SaldoVURev) > 0 and (#table_name#.Revaluable='S')"
	Mensaje="'no corresponde con la diferencia entre la vida util de revaluación: ' #_Cat# #PreserveSingleQuotes(Lto_char_VidaUtilRev)# #_Cat# ', y su saldo: ' #_Cat# #PreserveSingleQuotes(Lto_char_SaldoVURev)#"
	joinEmpresas="false"
	exists="false"
	permiteNulos="true"
	ErrorNum="1000"/>
<cf_dbfunction name="to_datechar" returnvariable="Lto_datechar_FechaIniRev" args="#table_name#.FechaIniRev">
<cf_dbfunction name="to_datechar" returnvariable="Lto_datechar_FechaIniDepr" args="#table_name#.FechaIniDepr">
<cf_dbfunction name="date_format" returnvariable="Ldate_format_FechaIniDepr" args="#table_name#.FechaIniDepr,DD/MM/YYYY">
<cfinvoke method="fnValida"
	Columna="FechaIniRev"
	Type="D"
	Tabla=""
	Filtro=""
	FiltroGral="#PreserveSingleQuotes(Lto_datechar_FechaIniRev)#<#PreserveSingleQuotes(Lto_datechar_FechaIniDepr)# AND (#table_name#.Revaluable='S') "
	Mensaje="'es menor que la fecha de inicio de depreciación: ' #_Cat# #PreserveSingleQuotes(Ldate_format_FechaIniDepr)#"
	joinEmpresas="false"
	exists="false"
	permiteNulos="true"
	ErrorNum="1001"/>
<!--- 1100. CFuncional: Se valida que el centro funcional exista para la Empresa --->
<cfinvoke method="fnValida"
	Columna="CFuncional"
	Tabla="CFuncional"
	Filtro="CFuncional.Ecodigo = #table_name#.Ecodigo
		and CFuncional.CFcodigo = #table_name#.CFuncional"
	Mensaje="'no existe para la Empresa '#_Cat# Empresas.Edescripcion"
	joinEmpresas="true"
	ErrorNum="1100"/>
<cfinvoke method="fnValida"
	Columna="CFuncional"
	Tabla="CFuncional
		inner join CRCCCFuncionales
		on CRCCCFuncionales.CFid = CFuncional.CFid"
	Filtro="CFuncional.Ecodigo = #table_name#.Ecodigo
		and CFuncional.CFcodigo = #table_name#.CFuncional"
	Mensaje="'no tiene definido un centro de custodia para el centro funcional ' #_Cat# #table_name#.CFuncional #_Cat# ' y la Empresa '#_Cat# Empresas.Edescripcion"
	joinEmpresas="true"
	ErrorNum="1101"/>
<!--- 1200. TipoAF: Se valida que el tipo exista para la Empresa --->
<cfinvoke method="fnValida"
	Columna="TipoAF"
	Tabla="AFClasificaciones"
	Filtro="AFClasificaciones.Ecodigo = #table_name#.Ecodigo
		and AFClasificaciones.AFCcodigoclas = #table_name#.TipoAF"
	Mensaje="'no existe para la Empresa ' #_Cat# Empresas.Edescripcion"
	joinEmpresas="true"
	ErrorNum="1200"/>
<!--- 1300. Categoria: Se valida que la categoría exista para la Empresa. --->
<cfinvoke method="fnValida"
	Columna="Categoria"
	Tabla="ACategoria"
	Filtro="ACategoria.Ecodigo = #table_name#.Ecodigo
		and ACategoria.ACcodigodesc = #table_name#.Categoria"
	Mensaje="'no existe para la Empresa '#_Cat# Empresas.Edescripcion"
	joinEmpresas="true"
	ErrorNum="1300"/>
<!--- 1400. Clase: Se valida que la clase exista para la categoria y para la Empresa. --->
<cfinvoke method="fnValida"
	Columna="Clase"
	Tabla="AClasificacion
		inner join ACategoria
		on ACategoria.Ecodigo = AClasificacion.Ecodigo
		and ACategoria.ACcodigo = AClasificacion.ACcodigo"
	Filtro="AClasificacion.Ecodigo = #table_name#.Ecodigo
		and AClasificacion.ACcodigodesc = #table_name#.Clase
		and ACategoria.ACcodigodesc = #table_name#.Categoria"
	Mensaje="'no existe para la categoría ' #_Cat# #table_name#.Categoria #_Cat# ' y la Empresa ' #_Cat# Empresas.Edescripcion"
	joinEmpresas="true"
	ErrorNum="1400"/>
<!--- 1500. PerUltRev: no se valida. no se utiliza en el sistema. --->
<!--- 1600. MesUltRev: no se valida. no se utiliza en el sistema. --->
<!--- 1700. VidaUtilAdq: no se valida. --->
<!--- 1701. VidaUtilAdq: Valida que no sea nulo ni menor que cero. --->

<!--- Obitiene la Vida Util de la Adq. de la Categoria-Clase --->
<cfquery name="rs" datasource="#session.dsn#">
Select count(1) as haynulos from #table_name# where VidaUtilAdq is null
</cfquery>

<cfif rs.haynulos gt 0>
  
	<cfquery datasource="#session.dsn#" name="PorActVidaAD">
		select b.ACvutil, a.ACcodigodesc as Categoria, b.ACcodigodesc as Clase, a.Ecodigo 
		from ACategoria a
		  inner join AClasificacion b
			   on a.ACcodigo = b.ACcodigo
		   	  and a.Ecodigo  = b.Ecodigo
		   inner join #table_name# tm
		   	  on a.ACcodigodesc = tm.Categoria
		     and b.ACcodigodesc = tm.Clase
		     and a.Ecodigo  	= tm.Ecodigo
		where tm.VidaUtilAdq is null
	</cfquery>
	<cfloop query="PorActVidaAD">
		<cfquery datasource="#session.dsn#">
			UPDATE #table_name#
			set VidaUtilAdq = #PorActVidaAD.ACvutil#
			where '#PorActVidaAD.Categoria#' = Categoria
			  and '#PorActVidaAD.Clase#'      = Clase
			  and #PorActVidaAD.Ecodigo#  	= Ecodigo
			  and VidaUtilAdq is null
		</cfquery>
	</cfloop>
</cfif>

<cfinvoke method="fnValida"
	Columna="VidaUtilAdq"
	Tabla=""
	Filtro=""
	FiltroGral="VidaUtilAdq is null or VidaUtilAdq<0"
	Mensaje="'es menor que cero'"
	joinEmpresas="false"
	ErrorNum="1701"/>
<!--- 1702. VidaUtilAdq: Valida que sea cero cuando no Deprecia. --->
<cfinvoke method="fnValida"
	Columna="VidaUtilAdq"
	Tabla=""
	Filtro=""
	FiltroGral="(VidaUtilAdq > 0) and (Depreciable<>'S')"
	Mensaje="'es mayor que cero, y el campo Depreciable no es S, debe ser cero cuando el activo no deprecia'"
	joinEmpresas="false"
	ErrorNum="1702"/>
<!--- 1800. VidaUtilRev: no se valida. --->
<!--- 1801. VidaUtilRev: valida que no sea nulo ni menor que cero. --->

<cfquery name="rs" datasource="#session.dsn#">
Select count(1) as haynulos from #table_name# where VidaUtilRev is null
</cfquery>

<cfif rs.haynulos gt 0>
<cfquery datasource="#session.dsn#" name="PorActVidaRev">
		select b.ACvutil, a.ACcodigodesc as Categoria, b.ACcodigodesc as Clase, a.Ecodigo 
		from ACategoria a
		  inner join AClasificacion b
			   on a.ACcodigo = b.ACcodigo
		   	  and a.Ecodigo  = b.Ecodigo
		   inner join #table_name# tm
		   	  on a.ACcodigodesc = tm.Categoria
		     and b.ACcodigodesc = tm.Clase
		     and a.Ecodigo  	= tm.Ecodigo
		where tm.VidaUtilAdq is null
	</cfquery>
	<cfloop query="PorActVidaRev">
		<cfquery datasource="#session.dsn#">
			UPDATE #table_name#
			set VidaUtilRev = #PorActVidaRev.ACvutil#
			where '#PorActVidaRev.Categoria#' = Categoria
			  and '#PorActVidaRev.Clase#'      = Clase
			  and #PorActVidaRev.Ecodigo#  	  = Ecodigo
			  and VidaUtilRev is null
		</cfquery>
	</cfloop>

</cfif>

<cfinvoke method="fnValida"
	Columna="VidaUtilRev"
	Tabla=""
	Filtro=""
	FiltroGral="VidaUtilRev is null or VidaUtilRev<0"
	Mensaje="'es menor que cero'"
	joinEmpresas="false"
	ErrorNum="1801"/>
<!--- 1802. VidaUtilRev: Valida que sea cero cuando no Deprecia. --->
<cfinvoke method="fnValida"
	Columna="VidaUtilRev"
	Tabla=""
	Filtro=""
	FiltroGral="(VidaUtilRev > 0) and (Revaluable<>'S')"
	Mensaje="'es mayor que cero, y el campo Revaluable no es S, debe ser cero cuando el activo no revalua'"
	joinEmpresas="false"
	ErrorNum="1802"/>
<!--- 1900. SaldoVUAdq: validar que sea menor o igual que la vida útil de adquisición. --->
<cf_dbfunction name="to_char" returnvariable="Lto_char_VidaUtilAdq" args="#table_name#.VidaUtilAdq">
<cfinvoke method="fnValida"
	Columna="SaldoVUAdq"
	Tabla=""
	Filtro=""
	FiltroGral="#table_name#.SaldoVUAdq>#table_name#.VidaUtilAdq"
	Mensaje="'es mayor que la vida util de adquisición: '#_Cat# #PreserveSingleQuotes(Lto_char_VidaUtilAdq)#"
	joinEmpresas="false"
	ErrorNum="1900"/>
<cfinvoke method="fnValida"
	Columna="SaldoVUAdq"
	Tabla=""
	Filtro=""
	FiltroGral="SaldoVUAdq is null or SaldoVUAdq<0"
	Mensaje="'es menor que cero'"
	joinEmpresas="false"
	ErrorNum="1901"/>
<!--- 2000. SaldoVURev: validar que sea menor o igual que la vida útil de revaluación. --->
<cf_dbfunction name="to_char" returnvariable="Lto_char_VidaUtilRev" args="#table_name#.VidaUtilRev">
<cfinvoke method="fnValida"
	Columna="SaldoVURev"
	Tabla=""
	Filtro=""
	FiltroGral="#table_name#.SaldoVURev>#table_name#.VidaUtilRev"
	Mensaje="'es mayor que la vida util de revaluación: ' #_Cat#  #PreserveSingleQuotes(Lto_char_VidaUtilRev)#"
	joinEmpresas="false"
	ErrorNum="2000"/>
<cfinvoke method="fnValida"
	Columna="SaldoVURev"
	Tabla=""
	Filtro=""
	FiltroGral="SaldoVURev is null or SaldoVURev<0"
	Mensaje="'es menor que cero'"
	joinEmpresas="false"
	ErrorNum="2001"/>
<cf_dbfunction name="to_char" returnvariable="Lto_char_SaldoVUAdq" args="#table_name#.SaldoVUAdq">
<cfinvoke method="fnValida"
	Columna="SaldoVURev"
	Tabla=""
	Filtro=""
	FiltroGral="#table_name#.Depreciable in ('S','s') and #table_name#.Revaluable in ('S','s') and #table_name#.SaldoVURev<>#table_name#.SaldoVUAdq"
	Mensaje="'es distinto que el saldo de vida util de adquisición: ' #_Cat# #PreserveSingleQuotes(Lto_char_SaldoVUAdq)#"
	joinEmpresas="false"
	ErrorNum="2002"/>
<!--- 2100. ValorAdq: no se valida. --->
<cfinvoke method="fnValida"
	Columna="ValorAdq"
	Type="M"
	Tabla=""
	Filtro=""
	FiltroGral="ValorAdq is null or ValorAdq<0"
	Mensaje="'es menor que cero'"
	joinEmpresas="false"
	ErrorNum="2101"/>
<!--- 2200. ValorMej: no se valida. --->
<cfinvoke method="fnValida"
	Columna="ValorMej"
	Type="M"
	Tabla=""
	Filtro=""
	FiltroGral="ValorMej is null or ValorMej<0"
	Mensaje="'es menor que cero'"
	joinEmpresas="false"
	ErrorNum="2201"/>
<!--- 2300. ValorRev: no se valida. --->
<cfinvoke method="fnValida"
	Columna="ValorRev"
	Type="M"
	Tabla=""
	Filtro=""
	FiltroGral="ValorRev is null or ValorRev<0"
	Mensaje="'es menor que cero'"
	joinEmpresas="false"
	ErrorNum="2301"/>
<!--- 2400. DeprAcumAdq: validar que sea menor o igual que el valor de adquisición menos el valor de rescate --->
<cf_dbfunction name="to_char_currency" returnvariable="Lto_char_currency_ValorAdq" args="#table_name#.ValorAdq">
<cf_dbfunction name="to_char_currency" returnvariable="Lto_char_currency_ValorRescate" args="#table_name#.ValorRescate">
<cfinvoke method="fnValida"
	Columna="DeprAcumAdq"
	Type="M"
	Tabla=""
	Filtro=""
	FiltroGral="#table_name#.DeprAcumAdq>(#table_name#.ValorAdq-#table_name#.ValorRescate)"
	Mensaje="'es mayor que valor de adquisición: '#_Cat# #PreserveSingleQuotes(Lto_char_currency_ValorAdq)# #_Cat# ', menos el valor de rescate: '#_Cat# #PreserveSingleQuotes(Lto_char_currency_ValorRescate)#"
	joinEmpresas="false"
	ErrorNum="2400"/>
<cfinvoke method="fnValida"
	Columna="DeprAcumAdq"
	Type="M"
	Tabla=""
	Filtro=""
	FiltroGral="DeprAcumAdq is null or DeprAcumAdq<0"
	Mensaje="'es menor que cero'"
	joinEmpresas="false"
	ErrorNum="2401"/>
<!--- 2500. DeprAcumMej: validar que sea menor o igual que el valor de mejoras --->
<cf_dbfunction name="to_char_currency" returnvariable="Lto_char_currency_ValorMej" args="#table_name#.ValorMej">
<cfinvoke method="fnValida"
	Columna="DeprAcumMej"
	Type="M"
	Tabla=""
	Filtro=""
	FiltroGral="#table_name#.DeprAcumMej>#table_name#.ValorMej"
	Mensaje="'es mayor que valor de mejoras: ' #_Cat# #PreserveSingleQuotes(Lto_char_currency_ValorMej)#"
	joinEmpresas="false"
	ErrorNum="2500"/>
<cfinvoke method="fnValida"
	Columna="DeprAcumMej"
	Type="M"
	Tabla=""
	Filtro=""
	FiltroGral="DeprAcumMej is null or DeprAcumMej<0"
	Mensaje="'es menor que cero'"
	joinEmpresas="false"
	ErrorNum="2501"/>
<!--- 2600. DeprAcumRev: validar que sea menor o igual que el valor de revaluaciones --->
<cf_dbfunction name="to_char_currency" returnvariable="Lto_char_currency_ValorRev" args="#table_name#.ValorRev">
<cfinvoke method="fnValida"
	Columna="DeprAcumRev"
	Type="M"
	Tabla=""
	Filtro=""
	FiltroGral="#table_name#.DeprAcumRev>#table_name#.ValorRev"
	Mensaje="'es mayor que valor de revaluaciones: ' #_Cat# #PreserveSingleQuotes(Lto_char_currency_ValorRev)#"
	joinEmpresas="false"
	ErrorNum="2600"/>
<cfinvoke method="fnValida"
	Columna="DeprAcumRev"
	Type="M"
	Tabla=""
	Filtro=""
	FiltroGral="DeprAcumRev is null or DeprAcumRev<0"
	Mensaje="'es menor que cero'"
	joinEmpresas="false"
	ErrorNum="2601"/>
<!--- 2700. Metodo: validar que sea L = Línea Recta o D = Suma Digitos. --->
<cfquery name="rs" datasource="#session.dsn#">
Select count(1) as haynulos from #table_name# where Metodo is null
</cfquery>

<cfif rs.haynulos gt 0>
	<cfquery datasource="#session.dsn#" name="PorActualizarMet">
		select a.ACmetododep, a.ACcodigodesc as Categoria, a.Ecodigo
		  from ACategoria a
		    inner join #table_name# tm 
			  on a.ACcodigodesc = tm.Categoria
	         and a.Ecodigo      = tm.Ecodigo
	     where tm.Metodo is null
	</cfquery>
	<cfloop query="PorActualizarMet">
		<cfquery datasource="#session.dsn#">
			UPDATE #table_name#
			set Metodo = case when '#PorActualizarMet.ACmetododep#' = 1 then 'L' else 'D' end
			where '#PorActualizarMet.Categoria#' = Categoria
			  and #PorActualizarMet.Ecodigo#    = Ecodigo
			  and Metodo is null
		</cfquery>
	</cfloop>
</cfif>

<cfinvoke method="fnValida"
	Columna="Metodo"
	Tabla=""
	Filtro=""
	FiltroGral="#table_name#.Metodo not in ('L','D','l','d') or #table_name#.Metodo is null"
	Mensaje="'no es válido. Los valores permitidos son L = Línea Recta, y D = Suma Digitos'"
	joinEmpresas="false"
	ErrorNum="2700"/>
<!--- 2800. Depreciable: validar que sea S = Sí, y N = No. --->
<cfquery name="rs" datasource="#session.dsn#">
Select count(1) as haynulos from #table_name# where Depreciable is null
</cfquery>

<cfif rs.haynulos gt 0>
	<cfquery datasource="#session.dsn#" name="PorActDepr">
		select b.ACdepreciable, a.ACcodigodesc as Categoria, b.ACcodigodesc as Clase, a.Ecodigo
		from ACategoria a
		  inner join AClasificacion b
			  on a.ACcodigo = b.ACcodigo
			 and a.Ecodigo  = b.Ecodigo
		  inner join #table_name# tm 
		  	on a.ACcodigodesc = tm.Categoria
		   and b.ACcodigodesc = tm.Clase
		   and a.Ecodigo      = tm.Ecodigo
		where tm.Depreciable is null
	</cfquery>
	<cfloop query="PorActDepr">
		<cfquery datasource="#session.dsn#">
			UPDATE #table_name#
			set Depreciable = '#PorActDepr.ACdepreciable#'
			where '#PorActDepr.Categoria#' = Categoria
			  and '#PorActDepr.Clase#'     = Clase
			  and #PorActDepr.Ecodigo#       = Ecodigo
			  and Depreciable is null
	   </cfquery>
	</cfloop>
	
</cfif>

<cfinvoke method="fnValida"
	Columna="Depreciable"
	Tabla=""
	Filtro=""
	FiltroGral="#table_name#.Depreciable not in ('S','N','s','n')"
	Mensaje="'no es válido. Los valores permitidos son S = Sí, y N = No'"
	joinEmpresas="false"
	ErrorNum="2800"/>
<!--- 2900. Revaluable: validar que sea S = Sí, y N = No. --->
<cfquery name="rs" datasource="#session.dsn#">
Select count(1) as haynulos from #table_name# where Revaluable is null
</cfquery>

<cfif rs.haynulos gt 0>
	<cfquery datasource="#session.dsn#" name="PorActRev">
		select b.ACrevalua, a.ACcodigodesc as Categoria, b.ACcodigodesc as Clase, a.Ecodigo
		from ACategoria a
		  inner join AClasificacion b
			  on a.ACcodigo = b.ACcodigo
			 and a.Ecodigo  = b.Ecodigo
		  inner join #table_name# tm 
		  	on a.ACcodigodesc = tm.Categoria
		   and b.ACcodigodesc = tm.Clase
		   and a.Ecodigo      = tm.Ecodigo
		where tm.Revaluable is null
	</cfquery>
	<cfloop query="PorActRev">
		<cfquery datasource="#session.dsn#">
			UPDATE #table_name#
			set Revaluable = '#PorActRev.ACrevalua#'
			where '#PorActRev.Categoria#' = Categoria
			  and '#PorActRev.Clase#'     = Clase
			  and #PorActRev.Ecodigo#     = Ecodigo
			  and Revaluable is null
	   </cfquery>
	</cfloop>
</cfif>

<cfinvoke method="fnValida"
	Columna="Revaluable"
	Tabla=""
	Filtro=""
	FiltroGral="#table_name#.Revaluable not in ('S','N','s','n')"
	Mensaje="'no es válido. Los valores permitidos son S = Sí, y N = No'"
	joinEmpresas="false"
	ErrorNum="2900"/>
<!--- 3000. FechaAdq: validar que sea menor o igual que la fecha de inicio de revaluación. --->
<cf_dbfunction name="to_datechar" returnvariable="Lto_datechar_FechaAdq" args="#table_name#.FechaAdq">
<cf_dbfunction name="to_datechar" returnvariable="Lto_datechar_FechaIniDepr" args="#table_name#.FechaIniDepr">
<cf_dbfunction name="date_format" returnvariable="Ldate_format_FechaIniDepr" args="#table_name#.FechaIniDepr,DD/MM/YYYY">
<cfinvoke method="fnValida"
	Columna="FechaAdq"
	Type="D"
	Tabla=""
	Filtro=""
	FiltroGral="#PreserveSingleQuotes(Lto_datechar_FechaAdq)#>#PreserveSingleQuotes(Lto_datechar_FechaIniDepr)#"
	Mensaje="'es mayor que la fecha de inicio de depreciación: ' #_Cat# #PreserveSingleQuotes(Ldate_format_FechaIniDepr)#"
	joinEmpresas="false"
	exists="false"
	permiteNulos="true"
	ErrorNum="3000"/>
<cfif Lvar_Retirados>
	<!--- 3001. FechaRet: validar que sea mayor o igual que la fecha de inicio de adquisición. --->
	<cf_dbfunction name="to_datechar" returnvariable="Lto_datechar_FechaRet" args="#table_name#.FechaRet">
	<cf_dbfunction name="to_datechar" returnvariable="Lto_datechar_FechaAdq" args="#table_name#.FechaAdq">
	<cf_dbfunction name="date_format" returnvariable="Ldate_format_FechaAdq" args="#table_name#.FechaAdq,DD/MM/YYYY">
	<cfinvoke method="fnValida"
		Columna="FechaRet"
		Type="D"
		Tabla=""
		Filtro=""
		FiltroGral="#PreserveSingleQuotes(Lto_datechar_FechaRet)#<#PreserveSingleQuotes(Lto_datechar_FechaAdq)#"
		Mensaje="'es menor que la fecha de adquisición: '#_Cat# #PreserveSingleQuotes(Ldate_format_FechaAdq)#"
		joinEmpresas="false"
		exists="false"
		permiteNulos="true"
		ErrorNum="3001"/>
</cfif>
<!--- Borra los errores adicionales a Empresa cuando hay error en la Empresa. porque los demás dependen de la Empresa (la mayoría) --->
<cfquery datasource="#session.dsn#">
	delete from #AF_INICIO_ERROR#
	where exists(
	select 1 from #AF_INICIO_ERROR# b
	where b.Ecodigo = #AF_INICIO_ERROR#.Ecodigo
	and b.Placa = #AF_INICIO_ERROR#.Placa
	and b.ErrorNum < 200)
	and ErrorNum > 200
</cfquery>
<!--- Devuelve errores si los hay --->
<cfquery name="err" datasource="#session.dsn#">
	select Ecodigo, Placa, Mensaje, DatoIncorrecto, ErrorNum
	from #AF_INICIO_ERROR#
	order by Ecodigo, Placa, ErrorNum
</cfquery>
<!--- Si hay errores los devuelve, si no realiza el proceso de importación --->
<cfif (err.recordcount) EQ 0>
<!---*********************************************************************************************************************************************************************************************************************************************************************************************
Columnas esperadas:
Ecodigo	Placa	Descripcion	Serie	Marca	Modelo	EmpResponsable	ValorRescate	FechaIniDepr	FechaIniRev	CFuncional	TipoAF	
Categoria	Clase	PerUltRev	MesUltRev	 VidaUtilAdq 	 VidaUtilRev 	 SaldoVUAdq 	 SaldoVURev 	
ValorAdq	ValorMej	ValorRev	DeprAcumAdq	DeprAcumMej	 DeprAcumRev 	Metodo	Depreciable	Revaluable	FechaAdq
Proceso de Importación 
Consideraciones Adicionales:
	1. Si la Fecha de Inicio de Revaluación es nula utilizar la Fecha de Inicio de Depreciación.
	2. El Saldo de Vida Útil de Revaluación es igual que el Saldo de Vida Útil de Adquisición.
	3. Si el Empleado Reponsable del Activo no está indicado asumir el responsable del centro funcional.
	4. Si los campos depreciable o revaluable vienen nulos utiliza los de la categoría clase.
Comentarios de desarrollo:
	1. Los throws en esta sección nunca deberían darse, porque se supone que ya los datos están validados, pero se ponen para asegurar la integridad de los datos.
	2. Dos validaciones no se han podido hacer hasta este punto:
		2.1 Una es cuando el empleado es nulo y se tiene que obtener el encargado del centro funcional, si este no se puede obtener se debe enviar los errores respectivos.
		2.2 La otra es que el empleado y centro funcional coincidan.
*********************************************************************************************************************************************************************************************************************************************************************************************--->
<!--- Tabla Temporal de Activos Fijos --->
<cf_dbtemp name="ActivoTemp02" returnvariable="Activos" datasource="#session.dsn#">
	<cf_dbtempcol name="Ecodigo" 		type="integer" 		mandatory="yes">
	<cf_dbtempcol name="Aid" 			type="numeric" 		mandatory="yes">
	<cf_dbtempcol name="Aplaca" 		type="varchar(20)" 	mandatory="yes">
	<cf_dbtempcol name="Adescripcion" 	type="varchar(100)" mandatory="yes">
	<cf_dbtempcol name="Aserie" 		type="varchar(50)" 	mandatory="no">
	<cf_dbtempcol name="AFMid" 			type="numeric" 		mandatory="yes">
	<cf_dbtempcol name="AFMMid" 		type="numeric" 		mandatory="yes">
	<cf_dbtempcol name="DEid" 			type="numeric" 		mandatory="yes">
	<cf_dbtempcol name="Avalrescate" 	type="money" 		mandatory="yes">
	<cf_dbtempcol name="Afechainidep" 	type="datetime" 	mandatory="yes">
	<cf_dbtempcol name="Afechainirev" 	type="datetime" 	mandatory="yes">
	<cf_dbtempcol name="CFid" 			type="numeric" 		mandatory="yes">
	<cf_dbtempcol name="Ocodigo" 		type="integer" 		mandatory="yes">
	<cf_dbtempcol name="CRCCid" 		type="numeric" 		mandatory="yes">
	<cf_dbtempcol name="AFCcodigo" 		type="integer" 		mandatory="yes">
	<cf_dbtempcol name="ACcodigo" 		type="integer" 		mandatory="yes">
	<cf_dbtempcol name="ACid" 			type="integer" 		mandatory="yes">
	<cf_dbtempcol name="AFSperiodourev" type="integer" 		mandatory="yes">
	<cf_dbtempcol name="AFSmesurev" 	type="integer" 		mandatory="yes">
	<cf_dbtempcol name="AFSvutiladq" 	type="integer" 		mandatory="yes">
	<cf_dbtempcol name="AFSvutilrev" 	type="integer" 		mandatory="yes">
	<cf_dbtempcol name="AFSsaldovutiladq"type="integer" 	mandatory="yes">
	<cf_dbtempcol name="AFSsaldovutilrev"type="integer" 	mandatory="yes">
	<cf_dbtempcol name="AFSvaladq" 		type="money" 		mandatory="yes">
	<cf_dbtempcol name="AFSvalmej" 		type="money" 		mandatory="yes">
	<cf_dbtempcol name="AFSvalrev" 		type="money" 		mandatory="yes">
	<cf_dbtempcol name="AFSdepacumadq" 	type="money" 		mandatory="yes">
	<cf_dbtempcol name="AFSdepacummej" 	type="money" 		mandatory="yes">
	<cf_dbtempcol name="AFSdepacumrev" 	type="money" 		mandatory="yes">
	<cf_dbtempcol name="AFSmetododep" 	type="integer"		mandatory="yes">
	<cf_dbtempcol name="AFSdepreciable" type="integer" 		mandatory="yes">
	<cf_dbtempcol name="AFSrevalua" 	type="integer" 		mandatory="yes">
	<cf_dbtempcol name="Afechaaltaadq" 	type="datetime" 	mandatory="yes">
	<cf_dbtempcol name="Afechaaltaret" 	type="datetime" 	mandatory="no">
	
	<cf_dbtempkey cols="Ecodigo,Aplaca">
</cf_dbtemp>
<!--- La variable continuar nos ayudara a abortar el proceso en los dos posibles casos de error definidos  previamente. --->
<cfset Lvar_continuar = true>
<!--- Insert Inicial de Activos Fijos en Tabla Temporal de Activos Fijos --->
<cfquery datasource="#session.dsn#">
	insert into #Activos#
		(Ecodigo, Aid, Aplaca, Adescripcion, Aserie, AFMid, AFMMid, DEid, Avalrescate, Afechainidep, Afechainirev, CFid, Ocodigo, CRCCid, AFCcodigo, 
		ACcodigo, ACid, AFSperiodourev, AFSmesurev, AFSvutiladq, AFSvutilrev, AFSsaldovutiladq, AFSsaldovutilrev, 
		AFSvaladq, AFSvalmej, AFSvalrev, AFSdepacumadq, AFSdepacummej, AFSdepacumrev, AFSmetododep, AFSdepreciable,
		AFSrevalua, Afechaaltaadq<cfif Lvar_Retirados>, Afechaaltaret</cfif>)
	select 
		Ecodigo, -1, rtrim(Placa), Descripcion, Serie, -1, -1, -1, ValorRescate, FechaIniDepr, coalesce(FechaIniRev,FechaIniDepr), -1, -1, -1, -1, 
		-1, -1, coalesce(PerUltRev,<cf_dbfunction name="date_part" args="YY|coalesce(FechaIniRev,FechaIniDepr)" delimiters="|">), 
		coalesce(MesUltRev,<cf_dbfunction name="date_part" args="MM|coalesce(FechaIniRev,FechaIniDepr)" delimiters="|">), 
		VidaUtilAdq, VidaUtilRev, SaldoVUAdq, SaldoVURev, ValorAdq, ValorMej, ValorRev, DeprAcumAdq, DeprAcumMej, DeprAcumRev, 
		case upper(Metodo) when 'D' then 3 else 1 end, coalesce(case upper(Depreciable) when 'S' then 1 when 'N' then 0 end,-1), 
		coalesce(case upper(Revaluable) when 'S' then 1 when 'N' then 0 end,-1), FechaAdq<cfif Lvar_Retirados>, FechaRet</cfif>
	from #table_name#
</cfquery>
<!--- Actualiza la VUR y SVUR con los datos de la adquisicion para garantizar que sean iguales --->
<cfquery datasource="#session.dsn#">
Update #Activos#
set AFSvutilrev = AFSvutiladq, 
	AFSsaldovutilrev = AFSsaldovutiladq
where (AFSvutilrev != AFSvutiladq
    or AFSsaldovutilrev != AFSsaldovutiladq)
</cfquery>

<!--- Actualiza AFMid AFMMid en Tabla Temporal de Activos Fijos --->
<cfquery name="porActualizar" datasource="#session.dsn#">
    select mar.AFMid, mod.AFMMid, tem.Ecodigo, rtrim(tem.Placa) as Placa
	  from #table_name# tem
		inner join AFMarcas mar	
			on mar.Ecodigo   = tem.Ecodigo
		   and mar.AFMcodigo = tem.Marca
		inner join AFMModelos mod
			on mod.Ecodigo = tem.Ecodigo
		   and mod.AFMid = mar.AFMid
		   and mod.AFMMcodigo = tem.Modelo
</cfquery>
<cfloop query="porActualizar">
	<cfquery datasource="#session.dsn#">
		update #Activos#
		set AFMid = #porActualizar.AFMid#, 
			AFMMid = #porActualizar.AFMMid#
		where Ecodigo= #porActualizar.Ecodigo# 
		and    Aplaca= '#porActualizar.Placa#'
	</cfquery>
</cfloop>
<cfquery name="rsAFMidAFMMidMFT" datasource="#session.dsn#">
	select 1 from #Activos#
	where AFMid = -1 or AFMMid = -1
</cfquery>
<cfif rsAFMidAFMMidMFT.recordcount gt 0>
	<cf_errorCode	code = "50082" msg = "No se pudo actualizar la Marca y Modelo (AFMid ,AFMMid). Proceso Cancelado!">
</cfif>
<!--- Actualiza CFid Ocodigo en Tabla Temporal de Activos Fijos --->
<cfquery name="PorActualizarCF" datasource="#session.dsn#">
	 select CFuncional.CFid, CFuncional.Ocodigo,
		    coalesce((select min(CRCCid) 
					   from CRCCCFuncionales
					  where CFid = CFuncional.CFid), -1) as CRCCid, 
			 #table_name#.Ecodigo, rtrim(#table_name#.Placa) as Placa 
	from #table_name#
		inner join CFuncional
			on CFuncional.Ecodigo   = #table_name#.Ecodigo
			and CFuncional.CFcodigo = #table_name#.CFuncional
</cfquery>
<cfloop query="PorActualizarCF">
	<cfquery datasource="#session.dsn#">
		update #Activos#
		set CFid    = #PorActualizarCF.CFid#,
			Ocodigo = #PorActualizarCF.Ocodigo#,
			CRCCid  = #PorActualizarCF.CRCCid#
		where #PorActualizarCF.Ecodigo# = Ecodigo
		  and '#PorActualizarCF.Placa#'  = Aplaca
	</cfquery>
</cfloop>

<cfquery name="rsCFidOcodigoMFT" datasource="#session.dsn#">
	select 1 from #Activos#
	where CFid = -1 or Ocodigo = -1 or CRCCid = -1
</cfquery>
<cfif rsCFidOcodigoMFT.recordcount gt 0>
	<cf_errorCode	code = "50083" msg = "No se pudo actualizar el Centro Funcional, Oficina, Centro de Custodia (CFid, Ocodigo, CRCCid). Proceso Cancelado!">
</cfif>
<!--- Actualiza DEid en Tabla Temporal de Activos Fijos --->
<cfquery datasource="#session.dsn#">
	update #Activos#
	set DEid = coalesce((select min(DatosEmpleado.DEid)
				from #table_name#
				  inner join DatosEmpleado
			        on DatosEmpleado.Ecodigo = #table_name#.Ecodigo
			       and DatosEmpleado.DEidentificacion = #table_name#.EmpResponsable
	           where #table_name#.Ecodigo = #Activos#.Ecodigo
		         and rtrim(#table_name#.Placa) = #Activos#.Aplaca),-1)
</cfquery>
<cfquery name="rsDEidMFT1" datasource="#session.dsn#">
	select 1 from #Activos#
	where DEid = -1
</cfquery>
<cfif rsDEidMFT1.recordcount gt 0>
	<!--- 1. Encargado por RHPlazas --->
	<cfquery datasource="#session.dsn#">
		update #Activos#
		set DEid = coalesce((select min(LineaTiempo.DEid)
		             from CFuncional 
			           inner join LineaTiempo 
			            on LineaTiempo.RHPid = CFuncional.RHPid
			           and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> 
			           between LineaTiempo.LTdesde and LineaTiempo.LThasta
		            where CFuncional.CFid = #Activos#.CFid
		             and #Activos#.DEid = -1),-1)
	</cfquery>
	<!--- 2. Encargado por EmpleadoCFuncional --->
	<cfquery datasource="#session.dsn#">
		update #Activos#
		set DEid = coalesce((select min(EmpleadoCFuncional.DEid)
	           		from EmpleadoCFuncional
		           where EmpleadoCFuncional.CFid = #Activos#.CFid
		           and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> 
		           between EmpleadoCFuncional.ECFdesde and EmpleadoCFuncional.ECFhasta
		           and #Activos#.DEid = -1),-1)
	</cfquery>
	<cfquery name="err" datasource="#session.dsn#">
		select #Activos#.Ecodigo, #Activos#.Aplaca, '5000. La Columna CFuncional contiene un dato que no tiene definido un Encargado, este se requiere para definirlo como encargado del Activo, debido a que la Columna EmpEncargado esta en blanco.' as Mensaje, CFuncional.CFcodigo as CFuncional 
		from #Activos#
			inner join CFuncional
			on CFuncional.CFid = #Activos#.CFid
		where DEid = -1
		order by #Activos#.Ecodigo, #Activos#.Aplaca
	</cfquery>
	<cfif (err.recordcount) GT 0>
		<cfset Lvar_continuar = false>
	</cfif>
</cfif>
<cfif Lvar_continuar>
<!--- Valida que el Empleado y el Centro Funcional coincidan --->
<cfquery name="err" datasource="#session.dsn#">
	select #Activos#.Ecodigo, #Activos#.Aplaca, '6000. La Columna CFuncional contiene un dato que no concuerda con la Columna EmpEncargado, El Empleado debe pertenecer al Centro Funcional.' as Mensaje, CFuncional.CFcodigo as CFuncional, DatosEmpleado.DEidentificacion as EmpResponsable
	from #Activos#
		inner join CFuncional
		on CFuncional.CFid = #Activos#.CFid
		inner join DatosEmpleado
		on DatosEmpleado.DEid = #Activos#.DEid
	where not exists(
		select 1
		from LineaTiempo
			inner join RHPlazas 
			on RHPlazas.RHPid = LineaTiempo.RHPid
		where LineaTiempo.Ecodigo = #Activos#.Ecodigo
		and CFid = #Activos#.CFid
		and DEid = #Activos#.DEid
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between LTdesde and LThasta
	)
	and not exists(
		select 1
		from EmpleadoCFuncional
		where Ecodigo = #Activos#.Ecodigo
		and CFid = #Activos#.CFid
		and DEid = #Activos#.DEid
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between ECFdesde and ECFhasta
	)
	order by #Activos#.Ecodigo, #Activos#.Aplaca
</cfquery>
<cfif (err.recordcount) GT 0>
	<cfset Lvar_continuar = false>
</cfif>
<cfif Lvar_continuar>
<!--- Actualiza AFCcodigo en Tabla Temporal de Activos Fijos --->

<cfquery datasource="#session.dsn#">
	update #Activos#
	set AFCcodigo = coalesce((select min(AFClasificaciones.AFCcodigo)
	from #table_name#
		inner join AFClasificaciones
			on AFClasificaciones.Ecodigo = #table_name#.Ecodigo
			and AFClasificaciones.AFCcodigoclas = rtrim(#table_name#.TipoAF)
	where #table_name#.Ecodigo = #Activos#.Ecodigo
		and rtrim(#table_name#.Placa) = #Activos#.Aplaca),-1)
</cfquery>

<cfquery name="rsAFCcodigoMFT" datasource="#session.dsn#">
	select 1 from #Activos#
	where AFCcodigo = -1
</cfquery>
<cfif rsAFCcodigoMFT.recordcount gt 0>
	<cf_errorCode	code = "50084" msg = "No se pudo actualizar el Tipo (AFCcodigo). Proceso Cancelado!">
</cfif>
<!--- Actualiza ACcodigo ACid en Tabla Temporal de Activos Fijos --->
<cfquery name="PorActulizarAC" datasource="#session.dsn#">
	select ACategoria.ACcodigo, AClasificacion.ACid, #table_name#.Ecodigo, rtrim(#table_name#.Placa) as Placa
	 from #table_name#
	   inner join ACategoria
		 on ACategoria.Ecodigo = #table_name#.Ecodigo
		and ACategoria.ACcodigodesc = #table_name#.Categoria
	   inner join AClasificacion
		 on AClasificacion.Ecodigo = #table_name#.Ecodigo
		and AClasificacion.ACcodigo = ACategoria.ACcodigo
		and AClasificacion.ACcodigodesc = #table_name#.Clase
</cfquery>
<cfloop query="PorActulizarAC">
	<cfquery datasource="#session.dsn#">
		update #Activos#
		set ACcodigo = #PorActulizarAC.ACcodigo#, 
			ACid     = #PorActulizarAC.ACid#
		where #PorActulizarAC.Ecodigo# = Ecodigo
		  and '#PorActulizarAC.Placa#' = Aplaca
</cfquery>
</cfloop>
<cfquery name="rsACcodigoACidMFT" datasource="#session.dsn#">
	select 1 from #Activos#
	where ACcodigo = -1 or ACid = -1
</cfquery>
<cfif rsACcodigoACidMFT.recordcount gt 0>
	<cf_errorCode	code = "50085" msg = "No se pudo actualizar la Categoría y Clasificación (ACcodigo, ACid). Proceso Cancelado!">
</cfif>
<!--- Actualiza AFSdepreciable en Tabla Temporal de Activos Fijos --->
<cfquery datasource="#session.dsn#">
	update #Activos#
	set  AFSdepreciable = (select case AClasificacion.ACdepreciable when 'S' then 1 else 0 end
									 from AClasificacion
									where AClasificacion.Ecodigo = #Activos#.Ecodigo
									and AClasificacion.ACcodigo = #Activos#.ACcodigo
									and AClasificacion.ACid = #Activos#.ACid)
	where #Activos#.AFSdepreciable = -1
</cfquery>
<cfquery name="rsAFSdepreciableMFT" datasource="#session.dsn#">
	select 1 from #Activos#
	where AFSdepreciable = -1
</cfquery>
<cfif rsAFSdepreciableMFT.recordcount gt 0>
	<cf_errorCode	code = "50086" msg = "No se pudo actualizar la columna AFSdepreciable. Proceso Cancelado!">
</cfif>
<!--- Actualiza AFSrevalua en Tabla Temporal de Activos Fijos --->
<cfquery datasource="#session.dsn#">
	update #Activos#
	set  AFSrevalua = (select case AClasificacion.ACrevalua when 'S' then 1 else 0 end
				        from AClasificacion
					   where AClasificacion.Ecodigo = #Activos#.Ecodigo
					   and AClasificacion.ACcodigo = #Activos#.ACcodigo
					   and AClasificacion.ACid = #Activos#.ACid)
	where #Activos#.AFSrevalua = -1
</cfquery>
<cfquery name="rsAFSrevaluaMFT" datasource="#session.dsn#">
	select 1 from #Activos#
	where AFSrevalua = -1
</cfquery>
<cfif rsAFSrevaluaMFT.recordcount gt 0>
	<cf_errorCode	code = "50087" msg = "No se pudo actualizar la columna AFSrevalua. Proceso Cancelado!">
</cfif>
<!--- INICIO --->
<cfif Lvar_Debug><cfdump var="#LSTimeFormat(now(),'HH:MM:SS')#"></cfif>
<!--- Agregar Activo Fijo --->
<cfif Lvar_Debug>
	<cfquery name="rstemp" datasource="#session.dsn#">select max(Aid) as Aid from Activos</cfquery><cfset Lvar_maxAidAnterior = rstemp.Aid>
	<cfquery name="rstemp" datasource="#session.dsn#">select max(AGTPid) as AGTPid from AGTProceso</cfquery><cfset Lvar_maxAGTPidAnterior = rstemp.AGTPid>
	<cfquery name="rstemp" datasource="#session.dsn#">select max(TAid) as TAid from TransaccionesActivos</cfquery><cfset Lvar_maxTAidAnterior = rstemp.TAid>
	<cfquery name="rstemp" datasource="#session.dsn#">select max(AFSid) as AFSid from AFSaldos</cfquery><cfset Lvar_maxAFSidAnterior = rstemp.AFSid>
	<cfquery name="rstemp" datasource="#session.dsn#">select max(AFRid) as AFRid from AFResponsables</cfquery><cfset Lvar_maxAFRidAnterior = rstemp.AFRid>
	<cfquery name="rstemp" datasource="#session.dsn#">select max(CRBid) as CRBid from CRBitacoraTran</cfquery><cfset Lvar_maxCRBidAnterior = rstemp.CRBid>
</cfif>
<!--- Obtiene las diferentes empresas del archivo, con sus respectivos Periodo, Mes y Moneda --->
<cfquery name="rsGetEmpresas" datasource="#session.dsn#">
	select distinct a.Ecodigo, periodo.Pvalor as Periodo, mes.Pvalor as Mes, Empresas.Mcodigo,
	       coalesce(<cf_dbfunction name="to_integer" args="vale.Pvalor">, -1)  as CRTDid
	from #Activos# a
	inner join Parametros periodo 
		on periodo.Ecodigo = a.Ecodigo
		and periodo.Pcodigo = 50
	inner join Parametros mes
		on mes.Ecodigo = a.Ecodigo
		and mes.Pcodigo = 60
	left join Parametros vale
		on vale.Ecodigo = a.Ecodigo 
		and vale.Pcodigo = 910
	inner join Empresas
		on Empresas.Ecodigo = a.Ecodigo
</cfquery>
	<cfquery name="sinvale" dbtype="query">
	select count(1) cantidad from rsGetEmpresas where CRTDid = -1
	</cfquery>
	<cfif sinvale.cantidad GT 0>
		<cf_errorCode	code = "50088" msg = "Error en Control de Responsables. Debe definir un Tipo de Documento para Importación, para cada una de las Empresas, en la sección de Parámetros.">
	</cfif>
<cftransaction>
<cfquery datasource="#session.dsn#">
	insert into Activos 
		(Ecodigo, ACid, ACcodigo, AFMid, AFMMid, AFCcodigo, Adescripcion, Aserie, Aplaca, Astatus, 
		Afechainidep, Afechainirev, Avutil, Avalrescate, Afechaaltaadq)
	select 
		Ecodigo, ACid, ACcodigo, AFMid, AFMMid, AFCcodigo, Adescripcion, Aserie, Aplaca, <cfif Lvar_Retirados>60, <cfelse>0, </cfif>
		Afechainidep, Afechainirev, AFSvutiladq, Avalrescate, Afechaaltaadq
	from #Activos#
</cfquery>
<cfif Lvar_Debug><cfdump var="#LSTimeFormat(now(),'HH:MM:SS')#"></cfif>
<cfquery datasource="#session.dsn#">
	update #Activos#
	set Aid =(select Activos.Aid
			   from Activos
	          where Activos.Ecodigo = #Activos#.Ecodigo
		       and Activos.Aplaca = #Activos#.Aplaca)
</cfquery>
<cfquery name="ActivosInsertados" datasource="#session.dsn#">
	select 1 from #Activos#
	where Aid = -1
</cfquery>
<cfif ActivosInsertados.recordcount gt 0>
	<cf_errorCode	code = "50089" msg = "No se pudo adquirir todos los Activos. Proceso Cancelado!">
</cfif>
<cfif Lvar_Debug><cfdump var="#LSTimeFormat(now(),'HH:MM:SS')#"></cfif>
<!--- Realiza todas las transacciones por Empresa --->
	<cfloop query="rsGetEmpresas">
		<!--- Agregar Transacción de Adquisición --->
		<cfinvoke component="sif.Componentes.OriRefNextVal" method="nextVal" ORI="AFAQ" REF="AQ" returnvariable="LvarNumDoc"/>
		<cfquery name="rs_agtp_insert" datasource="#session.dsn#">
			insert into AGTProceso(Ecodigo, IDtrans, AGTPdescripcion, AGTPperiodo, AGTPmes, 
				Usucodigo, AGTPestadp, AGTPecodigo, AGTPdocumento, AGTPipregistro, AGTPipaplica, Usuaplica, 
				AGTPfalta, AGTPfaplica)
			values (#rsGetEmpresas.Ecodigo#, 1, 'Adq. Inicial Activos Fijos', #rsGetEmpresas.Periodo#, #rsGetEmpresas.Mes#, 
				#session.usucodigo#, 4, #rsGetEmpresas.Ecodigo#, #LvarNumDoc#, '#session.sitio.ip#', '#session.sitio.ip#', #session.usucodigo#, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">)
			<cf_dbidentity1 verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 name="rs_agtp_insert" verificar_transaccion="false">
		<cfquery datasource="#session.dsn#">
			insert into TransaccionesActivos 
				(Aid, Ecodigo, IDtrans, CFid, TAperiodo, TAmes, TAfecha, 	TAmontooriadq, TAmontolocadq, 
				TAmontoorimej, TAmontolocmej, TAmontoorirev, TAmontolocrev, Mcodigo, TAtipocambio, AGTPid, Usucodigo, TAfechainidep, 
				TAvalrescate, 	TAvutil, TAfechainirev, TAvaladq, TAvalmej, TAvalrev, TAdepacumadq, TAdepacummej, TAdepacumrev, TAfalta)
			select Aid, Ecodigo, 1, CFid, #rsGetEmpresas.Periodo#, #rsGetEmpresas.Mes#, Afechaaltaadq, AFSvaladq, AFSvaladq, 
				0.00, 0.00, 0.00, 0.00, #rsGetEmpresas.Mcodigo#, 1.00, #rs_agtp_insert.identity#, #session.usucodigo#, Afechainidep, 
				Avalrescate, AFSvutiladq, Afechainirev, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
			from #Activos#
			where Ecodigo = #rsGetEmpresas.Ecodigo#
		</cfquery>
		<cfif Lvar_Debug><cfdump var="#LSTimeFormat(now(),'HH:MM:SS')#"></cfif>
		<!--- Agregar Transacción de Mejora --->
		<cfinvoke component="sif.Componentes.OriRefNextVal" method="nextVal" ORI="AFMJ" REF="MJ" returnvariable="LvarNumDoc"/>
		<cfquery name="rs_agtp_insert" datasource="#session.dsn#">
			insert into AGTProceso(Ecodigo, IDtrans, AGTPdescripcion, AGTPperiodo, AGTPmes, 
				Usucodigo, AGTPestadp, AGTPecodigo, AGTPdocumento, AGTPipregistro, AGTPipaplica, Usuaplica, 
				AGTPfalta, AGTPfaplica)
			values (#rsGetEmpresas.Ecodigo#, 2, 'Mej. Inicial Activos Fijos', #rsGetEmpresas.Periodo#, #rsGetEmpresas.Mes#, 
				#session.usucodigo#, 4, #rsGetEmpresas.Ecodigo#, #LvarNumDoc#, '#session.sitio.ip#', '#session.sitio.ip#', #session.usucodigo#, 
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">, <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">)
			<cf_dbidentity1 verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 name="rs_agtp_insert" verificar_transaccion="false">
		<cfquery datasource="#session.dsn#">
			insert into TransaccionesActivos 
				(Aid, Ecodigo, IDtrans, CFid, TAperiodo, TAmes, TAfecha, 	TAmontooriadq, TAmontolocadq, 
				TAmontoorimej, TAmontolocmej, TAmontoorirev, TAmontolocrev, Mcodigo, TAtipocambio, AGTPid, Usucodigo, TAfechainidep, 
				TAvalrescate, 	TAvutil, TAfechainirev, TAvaladq, TAvalmej, TAvalrev, TAdepacumadq, TAdepacummej, TAdepacumrev, TAfalta)
			select Aid, Ecodigo, 2, CFid, #rsGetEmpresas.Periodo#, #rsGetEmpresas.Mes#, Afechaaltaadq, 0.00, 0.00, 
				AFSvalmej, AFSvalmej, 0.00, 0.00, #rsGetEmpresas.Mcodigo#, 1.00, #rs_agtp_insert.identity#, #session.usucodigo#, Afechainidep, 
				Avalrescate, AFSvutiladq, Afechainirev, AFSvaladq, 0.00, 0.00, 0.00, 0.00, 0.00, <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
			from #Activos#
			where Ecodigo = #rsGetEmpresas.Ecodigo#
			and AFSvalmej > 0.00
		</cfquery>
		<cfif Lvar_Debug><cfdump var="#LSTimeFormat(now(),'HH:MM:SS')#"></cfif>
		<!--- Agregar Transacción de Revaluación --->
		<cfinvoke component="sif.Componentes.OriRefNextVal" method="nextVal" ORI="AFRE" REF="RE" returnvariable="LvarNumDoc"/>
		<cfquery name="rs_agtp_insert" datasource="#session.dsn#">
			insert into AGTProceso(Ecodigo, IDtrans, AGTPdescripcion, AGTPperiodo, AGTPmes, 
				Usucodigo, AGTPestadp, AGTPecodigo, AGTPdocumento, AGTPipregistro, AGTPipaplica, Usuaplica, 
				AGTPfalta, AGTPfaplica)
			values (#rsGetEmpresas.Ecodigo#, 3, 'Rev. Inicial Activos Fijos', #rsGetEmpresas.Periodo#, #rsGetEmpresas.Mes#, 
				#session.usucodigo#, 4, #rsGetEmpresas.Ecodigo#, #LvarNumDoc#, '#session.sitio.ip#', '#session.sitio.ip#', #session.usucodigo#, 
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">, <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">)
			<cf_dbidentity1 verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 name="rs_agtp_insert" verificar_transaccion="false">
		<cfquery datasource="#session.dsn#">
			insert into TransaccionesActivos 
				(Aid, Ecodigo, IDtrans, CFid, TAperiodo, TAmes, TAfecha, 	TAmontooriadq, TAmontolocadq, 
				TAmontoorimej, TAmontolocmej, TAmontoorirev, TAmontolocrev, Mcodigo, TAtipocambio, AGTPid, Usucodigo, TAfechainidep, 
				TAvalrescate, 	TAvutil, TAfechainirev, TAvaladq, TAvalmej, TAvalrev, TAdepacumadq, TAdepacummej, TAdepacumrev, TAfalta)
			select Aid, Ecodigo, 3, CFid, #rsGetEmpresas.Periodo#, #rsGetEmpresas.Mes#, Afechaaltaadq, 0.00, 0.00, 
				0.00, 0.00, AFSvalrev, AFSvalrev, #rsGetEmpresas.Mcodigo#, 1.00, #rs_agtp_insert.identity#, #session.usucodigo#, Afechainidep, 
				Avalrescate, AFSvutiladq, Afechainirev, AFSvaladq, AFSvalmej, 0.00, 0.00, 0.00, 0.00, <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
			from #Activos#
			where Ecodigo = #rsGetEmpresas.Ecodigo#
			and AFSvalrev > 0.00
		</cfquery>
		<cfif Lvar_Debug><cfdump var="#LSTimeFormat(now(),'HH:MM:SS')#"></cfif>
		<!--- Agregar Transacción de Depreciación de Adquisición, Mejoras y Revaluaciones --->
		<cfinvoke component="sif.Componentes.OriRefNextVal" method="nextVal" ORI="AFDP" REF="DP" returnvariable="LvarNumDoc"/>
		<cfquery name="rs_agtp_insert" datasource="#session.dsn#">
			insert into AGTProceso(Ecodigo, IDtrans, AGTPdescripcion, AGTPperiodo, AGTPmes, 
				Usucodigo, AGTPestadp, AGTPecodigo, AGTPdocumento, AGTPipregistro, AGTPipaplica, Usuaplica, 
				AGTPfalta, AGTPfaplica)
			values (#rsGetEmpresas.Ecodigo#, 4, 'Dep. Inicial Activos Fijos', #rsGetEmpresas.Periodo#, #rsGetEmpresas.Mes#, 
				#session.usucodigo#, 4, #rsGetEmpresas.Ecodigo#, #LvarNumDoc#, '#session.sitio.ip#', '#session.sitio.ip#', #session.usucodigo#, 
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">, <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">)
			<cf_dbidentity1 verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 name="rs_agtp_insert" verificar_transaccion="false">
		<cfquery datasource="#session.dsn#">
			insert into TransaccionesActivos 
				(Aid, Ecodigo, IDtrans, CFid, TAperiodo, TAmes, TAfecha, 	TAmontooriadq, TAmontolocadq, 
				TAmontoorimej, TAmontolocmej, TAmontoorirev, TAmontolocrev, Mcodigo, TAtipocambio, AGTPid, Usucodigo, TAfechainidep, 
				TAvalrescate, 	TAvutil, TAfechainirev, TAvaladq, TAvalmej, TAvalrev, TAdepacumadq, TAdepacummej, TAdepacumrev, TAfalta)
			select Aid, Ecodigo, 4, CFid, #rsGetEmpresas.Periodo#, #rsGetEmpresas.Mes#, Afechaaltaadq, AFSdepacumadq, AFSdepacumadq, 
				AFSdepacummej, AFSdepacummej, AFSdepacumrev, AFSdepacumrev, #rsGetEmpresas.Mcodigo#, 1.00, #rs_agtp_insert.identity#, #session.usucodigo#, Afechainidep, 
				Avalrescate, AFSvutiladq, Afechainirev, AFSvaladq, AFSvalmej, AFSvalrev, 0.00, 0.00, 0.00, <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
			from #Activos#
			where Ecodigo = #rsGetEmpresas.Ecodigo#
			and (AFSdepacumadq > 0.00 or AFSdepacummej > 0.00 or AFSdepacumrev > 0.00)
		</cfquery>
		<cfif Lvar_Debug><cfdump var="#LSTimeFormat(now(),'HH:MM:SS')#"></cfif>
		<!--- Agregar Saldos para el Periodo / Mes de Auxiliares de la Empresa Indicada --->
		<cfquery datasource="#session.dsn#">
			insert into AFSaldos 
				(Aid, Ecodigo, CFid, AFCcodigo, ACid, ACcodigo, AFSperiodourev, AFSmesurev, AFSperiodo, AFSmes, AFSvutiladq, AFSvutilrev, 
				AFSsaldovutiladq, AFSsaldovutilrev, AFSvaladq, AFSvalmej, AFSvalrev, AFSdepacumadq, AFSdepacummej, AFSdepacumrev, 
				AFSmetododep, AFSdepreciable, AFSrevalua, Ocodigo)
			select Aid, Ecodigo, CFid, AFCcodigo, ACid, ACcodigo, AFSperiodourev, AFSmesurev, #rsGetEmpresas.Periodo#, #rsGetEmpresas.Mes#, AFSvutiladq, AFSvutilrev, 
				AFSsaldovutiladq, AFSsaldovutilrev, <cfif Lvar_Retirados>0.00, 0.00, 0.00, 0.00, 0.00, 0.00, <cfelse>AFSvaladq, AFSvalmej, AFSvalrev, AFSdepacumadq, AFSdepacummej, AFSdepacumrev, </cfif>
				AFSmetododep, AFSdepreciable, AFSrevalua, Ocodigo
			from #Activos#
			where Ecodigo = #rsGetEmpresas.Ecodigo#
		</cfquery>
		<cfif Lvar_Debug><cfdump var="#LSTimeFormat(now(),'HH:MM:SS')#"></cfif>
		<!--- Agregar Documento de Responsabilidad para el Activo Fijo al Empleado Indicado o al Responsable del Centro Funcional Indicado --->
		<cfset AFRffin= CreateDate(6100, 01, 01)>
		<cfquery datasource="#session.dsn#">
			insert into AFResponsables 
			(Ecodigo, DEid, Aid, CFid, CRCCid, CRTDid, CRDRdescripcion, CRDRdescdetallada, AFRfini, AFRffin, 
			Usucodigo, Ulocalizacion, Monto)
			select Ecodigo, DEid, Aid, CFid, CRCCid, #rsGetEmpresas.CRTDid#, <cf_dbfunction name="sPart" args="Adescripcion°1°80" delimiters="°">, Adescripcion, Afechaaltaadq, <cfif Lvar_Retirados>Afechaaltaret, <cfelse>#AFRffin#, </cfif>
			#session.usucodigo#, '00', AFSvaladq + AFSvalmej + AFSvalrev - AFSdepacumadq - AFSdepacummej - AFSdepacumrev
			from #Activos#
			where Ecodigo = #rsGetEmpresas.Ecodigo#
			  and not exists (Select 1
							  from #AF_CONVALES# av
							  where av.Ecodigo = #Activos#.Ecodigo
								and av.Placa = #Activos#.Aplaca)
		</cfquery>
		
		<!--- Pasa los Vales de CRDocumentoResponsabilidad a AFResponsables en donde Pasar sea 1 --->

		<cfquery datasource="#session.dsn#">
		insert into AFResponsables 
		(			Ecodigo, 
					DEid, 
					Aid, 
					CFid, 
					CRCCid, 
					CRTDid, 
					CRDRdescripcion, 
					CRDRdescdetallada, 
					AFRfini, 
					AFRffin, 
					Usucodigo, 
					Ulocalizacion, 
					CRDRtipodocori,
					CRDRdocori,					
					Monto,
					CRTCid,
					BMUsucodigo					
		)		
		select
					crdr.Ecodigo, 
					crdr.DEid, 
					act.Aid, 
					crdr.CFid, 
					crdr.CRCCid, 
					crdr.CRTDid, 
					crdr.CRDRdescripcion, 
					crdr.CRDRdescdetallada, 					
					crdr.CRDRfdocumento,
					#AFRffin#,
					#Session.Usucodigo#,
					'00', 										
					crdr.CRDRtipodocori, 
					crdr.CRDRdocori, 					
					crdr.Monto,
					crdr.CRTCid,
					#Session.Usucodigo#
					
		from CRDocumentoResponsabilidad crdr
				inner join #Activos# act
					 on act.Aplaca = crdr.CRDRplaca
					and act.Ecodigo = crdr.Ecodigo

				inner join #AF_CONVALES# av
					 on av.Ecodigo = act.Ecodigo
					and av.Placa   = act.Aplaca
					and av.Pasar   = 1
		
		</cfquery>
		
<!---validar si el activo esta en tránsito --->
<cfquery name="rsATransito" datasource="#session.dsn#">
	select count(1) as transito 
	  from CRDocumentoResponsabilidad dr 
	    inner join Activos a
	     on dr.CRDRplaca = a.Aplaca 
	    and dr.Ecodigo = a.Ecodigo 
</cfquery>

<cfif rsATransito.transito gt 0>

<script language="javascript1.1" type="text/javascript">
function trans (){
	alert("El Activo no se encuentra en tránsito:"+error_msg);
}
</script>
</cfif>

	
		<!--- Borra de CRDocumentoResponsabilidad los vales que se pasaron a AFResponsables --->
		<cfquery datasource="#session.dsn#">
		Delete from CRDocumentoResponsabilidad
		 where (select count(1) from #AF_CONVALES# a
						where a.Placa = CRDocumentoResponsabilidad.CRDRplaca
		  				and a.Ecodigo = CRDocumentoResponsabilidad.Ecodigo
		 				and a.Pasar = 1
		        ) > 0
		</cfquery>
		
		<cfif Lvar_Debug><cfdump var="#LSTimeFormat(now(),'HH:MM:SS')#"></cfif>
		<!--- Agregar CRBitacoraTran Adquisición --->
		<cfquery datasource="#session.dsn#">
			insert into CRBitacoraTran 
			(Ecodigo, CRBfecha, Usucodigo, CRBmotivo, CRBPlaca, AFRid, Aid, BMUsucodigo)
			select #Activos#.Ecodigo, #Activos#.Afechaaltaadq, #session.usucodigo#, 1, #Activos#.Aplaca, AFResponsables.AFRid, #Activos#.Aid, #session.usucodigo#
			from #Activos#
				inner join AFResponsables
					on AFResponsables.Ecodigo = #Activos#.Ecodigo
					and AFResponsables.Aid = #Activos#.Aid
			where #Activos#.Ecodigo = #rsGetEmpresas.Ecodigo#
		</cfquery>
		<cfif Lvar_Debug><cfdump var="#LSTimeFormat(now(),'HH:MM:SS')#"></cfif>
		<cfif Lvar_Retirados>
			<!--- Agregar Transacción de Retiros --->
			<cfinvoke component="sif.Componentes.OriRefNextVal" method="nextVal" ORI="AFDP" REF="DP" returnvariable="LvarNumDoc"/>
			<cfquery name="rs_agtp_insert" datasource="#session.dsn#">
				insert into AGTProceso(Ecodigo, IDtrans, AGTPdescripcion, AGTPperiodo, AGTPmes, 
					Usucodigo, AGTPestadp, AGTPecodigo, AGTPdocumento, AGTPipregistro, AGTPipaplica, Usuaplica, 
					AGTPfalta, AGTPfaplica)
				values (#rsGetEmpresas.Ecodigo#, 5, 'Ret. Inicial Activos Fijos', #rsGetEmpresas.Periodo#, #rsGetEmpresas.Mes#, 
					#session.usucodigo#, 4, #rsGetEmpresas.Ecodigo#, #LvarNumDoc#, '#session.sitio.ip#', '#session.sitio.ip#', #session.usucodigo#, 
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">, <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">)
				<cf_dbidentity1 verificar_transaccion="false">
			</cfquery>
			<cf_dbidentity2 name="rs_agtp_insert" verificar_transaccion="false">
			<cfquery datasource="#session.dsn#">
				insert into TransaccionesActivos 
					(Aid, Ecodigo, IDtrans, CFid, TAperiodo, TAmes, TAfecha, 	TAmontooriadq, TAmontolocadq, 
					TAmontoorimej, TAmontolocmej, TAmontoorirev, TAmontolocrev, TAmontodepadq, TAmontodepmej, 
					TAmontodeprev, Mcodigo, TAtipocambio, AGTPid, Usucodigo, TAfechainidep, TAvalrescate, 	TAvutil, 
					TAfechainirev, TAvaladq, TAvalmej, TAvalrev, TAdepacumadq, TAdepacummej, TAdepacumrev, TAfalta)
				select Aid, Ecodigo, 5, CFid, #rsGetEmpresas.Periodo#, #rsGetEmpresas.Mes#, Afechaaltaret, AFSvaladq, AFSvaladq, 
					AFSvalmej, AFSvalmej, AFSvalrev, AFSvalrev, AFSdepacumadq, AFSdepacummej, 
					AFSdepacumrev, #rsGetEmpresas.Mcodigo#, 1.00, #rs_agtp_insert.identity#, #session.usucodigo#, Afechainidep, Avalrescate, AFSvutiladq, 
					Afechainirev, AFSvaladq, AFSvalmej, AFSvalrev, AFSdepacumadq, AFSdepacummej, AFSdepacumrev, <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">
				from #Activos#
				where Ecodigo = #rsGetEmpresas.Ecodigo#
			</cfquery>
			<cfif Lvar_Debug><cfdump var="#LSTimeFormat(now(),'HH:MM:SS')#"></cfif>
			<!--- Agregar CRBitacoraTran Retiro --->
			<cfquery datasource="#session.dsn#">
				insert into CRBitacoraTran 
				(Ecodigo, CRBfecha, Usucodigo, CRBmotivo, CRBPlaca, AFRid, Aid, BMUsucodigo)
				select #Activos#.Ecodigo, #Activos#.Afechaaltaret, #session.usucodigo#, 2, #Activos#.Aplaca, AFResponsables.AFRid, #Activos#.Aid, #session.usucodigo#
				from #Activos#
					inner join AFResponsables
						on AFResponsables.Ecodigo = #Activos#.Ecodigo
						and AFResponsables.Aid = #Activos#.Aid
				where #Activos#.Ecodigo = #rsGetEmpresas.Ecodigo#
			</cfquery>
			<cfif Lvar_Debug><cfdump var="#LSTimeFormat(now(),'HH:MM:SS')#"></cfif>
		</cfif>
	</cfloop>
<cfif Lvar_Debug>
	<cfquery name="rstemp" datasource="#session.dsn#">select count(1) as Cantidad from #Activos#</cfquery>
	<cfdump var="#rstemp.Cantidad#" label="Temp_Activos">
	<cfquery name="rstemp" datasource="#session.dsn#">select count(1) as Cantidad from Activos where Aid > #Lvar_maxAidAnterior#</cfquery>
	<cfdump var="#rstemp.Cantidad#" label="Activos">
	<cfquery name="rstemp" datasource="#session.dsn#">select count(1) as Cantidad from AGTProceso where AGTPid > #Lvar_maxAGTPidAnterior#</cfquery>
	<cfdump var="#rstemp.Cantidad#" label="AGTProceso">
	<cfquery name="rstemp" datasource="#session.dsn#">select count(1) as Cantidad from TransaccionesActivos where TAid > #Lvar_maxTAidAnterior#</cfquery>
	<cfdump var="#rstemp.Cantidad#" label="TransaccionesActivos">
	<cfquery name="rstemp" datasource="#session.dsn#">select count(1) as Cantidad from AFSaldos where AFSid > #Lvar_maxAFSidAnterior#</cfquery>
	<cfdump var="#rstemp.Cantidad#" label="AFSaldos">
	<cfquery name="rstemp" datasource="#session.dsn#">select count(1) as Cantidad from AFResponsables where AFRid > #Lvar_maxAFRidAnterior#</cfquery>
	<cfdump var="#rstemp.Cantidad#" label="AFResponsables">
	<cfquery name="rstemp" datasource="#session.dsn#">select count(1) as Cantidad from CRBitacoraTran where CRBid > #Lvar_maxCRBidAnterior#</cfquery>
	<cfdump var="#rstemp.Cantidad#" label="CRBitacoraTran">
	<cfdump var="#LSTimeFormat(now(),'HH:MM:SS')#">
	<cfabort>
</cfif>
</cftransaction>
<!--- FIN --->
</cfif><!--- Lvar_continuar --->
</cfif><!--- Lvar_continuar --->
</cfif>



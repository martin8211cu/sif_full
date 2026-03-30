<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<!--- Funciona de Validación General de a existencia de un dato en la Base de Datos --->
<cffunction access="private" name="fnValida" output="false" returntype="boolean">
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
		<cf_dumptable name="#table_name#" abort="false" >
	</cfif>
	
	<cfquery datasource="#session.dsn#">
		insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
		select #table_name#.Aplaca, '#ErrorNum#. La Columna #Arguments.Columna# contiene un dato que ' #_Cat# #PreserveSingleQuotes(Arguments.Mensaje)# #_Cat# '.' as Mensaje, 
		<cfif Arguments.Type EQ 'D'>
			<cf_dbfunction name="date_format" args="#table_name#.#Arguments.Columna#,DD/MM/YYYY"> as DatoIncorrecto, 
		<cfelseif Arguments.Type EQ 'M'>
			<cf_dbfunction name="to_char_currency" args="#table_name#.#Arguments.Columna#"> as DatoIncorrecto, 
		<cfelseif Arguments.Type EQ 'F'>
			<cf_dbfunction name="to_char_float" args="#table_name#.#Arguments.Columna#"> as DatoIncorrecto, 
		<cfelse>
			<cf_dbfunction name="to_char" args="#table_name#.#Arguments.Columna#"> as DatoIncorrecto, 
		</cfif>
		#Arguments.ErrorNum# as ErrorNum
		from #table_name#
		where #table_name#.Aplaca is not null
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
<cf_dbtemp name="AF_INICIO_ERROR" returnvariable="AF_INICIO_ERROR" datasource="#session.dsn#">
	<cf_dbtempcol name="Aplaca" 		type="char(20)" 	mandatory="no">
	<cf_dbtempcol name="Mensaje" 		type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="DatoIncorrecto" type="varchar(40)" 	mandatory="no">
	<cf_dbtempcol name="ErrorNum" 		type="integer" 		mandatory="yes">
</cf_dbtemp>

<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetPeriodoAux" returnvariable="rsPeriodo.value"/>
<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetMesAux" 	returnvariable="rsMes.value"/>

<!--- 400. Aplaca: valida que no sea nulo. --->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select <cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">, '400. Existe(n) ' #_Cat# <cf_dbfunction name="to_char" args="count(1)"> #_Cat# ' placa(s) en blanco.', <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">, 400
	from #table_name#
	where Aplaca is null
	having count(1) > 0
</cfquery>

<!--- 410. Aplaca: Repetida en el Archivo. --->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select Aplaca, '410. La Placa se encuentra ' #_Cat# <cf_dbfunction name="to_char" args="count(1)"> #_Cat# ' veces en el Archivo' as Mensaje, 
	<cf_dbfunction name="to_char" args="Aplaca"> as DatoIncorrecto, 410 as ErrorNum
	from #table_name#
	where Aplaca is not null
	group by Aplaca
	having count(1) > 1
</cfquery>

<!--- 420. Aplaca: base de datos exista. --->
<cfinvoke method="fnValida"
	Columna="Aplaca"
	Type="S"
	Tabla="Activos"
	Filtro="Activos.Ecodigo = #session.Ecodigo# and Activos.Aplaca = #table_name#.Aplaca"
	Mensaje="'no existe para la empresa #session.Enombre#'"
	ErrorNum="420"/>
	
<!--- 430. Aplaca: valida que no este retirado para la empresa. --->
<cfinvoke method="fnValida"
	Columna="Aplaca"
	Type="S"
	Tabla=""
	Filtro=""
	FiltroGral="exists (select 1 from Activos where Activos.Ecodigo = #session.Ecodigo# and Activos.Aplaca = #table_name#.Aplaca and Activos.Astatus = 60)"
	Mensaje="'está retirado para la empresa #session.Enombre#'"
	ErrorNum="430"/>
	
<!---Activo Inconsistente(Mas de un Documento de responsabilidad vigente)--->
<cfquery datasource="#session.dsn#">
    insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select b.Aplaca, '411. El Activo esta inconsistente, tiene mas de un un Documento de Responsabilidad vigente' as Mensaje, 
	<cf_dbfunction name="to_char" args="b.Aplaca"> as DatoIncorrecto, 411 as ErrorNum
  	from AFResponsables a 
		inner join Activos b
		   on a.Aid= b.Aid
		   and a.Ecodigo=b.Ecodigo
		where <cf_dbfunction name="now"> between a.AFRfini and a.AFRffin
		and a.Ecodigo= #session.Ecodigo# and b.Aplaca in (select c.Aplaca from #table_name# c)
	group by b.Aplaca 
	having count(1) >1
</cfquery>

<!---Activo Inconsistente(Activo repetido en la base de datos)---->
<cfquery datasource="#session.dsn#">
    insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Aplaca, '412. El Activo esta inconsistente, la placa esta repetida en la base de datos' as Mensaje, 
	<cf_dbfunction name="to_char" args="a.Aplaca"> as DatoIncorrecto, 412 as ErrorNum
  	from Activos a
		where a.Ecodigo= #session.Ecodigo# and a.Aplaca in (select b.Aplaca from #table_name# b)
	group by a.Aplaca 
	having count(1) >1
</cfquery>

<!----Activo Inconsistente (El Activo se encuentra Activo y en transito a la vez)---->
<cfquery datasource="#session.dsn#">
    insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Aplaca, '413. El Activo esta inconsistente, se encuentra Activo y en transito a la vez' as Mensaje, 
	<cf_dbfunction name="to_char" args="a.Aplaca"> as DatoIncorrecto, 412 as ErrorNum
  	from Activos a
		inner join #table_name# b
		   on a.Aplaca = b.Aplaca
		inner join CRDocumentoResponsabilidad c
		   on c.CRDRplaca = a.Aplaca         
		where a.Ecodigo= #session.Ecodigo# 
</cfquery>

<!-----Activo ya se encuentra en la lista de Activos por ser Aplicados---->
<cfquery datasource="#session.dsn#">
    insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Aplaca, '414. El activo se encuentra en una transaccion de retiro desde control de responsables' as Mensaje, 
	<cf_dbfunction name="to_char" args="a.Aplaca"> as DatoIncorrecto, 414 as ErrorNum
  	from Activos a
		inner join #table_name# b
		   on a.Aplaca = b.Aplaca
		inner join CRCRetiros c
		   on a.Aid= c.Aid       
		where a.Ecodigo= #session.Ecodigo# 
</cfquery>

<!-----Activo se encuentra en la cola de transaccciones de control de responsables---->
<cfquery datasource="#session.dsn#">
    insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Aplaca, '415. El activo se encuentra en la cola de Control de responsables' as Mensaje, 
	<cf_dbfunction name="to_char" args="a.Aplaca"> as DatoIncorrecto, 415 as ErrorNum
  	from Activos a
		inner join #table_name# b
		   on a.Aplaca = b.Aplaca
		inner join CRColaTransacciones c
		   on a.Aid= c.Aid       
		where a.Ecodigo= #session.Ecodigo# 
</cfquery>

<!-----Activo se encuentra en una transaccion pendiente de aplicar en activos Fijos---->
<cfquery datasource="#session.dsn#">
 insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Aplaca, '416. El activo se encuentra en una transaccion de ' #_Cat# d.AFTdes #_Cat# ' pendiente de Aplicar en Activos Fijos' as Mensaje, 
	<cf_dbfunction name="to_char" args="a.Aplaca"> as DatoIncorrecto, 416 as ErrorNum
  	from Activos a
		inner join #table_name# b
		   on a.Aplaca = b.Aplaca
		inner join ADTProceso c
		   on a.Aid= c.Aid   
		inner join AFTransacciones d
	 	    on d.IDtrans = c.IDtrans  
		where a.Ecodigo= #session.Ecodigo# 
</cfquery>

<!-----Activo se encuentra en una transacción de traspaso de responsable pendiente de aplicar---->
<cfquery datasource="#session.dsn#">
    insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Aplaca, '417. El activo se encuentra en una transacción de traspaso de responsable pendiente de aplicar desde control de responsables' as Mensaje, 
	<cf_dbfunction name="to_char" args="a.Aplaca"> as DatoIncorrecto, 417 as ErrorNum
  	from Activos a
		inner join #table_name# b
		   on a.Aplaca = b.Aplaca
		inner join AFResponsables c
		   on a.Aid= c.Aid  
		inner join AFTResponsables d
		   on c.AFRid = d.AFRid
		where a.Ecodigo= #session.Ecodigo# 
</cfquery>

<!-----Permisos del centro de custodia---->
<cfquery datasource="#session.dsn#">
    insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Aplaca, '418. Usted no tiene permiso para retirar activos del centro de custodia de ' #_Cat# f.CRCCcodigo #_Cat# '-' #_Cat# f.CRCCdescripcion as Mensaje, 
	<cf_dbfunction name="to_char" args="a.Aplaca"> as DatoIncorrecto, 418 as ErrorNum
  	from Activos a
		inner join #table_name# b
		   on a.Aplaca = b.Aplaca
		inner join AFResponsables c
		   on a.Aid= c.Aid
		   and <cf_dbfunction name="now"> between c.AFRfini and c.AFRffin
		inner join CRCentroCustodia f
		    on f.CRCCid = c.CRCCid
		where a.Ecodigo= #session.Ecodigo# and not exists
		   (
		    select 1 
			from CRCCUsuarios e
			 where e.Usucodigo = #session.Usucodigo#
			 and e.CRCCid = c.CRCCid 
		   )
</cfquery>

<!---Activo Inconsistente(sin vale vigente)--->
<cfquery datasource="#session.dsn#">
    insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select b.Aplaca, '411. El Activo esta inconsistente, No tienen un Documento de responsabilidad vigente' as Mensaje, 
	<cf_dbfunction name="to_char" args="b.Aplaca"> as DatoIncorrecto, 411 as ErrorNum
  	from AFResponsables a 
		inner join Activos b
		   on a.Aid= b.Aid
		   and a.Ecodigo=b.Ecodigo
		where <cf_dbfunction name="now"> between a.AFRfini and a.AFRffin
		and a.Ecodigo= #session.Ecodigo# and b.Aplaca in (select c.Aplaca from #table_name# c)
	group by b.Aplaca 
	having count(1) = 0
</cfquery>

<cfquery name="err" datasource="#session.dsn#">
	select Aplaca, Mensaje
	from #AF_INICIO_ERROR#
	order by Aplaca, ErrorNum
</cfquery>

<!---Inserta los retiros de Activos por Aplicar---->
<cfif (err.recordcount) EQ 0>
	<cfquery datasource="#Session.Dsn#">
		INSERT into CRCRetiros(Ecodigo, Aid, AFRid, BMUsucodigo) 
		select   #session.Ecodigo# , 
			b.Aid,
			c.AFRid,
			#session.Usucodigo#
		from #table_name# a
			inner join Activos b
			 on a.Aplaca = b.Aplaca
			inner join AFResponsables c
			  on b.Aid = c.Aid
			  and <cf_dbfunction name="now"> between c.AFRfini and c.AFRffin
	</cfquery>
</cfif>


<!--- *********************  I m p o r t a d o r   d e   R e s u l t a d o s   d e   C o n t e o ********************* --->
<!--- Este importador estÃ¡ desarrollado con una funcionalidad limitada, para solventar una necesisdad especÃ­fica, de una 
cliente. Ricardo PÃ©rez, el mismo puede pero no debe ser utilzado en otro cliente, debido a que debe realizarse una anÃ¡lisis
profundo de la funcionalidad completa que debe tener el importador de este proceso para cumplir con toda la funcionalidad
permitida en el proceso. --->
<!---- ************************************* V A L I D A C I O N E S ************************************ --->
<!--- FunciÃ³n General de ValidaciÃ³n. Hace mas complejo este importador, dada la simplicidad de la funcionalidad inicial, 
pero estÃ¡ pensado a futuro para soportar muchas validaciones, de manera clara, ordenada y flexible. (Ver Importador de 
Activos Inicial S.R y R. para ver un ejemplo que aprovecha mejor este tipo de validaciÃ³n en un proceso de importaciÃ³n) --->
<cffunction 
		access="private" 
		name="fnValida"
		output="false" 
		returntype="boolean">
	<cfargument name="Columna" required="true">
	<cfargument name="Type" required="false" default="S">
	<cfargument name="Tabla" required="true">
	<cfargument name="Filtro" required="true">
	<cfargument name="Mensaje" required="true">
	<cfargument name="ErrorNum" required="true"/>
	<cfargument name="filtroGral" required="false" default=""/>
	<cfargument name="exists" required="false" default="false"><!--- true indica que hay error cuando existe --->
	<cfargument name="permiteNulos" required="false" default="false" type="boolean"/>
	<cfargument name="debug" required="false" default="false" type="boolean"/>
	<cfif Arguments.debug>
		<cf_dumptable name="#table_name#" abort="false">
	</cfif>
	<cfquery datasource="#session.dsn#">
		insert into #AF_INICIO_ERROR# (Placa, Mensaje, DatoIncorrecto, ErrorNum)
		select #table_name#.Placa, {fn concat('#ErrorNum#. La Columna #Arguments.Columna# contiene un dato que ',{fn concat(#PreserveSingleQuotes(Arguments.Mensaje)#,'.')})} as Mensaje, 
		<cfif Arguments.Type EQ 'D'>
			<cf_dbfunction name="date_format" args="#table_name#.#Arguments.Columna#,DD/MM/YYYY">
		<cfelseif Arguments.Type EQ 'M'>
			<cf_dbfunction name="to_char_currency" args="#table_name#.#Arguments.Columna#">
		<cfelse>
			<cf_dbfunction name="to_char" args="#table_name#.#Arguments.Columna#">
		</cfif> as DatoIncorrecto, 
		#Arguments.ErrorNum# as ErrorNum
		from #table_name#
		where #table_name#.Placa is not null
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
<!--- Tabla Temporal de Errores: El propÃ³sito de utilizar esta tabla es devolver todos los errores del archivo en una sola 
salida, dando asÃ­ al usuario la facilidad de corregir todos los errores de una sola vez en lugar de hacerlo tipo por tipo --->
<cf_dbtemp name="AF_INICIO_ERROR" returnvariable="AF_INICIO_ERROR" datasource="#session.dsn#">
	<cf_dbtempcol name="Placa" type="char(20)" mandatory="no">
	<cf_dbtempcol name="Mensaje" type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="DatoIncorrecto" type="varchar(40)" mandatory="no">
	<cf_dbtempcol name="ErrorNum" type="integer" mandatory="yes">
</cf_dbtemp>
<cf_dbfunction name="now" returnvariable="hoy">
<!--- 100. Placa: Validar que la placa no venga nula (100), no venga repetida(110), exista existe en la empresa(120),
este activa(130), tenga saldos(140), tenga responsable(150), no este en otra hoja de conteo activa(160) --->
<!--- 100 --->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Placa, Mensaje, DatoIncorrecto, ErrorNum)
	select '' as Placa, {fn concat('100. Existen ', {fn concat(<cf_dbfunction name="to_char" args="count(1)">, ' Placas nulas en el Archivo.')})} as Mensaje, 
	'' as DatoIncorrecto, 100 as ErrorNum
	from #table_name#
	where Placa is null
	having count(1) > 0
</cfquery>
<!--- 110 --->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Placa, Mensaje, DatoIncorrecto, ErrorNum)
	select Placa, {fn concat('110. La Placa se encuentra ', {fn concat(<cf_dbfunction name="to_char" args="count(1)">, ' veces en el Archivo.')})} as Mensaje, 
	<cf_dbfunction name="to_char" args="Placa"> as DatoIncorrecto, 110 as ErrorNum
	from #table_name#
	where #table_name#.Placa is not null
	group by Placa
	having count(1) > 1
</cfquery>
<!--- 120 --->
<cfinvoke method="fnValida"
	Columna="Placa"
	Tabla="Activos"
	Filtro="Activos.Ecodigo = #session.Ecodigo#
		and Activos.Aplaca = #table_name#.Placa"
	Mensaje="'no existe para la Empresa'"
	exists="false"
	ErrorNum="120"/>
<!--- 130 --->
<cfinvoke method="fnValida"
	Columna="Placa"
	Tabla="Activos"
	Filtro="Activos.Ecodigo = #session.Ecodigo#
		and Activos.Aplaca = #table_name#.Placa
		and Astatus = 0"
	Mensaje="'no est&aacute; activo en la Empresa'"
	exists="false"
	ErrorNum="130"/>
<!--- 140 --->
<cf_dbfunction name="to_number" returnvariable="Lto_number_Pvalor" args="Parametros.Pvalor">
<cfinvoke method="fnValida"
	Columna="Placa"
	Tabla="Activos
		inner join AFSaldos b
			on b.Ecodigo = Activos.Ecodigo
			and b.Aid = Activos.Aid
			and b.AFSperiodo = (select #Lto_number_Pvalor# from Parametros where Ecodigo = Activos.Ecodigo and Pcodigo = 50)
			and b.AFSmes = 		(select #Lto_number_Pvalor# from Parametros where Ecodigo = Activos.Ecodigo and Pcodigo = 60)"
	Filtro="Activos.Ecodigo = #session.Ecodigo#
		and Activos.Aplaca = #table_name#.Placa
		and Astatus = 0"
	Mensaje="'no tiene saldos para el periodo / mes de auxiliares'"
	exists="false"
	ErrorNum="140"/>
<!--- 150 --->
<cf_dbfunction name="to_number" returnvariable="Lto_number_Pvalor" args="Parametros.Pvalor">
<cfinvoke method="fnValida"
	Columna="Placa"
	Tabla="Activos
		inner join AFSaldos b
			on b.Ecodigo = Activos.Ecodigo
			and b.Aid = Activos.Aid
			and b.AFSperiodo = (select #Lto_number_Pvalor# from Parametros where Ecodigo = Activos.Ecodigo and Pcodigo = 50)
			and b.AFSmes = 		(select #Lto_number_Pvalor# from Parametros where Ecodigo = Activos.Ecodigo and Pcodigo = 60)"
	Filtro="Activos.Ecodigo = #session.Ecodigo#
		and Activos.Aplaca = #table_name#.Placa
		and Astatus = 0
		and exists(
				select 1 from AFResponsables
				where Ecodigo = Activos.Ecodigo
				and Aid = Activos.Aid 
				and #hoy# between AFRfini and AFRffin
			)"
	Mensaje="'no tiene responsable en el modulo de control de responsables'"
	exists="false"
	ErrorNum="150"/>
<!--- 160 --->
<cf_dbfunction name="to_number" returnvariable="Lto_number_Pvalor" args="Parametros.Pvalor">
<cfinvoke method="fnValida"
	Columna="Placa"
	Tabla="Activos
		inner join AFSaldos b
			on b.Ecodigo = Activos.Ecodigo
			and b.Aid = Activos.Aid
			and b.AFSperiodo = (select #Lto_number_Pvalor# from Parametros where Ecodigo = Activos.Ecodigo and Pcodigo = 50)
			and b.AFSmes = 		(select #Lto_number_Pvalor# from Parametros where Ecodigo = Activos.Ecodigo and Pcodigo = 60)"
	Filtro="Activos.Ecodigo = #session.Ecodigo#
		and Activos.Aplaca = #table_name#.Placa
		and Astatus = 0
		and exists(
				select 1 from AFResponsables
				where Ecodigo = Activos.Ecodigo
				and Aid = Activos.Aid 
				and #hoy# between AFRfini and AFRffin
			)
		and not exists(
				select 1 from AFTFDHojaConteo x
					inner join AFTFHojaConteo y 
					on y.AFTFid_hoja = x.AFTFid_hoja
					and y.AFTFestatus_hoja < 3
				where x.Aid = Activos.Aid
				and x.Ecodigo = Activos.Ecodigo
				and x.AFTFid_hoja <> #Form.AFTFid_hoja#
			)"
	Mensaje="'se encuentra en otra hoja de conteo activa'"
	exists="false"
	ErrorNum="160"/>
<!--- ERR: Devuelve todos los errores encontrados al archivo ordenados por placa y nÃºmero de error en una tabla HTML --->
<cfquery name="err" datasource="#session.dsn#">
	select distinct Placa, Mensaje, DatoIncorrecto 
	from #AF_INICIO_ERROR#
	order by Placa, ErrorNum
</cfquery>
<!---- ****************************************  P R O C E S O  *************************************** --->
<cfif (err.recordcount) EQ 0>
	<!--- PROCESO 1. Para las placas que si existen en el archivo actualiza el estatus del resgistro guardado en el campo
	AFTFbanderaproceso (0 x 1, 1 x 3; 2,3,4 no cambian) --->
	<cfquery name="rsp2" datasource="#session.dsn#">
		select AFTFid_detallehoja			
		from #table_name# a
			inner join Activos b
				inner join AFTFDHojaConteo c
				on c.Ecodigo = b.Ecodigo
				and c.Aid = b.Aid
				and c.AFTFid_hoja = #Form.AFTFid_hoja# 
				and c.AFTFbanderaproceso = 1
			on b.Ecodigo = #session.Ecodigo#
			and b.Aplaca = a.Placa 
	</cfquery>
	<cfif rsp2.recordcount gt 0>
		<cfinvoke component="sif.af.tomaFisica.componentes.aftfHojasConteo" 
				method="updatebDHojaConteo"><!--- Ojo que se utiliza el updateb porque este verifica el estado 4 --->
			<cfinvokeargument name="AFTFid_hoja" value="#Form.AFTFid_hoja#">
			<cfinvokeargument name="AFTFid_detallehoja" value="#ValueList(rsp2.AFTFid_detallehoja)#">
			<cfinvokeargument name="AFTFbanderaproceso" value="3">
		</cfinvoke>
	</cfif>
	<cfquery name="rsp1" datasource="#session.dsn#">
		select AFTFid_detallehoja			
		from #table_name# a
			inner join Activos b
				inner join AFTFDHojaConteo c
				on c.Ecodigo = b.Ecodigo
				and c.Aid = b.Aid
				and c.AFTFid_hoja = #Form.AFTFid_hoja# 
				and c.AFTFbanderaproceso = 0
			on b.Ecodigo = #session.Ecodigo#
			and b.Aplaca = a.Placa 
	</cfquery>
	<cfif rsp1.recordcount gt 0>
		<cfinvoke component="sif.af.tomaFisica.componentes.aftfHojasConteo" 
				method="updatebDHojaConteo"><!--- Ojo que se utiliza el updateb porque este verifica el estado 4 --->
			<cfinvokeargument name="AFTFid_hoja" value="#Form.AFTFid_hoja#">
			<cfinvokeargument name="AFTFid_detallehoja" value="#ValueList(rsp1.AFTFid_detallehoja)#">
			<cfinvokeargument name="AFTFbanderaproceso" value="1">
		</cfinvoke>
	</cfif>
	<cfquery name="rsp3" datasource="#session.dsn#">
		select Aid
		from Activos a, #table_name# b
		where a.Ecodigo = #Session.Ecodigo#
		and a.Aplaca = b.Placa
		and not exists(
			select 1 
			from AFTFDHojaConteo c
			where c.AFTFid_hoja = #Form.AFTFid_hoja#
			and c.Ecodigo = a.Ecodigo
			and c.Aid = a.Aid
		)
	</cfquery>
	<cfif rsp3.recordcount gt 0>
		<cfinvoke component="sif.af.tomaFisica.componentes.aftfHojasConteo" 
				method="insertDHojaConteoWFilters" returnvariable="resAFTFid_detallehoja">
			<cfinvokeargument name="AFTFid_hoja" value="#Form.AFTFid_hoja#">
			<cfinvokeargument name="Aid" value="#ValueList(rsp3.Aid)#">
			<cfinvokeargument name="AFTForigen" value="1">
			<cfinvokeargument name="AFTFbanderaproceso" value="4">
		</cfinvoke>
	</cfif>
	<cfquery name="rsp4" datasource="#session.dsn#">
		select AFTFid_detallehoja
		from AFTFDHojaConteo c
		where c.AFTFid_hoja = #Form.AFTFid_hoja#
		and c.AFTFbanderaproceso = 0
	</cfquery>
	<cfif rsp4.recordcount gt 0>
		<cfinvoke component="sif.af.tomaFisica.componentes.aftfHojasConteo" 
				method="updatebDHojaConteo"><!--- Ojo que se utiliza el updateb porque este verifica el estado 4 --->
			<cfinvokeargument name="AFTFid_hoja" value="#Form.AFTFid_hoja#">
			<cfinvokeargument name="AFTFid_detallehoja" value="#ValueList(rsp4.AFTFid_detallehoja)#">
			<cfinvokeargument name="AFTFbanderaproceso" value="2">
		</cfinvoke>
	</cfif>
</cfif>

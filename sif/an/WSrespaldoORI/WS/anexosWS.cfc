<cfcomponent output="no">
	<cffunction name="Version" access="remote" output="no" returntype="void">
		<cfargument name="WSkey" 	type="string"  	required="yes">
		<cfargument name="Numero" 	type="string"  	required="yes">
		
        
		<cfset LvarVersionXLA = 0>
        <cftry>
			<cfset LvarVersionXLA = Arguments.Numero + 0>
        <cfcatch type="any"></cfcatch>
        </cftry>
		<cfset LvarVersionSRV = "2.11">
		<cfif Arguments.Numero NEQ LvarVersionSRV>
        	<cfset LvarMSG = "Error de Versión de SOINanexos:  Versión instalada en el Servidor #LvarVersionSRV#. Versión instalada en Excel #Arguments.Numero#:\n\n">
            <cfif LvarVersionXLA LT LvarVersionSRV+0>
				<cf_errorCode	code = "50838"
								msg  = "@errorDat_1@Debe bajar e instalar la última versión de SOINanexos en su computador antes de utilizarlo."
								errorDat_1="#LvarMSG#"
				>
            <cfelse>
            	<cf_errorCode	code = "50839"
            					msg  = "@errorDat_1@Existe un nuevo parche de SOINanexos que debe ser instalado en su Servidor, comuniquese con el Área de Tecnología."
            					errorDat_1="#LvarMSG#"
            	>
            </cfif>
		</cfif>
		<cfif isdefined("application.anexos.#WSkey#")>
			<cfset application.anexos[WSkey].Version = Numero>
		</cfif>
	</cffunction>
			
<!---
	PROCESOS DURANTE EL DISEÑO DEL ANEXO:
		En SIF --> Anexos --> Administración de Anexos --> <Cargar con SOINanexos>:
			Se inicializa la Seguridad:
				Se crea una Llave de Seguridad para identificar el permiso:
					WSkey=UPL#GetTickCount()# 
				Se crea la estructura para almacenar el permiso:
					application.anexos.#WSkey#
					application.anexos.#WSkey#.timestamp = GetTickCount()
					application.anexos.#WSkey#.etapa 	 = "INICIO"
					application.anexos.#WSkey#.session	 = session.[lo que se ocupa de session]
			Se crea una hoja Excel de Operacion (WS_XLOP) en formato XML con la siguiente estructura
						COLUMNA 1:			COLUMNA 2:			COLUMNA 3:	COLUMNA 4:
				FILA 1:	SoinXLOP,			URL WebService
				FILA 2:	Operacion UPLOAD,	WSkey de Seguridad
				FILA 3:	AnexoId a Cargar, 	Consecutivo=1,		N/A,		Descripcion Anexo
			Se hace un download de la hoja Excel
		En Excel --> SOINanexos.XLA --> Al abrir cualquier Hoja y se determina que es WS_XLOP:
			Se abre la hoja de Operaciones WS_XLOP
			Se visualiza el botón de <Guardar Diseño>
			Se envía el siguiente mensaje:
				"1. Active el Libro de Trabajo (Workbook) que corresponde al Diseño del Anexo: " + FvarUploadACnombre + vbCrLf + _
				"2. Presione el botón de <Guardar Diseño> en la barra de comandos SOINanexos"
			Cierra la hoja de Operaciones WS_XLOP y espera a que el usuario presione <Guardar Diseño>
		En Excel --> SOINanexos.XLA --> <Guardar Diseño>:
			Se pregunta si la hoja actual corresponde al Diseño del Anexo que se quiere cargar
			Se esconde el botón de <Guardar Diseño>
			Obtiene los Rangos:
				Se crea un arreglo con todos los rangos, donde cada rango tiene la siguiente estructura:
					Si el Rango es de multiples celdas: rangoRow=-1, rangoCol=-1
					Si el Rango no tiene formula:		rangoFormula = "*"
					LvarRango[i] = "RangeName,SheetName,rangoRow,rangoCol,rangoFormula"
			Genera el Anexo Diseñado en formato XLS
			Genera el Anexo Diseñado en formato HTML
			Obtiene un Arreglo Binario con el Archivo XLS
			Obtiene un Arreglo Binario con el Archivo ZIP resultado de comprimir el formato HTML
			TIEMPO DE PRUEBA ANTES DE LLAMAR AL WEBSERVICE:
				Con una prueba de un XLS de 3.2 MB y con 2,200 rangos se obtuvo los siguientes resultados:
					HTML generado: 6 MB
					ZIP  generado: 1.5 MB
					TIEMPO DE PROCESAMIENTO EN EXCEL: 
						15 segundos
					El tiempo a considerar para que la seguridad otorgue permiso de realizar el proceso es:
						30 segundos + Tiempo que el usuario busca el anexo a cargar y presiona <Guardar Diseño>
			Ejecuta el metodo WebService: GrabarAnexoDisenoRAN
				Coldfusion recibe un arreglo con todos los Rangos de la Hoja Excel
				Limpia el XML, XLS y ZIP del Anexo en la Base de Datos
				Ejecuta sif.an.operacion.admin.anexo-UpParseoXML.LimpiarAnexoCel
				Por cada Rango en el arreglo:
					Ejecuta sif.an.operacion.admin.anexo-UpParseoXML.AgregaAnexoCel
				TIEMPO DE PRUEBA con 2,200 rangos: 
					24 segundos
			Ejecuta el metodo WebService: GrabarAnexoDisenoXLS
				Coldfusion recibe un Dato Binario con el XLS
				Si la imagen ya existe en Anexoim:
					Guarda el XML y XLS anterior en AnexoVersion
					Actualiza el XML = null y XLS = dato Binario recibido en Anexoim
				si no existe la imagen en Anexoim:
					Inserta  el XML = null y XLS = dato Binario recibido en Anexoim
				TIEMPO DE PRUEBA con dato binario de 3.2 MB: 
					10 segundos
			Ejecuta el metodo WebService: GrabarAnexoDisenoZIP
				Coldfusion recibe un Dato Binario con el XLS
				Borra la imagen HTML del día:
					Borra directorio /sif/an/html/YYYYMMDD/AD#AnexoId#
				Actualiza el ZIP = dato Binario recibido en Anexoim
				TIEMPO DE PRUEBA con dato binario de 1.5 MB: 
					5 segundos

	RESUMEN OPERACIONES								TIEMPO		Espera	TIEMPO
													ANTES WS	WS		DESPUES WS
	Anexos:	Download XLOP							0
	Excel:	Usuario presiona Salvar					2
	Excel:	Obtiene los Rangos						1
	Excel:	Genera el Anexo Diseño XLS y HTML/ZIP 	2
	WS:		GrabarAnexoDisenoRAN 					1			(6-1)	0
	WS:		GrabarAnexoDisenoXLS 					10			(10-1)	0
	WS:		GrabarAnexoDisenoZIP 					10			(10-1)	0		

--->

	<cffunction name="GrabarAnexoDisenoRAN" access="remote" output="no" returntype="void">
		<cfargument name="WSkey" 	type="string"  	required="yes">
		<cfargument name="ACkey" 	type="string"  	required="yes">
		<cfargument name="AnexoId"  type="string" 	required="yes">
		<cfargument name="Rangos"	type="array"  	required="yes">

		<cfset GrabarAnexoDisenoRAN_2 (Arguments.WSkey, Arguments.ACkey, Arguments.AnexoId, Arguments.Rangos, true)>
	</cffunction>

	<cffunction name="GrabarAnexoDisenoRAN_2" access="remote" output="no" returntype="void">
		<cfargument name="WSkey" 	type="string"  	required="yes">
		<cfargument name="ACkey" 	type="string"  	required="yes">
		<cfargument name="AnexoId"  type="string" 	required="yes">
		<cfargument name="Rangos"	type="array"  	required="yes">
		<cfargument name="Inicial"	type="boolean" 	required="no" default="yes">
		
		<cfset LvarTiempoEspera = 5>
		<cfset sbVerificarSeguridad (Arguments.WSkey, Arguments.ACkey, Arguments.AnexoId, LvarTiempoEspera)>
		
		<cfsetting requesttimeout="900">

		<cfif Arguments.Inicial>
			<cfquery name="rsXML" datasource="#session.DSN#">
				update Anexoim
				   set AnexoDef = null
					 , AnexoXLS = null
					 , AnexoZIP = null
				 where AnexoId 	= <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.AnexoId#">				
			</cfquery>
			<cfset LvarObj = createObject("component","sif.an.operacion.admin.anexo-UpParseoXML")>
			<cfset LvarObj.LimpiarAnexoCel(Arguments.AnexoId)>
		</cfif>

		<cfif not isdefined("LvarObj")>
			<cfset LvarObj = createObject("component","sif.an.operacion.admin.anexo-UpParseoXML")>
		</cfif>

		<cfset LvarRangosN = arrayLen(Arguments.Rangos)>
		<cfloop index="i" from="1" to="#LvarRangosN#">
			<cfif Arguments.Rangos[i] EQ "EOF">
				<cfbreak>
			</cfif>

			<cfif Arguments.Rangos[i] NEQ ":">
				<cfset LvarRango = listToArray(Arguments.Rangos[i])>
				<!---
					LvarRango[2] = SheetName
					LvarRango[1] = RangeName
					LvarRango[3] = rangoRow
					LvarRango[4] = rangoCol
					LvarRango[5] = rangoFor
				--->

				<cftry>
					<cfset LvarObj.GuardarAnexoCel(Arguments.AnexoId, LvarRango[2], LvarRango[1], LvarRango[3], LvarRango[4], LvarRango[5])>
				<cfcatch type="any">
					<cflog file="SOINanexos" text="Error Grabando Rango Sheet='#LvarRango[2]#', RangeName='#LvarRango[1]#', Row='#LvarRango[3]#', Col='#LvarRango[4]#', Formula='#LvarRango[5]#': #cfcatch.Message# #cfcatch.Detail#">
					<cf_errorCode	code = "50840"
									msg  = "Error Grabando Rango Sheet='@errorDat_1@', RangeName='@errorDat_2@', Row='@errorDat_3@', Col='@errorDat_4@', Formula='@errorDat_5@': @errorDat_6@ @errorDat_7@"
									errorDat_1="#LvarRango[2]#"
									errorDat_2="#LvarRango[1]#"
									errorDat_3="#LvarRango[3]#"
									errorDat_4="#LvarRango[4]#"
									errorDat_5="#LvarRango[5]#"
									errorDat_6="#cfcatch.Message#"
									errorDat_7="#cfcatch.Detail#"
					>
				</cfcatch>
				</cftry>
			</cfif>
		</cfloop>

		<cfset sbActualizarSeguridad (Arguments.WSkey, Arguments.ACkey, false)>
		<cfreturn>
	</cffunction>

	<cffunction name="GrabarAnexoDisenoXLS" access="remote" output="no" returntype="void">
		<cfargument name="WSkey" 	type="string"  	required="yes">
		<cfargument name="ACkey" 	type="string"  	required="yes">
		<cfargument name="AnexoId"  type="string" 	required="yes">
		<cfargument name="XLS" 		type="binary"  	required="yes">

		<cfset sbVerificarSeguridad (Arguments.WSkey, Arguments.ACkey, Arguments.AnexoId)>
		
		<cfset sbGrabarAnexoDisenoXLS (Arguments.AnexoId, Arguments.XLS)>

		<cfset sbActualizarSeguridad (Arguments.WSkey, Arguments.ACkey, false)>
		<cfreturn>
	</cffunction>

	<cffunction name="sbGrabarAnexoDisenoXLS" access="private" output="no" returntype="void">
		<cfargument name="AnexoId"  type="string" 	required="yes">
		<cfargument name="XLS" 		type="binary"  	required="yes">

		<cfquery datasource="#session.dsn#" name="existe">
			select 1
			  from Anexoim
			 where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AnexoId#">
		</cfquery>

		<cfif existe.RecordCount>
			<cfquery datasource="#session.dsn#">
				insert into AnexoVersion (
					AnexoId, AnexoVersion, Ecodigo,
					AnexoDef, AnexoXLS,
					AnexoDes, AnexoEditor,
					BMfecha, BMUsucodigo)
				select
					<!---a.AnexoId, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, a.Ecodigo,--->
					a.AnexoId, <CF_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">, a.Ecodigo,
					i.AnexoDef, i.AnexoXLS, 
					a.AnexoDes, i.AnexoEditor,
					a.AnexoFec, coalesce (a.BMUsucodigo, 0) as BMUsucodigo
				from Anexo a
					inner join Anexoim i
						on a.AnexoId = i.AnexoId
				where a.AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AnexoId#">
				  and (<cf_dbfunction name="islobnotnull" args="i.AnexoDef"> OR <cf_dbfunction name="islobnotnull" args="i.AnexoXLS">)
			</cfquery>

			<cfquery name="rsXML" datasource="#session.DSN#">
				update Anexoim
				   set AnexoXLS = <cfqueryparam cfsqltype="cf_sql_blob" 		value="#Arguments.XLS#">				 
				     , AnexoDef = null
				 where AnexoId 	= <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.AnexoId#">
			</cfquery>
		<cfelse>
			<cfquery name="rsInsUp" datasource="#Session.DSN#">
				insert into Anexoim (Ecodigo, AnexoId, AnexoXLS, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" 		value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.AnexoId#">,
					<cfqueryparam cfsqltype="cf_sql_blob" 			value="#Arguments.XLS#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#session.Usucodigo#">
				)
			</cfquery>
		</cfif>

		<cfreturn>
	</cffunction>

	<cffunction name="GrabarAnexoDisenoZIP" access="remote" output="no" returntype="void">
		<cfargument name="WSkey" 	type="string"  	required="yes">
		<cfargument name="ACkey" 	type="string"  	required="yes">
		<cfargument name="AnexoId"  type="string" 	required="yes">
		<cfargument name="ZIP" 		type="binary"  	required="yes">		
		
		<cfset sbVerificarSeguridad (Arguments.WSkey, Arguments.ACkey, Arguments.AnexoId)>

		<cfset sbGrabarAnexoDisenoZIP (Arguments.AnexoId, Arguments.ZIP)>

		<cfset sbActualizarSeguridad (Arguments.WSkey,Arguments.ACkey, true)>
	</cffunction>

	<cffunction name="sbGrabarAnexoDisenoZIP" access="private" output="no" returntype="void">
		<cfargument name="AnexoId"  type="string" 	required="yes">
		<cfargument name="ZIP" 		type="binary"  	required="yes">

		<cfset LvarDir=expandPath("/sif/an/html/" & DateFormat(now(),"YYYYMMDD") & "/AD#Arguments.AnexoId#")>
		<cfif DirectoryExists(LvarDir)>
			<cfdirectory action="delete" directory="#LvarDir#" recurse="yes">
		</cfif>

		<cfquery datasource="#session.dsn#" name="existe">
			select 1
			  from Anexoim
			 where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AnexoId#">
		</cfquery>

		<cfif existe.RecordCount>
			<cfquery datasource="#session.DSN#">
				update Anexoim
				   set AnexoZIP = <cfqueryparam cfsqltype="cf_sql_blob" 		value="#Arguments.ZIP#">
				 where AnexoId 	= <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.AnexoId#">
			</cfquery>
		<cfelse>
			<cfquery datasource="#Session.DSN#">
				insert into Anexoim (Ecodigo, AnexoId, AnexoZIP, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" 		value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.AnexoId#">,
					<cfqueryparam cfsqltype="cf_sql_blob" 			value="#Arguments.ZIP#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#session.Usucodigo#">
				)
			</cfquery>
		</cfif>

		<cfreturn>
	</cffunction>
	
<!---
	PROCESOS DURANTE LA ACTUALIZACION DEL ANEXO CALCULADO:
		En SIF --> Anexos --> Cálculo --> <Calcular>: (sólo 1 anexo)
		o bien
		En SIF --> Anexos --> Cálculo --> <Actualizar Anexos Calculados con SOINanexos>: (todos los anexos con Calculo Finalizado pero sin Anexo Calculado Excel)
			Se inicializa la Seguridad:
				Se crea una Llave de Seguridad para identificar el permiso:
					WSkey=UPL#GetTickCount()# 
				Se crea la estructura para almacenar el permiso:
					application.anexos.#WSkey#
					application.anexos.#WSkey#.timestamp = GetTickCount()
					application.anexos.#WSkey#.etapa 	 = "INICIO"
					application.anexos.#WSkey#.session	 = session.[lo que se ocupa de session]
			Se crea una hoja Excel de Operacion (WS_XLOP) en formato XML con la siguiente estructura
						COLUMNA 1:			COLUMNA 2:			COLUMNA 3:				COLUMNA 4:
				FILA 1:	SoinXLOP,			URL WebService
				FILA 2:	Operacion UPLOAD,	WSkey de Seguridad
				POR CADA ANEXO CALCULADO A REFRESCAR:
				FILA i:	AnexoId a Cargar, 	Consecutivo=i,		GrabarDiseño (1 o 0),	Descripcion Anexo
			Se hace un download de la hoja Excel
		En Excel --> SOINanexos.XLA --> Al abrir cualquier Hoja y se determina que es WS_XLOP:
			Se abre la hoja de Operaciones WS_XLOP
			Por cada Anexo Calcular a Refrescar:
				Leer el Diseño del Anexo:
					Si hay que GrabarDiseño (en caso de Anexos Viejos):
						Ejecuta el metodo WebService: LeerAnexoDisenoXML_EnCalculo
							Coldfusion lee el XML de la base de datos y la envia a Excel
						Excel recibe un String con el XML y crea el archivo XML
						Abre el archivo XML como el Anexo de Diseño
						Genera el Anexo Diseñado en formato XLS
						Genera el Anexo Diseñado en formato HTML
						Obtiene un Arreglo Binario con el Archivo XLS
						Obtiene un Arreglo Binario con el Archivo ZIP resultado de comprimir el formato HTML
						Ejecuta el metodo WebService: GrabarAnexoDisenoXLS
							Coldfusion recibe un Dato Binario con el XLS
							Si la imagen ya existe en Anexoim:
								Guarda el XML y XLS anterior en AnexoVersion
								Actualiza el XML = null y XLS = dato Binario recibido en Anexoim
							si no existe la imagen en Anexoim:
								Inserta  el XML = null y XLS = dato Binario recibido en Anexoim
						Ejecuta el metodo WebService: GrabarAnexoDisenoZIP
							Coldfusion recibe un Dato Binario con el XLS
							Borra la imagen HTML del día:
								Borra directorio /sif/an/html/YYYYMMDD/AD#AnexoId#
							Actualiza el ZIP = dato Binario recibido en Anexoim
					Si no hay que GrabarDiseño (en caso de que existe el XLS de diseño):
						Ejecuta el metodo WebService: LeerAnexoDisenoXLS_EnCalculo
							Coldfusion lee el XLS de la base de datos y la envia a Excel
						Excel recibe un Dato Binario con el XLS y crea el archivo XLS
						Abre el archivo XLS como el Anexo de Diseño
				Actualiza el Diseño del Anexo con los valores Calculados:
					Ejecuta el metodo WebService: LeerCalculos
						Coldfusion lee los valores calculados y los almacena en un arreglo que los envia a Excel.
							Hoja,Rango,Valor
							EOF
						Se actualiza el tiempo de espera para el calculo en 2 minutos
					Excel recibe el arreglo
					Por cada elemento en el arreglo hasta Encontra EOF:
						Actualiza la celda AnexoDiseño(Hoja!Rango) = Valor
						Si hay que esconderFilas, esconde Filas
						Si hay que esconderColumnas, esconde Columnas
					TIEMPO DE PRUEBA con 2,200 rangos: 
						Sólo refrescar Anexo:		2 segundos
						Escondiendo Filas y Cols:	25 segundos
				Envia el Anexo Calculado								
					Genera el Anexo Calculado en formato XLS
					Genera el Anexo Calculado en formato HTML
					Obtiene un Arreglo Binario con el Archivo XLS
					Obtiene un Arreglo Binario con el Archivo ZIP resultado de comprimir el formato HTML
					Ejecuta el metodo WebService: GrabarAnexoCalculoXLS
						Coldfusion recibe un Dato Binario con el XLS
						Actualiza el XML = null y XLS = dato Binario recibido en AnexoCalculo
					Ejecuta el metodo WebService: GrabarAnexoDisenoZIP
						Coldfusion recibe un Dato Binario con el XLS
						Borra la imagen HTML del día:
							Borra directorio /sif/an/html/YYYYMMDD/AC#AnexoId#
						Actualiza el ZIP = dato Binario recibido en AnexoCalculo

	RESUMEN OPERACIONES								TIEMPO		Espera	TIEMPO
													ANTES WS	WS		DESPUES WS
	Anexos:	Download XLOP							0
	Si GrabarDiseño (Viejo)
	  WS:		LeerAnexoDisenoXML_EnCalculo 		0			(0)		x
	  Excel:	GeneraAnexoDiseño XLS y HTML/ZIP	2
	  WS:		GrabarAnexoDisenoXLS_EnCalculo		x			(2x+2-1)	0
	  WS:		GrabarAnexoDisenoZIP_EnCalculo		x			(x-1)	0
	sino
	  WS:		LeerAnexoDisenoXLS_EnCalculo 		0			(1-1)	10
	fin
	
	WS:		LeerCalculos 							0			(x-1 ó 0) 1	
	Excel:	Actualiza Anexo en Excel				1
	Excel:	EsconderFila y Columna					2
	Excel:	Genera el Anexo Calculo XLS y HTML/ZIP	2
	WS:		GrabarAnexoCalculoXLS 					x			(x+6-1)	0
	WS:		GrabarAnexoCalculoZIP 					x			(x-1)	0
--->
	<cffunction name="LeerAnexoDisenoXML_EnCalculo" access="remote" output="no" returntype="string">
		<cfargument name="WSkey" type="string"  required="yes">
		<cfargument name="ACkey" type="string"  required="yes">		
		<cfargument name="ACid"  type="string" required="yes">
		
		<cfset LvarTiempoEspera = 0>
		<cfset sbVerificarSeguridad (Arguments.WSkey, Arguments.ACkey, Arguments.ACid, LvarTiempoEspera)>
		
		<cfquery name="rsXML" datasource="#session.DSN#">
			select AnexoDef 
			  from AnexoCalculo ac
			  	inner join Anexoim ad
					on ad.AnexoId = ac.AnexoId
			  where ac.ACid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.ACid#">
		</cfquery>
		
		<cfset sbActualizarSeguridad (Arguments.WSkey, Arguments.ACkey, false)>
		<cfreturn rsXML.AnexoDef>
	</cffunction>
	
	<cffunction name="GrabarAnexoDisenoXLS_EnCalculo" access="remote" output="no" returntype="void">
		<cfargument name="WSkey" 	type="string"  	required="yes">
		<cfargument name="ACkey" 	type="string"  	required="yes">
		<cfargument name="ACid"  	type="string" 	required="yes">
		<cfargument name="XLS" 		type="binary"  	required="yes">		
		
		<cfset sbVerificarSeguridad (Arguments.WSkey, Arguments.ACkey, Arguments.ACid)>
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select AnexoId 
			  from AnexoCalculo
			 where ACid 	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.ACid#">
		</cfquery>

		<cfset sbGrabarAnexoDisenoXLS (rsSQL.AnexoId, Arguments.XLS)>

		<cfset sbActualizarSeguridad (Arguments.WSkey, Arguments.ACkey, false)>
	</cffunction>
	
	<cffunction name="GrabarAnexoDisenoZIP_EnCalculo" access="remote" output="no" returntype="void">
		<cfargument name="WSkey" 	type="string"  	required="yes">
		<cfargument name="ACkey" 	type="string"  	required="yes">
		<cfargument name="ACid"  	type="string" 	required="yes">
		<cfargument name="ZIP" 		type="binary"  	required="yes">		
		
		<cfset sbVerificarSeguridad (Arguments.WSkey, Arguments.ACkey, Arguments.ACid)>

		<cfquery name="rsSQL" datasource="#session.DSN#">
			select AnexoId 
			  from AnexoCalculo
			 where ACid 	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.ACid#">
		</cfquery>

		<cfset sbGrabarAnexoDisenoZIP (rsSQL.AnexoId, Arguments.ZIP)>

		<cfset sbActualizarSeguridad (Arguments.WSkey, Arguments.ACkey, false)>
	</cffunction>
	
	<cffunction name="LeerAnexoDisenoXLS_EnCalculo" access="remote" output="no" returntype="binary">
		<cfargument name="WSkey" type="string"  required="yes">
		<cfargument name="ACkey" type="string"  required="yes">		
		<cfargument name="ACid"  type="string" required="yes">
		
		<cfset LvarTiempoEspera = 0>
		<cfset sbVerificarSeguridad (Arguments.WSkey, Arguments.ACkey, Arguments.ACid, LvarTiempoEspera)>
		
		<cfquery name="rsXLS" datasource="#session.DSN#">
			select AnexoXLS 
			  from AnexoCalculo ac
			  	inner join Anexoim ad
					on ad.AnexoId = ac.AnexoId
			  where ac.ACid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.ACid#">
		</cfquery>
	
		<cfset sbActualizarSeguridad (Arguments.WSkey, Arguments.ACkey, false)>
		<cfreturn rsXLS.AnexoXLS>
	</cffunction>

	<cffunction name="LeerCalculos" access="remote" output="no" returntype="array">
		<cfargument name="WSkey" type="string"  required="yes">
		<cfargument name="ACkey" type="string"  required="yes">		
		<cfargument name="ACid"  type="string" required="yes">
		
		<cfset sbVerificarSeguridad (Arguments.WSkey, Arguments.ACkey, Arguments.ACid)>
		
		<cfset LvarCalculos = arrayNew(1)>
		<cfquery name="rsCalculos" datasource="#session.DSN#">
			select c.AnexoHoja, c.AnexoRan, c.AnexoCon, r.ACvalor 
			  from AnexoCalculoRango r
			  	inner join AnexoCel c
					on c.AnexoCelId = r.AnexoCelId
			 where r.ACid 	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.ACid#">
			   and c.AnexoFila		> 0
			   and c.AnexoColumna	> 0
		</cfquery>

		<cfset LvarRow = 1>
		<cfloop query="rsCalculos">
			<cfset LvarCalculos[LvarRow] = "#trim(rsCalculos.AnexoHoja)#,#trim(rsCalculos.AnexoRan)#,#trim(rsCalculos.ACvalor)#">
			<cfset LvarRow = LvarRow + 1>
		</cfloop>
		<cfset LvarCalculos[LvarRow] = "EOF">
		
		<cfset sbActualizarSeguridad (Arguments.WSkey, Arguments.ACkey, false)>
		<cfreturn LvarCalculos>
	</cffunction>

	<cffunction name="LeerCalculosQuery" access="remote" output="no" returntype="query">
		<cfargument name="WSkey" type="string"  required="yes">
		<cfargument name="ACkey" type="string"  required="yes">		
		<cfargument name="ACid"  type="string" required="yes">
		
		<cfset sbVerificarSeguridad (Arguments.WSkey, Arguments.ACkey, Arguments.ACid)>
		
		<cfquery name="rsCalculos" datasource="#session.DSN#">
			select c.AnexoHoja, c.AnexoRan, c.AnexoCon, r.ACvalor 
			  from AnexoCalculoRango r
			  	inner join AnexoCel c
					on c.AnexoCelId = r.AnexoCelId
			 where r.ACid 	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.ACid#">
			   and c.AnexoFila		> 0
			   and c.AnexoColumna	> 0
		</cfquery>

		<cfset sbActualizarSeguridad (Arguments.WSkey, Arguments.ACkey, false)>
		<cfreturn rsCalculos>
	</cffunction>

	<cffunction name="GrabarAnexoCalculoXLS" access="remote" output="no" returntype="void">
		<cfargument name="WSkey" 	type="string"  	required="yes">
		<cfargument name="ACkey" 	type="string"  	required="yes">
		<cfargument name="ACid"  	type="string" 	required="yes">
		<cfargument name="XLS" 		type="binary"  	required="yes">		
		
		<cfset sbVerificarSeguridad (Arguments.WSkey, Arguments.ACkey, Arguments.ACid)>
		
		<cfquery datasource="#session.DSN#">
			update AnexoCalculo
			   set ACxls = <cfqueryparam cfsqltype="cf_sql_blob" 		value="#Arguments.XLS#">
				 , ACstatus = 'T'
			 where ACid  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.ACid#">
		</cfquery>
		
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select ACdistribucion, AnexoId
			  from AnexoCalculo
			 where ACid  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.ACid#">
		</cfquery>
		
		<cfif rsSQL.ACdistribucion EQ "S">
			<cfhttp 
				url			 = "http://#cgi.HTTP_HOST#/cfmx/sif/an/WS/distribuir.cfm?ACid=#Arguments.ACid#&AnexoId=#rsSQL.AnexoId#&DSN=#URLEncodedFormat(session.DSN)#"
				method		 = "get"
				timeout		 = "1"
				throwonerror = "no"
			/>
		</cfif>
		
		<cfset sbActualizarSeguridad (Arguments.WSkey, Arguments.ACkey, false)>
		<cfreturn>
	</cffunction>

	<cffunction name="GrabarAnexoCalculoZIP" access="remote" output="no" returntype="void">
		<cfargument name="WSkey" 	type="string"  	required="yes">
		<cfargument name="ACkey" 	type="string"  	required="yes">
		<cfargument name="ACid"  	type="string" 	required="yes">
		<cfargument name="ZIP" 		type="binary"  	required="yes">		
		
		<cfset sbVerificarSeguridad (Arguments.WSkey, Arguments.ACkey, Arguments.ACid)>
		
		<cfset LvarDir=expandPath("/sif/an/html/" & DateFormat(now(),"YYYYMMDD") & "/AC#Arguments.ACid#")>
		<cfif DirectoryExists(LvarDir)>
			<cfdirectory action="delete" directory="#LvarDir#" recurse="yes">
		</cfif>

		<cfquery name="rsXML" datasource="#session.DSN#">
			update AnexoCalculo
			   set ACzip = <cfqueryparam cfsqltype="cf_sql_blob" 		value="#Arguments.ZIP#">
			 where ACid  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.ACid#">
		</cfquery>
		
		<cfset sbActualizarSeguridad (Arguments.WSkey,Arguments.ACkey, true)>
		<cfreturn>
	</cffunction>

<!---
	PROCESOS DE SEGURIDAD
--->
	<cffunction name="fnInicializarSeguridad" access="public" output="no" returntype="string">
		<cfargument name="XLOP" type="string"  required="yes">

		<cfset var LvarWSkey = "">
		
		<cflock scope="application" throwontimeout="no" timeout="5">
			<cfset LvarWSkey = "#mid(Arguments.XLOP,1,3)##GetTickCount()#">
		</cflock>
		
		<!--- CREA LA ESTRUCTURA DE SEGURIDAD --->
		<cfset Application.Anexos[LvarWSkey] = structnew()>
		
		<!--- INICIALIZA LOS TIEMPOS DE CONTROL --->
		<cfset Application.Anexos[LvarWSkey].Inicio = GetTickCount()>
		
		<!--- GUARDA LA SESSION ACTUAL EN LA WSkey INDICADA --->
		<cfset Application.Anexos[LvarWSkey].session = structnew()>

		<cfset Application.Anexos[LvarWSkey].session.CEcodigo 		= session.CEcodigo>
		<cfset Application.Anexos[LvarWSkey].session.Ecodigo 		= session.Ecodigo>
		<cfset Application.Anexos[LvarWSkey].session.EcodigoSDC		= session.EcodigoSDC>
		<cfset Application.Anexos[LvarWSkey].session.EcodigoCorp 	= session.EcodigoCorp>
		<cfset Application.Anexos[LvarWSkey].session.DSN			= session.DSN>
		<cfset Application.Anexos[LvarWSkey].session.Usucodigo 		= session.Usucodigo>
		<cfset Application.Anexos[LvarWSkey].session.Usulogin 		= session.Usulogin>
		<cfset Application.Anexos[LvarWSkey].session.dsinfo			= session.dsinfo>
		
		<cfreturn LvarWSkey>
	</cffunction>

	<cffunction name="sbVerificarSeguridad" access="private" output="no" returntype="void">
		<cfargument name="WSkey" 	type="string" 	required="yes">
		<cfargument name="ACkey" 	type="string" 	required="yes">
		<cfargument name="ACid"  	type="string"	required="yes">
		<cfargument name="Maximo" 	type="numeric"	required="no" default="-1">

		<cfapplication name="SIF_ASP" 
			sessionmanagement="Yes"
			clientmanagement="No"
			setclientcookies="Yes"
			sessiontimeout=#CreateTimeSpan(0,10,0,0)#
		>

		<cfsetting requesttimeout="1800">		

		<!--- LIMPIA LA COLA DE AUTORIZACIONES PENDIENTES CADA HORA --->
		<cfif not isdefined("application.anexos.clear")>
			<cfset application.anexos.clear = "#GetTickCount()#">
		</cfif>
		<cfset LvarIni = application.anexos.clear>
		<cfset LvarFin = GetTickCount()>
		<cfset LvarSeg = (LvarFin - LvarIni) / 1000>
		<cfset LvarMin = int(LvarSeg / 60)>
		<cfif LvarMin GT 60>
			<cfset application.anexos.clear = "#GetTickCount()#">
			<cfloop item="LvarWSkey" collection="#application.anexos#">
				<cfif isnumeric(mid(LvarWSkey,4,100))>
					<cfparam name="Application.Anexos.#LvarWSkey#.Inicio" default="0">
					<cfset LvarIni = Application.Anexos[LvarWSkey].Inicio>
					<cfif isnumeric(LvarIni)>
						<cfset LvarSeg = (LvarFin - LvarIni) / 1000>
						<cfset LvarMin = int(LvarSeg / 60)>
						<cfif LvarMin GT 60>
							<cfset structDelete(application.anexos, LvarWSkey)>
						</cfif>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>

		
		<cfif not isdefined("session.anexos.#WSkey#") OR not isdefined("session.anexos.#WSkey#.OK")>
			<!--- VERIFICA SI EXISTE LA AUTORIZACION --->
			<cfif not isdefined("application.anexos.#WSkey#")>
				<cf_errorCode	code = "50841" msg = "No tiene autorización para comunicarse con el Servidor">
			<cfelseif not isdefined("application.anexos.#WSkey#.version")>
				<cfset Version(WSkey, "1.00")>
			</cfif>
	
			<cfset session.anexos = structNew()>
			<cfset session.anexos[WSkey] = application.anexos[WSkey]>
			
			<!--- VERIFICA SI EXPIRO LA AUTORIZACION --->
			<cfif Arguments.Maximo GTE 0>
				<cfset LvarIni = session.anexos[WSkey].Inicio>
				<cfset LvarFin = GetTickCount()>
				<cfset LvarSeg = (LvarFin - LvarIni) / 1000>
				<cfset LvarMinEx = int(LvarSeg / 60)>
				<cfset LvarExpiro = LvarMinEx GT Arguments.Maximo>
		
				<cfif LvarExpiro>
					<cf_errorCode	code = "50842"
									msg  = "Expiró la autorización para comunicarse con el Servidor (@errorDat_1@ minutos)"
									errorDat_1="#LvarMinEx#"
					>
				</cfif>
			</cfif>
			
			<!--- CARGA LA SESSION DE LA WSkey INDICADA --->
			<cfset session.CEcodigo 	= Application.Anexos[WSkey].session.CEcodigo>
			<cfset session.Ecodigo		= Application.Anexos[WSkey].session.Ecodigo>
			<cfset session.EcodigoSDC	= Application.Anexos[WSkey].session.EcodigoSDC>
			<cfset session.EcodigoCorp	= Application.Anexos[WSkey].session.EcodigoCorp>
			<cfset session.DSN			= Application.Anexos[WSkey].session.DSN>
			<cfset session.Usucodigo	= Application.Anexos[WSkey].session.Usucodigo>
			<cfset session.Usulogin		= Application.Anexos[WSkey].session.Usulogin>
			<cfset session.dsinfo		= Application.Anexos[WSkey].session.dsinfo>

			<cfset session.anexos[WSkey].OK	= true>
			
			<cfset structDelete(Application.Anexos, WSkey)>
		</cfif>

		<!--- VERIFICA EL CONSECUTIVO DE OPERACIONES --->
		<cfset LvarPermiso = isdefined("session.anexos.#WSkey#") AND isdefined("session.anexos.#WSkey#.IDS")>
		<cfif LvarPermiso>
			<cfset LvarIDS_N = arrayLen(session.anexos[WSkey].IDS)>
			<cfset LvarPermiso = ACkey LTE LvarIDS_N>
			<cfif LvarPermiso>
				<cfset LvarPermiso = session.anexos[WSkey].IDS[ACkey] EQ ACid>
			</cfif>
		</cfif>
		<cfif NOT LvarPermiso>
			<cfset structDelete(session.anexos, WSkey)>
			<cf_errorCode	code = "50843" msg = "No tiene autorización para utilizar el anexo indicado">
		</cfif>
	</cffunction>

	<cffunction name="sbActualizarSeguridad" access="private" output="no" returntype="void">
		<cfargument name="WSkey" 		type="string"  required="yes">
		<cfargument name="ACkey" 		type="string"  required="yes">
		<cfargument name="finProceso"  	type="string"  required="yes">
		
		<cfif Arguments.finProceso>
			<!--- SI ES EL FINAL DE PROCESO DE UN CONSECUTIVO  --->
			<cfif Arguments.ACkey EQ arrayLen(session.anexos[WSkey].IDS)>
				<!--- SI ES EL ULTIMO CONSECUTIVO: ELIMINA LA WSkey --->
				<cfset structDelete(session.anexos, WSkey)>
			<cfelse>
				<!--- SI HAY QUE PROCESAR MAS CONSECUTIVOS --->
				<!--- ELIMINA LA ACkey PARA QUE NO PUEDA REPROCESARSE EL CONSECUTIVO --->
				<cfset session.anexos[WSkey].IDS[ACkey] = 0>
				<!--- SE INICIALIZA EL TIEMPO PARA PROCESAR EL PROXIMO CONSECUTIVO --->
				<cfset session.anexos[WSkey].Inicio 	= GetTickCount()>
			</cfif>
		<cfelse>
			<!--- SI CONTINUA EL PROCESO DE UN CONSECUTIVO  --->
			<!--- SE INICIALIZA EL TIEMPO PARA SEGUIR PROCESANDO EL MISMO CONSECUTIVO --->
			<cfset session.anexos[WSkey].Inicio = GetTickCount()>
		</cfif>
	</cffunction>

	<cffunction name="sbThrow" access="private" output="no">
		<cfargument name="objCatch" type="any">
		<cfargument name="log" type="boolean" default="no">
		
		<cfset var LvarMSG = objCatch.Message & " " & objCatch.Detail>
		<cfif objCatch.type EQ "Application">
			<cfthrow message="#LvarMSG#">
		</cfif>
		<cfset LvarPagina = ReplaceNoCase(Replace(objCatch.TagContext[1].Template, "\", "/", 'all'), Replace(ExpandPath(""), "\", "/",'all'), "")>
		<cfset LvarMSG = LvarMSG & " at: " & LvarPagina & ":" & objCatch.TagContext[1].Line>
		<cfset LvarTagContextI = objCatch.TagContext[1]>
		<cfif isdefined('LvarTagContextI.ID')>
			<cfset LvarMSG = LvarMSG  & " (" & objCatch.TagContext[1].ID & ")">
		</cfif>

		<cfset LvarMSG = trim(rereplace(replaceNocase(LvarMSG,"<BR>"," "), "\s{1,}", " ", "ALL"))>

		<cfset LvarSQL = "">
		<cfif isdefined("objCatch.SQL")>
			<cfset LvarSQL = " SQL: " & trim(rereplace(objCatch.SQL, "\s{1,}", " ", "ALL"))>
			<cfset LvarSQL = trim(rereplace(LvarSQL, "\s{1,}", " ", "ALL"))>
		</cfif>
		<cfif Arguments.log OR LvarSQL NEQ "">
			<cflog file="anexosWS" text="#LvarMSG# #LvarSQL#">
		</cfif>
		<cfset LvarMSG = replace(LvarMSG,"[","(","ALL")>
		<cfset LvarMSG = replace(LvarMSG,"]",")","ALL")>
		<cfset LvarMSG = replace(LvarMSG," at: ","\n#chr(9)#at ")>
		<cfthrow message="#LvarMSG#">
	</cffunction>
</cfcomponent>





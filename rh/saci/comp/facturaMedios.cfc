<cfcomponent>
<!--- crearFactura --->
<cffunction name="crearFactura" access="public" returntype="string" output="false" hint="crea una ISBfacturaMedios, y regresa el LFlote">
  <cfargument name="dsn" type="string" required="yes">

  <cfset var LFnumero = DateFormat(Now(), 'YYYYMMDD')>
  <cfset var LFlote = 0>
  <cfset var listaLotes = ''>
  <cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="302" returnvariable="horaCorte"/>
  
  <cfset horaCorte = CreateDateTime(Year(Now()), Month(Now()), Day(Now()),
  	ListFirst(horaCorte,':'), ListRest(horaCorte, ':'), 0)>
  <cfif horaCorte GT Now()>
  	<cfset horaCorte = DateAdd('d', -1, horaCorte)>
  </cfif>

  <cfquery datasource="#Arguments.dsn#" name="emids">
  	select EMid, count(1) as cant
	from ISBeventoMedio em
	where EVestado = 'N'
	  and EVtasacion < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#horaCorte#">
	group by EMid
  </cfquery>
  <cfloop query="emids">
    <cfset LFlote = This.insertarFactura (Arguments.dsn, emids.EMid, LFnumero)>
    <cfset This.llenarFactura(Arguments.dsn, emids.EMid, LFlote, horaCorte)>
	<cfset listaLotes = ListAppend(listaLotes, LFlote)>
  </cfloop>
  <cfreturn listaLotes>
</cffunction>
<!--- insertarFactura --->
<cffunction name="insertarFactura" access="public" returntype="numeric" output="false" hint="crea una ISBfacturaMedios, y regresa el LFlote">
  <cfargument name="dsn" type="string" required="yes">
  <cfargument name="EMid" type="numeric" required="yes">
  <cfargument name="LFnumero" type="string" required="yes">
  <cfquery datasource="#Arguments.dsn#" name="buscarISBfacturaMedios">
  	select LFlote
	from ISBfacturaMedios
	where EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">
	  and LFnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LFnumero#">
  </cfquery>
  <cfif Len(buscarISBfacturaMedios.LFlote)>
    <cfreturn buscarISBfacturaMedios.LFlote>
  </cfif>
  <cfquery datasource="#Arguments.dsn#" name="newISBfacturaMedios">
		insert into ISBfacturaMedios (
			EMid, LFnumero, BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LFnumero#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
		<cf_dbidentity1 datasource="#Arguments.dsn#" name="newISBfacturaMedios" verificar_transaccion="false">
	</cfquery>
  <cf_dbidentity2 datasource="#Arguments.dsn#" name="newISBfacturaMedios" verificar_transaccion="false">
  <cfreturn newISBfacturaMedios.identity>
</cffunction>
<!---
	llenarFactura
	Tasar las llamadas y llenar las facturas.
	Las llamadas se tasan tomando en cuenta el modelo tarifario, excepto por la tarifa base,
	ya que este componente genera facturas diarias y no mensuales.
 --->
<cffunction name="llenarFactura" output="false">
  <cfargument name="dsn" type="string" required="yes">
  <cfargument name="EMid" type="numeric" required="yes">
  <cfargument name="LFlote" type="numeric" required="yes">
  <cfargument name="corte" type="date" required="yes">

  <cfquery datasource="#arguments.dsn#">
  	exec isb_factura900
		@EMid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">,
		@LFlote =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LFlote#">,
		@corte = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.corte#">
  </cfquery>
</cffunction>
<!--- enviarFactura --->
<cffunction name="enviarFactura" output="false">
	<cfargument name="dsn" type="string" required="yes">
	<cfargument name="LFlote" type="numeric" required="yes">
	
	<cfquery datasource="#Arguments.dsn#" name="ISBfacturaMedios">
		select LFnumero, EMid
		from ISBfacturaMedios
		where LFlote = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LFlote#">
	</cfquery>
	
	<cfquery datasource="#Arguments.dsn#" name="ISBmedioCia">
		select EMnombre, EMcorreoEnvioFacturas
		from ISBmedioCia
		where EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBfacturaMedios.EMid#">
	</cfquery>
	
	<cfset nombreAttachment = 'DTETRA900' & (ISBfacturaMedios.LFnumero) & '.txt'>
	
	<cfset contenidoAttachment = This.generarArchivoTrafico(dsn, LFlote, true)>
	
	<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="301" returnvariable="emailFrom"/>

	<cfset emailTo = ISBmedioCia.EMcorreoEnvioFacturas>
	<cfset emailSubject = 'Facturación ' & ISBmedioCia.EMnombre & ' No. ' & ISBfacturaMedios.LFnumero>
	<cfsavecontent variable="emailBody">
		Adjunto archivo <code><cfoutput># nombreAttachment #</cfoutput></code>
	</cfsavecontent>
	
	<cftransaction>
		<cfquery datasource="asp" name="correo">
			insert into SMTPQueue 
				(SMTPremitente, SMTPdestinatario, SMTPasunto,
				SMTPtexto, SMTPhtml)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#emailFrom#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#emailTo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#emailSubject#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#emailBody#">,
				1)
			<cf_dbidentity1 datasource="asp" name="correo">
		</cfquery>
		<cf_dbidentity2 datasource="asp" name="correo">
		<cfquery datasource="asp" name="correo">
			insert into SMTPAttachment 
				(SMTPid, SMTPnombre, SMTPmime,	SMTPcontenido)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#correo.identity#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="# nombreAttachment #">,
				'text/plain',
				<cfqueryparam cfsqltype="cf_sql_blob" value="# CharsetDecode( contenidoAttachment, 'utf-8' )#">
			)
		</cfquery>
	</cftransaction>
	<cftransaction>
		<cfquery datasource="#Arguments.dsn#" name="isbcorreo">
			insert into ISBfacturaMediosEmail 
				(LFlote, FMEinout, FMEfrom, FMEto,
				FMEsubject, FMEbody, FMErecibido, FMEestado,<!--- Nuevo/Proceso/Terminado --->
				FMEinicio, FMEfin, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LFlote#">,
				'out',
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#emailFrom#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#emailTo#">,
				
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#emailSubject#">,
				<cfqueryparam cfsqltype="cf_sql_clob" value="#emailBody#">,
				getdate(), 'N',
				
				getdate(), getdate(),
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			)
			<cf_dbidentity1 datasource="#Arguments.dsn#" name="isbcorreo">
		</cfquery>
		<cf_dbidentity2 datasource="#Arguments.dsn#" name="isbcorreo">
		<cfquery datasource="#Arguments.dsn#">
			insert into ISBfacturaMediosArchivo (<!--- no guardo el identity --->
				FMEmailid, FMEnombre, FMEtipoArchivo,
				FMEtotal, FMEprocesados, FMEerrores, FMEignorados, FMEcontent,
				FMEinicio, FMEfin, BMUsucodigo )
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#isbcorreo.identity#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#nombreAttachment#">, 'D',
				
				0, 0, 0, 0,
				<cfqueryparam cfsqltype="cf_sql_blob" value="# CharsetDecode( contenidoAttachment, 'utf-8' )#">,
				getdate(), getdate(),
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			) 
		</cfquery>
	</cftransaction>
	
</cffunction>
<!--- revisarCorreo --->
<cffunction name="revisarCorreo" output="false">
	<cfargument name="dsn" type="string" required="yes">
	
	<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="311" returnvariable="popServer"/>
	<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="312" returnvariable="popUsername"/>
	<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="313" returnvariable="popPassword"/>
	<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="314" returnvariable="borrarCorreoPOP"/>
	
	<cfset attachmentPath = GetTempDirectory()  & 'inbox' & NumberFormat(Int(Rand()*1000000), '000000')>
	<cfpop server="#popServer#" username="#popUsername#" password="#popPassword#"
		name="correo" action="getall" attachmentpath="#attachmentPath#" generateuniquefilenames="yes"/>
	<cfset ElementosBorrados = 0>
	<cftry>
	<cfloop query="correo">
		<!--- ver si el correo corresponde a una compañía de medios --->
		
		<cfquery datasource="#Arguments.dsn#" name="buscaCia">
			select EMid
			from ISBmedioCia
			where lower(EMcorreoReciboFacturas) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCase( correo.from )#">
			or <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCase( correo.from )#"> like '%<' || lower(EMcorreoReciboFacturas) || '>%'
		</cfquery>
		<cfquery datasource="#Arguments.dsn#" name="buscaUID">
			select FMEmailid
			from ISBfacturaMediosEmail
			where FMEmailUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#correo.uid#">
			  and FMEfrom = <cfqueryparam cfsqltype="cf_sql_varchar" value="#correo.from#">
		</cfquery>
		<cfif Len(buscaCia.EMid) And Not Len(buscaUID.FMEmailid)>
			<!---
				Solamente proceso y borro los correos que provengan de una compañía de medios.
				Los correos que ya hayan sido procesados, aunque no se hayan borrado del pop, no los proceso.
				Los demás correos no los proceso ni los borro del servidor de correo.
			--->
			<cftransaction>
				<cfquery datasource="#Arguments.dsn#" name="newEmail">
					insert into ISBfacturaMediosEmail
						(FMEinout, FMEfrom, FMEto, FMEsubject, 
						FMEbody, FMEmailHeaders, FMEmailUID, 
						FMEinicio, FMEestado, BMUsucodigo)
					values (
						'in',
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#correo.from#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#correo.to#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#correo.subject#">,
						<cfif Len(correo.HTMLBody)>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#correo.HTMLBody#">,
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#correo.textBody#">,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#correo.header#" null="#Len(Trim(correo.header)) EQ 0#">,
						<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#correo.uid#" null="#Len(Trim(correo.uid)) EQ 0#">,
						getdate(), 'P', <!--- en proceso --->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					)
					<cf_dbidentity1 datasource="#Arguments.dsn#" name="newEmail">
				</cfquery>
				<cf_dbidentity2 datasource="#Arguments.dsn#" name="newEmail">
			</cftransaction>
			<cfif Len(correo.attachments)>
				<cfloop from="1" to="#ListLen(correo.attachments,Chr(9))#" index="num_archivo_attachment">
					<cfset attachName = ListGetAt(correo.attachments, num_archivo_attachment, Chr(9))>
					<cfset attachPath = ListGetAt(correo.attachmentFiles, num_archivo_attachment, Chr(9))>
					<cfif FindNoCase('RAPLI', attachName)>
						<cfset attachType = 'A'>
					<cfelseif FindNoCase('RINCO', attachName)>
						<cfset attachType = 'I'>
					<cfelse>
						<cfset attachType = '-'>
					</cfif>
					<cffile action="readbinary" file="#attachPath#" variable="attachemntContents">
					<cftransaction>
						<cfquery datasource="#Arguments.dsn#" name="insertArchivo">
							insert into ISBfacturaMediosArchivo (
								FMEmailid, FMEnombre, FMEtipoArchivo,
								FMEtotal, FMEprocesados, FMEerrores,  FMEignorados, FMEcontent,
								BMUsucodigo)
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#newEmail.identity#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#attachName#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#attachType#">,
								
								0, 0, 0, 0,
								<cfqueryparam cfsqltype="cf_sql_blob" value="#attachemntContents#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							)
							<cf_dbidentity1 datasource="#Arguments.dsn#" name="insertArchivo">
						</cfquery>
						<cf_dbidentity2 datasource="#Arguments.dsn#" name="insertArchivo">
					</cftransaction>
					<cfset attachemntContents = ''>
					
					<cftry>
					
					
						<cfif LCase( Right(attachPath, 4) ) is '.zip'>
							<cfset zipFile = 0>
							<cfset zipFile = CreateObject("java", "java.util.zip.ZipFile").init(attachPath)>
							<cftry>
								<cfset zipEntries = zipFile.entries()>
								
								<cfloop condition="zipEntries.hasMoreElements()">
									<cfset zipEntry = zipEntries.nextElement()>
									<!---<cflog file="unzip" text="entry: #zipEntry#">--->
									
									<cfif FindNoCase('RAPLI', zipEntry.getName())>
										<cfset attachType = 'A'>
									<cfelseif FindNoCase('RINCO', zipEntry.getName())>
										<cfset attachType = 'I'>
									<cfelse>
										<cfset attachType = '-'>
									</cfif>
									<cfif ListFind('A,I', attachType )>
										<cftransaction>
											<cfquery datasource="#Arguments.dsn#" name="insertArchivo">
												insert into ISBfacturaMediosArchivo (
													FMEmailid, FMEnombre, FMEtipoArchivo,
													FMEtotal, FMEprocesados, FMEerrores,  FMEignorados, FMEcontent,
													BMUsucodigo)
												values (
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#newEmail.identity#">,
													<cfqueryparam cfsqltype="cf_sql_varchar" value="#attachName#:#zipEntry.getName()#">,
													<cfqueryparam cfsqltype="cf_sql_varchar" value="#attachType#">,
													
													0, 0, 0, 0,
													null,
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
												)
												<cf_dbidentity1 datasource="#Arguments.dsn#" name="insertArchivo">
											</cfquery>
											<cf_dbidentity2 datasource="#Arguments.dsn#" name="insertArchivo">
										</cftransaction>
										
										<cfset lineCount = 0>
										<cfset zipEntryInputStream = zipFile.getInputStream(zipEntry)>
										<cfset fileReader = CreateObject("java", "java.io.InputStreamReader").init(zipEntryInputStream)>
										<cftry>
											<cfset lineCount = This.contarLineas(fileReader)>
											<cfcatch type="any">
												<cfset fileReader.close()>
												<cfrethrow>
											</cfcatch>
										</cftry>
										<cfset fileReader.close()>
								
										<cfset zipEntryInputStream = zipFile.getInputStream(zipEntry)>
										<cfset fileReader = CreateObject("java", "java.io.InputStreamReader").init(zipEntryInputStream)>
										<cfset lineReader = CreateObject("java", "java.io.LineNumberReader").init(fileReader)>
										<cfset This.recibirArchivoAplicados(Arguments.dsn, newEmail.identity, insertArchivo.identity, attachType, lineReader, lineCount)>
									</cfif>
								</cfloop>
								
								<cfset zipFile.close()>
							<cfcatch type="any">
								<cfset zipFile.close()>
								<cfrethrow>
							</cfcatch>
							</cftry>
							
						<cfelse>
							<cfif ListFind('A,I', attachType )>
							
								<cfset lineCount = 0>
								<cfset fileReader = CreateObject("java", "java.io.FileReader").init(attachPath)>
								<cftry>
									<cfset lineCount = This.contarLineas(fileReader)>
									<cfcatch type="any">
										<cfset fileReader.close()>
										<cfrethrow>
									</cfcatch>
								</cftry>
								<cfset fileReader.close()>
							
								<cfset fileReader = CreateObject("java", "java.io.FileReader").init(attachPath)>
								<cfset lineReader = CreateObject("java", "java.io.LineNumberReader").init(fileReader)>
								<cfset This.recibirArchivoAplicados(Arguments.dsn, newEmail.identity, insertArchivo.identity, attachType, lineReader, lineCount)>
							</cfif>
							
						</cfif>
						<!--- finally --->
						<cfif IsDefined('lineReader')>
							<cfset lineReader.close()>
						</cfif>
						<cffile action="delete" file="#attachPath#">
						<!--- /finally --->
					<cfcatch type="any">
						<!--- finally --->
						<cfif IsDefined('lineReader')>
							<cfset lineReader.close()>
						</cfif>
						<cffile action="delete" file="#attachPath#">
						<!--- /finally --->
						<cfrethrow>
					</cfcatch>
					</cftry>
					
				</cfloop><!--- foreach attachment --->
			</cfif><!--- has attachments --->
			<cfquery datasource="#Arguments.dsn#">
				update ISBfacturaMediosEmail
				set FMEestado = 'T' <!--- Terminado --->
				, FMEfin = getdate()
				where FMEmailid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#newEmail.identity#">
			</cfquery>
			<cfif borrarCorreoPOP EQ '1'>
				<cfpop server="#popServer#" username="#popUsername#" password="#popPassword#" name="correo" action="delete" 
					messagenumber="#correo.MessageNumber-ElementosBorrados#"/>
				<cfset ElementosBorrados = ElementosBorrados + 1>
			</cfif>
		</cfif><!--- Len(buscaCia.EMid) --->
	</cfloop><!--- mensajes --->
	<cfcatch type="any">
		<!--- finally --->
		<cfif DirectoryExists(attachmentPath)>
			<cfdirectory action="delete" recurse="yes" directory="#attachmentPath#">
		</cfif>
		<!--- /finally --->
		<cfrethrow>
	</cfcatch>
	</cftry>
	<!--- finally --->
	<cfif DirectoryExists(attachmentPath)>
		<cfdirectory action="delete" recurse="yes" directory="#attachmentPath#">
	</cfif>
	<!--- /finally --->
</cffunction>

<cffunction name="recibirArchivoAplicados" output="false">

	<!--- un archivo de prueba se puede generar con 
	Aplicados:		
		select replicate('x',50)||convert(varchar,log_id)||'..'
		from ISBeventoMedio
	Inconsistencias:	
		select replicate('x',76)||convert(varchar,log_id)'
		from ISBeventoMedio
	Liquidaciones:
		select replicate('x',54)||substring('GRA',log_id % 3+1,1)||replicate('*',9)||convert(varchar,log_id)
		from ISBeventoMedio
		--->

	<cfargument name="dsn" type="string" required="yes">
	<cfargument name="FMEmailid" type="numeric">
	<cfargument name="FMEarchivo" type="numeric">
	<cfargument name="EVestado" type="string">
	<cfargument name="lineReader" type="any">
	<cfargument name="lineCount" type="numeric">
	
	<cfset var lineNumber = 0>
	<cfset var errorCount = 0>
	<cfset var linea = ''>
	<cfset var LFobs = ''>
	
	<cfif Arguments.EVestado is 'A'>
		<cfset largoEsperado = 60>
		<cfset posicionLinea = 51>
	<cfelseif Arguments.EVestado is 'I'>
		<cfset largoEsperado = 86>
		<cfset posicionLinea = 77>
	<cfelseif Arguments.EVestado is 'L'>
		<cfset largoEsperado = 74>
		<cfset posicionLinea = 65>
		<cfset posicionEstado = 55><!--- solo en liquidaciones --->
	<cfelse>
		<cfthrow message="EVestado invalido: #Arguments.EVestado#">
	</cfif>
	
	<cfquery datasource="#Arguments.dsn#">
		update ISBfacturaMediosArchivo
		set FMEinicio = getdate(),
			FMEtimestamp = getdate(),
			FMEtotal = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.lineCount#">
		where FMEarchivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FMEarchivo#">
	</cfquery>
	<cfset myEVestado = Arguments.EVestado>
	<cfset lineNumber = 0>
	<cfloop condition="1"><cfsilent><!--- intento de reducir la memoria usada --->
		<cfset linea = lineReader.readLine()>
		<cfif Not IsDefined('linea')>
			<!--- fin de archivo cuando readLine regresa nulo --->
			<cfbreak>
		</cfif>
		<cfset lineNumber = lineNumber + 1>
		<cfset error_message = ''>
		<cfif lineNumber Is 1 And linea.startsWith('HDR')>
			<!--- si viene un header, ignorarlo --->
		<cfelseif linea.startsWith('TRL')>
			<!--- si viene un trailer, ignorarlo --->
		<cfelseif Len(linea) Neq largoEsperado>
			<cfset error_message = 'Longitud incorrecta #Len(linea)# (debió ser #largoEsperado#).'>
		<cfelse>
			<cftry>
				<cfset log_id = Mid(linea, posicionLinea, 10)>
				<cfif Arguments.EVestado EQ 'I'>
					<!--- inconsistencias, leer mensaje --->
					<cfset LFobs = Trim(Mid(linea, 52, 25))>
				<cfelseif Arguments.EVestado EQ 'L'>
					<!--- Liquidaciones, leer estado del archivo: viene G/R/A, guardo G/L/M --->
					<cfset estado_archivo = Mid(linea, posicionEstado, 1)>
					<cfset telefono = Mid(linea,1, 7)>
					<cfif Not ListFind('G,R,A', estado_archivo)>
						<cfset error_message = 'Estado inválido ' & estado_archivo>
					<cfelse>
						<cfset myEVestado = ListGetAt('G,L,M', ListFind('G,R,A', estado_archivo))>
					</cfif>
				</cfif>
				<cfif Not ReFind('^[ ]*[0-9]+$', log_id)>
					<cfset error_message='Log_id inválido #log_id#'>
				<cfelse>
					<cfset This.setEstadoLlamada(Arguments.dsn, log_id, myEVestado, LFobs, Arguments.FMEmailid, Arguments.FMEarchivo)>
					<cfif myEVestado eq 'M'>
						<cfset This.setBloqueo(Arguments.dsn,telefono)>
					</cfif>
				</cfif>
			<cfcatch type="any">
				<cfset error_message = cfcatch.Message & ' ' & cfcatch.Detail>
			</cfcatch>
			</cftry>
		</cfif>
		<cfif Len(error_message)>
			<cfset errorCount = errorCount + 1>
			<cfquery datasource="#Arguments.dsn#">
				update ISBfacturaMediosArchivo
				set FMEerrores = FMEerrores + 1
				,	FMEtimestamp = getdate()
				<cfif errorCount LE 10>
				,	FMEobs = convert(varchar(16384), FMEobs) || <cfqueryparam cfsqltype="cf_sql_varchar" value="Línea #lineNumber#: #error_message##Chr(13)##Chr(10)#">
				</cfif>
				where FMEarchivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FMEarchivo#">
			</cfquery>
		</cfif>
	</cfsilent><!--- a ver si no consume tanta memoria ---></cfloop>
	<cfquery datasource="#Arguments.dsn#">
		update ISBfacturaMediosArchivo
		set FMEfin = getdate()
		,	FMEtimestamp = getdate()
		where FMEarchivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FMEarchivo#">
	</cfquery>
</cffunction>

<!--- recibirLiquidaciones --->
<cffunction name="recibirLiquidaciones" output="false" returntype="void">
	<cfargument name="dsn" type="string" required="yes">
	<cfargument name="rutaArchivo" type="string" required="yes" hint="Nombre del archivo por subir">
	<cfargument name="nombreOriginal" type="string" required="yes" hint="Nombre original del archivo por subir">
	

	<!--- contar las lineas del archivo --->
	<cfset var lineCount = 0>
	<cfset var fileReader = CreateObject('java', 'java.io.FileReader').init(Arguments.rutaArchivo)>
	<cftry>
		<cfset lineCount = This.contarLineas(fileReader)>
		<cfcatch type="any">
			<cfset fileReader.close()>
			<cfrethrow>
		</cfcatch>
	</cftry>
	<cfset fileReader.close()>
	<cftransaction>
		<cfquery datasource="#Arguments.dsn#" name="insertArchivo">
			insert into ISBfacturaMediosArchivo (
				FMEnombre, FMEtipoArchivo, FMEinicio, FMEtotal,
				FMEprocesados, FMEerrores,  FMEignorados, FMEcontent,
				BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.nombreOriginal#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="L">, getdate(),
				
				0, 0, 0, 0, null,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			)
			<cf_dbidentity1 datasource="#Arguments.dsn#" name="insertArchivo">
		</cfquery>
		<cf_dbidentity2 datasource="#Arguments.dsn#" name="insertArchivo">
	</cftransaction>
	
	<cfset fileReader = CreateObject("java", "java.io.FileReader").init(Arguments.rutaArchivo)>
	<cfset lineReader = CreateObject("java", "java.io.LineNumberReader").init(fileReader)>
	
	<cftry>
		<cfset This.recibirArchivoAplicados(Arguments.dsn, 0, insertArchivo.identity, 'L', lineReader, lineCount)>
		<cfset lineReader.close()>
	<cfcatch type="any">
		<cfset lineReader.close()>
		<cfrethrow>
	</cfcatch>
	</cftry>
</cffunction>
<!--- setEstadoLlamada --->
<cffunction name="setEstadoLlamada" output="false">
	<cfargument name="dsn" type="string" required="yes">
	<cfargument name="log_id" type="numeric">
	<cfargument name="EVestado" type="string">
	<cfargument name="LFobs" type="string">
	<cfargument name="FMEmailid" type="numeric">
	<cfargument name="FMEarchivo" type="numeric">

	<!---<cflog file="isb_setEstadoLlamada" text="log_id=#log_id#, EVestado=#EVestado#, obs=#LFobs#, mailid=#FMEmailid#, archivo=#FMEarchivo#">--->

		<!---
			se utiliza un stored procedure en lugar de codigo cfc
			con el fin de mejorar el rendimiento.
			La  pruebas realizadas en desarrollo indican una reducción 
			en el tiempo de proceso de 16ms a 7ms por registro.
			- danim, 5-jun-2006
		--->
		<cfquery datasource="#Arguments.dsn#">
			exec isb_setEstadoLlamada
				@log_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.log_id#">,
				@EVestado = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.EVestado#">,
				@LFobs = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LFobs#">,
				@FMEmailid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FMEmailid#" null="#Arguments.FMEmailid eq 0#">,
				@FMEarchivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FMEarchivo#">
		</cfquery>
</cffunction>
<cffunction name="setBloqueo" output="false">
	<cfargument name="dsn" type="string" required="yes">
	<cfargument name="MDref" type="string" required="yes">
		<!---
			Se bloquean los Medios que reciben una llamada Morosa, con estado M 
		--->
		
		
		<cfquery datasource="#Arguments.dsn#" name="param225">
			select Pvalor 
				from ISBparametros 
			where Pcodigo = 225 
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfset pv = "-1">
		<cfif param225.RecordCount gt 0 and len(trim(param225.Pvalor))>
			<cfset pv = param225.Pvalor>
		</cfif>
		<cfinvoke component="saci.ws.intf.H038a_bloqueo900" method="bloqueo900"
		origen="saci"
		paquete="T"
		MDbloqueado="true"
		telefono="#Arguments.MDref#"
		MBmotivo="#pv#"/>

</cffunction>
<!--- generarArchivoTrafico --->
<cffunction name="generarArchivoTrafico" output="yes">
	<!--- requiere de output=yes para poder generar los cfoutput.
		Cuando se trate de generar un archivo, se puede invocar con
		cfsilent si es necesarion
	 --->
	<cfargument name="dsn" type="string" required="yes">
	<cfargument name="LFlote" type="numeric" required="yes">
	<cfargument name="generarVariable" type="boolean">

	<cfset HoraEnvio = Now()>
	<cfset localCache = CreateObject("java", "java.lang.StringBuffer")>
	<cfset linea = 'HDR' & DateFormat(HoraEnvio, 'yyyymmdd') & TimeFormat(HoraEnvio, 'HHmmss') & Chr(13) & Chr(10)>
	<cfif Arguments.generarVariable>
		<cfset localCache.append(linea)>
	<cfelse>
		<cfoutput>#linea#</cfoutput>
	</cfif>
	<cfset FechaEnvio = DateFormat(Now(), 'yymmdd')>
	<cfset lineCount = 0>

	<cftry>
		<cf_jdbcquery_open name="ISBeventoMedio" datasource="#Arguments.dsn#">
			<cfoutput>
			select log_id, MDref, EVmonto, EVduracion, EVinicio
			from ISBeventoMedio
			where LFlote = #Arguments.LFlote#
			</cfoutput>
		</cf_jdbcquery_open>
		
		<cfloop query="ISBeventoMedio">
			<cfset lineCount = lineCount + 1>
			<cfset linea = ''>
			<cfset linea = linea & RepeatString('6', 1)> <!--- Código para este servicio --->
			<cfset linea = linea & '900'> <!--- Relleno --->
			<cfset linea = linea & TimeFormat(EVinicio, 'HHmmss')> <!--- Hora de inicio de la llamada --->
			<cfset linea = linea & FechaEnvio> <!--- Fecha de envío por RACSA --->
			<cfset linea = linea & Left(MDref & '       ', 7)> <!--- Teléfono --->
			<cfset linea = linea & RepeatString(' ', 5)> <!--- Número de mensajes --->
			<cfset linea = linea & Right(NumberFormat(EVmonto, '0000000.00'), 10)> <!--- Valor del servicio --->
			<cfset linea = linea & 'C'> <!--- Moneda : está fija --->
			<cfset linea = linea & RepeatString(' ', 4)> <!--- Código destino--->
			<cfset linea = linea & RepeatString(' ', 4)> <!--- Código de área --->
			<cfset linea = linea & DateFormat(EVinicio, 'yyyymmdd')> <!--- Fecha conexión --->
			<cfset linea = linea & Right(NumberFormat(EVduracion, '00000000'), 8)> <!--- Cantidad de segundos consumidos --->
			<cfset linea = linea & RepeatString(' ', 5)> <!--- Resto --->
			<cfset linea = linea & Right('0000000000' & log_id, 10)> <!--- Log_id --->
			<cfset linea = linea & Chr(13) & Chr(10)>
			<cfset localCache.append(linea)>
			<cfif lineCount Mod 100 EQ 0>
				<cfif Arguments.generarVariable>
				<cfelse>
					<cfoutput>#localCache.toString()#</cfoutput>
					<cfset localCache.setLength(0)>
				</cfif>
			</cfif>
		</cfloop>
		<cfif Arguments.generarVariable>
		<cfelse>
			<cfoutput>#localCache.toString()#</cfoutput>
		</cfif>
		<cf_jdbcquery_close>
	<cfcatch type="any">
		<cf_jdbcquery_close>
		<cfrethrow>
	</cfcatch>
	</cftry>
	<cfset linea = 'TRL' & DateFormat(HoraEnvio, 'yyyymmdd') & TimeFormat(HoraEnvio, 'HHmmss') & NumberFormat(lineCount, '0000000') & Chr(13) & Chr(10)>
	<cfif Arguments.generarVariable>
		<cfset localCache.append(linea)>
		<cfreturn localCache.toString()>
	<cfelse>
		<cfoutput>#linea#</cfoutput>
	</cfif>
	<cfreturn ''>
</cffunction>


<cffunction name="contarLineas" output="false">
	<cfargument name="fileReader">
	<cfset var lineCount = 0>
	<cfset var lineReader = CreateObject("java", "java.io.LineNumberReader").init(fileReader)>
	<cfset var linea = ''>
	<cfloop condition="1"><cfsilent><!--- intento de reducir la memoria usada --->
		<cfset linea = lineReader.readLine()>
		<cfif Not IsDefined('linea')>
			<!--- fin de archivo cuando readLine regresa nulo --->
			<cfbreak>
		</cfif>
		<cfset lineCount = lineCount + 1>
	</cfsilent></cfloop>
	<cfreturn lineCount>
</cffunction>
</cfcomponent>

<!---
/*
** Cancelación de Facturas y Sustituci+on
** 
** Fecha: 27 Abril de 2022
*/
--->

<cfcomponent>

	<cffunction name="Cancelacion_Sust_Konesh" output="no" returntype="string" access="public">
		<cfargument name='codigo' 	    type='string'  	required='true'>     <!---Facturas que se deben crear--->
		<cfargument name='RfcEmisor' 	type='string' 	required='true'>
		<cfargument name='Tipo' 		type='string' 	required='true'>  <!---Muestra si es cancelación o sustitución de factura--->
		<cfargument name='FolioSust' 	type='string' 	required='false'>  <!---UUID Con el que susituiremos al anterior en caso de ser sustitución--->
		<cfargument name='Motivo'		type='string' 	required='false'>	 <!--- Motivo de cancelación ---->
		<cfargument name='Ecodigo'		type='numeric' 	required='true'>	 <!--- Codigo empresa ---->
		<cfargument name='usuario' 		type='string' 	required='true'>	 <!--- Codigo del usuario ---->
		<cfargument name='debug' 		type='string' 	required='false' default	= "N">	 <!--- Ejecutra el debug S= si  N= no---->
		<cfargument name='Conexion' 	type='string' 	required='false' default	= "#Session.DSN#">
		<cfargument name='USA_tran' 	type="boolean" 	required='false' default='true'>
		<!---<cfset codigo = arrayToList(codigo)>--->
		<!--- Fecha y hora--->
		<cfset ZonaHoraria = createObject("component","rh.Componentes.GeneraCFDIs.ZonaHoraria")>
        <cfset DiferenciaHorasTimbrado = ZonaHoraria.DiferenciaHorasTimbrado()>
        
        <cfif DiferenciaHorasTimbrado eq "">
            <cfset DiferenciaHorasTimbrado = 0>
        </cfif>
		<cfset Hora = timeFormat(now(), "HH")>
		<cfset Hora ="#Hora#"+"#DiferenciaHorasTimbrado#">
		<cfset Hora = NumberFormat(Hora, '00')>
        <cfset fechaHora= dateFormat(Now(),"yyyy-mm-dd") & "T" & timeFormat(now(), "#Hora#:mm:ss")> 

		<cfquery name="rsGetUI" datasource = "#Session.DSN#">
				select TimbreFiscal as timbre from Documentos
				where Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#codigo#">
		</cfquery>
		<cfif Tipo eq "Cancelacion">
        	<cfoutput>
        	    <!--- XML de Cancelación de factura --->
        	    <cfxml variable="xmlCan"><Cancelacion xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://cancelacfd.sat.gob.mx" RfcEmisor="#rfcEmisor#" Fecha="#fechaHora#"><Folios><Folio UUID="#rsGetUI.timbre#" Motivo="#Motivo#"/></Folios></Cancelacion></cfxml>
        	</cfoutput>
		<cfelseif Tipo eq "Sustitucion">
			<cfoutput>
        	    <!--- XML de Sustitución de factura --->
        	    <cfxml variable="xmlCan"><Cancelacion xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://cancelacfd.sat.gob.mx" RfcEmisor="#rfcEmisor#" Fecha="#fechaHora#"><Folios><Folio UUID="#rsGetUI.timbre#" Motivo="01" FolioSustitucion="#FolioSust#"/></Folios></Cancelacion></cfxml>
        	</cfoutput>
		</cfif>
		
        <cfset xmlCancelacion = ToString(xmlCan)>

         <!--- INICIA - path fijo--->
        <cfquery name="getDatosCert" datasource="#session.dsn#">
            select archivoKey, Certificado, clave from RH_CFDI_Certificados where Ecodigo=#session.Ecodigo#
        </cfquery>
        <cfset vsPath = #getDatosCert.archivoKey#>
        <cfset vsPath_A = left(vsPath,2)>

        <cfset keyContent = filereadbinary(vsPath)>
        <cfset certificadoCont = "#getDatosCert.Certificado#">
        <cfset claveKey = "#getDatosCert.clave#">
        <!--- FIN - path fijo--->

	    <!--- INICIA - Obtencion de parametros para Timbrado con PAC --->
        <cfquery name="getUrl" datasource="#session.dsn#">
            select Pvalor from Parametros where Ecodigo=#session.Ecodigo# and Mcodigo='FA' and Pcodigo = 501
        </cfquery>
        <cfquery name="getToken" datasource="#session.dsn#">
            select Pvalor from Parametros where Ecodigo=#session.Ecodigo# and Mcodigo='FA' and Pcodigo = 506
        </cfquery>
        <cfquery name="getUsr" datasource="#session.dsn#">
            select Pvalor from Parametros where Ecodigo=#session.Ecodigo# and Mcodigo='FA' and Pcodigo = 504
        </cfquery>
        <cfquery name="getPwd" datasource="#session.dsn#">
            select Pvalor from Parametros where Ecodigo=#session.Ecodigo# and Mcodigo='FA' and Pcodigo = 505
        </cfquery>
        <cfquery name="getCta" datasource="#session.dsn#">
            select Pvalor from Parametros where Ecodigo=#session.Ecodigo# and Mcodigo='FA' and Pcodigo = 503
        </cfquery>
        <!--- FIN - Obtencion de parametros para Timbrado con PAC --->
    

        <!--- INICIA - Credenciales para autenticacion con el PAC--->
        <cfset LvarToken="#getToken.Pvalor#" >
        <cfset LvarUsuario="#getUsr.Pvalor#" >
        <cfset LvarPassword="#getPwd.Pvalor#" >
        <cfset LvarCuenta="#getCta.Pvalor#" >
        <cfset LvarUrl = "#getUrl.Pvalor#">

    
        <cffunction  name="ClassGenEnveloped"> <!--- Obtener clase GenEnveloped de Sello Digital .jar--->
            <cfobject type="java" class="generacsd.GenEnveloped" name="myGenEnveloped">
            <cfreturn myGenEnveloped>
        </cffunction>

        <cffunction name="GeneraFirmaXML" returntype="string"> <!--- obtener la cadenaOriginal--->
            <cfargument name="xmlString"       type="string" 	required="yes">     
            <cfargument name="certificado"     type="string" 	required="yes">  
            <cfargument name="privateKey"      	required="yes">
            <cfargument name="privateKeyPass"  type="string" 	required="yes">
            <cfset GenEnveloped = ClassGenEnveloped()>
            <cfset firmaXML = GenEnveloped.sign('#arguments.xmlString#','#arguments.certificado#','#arguments.privateKey#','#arguments.privateKeyPass#')> 
            <cfreturn firmaXML>
        </cffunction>

         <cfset firmaXml = GeneraFirmaXML(xmlCancelacion,certificadoCont,keyContent,claveKey)> 
         <cfset xmlCan = (firmaXML)>

        <cfsavecontent variable="soapBody">
        	<cfoutput>
        	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:can="http://cancelacion.cfdi.mx.konesh.com">
           <soap:Body>
              <can:cancelar>
                 <!---Optional:--->
                 <can:usr>#LvarUsuario#</can:usr>
                 <!---Optional:--->
                 <can:psw>#LvarPassword#</can:psw>
                 <!---Optional:--->
                 <can:tkn>#LvarToken#</can:tkn>
                 <!---Optional:--->
                 <can:cta>#LvarCuenta#</can:cta>
                 <!---Optional:--->
                 <can:xmldsig><![CDATA[#xmlCan#]]></can:xmldsig>
              </can:cancelar>
           </soap:Body>
        </soap:Envelope>
        </cfoutput>
        </cfsavecontent>

	    <cfhttp url=#LvarUrl#  method="post"  result="httpResponse">
	    <cfhttpparam type="header" name="content-type" value="application/soap" />
        <cfhttpparam type="xml"  value="#trim( soapBody )#"/>
        </cfhttp> 
        <cfset result = serializeXML(httpResponse.filecontent)>
        <cfset result =  replace(result,"&lt;","<","ALL")>
                 <cfset match = REMatch("<ERROR codError=.*?</ERROR>",result)>
                <cfif ArrayIsEmpty(match) eq false>
                    <cfset match2 = REMatch("codError=.*?>",result)>
                    <cfthrow message="No se ha Cancelado el CFDI [#match2[1]#] #match[1]#">
                </cfif>

        
		
                <cfquery name="rsFactCanc" datasource="#session.dsn#">
							select	s.SNcodigo, Ddocumento, a.CCTcodigo, s.SNnombre, TimbreFiscal from Documentos a 
								inner join SNegocios s on a.SNcodigo = s.SNcodigo
								where Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#codigo#">
								and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">			
				</cfquery>
                <cfquery name="insertCola"datasource="#session.DSN#">
        	        	insert into ColaCancelacionFactura
        	                (Ecodigo, CCTcodigo, Ddocumento, SNcodigo ,SNnombre, Rfc, Timbre, Estatus, Tipo,
        	            	 Motivo, BMUsucodigo)
						values
        	        		(<cfqueryparam value="#Ecodigo#" cfsqltype="cf_sql_integer">,
        	                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFactCanc.CCTcodigo#">,
        	                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFactCanc.Ddocumento#">,
                             <cfqueryparam cfsqltype="cf_sql_integer" value="#rsFactCanc.SNcodigo#">,	
                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFactCanc.SNnombre#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RfcEmisor#">,
                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFactCanc.TimbreFiscal#">,
        	                 <cfqueryparam cfsqltype="cf_sql_varchar" value="Procesando">,
							 <cfif Tipo eq "Cancelacion">
							 	<cfqueryparam cfsqltype="cf_sql_varchar" value="Cancelación">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Motivo#">,
							 <cfelseif Tipo eq "Sustitucion">
							 	<cfqueryparam cfsqltype="cf_sql_varchar" value="Sustitución">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="01">,
							 </cfif>
	    	                 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
        	             	)
					</cfquery>
                
                <cfset match = REMatch("<TIPO_CANCELACION>.*?</TIPO_CANCELACION>",result)>
                <cfif ArrayIsEmpty(match) eq false>
                <cfdump  var="Petición procesada correctamente: #match[1]#">
                </cfif>
	</cffunction>

	<cffunction name="EstatusCancelacionKonesh" output="no" returntype="string" access="public">
		<cfargument name='RfcEmisor' 	type='string' 	required='false'>
		<cfargument name='Ecodigo'		type='numeric' 	required='true'>	 <!--- Codigo empresa ---->
		<cfargument name='usuario' 		type='string' 	required='true'>	 <!--- Codigo del usuario ---->
		<cfargument name='debug' 		type='string' 	required='false' default	= "N">	 <!--- Ejecutra el debug S= si  N= no---->
		<cfargument name='Conexion' 	type='string' 	required='false' default	= "#Session.DSN#">
		<cfargument name='USA_tran' 	type="boolean" 	required='false' default='true'>
	
		<!--- INICIA - Obtencion de parametros para Timbrado con PAC --->
		<cfquery name="getUrl" datasource="#session.dsn#">
		    select Pvalor from Parametros where Ecodigo=#Ecodigo# and Mcodigo='FA' and Pcodigo = 502
		</cfquery>
		<cfquery name="getToken" datasource="#session.dsn#">
		    select Pvalor from Parametros where Ecodigo=#Ecodigo# and Mcodigo='FA' and Pcodigo = 506
		</cfquery>
		<cfquery name="getUsr" datasource="#session.dsn#">
		    select Pvalor from Parametros where Ecodigo=#Ecodigo# and Mcodigo='FA' and Pcodigo = 504
		</cfquery>
		<cfquery name="getPwd" datasource="#session.dsn#">
		    select Pvalor from Parametros where Ecodigo=#Ecodigo# and Mcodigo='FA' and Pcodigo = 505
		</cfquery>
		<cfquery name="getCta" datasource="#session.dsn#">
		    select Pvalor from Parametros where Ecodigo=#Ecodigo# and Mcodigo='FA' and Pcodigo = 503
		</cfquery>
		<!--- FIN - Obtencion de parametros para Timbrado con PAC --->
		
		<!--- INICIA - Credenciales para autenticacion con el PAC--->
		<cfset LvarToken="#getToken.Pvalor#" >
		<cfset LvarUsuario="#getUsr.Pvalor#" >
		<cfset LvarPassword="#getPwd.Pvalor#" >
		<cfset LvarCuenta="#getCta.Pvalor#" >
		<cfset LvarUrl = "#getUrl.Pvalor#">
		<!--- Fecha y hora--->
		<cfset ZonaHoraria = createObject("component","rh.Componentes.GeneraCFDIs.ZonaHoraria")>
        <cfset DiferenciaHorasTimbrado = ZonaHoraria.DiferenciaHorasTimbrado()>
        
        <cfif DiferenciaHorasTimbrado eq "">
            <cfset DiferenciaHorasTimbrado = 0>
        </cfif>
		<cfset Hora = timeFormat(now(), "HH")>
		<cfset Hora ="#Hora#"+"#DiferenciaHorasTimbrado#">
		<cfset Hora = NumberFormat(Hora, '00')>
        <cfset fechaHora= dateFormat(Now(),"yyyy-mm-dd") & "T" & timeFormat(now(), "#Hora#:mm:ss")> 
		
	
		<!--- Consulta de la tabla donde se muestra la fila de las Facturas en cancelación --->
		<cfquery name="rsColaCanc" datasource="#session.dsn#">
			select * from ColaCancelacionFactura
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfif not isDefined("Arguments.RfcEmisor")>
			<cfset RfcEmisor = "#rsColaCanc.Rfc#">
		</cfif>
		<!--- Comienza Loop general para recorrer todos los registros y verificar su estado de cancelación --->
		<cfset control = 1>
		<cfloop query="rsColaCanc">
			<cfif rsColaCanc.Aplicado neq "OK">
			
				<!--- Petición para el estatus de cancelación --->
				<cfsavecontent variable="EstatusCanc">
        			<cfoutput>
        				<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:can="http://cancelacion.estado.consulta.mx.konesh.com">
   						<soapenv:Header/>
   						<soapenv:Body>
      						<can:obtieneEstadoCancelacion>
        						 <can:usuario>#LvarUsuario#</can:usuario>
        						 <can:password>#LvarPassword#</can:password>
								 <can:token>#LvarToken#</can:token>
        						 <can:cuenta>#LvarCuenta#</can:cuenta>
        						 <can:rfcEmisor>#RfcEmisor#</can:rfcEmisor>
        						 <can:listaUuid>#rsColaCanc.Timbre#</can:listaUuid>
      						</can:obtieneEstadoCancelacion>
   						</soapenv:Body>
						</soapenv:Envelope>
        			</cfoutput>
        		</cfsavecontent>
				<!--- Mandamos la petición --->
	    		<cfhttp url=#LvarUrl#  method="post"  result="httpResponse">
	    		<cfhttpparam type="header" name="content-type" value="application/soap" />
        		<cfhttpparam type="xml"  value="#trim( EstatusCanc )#"/>
        		</cfhttp> 
				<!--- Obtenemos el resultado de la petición y remplazamos algunos carateres especiales--->
        		<cfset result = serializeXML(httpResponse.filecontent)>
        		<cfset result =  replace(result,"&lt;","<","ALL")>	
				<!--- Obtenemos el estado de la factura con respecto a la cancelación--->
				<cfset match = REMatch("<estado>.*?</estado>",result)>	
				<cfset match = arrayToList(match)>	
				<cfset estado_a =   replace(match,"<estado>","","ALL")>
				<cfset estado_a =  replace(estado_a,"</estado>","","ALL")>
				<!--- Obtenemos el estatus de la factura con respecto a la cancelación--->
				<cfset match = REMatch("<subEstado>.*?</subEstado>",result)>	
				<cfset match = arrayToList(match)>	
				<cfset estatus_a =   replace(match,"<subEstado>","","ALL")>
				<cfset estatus_a =  replace(estatus_a,"</subEstado>","","ALL")>
				<!--- Obtenemos los dias que han transcurrido desde su cancelación --->
				<cfset diasCancelado =0>
				<cfif rsColaCanc.FechaCancelado neq "NULL">
					<cfquery name="rsDate" datasource="#session.dsn#">
					SELECT DATEDIFF(DAY, '#rsColaCanc.FechaCancelado#', '#fechaHora#') as dia
					</cfquery>
					<cfset diasCancelado ="#rsDate.dia#">
				</cfif>
				
				<!--- Obtenemos el folio para posteriormente realizar la operación interna de aplicar documentos --->
				<cfif rsColaCanc.Aplicado neq "OK" and control eq 1>
						
						<cfset folio = rsColaCanc.Ddocumento>
						<cfset folio = listToArray(folio)>

					<cfif rsColaCanc.Tipo eq "Cancelación" and rsColaCanc.Estado eq "Cancelado" >
						<cftransaction>
							<cfset 	CancelacionFactura (
										folio,
										Arguments.Ecodigo,
										0,
										Arguments.usuario,
										Arguments.debug,
										Arguments.Conexion
							)>
						</cftransaction>
					<cfelseif rsColaCanc.Tipo eq "Sustitución" and rsColaCanc.Estado eq "Cancelado" >
						<cftransaction>
							<cfset 	CancelacionFactura (
										folio,
										Arguments.Ecodigo,
										1,
										Arguments.usuario,
										Arguments.debug,
										Arguments.Conexion
							)>
						</cftransaction>
					</cfif>
					
				</cfif>
				<cfif rsColaCanc.Estado neq "Cancelado">
				<!--- Actualizamos el Estado y el Estatus --->
				<cfquery name="upColCan" datasource="#session.dsn#">
        		    update ColaCancelacionFactura
        		            set     Estado = '#estado_a#', Estatus='#estatus_a#'
							<cfif estado_a eq "Cancelado" and rsColaCanc.FechaCancelado neq "NULL">
							, FechaCancelado = <cfqueryparam cfsqltype="cf_sql_datetime" value="#fechaHora#">
							<cfelseif estado_a eq "Vigente" and rsColaCanc.FechaCancelado neq "NULL">
							, FechaCancelado = <cfqueryparam cfsqltype="cf_sql_datetime" value="#fechaHora#">
							</cfif>
        		            WHERE   Timbre= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsColaCanc.Timbre#">
        		            AND Ecodigo = #Ecodigo#
        		</cfquery> 
				</cfif>
				<cfset control = 2>
			</cfif>
			<!---
			<!---Elimina el registro si han transcurrido mas de 30 dias de su cancelación --->
			<cfif diasCancelado gte 30>
				<cfquery datasource="#session.DSN#">
					delete from ColaCancelacionFactura
					 WHERE   Timbre= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsColaCanc.Timbre#">
        		    AND Ecodigo = #Ecodigo#
				</cfquery>
			</cfif>
			<!--- Elimina el registro despues de 5 dias si su estado es vigente y su solicitud es rechazada --->
			<cfif diasCancelado gte 4 and estado_a eq "Vigente">
				<cfquery datasource="#session.DSN#">
					delete from ColaCancelacionFactura
					 WHERE   Timbre= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsColaCanc.Timbre#">
        		    AND Ecodigo = #Ecodigo#
				</cfquery>
			</cfif>--->
			
		</cfloop>
	</cffunction>


	<cffunction name="CancelacionFactura" output="no" returntype="string" access="public">
		<cfargument name='Folios'	    type='any' 		required='true'>	 <!--- Lista de folios ---->
		<cfargument name='Ecodigo'		type='numeric' 	required='true'>	 <!--- Codigo empresa ---->
		<cfargument name='Sustitucion'	type='numeric' 	required='false'  default	= 0>	 <!--- Codigo empresa ---->
		<cfargument name='usuario' 		type='string' 	required='true'>	 <!--- Codigo del usuario ---->
		<cfargument name='debug' 		type='string' 	required='false' default	= "N">	 <!--- Ejecutra el debug S= si  N= no---->
		<cfargument name='Conexion' 	type='string' 	required='false' default	= "#Session.DSN#">
		<cfargument name='USA_tran' 	type="boolean" 	required='false' default='true'>

		<cfloop array="#Folios#" index="i">
				<cfquery name="rsPF" datasource="#session.dsn#">

				select DISTINCT	a.Ecodigo, s.SNcodigo, Ddocumento, t.CCTcodigoRef as CCTcodigo, t.PFTtipo, 
				s.SNnombre, m.ClaveSAT, Dsaldo,Dfecha, TimbreFiscal, a.Ccuenta, Dtref,Ddocref,
				Dtotal,a.Mcodigo,a.Dtipocambio
				from Documentos a 
								inner join FAPFTransacciones t on a.Ecodigo = t.Ecodigo and a.CCTcodigo = t.CCTcodigoRef
								inner join Monedas m on (a.Ecodigo=m.Ecodigo and a.Mcodigo = m.Mcodigo) 
								inner join SNegocios s on (a.Ecodigo=m.Ecodigo and a.SNcodigo = s.SNcodigo)
								where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								 and a.Dsaldo > 0.0
						and Ddocumento = '#i#'				
				</cfquery>

			<cfset Total = LSParseNumber("#rsPF.Dsaldo#")>
			<cfset SNCodigo = "#rsPF.SNcodigo#">
			<cfset lvarFecha = "#rsPF.Dfecha#">
			<cfset codigo = "#i#">
			<cfset ccCodigo = "#rsPF.CCTcodigo#">
			<cfset completado = 0>
			<cfset fechaHora="#DateFormat(Now(),"yyyy-mm-ddTHH:mm:ss")#"> 
			<cfset timbreSus = "#rsPF.TimbreFiscal#">
			<cfset tipoTransaccion = "#rsPF.PFTtipo#">
			
			<!---Consulta para el Dcodigo--->
				<cfquery name="rsDcodigo" datasource="#session.dsn#">
					select Dcodigo, Ddescripcion from Departamentos
					where Ecodigo =  #Ecodigo#
					order by Ddescripcion
				</cfquery>
			<!--- Depende el tipo de transacción es el tipo de operación --->
				<cfif tipoTransaccion eq 'C'>
					<cfset transaccionCxC = "AN">
				<cfelse>
					<cfset transaccionCxC = "AC">
				</cfif>
				<cfquery name="rsVerificaTCXC" datasource="#session.DSN#">
					select CCTcodigo from CCTransacciones
					where CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#transaccionCxC#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
				</cfquery>
				<cfif rsVerificaTCXC.CCTcodigo eq ''>
					<cfthrow message="No está definido el tipo de transacción 'AN' o 'AC' en transacciónes CXC">
				</cfif>

				<cfset nombre = #transaccionCxC# & "-" & #i#>
				<!---Comenzamos a llenar los datos necesarios para Créditos de CXC--->
				<!---Verificamos que no exista un registro guardado en Créditos--->
				<cfquery name="rsVerifica" datasource="#session.DSN#">
        	        	select 1 from HDocumentos
        	            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
					and Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombre#">
        	            and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#transaccionCxC#">
        	        </cfquery>
        	        <cfquery name="rsVerifica2" datasource="#session.DSN#">
        	        	select 1 from EDocumentosCxC
        	            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
					and EDdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombre#">
        	            and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#transaccionCxC#">
        	        </cfquery>

        	      <cfif rsVerifica.recordcount GT 0 OR rsVerifica2.recordcount GT 0>
        	        	<cfabort showerror="Documento ya existe en los Documentos de CxC">
					</cfif>

        	        <!--- Inserta del Documento en el auxiliar de CxC --->
        	        <cfquery name="rsOIinsert" datasource="#session.DSN#">
						select Ocodigo, SNcodigo, Mcodigo, Dtipocambio, Ccuenta, Dtotal, Dfecha, id_direccionFact, id_direccionEnvio, DEdiasVencimiento,
						Dvencimiento, DEobservacion, TESRPTCid, TESRPTCietu, TimbreFiscal, EDieps 
						from Documentos where Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">
 						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
					</cfquery>


				<!--- LLenamos el encabezado en cxc dependiendo el tipo de operación --->
				<cfset ccuenta1 = "#rsPF.Ccuenta#">
					<cfquery name="insertDoc"datasource="#session.DSN#">
        	        	insert into EDocumentosCxC
        	                (Ocodigo, CCTcodigo, EDdocumento, SNcodigo, Mcodigo,
        	            	EDtipocambio, Ccuenta, EDdescuento, EDporcdesc, EDimpuesto,
        	                EDtotal, EDfecha, EDtref, EDdocref, EDusuario, EDselect, Interfaz,
        	                id_direccionFact, id_direccionEnvio, DEdiasVencimiento, EDvencimiento,
        	            	DEobservacion, DEdiasMoratorio, Ecodigo, BMUsucodigo, TESRPTCid, TESRPTCietu,TimbreFiscal,EDieps)
						values
        	        		(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.Ocodigo#">,
        	                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#transaccionCxC#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#nombre#">,
        	                 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.SNcodigo#">,
        	    	         <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.Mcodigo#">,
	    	                 <cfqueryparam cfsqltype="cf_sql_float" value="#rsOIinsert.Dtipocambio#">,
							 <cfif ccuenta1 neq "">
							 	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.Ccuenta#">,
							<cfelse>
							0,
							 </cfif>
        	                 
        	                 0,
        	                 0,
        	                 0,
        	                 <cfqueryparam cfsqltype="cf_sql_money" value="#rsOIinsert.Dtotal#">,
        	                 <cfqueryparam cfsqltype="cf_sql_date" value="#rsOIinsert.Dfecha#">,
							 	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccCodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">,
    		                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usuario#">,
        	                 0,
        	                 0,
        	                 <cfif rsOIinsert.id_direccionFact EQ "">
								 null,
        	                 <cfelse>
        	                     <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.id_direccionFact#">,
        	                 </cfif>
        	                 <cfif rsOIinsert.id_direccionEnvio EQ "">
        	                 	null,
        	                 <cfelse>
        		             	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.id_direccionEnvio#">,
        	                 </cfif>
        	                 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.DEdiasVencimiento#">,
        	                 <cfqueryparam cfsqltype="cf_sql_date" value="#rsOIinsert.Dvencimiento#">,
        	                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.DEobservacion#">,
        	                 0,
        	                 <cfqueryparam value="#Ecodigo#" cfsqltype="cf_sql_integer">,
        		             <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							 <cfif rsOIinsert.TESRPTCid neq "">
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.TESRPTCid#">,
							 <cfelse>
							 0,
							 </cfif>
        	                 
        	                 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.TESRPTCietu#">,
        	                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.TimbreFiscal#">,
        	                 <cfqueryparam cfsqltype="cf_sql_money" value="#rsOIinsert.EDieps#">
        	             	)
						<cf_dbidentity1 name="insertDoc" datasource="#session.DSN#" >
					</cfquery>
				<cf_dbidentity2 name="insertDoc" datasource="#session.DSN#"  returnvariable="EdId">
				<!--- Consulta para obtener lineas de la factura --->
				<cfquery name="rsLineas" datasource="#session.dsn#">
					select DDcodartcon, DDtipo, DDescripcion, DDdescalterna, Dcodigo, 
						DDcantidad, DDpreciou, DDdesclinea, DDtotal, DDMontoIEPS,
						Ccuenta, Alm_Aid, Icodigo, CFid, codIEPS, DDMontoIEPS, 
						afectaIVA, Rcodigo 
						from DDocumentos 
						where Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">
 						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
				</cfquery>
				
				<!---Llenado Automatico de las lineas en créditos de CxC --->
				<cfloop query="#rsLineas#">
					<cfset EdId = "#EdId#">
					<cfset Aid = "">
					<cfset Cid = "#rsLineas.DDcodartcon#">
					<cfset tipoLinea = "#rsLineas.DDtipo#">
					<cfset DDdescripcion = "#rsLineas.DDescripcion#">
					<cfset descAlterna = "#rsLineas.DDdescalterna#">
					<cfset Dcodigo = "#rsDcodigo.Dcodigo#">
					<cfset cantidad = "#rsLineas.DDcantidad#">
					<cfset precioU = "#rsLineas.DDpreciou#">
					<cfset descLinea = "#rsLineas.DDdesclinea#">
					<cfset porcentajeDescl = "">
					<cfset totalLinea = LSParseNumber(rsLineas.DDtotal)>
					<cfset ieps = "#rsLineas.DDMontoIEPS#">
					<cfset ccuenta = "#rsLineas.Ccuenta#">
					<cfset AlmId = "#rsLineas.Alm_Aid#">
					<cfset Icodigo = "#rsLineas.Icodigo#">
					<cfset cfId = "#rsLineas.CFid#">
					<cfset codIEPS = "#rsLineas.codIEPS#">
					<cfset montoIEPS = "#rsLineas.DDMontoIEPS#">
					<cfset afectaIva = "#rsLineas.afectaIVA#">
					<cfset rCodigo = "#rsLineas.Rcodigo#">
					<!--- Suma los descuentos a cada linea para tener el monto correcto--->
					<cfif descLinea gt 0>
						<cfset totalLinea = totalLinea+descLinea>
					</cfif>
					<cfquery name="insertD" datasource="#Session.DSN#" >
					
						INSERT INTO DDocumentosCxC
								(Ecodigo, EDid, Aid, Cid, DDdescripcion, DDdescalterna, Dcodigo, DDcantidad, DDpreciou,
							 	DDdesclinea, DDporcdesclin, DDtotallinea, DDtipo, Ccuenta, Alm_Aid, Icodigo, CFid,
							 	OCid, OCTid, OCIid, BMUsucodigo, codIEPS, DDMontoIEPS, afectaIVA, Rcodigo)
						values (
							 #Ecodigo# ,
							 <cfif EdId eq "">
							 	null,
							 <cfelse>
							 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#EdId#">,
							 </cfif>
							<cfif Aid eq "">
							 	null,
							 <cfelse>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Aid#">,
							</cfif>
							<cfif Cid eq "">
							 	null,
							 <cfelse>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Cid#">,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="Cancelacion de Factura">,
							<cfif len(trim(descAlterna)) GT 0>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#descAlterna#">,
							<cfelse>
								null,
							</cfif>
							<cfif  rsDcodigo.recordcount EQ 1>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Dcodigo#">,
							<cfelse>
								null,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_float" value="#Replace(cantidad,',','','all')#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(precioU,',','','all')#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(descLinea,',','','all')#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#Replace(0,',','','all')#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#totalLinea#">,

							<cfqueryparam cfsqltype="cf_sql_char" value="#mid(tipoLinea,1,1)#">,
							<cfif ccuenta eq "">
							 	null,
							 <cfelse>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#ccuenta#">,
							</cfif>
							<cfif AlmId eq "">
							 	null,
							 <cfelse>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#AlmId#">,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_char" value="#Icodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#cfId#">,
								null,
								null,
								null,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(codIEPS,',','','all')#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(montoIEPS,',','','all')#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#afectaIva#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rCodigo#">
							)
					</cfquery>
				</cfloop>   

				<!--- Invoca el componente de aplicar créditos en CxC --->
				<cfinvoke component="sif.Componentes.CC_PosteoDocumentosCxC"
							method="PosteoDocumento"
							EDid	= "#EdId#"
							Ecodigo = "#Ecodigo#"
							usuario = "#Session.usuario#"
						/> 

						<cfquery name="rsgetDocuments" datasource="#session.DSN#">
        			        	select * from Documentos
        			            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
					and Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombre#">
        			            and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#transaccionCxC#">
        			        </cfquery>

				<!--- Comienza la aplicación de documentos --->		
				<cfquery datasource="#Session.DSN#">
				insert into EFavor (Ecodigo, CCTcodigo, Ddocumento, SNcodigo, Mcodigo, EFtipocambio, EFtotal, EFselect, Ccuenta,
								EFfecha, EFusuario, CodTipoPago)
				values
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#rsgetDocuments.CCTcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#nombre#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsgetDocuments.SNcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsgetDocuments.Mcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#rsgetDocuments.Dtipocambio#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Total#">,
					0,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsgetDocuments.Ccuenta#">,
					<!--- <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(Form.EFfecha)#">, --->
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#lvarFecha#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsgetDocuments.Dusuario#">,
					0
					)
				</cfquery>

				<cfquery datasource="#Session.DSN#">
					insert into DFavor (
						Ecodigo,
						CCTcodigo,
						Ddocumento,
						CCTRcodigo,
						DRdocumento,
						SNcodigo,
						DFmonto,
						Ccuenta,
						Mcodigo,
						DFtotal,
						DFmontodoc,
						DFtipocambio )
					values
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#rsgetDocuments.CCTcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#nombre#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#rsgetDocuments.Dtref#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#rsgetDocuments.Ddocref#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsgetDocuments.SNcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#Total#">,<!--- Porque se guarda en dos campos diferentes --->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsgetDocuments.Ccuenta#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsgetDocuments.Mcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#Total#">,<!--- Porque se guarda en dos campos diferentes --->
						<cfqueryparam cfsqltype="cf_sql_money" value="#Total#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#rsgetDocuments.Dtipocambio#">
					)
    			</cfquery>

					<cfquery name="rsSocio" datasource="#session.dsn#">
								 select sn.SNid 
								     from Documentos a 
									     inner join SNegocios sn
								            on a.SNcodigo = sn.SNcodigo 
        		  						   and a.Ecodigo = sn.Ecodigo 
								   where rtrim(ltrim(a.CCTcodigo))  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsgetDocuments.CCTcodigo)#">
					and  rtrim(ltrim(a.Ddocumento)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(nombre)#">						 
								</cfquery> 
				
					<!--- Invoca el componente de posteo --->
								<cfinvoke component="sif.Componentes.CC_PosteoDocsFavorCxC"
								  method = "CC_PosteoDocsFavorCxC"
									Ecodigo    = "#Ecodigo#"
									CCTcodigo  = "#rsgetDocuments.CCTcodigo#"
									Ddocumento = "#nombre#"
									usuario    = "#Session.usuario#"
									SNid       = "#rsSocio.SNid#"
									Usucodigo  = "#Session.usucodigo#"
									fechaDoc   = "S"
        		                    transaccionActiva = "false"
									debug      = "NO"
									/>
				
				
					<cfquery name="rsParametros" datasource="#session.dsn#">
						select Pvalor from Parametros 
    				    where Pcodigo = 507		
    				    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">	
					</cfquery>
    				<cfset parametro = "#rsParametros.Pvalor#">

					<cfif parametro eq "Manual">
						<cfquery name="insertCola"datasource="#session.DSN#">
        	        	insert into ColaCancelacionFactura
        	                (Ecodigo, CCTcodigo, Ddocumento, SNcodigo ,SNnombre, Timbre, Estado, Estatus, Tipo,
        	            	 Motivo, FechaCancelado, BMUsucodigo)
						values
        	        		(<cfqueryparam value="#Ecodigo#" cfsqltype="cf_sql_integer">,
        	                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccCodigo#">,
        	                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPF.Ddocumento#">,
                             <cfqueryparam cfsqltype="cf_sql_integer" value="#SNCodigo#">,	
                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPF.SNnombre#">,
							 <cfif Sustitucion eq 1>
                             	<cfqueryparam cfsqltype="cf_sql_varchar" value="#timbreSus#">,
        	                 	<cfqueryparam cfsqltype="cf_sql_varchar" value="Cancelado">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Cancelado">,
							 	<cfqueryparam cfsqltype="cf_sql_varchar" value="Sustitución Manual">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="01">,
							 <cfelse>
							 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPF.TimbreFiscal#">,
        	                 	<cfqueryparam cfsqltype="cf_sql_varchar" value="Cancelado">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="Cancelado">,
							 	<cfqueryparam cfsqltype="cf_sql_varchar" value="Cancelación Manual">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MCanc#">,
							 </cfif>
							 <cfqueryparam cfsqltype="cf_sql_date" value="#fechaHora#">,
	    	                 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
        	             	)
					</cfquery>

					</cfif>
					<cfquery name="upColCan" datasource="#session.dsn#">
        	    			update ColaCancelacionFactura
        	        	    set     Aplicado = 'OK'
        	        	    WHERE   Timbre= 
							<cfif Sustitucion eq 1>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#timbreSus#">
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPF.TimbreFiscal#">
							</cfif>
        	        	    AND Ecodigo = #Ecodigo#
        				</cfquery>

			</cfloop>
			
	</cffunction>


</cfcomponent>



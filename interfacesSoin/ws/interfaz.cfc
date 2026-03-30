<cfcomponent>
	<cffunction name="sendToSoin" 		access="remote" output="false" returntype="string">
		<cfargument name="Empresa"		type="string">
		<cfargument name="EcodigoSDC"	type="numeric">
		
		<cfargument name="Num_Interfaz"	type="numeric">
		<cfargument name="ID_Proceso"	type="numeric">

		<cftry>
			<cfset fnAcceso (ARGUMENTS.Empresa, ARGUMENTS.EcodigoSDC)>
		<cfcatch type="any">
			<cfreturn cfcatch.Message>
		</cfcatch>
		</cftry>

		<cftry>
			<cfobject name="LobjColaProcesos" component="interfacesSoin.Componentes.interfaces">
	
			<cfset GvarMSG = "OK">
			<cfset GvarNI = ARGUMENTS.Num_Interfaz>
			<cfset GvarID = ARGUMENTS.ID_Proceso>
			<cfset GvarUD = "WS:" & session.Interfaz.UID>
	
			<cfset GvarMSG = LobjColaProcesos.fnProcesoNuevoExterno (GvarNI, GvarID, GvarUD)>			
		<cfcatch type="any">
			<cfset LvarMSGstackTrace = LobjColaProcesos.fnGetStackTrace(cfcatch)>
			<cfset LobjColaProcesos.fnLog("","ERROR DE ANTES DE INICIAR LA INTERFAZ (WS1:sendToSoinXML), StackTrace=#LvarMSGstackTrace#")>
		
			<cfset GvarMSG = "ERROR DE ANTES DE INICIAR LA INTERFAZ (WS1:sendToSoin): #cfcatch.Message# #cfcatch.Detail#">
		</cfcatch>
		</cftry>

		<cfreturn GvarMSG>
	</cffunction>

	<cffunction name="sendToSoinXML"	access="remote" output="false" returntype="interfaz_out_xml">
		<cfargument name="Empresa"		type="string">
		<cfargument name="EcodigoSDC"	type="numeric">
		
		<cfargument name="Num_Interfaz"	type="numeric">

		<cfargument name="XML_IE"		type="string" default="">
		<cfargument name="XML_ID"		type="string" default="">
		<cfargument name="XML_IS"		type="string" default="">

		<cfargument name="XML_OUT"		type="boolean" default="true">

<!---
<cfobject component="interfaz_out_xml" name="LvarOUT_XML">
<cfset LvarOUT_XML.ID		= "0">
<cfset LvarOUT_XML.MSG		= GetHttpRequestData().toString()>
<cfset LvarOUT_XML.XML_OE	= "">
<cfset LvarOUT_XML.XML_OD	= "">
<cfset LvarOUT_XML.XML_OS	= "">
<cfreturn LvarOUT_XML>
--->
		<cftry>
			<cfset fnAcceso (ARGUMENTS.Empresa, ARGUMENTS.EcodigoSDC)>
		<cfcatch type="any">
			<cfobject component="interfaz_out_xml" name="LvarOUT_XML">

			<cfset LvarOUT_XML.ID		= "0">
			<cfset LvarOUT_XML.MSG		= cfcatch.Message>
			<cfset LvarOUT_XML.XML_OE	= "">
			<cfset LvarOUT_XML.XML_OD	= "">
			<cfset LvarOUT_XML.XML_OS	= "">
			
			<cfreturn LvarOUT_XML>
		</cfcatch>
		</cftry>

		<cftry>
			<cfobject name="LobjColaProcesos" component="interfacesSoin.Componentes.interfaces">

			<cfset GvarID 	= "0">
			<cfset GvarMSG	= "OK">
			<cfset GvarNI	= ARGUMENTS.Num_Interfaz>
			<cfset GvarUD	= "WS:" & session.Interfaz.UID>
			<cfset url.XML_IE = ARGUMENTS.XML_IE>	<cfset ARGUMENTS.XML_IE	= "">
			<cfset url.XML_ID = ARGUMENTS.XML_ID>	<cfset ARGUMENTS.XML_ID	= "">
			<cfset url.XML_IS = ARGUMENTS.XML_IS>	<cfset ARGUMENTS.XML_IS	= "">
			<cfif ARGUMENTS.XML_OUT>
				<cfset url.XML_OUT	= "1">
			<cfelse>
				<cfset url.XML_OUT	= "0">
			</cfif>
			<cfset url.XML_DBS	= "0">
			<cfset form.XML_DBS	= "0">
	
			<cfset LvarXML_OUT  = url.XML_OUT>
			<cfset LVarXML_DBS	= url.XML_DBS>
		
			<cfset GvarXML = LobjColaProcesos.fnProcesoNuevoExternoXML (GvarNI, GvarUD)>
		
			<cfset GvarMSG = GvarXML.MSG>
			<cfset GvarID  = GvarXML.ID>
			
		<cfcatch type="any">
			<cfset LvarMSGstackTrace = LobjColaProcesos.fnGetStackTrace(cfcatch)>
			<cfset LobjColaProcesos.fnLog("","ERROR DE ANTES DE INICIAR LA INTERFAZ (WS2:sendToSoinXML), StackTrace=#LvarMSGstackTrace#")>
		
			<cfset GvarMSG = "ERROR DE ANTES DE INICIAR LA INTERFAZ (WS2:sendToSoinXML): #cfcatch.Message# #cfcatch.Detail#">
		</cfcatch>
		</cftry>
		
		<cfif GvarMSG EQ "OK" AND LvarXML_OUT EQ "1">
			<cftry>
				<cfif GvarXML.ManejoDatos EQ "T">
					<cfset GvarXML.XML_OE = LobjColaProcesos.sbGeneraTablaToXML (GvarNI, GvarID, "O", "E", LvarXML_DBS, false)>
					<cfset GvarXML.XML_OD = LobjColaProcesos.sbGeneraTablaToXML (GvarNI, GvarID, "O", "D", LvarXML_DBS, false)>
					<cfset GvarXML.XML_OS = LobjColaProcesos.sbGeneraTablaToXML (GvarNI, GvarID, "O", "S", LvarXML_DBS, false)>
				</cfif>
			<cfcatch type="any">
			</cfcatch>
			</cftry>
		</cfif>
		
		<cfparam name="GvarXML.XML_OE" default="">
		<cfparam name="GvarXML.XML_OD" default="">
		<cfparam name="GvarXML.XML_OS" default="">

		<cfobject component="interfaz_out_xml" name="LvarOUT_XML">
		<cfset LvarOUT_XML.ID		= GvarID>
		<cfset LvarOUT_XML.MSG		= GvarMSG>
		<cfset LvarOUT_XML.XML_OE	= GvarXML.XML_OE>
		<cfset LvarOUT_XML.XML_OD	= GvarXML.XML_OD>
		<cfset LvarOUT_XML.XML_OS	= GvarXML.XML_OS>
		
		<cfreturn LvarOUT_XML>
	</cffunction>

	<cffunction name="fnAcceso" access="private" output="false">
		<cfargument name="Empresa"		type="string">
		<cfargument name="EcodigoSDC"	type="numeric">
		<cfargument name="UID"			type="string">
		<cfargument name="PWD"			type="string">
	
		<cftry>
			<cfset LvarIP = "">
			<cftry>
				<cfset LvarIP = "(IP=#GetPageContext().getRequest().getRemoteAddr()#)">
			<cfcatch type="any"></cfcatch>
			</cftry>
			<cfset form.j_username 	= session.Interfaz.UID>
			<cfset form.j_password 	= session.Interfaz.PWD>
			<cfset form.j_empresa 	= ARGUMENTS.Empresa>
			<cfset LvarEcodigoSDC 	= ARGUMENTS.EcodigoSDC>

			<cfif form.j_username EQ "" OR form.j_password EQ "">
				<cflogout>
				<cfset fnError("ERROR DE SEGURIDAD ANTES DE INICIAR LA INTERFAZ: Servicio no Autorizado (1) #LvarIP#")>
			</cfif>

			<cfif ARGUMENTS.Empresa EQ "" OR ARGUMENTS.EcodigoSDC EQ "0">
				<cfset fnError("ERROR DE SEGURIDAD ANTES DE INICIAR LA INTERFAZ: Servicio no Autorizado (2) #LvarIP#")>
			</cfif>
			
			<cfparam name="session.Interfaz.AUT" default="">
			<cfset LvarAUT = ARGUMENTS.Empresa & "," & ARGUMENTS.EcodigoSDC & "," & form.j_username>

			<cfif session.Interfaz.AUT NEQ LvarAUT>
				<cfset session.login_no_interactivo = true>
	
				<cfinclude template="/home/check/dominio.cfm">
				<cfinclude template="/home/check/autentica.cfm">
				<cfif not isdefined("session.usucodigo") or session.usucodigo eq 0>
					<cfset fnError("ERROR DE SEGURIDAD ANTES DE INICIAR LA INTERFAZ: Usuario o Password no Autenticado #LvarIP#")>
					<cfreturn>
				</cfif>

				<cfinclude template="/home/check/acceso.cfm">
				<cfif not isdefined("session.usucodigo") or session.usucodigo eq 0>
					<cfset fnError("ERROR DE SEGURIDAD ANTES DE INICIAR LA INTERFAZ: Usuario no Autorizado #LvarIP#")>
				</cfif>
	
				<cfquery name="rsEmpresas" datasource="asp">
					select distinct p.Ecodigo as EcodigoSDC, Enombre, 
						'#trim(session.datos_personales.Nombre) & " " & trim(session.datos_personales.Apellido1) & " " & trim(session.datos_personales.Apellido2)#' as Nombre
					  from vUsuarioProcesos p
						   inner join Empresa e 
							  on CEcodigo = #Session.CEcodigo#
							 and p.Ecodigo = e.Ecodigo
					 where Usucodigo=#Session.Usucodigo#
					   and p.Ecodigo = #LvarEcodigoSDC#
				</cfquery>
				<cfif rsEmpresas.recordCount NEQ 1>
					<cfset fnError("ERROR DE SEGURIDAD ANTES DE INICIAR LA INTERFAZ: Empresa no Autorizada #LvarIP#")>
				</cfif>
				<cfset CreateObject("Component","/home/check/functions").seleccionar_empresa(rsEmpresas.EcodigoSDC)>
				<cfset session.Interfaz.AUT = LvarAUT>

				<!--- ACTUALIZA DSINFO --->
				<cfset CreateObject("Component","/interfacesSoin/Componentes/interfaces").sbDSINFO()>
			</cfif>
		<cfcatch type="any">
			<cfset fnError(#cfcatch.Message#)>
		</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="fnError" access="private" output="false">
		<cfargument name="MSG" type="string">
		
		<cfthrow message="#MSG#">
	</cffunction>
</cfcomponent>



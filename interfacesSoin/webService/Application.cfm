<cftry> 
	<cfapplication name="SIF_ASP" 
		sessionmanagement="Yes"
		clientmanagement="No"
		setclientcookies="Yes"
		sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
		
	<cfsetting 	enablecfoutputonly="yes" 
				requesttimeout="36000">
	<cfset res = setLocale("English (Canadian)")>
	<cfheader name = "Expires" value = "0">
	<cfparam name="Session.Idioma" default="ES_CR">
	
	<cfset LvarIP = "">
	<cftry>
		<cfset LvarIP = "(IP=#GetPageContext().getRequest().getRemoteAddr()#)">
	<cfcatch type="any"></cfcatch>
	</cftry>
	<cfset GvarMSG = "OK">

	<cfparam name="form.AU" 	default="">
	<cfparam name="form.NI" 	default="">
	<cfparam name="form.ID" 	default="">

	<cfparam name="url.AU" 		default="#form.AU#">
	<cfparam name="url.NI" 		default="#form.NI#">
	<cfparam name="url.ID" 		default="#form.ID#">

	<cfparam name="form.XML_OUT" default="0">
	<cfparam name="form.XML_DBS" default="0">
	<cfparam name="url.XML_OUT"	default="#form.XML_OUT#">
	<cfparam name="url.XML_DBS"	default="#form.XML_DBS#">

	<cfset url.WS_XML = (isdefined("form.XML_IE") OR isdefined("url.XML_IE"))>
	<cfif url.WS_XML>
		<cfparam name="form.XML_IE" default="">
		<cfparam name="form.XML_ID" default="">
		<cfparam name="form.XML_IS" default="">
		<cfparam name="url.XML_IE" 	default="#form.XML_IE#">
		<cfset form.XML_IE = "">
		<cfparam name="url.XML_ID" 	default="#form.XML_ID#">
		<cfset form.XML_ID = "">
		<cfparam name="url.XML_IS" 	default="#form.XML_IS#">
		<cfset form.XML_IS = "">
	</cfif>
	
	<cfparam name="session.AU" 	default="">
	
	<cfobject type = "Java"	action = "Create" class = "java.lang.Integer" name = "LobjInteger">

	<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" />
	
	<cfif url.AU EQ "" or url.NI EQ "" or url.ID EQ "">
		<cfset fnError("ERROR DE SEGURIDAD ANTES DE INICIAR LA INTERFAZ: Servicio no Autorizado (1) #LvarIP#")>
	</cfif>
	
	<cfset GvarNI = url.NI>
	<cfset GvarID = url.ID>
	<cfset GvarUD = "">

	<cfset LvarAU = fnDecodificar(url.AU, url.NI, url.ID)>
	<cfset GvarUD = listGetAt(LvarAU,5)>
		
	<!--- LvarAUstr = copia de LvarAU sin password ni usuario BD para guardar en session --->
	<cfset LvarAUstr = listDeleteAt(LvarAU,5)>
	<cfset LvarAUstr = listDeleteAt(LvarAUstr,4)>

	<cfif session.AU NEQ LvarAUstr>
		<cfset session.AU = LvarAUstr>
	
		<cfset LvarAU = listToArray(LvarAU)>
		<cfif arraylen(LvarAU) NEQ 5>
			<cfset fnError("ERROR DE SEGURIDAD ANTES DE INICIAR LA INTERFAZ: Servicio no Autorizado (2) #LvarIP#")>
		</cfif>

		<cfif not isdefined("session.usucodigo") or session.usucodigo eq 0 or not isdefined("session.lastAutentica") or session.lastAutentica NEQ url.AUT>
			<cfset session.login_no_interactivo = true>
			<cfset form.j_empresa 	= LvarAU[1]>
			<cfset LvarEcodigoSDC 	= LvarAU[2]>
			<cfset form.j_username 	= LvarAU[3]>
			<cfset form.j_password 	= LvarAU[4]>
			<cfinclude template="/home/check/dominio.cfm">
			<cfinclude template="/home/check/autentica.cfm">
			<cfif not isdefined("session.usucodigo") or session.usucodigo eq 0>
				<cfset fnError("ERROR DE SEGURIDAD ANTES DE INICIAR LA INTERFAZ: Usuario o Password no Autenticado #LvarIP#")>
			</cfif>
			<!---  
			--->
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

			<!--- ACTUALIZA DSINFO --->
			<cfset CreateObject("Component","/interfacesSoin/Componentes/interfaces").sbDSINFO()>
		</cfif>
	</cfif>
<cfcatch type="any">
	<cfset fnError("ERROR DE SEGURIDAD ANTES DE INICIAR LA INTERFAZ:  #LvarIP# #cfcatch.Message# #cfcatch.Detail#")>
</cfcatch>
</cftry>

<cffunction name="fnDecodificar" access="private" returntype="string" output="true">
	<cfargument name="AU" type="string" required="yes">
	<cfargument name="NI" type="string" required="yes">
	<cfargument name="ID" type="string" required="yes">
	
	<cfif not isnumeric(NI) or not isnumeric(ID)>
		<cfreturn "">
	</cfif>
	
    <cfset LvarPos = 2*(1+(ID mod (len(AU)/2-2)))-1>
	<cfset LvarXorC = 1>
	<cfset LvarRnd = LobjInteger.valueOf(mid(AU,LvarPos,2), 16)>
	<cfset LvarXor = LobjInteger.valueOf(mid(AU,LvarPos+2,2), 16)>
	<cfset LvarAU = "">
	<cfloop index="i" from="1" to="#len(AU)#" step="2">
		<cfif i EQ LvarPos OR i EQ LvarPos+2>
		<cfelse>
			<cfset LvarChar = LobjInteger.valueOf(mid(AU,i,2),16)>
			<cfset LvarXorC = BitXor(LvarXorC, LvarChar)>
			<cfset LvarChar = BitXor(LvarChar, LvarRnd)>
			<cfset LvarAU = LvarAU & chr(LvarChar)>
		</cfif>
	</cfloop>

	<cfset LvarAU = toString(LvarAU.getBytes("ISO-8859-1"),"UTF-8")>
	<cfreturn LvarAU>
</cffunction>

<cffunction name="fnError" access="private">
	<cfargument name="msg" type="string" required="yes">

	<cfset GvarMSG = Arguments.msg>
	<cflog file="InterfacesSoin#DateFormat(now(),'YYYYMMDD')#" text="ID=#url.ID#, Interfaz=#url.NI#, MSG=#GvarMSG#">
	<cfheader name="SOIN-MSG" value="#URLEncodedFormat(GvarMSG)#">
	<cfinclude template="interfaz-service-form.cfm">
	<cfset session.AU = "">
	<cfabort>
</cffunction>
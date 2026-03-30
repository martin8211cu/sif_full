<cfcomponent>
	<cffunction name="sendToSoin" 		access="remote" output="false" returntype="string">
		<cfargument name="Autenticacion"	type="string">
		<cfargument name="Num_Interfaz"		type="string">
		<cfargument name="ID_Proceso"		type="string">

		<cftry>
			<cfset fnAcceso(Arguments.Autenticacion)>
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

		<cfreturn fnAjustaMSG(GvarMSG)>
	</cffunction>

	<cffunction name="sendToSoinXML"	access="remote" output="false" returntype="string">
		<cfargument name="Autenticacion"	type="string">
		<cfargument name="Num_Interfaz"		type="string">
		<cfargument name="Parametros"		type="string">

		<cftry>
			<cfset fnAcceso(Arguments.Autenticacion)>
		<cfcatch type="any">
			<cfreturn ",Error de Acceso: #fnAjustaMSG("#cfcatch.Message# #cfcatch.Detail#")#">
		</cfcatch>
		</cftry> 

		<cfif Num_Interfaz NEQ "17" AND Num_Interfaz NEQ "19">
			<cfreturn ",NO SE PUEDE PROCESAR LA INTERFAZ: Sólo se ha implementado las Interfaces 17 y 19 invocada con sendToSoinXML">
		</cfif>
		
		<cftry>
			<!-----------------------------------------------------------------------------------------------------------------------------------------------------
			GENERA CUENTA FINANCIERA
			------------------------------------------------------------------------------------------------------------------------------------------------------->
			<cfif Num_Interfaz EQ "17">
				<cfset LvarCFcuenta		= 0>
				<cfif listLen(Arguments.Parametros) NEQ 4 AND listLen(Arguments.Parametros) NEQ 5>
					<cfreturn ",NO SE PUEDE PROCESAR LA INTERFAZ 17: Parametros: Cuenta,Oficina,YYYY-MM-DD,{G,V}[,1]">
				</cfif>
				<cfset LvarCFformato	= trim(listGetAt(Arguments.Parametros,1))>
				<cfset LvarOficodigo	= trim(listGetAt(Arguments.Parametros,2))>
				<cfset LvarFecha		= trim(listGetAt(Arguments.Parametros,3))>
				<cfset LvarModo			= trim(listGetAt(Arguments.Parametros,4))>

				<cfif listLen(Arguments.Parametros) EQ 4>
					<cfset LvarFormatear	= false>
				<cfelseif listLen(Arguments.Parametros) EQ 5>
					<cfset LvarFormatear	= trim(listGetAt(Arguments.Parametros,5)) EQ "1">
				</cfif>

				<cfif LvarFormatear>
					<cftry>
						<cfset LvarCFformato = replace(LvarCFformato,"-","","ALL")>
						<cfquery name="rs" datasource="sifinterfaces">
							set nocount on 
							declare @MSG	varchar(1024)
							declare @Cuenta	varchar(100)
							select  @MSG = 'Parse OK'
							exec sp_ParseaCuenta
								   @Mayor       = '#mid(LvarCFformato,1,4)#',
								   @Detalle     = '#mid(LvarCFformato,5,100)#',
								   @CFformato   = @Cuenta output,
								   @MSG         = @MSG output
							select @MSG as MSG, @Cuenta as CFformato
							set nocount off
						</cfquery>
						<cfif rs.MSG NEQ "Parse OK">
							<cfreturn ",#fnAjustaMSG(rs.MSG)#">
						</cfif>
						<cfif trim(rs.CFformato) EQ "">
							<cfreturn ",Error al formatear la cuenta: Generó formato vacío">
						</cfif>
						<cfset LvarCFformato = trim(rs.CFformato)>
					<cfcatch type="any">
						<cfreturn ",Error al formatear la cuenta: #fnAjustaMSG("#cfcatch.Message# #cfcatch.Detail#")#">
					</cfcatch>
					</cftry>
				</cfif>
				
				<cfif LvarModo EQ "G">
					<cfset LvarCFcuenta	= "">
				<cfelse>
					<!---  Verificar si la cuenta existe ya --->
					<cfquery name="rsSQL" datasource="sifinterfaces">
						select 	CFcuenta, CTAMOV as CFmovimiento,
								Ccuenta, Cmayor
						  from CFinanciera
						 where CFformato = '#LvarCFformato#'
						   and Ecodigo = #session.Ecodigo#
					</cfquery>
					<cfset LvarCFcuenta	= rsSQL.CFcuenta>
				</cfif>

				<cfif LvarCFcuenta NEQ "">
					<!---  Si la cuenta ya existe: solo ejecuta validación --->
					<cfset LvarCFcuenta = rsSQL.CFcuenta>
					<cfquery name="rs" datasource="sifinterfaces">
						set nocount on 
						declare @MSG varchar(1024)
						select  @MSG = 'LA CUENTA NO SE PUDO VALIDAR ...'
						exec sp_ValidaCuentaExistente
								  @Ecodigo		= #session.Ecodigo#
								, @CFcuenta		= #rsSQL.CFcuenta#
								, @Ccuenta		= #rsSQL.Ccuenta#
								, @Oficodigo	= '#LvarOficodigo#'
								, @CFformato	= '#LvarCFformato#' 
								, @Cmayor		= '#rsSQL.Cmayor#'
								, @Cdetalle		= '#replace(mid(LvarCFformato,6,100),"-","","ALL")#'
								, @Cmovimiento	= '#rsSQL.CFmovimiento#'
								, @Fecha		= '#dateFormat(LvarFecha,"YYYYMMDD")#'
								, @MSG_sal		= @MSG output
								, @GenError		= 'N'
						select @MSG as MSG
						set nocount off
					</cfquery>

					<cfset LvarMSG	= rs.MSG>

					<cfif LvarMSG NEQ "OK">
						<cfreturn ",#fnAjustaMSG(LvarMSG)#">
					</cfif>
				<cfelse>
					<cfif LvarOficodigo NEQ "-1">
						<cfquery name="rsSQL" datasource="#session.dsn#">
							select Ocodigo 
							  from Oficinas
							 where Ecodigo = #session.Ecodigo#
							   and Oficodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarOficodigo#">
						</cfquery> 

						<cfif rsSQL.Ocodigo EQ "">
							<cfreturn ",Código de Oficina no existe">
						</cfif>
						<cfset LvarOcodigo = rsSQL.Ocodigo>
					</cfif>

					<cftransaction>
						<!--- GeneraCuentaFinanciera --->
						<cfinvoke 	 component="sif.Componentes.PC_GeneraCuentaFinanciera"
									 method="fnGeneraCuentaFinanciera"
									 returnvariable="LvarMSG">
							<cfinvokeargument name="Lprm_DSN"				value="#session.dsn#"/>
							<cfinvokeargument name="Lprm_CFformato"			value="#LvarCFformato#"/>
							<cfinvokeargument name="Lprm_fecha" 			value="#LvarFecha#"/>
							<cfif LvarOficodigo NEQ -1>
								<cfinvokeargument name="Lprm_Ocodigo" 		value="#LvarOcodigo#"/>
							</cfif>
							<cfinvokeargument name="Lprm_TransaccionActiva"	value="true">
							<cfinvokeargument name="Lprm_CrearConPlan" 		value="true">
						</cfinvoke>
					</cftransaction>

					<cfif LvarMSG NEQ "NEW" AND LvarMSG NEQ "OLD">
						<cfreturn ",#fnAjustaMSG(LvarMSG)#">
					</cfif>

					<cfquery name="rsSQL" datasource="#session.dsn#">
						select CFcuenta, CFmovimiento
						  from CFinanciera
						 where CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCFformato#">
						   and Ecodigo 	 = #session.Ecodigo#
					</cfquery>

					<cfif rsSQL.CFcuenta EQ "">
						<cfreturn ",La Cuenta Financiera no se pudo crear">
					</cfif>
				</cfif>
				
				<cfif rsSQL.CFmovimiento NEQ "S">
					<cfreturn ",La Cuenta Financiera no permite movimientos">
				</cfif>

				<cfreturn "#rsSQL.CFcuenta#,OK">
			<!-----------------------------------------------------------------------------------------------------------------------------------------------------
			INTERFAZ DE CONSULTA DE ACTIVOS
			------------------------------------------------------------------------------------------------------------------------------------------------------->
			<cfelseif Num_Interfaz EQ "19">
				<cfif listLen(Arguments.Parametros) NEQ 3>
					<cfreturn ",NO SE PUEDE PROCESAR LA INTERFAZ 19: Parametros: Placa,Cedula,Control">
				</cfif>
				<cfset LvarPlaca	= listGetAt(Arguments.Parametros,1)>
				<cfset LvarCedula	= listGetAt(Arguments.Parametros,2)>
				<cfset LvarcontrolAut	= listGetAt(Arguments.Parametros,3)>

				<cfset hilerarst = "">
				<cfif isdefined("LvarCedula") and Len(LvarCedula) eq 0>
					<cfreturn ",La Cedula no existe o esta indefinida">
				</cfif>

				<cfquery datasource="#session.dsn#" name="rsCedula">
					Select DEid as Empleado
					from DatosEmpleado
					where Ecodigo = #session.Ecodigo#
					  and DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCedula#">
				</cfquery>

				<cfif rsCedula.recordcount eq 0>
					<cfreturn ",Empleado no existe">
				</cfif>

				<cfset LvarDEid = rsCedula.Empleado>

				<cfquery datasource="#session.dsn#" name="rsStActivo">
					Select Aid, Astatus, Adescripcion, Aserie, AFCcodigo
					from Activos
					where Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarPlaca#">
					  and Ecodigo = #session.Ecodigo#
				</cfquery>

				<cfif rsStActivo.recordcount GT 1>
					<cfreturn ",Existe mas de un Activo para esa Placa.  Proceso Cancelado!">
				</cfif>

				<cfif rsStActivo.recordcount EQ 1 and rsStActivo.Astatus EQ 60>
					<cfreturn ",El Activo no puede ser procesado porque se encuentra retirado">
				</cfif>

				<cfset LvarExisteInfoPlaca = false>
				<cfset LvarExistePlaca     = false>
				<cfset LvarAid = -1>

				<cfif rsStActivo.recordcount EQ 1>
					<cfset LvarExistePlaca     = true>
					<cfset LvarAid = rsStActivo.Aid>
				</cfif>

				<cfif LvarExistePlaca>
					<!--- CONSULTA LA PLACA EN ACTIVOS --->
					<cfquery datasource="#session.dsn#" name="rsPlaca">
						select 
								A.ACcodigodesc as AF2CAT, B.ACcodigodesc as AF3COD, 
								C.Adescripcion as AF4DES, F.CFcodigo as I04COD, 
								C.Aserie as AF4SER, C.AFCcodigo as TipoAct
						from Activos C
							inner join AClasificacion B
									inner join ACategoria A
									on A.Ecodigo    = B.Ecodigo
									and A.ACcodigo  = B.ACcodigo
							on  B.Ecodigo  = C.Ecodigo
							and B.ACcodigo = C.ACcodigo
							and B.ACid     = C.ACid

							inner join AFResponsables D
									inner join CFuncional F
									on F.CFid = D.CFid
									
							 on D.Aid     = C.Aid
							and D.Ecodigo = C.Ecodigo
							and D.AFRfini <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
							and D.AFRffin >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
							and D.DEid    =  #LvarDEid#
							
						where C.Aid = #LvarAid#
					</cfquery>

					<cfif rsPlaca.recordcount gt 0>
						<cfset LvarExisteInfoPlaca = true>
					</cfif>
				</cfif>

				<cfif LvarExisteInfoPlaca>
					<cfoutput query="rsPlaca">
						<cfset hilerarst = #Trim(AF2CAT)# & chr(182) & #Trim(AF3COD)# & chr(182) & #Trim(replace(AF4DES,",","","ALL"))# & chr(182) & #Trim(I04COD)# & chr(182) & #Trim(AF4SER)# & chr(182) & #Trim(TipoAct)#>
					</cfoutput>
				<cfelse>
					<!--- CONSULTA EN VALES --->
					<cfquery datasource="#session.dsn#" name="rsVPlaca">
						select 
								A.CRDRid,
								D.ACcodigodesc as AF2CAT, E.ACcodigodesc as AF3COD, 
								A.CRDRdescdetallada as AF4DES, C.CFcodigo as I04COD, 
								CRDRserie as AF4SER, A.AFCcodigo as TipoAct
						from CRDocumentoResponsabilidad A
							inner join CFuncional C
							on C.CFid = A.CFid
							
							inner join ACategoria D
							on D.ACcodigo  = A.ACcodigo
							and D.Ecodigo  = A.Ecodigo

							inner join AClasificacion E
							on 	E.ACid = A.ACid
							and E.ACcodigo = A.ACcodigo
							and E.Ecodigo  = A.Ecodigo

						where A.CRDRplaca	     	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarPlaca#">
						  and A.Ecodigo			= #session.Ecodigo#
						  and A.CRDRestado 		= 10
						  and A.DEid 			= #LvarDEid#
					</cfquery>

					<cfif rsVPlaca.recordcount gt 0>
						<cfset LvarCRDRid = rsVPlaca.CRDRid>
						<cfoutput query="rsVPlaca">
							<cfset hilerarst = #Trim(AF2CAT)# & chr(182) & #Trim(AF3COD)# & chr(182) & #Trim(replace(AF4DES,",","","ALL"))# & chr(182) & #Trim(I04COD)# & chr(182) & #Trim(AF4SER)# & chr(182) & #Trim(TipoAct)#>
						</cfoutput>
						<cfif LvarcontrolAut eq "S">
							<!--- 		Marca el activo para que no se pueda recuperar, debido a que ya fue consultado por fondos 	--->
							<cfquery datasource="#session.dsn#">
								Update CRDocumentoResponsabilidad
								set CRDRutilaux = 1
								where CRDRid = #LvarCRDRid#
							</cfquery>
						</cfif>
					<cfelse>
						<cfreturn ",No existe datos de activo asociado a la informacion digitada">
					</cfif>
				</cfif>
				
				<cfreturn "#hilerarst#,OK">
			</cfif>
		<cfcatch type="any">
			<cfreturn ",ERROR DE EJECUCION: #fnAjustaMSG("#cfcatch.Message# #cfcatch.Detail#")#">
		</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="fnAcceso" access="private" output="false">
		<cfargument name="Autenticacion"		type="string">
	
		<cftry>
			<cfset LvarIP = "">
			<cftry>
				<cfset LvarIP = "(IP=#GetPageContext().getRequest().getRemoteAddr()#)">
			<cfcatch type="any"></cfcatch>
			</cftry>

			<cfset LvarEmpresa			= listGetAt(Arguments.Autenticacion,1)>
			<cfset LvarEcodigoSDC		= listGetAt(Arguments.Autenticacion,2)>
			<cfset session.Interfaz.UID = listGetAt(Arguments.Autenticacion,3)>
			<cfset session.Interfaz.PWD = listGetAt(Arguments.Autenticacion,4)>

			<cfset form.j_username 	= session.Interfaz.UID>
			<cfset form.j_password 	= session.Interfaz.PWD>
			<cfset form.j_empresa 	= LvarEmpresa>
			<cfset LvarEcodigoSDC 	= LvarEcodigoSDC>

			<cfif form.j_username EQ "" OR form.j_password EQ "">
				<cflogout>
				<cfset fnError("ERROR DE SEGURIDAD ANTES DE INICIAR LA INTERFAZ: Servicio no Autorizado (1) #LvarIP#")>
			</cfif>

			<cfif LvarEmpresa EQ "" OR LvarEcodigoSDC EQ "0">
				<cfset fnError("ERROR DE SEGURIDAD ANTES DE INICIAR LA INTERFAZ: Servicio no Autorizado (2) #LvarIP#")>
			</cfif>
			
			<cfparam name="session.Interfaz.AUT" default="">
			<cfset LvarAUT = LvarEmpresa & "," & LvarEcodigoSDC & "," & form.j_username>

			<cfif session.Interfaz.AUT NEQ LvarAUT>
				<cfset session.login_no_interactivo = true>
	
				<cfinclude template="/home/check/dominio.cfm">
				<cfinclude template="/home/check/autentica.cfm">
				<cfif not isdefined("session.usucodigo") or session.usucodigo eq 0>
					<cfset fnError("ERROR DE SEGURIDAD ANTES DE INICIAR LA INTERFAZ: Usuario o Password no Autenticado #LvarIP#")>
					<cfreturn>
				</cfif>

				<!--- <cfinclude template="/home/check/acceso.cfm"> --->
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
			<cfset fnError("#cfcatch.Message# #cfcatch.Detail#")>
		</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="fnError" access="private" output="false">
		<cfargument name="MSG" type="string">
		
		<cfthrow message="#MSG#">
	</cffunction>

	<cffunction name="fnAjustaMSG" access="private" output="false" returntype="string">
		<cfargument name="MSG" type="string">
		
		<cfset LvarMSG = replace(Arguments.MSG,'"',"","ALL")>		<!--- Quita comillas dobles --->
		<cfset LvarMSG = replace(LvarMSG,"'","","ALL")>				<!--- Quita comillas simples --->
		<cfset LvarMSG = replace(LvarMSG,chr(10)," ","ALL")>		<!--- Quita enters --->
		<cfset LvarMSG = replace(LvarMSG,chr(13)," ","ALL")>		<!--- Quita enters --->
		<cfset LvarMSG = replace(LvarMSG,chr(9)," ","ALL")>			<!--- Quita TABS --->
		<cfset LvarMSG = replaceNoCase(LvarMSG,"<BR>"," ","ALL")>	<!--- Quita <BR> --->
		<cfset LvarMSG = replaceNoCase(LvarMSG,"<BR/>"," ","ALL")>	<!--- Quita <BR> --->
		<cfset LvarMSG = replace(LvarMSG,"&aacute;","a","ALL")>		<!--- Convierte tildes --->
		<cfset LvarMSG = replace(LvarMSG,"&eacute;","e","ALL")>		<!--- Convierte tildes --->
		<cfset LvarMSG = replace(LvarMSG,"&iacute;","i","ALL")>		<!--- Convierte tildes --->
		<cfset LvarMSG = replace(LvarMSG,"&oacute;","o","ALL")>		<!--- Convierte tildes --->
		<cfset LvarMSG = replace(LvarMSG,"&uacute;","u","ALL")>		<!--- Convierte tildes --->
		<cfset LvarMSG = replace(LvarMSG,"&nacute;","ñ","ALL")>		<!--- Convierte tildes --->
		<cfset LvarMSG = replace(LvarMSG,"&Aacute;","A","ALL")>		<!--- Convierte tildes --->
		<cfset LvarMSG = replace(LvarMSG,"&Eacute;","E","ALL")>		<!--- Convierte tildes --->
		<cfset LvarMSG = replace(LvarMSG,"&Iacute;","I","ALL")>		<!--- Convierte tildes --->
		<cfset LvarMSG = replace(LvarMSG,"&Oacute;","O","ALL")>		<!--- Convierte tildes --->
		<cfset LvarMSG = replace(LvarMSG,"&Uacute;","U","ALL")>		<!--- Convierte tildes --->
		<cfset LvarMSG = replace(LvarMSG,"&Nacute;","Ñ","ALL")>		<!--- Convierte tildes --->
		<cfloop condition="find('  ',LvarMSG)">
			<cfset LvarMSG = replace(LvarMSG,"  "," ","ALL")>		<!--- Quita spaces --->
		</cfloop>
		<cfreturn LvarMSG>
	</cffunction>
</cfcomponent>



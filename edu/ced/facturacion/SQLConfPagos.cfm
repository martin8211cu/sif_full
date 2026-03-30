<cfparam name="action" default="ConfPagos.cfm">
<!--- Aqui se busca la cuenta nueva si el usuario escoje esta opción --->
<cfif isdefined("form.btnGenerar")>
	<cfif isdefined('form.PagaEncar')>
		<cfset arrayPE = ListToArray(form.PagaEncar)>
	</cfif>

	<cfif isdefined("form.rbCta") and form.rbCta EQ 1>
		<cfset CtaNueva = "">
		<cfset encontrado = false>
			<!---Ciclo que consulta si existe esta cuenta, si no existe hace break y continua el script --->
			 <cfloop  condition="#encontrado# EQ false">
				<cfset CtaNueva = #Rand()#>
				<cfquery name="ABC_RH" datasource="#Session.Edu.DSN#">
						set nocount on
						if not exists ( select 1 from UsuarioCuenta
								where Cmaestra = <cfqueryparam value="#CtaNueva#" cfsqltype="cf_sql_char">
							)
							begin
								select 0 as existe
							end	
							else 
								select 1 as existe
							set nocount off
				</cfquery>			
				<cfif ABC_RH.existe EQ 0 >
					<cfset encontrado = true>
				</cfif>
			</cfloop> 
	</cfif>
	<cftry>
		<cfquery name="ABC_Relaciones" datasource="#Session.Edu.DSN#">
			set nocount on
			
			<cfif isdefined("form.EEcodigo") >			 
					<cfif #form.EEcodigo# NEQ "">			<!--- CAMBIO de Encargado --->
						update Encargado set 
							<cfif form.rbCta EQ 0 and isdefined("form.CboCuentaEnc")>
								EEcuenta= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CboCuentaEnc#">,
							<cfelseif form.rbCta EQ 1>
								EEcuenta= substring('<cfoutput>#CtaNueva#</cfoutput>',3,7),		
							</cfif>
							CBctacliente=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CuentaCliente#">
						where EEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEcodigo#">
						
						set nocount on
						if not exists ( select 1 from UsuarioCuenta
							where 
							<cfif form.rbCta EQ 0 and isdefined("form.CboCuentaEnc")>
								Cmaestra= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CboCuentaEnc#">
							<cfelseif form.rbCta EQ 1>
								Cmaestra= substring('<cfoutput>#CtaNueva#</cfoutput>',3,7)		
							</cfif>
						)
						begin
							insert UsuarioCuenta (Usucodigo, Ulocalizacion, Cmaestra)
							values(
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">,
								<cfif form.rbCta EQ 0 and isdefined("form.CboCuentaEnc")>
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CboCuentaEnc#">
								<cfelseif form.rbCta EQ 1>
									substring('<cfoutput>#CtaNueva#</cfoutput>',3,7)		
								</cfif>
							)
						end	
						else 
							select 1
						set nocount off
														
					<cfelse>								<!--- ALTA de Encargado --->
						insert Encargado (persona, autorizado, EEcuenta, CBctacliente)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">,
								<cfif isdefined("form.autorizadoenc")>
									1,
								<cfelse>
									0,
								</cfif>
								<cfif form.rbCta EQ 0 and isdefined("form.CboCuentaEnc")>
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CboCuentaEnc#">,
								<cfelseif form.rbCta EQ 1>
									substring('<cfoutput>#CtaNueva#</cfoutput>',3,7),		
								</cfif>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CuentaCliente#">
								)
								
					

					</cfif>
			<cfelse>	 
				select 1
			</cfif>
			set nocount off
		</cfquery>	
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
	<!--- Rodolfo Jiménez Jara, Soluciones Integrales S.A., Centro America, chm1967@yahoo.com --->
	<cftry>
		<cfquery name="ABC_Relaciones" datasource="#Session.Edu.DSN#">
			set nocount on
			<!--- Si no marca ningun encargado, debe de poner EEpago = 0, adentro marca solo los que el encargado deseea pagar --->
			update EncargadoEstudiante 
			set EEpago = 0
			where EEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEcodigo#">
			  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			<cfif isdefined('arrayPE') or  isdefined('form.PagaEncar') >
				<!--- Alumnos que reciben pagos --->
				<cfif isdefined('arrayPE') and IsArray(arrayPE) EQ true>
				
					 <cfloop index = "LoopCount" from = "1" to = "#ArrayLen(arrayPE)#"> 
						update EncargadoEstudiante 
						set EEpago = 0
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrayPE[LoopCount]#">
						  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
						
						update EncargadoEstudiante 
						set EEpago = 1
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrayPE[LoopCount]#">
						  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
						  and EEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEcodigo#">
					</cfloop>						
				<cfelseif isdefined('form.PagaEncar')>
											
						update EncargadoEstudiante 
						set EEpago = 0
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PagaEncar#">
						  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
						  
						update EncargadoEstudiante 
						set EEpago = 1
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PagaEncar#">
						  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
						  and EEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEcodigo#">							
														
				</cfif>
			<cfelse>
				select 1
			</cfif>
			set nocount off
		</cfquery>	
		<cfcatch type="any">
			<cfinclude template="../../errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
	</cftry>
	
	
	
</cfif>				

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="persona"   type="hidden" value="<cfif isdefined("Form.persona")>#form.persona#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

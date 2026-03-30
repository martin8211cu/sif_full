<cfset modo="ALTA">
	<cfif isdefined("Form.NuevoNUBE")  and isdefined("Form.Nuevo")>
    	<cflocation url="/cfmx/rh/Cloud/Empleado/windowsCreditosFiscales.cfm?DEid=#form.DEid#&modo=CAMBIObtnNuevo=NUEVO">
    </cfif>
	<cfif isdefined("Form.Nuevo")>
		<cflocation url="expediente-cons.cfm?o=3&DEid=#form.DEid#&modo=CAMBIObtnNuevo=NUEVO">
	<cfelse>
		<cftransaction>
			<cfif isdefined("Form.Alta")>
				<cfquery name="insFEmpleado" datasource="#Session.DSN#">	
					insert into FEmpleado 
					(DEid, NTIcodigo, FEidentificacion, Pid, FEnombre, FEapellido1, FEapellido2, FEfnac, FEdir, FEdiscapacitado, 
						FEfinidiscap, FEffindiscap, FEasignacion, FEfiniasignacion, FEffinasignacion, FEestudia, FEfiniestudio, 
						FEffinestudio, FEdeducrenta,FEdeducdesde,FEdeduchasta,FEidconcepto,FEsexo, FEdatos1, FEdatos2, FEdatos3, FEobs1, FEobs2, FEinfo1, FEinfo2, Usucodigo, Ulocalizacion)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NTIcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FEidentificacion#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Pid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FEnombre#">,					
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FEapellido1#">,					
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FEapellido2#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.FEfnac)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FEdir#">,
						<cfif isdefined('form.ckFEdiscapacitado')>
							1,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.FEfinidiscap)#">,
							<cfif len(trim(form.FEffindiscap)) gt 0 >
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.FEffindiscap)#">
							<cfelse>
								null
							</cfif>
							,
						<cfelse>
							0,
							null,
							null,
						</cfif>
						<cfif isdefined('form.ckFEasignacion')>
							1,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.FEfiniasignacion)#">,
							<cfif len(trim(FEffinasignacion)) gt 0 >
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.FEffinasignacion)#">
							<cfelse>
								null
							</cfif>,
						<cfelse>
							0,
							null,
							null,
						</cfif>
						<cfif isdefined('form.ckFEestudia')>
							1,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.FEfiniestudio)#">,
							<cfif len(trim(form.FEffinestudio)) gt 0 >
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.FEffinestudio)#">
							<cfelse>
								null
							</cfif>,									
						<cfelse>
							0,
							null,
							null,
						</cfif>
						
						<cfif isdefined('form.ckFEdeducrenta')>
							1,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.FEdeducdesde)#">,
							<cfif len(trim(form.FEdeduchasta)) gt 0 >
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.FEdeduchasta)#">
							<cfelse>
								<!---null---->
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="01/01/6100">
							</cfif>,									
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FEidconcepto#">,
						<cfelse>
							0,
							null,
							null,
							null,
						</cfif>
															
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FEsexo#">,
						<cfif isdefined('form.FEdatos1')>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FEdatos1#">,					
						<cfelse>
							'',
						</cfif>
						<cfif isdefined('form.FEdatos2')>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FEdatos2#">,					
						<cfelse>
							'',
						</cfif>
						<cfif isdefined('form.FEdatos3')>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FEdatos3#">,					
						<cfelse>
							'',
						</cfif>
						<cfif isdefined('form.FEobs1')>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FEobs1#">,					
						<cfelse>
							'',
						</cfif>
						<cfif isdefined('form.FEobs2')>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FEobs2#">,					
						<cfelse>
							'',
						</cfif>
						<cfif isdefined('form.FEinfo1')>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FEinfo1#">,
						<cfelse>
							'',
						</cfif>
						<cfif isdefined('form.FEinfo2')>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FEinfo2#">,
						<cfelse>
							'',
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ulocalizacion#">
						)
						<cf_dbidentity1 datasource="#Session.DSN#">
					</cfquery>
						<cf_dbidentity2 datasource="#Session.DSN#" name="insFEmpleado">
						
					<cfset modo="CAMBIO">
			<cfelseif isdefined("Form.Baja")>
				<cfquery name="delFEmpleado" datasource="#Session.DSN#">
					delete from FEmpleado
					where FElinea = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FElinea#">
				</cfquery>
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Cambio")>
				<cfquery name="updFEmpleado" datasource="#Session.DSN#">
					update FEmpleado set
						NTIcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.NTIcodigo#">,
						FEidentificacion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FEidentificacion#">,
						Pid 				= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Pid#">,
						FEnombre 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FEnombre#">,								
						FEapellido1 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FEapellido1#">,								
						FEapellido2 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FEapellido2#">,
						FEfnac 				= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.FEfnac)#">,
						FEdir 				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FEdir#">
						<cfif isdefined('form.ckFEdiscapacitado')>
							,FEdiscapacitado = 1									
							,FEfinidiscap = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.FEfinidiscap)#">
							,FEffindiscap = <cfif len(trim(form.FEffindiscap)) gt 0 ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.FEffindiscap)#"><cfelse>null</cfif>
						<cfelse>
							,FEdiscapacitado=0
							,FEfinidiscap	=null
							,FEffindiscap	=null
						</cfif>
						<cfif isdefined('form.ckFEasignacion')>
							,FEasignacion = 1									
							,FEfiniasignacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.FEfiniasignacion)#">
							,FEffinasignacion = <cfif len(trim(form.FEffinasignacion)) gt 0 ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.FEffinasignacion)#"><cfelse>null</cfif>
						<cfelse>
							,FEasignacion	=0
							,FEfiniasignacion=null
							,FEffinasignacion=null
						</cfif>
						<cfif isdefined('form.ckFEestudia')>
							,FEestudia = 1									
							,FEfiniestudio 	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.FEfiniestudio)#">
							,FEffinestudio 	= <cfif len(trim(form.FEffinestudio)) gt 0 ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.FEffinestudio)#"><cfelse>null</cfif>
						<cfelse>
							,FEestudia		=0
							,FEfiniestudio	=null
							,FEffinestudio	=null
						</cfif>
						<cfif isdefined('form.ckFEdeducrenta')>
							,FEdeducrenta = 1									
							,FEdeducdesde 	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.FEdeducdesde)#">
							,FEdeduchasta 	= <cfif len(trim(form.FEdeduchasta)) gt 0 >
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.FEdeduchasta)#">
							<cfelse>
								<!---null---->
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="01/01/6100">
							</cfif>
							<cfif isdefined('form.FEidconcepto') and form.FEidconcepto NEQ "">
								,FEidconcepto	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FEidconcepto#">									
							<cfelse>
								,FEidconcepto	= null								
							</cfif>
						<cfelse>
							,FEdeducrenta	=0
							,FEdeducdesde	=null
							,FEdeduchasta	=null
							,FEidconcepto	=null
						</cfif>								
						,FEsexo 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FEsexo#">								
						<cfif isdefined('form.FEdatos1')>
							,FEdatos1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FEdatos1#">
						</cfif>								
						<cfif isdefined('form.FEdatos2')>
							,FEdatos2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FEdatos2#">
						</cfif>								
						<cfif isdefined('form.FEdatos3')>
							,FEdatos3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FEdatos3#">
						</cfif>																
						<cfif isdefined('form.FEobs1')>
							,FEobs1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FEobs1#">									
						</cfif>								
						<cfif isdefined('form.FEobs2')>
							,FEobs2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FEobs2#">																
						</cfif>								
						<cfif isdefined('form.FEinfo1')>
							,FEinfo1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FEinfo1#">
						</cfif>
						<cfif isdefined('form.FEinfo2')>
							,FEinfo2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FEinfo2#">
						</cfif>

					where FElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Felinea#">
				</cfquery>
				<cfset modo="CAMBIO">
			</cfif>
		</cftransaction>	
	</cfif>
	
<cfif isdefined("Form.Alta")>
	<cfset vNewFam = "">
	<cfif isdefined('insFEmpleado')>
		<cfset vNewFam = insFEmpleado.identity>
		
	</cfif>
</cfif>	
           
	<cfif Session.Params.ModoDespliegue EQ 1>
		<cflocation url="expediente-cons.cfm?o=3&DEid=#form.DEid#&FElinea=#Form.Felinea#&modo=CAMBIO">	
	<cfelseif Session.Params.ModoDespliegue EQ 0>
		<cfset action = "/cfmx/rh/autogestion/autogestion.cfm">
     <cfelseif Session.Params.ModoDespliegue EQ 2 and modo EQ "ALTA">
     	<cflocation url= "/cfmx/rh/Cloud/Empleado/windowsCreditosFiscales.cfm?DEid=#form.DEid#&FElinea=#Form.Felinea#&modo=CAMBIO">
     <cfelseif Session.Params.ModoDespliegue EQ 2>
     	<cfset action = "/cfmx/rh/Cloud/Empleado/windowsCreditosFiscales.cfm">
	</cfif>

	<form action="<cfoutput>#action#</cfoutput>" method="post" name="sql">
		<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
		<input name="FElinea" type="hidden" value="<cfoutput><cfif isdefined("Form.Cambio") and isdefined("form.FElinea")>#form.FElinea#<cfelseif isdefined('vNewFam')>#vNewFam#</cfif></cfoutput>">	
		<input name="DEid" type="hidden" value="<cfif isdefined("form.DEid")><cfoutput>#form.DEid#</cfoutput></cfif>">			
		<input name="o" type="hidden" value="3">		
		<input name="sel" type="hidden" value="1">
		<input name="modo" type="hidden" value="CAMBIO">
	</form>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

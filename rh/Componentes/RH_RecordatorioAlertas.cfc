<cfcomponent>
	<!--- Hecho por: Rodolfo Jiménez --->
	<cffunction name="mensaje" returntype="string">
		<cfargument name="nombre_empresa" required="yes" type="string">
		<cfargument name="nombre_persona" required="yes" type="string">
		<cfargument name="email" required="yes" type="string">
		<cfargument name="EcodigoSDC" required="yes" type="numeric">
		<cfargument name="inicio" required="yes" type="string">
		
		<cfsavecontent variable="msj">
			<cfoutput>
			#arguments.nombre_empresa# le recuerda que a la fecha de #arguments.inicio#, estan por vencerse las alertas adjuntadas. <br>
			<font size="2">Nota: este mensaje es generado autom&aacute;ticamente por el sistema de Alerta de Acciones. Por favor no responda a este mensaje.</font>
			</cfoutput>
		</cfsavecontent>
		<cfreturn #msj# >
	</cffunction>
	

	<cffunction name="AltaAlerta" access="public" returntype="numeric" output="true">
		<cfargument name="RHTid" type="numeric" default="-1" required="yes"><!--- Id del tipo de Accion. --->
		<cfargument name="Fecha" type="string" default="" required="no">	<!--- Fecha del reporte --->
		<cfargument name="Lcache" type="string" default="" required="no">	<!--- Caché a procesar --->
		<cfargument name="empresa" type="numeric" default="0" required="no"><!--- Código de Empresa (sif) --->
		<cfargument name="empresasdc" type="numeric" default="0" required="no"><!--- Código de Empresa (asp) --->
		<cfargument name="empresa_nombre" type="string" default="" required="no"><!--- Nombre de la empresa --->

		
		<cfset contador = 0 >
		<cfquery name="data" datasource="#Lcache#">
					
			select   {fn concat({fn concat({fn concat({ fn concat(a.DEapellido1, ' ') },a.DEapellido2)}, ' ')},a.DEnombre) } as NombreCompleto,
				RHAAid  ,rhaa.RHTid ,DLlinea ,rhaa.DEid  , fdesdeaccion ,fhastaaccion ,falerta,
				recibido , rhaa.BMUsucodigo ,BMfechaalta,
				RHTdesc, rhaa.Ecodigo
			from  RHAlertaAcciones rhaa
				  inner join DatosEmpleado a
					on  a.DEid    = rhaa.DEid
					and a.Ecodigo = rhaa.Ecodigo 
					and rhaa.falerta <= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd("d",1,LSParseDateTime(Arguments.Fecha))#">
				inner join RHTipoAccion rhta
				  on rhta.RHTid = rhaa.RHTid
					 and rhta.Ecodigo = rhaa.Ecodigo
						
			where rhaa.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.empresa#">
			and rhaa.recibido = 0
			order by rhaa.RHAAid, a.DEid, rhaa.fhastaaccion
		
		</cfquery>
	
		<cfif isdefined("data") and data.RecordCount NEQ 0>
			<cfquery name="Email" datasource="#Lcache#">
				select de.DEemail, p.Pvalor, e.Ecodigo
				from UsuarioReferencia ur, DatosEmpleado de, Empresas e, RHParametros p
				where ur.STabla = 'DatosEmpleado'
				  and ur.Usucodigo = convert(numeric, p.Pvalor)
				  and convert(numeric,ur.llave) = de.DEid
				  and ur.llave is not null
				  and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.empresa#">
				  and de.Ecodigo = e.Ecodigo
				  and e.EcodigoSDC = ur.Ecodigo
				  and p.Ecodigo = e.Ecodigo
				  and p.Pcodigo = 180
				  and p.Pvalor is not null
			</cfquery>
			
			<cfif isdefined("Email") and Email.RecordCount NEQ 0>
				<cfset CorreoAdm = Email.DEemail>
			<cfelse>
				<cfset CorreoAdm = 'rodolfo@soin.co.cr'>
			</cfif>
			
			<cfset extension = "pdf">
			<cfset tempfile = GetTempDirectory() & "\VisualizaAlerta.#extension#">
			
			
			<cfinclude template="/rh/expediente/consultas/VisualizaAlerta-reporte2.cfm">
			<cftry>
				<cfmail from="#CorreoAdm#" subject="Alertas por vencer" 
				spoolenable="no" to="#CorreoAdm#"><!---#CorreoAdm#,--->
					<cfmailparam file="#tempfile#">
					<cfmailpart type="html" wraptext="72">
						<p>Señor(a)(ita)(es) Administrador(a)(ita)(es)</p>
						<br>
						
						
							#arguments.empresa_nombre# le recuerda que a la fecha de #arguments.Fecha#, estan por vencerse las alertas adjuntadas. <br>
							<font size="2">Nota: este mensaje es generado autom&aacute;ticamente por el sistema de Alerta de Acciones. Por favor no responda a este mensaje.</font>
						 
					</cfmailpart>
				</cfmail>
			<cfcatch>
				<cfdump var="#cfcatch#">
			</cfcatch>
			</cftry>
		</cfif>
		<!---<cffile action="delete" file="#tempfile#"> --->
		
		<cfset contador = contador + 1 >
		 <cfloop query="data">
			<cfif len(trim(CorreoAdm))>
				
				<cfset texto = mensaje( Arguments.empresa_nombre, data.NombreCompleto, CorreoAdm, Arguments.empresasdc, LSDateFormat(Arguments.fecha,'dd/mm/yyyy') ) >
				<!---<cfquery datasource="asp">
					insert into SMTPQueue(SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml )
					values ( 'gestion@soin.co.cr',
							 <cfqueryparam cfsqltype="cf_sql_varchar"   value="#CorreoAdm#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar"   value="Alerta de Acciones">,
							 <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#texto#">,
							 1 )
				</cfquery>--->
			</cfif>
		</cfloop>
		
		<cfreturn contador>
	</cffunction>
	
	
	<cffunction name="AddAlerta" access="public" returntype="numeric" output="true">
		<cfargument name="RHTid" type="numeric" default="-1" required="yes"><!--- Id del tipo de Accion. --->
		<cfargument name="Fecha" type="string" default="" required="no">	<!--- Fecha del reporte --->
		<cfargument name="Lcache" type="string" default="" required="no">	<!--- Caché a procesar --->
		<cfargument name="empresa" type="numeric" default="0" required="no"><!--- Código de Empresa (sif) --->
		<cfargument name="empresasdc" type="numeric" default="0" required="no"><!--- Código de Empresa (asp) --->
		<cfargument name="empresa_nombre" type="string" default="" required="no"><!--- Nombre de la empresa --->
		
		<cfargument name="DLlinea" type="numeric" default="-1" required="no">		<!--- datos laborales linea --->
		<cfargument name="DEid" type="numeric" default="-1" required="no">			<!--- Id del empleado --->
		<cfargument name="fdesdeaccion" type="string" default="" required="no">	<!--- Fecha desde --->
		<cfargument name="fhastaaccion" type="string" default="" required="no">	<!--- Fecha hasta --->
		<cfargument name="falerta" type="string" default="" required="no">		<!--- Fecha Alerta --->
		
			<cfset newId = 1>
			<cfquery datasource="#Lcache#">
				insert RHAlertaAcciones 
					( Ecodigo, RHTid, DLlinea, DEid, fdesdeaccion, fhastaaccion, falerta, recibido, BMUsucodigo, BMfechaalta)
					values (#arguments.empresa#,#arguments.RHTid#,#arguments.DLlinea#,#arguments.DEid#, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fdesdeaccion#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fhastaaccion#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.falerta#">,
					0,0,#now()#)
			</cfquery>
			
			<cfquery datasource="#Lcache#" name="rsUpd">
				Update DLaboralesEmpleado set DLalertagen=1
				where DEid = #arguments.DEid#
				and Ecodigo = #arguments.empresa#
				and DLlinea = #arguments.DLlinea#
				and RHTid = #arguments.RHTid#
			</cfquery>
			
		<cfreturn #newId#>
	
	</cffunction>
	
</cfcomponent>
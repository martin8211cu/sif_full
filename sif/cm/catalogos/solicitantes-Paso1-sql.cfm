<cfif not isdefined("Form.Nuevo")>

	<!--- Componente de Seguridad --->
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">

	<!--- 1. Hay integracion con RH --->
	<cfset integracion = false >
	<cfif isdefined("Form.Alta") or isdefined("Form.AltaEsp") or isdefined("Form.Cambio") or isdefined("Form.CambioEsp")>
		<cfquery name="rsIntegracion" datasource="#session.DSN#">
			select Pvalor 
			from Parametros 
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo=520
		</cfquery>

		<cfif rsIntegracion.RecordCount gt 0 and rsIntegracion.Pvalor eq 'S'>
			<cfset integracion = true >
		</cfif>
	</cfif>
	<!--- 1.4 Valida que el CMScodigo no exista --->
	<cfif isdefined("Form.Alta") or isdefined("Form.AltaEsp")>
		<cfquery name="valida" datasource="#session.DSN#">
			select 1 from CMSolicitantes 
			where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and CMScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMScodigo#">
		</cfquery>
		<cfif valida.RecordCount gt 0>
			<cf_errorCode	code = "50263" msg = "El Código del solicitante ya existe, por favor intente de nuevo.">
		</cfif>
	</cfif>

	<cfif isdefined("Form.Alta") or isdefined("Form.AltaEsp")>
		<!--- Valida que no inserte el mismo usuario o empleado mas de una vez--->
		<cfset ok = true >
		<!--- 1.2 Si hay integracion con RH --->
		<cfif isdefined("form.Alta")>
			<cfquery name="rsValidaExiste" datasource="asp">
				select Usucodigo 
				from UsuarioReferencia
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.EcodigoSDC#" >
				  and STabla='CMSolicitantes'
				  and Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#" >
			</cfquery>
			
			<cfif rsValidaExiste.recordCount gt 0>
				<cfset ok = false >
			</cfif>
		</cfif>	

		<cfif ok >
			<cftransaction>
				<cfquery name="insert" datasource="#Session.DSN#">
					insert into CMSolicitantes (Ecodigo, Usucodigo, DEid, CMSnombre, CMSestado, CMSfalta, CMScodigo, CFid )
						values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
								 <cfif isdefined("form.DEid") and len(trim(form.DEid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"><cfelse>null</cfif>,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.Nombre)#">,	
								 <cfif isdefined("Form.CMSestado")>1<cfelse>0</cfif>,
								 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								 <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMScodigo#">,
								 <cfif isdefined("form.CFid") and len(trim(form.CFid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#"><cfelse>null</cfif>
							   )
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="insert">
				
				<!--- Inserta un registro en CMSolicitantesCF si hay integracion con RH --->
				<cfif integracion >
					<!--- 1. Calcula Centro Funcional del Empleado --->
					<cfquery name="rsCF" datasource="#session.DSN#">
						select b.CFid 
						from LineaTiempo a
						inner join RHPlazas b
						on a.RHPid = b.RHPid
						   and a.Ecodigo=b.Ecodigo
						where a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
						  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between a.LTdesde and a.LThasta	
					</cfquery>
					<!--- Inserta en CMSolicitantesCF --->
					<cfif rsCF.RecordCount gt 0 and len(trim(rsCF.CFid)) >
						<cfquery name="insertcf" datasource="#session.DSN#">
							insert into CMSolicitantesCF(CFid, CMSid, Usucodigo, CMSCFfecha)
							values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCF.CFid#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#insert.identity#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
							 )
						</cfquery>
					</cfif>
				</cfif>
			</cftransaction>

			<!--- inserta referenciai y rol --->
			<cfset sec.insUsuarioRef(form.Usucodigo,session.EcodigoSDC,'CMSolicitantes',insert.identity)>

			<cfif isdefined("form.CMSestado")>
				<!--- Parametro 860.--->
				<!--- Si el paramtros tiene valor definido, lo asigna al comprador 
					  Si no existe el parametro o esta vacio, asigna el default SOLIC
				--->
				<cfquery name="rsRol" datasource="#session.DSN#">
					select Pvalor as rol
					from Parametros
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and Pcodigo = 860
				</cfquery>
				<cfif len(trim(rsRol.rol))>
					<cfset sec.insUsuarioRol(form.Usucodigo,session.EcodigoSDC,'SIF', trim(rsRol.rol) ) >
				<cfelse>
					<cfset sec.insUsuarioRol(form.Usucodigo,session.EcodigoSDC,'SIF','SOLIC')>
				</cfif>
			</cfif>

			<!--- Forma en que busca el codigo de usuario, usucodigo para
			 insertarlo en Solicitantes  --->
			<cfquery name="rs" datasource="#Session.DSN#">
				select a.CMSid, a.CMSestado, c.Usucodigo
				from CMSolicitantes a
					inner join Empresa b
						on b.Ereferencia = a.Ecodigo
					inner join UsuarioReferencia c
						on c.Ecodigo = b.Ecodigo
						and c.STabla = 'CMSolicitantes'
						and c.llave = <cf_dbfunction name="to_char" args="a.CMSid">
						and <cf_dbfunction name="to_number" args="c.llave"> = a.CMSid
					where a.CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insert.identity#">
			  		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			
			<cfquery name="update" datasource="#session.DSN#">
				update CMSolicitantes 
					set Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.Usucodigo#">
				where CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insert.identity#">
			
			</cfquery>
			
			
			
			
			
			<!------------------------->
			
		<cfelse>
			<cf_errorCode	code = "50264" msg = "El registro que desea insertar ya existe">
		</cfif>	
				
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="deletecf" datasource="#Session.DSN#">
			delete from CMSolicitantesCF 
			where CMSid = <cfqueryparam value="#Form.CMSid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from CMSolicitantes
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and CMSid = <cfqueryparam value="#Form.CMSid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		
		<!--- Elimina referencias de ASP --->
		<cfset sec.delUsuarioRol(form.Usucodigo,session.EcodigoSDC,'SIF','SOLIC')>
		<cfset sec.delUsuarioRef (form.Usucodigo, session.EcodigoSDC, 'CMSolicitantes')>

	<cfelseif isdefined("Form.Cambio") or isdefined("Form.CambioEsp")>
		<!---<cfif form.Usucodigo neq form._Usucodigo>
			<cfquery name="rsValidaExiste" datasource="asp">
				select Usucodigo 
				from UsuarioReferencia
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.EcodigoSDC#" >
				  and STabla='CMSolicitantes'
				  and Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#" >
			</cfquery>
			
			<cfif rsValidaExiste.recordCount gt 0>
				<cf_errorCode	code = "50265" msg = "El registro que desea modificar, ya existe.">
			</cfif>
		</cfif>--->

		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="CMSolicitantes"
			 			redirect="solicitantes.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="CMSid" 
						type2="numeric" 
						value2="#form.CMSid#"
						>
		
		<cfquery name="update" datasource="#Session.DSN#">
			update CMSolicitantes 
			set Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">,
				DEid = <cfif isdefined("form.DEid") and len(trim(form.DEid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"><cfelse>null</cfif>,
				CMSnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.Nombre)#">,
				CMSestado = <cfif isdefined("Form.CMSestado")>1<cfelse>0</cfif>,
				CMScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMScodigo#">,
				CFid      = <cfif isdefined("form.CFid") and len(trim(form.CFid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#"><cfelse>null</cfif>
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and CMSid = <cfqueryparam value="#Form.CMSid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		
		<!--- No deberia darse este caso, pues los Solicitantes no pueden ser modificados --->
		<!---
		<cfif form.Usucodigo neq form._Usucodigo>
			<cfquery name="updateReferencia" datasource="asp">
				update UsuarioReferencia
				set Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
				  and llave = <cfqueryparam value="#Form.CMSid#" cfsqltype="cf_sql_varchar">
				  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form._Usucodigo#">
				  and STabla = 'CMSolicitantes'
			</cfquery>
		</cfif>
		--->

		<cfif isdefined("form.CMSestado")>
			<cfset sec.insUsuarioRol(form.Usucodigo,session.EcodigoSDC,'SIF','SOLIC')>
		<cfelse>
			<cfset sec.delUsuarioRol(form.Usucodigo,session.EcodigoSDC,'SIF','SOLIC')>
		</cfif>

	</cfif>
</cfif><!---Form.Nuevo--->
<cfif isdefined("form.Alta")>
	<cfset Session.Compras.Solicitantes.CMSid = insert.identity>
<cfelseif isdefined("Form.Cambio")>
	<cfset Session.Compras.Solicitantes.CMSid = Form.CMSid>
<cfelseif isdefined("form.AltaEsp")>
	<cfset Session.Compras.Solicitantes.Pantalla = Session.Compras.Solicitantes.Pantalla + 1>
	<cfset Session.Compras.Solicitantes.CMSid = insert.identity>
<cfelseif isdefined("Form.CambioEsp")>
	<cfset Session.Compras.Solicitantes.Pantalla = Session.Compras.Solicitantes.Pantalla + 1>
	<cfset Session.Compras.Solicitantes.CMSid = Form.CMSid>
<cfelseif isdefined("form.Baja")>
	<cfset Session.Compras.Solicitantes.Pantalla = Session.Compras.Solicitantes.Pantalla - 1>
	<cfset Session.Compras.Solicitantes.CMSid = "">
<cfelseif isdefined("form.Nuevo")>
	<cfset Session.Compras.Solicitantes.CMSid = "">
</cfif>
<cflocation url="solicitantes.cfm">


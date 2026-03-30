<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into RHGrupoMaterias(RHGMcodigo, Descripcion, Ecodigo, RHAGMid, RHGMperiodo, BMfecha, BMUsucodigo)
				values(	<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHGMcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAGMid#" null="#Len(form.RHAGMid) EQ 0#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGMperiodo#" null="#Len(form.RHGMperiodo) Is 0#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					  )
		</cfquery>
		<cfset modo="ALTA">
	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from RHMateriasGrupo
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and RHGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGMid#">
		</cfquery>  
			
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from RHGrupoMaterias
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and RHGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGMid#">
		</cfquery>  
		<cfset modo="ALTA">

	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="RHGrupoMaterias"
			 			redirect="grupoMaterias.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="RHGMid" 
						type2="numeric" 
						value2="#form.RHGMid#">

		<cfquery name="update" datasource="#Session.DSN#">
			update RHGrupoMaterias
			set RHGMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHGMcodigo#">,
				RHAGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAGMid#" null="#Len(form.RHAGMid) EQ 0#">,
				RHGMperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGMperiodo#" null="#Len(form.RHGMperiodo) Is 0#">,
				Descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion#">
			where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
			  and RHGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGMid#" >
		</cfquery> 
		<cfset modo="CAMBIO">
	<cfelseif isdefined('form.bandBorrar') and form.bandBorrar EQ 1>
		<!--- Borrado de los cursos del grupo de cursos seleccionado --->
		
		<cfif isdefined('form.Mcodigo')>
			<cfquery datasource="#Session.DSN#">
				delete from RHMateriasGrupo
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
					and RHGMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGMid#" >
					and Mcodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#" >
			</cfquery>
		</cfif>
		
		<cfset modo="CAMBIO">
	<cfelseif isdefined('form.AgregarDet')>
		<!--- Insercion del curso para el grupo --->
		<cfif isdefined('form.Mcodigo')>
			<cfquery datasource="#Session.DSN#">
				insert into RHMateriasGrupo( Mcodigo, RHMGperiodo, RHMGimportancia, RHMGsecuencia, RHGMid, Ecodigo, BMfecha, BMUsucodigo )
				values ( 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#" >,
							<cfif Len(form.RHMGperiodo)><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMGperiodo#" ><cfelse>null</cfif>,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMGimportancia#" >,
							<cfif Len(form.RHMGsecuencia)><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMGsecuencia#" ><cfelse>0</cfif>,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGMid#" >,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">)
			</cfquery>
		</cfif>
		
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfoutput>
<form action="grupoMaterias.cfm" method="post" name="sql">
	<cfif isdefined("form.Cambio") or (isdefined('form.bandBorrar') and (form.bandBorrar EQ 1 or form.bandBorrar EQ 2))>
		<input name="RHGMid" type="hidden" value="#form.RHGMid#">
	</cfif>
</form>
</cfoutput>	

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>

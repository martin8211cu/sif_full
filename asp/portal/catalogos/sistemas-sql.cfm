<cfparam name="Form.Pagina" default="1">
<cfif not isdefined("Form.btnNuevo") and not isdefined("form.btnModulos")>

	<cfif isdefined("form.btnAgregar") or isdefined("form.btnCambiar")>
		<!--- Actualiza el orden --->
		<cfif trim(form.SSorden) neq trim(form.SSorden_2) and len(trim(form.SSorden)) gt 0>
			<cfset table = "SSistemas" >
			<cfset orden = "SSorden" >
			<cfif isdefined("form.SSorden") and len(trim(form.SSorden)) gt 0>
				<cfset where = "SSorden = #form.SSorden#">
				<cfset where_upd = "SSorden >= #form.SSorden#">
			</cfif>
			<cfinclude template="orden-sql.cfm">
		</cfif>
	</cfif>

	<cfif isdefined("Form.SScodigo") and Len(Trim(Form.SScodigo)) NEQ 0>
		<cfif isdefined("Form.btnEliminar")>
			<cfquery name="rs" datasource="asp">
				delete from SSistemas
				where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
			</cfquery>
		<cfelse>
			<cfquery name="rs" datasource="asp">
				update SSistemas 
				   set SSdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SSdescripcion#">,
				   	   SShomeuri = 	<cfif len(trim(form.SShomeuri)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SShomeuri#"><cfelse>null</cfif>,
					   SSmenu = <cfif isdefined("form.SSmenu")>1<cfelse>0</cfif>,
					   SSorden = <cfif len(trim(form.SSorden)) gt 0 ><cfqueryparam cfsqltype="cf_sql_integer" value="#form.SSorden#"><cfelse>null</cfif>,
					   <cfif Len(Trim(form.logo))>
					      SSlogo = <cf_dbupload filefield="logo" accept="image/*" datasource="asp">,
					   </cfif>
					   SShablada = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.SShablada#">
				where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
			</cfquery>
			<cflocation url="sistemas.cfm?SScodigo=#form.SScodigo#&Pagina=#URLEncodedFormat(Form.Pagina)#">
		</cfif>

	<cfelseif isdefined("Form.SScodigo_text") and Len(Trim(Form.SScodigo_text)) NEQ 0>
		<cfquery name="rs" datasource="asp">
			insert into SSistemas (SScodigo, SSdescripcion, SShomeuri, SSmenu, SSorden, SSlogo, SShablada, BMUsucodigo, BMfecha)
			values (
				<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo_text#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SSdescripcion#">,
				<cfif len(trim(form.SShomeuri)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SShomeuri#"><cfelse>null</cfif>,
				<cfif isdefined("form.SSmenu")>1<cfelse>0</cfif>,
				<cfif len(trim(form.SSorden)) gt 0 ><cfqueryparam cfsqltype="cf_sql_integer" value="#form.SSorden#"><cfelse>null</cfif>,
				<cf_dbupload filefield="logo" accept="image/*" datasource="asp">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.SShablada#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			)
		</cfquery>
		<cflocation url="sistemas.cfm?SScodigo=#form.sscodigo_text#&Pagina=#URLEncodedFormat(Form.Pagina)#">
	</cfif>
</cfif>	

<cfif isdefined("form.btnModulos")>
	<cflocation url="modulos.cfm?SScodigo=#form.SScodigo#&fSScodigo=#form.SScodigo#">
<cfelseif IsDefined("form.btnEliminar")>
	<cflocation url="sistemas.cfm?Pagina=#URLEncodedFormat(Form.Pagina)#">
</cfif>

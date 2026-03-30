
<!--- Modo ALTA --->
<cfif isdefined("Form.btnAgregar") or (isdefined('form.chkLista') and LEN(TRIM(form.chkLista)))
									or (isdefined('form.chk') and LEN(TRIM(form.chk)))>

	<!--- Averiguar si hay que agregar todos los conceptos de pago --->
	<cfif isdefined("Form.chkTodos")>

		<cfquery name="insASalarialIncidentes" datasource="#Session.DSN#">
			insert into RHASalarialIncidentes (RHASid, CIid, BMUsucodigo)
			select
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">, 
				a.CIid, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			from CIncidentes a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.CItipo <> 3
			and not exists (
				select 1
				from RHASalarialIncidentes b
				where b.RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
				and b.CIid = a.CIid
			)
		</cfquery>
		<!--- AGREGA LOS CONCEPTOS SELECCIONADOS EN EL CONLIS --->
	<cfelseif isdefined('form.chkLista') and LEN(TRIM(form.chkLista))>
		<cfset Lista_CIid = ListToArray(Replace(Form.chkLista,' ', '', 'all'),',')>
		<cfloop index="i" from="1" to="#ArrayLen(Lista_CIid)#">
			<cfset Lvar_CIid = Lista_CIid[i]>
			<!--- Chequear que el concepto de pago no haya sido insertado anteriormente --->
			<cfquery name="chkExists" datasource="#Session.DSN#">
				select 1
				from RHASalarialIncidentes
				where RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
				and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CIid#">
			</cfquery>
		
			<cfif not chkExists.recordCount>
				<cfquery name="insASalarialIncidentes" datasource="#Session.DSN#">
					insert into RHASalarialIncidentes (RHASid, CIid, BMUsucodigo)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CIid#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					)
				</cfquery>
			</cfif>
		</cfloop>
		
	<!--- Agregar solamente un concepto de pago --->
	<cfelseif isdefined("Form.CIid") and Len(Trim(Form.CIid))>
	
		<!--- Chequear que el concepto de pago no haya sido insertado anteriormente --->
		<cfquery name="chkExists" datasource="#Session.DSN#">
			select 1
			from RHASalarialIncidentes
			where RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
			and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">
		</cfquery>
	
		<cfif not chkExists.recordCount>
			<cfquery name="insASalarialIncidentes" datasource="#Session.DSN#">
				insert into RHASalarialIncidentes (RHASid, CIid, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				)
			</cfquery>
		</cfif>
	<cfelseif isdefined('form.chk') and LEN(TRIM(form.chk))>
		<cfset Lista_CIid = ListToArray(Replace(Form.chk,' ', '', 'all'),',')>
		<cfloop index="i" from="1" to="#ArrayLen(Lista_CIid)#">
			<cfset Lvar_CIid = Lista_CIid[i]>
			<cfquery name="delASalarialIncidentes" datasource="#Session.DSN#">
				delete from RHASalarialIncidentes
				where RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
				and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CIid#">
			</cfquery>
		</cfloop>
	</cfif>	
	
<!--- Modo BAJA --->
<cfelseif isdefined("Form.CIid_Del") and Len(Trim(Form.CIid_Del))>
	
	<cfquery name="delASalarialIncidentes" datasource="#Session.DSN#">
		delete from RHASalarialIncidentes
		where RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
		and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid_Del#">
	</cfquery>

</cfif>

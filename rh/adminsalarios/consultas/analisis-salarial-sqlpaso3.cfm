<cfif isdefined("form.chkdependencias")>
	<cfinvoke component="rh.Componentes.RH_Funciones" method="CFDependencias"
		CFid = "#form.CFid#"
		Nivel = 5
		returnvariable="Dependencias"/>
	<cfset Centros = ValueList(Dependencias.CFid)>
</cfif>

<!--- Modo ALTA --->
<cfif isdefined("Form.btnAgregar")>

	<!--- Averiguar si hay que agregar todos los puestos --->
	<cfif isdefined("Form.chkTodos")>

		<cfquery name="insASalarialPuestos" datasource="#Session.DSN#">
			insert into RHASalarialPuestos (RHASid, RHPcodigo, Ecodigo, EEid, RHASPperceptil, BMUsucodigo)
			select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">,
					b.RHPcodigo,
					a.Ecodigo,
					a.EEid,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHASPperceptil#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			from RHEncuestaPuesto a
				inner join RHPuestos b
				   	on b.Ecodigo = a.Ecodigo
				   	and b.RHPcodigo = a.RHPcodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">
			and not exists (
				select 1
				from RHASalarialPuestos c
				where c.RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
				and c.Ecodigo = a.Ecodigo
				and c.RHPcodigo = a.RHPcodigo
			)
		</cfquery>

	<!--- Agregar solamente un puesto --->
	<cfelseif isdefined("Form.RHPcodigo") and Len(Trim(Form.RHPcodigo)) and isdefined("Form.RHPdescpuesto") and Len(Trim(Form.RHPdescpuesto))>
	
		<!--- Chequear que el puesto no haya sido insertado anteriormente --->
		<cfquery name="chkExists" datasource="#Session.DSN#">
			select 1
			from RHASalarialPuestos 
			where RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">
		</cfquery>
	
		<cfif not chkExists.recordCount>
			<cfquery name="insASalarialPuestos" datasource="#Session.DSN#">
				insert into RHASalarialPuestos (RHASid, RHPcodigo, Ecodigo, EEid, RHASPperceptil, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHASPperceptil#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				)
			</cfquery>
		</cfif>
		<!--- Agregar puestos filtrados por centro funcional, tipo de puesto o centro funcional con dependencias --->
	<cfelseif isdefined('form.chkdependencias') or (isdefined('form.RHTPid') and form.RHTPid GT 0)
			or (isdefined("form.CFid") and Len(Trim(form.CFid)))>
		<cfquery name="insASalarialPuestos" datasource="#Session.DSN#">
			insert into RHASalarialPuestos (RHASid, RHPcodigo, Ecodigo, EEid, RHASPperceptil, BMUsucodigo)
			select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">,
					b.RHPcodigo,
					a.Ecodigo,
					a.EEid,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHASPperceptil#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			from RHEncuestaPuesto a
				inner join RHPuestos b
				   	on b.Ecodigo = a.Ecodigo
				   	and b.RHPcodigo = a.RHPcodigo
					<cfif isdefined('form.chkdependencias')>
					and b.CFid in (#Centros#)
					<cfelseif isdefined("form.CFid") and Len(Trim(form.CFid))>
					and b.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
					</cfif>
					<cfif isdefined('form.RHTPid') and form.RHTPid GT 0>
					and b.RHTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTPid#">
					</cfif>
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">
			and not exists (
				select 1
				from RHASalarialPuestos c
				where c.RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
				and c.Ecodigo = a.Ecodigo
				and c.RHPcodigo = a.RHPcodigo
			)
		</cfquery>	
	</cfif>
		
<!--- Modo BAJA --->
<cfelseif isdefined("Form.chk") and Len(Trim(Form.chk))>
	<cfset Lista_Puesto = ListToArray(Replace(Form.chk,' ', '', 'all'),',')>
	<cfloop index="i" from="1" to="#ArrayLen(Lista_Puesto)#">
		<cfset Lvar_Puesto = Lista_Puesto[i]>
		<cfquery name="delASalarialPuestos" datasource="#Session.DSN#">
			delete from RHASalarialPuestos
			where RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
			and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_Puesto#">
		</cfquery>
	</cfloop>
</cfif>

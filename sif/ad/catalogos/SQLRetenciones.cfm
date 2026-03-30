<cfset params="">

<cfif not isdefined("Form.Nuevo")>
	<cfif IsDefined("form.retcomp")>
		<cfset form.Ccuentaretc = "">
		<cfset form.Ccuentaretp = "">
	</cfif>
	<cfif isdefined("Form.Alta")>
		<cfquery name="rsExiste" datasource="#Session.DSN#">
			select Rcodigo 
			from Retenciones  
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and Rcodigo = <cfqueryparam value="#Form.Rcodigo#" cfsqltype="cf_sql_char">
		</cfquery>
	
		<cfif rsExiste.RecordCount eq 0>
			<cfquery name="Retenciones" datasource="#Session.DSN#">
				insert into Retenciones (
					Ecodigo, Rcodigo, Rdescripcion, Ccuentaretc,  Ccuentaretp, Rporcentaje, Conta_MonOri
					<cfif isdefined("form.chkretvar")>
						,isVariable
					</cfif>
				)
				values( 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char"    value="#trim(Form.Rcodigo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.Rdescripcion)#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentaretc#" null="#Len(Form.Ccuentaretc) is 0#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentaretp#" null="#Len(Form.Ccuentaretp) is 0#">,
						<cfif isdefined("form.chkretvar")>
							0,
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_float"   value="#Form.Rporcentaje#">,
						</cfif>
                        			<cfif isdefined("form.Conta_MonOri")>1<cfelse>0</cfif>
						<cfif isdefined("form.chkretvar")>
							,1
						</cfif>
						)
			</cfquery>					
			<cfquery name="rsPagina" datasource="#session.DSN#">
				 select Rcodigo
				 from Retenciones 
				 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				 order by Rcodigo 
			</cfquery>
			<cfset row = 1>
			<cfif rsPagina.RecordCount LT 500>
				<cfloop query="rsPagina">
					<cfif rsPagina.Rcodigo EQ form.Rcodigo>
						<cfset row = rsPagina.currentrow>
						<cfbreak>
					</cfif>
				</cfloop>
			</cfif>
			<cfset form.pagina = Ceiling(row / form.MaxRows)>
			<cfset params= params&'&Rcodigo='&form.Rcodigo&'&Empresa='&session.Ecodigo>
		<cfelse>
			<cf_errorCode	code = "50019" msg = "El código del Regristro ya Existe.">
		</cfif>
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="Retenciones" datasource="#Session.DSN#">
			delete from Retenciones
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and Rcodigo  = <cfqueryparam value="#Form.Rcodigo#" cfsqltype="cf_sql_char">
		</cfquery>
		<cfquery name="Retenciones" datasource="#Session.DSN#">
			delete from RetencionesComp
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and Rcodigo  = <cfqueryparam value="#Form.Rcodigo#" cfsqltype="cf_sql_char">
		</cfquery>
	
	<cfelseif isdefined("Form.Cambio")>
		<cfquery name="Retenciones" datasource="#Session.DSN#">
			update Retenciones set 
				Rdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.Rdescripcion)#">, 
				Ccuentaretc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentaretc#" null="#Len(Form.Ccuentaretc) is 0#">, 
				Ccuentaretp = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentaretp#" null="#Len(Form.Ccuentaretp) is 0#">,
				Rporcentaje = <cfqueryparam cfsqltype="cf_sql_float"   value="#Form.Rporcentaje#">,
                Conta_MonOri = <cfif isdefined("form.Conta_MonOri")>1<cfelse>0</cfif>
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and Rcodigo = <cfqueryparam value="#Form.Rcodigo#" cfsqltype="cf_sql_char">
		</cfquery>
		<cfset params= params&'&Rcodigo='&form.Rcodigo&'&Empresa='&session.Ecodigo>
	</cfif>
</cfif>

<cfif IsDefined("Form.Alta") or IsDefined("Form.Cambio")>
	<cfparam name="form.retsimple" default="">
	<cfif Not IsDefined("form.retcomp")>
		<cfset form.retsimple = "">
	</cfif>
	<!--- nos aseguramos que no se guarden datos de retencion compuesta --->
	<cfif isdefined("form.chkretvar")>
		<cfset form.retsimple = "">
	</cfif>
	<cfif ListContains(form.retsimple, form.Rcodigo)>
		<cfset form.retsimple = ListDeleteAt(form.retsimple, ListFind(form.retsimple, form.Rcodigo))>
	</cfif>
	<cfquery datasource="#Session.DSN#">
		delete from RetencionesComp
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and Rcodigo  = <cfqueryparam value="#Form.Rcodigo#" cfsqltype="cf_sql_char">
		  <cfif Len(Form.retsimple)>
		  and RcodigoDet not in (<cfqueryparam value="#Form.retsimple#" cfsqltype="cf_sql_char" list="yes">)
		  </cfif>
	</cfquery>
    <cfif Len(Form.retsimple)>
		<cfquery datasource="#Session.DSN#">
			insert into RetencionesComp (Ecodigo, Rcodigo, RcodigoDet)
			select
				<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#Form.Rcodigo#" cfsqltype="cf_sql_char">,
				Rcodigo
			from Retenciones
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and Rcodigo in (<cfqueryparam value="#Form.retsimple#" cfsqltype="cf_sql_char" list="yes">)
			  and Rcodigo not in (
				select RcodigoDet from RetencionesComp x
				where x.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and x.Rcodigo = <cfqueryparam value="#Form.Rcodigo#" cfsqltype="cf_sql_char"> )
		</cfquery>
	</cfif>
</cfif>

<cfif isdefined('form.filtro_Rcodigo') and form.filtro_Rcodigo NEQ ''>
	<cfset params= params&'&filtro_Rcodigo='&form.filtro_Rcodigo>	
	<cfset params= params&'&hfiltro_Rcodigo='&form.filtro_Rcodigo>		
</cfif>
<cfif isdefined('form.filtro_Rdescripcion') and form.filtro_Rdescripcion NEQ ''>
	<cfset params= params&'&filtro_Rdescripcion='&form.filtro_Rdescripcion>	
	<cfset params= params&'&hfiltro_Rdescripcion='&form.filtro_Rdescripcion>	
</cfif>		

<cflocation url="Retenciones.cfm?Pagina=#Form.Pagina##params#">






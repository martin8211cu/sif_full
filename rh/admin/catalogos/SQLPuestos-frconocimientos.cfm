<cfparam name="action" default="Puestos.cfm">

<cfif not isdefined("form.Nuevo")>
	<cfif isdefined("form.Eliminar")>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from RHConocimientosPuesto
			where RHPcodigo = (select RHPcodigo from RHPuestos
						       where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
						       and RHPcodigo ='#form.RHPcodigo#') 
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid_2#">
		</cfquery>			  
				
	<cfelseif isdefined("form.Agregar")>
		<cfquery name="RHConPuestoConsulta" datasource="#session.DSN#">
			select 1 
			from RHConocimientosPuesto a, RHPuestos b
			where a.Ecodigo = b.Ecodigo and a.RHPcodigo = b.RHPcodigo
			and b.RHPcodigo = '#form.RHPcodigo#' 
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			and a.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
		</cfquery>
		<cfif isdefined("RHConPuestoConsulta") and RHConPuestoConsulta.RecordCount EQ 0>
			<cfquery name="RHPuestoObtenerCodigo" datasource="#session.DSN#">
				select RHPcodigo from RHPuestos
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
				and RHPcodigo = '#form.RHPcodigo#'
		    </cfquery>
			<cfquery name="RHConPuestoInsert" datasource="#session.DSN#">
				insert into RHConocimientosPuesto(RHPcodigo, Ecodigo, RHCid, RHNid, RHCtipo, RHCnotamin, RHCpeso, PCid )
				values( <cfqueryparam cfsqltype="cf_sql_char" value="#RHPuestoObtenerCodigo.RHPcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHNid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCtipo#">,
						<cfif len(trim(form.RHCnotamin))>
							<cfqueryparam cfsqltype="cf_sql_float" value="#form.RHCnotamin/100#">
						<cfelse>null</cfif>,
						<cfif isdefined("form.RHCpeso") and len(trim(form.RHCpeso)) >
							<cfqueryparam cfsqltype="cf_sql_money" value="#form.RHCpeso#">
						<cfelse>1</cfif>,
						<cfif isdefined('form.PCid') and LEN(TRIM(form.PCid))>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
						<cfelse>null
						</cfif>
						 )
			</cfquery>		
		</cfif>
	<cfelseif isdefined("form.Modificar")>			
		<cfquery name="update" datasource="#session.DSN#">
			update RHConocimientosPuesto
			set RHCid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">, 
				RHNid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHNid#">, 
				RHCtipo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCtipo#">, 
				RHCnotamin 	= <cfif len(trim(form.RHCnotamin)) ><cfqueryparam cfsqltype="cf_sql_float" value="#form.RHCnotamin/100#"><cfelse>null</cfif>,
				RHCpeso 	= <cfif isdefined("form.RHCpeso") and len(trim(form.RHCpeso)) ><cfqueryparam cfsqltype="cf_sql_money" value="#form.RHCpeso#"><cfelse>1</cfif>,
				PCid 		= <cfif isdefined('form.PCid') and LEN(TRIM(form.PCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#"><cfelse>null</cfif>
			where RHPcodigo = (select RHPcodigo from RHPuestos
						       where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
						       and RHPcodigo ='#form.RHPcodigo#') 
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid_2#">
		</cfquery>
	</cfif>
</cfif>	
<cfset param = '?sel=1&o=6&RHPcodigo='&form.RHPcodigo>
<cfif isdefined("form.PageNum")><cfset param = param & '&PageNum=' & form.PageNum></cfif>
<cfif isdefined("form.Modificar")><cfset param = param & '&RHCid=' & form.RHCid></cfif>
<cflocation url="Puestos.cfm#param#">
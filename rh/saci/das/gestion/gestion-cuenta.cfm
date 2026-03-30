
<cfif isdefined("form.cpaso") and form.cpaso EQ 5  and not len(trim(Form.pkg_rep))>
	
	<!---Consulta el plazo de vencimiento en dias para los logines que estan retirados--->
	<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="plazoLogines">	
		<cfinvokeargument name="Pcodigo" value="40">
	</cfinvoke>
			
	<cfquery name="rsRepro" datasource="#session.DSN#">
		select a.Contratoid
		from ISBproducto a
			inner join ISBpaquete b
				on b.PQcodigo = a.PQcodigo
				and b.Habilitado=1
			inner join ISBcuenta c
				on c.CTid = a.CTid
				and c.Habilitado=1
				and c.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cli#">
		where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cue#">
		and a.CTcondicion not in ('C','0','X') 				<!--- Mientras el producto no esté en captura, pendiente de documentación y/o rechazado --->
		and (select count(1) 								<!---significa que al menos debe haber un servicio retirado que no este vencido---> 
			from ISBlogin z
			where z.Contratoid = a.Contratoid
			and z.Habilitado=2								<!---significa que al menos debe haber un servicio retirado que no este vencido---> 
			<!---and datediff( day, z.LGfechaRetiro, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#plazoLogines#">--->
		) > 0
		order by a.Contratoid
	</cfquery>
	
	<cfif rsRepro.recordCount GT 0>
		<cfset Form.pkg_rep = rsRepro.Contratoid>
		<cfset ExisteRepro = true>
	</cfif>
</cfif>


<table width="100%"cellpadding="2" cellspacing="0" border="0">
	<tr>
		<td valign="top" width="75%">
				<cfif isdefined("form.cpaso") and form.cpaso EQ 1>
					<cf_web_portlet_start titulo="Datos Generales">
					<cfinclude template="gestion-cuenta-datos.cfm">
					<cf_web_portlet_end> 
					
				<cfelseif isdefined("form.cpaso") and form.cpaso EQ 2>
					<cf_web_portlet_start titulo="Tareas Programadas">
						<cfinclude template="gestion-cuenta-tarea-list.cfm">
					<cf_web_portlet_end> 
				
				<cfelseif isdefined("form.cpaso") and form.cpaso EQ 3>
					<cf_web_portlet_start titulo="Cambio de Forma de Cobro">
					<cfinclude template="gestion-cobro.cfm">
					<cf_web_portlet_end> 
					
				<cfelseif isdefined("form.cpaso") and form.cpaso EQ 4>
					<cf_web_portlet_start titulo="Contactos">
					<cfinclude template="gestion-contacto.cfm">
					<cf_web_portlet_end> 
					
				<cfelseif isdefined("form.cpaso") and form.cpaso EQ 5>
					<cf_web_portlet_start titulo="Reprogramación">
					<cfinclude template="gestion-repro-producto.cfm">
					<cf_web_portlet_end> 
					
				</cfif>
		</td>
		<td valign="top"  width="25%">
			<cfinclude template="gestion-cuenta-menu.cfm">
			<br />
			
			<cfif isdefined("form.cpaso") and form.cpaso EQ 4>
				<cfinclude template="gestion-contacto-menu.cfm">
			
			<cfelseif isdefined("form.cpaso") and form.cpaso EQ 5 and ExisteRepro>
				<cfinclude template="gestion-repro-menu.cfm">
			</cfif>
		</td>
	</tr>
</table>

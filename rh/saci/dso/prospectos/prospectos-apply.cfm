<cfif isdefined("Form.Enviar") or isdefined("Form.Guardar")>

	<!--- busca si el Pid de la persona existe en la base de datos, si existe lo modifica y si no lo agrega --->
	<cfquery datasource="#Session.DSN#" name="rsVerifica">
		select count(1) existe from ISBpersona
		where Pid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Pid)#">
	</cfquery>
	
	<!--- busca el nivel mas alto de divicion politica para generar el nombre del compo de la localidad que vamos a almacenar en la tabla de personas --->
	<cfquery datasource="#Session.DSN#" name="rsDivPolitica">
		select max(DPnivel) as nivel 
		from DivisionPolitica
		where Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="CR">
	</cfquery>

	<!--- nombre del campo que posee el valor de la localidad --->
	<cfset localidad = "LCid_" & rsDivPolitica.nivel>
	
	<cfif rsDivPolitica.RecordCount eq 0>
		<cfthrow message="Error: La división política no se ha definido.">

	<cfelse>
	
		<cfif len(trim(form[localidad])) EQ false>
			<cfthrow message="Error: Debe llenar los campos de Localidad, no pueden quedar en blanco.">
		</cfif>
		
		
		<cfquery datasource="#Session.DSN#" name="rsAgentesCobertura">
		select a.AGid
		from ISBagente a
			inner join ISBagenteCobertura b
				on  b.AGid = a.AGid
				and a.Habilitado = 1
				and b.Habilitado = 1
				and a.AAprospecta=1
		Where b.LCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form[localidad]#" null="#Len(form[localidad]) Is 0#">
			order by a.AGid
	</cfquery>	
	
	<cfif isdefined('rsAgentesCobertura') and rsAgentesCobertura.RecordCount eq 0>
		<cfthrow message="Error: No se encontraron agentes que cubran la Localidad del Prospecto.">
	</cfif>
	
		
		
		<!---<cftransaction>--->
			<!--- Agrega los datos del prospecto --->	
			<cfinvoke component="saci.comp.ISBprospectos" method="Alta"  returnvariable="idReturn">
				<cfinvokeargument name="Ppersoneria" value="#form.Ppersoneria#">
				<cfinvokeargument name="Pid" value="#form.Pid#">
				<cfif form.Ppersoneria EQ 'J'>
					<cfinvokeargument name="Pnombre" value="#trim(form.PrazonSocial)#">
					<cfinvokeargument name="PrazonSocial" value="#trim(form.PrazonSocial)#">
				<cfelse>
					<cfinvokeargument name="Pnombre" value="#trim(form.Pnombre)#">
					<cfinvokeargument name="Papellido" value="#trim(form.Papellido)#">
					<cfinvokeargument name="Papellido2" value="#trim(form.Papellido2)#">
				</cfif>
				<cfif form.Ppersoneria EQ 'F' or form.Ppersoneria EQ 'J'>
					<cfinvokeargument name="Ppais" value="CR">
				<cfelse>
					<cfinvokeargument name="Ppais" value="#form.Ppais#">
				</cfif>
				<cfinvokeargument name="Pobservacion" value="#form.Pobservacion#">
				<cfinvokeargument name="Pprospectacion" value="">
				<cfif isdefined("Form.CPid") and Len(Trim(Form.CPid))>
				<cfinvokeargument name="CPid" value="#form.CPid#">
				</cfif>
				<cfinvokeargument name="Papdo" value="#form.Papdo#">
				<cfinvokeargument name="LCid" value="#form[localidad]#">
				<cfinvokeargument name="AGid" value="">
				<cfinvokeargument name="Pdireccion" value="#form.Pdireccion#">
				<cfinvokeargument name="Pbarrio" value="#form.Pbarrio#">
				<cfinvokeargument name="Ptelefono1" value="#form.Ptelefono1#">
				<cfinvokeargument name="Ptelefono2" value="#form.Ptelefono2#">
				<cfinvokeargument name="Pfax" value="#form.Pfax#">
				<cfinvokeargument name="Pemail" value="#form.Pemail#">
				<cfinvokeargument name="Pfecha" value="#now()#">
				<cfinvokeargument name="Pasignacion" value="">
				<cfinvokeargument name="conexion" value="#Session.DSN#">
			</cfinvoke>

			<cfif isdefined('idReturn') and idReturn NEQ -1>
				<!--- Asignacion de agente al nuevo prospecto --->	
				<cfinvoke component="saci.comp.ISBprospectos" method="revisaAgente">
					<cfinvokeargument name="Pquien" value="#idReturn#">
				</cfinvoke>
			</cfif>

		<!---</cftransaction>--->
		
		<cflocation url="prospectos.cfm?r=#idReturn#">
		
	</cfif>
</cfif>

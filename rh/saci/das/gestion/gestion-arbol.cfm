<cf_web_portlet_start titulo="Cuentas">
	<cfoutput>		
	<form name="formArbolGest" action="#CurrentPage#" method="get" style="margin: 0;">
		<cfinclude template="gestion-hiddens.cfm">
		<cfset id_cli="">
		<cfset id_cue="">
		<cfset id_contr="">
		<cfset id_cont="">
		<cfset id_log="">
		
		<cfif isdefined("form.cliente") and len(trim(form.cliente))>
			<cfset id_cli=form.cliente>
		</cfif>
		<cfif ExisteCuenta>		<cfset id_cue=form.CTid> 			</cfif>
		<cfif ExistePaquete>	<cfset id_contr=form.Contratoid> 	</cfif>
		<cfif ExisteContacto>	<cfset id_cont=form.Pcontacto> 		</cfif>
		<cfif ExisteLog>		<cfset id_log=form.LGnumero> 		</cfif>	
		<cf_gestionArbol
			id_cliente="#id_cli#"
			id_cuenta="#id_cue#"
			id_contrato="#id_contr#"
			id_login="#id_log#"
			id_contacto="#id_cont#"
			trafico="#ExisteTrafico#"
			form="formArbolGest"
			rol="#form.rol#"
			cambioPassword="#ExisteCambioPass#"
			AgregarServicio="#ExisteAddServicio#"
			infoServ="#ExisteInfoServ#"
			recarga="#ExisteRecarga#"
		>
	</form>
	</cfoutput>
<cf_web_portlet_end> 
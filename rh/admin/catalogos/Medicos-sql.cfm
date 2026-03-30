
<cfif isdefined("form.activo")>
	<cfset local.medicoActivo=1>
	<cfelse>
		<cfset local.medicoActivo=0>
</cfif>

<cfif isdefined("form.usucodigo") and form.usucodigo eq ''>
	<cfset form.usucodigo=0>
</cfif>

<cfif isDefined("form.alta") and form.alta eq "agregar">
	<cfset ComponenteAgenda = CreateObject("Component", "home.Componentes.Agenda")>
	<cfset local.newValue = ComponenteAgenda.CrearAgenda('R', form.nombre)>
	<cfquery name="insert" datasource="minisif">

		insert into Medicos(MEidentificacion,MEnombre,Usucodigo,MEespecialidad,MEactivo,CEcodigo,agenda)
		values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ced#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.espec#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#local.medicoActivo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#local.newValue#">
			)
	</cfquery>

	


	<cfelseif isDefined("form.cambio") and form.cambio eq "modificar">
		<cfquery name="update" datasource="minisif">
			update Medicos 
				set MEidentificacion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ced#">,
				MEnombre=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre#">,
				Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.usucodigo#">,
				MEespecialidad=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.espec#">,
				MEactivo=<cfqueryparam cfsqltype="cf_sql_bit" value="#local.medicoActivo#">
			where  MEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEid#">
			and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
		</cfquery>
	<cfelseif isDefined("form.baja") and form.baja eq "eliminar">
		<cfquery name="delete" datasource="minisif">
			delete from Medicos
				where MEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEid#">
		</cfquery>
		
</cfif>



<form id="form1" name="form1" method="post" action="Medicos.cfm">
</form>

<script type="text/javascript">
	document.form1.submit();
</script>
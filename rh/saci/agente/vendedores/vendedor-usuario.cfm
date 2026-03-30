<cfinvoke component="saci.comp.UsuarioSACI" method="init" />
<cfset botones = "">
<cfset valoresbotones = "">
<cfset tieneUsuario = false>
<cfset tieneRol = false>

<!--- Averiguar si tiene usuario --->
<cfinvoke component="saci.comp.UsuarioSACI" method="Tiene_Usuario" returnvariable="tieneUsuario">
	<cfinvokeargument name="referencia" value="#form.Pquien#">
</cfinvoke>
<cfset botones = Iif(not tieneUsuario, DE("Crear"), DE(""))>
<cfset valoresbotones = Iif(not tieneUsuario, DE("Crear Usuario"), DE(""))>

<!--- Averiguar si tiene roles --->
<cfif tieneUsuario>
	<cfinvoke component="saci.comp.UsuarioSACI" method="Tiene_Rol" returnvariable="tieneRol">
		<cfinvokeargument name="referencia" value="#form.Pquien#">
		<cfinvokeargument name="SRcodigo" value="VENDEDOR">
	</cfinvoke>
	<cfset botones = Iif(not tieneRol, DE("AsignarRol"), DE(""))>
	<cfset valoresbotones = Iif(not tieneRol, DE("Asignar Rol VENDEDOR"), DE(""))>
</cfif>

<cfset botones = botones & ",Lista">
<cfset valoresbotones = valoresbotones & ",Lista Vendedores">

<cfoutput>
	<form method="post" name="form1" action="vendedor-usuario-apply.cfm" style="margin:0">
		<cfinclude template="vendedor-hiddens.cfm">
		<input type="hidden" name="Vid" value="<cfif isdefined("form.Vid") and Len(Trim(form.Vid))>#form.Vid#<cfelseif isdefined("form.ven") and Len(Trim(form.ven))>#form.ven#</cfif>" />
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td>
				<cfset id_persona = "">
				<cfif ExisteVendedor>
					<cfset id_persona = Form.Pquien>
				</cfif>
				<cf_usuarioSACI
					id = "#id_persona#"
					form = "form1"
					cambioPass = "false"
					showId = "true"
					readonly = "true"
				>
			</td>
		  </tr>
		  <cfif Len(Trim(botones)) and Len(Trim(valoresbotones))>
		  <tr>
			<td>
				<cf_botones names="#botones#" values="#valoresbotones#" tabindex="1">
			</td>
		  </tr>
		  </cfif>
		</table>		
	</form>

	<cfif not tieneUsuario>
	<script language="javascript" type="text/javascript">
		function funcCrear() {
			return validarCreacion();
		}
	</script>
	</cfif>

</cfoutput>

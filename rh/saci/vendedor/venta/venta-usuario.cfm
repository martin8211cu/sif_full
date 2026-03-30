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
		<cfinvokeargument name="SRcodigo" value="CLIENTE">
	</cfinvoke>
	<cfset botones = Iif(not tieneRol, DE("AsignarRol"), DE(""))>
	<cfset valoresbotones = Iif(not tieneRol, DE("Asignar Rol CLIENTE"), DE(""))>
</cfif>

<cfoutput>
	<form method="post" name="form1" action="venta-usuario-apply.cfm" style="margin:0">
		<input type="hidden" name="CTid" value="<cfif isdefined("form.CTid") and Len(Trim(form.CTid))>#form.CTid#<cfelseif isdefined("form.cue") and Len(Trim(form.cue))>#form.cue#</cfif>" />
		<cfinclude template="venta-hiddens.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td>
				<cfset id_persona = "">
				<cfif ExistePersona>
					<cfset id_persona = Form.Pquien>
				</cfif>
				<!--- 
					El vendedor no debe poder cambiar el password de los usuarios de SACI
					solamente puede crear los usuarios
				--->
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

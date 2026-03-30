<cfinvoke component="saci.comp.UsuarioSACI" method="init" />
<cfset botones = "">
<cfset valoresbotones = "">
<cfset tieneUsuario = false>
<cfset tieneRol = false>

<!--- Averiguar si tiene usuario --->
<!---<cf_dump var="#form.Pquien#">--->

<cfinvoke component="saci.comp.UsuarioSACI" method="Tiene_Usuario" returnvariable="tieneUsuario">
	<cfinvokeargument name="referencia" value="#form.Pquien#">
</cfinvoke>

<cfset botones = Iif(not tieneUsuario, DE("Crear"), DE(""))>
<cfset valoresbotones = Iif(not tieneUsuario, DE("Crear Usuario"), DE(""))>

<!--- Averiguar si tiene roles --->
<cfif tieneUsuario>
	<cfinvoke component="saci.comp.UsuarioSACI" method="Tiene_Rol" returnvariable="tieneRol">
		<cfinvokeargument name="referencia" value="#form.Pquien#">
		<cfinvokeargument name="SRcodigo" value="AGENTE">
	</cfinvoke>
	<cfset botones = Iif(not tieneRol, DE("AsignarRol"), DE(""))>
	<cfset valoresbotones = Iif(not tieneRol, DE("Asignar Rol AGENTE"), DE(""))>
</cfif>

<cfset botones = botones & ",Lista">
<cfset valoresbotones = valoresbotones & ",Lista Agentes">


<cfoutput>
	<form method="post" name="form1" action="agente-usuario-apply.cfm" style="margin:0">
		<cfinclude template="agente-hiddens.cfm">
		<input type="hidden" name="AGid" value="<cfif isdefined("form.AGid") and Len(Trim(form.AGid))>#form.AGid#<cfelseif isdefined("form.ag") and Len(Trim(form.ag))>#form.ag#</cfif>" />
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td>

				<cfset id_persona = "">
				<cfif ExisteAgente>
					<cfset id_persona = Form.Pquien>
				</cfif>
							
				<cfset id_agente = "-1">
				 <cfif isdefined("Form.ag")> 
					<cfset id_agente = Form.ag>
				</cfif>
				
				
				<cf_usuarioSACI
					id = "#id_persona#"
					form = "form1"
					cambioPass = "false"
					showId = "true"
					readonly = "true"
					agente = "#id_agente#" 
				>
			
			<!---
				<cfset id_persona = "">
				<cfif ExisteAgente>
					<cfset id_persona = Form.Pquien>
				</cfif>
				
				<cf_usuarioSACI
					id = "#id_persona#"
					form = "form1"
					cambioPass = "false"
					showId = "true"
					readonly = "true"
				>
				--->
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

<cfset modoUC = 'ALTA'>
<cfif isdefined('form.EcodUsu') and len(trim(form.EcodUsu))>
	<cfset modoUC = 'CAMBIO'>
</cfif>


<cfif modoUC eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select FAlogin, BaseDatos, Servidor, Ecodigo as EcodUsu, ts_rversion
		from FAUsuario
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EcodUsu#">
	</cfquery>
	<cfset claveCambio = '=!-42/!@$%^&*?|~'>
</cfif>	
	
<cfoutput>
<form name="form1" method="post" action="usuarios_coneccion-sql.cfm">
	<table width="100%" cellpadding="3" cellspacing="0">
		<cfif isdefined('form.FAlogin_F') and len(trim(form.FAlogin_F))>
			<input type="hidden" name="FAlogin_F" value="#form.FAlogin_F#">	
		</cfif>
		<tr>
			<td align="right"><strong>Login</strong></td>
       		<td>
				<input type="text" name="FAlogin" onClick="javascript: this.select();" size="20" maxlength="30" <cfif modoUC neq 'ALTA'> readonly="true"</cfif> value="<cfif modoUC neq 'ALTA'>#trim(data.FAlogin)#</cfif>">
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Contraseña</strong></td>
        	<td>
				<input type="password" onClick="javascript: this.select();" name="FAcontrasena" size="25" maxlength="24" value=""><!--- <cfif modoUC neq 'ALTA'>#claveCambio#</cfif> --->
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Base de Datos</strong></td>
       		<td>
				<input type="text" name="BaseDatos" onClick="javascript: this.select();" size="20" maxlength="30" value="<cfif modoUC neq 'ALTA'>#trim(data.BaseDatos)#</cfif>">
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Servidor</strong></td>
        	<td>
				<input type="text" name="Servidor" onClick="javascript: this.select();" size="20" maxlength="30" value="<cfif modoUC neq 'ALTA'>#trim(data.Servidor)#</cfif>">
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modoUC neq 'ALTA'  >
					<cf_botones modo='CAMBIO'>
				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
			</td>
		</tr>
	</table>
	<cfif modoUC neq 'ALTA'>
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="EcodUsu" value="#data.EcodUsu#">
		<input type="hidden" name="ClaveActual" size="100" value="#claveCambio#">		
	</cfif>
</form>

<!-- MANEJA LOS ERRORES--->
<cf_qforms>
<script language="javascript" type="text/javascript">
<!--//
	objForm.FAlogin.description = "C&oacute;digo";
	objForm.FAcontrasena.description = "Contraseña";
	objForm.BaseDatos.description = "Base de Datos";
	objForm.Servidor.description = "Servidor";
	function validaMon(){
		return true;
	}	
	function habilitarValidacion(){
		objForm.FAlogin.required = true;
		objForm.FAcontrasena.required = true;
		objForm.BaseDatos.required = true;
		objForm.Servidor.required = true;
	}
	function deshabilitarValidacion(){
		objForm.FAlogin.required = false;
		objForm.FAcontrasena.required = false;
		objForm.BaseDatos.required = false;
		objForm.Servidor.required = false;
	}
	habilitarValidacion();
	//-->
</script>
</cfoutput>

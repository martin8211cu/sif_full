<cfif isdefined("Form.Cambio")>  
  <cfset modo="CAMBIO">
<cfelse>  
  <cfif not isdefined("Form.modo")>    
    <cfset modo="ALTA">
  <cfelseif Form.modo EQ "CAMBIO">
    <cfset modo="CAMBIO">
  <cfelse>
    <cfset modo="ALTA">
  </cfif>  
</cfif>
<cfif modo NEQ "ALTA">
	<cfquery name="rsTipoReglas" datasource="#Session.DSN#">
		select PCRGid, PCRGcodigo, Cmayor, PCRGDescripcion, PCRGorden, ts_rversion
		from PCReglaGrupo
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		And PCRGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCRGid#">
	</cfquery>
</cfif>

<form method="post" name="form1" action="TiposReglas_sql.cfm" onSubmit="javascript: return valida();">
<table align="center" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td> Código: </td>
		<td> 
			<input name="PCRGcodigo" type="text" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsTipoReglas.PCRGcodigo#</cfoutput></cfif>" size="10" maxlength="10" tabindex="1">
		</td>
	</tr>
	<tr>
		<td> Descripción: </td>
		<td> 
			<input name="PCRGDescripcion" type="text" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsTipoReglas.PCRGDescripcion#</cfoutput></cfif>" size="50" maxlength="80" tabindex="1">
		</td>
	</tr>
	
	<tr>
		<td> Cuenta Mayor: </td>
		<td> 
			<cfset ctamayor = "">
			<cfif modo NEQ 'ALTA'>
				<cfset ctamayor = rsTipoReglas.Cmayor>
			</cfif>
			<cf_sifCuentasMayor form="form1" Cmayor="Cmayor" size="30" idquery="#ctamayor#" tabindex="2">
		</td>
	</tr>
	<tr>
		<td> Orden: </td>
		<td> 
			<input type="text" name="PCRGorden" size="10" tabindex="3" style="text-align:right" onfocus="javascript: this.select();" onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" maxlength="3" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsTipoReglas.PCRGorden#</cfoutput><cfelse>0</cfif>">
		</td>
	</tr>
	<tr>
		<td colspan="2"> 
			<cfoutput>
				<cfif modo eq "ALTA">
					<cf_botones form="form1" modo="#modo#">
				<cfelse>
					<cf_botones form="form1" modo="#modo#" include="Usuarios_Adm,Reglas">
				</cfif>
			</cfoutput>
		</td>
	</tr>
    <cfset ts = "">
    <cfif modo NEQ "ALTA">
    	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" 
		artimestamp="#rsTipoReglas.ts_rversion#" returnvariable="ts">
    </cfif>
    <input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
	<input type="hidden" name="PCRGid" value="<cfif modo NEQ "ALTA">
	<cfoutput>#Form.PCRGid#</cfoutput></cfif>">
</table>
</form>
<script>
function valida(){
	if(document.form1.PCRGDescripcion.value == ''){
		alert("El campo Descripción es requerido");
		return false;
	}
	if(document.form1.Cmayor.value == ''){
		alert("La Cuenta Mayor es requerida");
		return false;
	}
	if(document.form1.PCRGorden.value == ''){
		document.form1.PCRGorden.value= "0"
	}
	return true;	
}
function funcUsuarios_Adm()
{
	document.location = "PermisosUsuarios.cfm?PCRGid=<cfif isdefined("Form.PCRGid")><cfoutput>#Form.PCRGid#</cfoutput></cfif>";
	return false;
}
function funcReglas(){
	document.location = "AdminReglas.cfm?RetTipos=1&btnElegirGrp=1&cboGrupos=<cfif isdefined("Form.PCRGid")><cfoutput>#Form.PCRGid#</cfoutput></cfif>";
	return false;
}
</script>
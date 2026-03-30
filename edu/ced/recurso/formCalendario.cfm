<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 31 de enero del 2006
	Motivo: Actualización de fuentes de educación a nuevos estándares de Pantallas y Componente de Listas.
 ---> 

<!-- Establecimiento del modo -->
<cfset modo = "ALTA">
<cfif isdefined('form.CDcodigo') and form.CDcodigo GT 0>
	<cfset modo = "CAMBIO">
</cfif>

<!--- Consultas --->
<!--- 1. Ccodigo del Calendario  --->
<cfif modo EQ "ALTA" >
	<cfquery datasource="#Session.Edu.DSN#" name="rsCalendario">
		Select convert(varchar,Ccodigo) as Ccodigo 
		from CentroEducativo 
		where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	</cfquery>
</cfif>

<!--- 1. Form  --->
<cfif modo EQ "CAMBIO" >
	<cfquery datasource="sdc" name="rsForm">
		select convert(varchar,Ccodigo) as Ccodigo,convert(varchar,CDcodigo) as CDcodigo,CDtitulo,CDdescripcion,convert(varchar,CDfecha,103) as CDfecha,CDferiado,CDabsoluto
		from CalendarioDia
		where CDcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDcodigo#">
	</cfquery>
</cfif>

<form name="form1" id="formCalendario" method="post" action="SQLCalendario.cfm"> 
	<cfoutput>
	<input name="MaxRows" type="hidden" value="<cfoutput>#form.MaxRows#</cfoutput>">
	<input name="Ccodigo" id="Ccodigo" type="hidden" value="<cfif modo EQ "ALTA"><cfoutput>#rsCalendario.Ccodigo#</cfoutput><cfelse><cfoutput>#rsForm.Ccodigo#</cfoutput></cfif>" >
	<input name="CDcodigo" id="CDcodigo" type="hidden" value="<cfif modo EQ "CAMBIO"><cfoutput>#rsForm.CDcodigo#</cfoutput></cfif>">
	<input name="Filtro_CDfecha" type="hidden" value="<cfif isdefined('form.Filtro_CDfecha')>#form.Filtro_CDfecha#</cfif>">
	<input name="Filtro_CDabsolutoIcono" type="hidden" value="<cfif isdefined('form.Filtro_CDabsolutoIcono')>#form.Filtro_CDabsolutoIcono#</cfif>">
	<input name="Filtro_CDferiadoIcono" type="hidden" value="<cfif isdefined('form.Filtro_CDferiadoIcono')>#form.Filtro_CDferiadoIcono#</cfif>">
	<input name="Filtro_CDtitulo" type="hidden" value="<cfif isdefined('form.Filtro_CDtitulo')>#form.Filtro_CDtitulo#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined('form.Pagina')>#form.Pagina#</cfif>">
	<input name="FechaIni" type="hidden" value="<cfif isdefined('Form.FechaIni')>#form.FechaIni#</cfif>">
	<input name="FechaFin" type="hidden" value="<cfif isdefined('Form.FechaFin')>#form.FechaFin#</cfif>">
	<cfif isdefined('form.Filtro_FechasMayores')><input name="FechasMayores" type="hidden" value="on"></cfif>
	</cfoutput>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr> 
			<td colspan="2" align="center" class="tituloAlterno">
				<cfif modo EQ 'CAMBIO'>
					Modificacion de Calendario 
				<cfelse>
					Ingreso de Calendario 
				</cfif> 
			</td>
		</tr>
		<tr> 
			<td align="right">Nombre:&nbsp;</td>
			<td>
				<input name="CDtitulo" type="text" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.CDtitulo#</cfoutput></cfif>" 
					id="CDtitulo" size="50" maxlength="80">
			</td>
		</tr>
		<tr> 
			<td align="right" valign="top">Descripci&oacute;n:&nbsp;</td>
			<td><textarea name="CDdescripcion" cols="48" id="CDdescripcion"><cfif modo NEQ 'ALTA'><cfoutput>#rsForm.CDdescripcion#</cfoutput></cfif></textarea></td>
		</tr>
		<tr> 
			<td align="right">Fecha:&nbsp;</td>
			<td>
				<cfif modo NEQ 'ALTA'>
					<cfset fecha = rsForm.CDfecha>
				<cfelse>
					<cfset fecha = ''>
				</cfif>
				<cf_sifcalendario name="CDfecha" value="#fecha#" >
			</td>
	  	</tr>
		<tr> 
			<td align="right">
				<input name="CDabsoluto" type="checkbox" id="CDabsoluto" 
					value="1" <cfif modo NEQ 'ALTA' and #rsForm.CDabsoluto# EQ "1">checked</cfif>>
			</td>
			<td><label for="CDabsoluto">Recurrente</label></td>
		</tr>
		<tr> 
			<td align="right">
				<input name="CDferiado" type="checkbox" id="CDferiado" 
					value="1" <cfif modo NEQ 'ALTA' and #rsForm.CDferiado# EQ "1">checked</cfif>>
			</td>
			<td><label for="CDferiado">Feriado</label></td>
		</tr>
		<tr><td colspan="2" align="center"><cf_botones modo="#modo#"></td></tr>
  </table>
</form>

<cf_qforms>

<script language="JavaScript" type="text/javascript" >
//------------------------------------------------------------------------------------------						
	function funcBaja(){
		if (confirm('Desea eliminar el registro?')){
			deshabilitarValidacion();
			return true; }
		else return false;
	}
//------------------------------------------------------------------------------------------						
	function deshabilitarValidacion() {
		objForm.CDtitulo.required = false;
		objForm.CDfecha.required = false;		
	}
//------------------------------------------------------------------------------------------						
	function habilitarValidacion() {
		objForm.CDtitulo.required = true;
		objForm.CDfecha.required = true;		
	}	
//------------------------------------------------------------------------------------------					
	objForm.CDtitulo.required = true;
	objForm.CDtitulo.description = "nombre";
	objForm.CDfecha.required = true;
	objForm.CDfecha.description = "fecha";		
//------------------------------------------------------------------------------------------		
</script>
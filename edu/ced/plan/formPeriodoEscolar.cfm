<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 01 de febrero del 2006
	Motivo: Actualizacin de fuentes de educacin a nuevos estndares de Pantallas y Componente de Listas.
 ---> 
<!-- Establecimiento del modo -->
<cfset modo = "ALTA">
<cfif isdefined('form.PEcodigo') and form.PEcodigo GT 0>
	<cfset modo = "CAMBIO">
</cfif>

<cfquery name="rsNiveles" datasource="#Session.Edu.DSN#">
	select convert(varchar, Ncodigo) as Ncodigo, Ndescripcion 
	from Nivel 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	and Ncodigo not in (
			select 	b.Ncodigo
			from PeriodoEscolar a, Nivel b
			where b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and a.Ncodigo = b.Ncodigo
			<cfif modo EQ "CAMBIO">
			and a.PEcodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
			</cfif>
			)
</cfquery>
<cfif modo NEQ "ALTA">
	<cfif isdefined("Form.PEcodigo") and len(trim("Form.PEcodigo")) NEQ 0>
		<cfquery datasource="#Session.Edu.DSN#" name="rsPeriodoEscolar">
			select PEcodigo, PEdescripcion, Ncodigo, PEorden 
			from PeriodoEscolar 
			where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
		</cfquery>
	</cfif>
<cfquery datasource="#Session.Edu.DSN#" name="rsHaySubPeriodoEscolar">
		select 1 from SubPeriodoEscolar 
		where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
	</cfquery>
</cfif>

<script language="JavaScript" type="text/JavaScript">

</script>

 
<form action="SQLPeriodoEscolar.cfm" method="post" name="form1" onSubmit="javascript:return validaForm(this);">
	<cfoutput>
	<input name="MaxRows" type="hidden" value="#form.MaxRows#">
	<input name="Pagina" type="hidden" value="<cfif isdefined('form.Pagina')>#form.Pagina#</cfif>">
	<input name="_Ncodigo" type="hidden" value="<cfif modo NEQ "ALTA">#rsPeriodoEscolar.Ncodigo#</cfif>">
	<input name="PEcodigo" type="hidden" value="<cfif modo NEQ "ALTA">#rsPeriodoEscolar.PEcodigo#</cfif>">	
	<input name="Filtro_PEdescripcion" type="hidden" value="<cfif isdefined('form.Filtro_PEdescripcion')>#form.Filtro_PEdescripcion#</cfif>">
	<input name="Filtro_PEorden" type="hidden" value="<cfif isdefined('form.Filtro_PEorden')>#form.Filtro_PEorden#</cfif>">
	<cfif modo NEQ "ALTA">
		<input name="HaySubPeriodoEscolar" type="hidden" value="#rsHaySubPeriodoEscolar.recordCount#">
	</cfif>
	</cfoutput>
	<table width="100%" align="center">
		<tr> 
			<td class="tituloAlterno" colspan="2" align="center"><font size="3"> 
				<cfif modo eq "ALTA">
					Nuevo Tipo de Curso Lectivo 
				<cfelse>
					Modificar Tipo de Curso Lectivo 
				</cfif>
				</font>
			</td>
		</tr>
		<tr valign="baseline"> 
			<td width="40%" align="right" nowrap>Descripci&oacute;n</td>
			<td width="60%">
				<input name="PEdescripcion" onfocus="javascript:this.select();"  type="text" 
					value="<cfif modo NEQ "ALTA"><cfoutput>#rsPeriodoEscolar.PEdescripcion#</cfoutput></cfif>" 
					size="50" maxlength="255" alt="La descripci&oacute;n del Nivel"> 
			</td>
		<tr valign="baseline"> 
			<td nowrap align="right">Nivel:</td>
				<td>
					<select name="Ncodigo" id="Ncodigo" <cfif modo NEQ "ALTA" and (rsHaySubPeriodoEscolar.recordCount NEQ 0)>disabled</cfif>>
					<cfoutput query="rsNiveles"> 
						<option value="#rsNiveles.Ncodigo#" <cfif modo NEQ "ALTA" and rsPeriodoEscolar.Ncodigo eq rsNiveles.Ncodigo>selected<cfelseif isdefined("Form.Ncodigo") AND form.Ncodigo EQ rsNiveles.Ncodigo>selected</cfif>>#rsNiveles.Ndescripcion# 
						</option>
					</cfoutput> 
				</select>
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="right">Orden</td>
			<td>
				<input name="PEorden" align="left" type="text" id="PEorden" size="8" maxlength="8" style="text-align: right;" 
				value="<cfif modo NEQ "ALTA"><cfoutput>#rsPeriodoEscolar.PEorden#</cfoutput></cfif>" 
				onfocus="javascript:this.value=qf(this); this.select();" onblur="javascript:fm(this,0);"  
				onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" > 
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2" align="center" nowrap><cf_botones modo="#modo#"></td></tr>
	</table>
</form>
<cf_qforms>
<script language="JavaScript">

//------------------------------------------------------------------------------------------							
	function validaForm(f) {
		if (f.Ncodigo.obj.disabled) {
			f.Ncodigo.obj.disabled = false;
		}
		return true;
	}
//------------------------------------------------------------------------------------------							
	function deshabilitarValidacion() {
		objForm.PEdescripcion.required = false;
		objForm.Ncodigo.required = false;
	}
//------------------------------------------------------------------------------------------							
	function habilitarValidacion() {
		objForm.PEdescripcion.required = true;
		objForm.Ncodigo.required = true;
	}	
//------------------------------------------------------------------------------------------							
	// Se aplica la descripción del Periodo Escolar
	// Rodolfo Jiménes Jara, SOIN de Costa Rica, 12/12/2002
	function __isTieneDependencias() {
			if (btnSelected("Baja", this.obj.form)) {
				// Valida que el Periodo Escolar no tenga dependencias con otros.
				var msg = "";

				if (new Number(this.obj.form.HaySubPeriodoEscolar.value) > 0) {
					msg = msg + "Cursos Lectivos"
				}
				if (msg != "")
				{
					this.error = "Usted no puede eliminar el Tipo de Curso Lectivo " + this.obj.form.PEdescripcion.value + " porque éste tiene asociado: " + msg + ".";
					this.obj.form.PEdescripcion.focus();
				}
		}
	}
//------------------------------------------------------------------------------------------							
	_addValidator("isTieneDependencias", __isTieneDependencias);

	<cfif modo EQ "ALTA">
		objForm.PEdescripcion.required = true;
		objForm.PEdescripcion.description = "Descripción";
		objForm.PEorden.description = "Orden";
		objForm.Ncodigo.required = true;
		objForm.Ncodigo.description = "Nivel";
	<cfelseif modo EQ "CAMBIO">
		objForm.PEdescripcion.required = true;
		objForm.PEdescripcion.description = "Descripción";
		objForm.Ncodigo.required = true;
		objForm.Ncodigo.description = "Nivel";
		objForm.PEdescripcion.validateTieneDependencias();
		// Agregar validacion de dependencias
	</cfif>
</script>
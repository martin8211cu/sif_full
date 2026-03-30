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
<cfif isdefined("url.Gcodigo") and len(trim("url.Gcodigo")) NEQ 0 and url.Gcodigo gt 0>
	<cfset form.Gcodigo = url.Gcodigo>
    <cfset modo="CAMBIO">
</cfif>
<cfif isdefined("url.Ncodigo") and len(trim("url.Ncodigo")) NEQ 0 and url.Ncodigo gt 0>
	<cfset form.Ncodigo = url.Ncodigo>
</cfif>

<cfquery datasource="#Session.Edu.DSN#" name="rsNiveles">
	select convert(varchar, Ncodigo) as Ncodigo, Ndescripcion from Nivel 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	order by Norden
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="rsGradoPromo">
	select convert(varchar, a.Ncodigo)+'|'+convert(varchar, b.Gcodigo) as Codigo, a.Ndescripcion+': '+b.Gdescripcion as Descripcion 
	from Nivel a, Grado b
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	and a.Ncodigo = b.Ncodigo
	<cfif modo NEQ "ALTA">
	and b.Gcodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Gcodigo#">
	</cfif>
	order by a.Norden, b.Gorden
</cfquery>

<cfif modo NEQ "ALTA">
	<cfquery datasource="#Session.Edu.DSN#" name="rsGrado">
		select  Gcodigo, Ncodigo, 
		       Gdescripcion, Ganual, Gorden, Ganterior, Nanterior, 
			   Gnalumnos, Gngrupos, isnull(Gtiponum,'N') as Gtiponum,
			   convert(varchar, Gpromonivel)+'|'+convert(varchar, Gpromogrado) as PromoGrado  
			   from Grado 
		where Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Gcodigo#">
	</cfquery>

	<cfquery datasource="#Session.Edu.DSN#" name="rsHayMateria">
		select 1 from Materia
		where Gcodigo  = <cfqueryparam value="#rsGrado.Gcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>

	<cfquery datasource="#Session.Edu.DSN#" name="rsHayGrupos">
		select 1 from Grado a, Nivel b, Grupo c
		where b.CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
		  and c.Gcodigo  = <cfqueryparam value="#rsGrado.Gcodigo#" cfsqltype="cf_sql_numeric">
		  and a.Ncodigo = b.Ncodigo
		  and b.Ncodigo = c.Ncodigo
		  and a.Gcodigo = c.Gcodigo
	</cfquery>

	<cfquery datasource="#Session.Edu.DSN#" name="rsHayHorario">
		select 1 from HorarioAplica 
		where Gcodigo  = <cfqueryparam value="#rsGrado.Gcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
</cfif>
<script language="JavaScript" src="../../js/utilesMonto.js"></script>
<script language="JavaScript" type="text/JavaScript">

	function validaForm(f) {
		if (f.Ncodigo.obj.disabled) {
			f.Ncodigo.obj.disabled = false;
		}
		return true;
	}
	
	function crearNuevoNivel(c) {
		if (c.value == "0") {
			c.selectedIndex = 0;
			location.href='Nivel.cfm?RegresarURL=Grado.cfm';
		}
		else if (c.value == "") 
			c.selectedIndex = 0;
	}
	
	
</script>
<form action="SQLGrado.cfm" method="post" name="form1" onSubmit="javascript:return validaForm(this);" >
 	
  <table align="center" width="100%" border="0" cellpadding="0"  cellspacing="0">
    <tr> 
      <td class="tituloAlterno" colspan="4"> 
        <cfif modo eq "ALTA">
          Nuevo Grado 
          <cfelse>
          Modificar Grado 
        </cfif>
		<input type="hidden" name="Pagina" value="<cfoutput>#form.Pagina#</cfoutput>">
			<input type="hidden" name="MaxRows" value="<cfoutput>#form.MaxRows#</cfoutput>">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td width="17%" align="right" valign="middle" nowrap> Descripci&oacute;n: </td>
      <td colspan="3"> 
        <input name="Gdescripcion" onfocus="javascript:this.select();"  type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#rsGrado.Gdescripcion#</cfoutput></cfif>" maxlength="255" alt="La descripci&oacute;n del Grado" style="width: 100%">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right"> Nivel: </td>
      <td width="28%" nowrap> 
        <!--- 	   	<cfif rsNiveles.RecordCount eq 0>
          <a href="Nivel.cfm?modulo=1" ><img src="../../Imagenes/Documentos2.gif" alt="Agregar Nivel en el Centro Educativo" border="0" align="baseline">&nbsp; 
          Agregar nuevo Nivel en el Centro Educativo</a>
		  <input name="Ncodigo" type="text" value="" size="50"  class="cajasinborde"  readonly="" maxlength="255" alt="El Nivel">
		<cfelse>	   --->
        <select name="Ncodigo" id="Ncodigo" onChange="javascript: crearNuevoNivel(this);" <cfif modo NEQ "ALTA" and (rsHayGrupos.recordCount NEQ 0 or rsHayHorario.recordCount NEQ 0 or rsHaymateria.recordCount NEQ 0)>disabled</cfif>>
          <cfoutput query="rsNiveles"> 
            <option value="#rsNiveles.Ncodigo#" <cfif modo NEQ "ALTA" and rsGrado.Ncodigo eq rsNiveles.Ncodigo>selected<cfelseif isdefined("Form.Ncodigo") AND form.Ncodigo EQ rsNiveles.Ncodigo>selected</cfif>>#rsNiveles.Ndescripcion# 
            </option>
          </cfoutput> 
          <option value="">-------------------</option>
          <option value="0">Crear Nuevo ...</option>
        </select>
        <!--- 	</cfif> --->
      </td>
      <td width="30%" nowrap>Cantidad de Grupos: </td>
      <td width="25%" nowrap> 
        <input name="Gngrupos" align="left" type="text" id="Gngrupos" size="8" maxlength="8" value="<cfif modo NEQ "ALTA"><cfoutput>#rsGrado.Gngrupos#</cfoutput></cfif>" onFocus="javascript:this.value=qf(this); this.select();" style="text-align: right;"  onBlur="javascript:fm(this,0);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Cantidad de Alumnos</td>
      <td> 
        <input name="Gnalumnos" align="left" type="text" id="Gnalumnos" size="8" maxlength="8" value="<cfif modo NEQ "ALTA"><cfoutput>#rsGrado.Gnalumnos#</cfoutput></cfif>" style="text-align: right;"  onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
      </td>
      <td>Numeraci&oacute;n para Grupo</td>
      <td> 
        <input type="radio" name="Gtiponum" value="N" <cfif modo NEQ "ALTA" and #rsGrado.Gtiponum# EQ "N">checked<cfelseif modo EQ "ALTA">checked</cfif>>
        Num&eacute;rico</td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Orden: </td>
      <td> 
        <input name="Gorden" align="left" type="text" id="Gorden" size="8" maxlength="8" value="<cfif modo NEQ "ALTA"><cfoutput>#rsGrado.Gorden#</cfoutput></cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0);" style="text-align: right;"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
      </td>
      <td>&nbsp;</td>
      <td> 
        <input type="radio" name="Gtiponum" value="A"  <cfif modo NEQ "ALTA" and #rsGrado.Gtiponum# EQ "A">checked</cfif>>
        Alfab&eacute;tico</td>
    </tr>
    <tr valign="baseline"> 
      <td colspan="2" align="right" nowrap>Siguiente Grado para Promoci&oacute;n</td>
      <td colspan="2">
        <select name="GradoPromo">
			<option value="|" <cfif modo NEQ "ALTA" and rsGrado.PromoGrado EQ "|">selected</cfif>>(Ninguno)</option>
			<cfoutput query="rsGradoPromo">
				<option value="#Codigo#" <cfif modo NEQ "ALTA" and rsGradoPromo.Codigo EQ rsGrado.PromoGrado>selected</cfif>>#Descripcion#</option>
			</cfoutput>
        </select>
      </td>
    </tr>
    <tr valign="baseline"> 
      <td colspan="4" align="center" nowrap> 
        <cf_botones modo="#modo#">
        &nbsp; <cfoutput> 
          <input type="hidden" name="Gcodigo" value="<cfif modo NEQ "ALTA">#rsGrado.Gcodigo#</cfif>">
          <input type="hidden" name="Ganual" value="<cfif modo NEQ "ALTA">#rsGrado.Ganual#</cfif>">
		  <input type="hidden" name="Filtro_Gdescripcion" value="<cfoutput>#form.Filtro_Gdescripcion#</cfoutput>">
		  <input type="hidden" name="Filtro_Gorden" value="<cfoutput>#form.Filtro_Gorden#</cfoutput>">
		  
		  <input type="hidden" name="_Ncodigo" value="<cfif modo NEQ "ALTA">#rsGrado.Ncodigo#</cfif>">
          <input type="hidden" name="Ayuda" value="1">
        </cfoutput> 
        <cfif modo NEQ "ALTA">
          <cfoutput> 
            <input type="hidden" name="HayMateria" value="#rsHayMateria.recordCount#">
            <input type="hidden" name="HayGrupos" value="#rsHayGrupos.recordCount#">
            <input type="hidden" name="HayHorario" value="#rsHayHorario.recordCount#">
          </cfoutput> 
        </cfif>
      </td>
    </tr>
  </table>

  </form>
  <cf_qforms>
<script language="JavaScript">
	_addValidator("isTieneDependencias", __isTieneDependencias);
	function habilitarValidacion() {
		objForm.Gdescripcion.required = true;
		objForm.Ncodigo.required = true;
	}
	
	function deshabilitarValidacion() {
		objForm.Gdescripcion.required = false;
		objForm.Ncodigo.required = false;
	}
	// Se aplica la descripcion del Grado 
	function __isTieneDependencias() {
		if(btnSelected("Baja", this.obj.form)) {
				// Valida que el Grado no tenga dependencias con otros.
				var msg = "";
				
				if (new Number(this.obj.form.HayMateria.value) > 0) {
					msg = msg + "materias"
				}
				if (new Number(this.obj.form.HayGrupos.value) > 0) {
					if (msg != "") msg += ', ';
					msg = msg + "grupos"
				}
				if (new Number(this.obj.form.HayHorario.value) > 0) {
					if (msg != "") msg += ', ';
					msg = msg + "horarios"
				}
				if (msg != "")
				{
					this.error = "Usted no puede eliminar el Grado " + this.obj.form.Gdescripcion.value + " porque ste tiene asociado: " + msg + ".";
					this.obj.form.Gdescripcion.focus();
				}
		}
	}

	<cfif modo EQ "ALTA">
		objForm.Gdescripcion.required = true;
		objForm.Gdescripcion.description = "Grado";
		objForm.Ncodigo.required = true;
		objForm.Ncodigo.description = "Nivel";
		objForm.Gorden.description = "Orden";
	<cfelseif modo EQ "CAMBIO">
		objForm.Gdescripcion.required = true;
		objForm.Gdescripcion.description = "Grado";
		objForm.Gdescripcion.validateTieneDependencias();
	</cfif>
//	objForm.Ncodigo.description = "El valor de Nivel";	
</script>

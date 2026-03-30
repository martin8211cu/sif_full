<cfif isdefined("url.Rconsecutivo") and len(trim(url.Rconsecutivo)) NEQ 0 and url.Rconsecutivo gt 0>
    <cfset form.Rconsecutivo = url.Rconsecutivo>
	<cfset form.Cambio="CAMBIO">
</cfif>
 
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif #Form.modo# EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>


<cfif modo NEQ "ALTA">
	<cfif isdefined("Form.Rconsecutivo") and len(trim("Form.Rconsecutivo")) NEQ 0>
		<cfquery datasource="#Session.Edu.DSN#" name="rsRecurso">
		 select  Rconsecutivo, CEcodigo , Rcodigo , Rdescripcion, Robservacion, convert(varchar,Rcapacidad) as Rcapacidad
		 from Recurso
 		 where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			  and Rconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Rconsecutivo#">
		</cfquery>
	</cfif>

</cfif>
<cfquery datasource="#Session.Edu.DSN#" name="rsCapacidad">
	select -1 as Rcapacidad , 'Todos'  as Capacidad
	union all
	select distinct Rcapacidad as Rcapacidad, convert(varchar,Rcapacidad) as Capacidad from Recurso
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
</cfquery>

<cfif modo NEQ "ALTA" and isdefined("Form.Rconsecutivo") and len(trim("Form.Rconsecutivo")) GT 0>
	<!--- 3. Validaciones de dependencias--->
	<!---  Rodolfo Jimnez Jara, SOIN, 04/12/2002 --->
	<cfquery datasource="#Session.Edu.DSN#" name="rsHayHorarioGuia">
		select 1 from HorarioGuia
		where Rconsecutivo  = <cfqueryparam value="#Form.Rconsecutivo#" cfsqltype="cf_sql_numeric">
		 
	</cfquery>
</cfif>	  

<script language="JavaScript" type="text/JavaScript">

	function funcLista() {
		deshabilitarValidacion();
		location.href = "listaInfraestructura.cfm?<cfoutput>?PageNum_Lista=#form.Pagina#&Pagina=#Form.Pagina#&Filtro_Rdescripcion=#Form.Filtro_Rdescripcion#&Filtro_Rcodigo=#Form.Filtro_Rcodigo#&Filtro_Rcapacidad=#Form.Filtro_Rcapacidad#</cfoutput>";	
		return false;
	}
	function funcNuevo(){
		deshabilitarValidacion();
		location.href = "lInfraestructura.cfm<cfoutput>?PageNum_Lista=#form.Pagina#&Pagina=#Form.Pagina#&Filtro_Rdescripcion=#Form.Filtro_Rdescripcion#&Filtro_Rcodigo=#Form.Filtro_Rcodigo#&Filtro_Rcapacidad=#Form.Filtro_Rcapacidad#</cfoutput>";	
		return false;
		}
	function funcBaja(){
		deshabilitarValidacion();
		location.href = "listaInfraestructura.cfm?<cfoutput>?PageNum_Lista=#form.Pagina#&Pagina=#Form.Pagina#&Filtro_Rdescripcion=#Form.Filtro_Rdescripcion#&Filtro_Rcodigo=#Form.Filtro_Rcodigo#&Filtro_Rcapacidad=#Form.Filtro_Rcapacidad#</cfoutput>";	
		//return false;
		}	
</script>
<!--- <script language="JavaScript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
</script> --->
<form action="SQLInfraestructura.cfm" method="post" name="form1">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td class="tituloAlterno" colspan="4" align="center"><font size="3"> 
        <cfif modo eq "ALTA">
          Nuevo Recurso: 
          <cfelse>
          Modificar Recurso 
        </cfif>
        </font></td>
    </tr>
    <tr> 
      <td width="17%" align="right">C&oacute;digo:&nbsp;</td>
      <td width="24%"><input name="Rcodigo" type="text" size="10" maxlength="10" tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#Trim(rsRecurso.Rcodigo)#</cfoutput></cfif>" onfocus="javascript:this.select();"></td>
      <td width="23%" align="right">Capacidad:&nbsp;</td>
      <td width="36%"><input name="Rcapacidad" type="text" size="10" maxlength="10" tabindex="3" style="text-align:right" value="<cfif modo NEQ "ALTA"><cfoutput>#Trim(rsRecurso.Rcapacidad)#</cfoutput></cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"></td>
    </tr>
    <tr> 
      <td align="right"> Descripci&oacute;n:&nbsp;</td>
      <td> 
        <textarea name="Rdescripcion" cols="30" rows="3" tabindex="2" onFocus="javascript:this.select();" ><cfif modo NEQ "ALTA"><cfoutput>#Trim(rsRecurso.Rdescripcion)#</cfoutput></cfif></textarea></td>
      <td align="right">Observaci&oacute;n:&nbsp;</td>
      <td> 
        <textarea name="Robservacion" cols="30" rows="3" tabindex="4" onfocus="javascript:this.select();"><cfif modo NEQ "ALTA"><cfoutput>#Trim(rsRecurso.Robservacion)#</cfoutput></cfif></textarea></td>
    </tr>
      <tr> 
      <td colspan="4" align="center" valign="baseline" nowrap> 
		 <cf_botones modo="#modo#"  include="Lista">
        <cfif modo NEQ "ALTA">
          <input type="hidden" name="Rconsecutivo" value="<cfoutput>#rsRecurso.Rconsecutivo#</cfoutput>">
        </cfif>
		<input type="hidden" name="HayHorarioGuia" value="<cfif modo NEQ "ALTA"><cfoutput>#rsHayHorarioGuia.recordCount#</cfoutput></cfif>">
		<cfoutput>
			<input name="Pagina" id="Pagina" value="#Form.Pagina#" type="hidden">
			<input name="MaxRows" id="MaxRows" value="#Form.MaxRows#" type="hidden">
			<input name="Filtro_Rdescripcion" id="Filtro_Rdescripcion" value="#Form.Filtro_Rdescripcion#" type="hidden">
			<input name="Filtro_Rcodigo" id="Filtro_Rcodigo" value="#Form.Filtro_Rcodigo#" type="hidden">
			<input name="Filtro_Rcapacidad" id="Filtro_Rcapacidad" value="#Form.Filtro_Rcapacidad#" type="hidden">
		</cfoutput>
      </td>
    </tr>
  </table>
</form>
<cf_qforms>
<script language="JavaScript">
	// Se aplica la descripcion del Grado 
	_addValidator("isTieneDependencias", __isTieneDependencias);
	function __isTieneDependencias() {
		if(btnSelected("Baja", this.obj.form)) {
				// Valida que el Grado no tenga dependencias con otros.
				var msg = "";
				//alert(new Number(this.obj.form.HayHorarioGuia.value)); 
				if (new Number(this.obj.form.HayHorarioGuia.value) > 0) {
					msg = msg + "horario de guía"
				}
				if (msg != "")
				{
					this.error = "Usted no puede eliminar el Tipo de Materia " + this.obj.form.Rdescripcion.value + " porque éste tiene asociado: " + msg + ".";
					this.obj.form.Rdescripcion.focus();
				}
		}
	}

	function deshabilitarValidacion() {
		objForm.Rdescripcion.required = false;
		objForm.Rcodigo.required = false;
	}
	
	function habilitarValidacion() {
		objForm.Rdescripcion.required = true;
		objForm.Rdescripcion.description = "Descripción";
		objForm.Rdescripcion.validateTieneDependencias();
		objForm.Rcodigo.required = true;
		objForm.Rcodigo.description = "Código";
	}
	
	
</script>


 



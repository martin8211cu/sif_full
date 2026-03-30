<!--- 
	Modificado por: E. Raúl Bravo Gómez
	Fecha: 21 de agosto del 2013
 --->

<!---<cfdump var="#form#">--->

<cfif isdefined("url.Idioma") and Len(Trim(url.Idioma))>
	<cfparam name="Form.Idioma" default="#url.Idioma#">
</cfif>
<cfif isdefined("url.CdescripcionMI") and Len(Trim(url.CdescripcionMI))>
	<cfparam name="Form.CdescripcionMI" default="#url.CdescripcionMI#">
</cfif>
<cfif isdefined("url.Cmayor") and Len(Trim(url.Cmayor))>
	<cfparam name="Form.Cmayor" default="#url.Cmayor#">
</cfif>

<cfif isDefined("Form.btnNuevo")>
	<cfset modoI = "ALTA">
<cfelse>
	<cfif <!---isDefined("Form.modoI") and trim(Form.modoI) eq "CAMBIO" 
	and---> 
	isDefined("Form.Cmayor") and len(trim(Form.Cmayor)) neq 0
	and isDefined("Form.Iid") and len(trim(Form.Iid)) neq 0
	and isDefined("Form.CdescripcionMI") and len(trim(Form.CdescripcionMI)) neq 0>
		<cfset modoI = "CAMBIO">
	<cfelse>
		<cfset modoI = "ALTA">
	</cfif>
</cfif>

<cfif modoI NEQ "ALTA">
	<cfquery name="rsCtasMayor" datasource="#Session.DSN#">
		select cm.Ecodigo,cm.Cmayor, cm.Iid, cm.CdescripcionMI, c.Cdescripcion
		from CtasMayorIdioma cm
        inner join CtasMayor c
        on cm.Ecodigo = c.Ecodigo and cm.Cmayor = c.Cmayor
		where cm.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		   and cm.Cmayor = <cfqueryparam value="#Form.Cmayor#" cfsqltype="cf_sql_char">
           and cm.Iid	= <cfqueryparam value="#Form.Iid#" cfsqltype="cf_sql_integer">
	</cfquery>
</cfif>

<cfquery name="rsIdiomas" datasource="#Session.DSN#">
	select Iid, Descripcion as LOCIdescripcion
	from Idiomas
	order by 1, 2
</cfquery>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset Btn_Idioma = t.Translate('Btn_Idioma','Idioma')>
<cfset Lbl_Cuenta = t.Translate('Lbl_Cuenta','Cuenta')>
<cfset BTN_Agregar 		= t.Translate('BTN_Agregar','Agregar','/sif/generales.xml')>
<cfset LB_btnNuevo 		= t.Translate('LB_btnNuevo','Nuevo','/sif/generales.xml')>
<cfset LB_Filtrar 		= t.Translate('LB_Filtrar','Filtrar','/sif/generales.xml')>
<cfset BTN_Eliminar 	= t.Translate('BTN_Eliminar','Eliminar','/sif/generales.xml')>
<cfset BTN_Modificar 	= t.Translate('BTN_Modificar','Modificar','/sif/generales.xml')>
<cfset Msg_ElimTrad 	= t.Translate('Msg_ElimTrad','¿Desea eliminar la traducción?')>
<cfset Btn_IrLista 		= t.Translate('Btn_IrLista','Ir a Lista')>

<form method="post" name="CtasMayorIdioma" action="SQLCtasMayorIdioma.cfm">
  <cfoutput>
	<cfif isdefined("Form.IdiomaF") and Len(Trim(Form.IdiomaF))>
    	<input type="hidden" name="IdiomaF" value="#Form.IdiomaF#" />
    </cfif>
   	<cfif isdefined("Form.DescripcionF") and Len(Trim(Form.DescripcionF))>
    	<input type="hidden" name="DescripcionF" value="#Form.DescripcionF#" />
    </cfif>
 	<input type="hidden" name="Cmayor" value="#Form.Cmayor#" />
 	<input type="hidden" name="Cdescripcion" value="#Form.Cdescripcion#" />
  </cfoutput>
  
  <table border="0" cellpadding="2" cellspacing="0">
  <cfoutput>
    <tr>
      <td align="right"><strong>#Lbl_Cuenta#:</strong>&nbsp;</td>
      </td>
      <td>#Form.Cmayor# #Form.Cdescripcion#</td>
    </tr>
    <tr>
      <td align="right"><strong>#Lbl_Idioma#:</strong>&nbsp;</td>
      <td>
		  <cfif modoI neq "ALTA">
            <input type="hidden" name="Idioma" value="#rsCtasMayor.Iid#">
          </cfif>	
          <select name="Idioma" <cfif modoI neq "ALTA"> disabled="disabled" </cfif>>
            <cfloop query="rsIdiomas">
              <option value="#rsIdiomas.Iid#" <cfif modoI neq "ALTA" and rsCtasMayor.Iid eq rsIdiomas.Iid> selected</cfif>>#rsIdiomas.LOCIdescripcion#</option>
            </cfloop>
          </select>
      </td>                            
    </tr>
    <tr>
      <td align="right"><strong>#MSG_Descripcion#:</strong>&nbsp;</td>
      <td>
	  	<input name="CdescripcionMI" type="text" value="<cfif modoI NEQ 'ALTA'><cfoutput>#rsCtasMayor.CdescripcionMI#</cfoutput></cfif>" size="50" maxlength="80" tabindex="1">
	  </td>
    </tr>
    <tr>
      <td colspan="2" nowrap="nowrap" align="center" style="width:10%">
		<cfif modoI neq "ALTA">
            <input type="submit" name="Cambio" 	class="btnGuardar" value="#BTN_Modificar#" tabindex="5" onClick="javascript: this.form.botonSel.value = this.name;">                                    
            <input type="submit" name="Baja"   	class="btnEliminarI" value="#BTN_Eliminar#"  tabindex="5" onClick="javascript: this.form.botonSel.value = this.name; if (!confirm('#Msg_ElimTrad#')){return false;}else{deshabilitarValidacion(this); return true;}">
            <input type="submit" name="btnNuevoI"  	class="btnNuevoI"    value="#LB_btnNuevo#" 	  tabindex="5" onClick="javascript: this.form.botonSel.value = this.name; deshabilitarValidacion(this); return true;">
        <cfelse>
            <input type="submit" name="Alta" 	class="btnGuardarI" value="#BTN_Agregar#" tabindex="5" onClick="javascript: this.form.botonSel.value = this.name;">
        </cfif>
        <input type="submit" name="btnLista" class="btnAnteriorI"	value="#Btn_IrLista#" tabindex="5" onClick="javascript: goLista();">
      </td>
    </tr>
  </cfoutput>
  </table>
</form>

<script language="JavaScript1.2" type="text/javascript">
	function goLista() {
		document.CtasMayorIdioma.action = 'CuentasMayor.cfm';
		document.CtasMayorIdioma.submit();
	}
</script>





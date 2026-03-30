<cfif isDefined("form.MESid") and len(trim(form.MESid)) gt 0>
	<cfset modoS = "CAMBIO">
<cfelse>
	<cfset modoS = "ALTA">
</cfif>

<!--- Consultas --->
<cfif modoS NEQ 'ALTA'>
	<cfquery name="rsformS" datasource="#Session.DSN#">
		select convert(varchar,METEid) as METEid, convert(varchar,MESid) as MESid, METEorden, METEetiq, ts_rversion
		from MEServicioEntidad
		where METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">
			and MESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MESid#">
	</cfquery>
	<cfquery name="rsDescs" datasource="#Session.DSN#">
		select convert(varchar, b.METSid) as METSid, b.METSdesc, a.MESdesc
		from MEServicio a, METipoServicio b
		where a.MESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormS.MESid#">
		and a.METSid = b.METSid
	</cfquery>
</cfif>

<cfquery name="rsTipoServicios" datasource="#Session.DSN#">
	select convert(varchar, METSid) as METSid, METSdesc
	from METipoServicio
</cfquery>

<cfquery name="rsServicios" datasource="#Session.DSN#">
	select convert(varchar, METSid) as METSid, convert(varchar, MESid) as MESid, MESdesc
	from MEServicio
</cfquery>

<script language="javascript1.4" type="text/javascript" src="../../../js/utilesMonto.js"></script>
<script language="JavaScript1.4" type="text/javascript">
	<!--//
	// specify the path where the "/qForms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	function CargarServicio(id1, id2) {
		var f = document.formS; 
		f.MESid.value = id1;
		f.METEid.value = id2;
		f.ModificarS.value = "ModificarS";
		f.action = "SQLTipoEntidad.cfm";
		f.submit();
	}
	<cfif modoS EQ 'ALTA'>
	function LlenarServicios(obj,id) {
	var cont = 0;
	obj.length=0;
	<cfoutput query="rsServicios">
		if (#Trim(rsServicios.METSid)#==id)
		{
			obj.length=cont+1;
			obj.options[cont].value='#rsServicios.MESid#';
			obj.options[cont].text='#rsServicios.MESdesc#';
			<cfif modoS NEQ "ALTA" and #rsServicios.MESid# EQ #rsFormS.MESid#>
				obj.options[cont].selected=true;
			</cfif>
			cont++;
		};
	</cfoutput>
	}
	</cfif>
	//-->
</script>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>

<cfoutput>
<form name="formS" method="post" action="SQLTipoEntidad.cfm">
<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
  <input type="hidden" name="TABSEL" id="TABSEL" value="#form.TABSEL#">
  <input type="hidden" name="METEid" value="#form.METEid#">
  <cfif  modoS NEQ "ALTA">
	<!---  ts_rversion --->
	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsformS.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
  </cfif>
  <input type="hidden" name="ModificarS" value="">
  <tr>
    <td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
	<td>&nbsp;Tipo de Servicio</td>
	<td><cfif modoS NEQ 'ALTA'>
			<input type="text" name="METSdesc" value="#rsDescs.METSdesc#" class="cajasinbordeb">
			<input type="hidden" name="METSid" value="#rsDescs.METSid#">
		<cfelse>
			<select name="METSid" onChange="javascript:LlenarServicios(document.formS.MESid,document.formS.METSid.value);">
				<cfloop query="rsTipoServicios">
				<option value="#METSid#">#METSdesc#</option>
				</cfloop>
			</select>
		</cfif>
	</td>
	<td>&nbsp;</td>
  </tr>  
  <tr>
    <td>&nbsp;</td>
	<td>&nbsp;Servicio</td>
	<td><cfif modoS NEQ 'ALTA'>
			<input type="text" name="MESdesc" value="#rsDescs.MESdesc#" class="cajasinbordeb">
			<input type="hidden" name="MESid" value="#rsFormS.MESid#">
		<cfelse>
			<select name="MESid">
			</select>
			<script language="JavaScript">LlenarServicios(document.formS.MESid,document.formS.METSid.value);</script>
		</cfif>
	</td>
	<td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
	<td>&nbsp;Etiqueta:</td>
	<td><input type="text" name="METEetiq" value="<cfif modoS NEQ "ALTA">#rsformS.METEetiq#</cfif>" size="30" maxlength="30" ></td>
	<td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
	<td>&nbsp;Orden:</td>
	<td><input type="text" name="METEorden" value="<cfif modoS NEQ "ALTA">#rsFormS.METEorden#</cfif>" size="10" maxlength="3" onKeyPress="return acceptNum(event)"></td>
	<td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
  </tr>
  <tr>
  	<td>&nbsp;</td>
	<td colspan="2" align="center" nowrap>
		<cfif modoS neq 'ALTA'>						
			&nbsp;<input type="submit" alt="9" name='CambioS' value="#Request.Translate('BotonCambiar','Modificar','/sif/Utiles/Generales.xml')#" onClick="javascript: return setBtn(this);" tabindex="3">						
			<input type="submit" alt="10" name='EliminarS' value="#Request.Translate('BotonEliminar','Eliminar','/sif/Utiles/Generales.xml')#" onClick="javascript: if (confirm('¿Desea eliminar esta característica?')) return setBtn(this); else return false;" tabindex="3">
			<input type="submit" alt="11" name="NuevoS" value="#Request.Translate('BotonNuevo','Nuevo','/sif/Utiles/Generales.xml')#" onClick="javascript: return setBtn(this);" tabindex="3">
		<cfelse>
			&nbsp;<input type="submit" alt="8" name='AltaS' value="#Request.Translate('BotonAgregar','Agregar','/sif/Utiles/Generales.xml')#" tabindex="3">
			<input type="reset" alt="12" name="LimpiarS" value="#Request.Translate('BotonLimpiar','Limpiar','/sif/Utiles/Generales.xml')#" tabindex="3">
		</cfif>
	</td>
	<td>&nbsp;</td>
  </tr>
    <tr>
    <td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
  </tr>
</table>
</form>
</cfoutput>

<cfset checked = "'<img name=''checked'' src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>'">
<cfset unchecked = "'<img name=''checked'' src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>'">
<cfinvoke 
	component="sif.me.Componentes.pListas"
	method="pListaME"
	returnvariable="pListaMERet">
	<cfinvokeargument name="tabla" value="MEServicioEntidad a, MEServicio b"/>
	<cfinvokeargument name="columnas" value="convert(varchar,a.METEid) as METEid, convert(varchar,a.MESid) as MESid, a.METEorden, a.METEetiq, b.MESdesc"/>
	<cfinvokeargument name="filtro" value="METEid = #Form.METEid# and a.MESid = b.MESid"/>
	
	<cfinvokeargument name="desplegar" value="MESdesc, METEetiq, METEorden"/>
	<cfinvokeargument name="etiquetas" value="Servicio, Etiqueta, Orden"/>
	<cfinvokeargument name="formatos" value="S, S, S"/>
	<cfinvokeargument name="align" value="left, left, center"/>
	
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="formName" value="listaServicio"/>

	<cfinvokeargument name="funcion" value="CargarServicio"/>
	<cfinvokeargument name="fparams" value="MESid, METEid"/>
</cfinvoke>

<script language="JavaScript1.2" type="text/javascript">
	<!--//
	qFormAPI.errorColor = "#FFFFCC";
	objformS = new qForm("formS");
	
	objformS.METEetiq.required = true;
	objformS.METEetiq.description="Etiqueta";
	objformS.METEorden.required = true;
	objformS.METEorden.description="Orden";
	objformS.METEorden.validateNumeric('El valor debe ser numérico para ' + objformS.METEorden.description);
	
	//-->
</script>
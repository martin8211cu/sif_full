<cfif not isdefined("Form.Nuevo") and not (isdefined("Form.root") and Form.root EQ 1) and isdefined("Form.EScodigo") and Len(Trim(Form.EScodigo)) NEQ 0>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cfquery name="rsEstructuraTipo" datasource="#Session.DSN#">
	select convert(varchar, ETcodigo) as ETcodigo, ETnombre
	from EstructuraTipo
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by ETorden
</cfquery>

<!--- Averiguar el padre que debería aparecer según cada situación de navegación --->
<cfif (isdefined("Form.Nuevo") or (isdefined("Form.root") and Form.root EQ 1)) and isdefined("Form.EScodigo") and Len(Trim(Form.EScodigo)) NEQ 0>
	<cfquery name="rsNombreCF" datasource="#Session.DSN#">
		select ESOnombre from EstructuraOrganizacional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and EScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EScodigo#">
	</cfquery>
<cfelseif isdefined("Form.EScodigoPadre") and Len(Trim(Form.EScodigoPadre)) NEQ 0>
	<cfquery name="rsNombreCF" datasource="#Session.DSN#">
		select ESOnombre from EstructuraOrganizacional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and EScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EScodigoPadre#">
	</cfquery>
<cfelse>
	<cfquery name="rsNombreCF" datasource="#Session.DSN#">
		select ESOnombre from EstructuraOrganizacional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and EScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNodoRoot.EScodigo#">
	</cfquery>
</cfif>

<cfif modo NEQ "ALTA">
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select convert(varchar,EScodigo) as EScodigo,
			ESOnombre,
			convert(varchar, EScodigoPadre) as EScodigoPadre,
			ESOcodificacion,
			ESOultimoNivel,
			ESOprefijo,
			convert(varchar, ETcodigo) as ETcodigo,
			ts_rversion
		from EstructuraOrganizacional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  and EScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EScodigo#">
	</cfquery>

</cfif>

<script language="JavaScript" src="../../js/qForms/qforms.js">//</script>
<script language="JavaScript1.2">
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function doConlisOrganizaciones() {
		popUpWindow("estructOrgaz_conlis.cfm?form=form1&id=EScodigoPadre&desc=EScodigoPadreNom",250,200,400,300);
	}

	var boton = "";
	function setBtn(button) {
		boton = button.name;
	}
	
	function showPrefijo(f) {
		if (f.ESOultimoNivel.checked) {
			document.getElementById("preMate").style.display = "";
			objForm.ESOprefijo.required = true;
		} else {
			document.getElementById("preMate").style.display = "none";
			objForm.ESOprefijo.required = false;
		}
	}
	
</script>

<form action="estructOrgaz_sql.cfm" method="post" name="form1">
<cfoutput>
	<!--- Alta de un hijo --->
	<cfif (isdefined("Form.Nuevo") or (isdefined("Form.root") and Form.root EQ 1)) and isdefined("Form.EScodigo") and Len(Trim(Form.EScodigo)) NEQ 0>
		<input type="hidden" name="EScodigoPadre" value="#Form.EScodigo#">
		<input type="hidden" name="EScodigo" value="">
	<!--- Cambio de un nodo --->
	<cfelseif isdefined("Form.EScodigoPadre") and Len(Trim(Form.EScodigoPadre)) NEQ 0>
		<input type="hidden" name="EScodigoPadre" value="#Form.EScodigoPadre#">
		<input type="hidden" name="EScodigo" value="#Form.EScodigo#">
	<!--- Alta de un hijo de root --->
	<cfelse>
		<input type="hidden" name="EScodigoPadre" value="#rsNodoRoot.EScodigo#">
		<input type="hidden" name="EScodigo" value="">
	</cfif>
		<input type="hidden" name="ItemId" value="<cfif isdefined("Form.ItemId")>#Form.ItemId#</cfif>">
  <table width="95%" border="0" cellspacing="0" cellpadding="1">
	<tr>
	  <td class="tituloMantenimiento" colspan="3" align="center">
		<font size="3">
			<cfif modo eq "ALTA">
				Nueva Unidad Acad&eacute;mica
			<cfelse>
				Modificar Unidad Acad&eacute;mica
			</cfif>
		</font></td>
	</tr>
	<tr>
		<td colspan="3" align="right">&nbsp;</td>
	</tr>
    <tr> 
      <td align="right" nowrap>Padre:</td>
      <td nowrap>
	  <!---
		  <input name="EScodigoPadreNom" type="text" value="<cfif modo NEQ "ALTA" and isDefined("rsNombreCF") >#rsNombreCF.ESOnombre#</cfif>" id="EScodigoPadreNom" size="40" maxlength="80" readonly tabindex="-1">
          <a href="##" tabindex="-1"><img src="#Session.JSroot#/imagenes/iconos/description.gif" alt="Lista de Responsables" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisOrganizaciones();"></a> 
		  <a href="##" tabindex="-1"><img src="#Session.JSroot#/imagenes/iconos/delete.small.png" alt="Limpiar Responsable" name="imagenLimpiar" width="16" height="16" border="0" align="absmiddle" onClick="javascript: document.form1.EScodigoPadre.value = ''; document.form1.EScodigoPadreNom.value = '';"></a>        
		  <input name="EScodigoPadre" type="hidden" id="EScodigoPadre" value="<cfif modo NEQ "ALTA">#rsForm.EScodigoPadre#</cfif>"> 
		--->
		<cfif isdefined("rsNombreCF")>
			#rsNombreCF.ESOnombre#
		</cfif>
		</td>
      <td nowrap align="right">
		  <cf_sifayuda width="650" height="450" name="imgAyuda" Tip="false">
	  </td>
    </tr>
    <tr> 
      <td align="right" nowrap>Tipo de Unidad:</td>
      <td colspan="2">
	  	<select name="ETcodigo" id="ETcodigo">
			<cfloop query="rsEstructuraTipo">
			<option value="#ETcodigo#" <cfif (modo NEQ 'ALTA' and rsEstructuraTipo.ETcodigo EQ rsForm.ETcodigo) or (isDefined("Form.ETcodigo") and rsEstructuraTipo.ETcodigo EQ Form.ETcodigo)>selected</cfif>>#ETnombre#</option>
			</cfloop>
		</select>
	  </td>
      </tr>
    <tr> 
      <td align="right" nowrap>C&oacute;digo:</td>
      <td colspan="2" nowrap><input name="ESOcodificacion" type="text" id="ESOcodificacion" value="<cfif modo NEQ "ALTA">#rsForm.ESOcodificacion#</cfif>" size="20" maxlength="15" tabindex="1">	</td>
      </tr>
    <tr> 
      <td align="right" nowrap>Nombre:</td>
      <td colspan="2">
	    <input name="ESOnombre" type="text" id="ESOnombre" value="<cfif modo NEQ "ALTA">#rsForm.ESOnombre#</cfif>" size="40" maxlength="60" tabindex="1">
    </td>
      </tr>
    <tr id="preMate" style="display: none;"> 
      <td align="right" nowrap>Prefijo para Materia:</td>
      <td colspan="2">
	    <input name="ESOprefijo" type="text" id="ESOprefijo" value="<cfif modo NEQ "ALTA">#rsForm.ESOprefijo#</cfif>" size="10" maxlength="4" tabindex="1">
    </td>
      </tr>
    <tr> 
      <td>&nbsp;</td>
      <td colspan="2"><input type="checkbox" name="ESOultimoNivel" value="1" <cfif modo NEQ "ALTA" and rsForm.ESOultimoNivel EQ 1>checked</cfif> onClick="javascript: showPrefijo(this.form);">Ultimo Nivel</td>
      </tr>
    <tr> 
    <tr> 
      <td>&nbsp;</td>
      <td colspan="2">&nbsp;</td>
      </tr>
      <td colspan="3"><div align="center"> 
          <cfif modo EQ "ALTA" or isDefined("Form.Nuevo")>
            <input type="submit" name="Alta" value="Agregar" onClick="javascript: setBtn(this);" tabindex="3">
            <input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: setBtn(this);" tabindex="3">
          <cfelse>
            <input type="submit" name="Cambio" value="Modificar" tabindex="3" onclick="javascript: setBtn(this); habilitarValidacion();">
            <input type="submit" name="Baja" value="Eliminar" tabindex="3" onclick="javascript: setBtn(this); inhabilitarValidacion(); return confirm('¿Desea eliminar este registro?');">
			<cfif rsForm.ESOultimoNivel EQ 0 and not (isdefined("Form.root") and Form.root EQ 1) >
            <input type="submit" name="Nuevo" value="Nuevo Hijo" tabindex="3" onClick="javascript: setBtn(this);">
			</cfif>
          </cfif>
        </div></td>
    </tr>
    <tr>
      <td colspan="3">&nbsp;</td>
    </tr>
  </table>

  <cfset ts = "">
  <cfif modo NEQ "ALTA">
    <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
	</cfinvoke>
	</cfif>  
  <input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>" size="32">

</cfoutput>
</form>

<script language="javascript" type="text/javascript">
	function habilitarValidacion() {
		objForm.ESOcodificacion.required = true;
		objForm.ESOnombre.required = true;
		objForm.ETcodigo.required = true;
		if (objForm.ESOultimoNivel.obj.checked) {
			objForm.ESOprefijo.required = true;
		} else {
			objForm.ESOprefijo.required = false;
		}
	}

	function inhabilitarValidacion() {
		objForm.ESOcodificacion.required = false;
		objForm.ESOnombre.required = false;
		objForm.ETcodigo.required = false;
		objForm.ESOprefijo.required = false;
	}

//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.ESOcodificacion.required = true;
	objForm.ESOcodificacion.description = "Código";
	objForm.ESOnombre.required = true;
	objForm.ESOnombre.description = "Nombre";
	objForm.ETcodigo.required = true;
	objForm.ETcodigo.description = "Tipo de Unidad";
	objForm.ESOprefijo.required = true;
	objForm.ESOprefijo.description = "Prefijo para Materia";

	<cfif modo NEQ 'CAMBIO'>
		document.form1.ESOcodificacion.focus();
	</cfif>
	showPrefijo(document.form1);
</script>

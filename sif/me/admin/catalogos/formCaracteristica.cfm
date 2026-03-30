<cfif isDefined("Form.METECid") and len(trim(Form.METECid)) gt 0>
	<cfset modoC = "CAMBIO">
<cfelse>
	<cfset modoC = "ALTA">
</cfif>

<!--- Consultas --->
<cfif modoC NEQ 'ALTA'>
	<cfquery name="rsFormC" datasource="#Session.DSN#">
		select convert(varchar,METECid) as METECid, convert(varchar,METEid) as METEid, 
			METECdescripcion, METECtipo, Usucodigo, Ulocalizacion,
			METECgrupolocale, METECrefpais,
			METEfechareg, METECdesplegar, METEClista, METECrequerido, METECeditable, METEfila, METEcol, METEorden, ts_rversion
		from METECaracteristica ZZ
		where METECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METECid#">
	</cfquery>

	<!--- Valores de la Característica --->
	<cfquery name="rsValoresCaracteristica" datasource="#Session.DSN#">
		select convert(varchar,MEVCid) as MEVCid, MEVCdescripcion, ts_rversion
		from MEVCaracteristica
		where METECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METECid#">
	</cfquery>											
	
	<cfquery name="rsUsoCaracteristica" datasource="#Session.DSN#">
		select count(1) as cont
		from MECaracteristicaEntidad
		where METECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METECid#">
	</cfquery>
</cfif>

<cfquery name="refpais" datasource="#session.dsn#">
	select METECid, METECdescripcion
	from METECaracteristica
	where METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METEid#">
	  and METECtipo = 'local'
	  and METECrefpais is null
	  <cfif modoC NEQ 'ALTA'>
	  and METECid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.METECid#">
	  </cfif>
</cfquery>

<script language="javascript1.4" type="text/javascript" src="../../../js/utilesMonto.js"></script>
<script language="JavaScript1.4" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	function CargarCaracteristica(id1, id2) {
		var f = document.formC; 
		f.METECid.value = id1;
		f.METEid.value = id2;
		f.ModificarC.value = "ModificarC";
		f.action = "SQLTipoEntidad.cfm";
		f.submit();
	}
	
	function chTipo(value) {
		window.status=value;
		document.all.trlista.style.display = (value == 'list') ? 'inline':'none';
		document.all.trlocal.style.display = (value == 'local') ? 'inline':'none';
	}
	
	//-->
</script>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>

<cfoutput>
<form name="formC" method="post" action="SQLTipoEntidad.cfm" style="margin:0" onSubmit="javascript:return finalizar();">
<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
  <input type="hidden" name="TABSEL" id="TABSEL" value="#Form.TABSEL#">
  <input type="hidden" name="METEid" value="#Form.METEid#">
  <cfif  modoC NEQ "ALTA">
	<!---  ts_rversion --->
	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsFormC.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
	<input type="hidden" name="cambiarValores" value="false">
  </cfif>
  <input type="hidden" name="METECid" value="<cfif modoC neq "ALTA">#rsFormC.METECid#</cfif>">
  <input type="hidden" name="ModificarC" value="">								
  <tr>
    <td width="0%">&nbsp;</td>
    <td width="18%">&nbsp;</td>
    <td width="18%">&nbsp;</td>
    <td colspan="2" align="left">&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
	<td nowrap>&nbsp;<strong>Descripci&oacute;n: </strong></td>
	<td valign="bottom" nowrap><input type="text" onFocus="this.select()" name="METECdescripcion" value="<cfif modoC NEQ "ALTA">#rsFormC.METECdescripcion#</cfif>" size="30" maxlength="80"></td>
	<td colspan="2" align="left" ><strong>
	  <input type="checkbox" name="METECdesplegar" <cfif modoC NEQ "ALTA" and rsFormC.METECdesplegar EQ 1> checked </cfif>>
	  Desplegar</strong></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td nowrap>&nbsp;<strong>Tipo de captura: </strong></td>
    
	<cfif modoC EQ "ALTA">
		<cfset METECtipo = 'char'>
	<cfelse>
		<cfset METECtipo = rsFormC.METECtipo>
	</cfif><td nowrap>
	<select name="METECtipo" id="METECtipo" onChange="chTipo(this.value)" onClick="chTipo(this.value)">
      <option value="char"  <cfif METECtipo IS 'char' >selected</cfif>>Texto</option>
      <option value="num"   <cfif METECtipo IS 'num'  >selected</cfif>>Num&eacute;rico</option>
      <option value="money" <cfif METECtipo IS 'money'>selected</cfif>>Valor (importe)</option>
      <option value="date"  <cfif METECtipo IS 'date' >selected</cfif>>Fecha</option>
      <option value="bit"   <cfif METECtipo IS 'bit'  >selected</cfif>>Check box</option>
      <option value="list"  <cfif METECtipo IS 'list' >selected</cfif>>Lista fija</option>
      <option value="local" <cfif METECtipo IS 'local'>selected</cfif>>Lista localizable</option>
    </select></td>
    <td colspan="2" align="left"><strong>
      <input name="METECeditable" type="checkbox" id="METECeditable2" <cfif modoC NEQ "ALTA" and rsFormC.METECeditable EQ 1> checked </cfif>>
      Editar</strong></td>
    </tr>
  <tr>
  	<td>&nbsp;</td>
    <td nowrap>&nbsp;<strong>Fila: </strong></td>
    <td nowrap><input type="text" onFocus="this.select()" name="METEfila" value="<cfif modoC NEQ "ALTA">#rsFormC.METEfila#<cfelse>0</cfif>" size="10" maxlength="3" onKeyPress="return acceptNum(event)" style="text-align:right" ></td>
    <td colspan="2" align="left" ><input type="checkbox" name="METEClista" <cfif modoC NEQ "ALTA" and rsFormC.METEClista EQ 1> checked </cfif>>
      <strong>Capturar</strong></td>
    </tr>
  <tr>
	<td>&nbsp;</td>
    <td nowrap>&nbsp;<strong>Columna: </strong></td>
    <td nowrap><input type="text" name="METEcol" onFocus="this.select()" value="<cfif modoC NEQ "ALTA">#rsFormC.METEcol#<cfelse>0</cfif>" size="10" maxlength="3" onKeyPress="return acceptNum(event)" style="text-align:right" ></td>
    <td colspan="2" align="left" ><input type="checkbox" name="METECrequerido" <cfif modoC NEQ "ALTA" and rsFormC.METECrequerido EQ 1> checked </cfif>>
      <strong>Requerido</strong></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
	<td nowrap>&nbsp;<strong>Orden Concat.: </strong></td>
    <td nowrap><input type="text" name="METEorden" onFocus="this.select()"  value="<cfif modoC NEQ "ALTA">#rsFormC.METEorden#<cfelse>0</cfif>" size="10" maxlength="3" onKeyPress="return acceptNum(event)" style="text-align:right" ></td>
    <td colspan="2" align="left" nowrap>&nbsp;</td>
    </tr>
  <tr id="trlista" <cfif modoC EQ 'ALTA' or rsFormC.METECtipo NEQ 'list'>style="display:none"</cfif>>
    <td>&nbsp;</td>
	<td nowrap>&nbsp;<strong>Lista de Valores: </strong></td>
	<cfset listavalores = "">
	<cfif modoC NEQ 'ALTA'>
		<cfloop query='rsValoresCaracteristica'>
			<cfset listavalores = listavalores & rsValoresCaracteristica.MEVCdescripcion>
			<cfif CurrentRow neq RecordCount>
				<cfset listavalores = listavalores & ",">
			</cfif>
		</cfloop>
	</cfif>
    <td nowrap colspan="3"><input type="text" name="MEVCdescripciones" onFocus="this.select()" value="#listavalores#" size="110" maxlength="1024" onChange="javascript: <cfif modoC neq "ALTA" and rsUsoCaracteristica.cont eq 0>document.formC.cambiarValores.value = 'true';</cfif>"></td>
	</tr>
  <tr id="trlocal" <cfif modoC EQ 'ALTA' or rsFormC.METECtipo NEQ 'local'>style="display:none"</cfif>>
    <td>&nbsp;</td>
	<td nowrap>&nbsp;<strong>Grupo de lista localizable: </strong></td>
    <td nowrap><input type="text" name="METECgrupolocale" value="<cfif modoC NEQ 'ALTA'>#rsFormC.METECgrupolocale#</cfif>" size="30" maxlength="1024" >
	</td>
	<td width="19%" nowrap><strong>Parametrizaci&oacute;n del pa&iacute;s: </strong> </td>
	<td width="45%" nowrap><select name="METECrefpais" id="select3">
      <option value="">[ninguna]</option>
      <cfloop query="refpais">
        <option value="#refpais.METECid#" <cfif modoC neq 'ALTA' and rsFormC.METECrefpais is refpais.METECid>selected</cfif>> #refpais.METECdescripcion#</option>
      </cfloop>
    </select></td>
	</tr>
  <tr>
  	<td>&nbsp;</td>
	<td colspan="4">
		<table class="ayuda" width="100%">
		  <tr>
			  <td>
			  	  <b>¿Cómo Capturar?</b><br><br>
				  <b>Fila:</b>&nbsp;Permite Fila en que se desplegará en Mantenimiento General.<br>
			  	  <b>Columna:</b>&nbsp;Columna en que se desplegará en Mantenimiento General.<br>
				  <b>Orden Concatenación:</b>&nbsp;Orden en que se concatenará en Nombre de la Entidad.<br>
				  <cfif modoC neq "ALTA" and rsUsoCaracteristica.cont gt 0>
					<b>Valores:</b>&nbsp;Esta característica ya fué utilizada por una o mas entidades, por lo tanto algunos valores no pueden ser modificados.<br>
				  <cfelse>
					<b>Valores:</b>&nbsp;Si digita los valores, recuerde que estos valores van a ser desplegados en un combo y separe cada valor con una coma.<br>
				  </cfif>
				  <b>Desplegar:</b>&nbsp;Permite desplegar en Lista.<br><!--- METECdesplegar --->
				  <b>Editar:</b>&nbsp;Permite editar en lista.<br><!--- METECeditable --->
				  <b>Capturar:</b>&nbsp;Permite capturar en lista.<br><!--- METEClista --->
				  <b>Requerido:</b>&nbsp;Requerido en Edición completa.<br><!--- METErequerido --->
		  	</td>
		  </tr>
		</table>
	</td>
	</tr>
  <tr>
  	<td>&nbsp;</td>
	<td colspan="4" align="center" nowrap>
		<cfif modoC neq 'ALTA'>						
			&nbsp;<input type="submit" alt="9" name='CambioC' value="#Request.Translate('BotonCambiar','Modificar','/sif/Utiles/Generales.xml')#" onClick="javascript: return setBtn(this);" tabindex="3">						
			<input type="submit" alt="10" name='EliminarC' value="#Request.Translate('BotonEliminar','Eliminar','/sif/Utiles/Generales.xml')#" onClick="javascript: if (confirm('¿Desea eliminar esta característica?')) return setBtn(this); else return false;" tabindex="3">
			<input type="submit" alt="11" name="NuevoC" value="#Request.Translate('BotonNuevo','Nuevo','/sif/Utiles/Generales.xml')#" onClick="javascript: return setBtn(this);" tabindex="3">
		<cfelse>
			&nbsp;<input type="submit" alt="8" name='AltaC' value="#Request.Translate('BotonAgregar','Agregar','/sif/Utiles/Generales.xml')#" tabindex="3">
			<input type="reset" alt="12" name="LimpiarC" value="#Request.Translate('BotonLimpiar','Limpiar','/sif/Utiles/Generales.xml')#" tabindex="3">
		</cfif>
	</td>
	</tr>
    <tr>
    <td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td colspan="2">&nbsp;</td>
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
	<cfinvokeargument name="tabla" value="METECaracteristica a, METipoEntidad b"/>
	<cfinvokeargument name="columnas" value="convert(varchar,a.METECid) as METECid, convert(varchar,a.METEid) as METEid, 
											METECdescripcion, METEfila, METEcol, METEorden,
											METECdesplegar = case METECdesplegar when 1 then #checked# else #unchecked# end, 
											METECeditable = case METECeditable when 1 then #checked# else #unchecked# end, 
											METEClista = case METEClista when 1 then #checked# else #unchecked# end, 
											METECrequerido = case METECrequerido when 1 then #checked# else #unchecked# end,
											METECtipo"/>
	<cfinvokeargument name="filtro" value="b.METEid = #Form.METEid# and b.METEid = a.METEid order by METEfila, METEcol, METECdescripcion"/>
	
	<cfinvokeargument name="desplegar" value="METECdescripcion, METEfila, METEcol, METEorden,
											METECdesplegar, METECeditable, METEClista, METECrequerido, 
											METECtipo"/>
	<cfinvokeargument name="etiquetas" value="Descripción, Fila, Columna, Orden, Desplegar, Editar, Capturar, Requerido, Tipo"/>
	<cfinvokeargument name="formatos" value="S, S, S, S,
											S, S, S, S, S"/>
	<cfinvokeargument name="align" value="left, left, left, left,
											center, center, center, center, center"/>
	
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="formName" value="listaCaracteristica"/>

	<cfinvokeargument name="funcion" value="CargarCaracteristica"/>
	<cfinvokeargument name="fparams" value="METECid, METEid"/>
</cfinvoke>

<script language="JavaScript1.2" type="text/javascript">
	<!--//
	qFormAPI.errorColor = "#FFFFCC";
	objFormC = new qForm("formC");
	
	objFormC.METECdescripcion.required = true;
	objFormC.METECdescripcion.description="Descripción";
	objFormC.METEfila.required = true;
	objFormC.METEfila.validateNumeric('El valor debe ser numérico para ' + objFormC.METEfila.description + '.');
	objFormC.METEfila.description="Fila";
	objFormC.METEcol.required = true;
	objFormC.METEcol.validateNumeric('El valor debe ser numérico para ' + objFormC.METEcol.description + '.');
	objFormC.METEcol.description="Columna";
	//objFormC.METEorden.required = true;
	objFormC.METEorden.validateNumeric('El valor debe ser numérico para ' + objFormC.METEcol.description + '.');
	objFormC.METEorden.description="Columna";
	
	function finalizar() {
		return true;
	}
	//-->
</script>
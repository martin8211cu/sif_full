<cfif isDefined("Form.METEidrel") and len(trim(Form.METEidrel)) gt 0
	and isDefined("Form.METEid") and Len(Trim(Form.METEid)) gt 0
	and isDefined("Form.METRid") and Len(Trim(Form.METRid)) gt 0>
	<cfset modoR = "CAMBIO">
<cfelse>
	<cfset modoR='ALTA'>
</cfif>

<!--- Consultas --->
<cfif modoR NEQ 'ALTA'>
	<cfquery name="rsFormR" datasource="#Session.DSN#">
		select convert(varchar,METEidrel) as METEidrel, 
				convert(varchar,METRid) as METRid, 
				convert(varchar,METEid) as METEid,
				MERPdescripcion1, 
				MERPdescripcion2, 
				MERPorden,
				MERPnuevos,
				MERPconlis,
				MERPver_hijos,
				MERPmin_hijos,
				MERPmax_hijos,
				MERPsug_hijos,
				MERPver_padres,
				MERPmin_padres,
				MERPmax_padres,
				MERPsug_padres,
				MERPtipo,
				ts_rversion
		from MERelacionesPermitidas
		where METEidrel = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.METEidrel#">
		  and METRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.METRid#">
		  and METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.METEid#">
	</cfquery>
	
	<!--- Descripción del Tipo de Entidad a relacionar --->
	<cfquery name="rsTipoEntidad" datasource="#Session.DSN#">
		select METEdesc from METipoEntidad 
		where METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormR.METEid#">
	</cfquery>

</cfif>

<!--- Lista de Tipos de Entidad --->
<cfquery name="rsTiposEntidadRel" datasource="#Session.DSN#">
	select convert(varchar,METEid) as METEid, METEdesc
	from METipoEntidad
</cfquery>

<!--- Obtiene los datos de la tabla de Tipos de Entidad según una entidad --->
<cffunction name="ObtenerValores2" returntype="query">
	<cfargument name="METEid" type="numeric" required="true">	
	<cfquery name="rs" datasource="#Session.DSN#">
		select METEdesc
		from METipoEntidad		
		where METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.METEid#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	function CargarRelacion(id1, id2, id3) {
		var f = document.formR; 
		f.METEidrel.value = id1;
		f.METRid.value = id2;
		f.METEid.value = id3;
		f.ModificarR.value = "ModificarR";
		f.action = "SQLTipoEntidad.cfm";
		f.submit();
	}	
	//-->
</script>


<form name="formR" method="post" action="SQLTipoEntidad.cfm">
<cfoutput>
<input type="hidden" name="TABSEL" id="TABSEL" value="#Form.TABSEL#">
<input type="hidden" name="METEid" value="#Form.METEid#">
<input type="hidden" name="METRid" value="<cfif modoR NEQ 'ALTA'>#rsFormR.METRid#</cfif>">
<!---  ts_rversion --->
<cfset ts = "">
<cfif modoR NEQ "ALTA">
  <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsFormR.ts_rversion#" returnvariable="ts">
  </cfinvoke>
</cfif>
<input type="hidden" name="ts_rversion" value="<cfif modoR NEQ "ALTA">#ts#</cfif>">
<input type="hidden" name="ModificarR" value="">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Relacionar con: </td>
    <td>
		<cfif modoR NEQ 'ALTA'>
			<cfset idrel = ObtenerValores2(rsFormR.METEidrel).METEdesc>
			<input type="text" name="METEidrelDesc" value="#idrel#" class="cajasinbordeb">
			<input type="hidden" name="METEidrel" value="#rsFormR.METEidrel#">
		<cfelse>
			<select name="METEidrel">
				<cfloop query="rsTiposEntidadRel">
				<option value="#METEid#">#METEdesc#</option>
				</cfloop>
			</select>
		</cfif>
	</td>
    <td rowspan="3" style="text-align: center;writing-mode:tb-rl; "><strong>Orden</strong></td>
    <td rowspan="3" style="text-align: center;writing-mode:tb-rl; "><strong>Agregar en L&iacute;neas</strong></td>
    <td rowspan="3" style="text-align: center;writing-mode:tb-rl; "><strong>Seleccionar en L&iacute;neas </strong></td>
    <td rowspan="3" style="text-align: center;writing-mode:tb-rl; "><strong>Ver hijos </strong></td>
    <td rowspan="3" style="text-align: center;writing-mode:tb-rl; "><strong>Hijos m&iacute;nimos </strong></td>
    <td rowspan="3" style="text-align: center;writing-mode:tb-rl; "><strong>Hijos m&aacute;ximos </strong></td>
    <td rowspan="3" style="text-align: center;writing-mode:tb-rl; "><strong>Hijos sugeridos</strong></td>
    <td rowspan="3" style="text-align: center;writing-mode:tb-rl; "><strong>Ver padres </strong></td>
    <td rowspan="3" style="text-align: center;writing-mode:tb-rl; "><strong>Padres m&iacute;nimos </strong></td>
    <td rowspan="3" style="text-align: center;writing-mode:tb-rl; "><strong>Padres m&aacute;ximos</strong></td>
    <td rowspan="3" style="text-align: center;writing-mode:tb-rl; "><strong>Padres sugeridos </strong></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Etiqueta para hijos vista desde el padre:</td>
    <td><cfoutput>
        <input type="text" name="MERPdescripcion1" value="<cfif modoR NEQ 'ALTA'>#rsFormR.MERPdescripcion1#</cfif>" size="25" maxlength="80">
    </cfoutput></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Etiqueta para padres vista desde el hijo:</td>
    <td><cfoutput>
        <input type="text" name="MERPdescripcion2" onFocus="this.select()" value="<cfif modoR NEQ 'ALTA'>#rsFormR.MERPdescripcion2#</cfif>" size="25" maxlength="80">
    </cfoutput></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="2">Tipos de Relaci&oacute;n:<br>
      Escriba una lista separada por comas </td>
    <td><div align="center">
      <input name="MERPorden" id="MERPorden" style="text-align:right" onKeyPress="return acceptNum(event)" value="<cfif modoR NEQ "ALTA">#rsFormR.MERPorden#<cfelse>0</cfif>" size="5" maxlength="3" >
</div></td>
    <td><div align="center">
      <input type="checkbox" name="MERPnuevos" <cfif modoR NEQ "ALTA" and rsFormR.MERPnuevos EQ 1> checked </cfif>>
    </div></td>
    <td><div align="center">
      <input name="MERPconlis" type="checkbox" id="MERPconlis" <cfif modoR NEQ "ALTA" and rsFormR.MERPconlis EQ 1> checked </cfif>>
    </div></td>
    <td><div align="center">
      <input name="MERPver_hijos" type="checkbox" id="MERPver_hijos" <cfif modoR NEQ "ALTA" and rsFormR.MERPver_hijos EQ 1> checked </cfif>>
    </div></td>
    <td><div align="center">
      <input name="MERPmin_hijos" id="MERPmin_hijos" style="text-align:right" onKeyPress="return acceptNum(event)" value="<cfif modoR NEQ "ALTA">#rsFormR.MERPmin_hijos#<cfelse>0</cfif>" size="5" maxlength="3" >
    </div></td>
    <td><div align="center">
      <input name="MERPmax_hijos" id="MERPmax_hijos" style="text-align:right" onKeyPress="return acceptNum(event)" value="<cfif modoR NEQ "ALTA">#rsFormR.MERPmax_hijos#<cfelse>0</cfif>" size="5" maxlength="3" >
    </div></td>
    <td><div align="center">
      <input name="MERPsug_hijos" id="MERPsug_hijos" style="text-align:right" onKeyPress="return acceptNum(event)" value="<cfif modoR NEQ "ALTA">#rsFormR.MERPsug_hijos#<cfelse>0</cfif>" size="5" maxlength="3" >
    </div></td>
    <td><div align="center">
      <input name="MERPver_padres" type="checkbox" id="MERPver_padres" <cfif modoR NEQ "ALTA" and rsFormR.MERPver_padres EQ 1> checked </cfif>>
    </div></td>
    <td><div align="center">
      <input name="MERPmin_padres" id="MERPmin_padres" style="text-align:right" onKeyPress="return acceptNum(event)" value="<cfif modoR NEQ "ALTA">#rsFormR.MERPmin_padres#<cfelse>0</cfif>" size="5" maxlength="3" >
    </div></td>
    <td><div align="center">
      <input name="MERPmax_padres" id="MERPmax_padres" style="text-align:right" onKeyPress="return acceptNum(event)" value="<cfif modoR NEQ "ALTA">#rsFormR.MERPmax_padres#<cfelse>0</cfif>" size="5" maxlength="3" >
    </div></td>
    <td><div align="center">
      <input name="MERPsug_padres" id="MERPsug_padres" style="text-align:right" onKeyPress="return acceptNum(event)" value="<cfif modoR NEQ "ALTA">#rsFormR.MERPsug_padres#<cfelse>0</cfif>" size="5" maxlength="3" >
    </div></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="13"><input type="text" name="MERPtipo" onFocus="this.select()" value="<cfif modoR NEQ 'ALTA'>#rsFormR.MERPtipo#</cfif>" size="90" maxlength="255"></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="6"><div align="center">
	<cfif modoR neq 'ALTA'>
		&nbsp;<input type="submit" alt="9" name='CambioR' value="#Request.Translate('BotonCambiar','Modificar','/sif/Utiles/Generales.xml')#" onClick="javascript: return setBtn(this);" tabindex="3">
		<input type="submit" alt="10" name='EliminarR' value="#Request.Translate('BotonEliminar','Eliminar','/sif/Utiles/Generales.xml')#" onClick="javascript: if (confirm('¿Desea eliminar esta relación?')) return setBtn(this); else return false;" tabindex="3">
		<input type="submit" alt="11" name="NuevoR" value="#Request.Translate('BotonNuevo','Nuevo','/sif/Utiles/Generales.xml')#" onClick="javascript: return setBtn(this);" tabindex="3">
	<cfelse>
		&nbsp;<input type="submit" alt="8" name='AltaR' value="#Request.Translate('BotonAgregar','Agregar','/sif/Utiles/Generales.xml')#"tabindex="3">
		<input type="reset" alt="12" name="LimpiarR" value="#Request.Translate('BotonLimpiar','Limpiar','/sif/Utiles/Generales.xml')#" tabindex="3">
	</cfif>
	</div></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</cfoutput>
</form>

<cfset checked = "'<img name=''checked'' src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>'">
<cfset unchecked = "'<img name=''checked'' src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>'">

<cfinvoke 
	component="sif.me.Componentes.pListas"
	method="pListaME"
	returnvariable="pListaMERet">
	<cfinvokeargument name="columnas" value="	convert(varchar,a.METEidrel) as METEidrel, 
												convert(varchar,a.METRid) as METRid, 
												convert(varchar,a.METEid) as METEid, 
												a.MERPorden,
												MERPnuevos = case a.MERPnuevos when 1 then #checked# else #unchecked# end, 
												MERPconlis = case a.MERPconlis when 1 then #checked# else #unchecked# end, 
												MERPver_hijos = case a.MERPver_hijos when 1 then #checked# else #unchecked# end, 
												a.MERPmin_hijos,
												a.MERPmax_hijos,
												a.MERPsug_hijos,
												MERPver_padres = case a.MERPver_padres when 1 then #checked# else #unchecked# end, 
												a.MERPmin_padres,
												a.MERPmax_padres,
												a.MERPsug_padres,
												a.MERPdescripcion1, a.MERPdescripcion2, b.METEdesc"/>
	<cfinvokeargument name="tabla" value="MERelacionesPermitidas a, METipoEntidad b"/>
	<cfinvokeargument name="filtro" value="a.METEid = #Form.METEid# and a.METEidrel = b.METEid order by MERPorden, MERPdescripcion1"/>
	
	<cfinvokeargument name="desplegar" value="METEdesc, 
													MERPdescripcion1, 
													MERPdescripcion2,
													MERPorden,
													MERPnuevos,
													MERPconlis,
													MERPver_hijos,
													MERPmin_hijos,
													MERPmax_hijos,
													MERPsug_hijos,
													MERPver_padres,
													MERPmin_padres,
													MERPmax_padres,
													MERPsug_padres"/>
	<cfinvokeargument name="etiquetas" value="Relación con, Descripción Padre, Descripción Hijo, Orden, A.L., S.L., V.H., H.Min, H.Max, H.Sug., V.P., P.Min, P.Max, P.Sug."/>
	<cfinvokeargument name="formatos" value="S, S, S, S, S, S, S, S, S, S, S, S, S, S"/>
	<cfinvokeargument name="align" value="left, left, left, center, center, center, center, center, center, center, center, center, center, center"/>
	
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="formName" value="listaRelaciones"/>

	<cfinvokeargument name="funcion" value="CargarRelacion"/>
	<cfinvokeargument name="fparams" value="METEidrel, METRid, METEid"/>
</cfinvoke>

<script language="JavaScript1.2" type="text/javascript">
	<!--//
	qFormAPI.errorColor = "#FFFFCC";
	objFormR = new qForm("formR");
	
	objFormR.METEidrel.required = true;
	objFormR.METEidrel.description="Tipo de Entidad Relacionada";
	objFormR.MERPdescripcion1.required = true;
	objFormR.MERPdescripcion1.description="Descripción Normal";
	objFormR.MERPdescripcion2.required = true;
	objFormR.MERPdescripcion2.description="Descripción Inversa";
	objFormR.MERPorden.required = true;
	objFormR.MERPorden.description="Orden";
	objFormR.MERPorden.validateRange(1,999,'Orden no está en el rango permitido. El rango permitido es de 1 a 999.');
	objFormR.MERPmin_hijos.required = true;
	objFormR.MERPmin_hijos.description="Minimo de hijos";
	objFormR.MERPmax_hijos.required = true;
	objFormR.MERPmax_hijos.description="Máximo de hijos";
	objFormR.MERPsug_hijos.required = true;
	objFormR.MERPsug_hijos.description="Sugerido de hijos";
	objFormR.MERPmin_padres.required = true;
	objFormR.MERPmin_padres.description="Mínimo de hijos";
	objFormR.MERPmax_padres.required = true;
	objFormR.MERPmax_padres.description="Máximo de hijos";
	objFormR.MERPsug_padres.required = true;
	objFormR.MERPsug_padres.description="Sugerido de hijos";	
	//-->
</script>
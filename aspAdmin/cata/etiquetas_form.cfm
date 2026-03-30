<!--- Establecimiento del modo --->
<cfif isdefined("form.modo") and isdefined('form.LOEid') and form.LOEid NEQ ''>
	<cfset modo=form.modo>
<cfelse>
	<cfset modo="ALTA">
</cfif>

<!---       Consultas      --->
<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		select convert(varchar,le.LOEid) as LOEid
			, LOEnombre
			, LOTdescripcion
		from LocaleEtiqueta le
			, LocaleTraduccion lt
		where le.LOEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LOEid#">
			and le.LOEid=lt.LOEid
			and Icodigo='es'
	</cfquery>
</cfif>

<link href="/cfmx/sif/css/estilos.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript" src="../js/qForms/qforms.js">//</script>
<form action="etiquetas_SQL.cfm" method="post" name="formEtiquetas">
	<cfoutput>
		<table width="95%" border="0" cellpadding="2" cellspacing="0" align="center">
			<tr>
				<td class="tituloMantenimiento" colspan="3" align="center">
					<cfif modo eq "ALTA">
						Nueva Etiqueta
					<cfelse>
						<input name="LOEid" id="LOEid" type="hidden" value="#rsForm.LOEid#">
						Etiqueta
					</cfif>
				</td>
			</tr>		
			<tr> 
			  <td align="right" valign="top"><strong>Nombre:</strong>&nbsp;</td>
			  <td valign="baseline"><input <cfif modo NEQ "ALTA">class="cajasinbordeb"</cfif> name="LOEnombre" type="text" id="LOEnombre" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.LOEnombre#</cfif>" size="40" maxlength="40" <cfif modo NEQ 'ALTA'> readonly="true"</cfif>></td>
			</tr>	
				<cfif modo EQ "ALTA">
					<tr> 
					  <td align="right"><strong>Traducci&oacute;n default:&nbsp;</strong></td>
					  <td align="left"><input name="LOTdescripcion" type="text" id="LOTdescripcion" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.LOEnombre#</cfif>" size="40" maxlength="255"  <cfif modo NEQ 'ALTA'> readonly="true"</cfif>></td>
					</tr>
					<tr> 
					  <td align="left">&nbsp;</td>
					  <td align="left">&nbsp;</td>
					</tr>					
				</cfif>			
			<tr> 
			  <td align="center" colspan="2">
				<cfset mensajeDelete = "¿Desea Eliminar la etiqueta ?">
						
				<input type="hidden" name="botonSel" value="">
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
				<cfif modo EQ "ALTA">
					<input type="submit" name="Alta" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion();">
					<input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name">
				<cfelse>	
					<input type="submit" name="Baja" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('<cfoutput>#mensajeDelete#</cfoutput>') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
				</cfif>
			  </td>
			</tr>
	  </table>
	</cfoutput>		  
</form>	  

<cfif modo NEQ 'ALTA'>
	<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Traducciones de la Etiqueta">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="0%" valign="top">			
			<cfinvoke component="aspAdmin.Componentes.pListasASP" 
					  method="pLista" 
					  returnvariable="pListaEtiquetas">
				<cfinvokeargument name="tabla" value="	LocaleTraduccion lt
								, LocaleEtiqueta le
								, Idioma i"/>
				<cfinvokeargument name="columnas" value="
								convert(varchar,lt.LOEid) as LOEid
								, convert(varchar,LOTid) as LOTid
								, lt.Icodigo
								, LOTdescripcion
								, (lt.Icodigo + '- ' + Descripcion) as Descripcion"/>
				<cfinvokeargument name="desplegar" value="Descripcion, LOTdescripcion"/>
				<cfinvokeargument name="etiquetas" value="Idioma, Traducci&oacute;n"/>
				<cfinvokeargument name="formatos"  value=""/>
				<cfinvokeargument name="filtro" value="
								lt.LOEid=#form.LOEid#
								and lt.LOEid=le.LOEid
								and lt.Icodigo=i.Icodigo "/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N,N"/>
				<cfinvokeargument name="keys" value="LOEid,LOTid"/>
				<cfinvokeargument name="irA" value="etiquetas.cfm"/>
				<cfinvokeargument name="formName" value="form_listaTraduccionEtiquetas"/>
			</cfinvoke>		
			</td>
			<td width="3%">&nbsp;</td>
			<td width="97%" valign="top"><cfinclude template="traduccionEtiquetas.cfm"></td>
		  </tr>
		</table>
	</cf_web_portlet>		
</cfif>


<script language="JavaScript">
	// Funciones para Manejo de Botones
	botonActual = "";
	
	function setBtn(obj) {
		botonActual = obj.name;
	}
	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacion() {
		objForm.LOEnombre.required = false;		
		<cfif modo EQ "ALTA">
			objForm.LOTdescripcion.required = false;
		</cfif>
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.LOEnombre.required = true;		
		<cfif modo EQ "ALTA">
			objForm.LOTdescripcion.required = true;		
		</cfif>
	}	
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formEtiquetas");
//---------------------------------------------------------------------------------------
	objForm.LOEnombre.required = true;
	objForm.LOEnombre.description = "Nombre";
	<cfif modo EQ "ALTA">
		objForm.LOTdescripcion.required = true;
		objForm.LOTdescripcion.description = "Traducción por default";	
	</cfif>		
</script>
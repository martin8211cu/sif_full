<!--- Establecimiento del modo --->

<cfif isdefined("form.LOCid") and len(trim(form.LOCid)) GT 0>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<!---       Consultas      --->
<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		Select convert(varchar,LOCid) as LOCid
			, LOCnombre
			, LOCtipo
			, LOCorden
		from LocaleConcepto
		where LOCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LOCid#">
	</cfquery>
</cfif>

<cfquery name="qryCodigos" datasource="#Session.DSN#">
	Select rtrim(ltrim(Ppais)) as Ppais
	from Pais
</cfquery>

<script language="JavaScript" type="text/javascript" src="../js/qForms/qforms.js">//</script>
<script language="JavaScript" type="text/javascript" src="../js/utilesMonto.js">//</script>
<link href="/cfmx/sif/css/estilos.css" rel="stylesheet" type="text/css">
<form action="conceptos_SQL.cfm" method="post" name="formConceptos">
	<cfoutput>
	  <table width="95%" border="0" cellpadding="2" cellspacing="0" align="center">
		<tr> 
		  <td class="tituloMantenimiento" colspan="3" align="center"> 
			<cfif modo eq "ALTA">
			  Nuevo Concepto
			<cfelse>
			  Modificar Concepto
			  <input name="LOCid" type="hidden" value="#rsForm.LOCid#">
			</cfif> 
		  </td>
		</tr>
		<tr> 
		  <td align="right" valign="top"><strong>Nombre</strong>:&nbsp;</td>
		  <td valign="baseline">
			<cfif modo NEQ 'ALTA' >
				<input name="LOCnombre" type="text" id="LOCnombre" class="cajasinbordeb" readonly="true" value="#rsForm.LOCnombre#" size="40" maxlength="40">
			<cfelse>
				<input name="LOCnombre" type="text" id="LOCnombre" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.LOCnombre#</cfif>" size="40" maxlength="40">
			</cfif>
		  </td>
		</tr>
		<tr> 
		  <td align="right" valign="top"><strong>Tipo</strong>:&nbsp;</td>
		  <td valign="baseline">
		  <cfif modo NEQ 'ALTA' >
			<cfif rsForm.LOCtipo EQ 'I'>
				<input type="hidden" name="LOCtipo" id="LOCtipo" value="I">
				Lista por Idiomas
			<cfelseif rsForm.LOCtipo EQ 'P'>	
				<input type="hidden" name="LOCtipo" id="LOCtipo" value="P">
				Lista por Pa&iacute;s			
			<cfelseif rsForm.LOCtipo EQ 'V'>			
				<input type="hidden" name="LOCtipo" id="LOCtipo" value="V">		
				Valor por Pa&iacute;s		
			</cfif>
		  <cfelse>
			<select name="LOCtipo" id="LOCtipo">
				<option value="I" <cfif modo NEQ 'ALTA' and rsForm.LOCtipo EQ 'I'> selected</cfif>>Lista por Idiomas</option>
				<option value="P" <cfif modo NEQ 'ALTA' and rsForm.LOCtipo EQ 'P'> selected</cfif>>Lista por Pa&iacute;s</option>
				<option value="V" <cfif modo NEQ 'ALTA' and rsForm.LOCtipo EQ 'V'> selected</cfif>>Valor por Pa&iacute;s</option>
			</select>	  
		  </cfif>
		  </td>
		</tr>
		<tr> 
		  <td align="right" valign="top"><strong>Orden</strong>:&nbsp;</td>
		  <td valign="baseline">
			  <select name="LOCorden" id="LOCorden">
				<option value="V" <cfif modo NEQ 'ALTA' and rsForm.LOCorden EQ 'V'> selected</cfif>>Valor</option>
				<option value="S" <cfif modo NEQ 'ALTA' and rsForm.LOCorden EQ 'S'> selected</cfif>>Secuencia</option>
				<option value="D" <cfif modo NEQ 'ALTA' and rsForm.LOCorden EQ 'D'> selected</cfif>>Descripci&oacute;n</option>
			  </select>
		  </td>
		</tr>		
		<tr> 
		  <td align="center">&nbsp;</td>
		  <td align="center">&nbsp;</td>
		</tr>
		<tr> 
		  <td align="center" colspan="2"> 
		  	<cfset mensajeDelete = "¿Desea Eliminar el Concepto ?"> 
			
			
<!--- 			<input type="hidden" name="botonSel" value="">
			<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
			<cfif modo EQ "ALTA">
				<input type="submit" name="Alta" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion();">
				<input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name">
			<cfelse>	
				<input type="submit" name="Baja" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('<cfoutput>#mensajeDelete#</cfoutput>') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
				<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
			</cfif> --->
			
			<cfinclude template="../portlets/pBotones.cfm">

			<input type="button" onClick="Alista()" name="lista" value="Ir a Lista"> 
		  </td>
		</tr>
	  </table>
  </cfoutput>
</form>	  

<cfif modo NEQ 'ALTA'>
	<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
	  <tr>
		<td>
			<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Valores del Concepto">
				<table width="100%" border="1" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="38%" valign="top">
						<cfinvoke component="aspAdmin.Componentes.pListasASP" 
								  method="pLista" 
								  returnvariable="pListaValoresConceptos">
							<cfinvokeargument name="tabla" value="
									LocaleValores lv
									, LocaleConcepto lc
									, Idioma i"/>
							<cfinvokeargument name="columnas" value="
									convert(varchar,lv.LOCid) as LOCid
									, convert(varchar,LOVid) as LOVid
									, LOVvalor
									, LOVdescripcion
									, LOVsecuencia
									, LOVvalor
									, (lv.Icodigo + '-' + Descripcion) as Descripcion"/>
							<cfinvokeargument name="desplegar" value="Descripcion,LOVsecuencia,LOVvalor,LOVdescripcion"/>
							<cfinvokeargument name="etiquetas" value="Idioma,Secuencia,Valor,Traducci&oacute;n"/>
							<cfinvokeargument name="formatos"  value=""/>
							<cfinvokeargument name="filtro" value="
									lv.LOCid=#form.LOCid#
									and lv.LOCid=lc.LOCid 
									and lv.Icodigo=i.Icodigo
									and LOVsecuencia != 0"/>
							<cfinvokeargument name="align" value="left,center,center,left"/>
							<cfinvokeargument name="ajustar" value="N,N,N,N"/>
							<cfinvokeargument name="keys" value="LOCid,LOVid"/>
							<cfinvokeargument name="irA" value="conceptos.cfm"/>
							<cfinvokeargument name="formName" value="form_listaValoresConceptos"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="botones" value="Nuevo"/>						
							<cfinvokeargument name="navegacion" value="LOCid=#form.LOCid#"/>
						</cfinvoke>					
					</td>
					<td width="2%">&nbsp;</td>
					<td width="60%" valign="top"><cfinclude template="valoresConceptos_form.cfm"></td>
				  </tr>
				</table>
			</cf_web_portlet>		
		</td>
	  </tr>
	</table>
</cfif>
<script language="JavaScript">
//---------------------------------------------------------------------------------------		
	function Alista() {
		<cfif modo NEQ 'ALTA'>
			document.formConceptos.LOCid.value = '-1';
		</cfif>
		document.formConceptos.action="conceptos.cfm";
		document.formConceptos.submit();
	}
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacion() {
		objForm.LOCnombre.required = false;
		objForm.LOCtipo.required = false;		
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.LOCnombre.required = true;
		objForm.LOCtipo.required = true;		
	}	
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formConceptos");
//---------------------------------------------------------------------------------------
	objForm.LOCnombre.required = true;
	objForm.LOCnombre.description = "Nombre";		
	objForm.LOCtipo.required = true;
	objForm.LOCtipo.description = "Tipo";		
</script>
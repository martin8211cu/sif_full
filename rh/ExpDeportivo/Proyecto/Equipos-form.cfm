<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>



<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Equipos"
Default="Equipos"
returnvariable="LB_Equipos"/>



<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Telefono"
Default="Tel&eacute;fono"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_Telefono"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Fax"
Default="Fax"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_Fax"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Direccion"
Default="Direcci&oacute;n"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_Direccion"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Ciudad"
Default="Ciudad"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_Ciudad"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Provincia"
Default="Provincia"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_Provincia"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Pais"
Default="Pa&iacute;s"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_Pais"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Logo"
Default="Logo"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_Logo"/>

<!--- Consultas --->
<cfif modo neq 'ALTA'>
	<!--- Form --->
	 <cfquery name="rsForm" datasource="#session.DSN#">
		select EDid, Ecodigo, Edescripcion, ts_rversion, Etelefono1, Efax, Edireccion1, Eciudad, Eprovincia, Ppais, logo 
		from Equipo
		where EDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDid#">
	</cfquery>
</cfif>
<cfquery name="rsPais" datasource="asp">
select Ppais, Pnombre
from Pais
</cfquery>

<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	function validar(f){
		f.obj.Ecodigo.disabled = false;
		return true;
	}

	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>
<cfoutput>
<form name="form1" method="post" action="../Proyecto/Equipos-sql.cfm" onSubmit="return validar(this);">
<cfif isdefined("url.popup") and url.popup eq "s">
<input type="hidden" name="popup" value="s" /> 

</cfif>
 
	<!---   <table width="100%" border="0" cellspacing="0" cellpadding="0"> --->
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr> 
		  <td align="right"><cf_translate key="LB_Codigo" XmlFile="/rh/ExpDeportivo/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</td>
		  <td>
			<input name="Ecodigo" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Ecodigo)#</cfif>" tabindex="1" size="5" maxlength="5"  onfocus="javascript:this.select();" >
		  </td>
		</tr>
		<tr> 
		  <td align="right" nowrap><cf_translate key="LB_Descripcion" XmlFile="/rh/ExpDeportivo/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
		  <td><input name="Edescripcion" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.Edescripcion#</cfif>" size="60" maxlength="80" onFocus="javascript:this.select();" ></td>
		</tr>
		<tr> 
		  <td align="right" nowrap>#LB_Telefono#:&nbsp;</td>
		  <td><input name="Etelefono1" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.Etelefono1#</cfif>" size="15" maxlength="30" onFocus="javascript:this.select();" ></td>
		  
		</tr>
			<tr> 
		  <td align="right" nowrap>#LB_Fax#:&nbsp;</td>
		  <td><input name="Efax" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.Efax#</cfif>" size="15" maxlength="30" onFocus="javascript:this.select();" ></td>
		  
		</tr>
		<tr> 
		  <td align="right" nowrap>#LB_Direccion#:&nbsp;</td>
		  <td><input name="Edireccion1" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.Edireccion1#</cfif>" size="60" maxlength="80" onFocus="javascript:this.select();" ></td>		  
		</tr>
		<tr> 
		  <td align="right" nowrap>#LB_Ciudad#:&nbsp;</td>
		  <td><input name="Eciudad" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.Eciudad#</cfif>" size="15" maxlength="30" onFocus="javascript:this.select();" ></td>		  
		</tr>
		<tr> 
		  <td align="right" nowrap>#LB_Provincia#:&nbsp;</td>
		  <td><input name="Eprovincia" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.Eprovincia#</cfif>" size="15" maxlength="30" onFocus="javascript:this.select();" ></td>		  
		</tr>
		<tr> 
		  <td align="right" nowrap>#LB_Pais#:&nbsp;</td>
		  <td class="fileLabel">
						<select name="Ppais">
							<option value="">(<cf_translate key="CMB_Seleccione_un_Pais">Seleccione un Pa&iacute;s</cf_translate>)</option>
							<cfloop query="rsPais">
								<option value="#Ppais#"<cfif modo NEQ 'ALTA' and rsPais.Ppais EQ rsForm.Ppais> selected</cfif>>#Pnombre#</option>
							</cfloop>
						</select>
					</td>
		  </tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<cfset tabindex="1">
				<cfinclude template="/rh/portlets/pBotones.cfm">
			</td>
		</tr>
	
		<cfset ts = "">	
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<tr><td><input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>"></td></tr>
	
<!--- 	  </table>  ---> 
	 
		<input type="hidden" name="EDid" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.EDid#</cfoutput></cfif>">
	 
 
 </form> 
</cfoutput>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	XmlFile="/rh/ExpDeportivo/generales.xml"
	returnvariable="MSG_Codigo"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	XmlFile="/rh/ExpDeportivo/generales.xml"
	returnvariable="MSG_Descripcion"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Pais"
	Default="País"
	XmlFile="/rh/ExpDeportivo/generales.xml"
	returnvariable="MSG_Pais"/>


<script language="JavaScript1.2" type="text/javascript">
	<cfif modo NEQ 'ALTA'>
		document.form1.Edescripcion.focus();
	<cfelse>
		document.form1.Ecodigo.focus();
	</cfif>

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	<cfoutput>
		objForm.Ecodigo.required = true;
		objForm.Ecodigo.description="#MSG_Codigo#";
		objForm.Edescripcion.required = true;
		objForm.Edescripcion.description="#MSG_Descripcion#";
		objForm.Ppais.required = true;
		objForm.Ppais.description="#MSG_Pais#";
	</cfoutput>

	function deshabilitarValidacion(){
		objForm.Ecodigo.required = false;
		objForm.Edescripcion.required = false;
		objForm.Ppais.required = false;
	}
	
</script>

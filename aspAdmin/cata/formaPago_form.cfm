<!--- Establecimiento del modo --->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif #form.modo# EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!---       Consultas      --->
<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		select convert(varchar,FPcodigo) as FPcodigo
			, FPnombre
			, FPtipo 
		from FormaPago
		where FPcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPcodigo#">
	</cfquery>
</cfif>

<script language="JavaScript" src="../js/qForms/qforms.js">//</script>
<form action="formaPago_SQL.cfm" method="post" name="formFormaPago">
	<cfif modo NEQ 'ALTA'>
		<input name="FPcodigo" type="hidden" value="<cfoutput>#form.FPcodigo#</cfoutput>">
	</cfif>
	<table width="95%" border="0" cellpadding="2" cellspacing="0" align="center">
		<tr>
		  	<td class="tituloMantenimiento" colspan="3" align="center">
				<cfif modo eq "ALTA">
					Nueva Forma de Pago
					<cfelse>
					Modificar Forma de Pago
				</cfif>
			</td>
		</tr>
		<tr> 
		  <td align="right" valign="top"><strong>Nombre</strong>:&nbsp;</td>
		  <td valign="baseline"><input name="FPnombre" type="text" id="FPnombre" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.FPnombre#</cfoutput></cfif>" size="60" maxlength="60"></td>
		</tr>
		<tr> 
		  <td width="28%" align="right" valign="baseline"><strong>Tipo</strong>:&nbsp;</td>
		  <td width="72%" valign="baseline">
		    <select name="FPtipo" id="FPtipo">
		      <option value="1" <cfif modo neq 'ALTA' and rsForm.FPtipo EQ '1'> selected</cfif>>Tarjeta de cr&eacute;dito</option>
              </select></td>
		</tr>		
		<tr> 
		  <td align="center">&nbsp;</td>
		  <td align="center">&nbsp;</td>
		</tr>
		<tr> 
		  <td align="center" colspan="2">
		  	<cfset mensajeDelete = "¿Desea Eliminar la Forma de Pago ?">
		  	<cfinclude template="../portlets/pBotones.cfm">
		  </td>
		</tr>
	  </table>
</form>	  

<cfif modo NEQ 'ALTA'>
	<table width="95%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td>
			<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Datos de Forma de Pago">		
				<table width="100%" border="0" cellspacing="0" cellpadding="0">	
				  <tr>
					<td valign="top" width="45%">	
						<cfinvoke component="aspAdmin.Componentes.pListasASP" 
								  method="pLista" 
								  returnvariable="pListaFormaPagoDatos">
							<cfinvokeargument name="tabla" value="FormaPagoDatos"/>
							<cfinvokeargument name="columnas" value="
								convert(varchar,FPcodigo) as FPcodigo
								, convert(varchar,FPDcodigo) as FPDcodigo
								, FPDnombre
								, case FPDtipoDato
									when 'F' then 'Fecha' 
									when 'N' then 'Numérico' 
									when 'C' then 'Caracter' 
									when 'P' then 'Password' 
									else ''
								end as FPDtipoDato
								, FPDorden"/>
							<cfinvokeargument name="desplegar" value="FPDnombre, FPDtipoDato,FPDorden"/>
							<cfinvokeargument name="etiquetas" value="Nombre,Tipo,Orden"/>
							<cfinvokeargument name="formatos"  value=""/>
							<cfinvokeargument name="filtro" value="FPcodigo=#form.FPcodigo# order by FPDorden, FPDnombre"/>
							<cfinvokeargument name="align" value="left,left,center"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="keys" value="FPcodigo,FPDcodigo"/>
							<cfinvokeargument name="irA" value="formaPago.cfm"/>
							<cfinvokeargument name="formName" value="form_listaFormaPagoDatos"/>
						</cfinvoke>		
					</td>
					<td valign="top" width="55%"><cfinclude template="formaPagoDatos_form.cfm"></td>
				  </tr>
				</table>
			
			</cf_web_portlet>
		</td>
	  </tr>
	</table>
</cfif>

<script language="JavaScript">
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacion() {
		objForm.FPnombre.required = false;		
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.FPnombre.required = true;		
	}	
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formFormaPago");
//---------------------------------------------------------------------------------------
	objForm.FPnombre.required = true;
	objForm.FPnombre.description = "Nombre";		
</script>
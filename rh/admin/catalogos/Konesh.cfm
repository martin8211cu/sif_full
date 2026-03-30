<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 		= t.Translate('LB_TituloH','SIF - Konesh')>
<cfset TIT_ReptK	= t.Translate('','Parametros de Conexion Konesh')>
<cfset LB_Url		= t.Translate('LB_Url','URL')>
<cfset LB_Cta		= t.Translate('LB_Cta','Cuenta')>
<cfset LB_User		= t.Translate('LB_User','Usuario')>
<cfset LB_Pass		= t.Translate('LB_Pass','Password')>
<cfset LB_tkn		= t.Translate('LB_tkn','Token')>
<cfset BTN_Agregar   = t.Translate('BTN_Agregar','Agregar')>


<cfset modo  = "ALTA">
<cfparam name="URLv"     default="">
<cfparam name="Cta"     default="">
<cfparam name="usuario"     default="">
<cfparam name="pass"     default="">
<cfparam name="tkn"     default="">

<cfquery name="rsUrl" datasource="#Session.DSN#">
	select Pvalor as URLv
	from Parametros
	where Pcodigo = 440
	and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rsusr" datasource="#Session.DSN#">
	select Pvalor as usuario
	from Parametros
	where Pcodigo = 442
	and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rspass" datasource="#Session.DSN#">
	select Pvalor as pass
	from Parametros
	where Pcodigo = 443
	and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rscta" datasource="#Session.DSN#">
	select Pvalor as Cta
	from Parametros
	where Pcodigo = 444
	and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rstkn" datasource="#Session.DSN#">
	select Pvalor as tkn
	from Parametros
	where Pcodigo = 445
	and Ecodigo = #Session.Ecodigo#
</cfquery>

<cfif rsusr.recordCount gt 0>
 <cfset modo = "CAMBIO">

<cfset URLv ="#rsUrl.URLv#">
<cfset Cta =" #rscta.Cta#">
<cfset usuario=#rsusr.usuario#>
<cfset pass=#rspass.pass#>
<cfset tkn=#rstkn.tkn#>
</cfif>

<cf_templateheader title="#LB_TituloH#">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_ReptK#'>
  <cfinclude template="../../cg/consultas/Funciones.cfm">
  <script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
  <cfset periodo="#get_val(50).Pvalor#">
  <cfset mes="#get_val(60).Pvalor#">
<form name="form1" method="get" action="SQLRegistroKonesh.cfm" onsubmit="return validaOption();">

<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">

			<table  width="80%" cellpadding="5" cellspacing="0" border="0">
				<tr>
					<td colspan="8">&nbsp;</td>
				</tr>
				<tr>
                	<cfoutput>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="right"><strong>#LB_Url#:</strong></td>
					<td>
					<cfoutput><input name="Urlv" tabindex="1" type="text" title="Solo Letras y Numeros" value="#URLv#" size="80" maxlength="70" /></cfoutput>
					</td>
                    </cfoutput>
				</tr>
				<tr>
                	<cfoutput>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="right"><strong>#LB_Cta#:</strong></td>
					<td>
					<cfoutput><input name="Cuenta" tabindex="1" type="text" title="Solo Letras y Numeros" value="#Cta#" size="20" maxlength="12" /></cfoutput>
					</td>
                    </cfoutput>
				</tr>
				<tr>
                	<cfoutput>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="right"><strong>#LB_User#:</strong></td>
					<td>
					<cfoutput><input name="usuario" tabindex="1" type="text" title="Solo Letras y Numeros" value="#usuario#" size="15" maxlength="15" /></cfoutput>
					</td>
                    </cfoutput>
				</tr>
				<tr>
                	<cfoutput>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="right"><strong>#LB_Pass#:</strong></td>
					<td>
					<cfoutput><input name="pass" tabindex="1" type="text" title="Solo Letras y Numeros" value="#pass#" size="15" maxlength="15" /></cfoutput>
					</td>
                    </cfoutput>
				</tr>
				<tr>
                	<cfoutput>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="right"><strong>#LB_tkn#:</strong></td>
					<td>
					<cfoutput><input name="tkn" tabindex="1" type="text" title="Solo Letras y Numeros" value="#tkn#" size="15" maxlength="15" /></cfoutput>
					</td>
                    </cfoutput>
				</tr>

				<tr>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>

				</tr>
				<tr>
					<td colspan="6">
                   <div align="center">
					<cfif modo EQ "ALTA">
                  <cfoutput>
                    <input name="Agregar" class="btnGuardar"  tabindex="1" type="submit" value="#BTN_Agregar#" >
                  </cfoutput>
				  <cfelse>
				    <input name="Modificar" class="btnGuardar"  tabindex="1" type="submit" value="Modificar">
                    <input name="Borrar" class="btnEliminar"  tabindex="1" type="submit" value="Eliminar">
                  </cfif>
				</div>
					</td>
				</tr>
			</table>

		</td>
	</tr>
</table>
</form>
<script>

function validaOption(){
mensa = "";

	if(document.form1.Urlv.value == ""){
		mensa = "\n- Es necesario indicar el URL";
	}

	if(document.form1.Cuenta.value == ""){
		mensa =mensa + "\n- Es necesario indicar la Cuenta";
	}

	if(document.form1.usuario.value == ""){
		mensa =mensa + "\n- Es necesario indicar el Usuario";
	}

	if(document.form1.pass.value == ""){
		mensa =mensa + "\n- Es necesario indicar el Password";
	}

	if(document.form1.tkn.value == ""){
		mensa =mensa + "\n- Es necesario indicar el Token";
	}

	if(mensa != ""){
	alert("Se presentaron los siguientes errores: \n" + mensa);
	return false;
	}


}
</script>


<cf_web_portlet_end>
<cf_templatefooter>
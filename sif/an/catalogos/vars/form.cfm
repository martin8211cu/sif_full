<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Nombre" 	default="Nombre" 
returnvariable="LB_Nombre" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Descripcion" 	default="Descripci&oacute;n" 
returnvariable="LB_Descripcion" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_TipoDato" 	default="Tipo de Dato" 
returnvariable="LB_TipoDato" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Mensaje" 	default="Esta descripci&oacute;n ser&aacute; desplegada en la pantalla de captura de variables." returnvariable="LB_Mensaje" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="CHK_RegistraValorOficina" 	default="Registrar un valor distinto para cada oficina" returnvariable="CHK_RegistraValorOficina" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="CHK_RegistraValorAnio" 	default="Registrar un sólo valor por año" returnvariable="CHK_RegistraValorAnio" xmlfile="form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="CHK_UltimoValor" 	default="Arrastrar útlimo valor anterior" returnvariable="CHK_UltimoValor" xmlfile="form.xml"/>			
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Caracter" 	default="Caracter" 
returnvariable="LB_Caracter" xmlfile="form.xml"/> 
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Moneda" 	default="Moneda" 
returnvariable="LB_Moneda" xmlfile="form.xml"/> 
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Flotante" 	default="Flotante" 
returnvariable="LB_Flotante" xmlfile="form.xml"/>
<cfset modo="ALTA"><cfif isdefined("form.AVid") and form.AVid GT 0><cfset modo="CAMBIO"></cfif>
<cfif modo neq "ALTA">
	<cfquery name="rsForm" datasource="#session.dsn#">
		select AVid, AVnombre, AVdescripcion, AVtipo, AVusar_oficina, AVvalor_anual, AVvalor_arrastrar, ts_rversion
		from AnexoVar
		where AVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AVid#">
	</cfquery>
</cfif>
<cfoutput>
<form action="sql.cfm" method="post" name="form1">
	<cfif modo neq "ALTA">
		<input type="hidden" name="AVid" value="#rsForm.AVid#">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts" arTimeStamp = "#rsForm.ts_rversion#"/>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
	<br>
	<table  
		border="0" width="422"
		cellspacing="2" 
		cellpadding="0">
	<tr>
	<td width="92" valign="top"><strong> #LB_Nombre#:&nbsp;
	</strong></td>
	<td colspan="2" valign="top">
		<input name="AVnombre" type="text" size="38" maxlength="30" <cfif modo neq "ALTA">value="#rsForm.AVnombre#"</cfif> style="width:210px" onfocus="this.select()">
	</td>
	</tr>
	<tr>
	<td valign="top"><strong> #LB_Descripcion#:&nbsp;
	</strong></td>
	<td colspan="2" valign="top">
	<textarea name="AVdescripcion" cols="40" rows="3" style="font-family:Arial, Helvetica, sans-serif;font-size:10px;width:210px"><cfif modo neq "ALTA">#rsForm.AVdescripcion#</cfif></textarea>
	</td>
	</tr>
	<tr>
	<td valign="top">&nbsp;</td>
	<td colspan="2" valign="top">
		<p>#LB_Mensaje#		</p>
	</td>
	</tr>
	<tr>
	<td valign="top"><strong><cfoutput> #LB_TipoDato#</cfoutput>:&nbsp;
	</strong></td>
	<td colspan="2" valign="top">
		<select name="AVtipo">
			<option value="C"<cfif modo neq "ALTA" and rsForm.AVtipo eq 'C'>selected</cfif>>#LB_Caracter#</option>
			<option value="M"<cfif modo neq "ALTA" and rsForm.AVtipo eq 'M'>selected</cfif>>#LB_Moneda#</option>
			<option value="F"<cfif modo neq "ALTA" and rsForm.AVtipo eq 'F'>selected</cfif>>#LB_Flotante#</option>
		</select>
	</td>
	</tr>
	<tr>
	  <td valign="top">&nbsp;</td>
	  <td width="25" valign="middle"><input name="AVusar_oficina" type="checkbox" id="AVusar_oficina" value="1" <cfif (modo NEQ "ALTA") AND (rsForm.AVusar_oficina EQ 1)>checked</cfif>></td>
	  <td width="297" valign="middle"><label for="AVusar_oficina">#CHK_RegistraValorOficina#</label></td>
	</tr>
	<tr>
	  <td valign="top">&nbsp;</td>
	  <td width="25" valign="middle"><input name="AVvalor_anual" type="checkbox" id="AVvalor_anual" value="1" <cfif (modo NEQ "ALTA") AND (rsForm.AVvalor_anual EQ 1)>checked</cfif>></td>
	  <td width="297" valign="middle"><label for="AVvalor_anual">#CHK_RegistraValorAnio#</label></td>
	</tr>
	<tr>
	  <td valign="top">&nbsp;</td>
	  <td width="25" valign="middle"><input name="AVvalor_arrastrar" type="checkbox" id="AVvalor_arrastrar" value="1" <cfif (modo NEQ "ALTA") AND (rsForm.AVvalor_arrastrar EQ 1)>checked</cfif>></td>
	  <td width="297" valign="middle"><label for="AVvalor_arrastrar">#CHK_UltimoValor#</label></td>
	</tr>
	</table>
	<br>
	<cf_botones modo="#modo#">
</form>
<cf_qforms>
<script language="javascript" type="text/javascript">
<!--//
	objForm.AVnombre.description = "#JSStringFormat('Nombre')#";
	objForm.AVdescripcion.description = "#JSStringFormat('Descripcin')#";
	function habilitarValidacion(){
		objForm.AVnombre.required = true;
		objForm.AVdescripcion.required = true;
	}
	function desahabilitarValidacion(){
		objForm.AVnombre.required = false;
		objForm.AVdescripcion.required = false;
	}
	habilitarValidacion();
	objForm.AVnombre.obj.focus();
//-->
</script>
</cfoutput>	
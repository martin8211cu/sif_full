<cfif isdefined("url.CPSMid") and len(trim(url.CPSMid))>
	<cfset form.CPSMid = url.CPSMid>
</cfif>
<cfif isdefined("form.CPSMid") and len(trim(form.CPSMid))>
	<cfquery name="rsCPCFMascaras.rsFormCPSM" datasource="#Session.dsn#">
		select CPSMid, Ecodigo, Usucodigo, CPSMascaraP, CPSMdescripcion, CPSMconsultar, CPSMtraslados, CPSMreservas, CPSMformulacion, ts_rversion, 
				' ' as ts
		from CPSeguridadMascarasCtasP
		where Ecodigo = #Session.Ecodigo#
		and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
		and CPSMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPSMid#">
	</cfquery>
	<cfinvoke 
		component="sif.Componentes.DButils"
		method="toTimeStamp"
		returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsCPCFMascaras.rsFormCPSM.ts_rversion#"/>
	</cfinvoke>
	<cfset QuerySetCell(rsCPCFMascaras.rsFormCPSM,'ts',ts)>
</cfif>
<cfquery name="rsCPCFMascaras.ListaMascaras" datasource="#Session.dsn#">
	select CPSMid, Ecodigo, Usucodigo, CPSMascaraP, CPSMdescripcion, CPSMconsultar, CPSMtraslados, CPSMreservas, CPSMformulacion, ts_rversion, 
			' ' as ts
	from CPSeguridadMascarasCtasP
	where Ecodigo = #Session.Ecodigo#
	and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
</cfquery>
<cfloop query="rsCPCFMascaras.ListaMascaras">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts#CurrentRow#" arTimeStamp="#rsCPCFMascaras.ListaMascaras.ts_rversion#"/>
	<cfset QuerySetCell(rsCPCFMascaras.ListaMascaras,'ts',Evaluate('ts'&CurrentRow),rsCPCFMascaras.ListaMascaras.CurrentRow)>
</cfloop>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="subtitulo">Lista de Cuentas Especiales Autorizadas al Usuario</td>
  </tr>
</table>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="titulolistas">&nbsp;</td>
    <td class="titulolistas">Tipo&nbsp;</td>
    <td class="titulolistas">M&aacute;scara&nbsp;</td>
    <td class="titulolistas">Consultar&nbsp;</td>
    <td class="titulolistas">Formular&nbsp;</td>
	<td class="titulolistas">&nbsp;</td>
  </tr>
  <cfoutput><form action="PSUsuariosMascaras-sql.cfm" method="post" name="formPSUMascaras">
  <input type="hidden" id="Usucodigo" name="Usucodigo" value="#form.Usucodigo#">
  <input type="hidden" id="CPSMid" name="CPSMid" value="<cfif isdefined("rsCPCFMascaras.rsFormCPSM.CPSMid")>#rsCPCFMascaras.rsFormCPSM.CPSMid#<cfelse><cfset LvarNuevo=true></cfif>">
  <input type="hidden" id="ts_rversion" name="ts_rversion" value="<cfif isdefined("rsCPCFMascaras.rsFormCPSM.ts")>#rsCPCFMascaras.rsFormCPSM.ts#</cfif>">
  <input type="hidden" id="CPSMdelete" name="CPSMdelete">
  <tr>
	<td>&nbsp;</td>
    <td><input name="txtCPSMdescripcion" type="text" value="<cfif isdefined("rsCPCFMascaras.rsFormCPSM.CPSMdescripcion")>#rsCPCFMascaras.rsFormCPSM.CPSMdescripcion#</cfif>" size="20" maxlength="40">&nbsp;</td>
    <td><input name="txtCPSMascaraP" type="text" value="<cfif isdefined("rsCPCFMascaras.rsFormCPSM.CPSMascaraP")>#rsCPCFMascaras.rsFormCPSM.CPSMascaraP#</cfif>" size="20" maxlength="100">&nbsp;</td>
	<td><input name="CPSMconsultar" type="checkbox" <cfif isdefined("LvarNuevo") OR isdefined("rsCPCFMascaras.rsFormCPSM.CPSMconsultar") and rsCPCFMascaras.rsFormCPSM.CPSMconsultar>checked</cfif>>&nbsp;</td>
    <td><input name="CPSMformulacion" type="checkbox" <cfif isdefined("LvarNuevo") OR isdefined("rsCPCFMascaras.rsFormCPSM.CPSMformulacion") and rsCPCFMascaras.rsFormCPSM.CPSMformulacion>checked</cfif>>&nbsp;</td>
	<td><input name="<cfif isdefined("rsCPCFMascaras.rsFormCPSM.CPSMid")>btnUpdMascaras<cfelse>btnAddMascaras</cfif>" type="submit" value="&nbsp;+&nbsp;">&nbsp;</td>
  </tr>
  </form></cfoutput>
  <cfif rsCPCFMascaras.ListaMascaras.recordcount>
	  <cfoutput query="rsCPCFMascaras.ListaMascaras"><tr onClick="if (document.nosubmit==true) {document.nosubmit=false; return;} document.formListaPSUMascaras.CPSMid.value=#CPSMid#; document.formListaPSUMascaras.submit();"
	  	class="<cfif CurrentRow Mod 2 EQ 0>listaNon<cfelse>listaPar</cfif>"
		onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif CurrentRow Mod 2 EQ 0>listaNon<cfelse>listaPar</cfif>';"
		style="cursor:pointer;">
		<td><cfif isdefined("form.CPSMid") and CPSMid EQ form.CPSMid><img src="/cfmx/sif/imagenes/addressGo.gif"><cfelse><img src="/cfmx/sif/imagenes/Borrar01_S.gif" width="16" height="16" onClick="document.nosubmit=true; if (!confirm('¿Desea eliminar el registro?')) return false; document.formPSUMascaras.CPSMdelete.value=#CPSMid#; document.formPSUMascaras.txtCPSMascaraP.value='x'; document.formPSUMascaras.txtCPSMdescripcion.value='x'; document.formPSUMascaras.submit();"></cfif></td>
		<td nowrap>#CPSMdescripcion#</td>
		<td nowrap>#CPSMascaraP#</td>
		<td><cfif CPSMconsultar><img src="/cfmx/sif/imagenes/checked.gif" onClick="document.nosubmit=true;this.src='PSUM-checkbox.cfm?Usucodigo=#form.Usucodigo#&CPSMid=#CPSMid#&ts_rversion=#ts#&Who=CPSMconsultar'"><cfelse><img src="/cfmx/sif/imagenes/unchecked.gif" onClick="document.nosubmit=true;this.src='PSUM-checkbox.cfm?Usucodigo=#form.Usucodigo#&CPSMid=#CPSMid#&ts_rversion=#ts#&Who=CPSMconsultar'"></cfif></td>
		<td><cfif CPSMformulacion><img src="/cfmx/sif/imagenes/checked.gif" onClick="document.nosubmit=true;this.src='PSUM-checkbox.cfm?Usucodigo=#form.Usucodigo#&CPSMid=#CPSMid#&ts_rversion=#ts#&Who=CPSMformulacion'"><cfelse><img src="/cfmx/sif/imagenes/unchecked.gif" onClick="document.nosubmit=true;this.src='PSUM-checkbox.cfm?Usucodigo=#form.Usucodigo#&CPSMid=#CPSMid#&ts_rversion=#ts#&Who=CPSMformulacion'"></cfif></td>
		<td>&nbsp;</td>
    </tr></cfoutput>
  <cfelse>
	  <tr><td align="center" colspan="8"><strong>-- No se encontr&oacute; ning&uacute;n resultado --</strong></td></tr>
  </cfif>
  <form action="PSUsuarios.cfm" method="post" name="formListaPSUMascaras">
	  <cfoutput><input type="hidden" id="Usucodigo" name="Usucodigo" value="#form.Usucodigo#"></cfoutput>
	  <input type="hidden" id="CPSMid" name="CPSMid">
  </form>
</table>
</div>
<cf_qforms form="formPSUMascaras" objForm="objForm2"/>
<script language="javascript" type="text/javascript">
<!--//
	objForm2.txtCPSMascaraP.description="Tipo";
	objForm2.txtCPSMdescripcion.description="<cfoutput>#JSStringFormat('Máscara')#</cfoutput>";
	objForm2.required("txtCPSMascaraP,txtCPSMdescripcion",true);	
//-->
</script>
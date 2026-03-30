<cfif isdefined("url.CPSMid") and len(trim(url.CPSMid))>
	<cfset form.CPSMid = url.CPSMid>
</cfif>
<cfif isdefined("form.CPSMid") and len(trim(form.CPSMid))>
	<cfquery name="rsCPCFMascaras.rsFormCPSM" datasource="#Session.dsn#">
		select CPSMid, Ecodigo, CFid as CFpk, Usucodigo, CPSMascaraP, CPSMdescripcion, CPSMconsultar, CPSMtraslados, CPSMreservas, CPSMformulacion, ts_rversion, 
				' ' as ts
		from CPSeguridadMascarasCtasP
		where Ecodigo = #Session.Ecodigo#
		and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
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
	select CPSMid, Ecodigo, CFid as CFpk, Usucodigo, CPSMascaraP, CPSMdescripcion, CPSMconsultar, CPSMtraslados, CPSMreservas, CPSMformulacion, ts_rversion, 
			' ' as ts
	from CPSeguridadMascarasCtasP
	where Ecodigo = #Session.Ecodigo#
	and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
</cfquery>
<cfloop query="rsCPCFMascaras.ListaMascaras">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts#CurrentRow#" arTimeStamp="#rsCPCFMascaras.ListaMascaras.ts_rversion#"/>
	<cfset QuerySetCell(rsCPCFMascaras.ListaMascaras,'ts',Evaluate('ts'&CurrentRow),rsCPCFMascaras.ListaMascaras.CurrentRow)>
</cfloop>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="subtitulo">Lista de Cuentas de Presupuesto Autorizadas</td>
  </tr>
</table>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="titulolistas">&nbsp;</td>
    <td class="titulolistas">Tipo&nbsp;</td>
    <td class="titulolistas">M&aacute;scara&nbsp;</td>
    <td class="titulolistas">Consultar&nbsp;</td>
    <td class="titulolistas">Trasladar&nbsp;</td>
    <td class="titulolistas">Provisionar&nbsp;</td>
    <td class="titulolistas">Formular&nbsp;</td>
	<td class="titulolistas">&nbsp;</td>
  </tr>
  <cfoutput><form action="PSCentrosFuncionalesMascaras-sql.cfm" method="post" name="formPSCFMascaras">
  <input type="hidden" id="CFpk" name="CFpk" value="#form.CFpk#">
  <input type="hidden" id="CPSMid" name="CPSMid" value="<cfif isdefined("rsCPCFMascaras.rsFormCPSM.CPSMid")>#rsCPCFMascaras.rsFormCPSM.CPSMid#</cfif>">
  <input type="hidden" id="ts_rversion" name="ts_rversion" value="<cfif isdefined("rsCPCFMascaras.rsFormCPSM.ts")>#rsCPCFMascaras.rsFormCPSM.ts#</cfif>">
  <input type="hidden" id="CPSMdelete" name="CPSMdelete">
  <tr>
	<td>&nbsp;</td>
	<cfset LvarNuevo = NOT isdefined("rsCPCFMascaras.rsFormCPSM.CPSMid")>
    <td><input name="txtCPSMdescripcion" type="text" value="<cfif isdefined("rsCPCFMascaras.rsFormCPSM.CPSMdescripcion")>#rsCPCFMascaras.rsFormCPSM.CPSMdescripcion#</cfif>" size="20" maxlength="40">&nbsp;</td>
    <td><input name="txtCPSMascaraP" type="text" value="<cfif isdefined("rsCPCFMascaras.rsFormCPSM.CPSMascaraP")>#rsCPCFMascaras.rsFormCPSM.CPSMascaraP#</cfif>" size="20" maxlength="100">&nbsp;</td>
	<td><input name="CPSMconsultar" type="checkbox" <cfif isdefined("LvarNuevo") OR isdefined("rsCPCFMascaras.rsFormCPSM.CPSMconsultar") and rsCPCFMascaras.rsFormCPSM.CPSMconsultar>checked</cfif>>&nbsp;</td>
    <td><input name="CPSMtraslados" type="checkbox" <cfif isdefined("LvarNuevo") OR isdefined("rsCPCFMascaras.rsFormCPSM.CPSMtraslados") and rsCPCFMascaras.rsFormCPSM.CPSMtraslados>checked</cfif>>&nbsp;</td>
    <td><input name="CPSMreservas" type="checkbox" <cfif isdefined("LvarNuevo") OR isdefined("rsCPCFMascaras.rsFormCPSM.CPSMreservas") and rsCPCFMascaras.rsFormCPSM.CPSMreservas>checked</cfif>>&nbsp;</td>
    <td><input name="CPSMformulacion" type="checkbox" <cfif isdefined("LvarNuevo") OR isdefined("rsCPCFMascaras.rsFormCPSM.CPSMformulacion") and rsCPCFMascaras.rsFormCPSM.CPSMformulacion>checked</cfif>>&nbsp;</td>
	<td>
		<input name="<cfif isdefined("rsCPCFMascaras.rsFormCPSM.CPSMid")>btnUpdMascaras<cfelse>btnAddMascaras</cfif>" type="submit" value="&nbsp;+&nbsp;" title="Agregar/modificar la Máscara únicamente en este Centro Funcional">&nbsp;
	</td>
  </tr>
  </form></cfoutput>
  <cfif rsCPCFMascaras.ListaMascaras.recordcount>
	  <cfoutput query="rsCPCFMascaras.ListaMascaras"><tr onClick="if (document.nosubmit==true) {document.nosubmit=false; return;} document.formListaPSCFMascaras.CPSMid.value=#CPSMid#; document.formListaPSCFMascaras.submit();"
	  	class="<cfif CurrentRow Mod 2 EQ 0>listaNon<cfelse>listaPar</cfif>"
		onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif CurrentRow Mod 2 EQ 0>listaNon<cfelse>listaPar</cfif>';"
		style="cursor:pointer;">
		<td><cfif isdefined("form.CPSMid") and CPSMid EQ form.CPSMid><img src="/cfmx/sif/imagenes/addressGo.gif"><cfelse><img src="/cfmx/sif/imagenes/Borrar01_S.gif" width="16" height="16" onClick="document.nosubmit=true; if (!confirm('¿Desea eliminar el registro?')) return false; document.formPSCFMascaras.CPSMdelete.value=#CPSMid#; document.formPSCFMascaras.txtCPSMascaraP.value='x'; document.formPSCFMascaras.txtCPSMdescripcion.value='x'; document.formPSCFMascaras.submit();"></cfif></td>
		<td nowrap>#CPSMdescripcion#</td>
		<td nowrap>#CPSMascaraP#</td>
		<td><cfif CPSMconsultar><img src="/cfmx/sif/imagenes/checked.gif" onClick="document.nosubmit=true;this.src='PSCFM-checkbox.cfm?CFpk=#form.CFpk#&CPSMid=#CPSMid#&ts_rversion=#ts#&Who=CPSMconsultar'"><cfelse><img src="/cfmx/sif/imagenes/unchecked.gif" onClick="document.nosubmit=true;this.src='PSCFM-checkbox.cfm?CFpk=#form.CFpk#&CPSMid=#CPSMid#&ts_rversion=#ts#&Who=CPSMconsultar'"></cfif></td>
		<td><cfif CPSMtraslados><img src="/cfmx/sif/imagenes/checked.gif" onClick="document.nosubmit=true;this.src='PSCFM-checkbox.cfm?CFpk=#form.CFpk#&CPSMid=#CPSMid#&ts_rversion=#ts#&Who=CPSMtraslados'"><cfelse><img src="/cfmx/sif/imagenes/unchecked.gif" onClick="document.nosubmit=true;this.src='PSCFM-checkbox.cfm?CFpk=#form.CFpk#&CPSMid=#CPSMid#&ts_rversion=#ts#&Who=CPSMtraslados'"></cfif></td>
		<td><cfif CPSMreservas><img src="/cfmx/sif/imagenes/checked.gif" onClick="document.nosubmit=true;this.src='PSCFM-checkbox.cfm?CFpk=#form.CFpk#&CPSMid=#CPSMid#&ts_rversion=#ts#&Who=CPSMreservas'"><cfelse><img src="/cfmx/sif/imagenes/unchecked.gif" onClick="document.nosubmit=true;this.src='PSCFM-checkbox.cfm?CFpk=#form.CFpk#&CPSMid=#CPSMid#&ts_rversion=#ts#&Who=CPSMreservas'"></cfif></td>
		<td><cfif CPSMformulacion><img src="/cfmx/sif/imagenes/checked.gif" onClick="document.nosubmit=true;this.src='PSCFM-checkbox.cfm?CFpk=#form.CFpk#&CPSMid=#CPSMid#&ts_rversion=#ts#&Who=CPSMformulacion'"><cfelse><img src="/cfmx/sif/imagenes/unchecked.gif" onClick="document.nosubmit=true;this.src='PSCFM-checkbox.cfm?CFpk=#form.CFpk#&CPSMid=#CPSMid#&ts_rversion=#ts#&Who=CPSMformulacion'"></cfif></td>
		<td>&nbsp;</td>
    </tr></cfoutput>
  <cfelse>
	  <tr><td align="center" colspan="8"><strong>-- No se encontr&oacute; ning&uacute;n resultado --</strong></td></tr>
  </cfif>
  <form action="PSCentrosFuncionales.cfm" method="post" name="formListaPSCFMascaras">
	  <cfoutput><input type="hidden" id="CFpk" name="CFpk" value="#form.CFpk#"></cfoutput>
	  <input type="hidden" id="CPSMid" name="CPSMid">
  </form>
</table>
</div>
<cf_qforms form="formPSCFMascaras" objForm="objForm1"/>
<script language="javascript" type="text/javascript">
<!--//
	objForm1.txtCPSMascaraP.description="Tipo";
	objForm1.txtCPSMdescripcion.description="<cfoutput>#JSStringFormat('Máscara')#</cfoutput>";
	objForm1.required("txtCPSMascaraP,txtCPSMdescripcion",true);	
//-->
</script>
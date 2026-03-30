<cfif isdefined("url.CPSUid") and len(trim(url.CPSUid))>
	<cfset form.CPSUid = url.CPSUid>
</cfif>
<cfif isdefined("form.CPSUid") and len(trim(form.CPSUid))>
	<cfquery name="rsCPUUsuarios.rsFormCPSU" datasource="#Session.dsn#">
		select 	a.CPSUid, a.CPSUidOrigen, a.Ecodigo, a.CFid as CFpk, a.Usucodigo, a.CPSUconsultar, a.CPSUtraslados, a.CPSUreservas, a.CPSUformulacion, a.CPSUaprobacion, a.CPSUidOrigen, a.ts_rversion, 
				' ' as ts, b.CFcodigo, b.CFdescripcion
		from CPSeguridadUsuario a inner join CFuncional b on a.CFid = b.CFid and a.Ecodigo = b.Ecodigo
		where a.Ecodigo = #Session.Ecodigo#
		and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
		and a.CPSUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPSUid#">
	</cfquery>
	<cfinvoke 
		component="sif.Componentes.DButils"
		method="toTimeStamp"
		returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsCPUUsuarios.rsFormCPSU.ts_rversion#"/>
	</cfinvoke>
	<cfset QuerySetCell(rsCPUUsuarios.rsFormCPSU,'ts',ts)>
</cfif>
<cfquery name="rsCPUUsuarios.ListaUsuarios" datasource="#Session.dsn#">
	select a.CPSUidOrigen, a.CPSUid, a.Ecodigo, a.CFid as CFpk, a.Usucodigo, a.CPSUconsultar, a.CPSUtraslados, a.CPSUreservas, a.CPSUformulacion, a.CPSUaprobacion, a.CPSUidOrigen, a.ts_rversion, 
			' ' as ts, b.CFcodigo, b.CFdescripcion
	from CPSeguridadUsuario a inner join CFuncional b on a.CFid = b.CFid and a.Ecodigo = b.Ecodigo
	where a.Ecodigo = #Session.Ecodigo#
	and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
		order by coalesce(a.CPSUidOrigen, a.CPSUid), coalesce(a.CPSUidOrigen, -1), b.CFcodigo
</cfquery>
<cfloop query="rsCPUUsuarios.ListaUsuarios">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts#CurrentRow#" arTimeStamp="#rsCPUUsuarios.ListaUsuarios.ts_rversion#"/>
	<cfset QuerySetCell(rsCPUUsuarios.ListaUsuarios,'ts',Evaluate('ts'&CurrentRow),rsCPUUsuarios.ListaUsuarios.CurrentRow)>
</cfloop>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="subtitulo">Lista de Centros Funcionales Autorizados</td>
  </tr>
</table>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="titulolistas">&nbsp;</td>
	<td class="titulolistas">Centro Funcional&nbsp;</td>
    <td class="titulolistas">Consultar&nbsp;</td>
    <td class="titulolistas">Trasladar&nbsp;</td>
    <td class="titulolistas">Provisionar&nbsp;</td>
    <td class="titulolistas">Formular&nbsp;</td>
    <td class="titulolistas" align="center">APROBAR<BR>TRASLADOS&nbsp;</td>
	<td class="titulolistas">&nbsp;</td>
  </tr>
  <cfoutput><form action="PSUsuariosCentrosFuncionales-sql.cfm" method="post" name="formPSUUsuarios">
  <input type="hidden" id="Usucodigo" name="Usucodigo" value="#form.Usucodigo#">
  <input type="hidden" id="CPSUid" name="CPSUid" value="<cfif isdefined("rsCPUUsuarios.rsFormCPSU.CPSUid")>#rsCPUUsuarios.rsFormCPSU.CPSUid#</cfif>">
  <input type="hidden" id="ts_rversion" name="ts_rversion" value="<cfif isdefined("rsCPUUsuarios.rsFormCPSU.ts")>#rsCPUUsuarios.rsFormCPSU.ts#</cfif>">
  <input type="hidden" id="CPSUdelete" name="CPSUdelete">
  <tr>
	<td>&nbsp;</td>
    <td><cfif isdefined("rsCPUUsuarios.rsFormCPSU.CFpk")><cf_rhcfuncional form="formPSUUsuarios" id="CFpk" query="#rsCPUUsuarios.rsFormCPSU#"><cfelse><cfset LvarNuevo=true><cf_rhcfuncional id="CFpk" form="formPSUUsuarios"></cfif>&nbsp;</td>
    <td><input name="CPSUconsultar" type="checkbox" <cfif isdefined("LvarNuevo") OR isdefined("rsCPUUsuarios.rsFormCPSU.CPSUconsultar") and rsCPUUsuarios.rsFormCPSU.CPSUconsultar>checked</cfif>>&nbsp;</td>
    <td><input name="CPSUtraslados" type="checkbox" <cfif isdefined("LvarNuevo") OR isdefined("rsCPUUsuarios.rsFormCPSU.CPSUtraslados") and rsCPUUsuarios.rsFormCPSU.CPSUtraslados>checked</cfif>>&nbsp;</td>
    <td><input name="CPSUreservas" type="checkbox" <cfif isdefined("LvarNuevo") OR isdefined("rsCPUUsuarios.rsFormCPSU.CPSUreservas") and rsCPUUsuarios.rsFormCPSU.CPSUreservas>checked</cfif>>&nbsp;</td>
    <td><input name="CPSUformulacion" type="checkbox" <cfif isdefined("LvarNuevo") OR isdefined("rsCPUUsuarios.rsFormCPSU.CPSUformulacion") and rsCPUUsuarios.rsFormCPSU.CPSUformulacion>checked</cfif>>&nbsp;</td>
    <td align="center">&nbsp;<input name="CPSUaprobacion" type="checkbox" <cfif isdefined("rsCPUUsuarios.rsFormCPSU.CPSUaprobacion") and rsCPUUsuarios.rsFormCPSU.CPSUaprobacion>checked</cfif>>&nbsp;</td>
	<td nowrap>
		<input name="<cfif isdefined("rsCPUUsuarios.rsFormCPSU.CPSUid")>btnUpdUsuarios<cfelse>btnAddUsuarios</cfif>" type="submit" value="&nbsp;+&nbsp;"  title="Agregar/modificar el Usuario únicamente en este Centro Funcional">&nbsp;
		<cfif not isdefined("rsCPUUsuarios.rsFormCPSU.CPSUidOrigen") OR rsCPUUsuarios.rsFormCPSU.CPSUidOrigen EQ "">
		<input name="<cfif isdefined("rsCPUUsuarios.rsFormCPSU.CPSUid")>btnUpdUsuariosC<cfelse>btnAddUsuariosC</cfif>" type="submit" value="&nbsp;&raquo;&nbsp;"  title="Agregar/modificar el Usuario en este Centro Funcional y en todos sus hijos">&nbsp;
		<cfelse>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		</cfif>
	</tr>
  </form></cfoutput>
  <cfif rsCPUUsuarios.ListaUsuarios.recordcount>
	  <cfoutput query="rsCPUUsuarios.ListaUsuarios"><tr onClick="if (document.nosubmit==true) {document.nosubmit=false; return;} document.formListaPSUUsuarios.CPSUid.value=#CPSUid#; document.formListaPSUUsuarios.submit();"
	  	class="<cfif CurrentRow Mod 2 EQ 0>listaNon<cfelse>listaPar</cfif>"
		onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif CurrentRow Mod 2 EQ 0>listaNon<cfelse>listaPar</cfif>';"
		style="cursor:pointer;">
		<td><cfif isdefined("form.CPSUid") and CPSUid EQ form.CPSUid><img src="/cfmx/sif/imagenes/addressGo.gif"><cfelseif isdefined("CPSUidOrigen") and CPSUidOrigen EQ ""><img src="/cfmx/sif/imagenes/Borrar01_S.gif" width="16" height="16" onClick="document.nosubmit=true; if (!confirm('¿Desea eliminar el registro?')) return false; document.formPSUUsuarios.CPSUdelete.value='#CPSUid#'; document.formPSUUsuarios.CFpk.value='1'; document.formPSUUsuarios.submit();"></cfif></td>
		<td nowrap>#CFcodigo# - #CFdescripcion#</td>
		<td><cfif CPSUconsultar><img src="/cfmx/sif/imagenes/checked.gif" onClick="document.nosubmit=true;this.src='PSUU-checkbox.cfm?Usucodigo=#form.Usucodigo#&CPSUid=#CPSUid#&ts_rversion=#ts#&Who=CPSUconsultar'"><cfelse><img src="/cfmx/sif/imagenes/unchecked.gif" onClick="document.nosubmit=true;this.src='PSUU-checkbox.cfm?Usucodigo=#form.Usucodigo#&CPSUid=#CPSUid#&ts_rversion=#ts#&Who=CPSUconsultar'"></cfif></td>
		<td><cfif CPSUtraslados><img src="/cfmx/sif/imagenes/checked.gif" onClick="document.nosubmit=true;this.src='PSUU-checkbox.cfm?Usucodigo=#form.Usucodigo#&CPSUid=#CPSUid#&ts_rversion=#ts#&Who=CPSUtraslados'"><cfelse><img src="/cfmx/sif/imagenes/unchecked.gif" onClick="document.nosubmit=true;this.src='PSUU-checkbox.cfm?Usucodigo=#form.Usucodigo#&CPSUid=#CPSUid#&ts_rversion=#ts#&Who=CPSUtraslados'"></cfif></td>
		<td><cfif CPSUreservas><img src="/cfmx/sif/imagenes/checked.gif" onClick="document.nosubmit=true;this.src='PSUU-checkbox.cfm?Usucodigo=#form.Usucodigo#&CPSUid=#CPSUid#&ts_rversion=#ts#&Who=CPSUreservas'"><cfelse><img src="/cfmx/sif/imagenes/unchecked.gif" onClick="document.nosubmit=true;this.src='PSUU-checkbox.cfm?Usucodigo=#form.Usucodigo#&CPSUid=#CPSUid#&ts_rversion=#ts#&Who=CPSUreservas'"></cfif></td>
		<td><cfif CPSUformulacion><img src="/cfmx/sif/imagenes/checked.gif" onClick="document.nosubmit=true;this.src='PSUU-checkbox.cfm?Usucodigo=#form.Usucodigo#&CPSUid=#CPSUid#&ts_rversion=#ts#&Who=CPSUformulacion'"><cfelse><img src="/cfmx/sif/imagenes/unchecked.gif" onClick="document.nosubmit=true;this.src='PSUU-checkbox.cfm?Usucodigo=#form.Usucodigo#&CPSUid=#CPSUid#&ts_rversion=#ts#&Who=CPSUformulacion'"></cfif></td>
		<td align="center"><cfif CPSUaprobacion><img src="/cfmx/sif/imagenes/checked.gif" onClick="document.nosubmit=true;this.src='PSUU-checkbox.cfm?Usucodigo=#form.Usucodigo#&CPSUid=#CPSUid#&ts_rversion=#ts#&Who=CPSUaprobacion'"><cfelse><img src="/cfmx/sif/imagenes/unchecked.gif" onClick="document.nosubmit=true;this.src='PSUU-checkbox.cfm?Usucodigo=#form.Usucodigo#&CPSUid=#CPSUid#&ts_rversion=#ts#&Who=CPSUaprobacion'"></cfif></td>
		<td>&nbsp;</td>
    </tr></cfoutput>
  <cfelse>
	  <tr><td align="center" colspan="8"><strong>-- No se encontr&oacute; ning&uacute;n resultado --</strong></td></tr>
  </cfif>
  <form action="PSUsuarios.cfm" method="post" name="formListaPSUUsuarios">
	  <cfoutput><input type="hidden" id="Usucodigo" name="Usucodigo" value="#form.Usucodigo#"></cfoutput>
	  <input type="hidden" id="CPSUid" name="CPSUid">
  </form>
</table>
</div>
<cf_qforms form="formPSUUsuarios" objForm="objForm1"/>
<script language="javascript" type="text/javascript">
<!--//
	objForm1.CFpk.description = "Centro Funcional";
	objForm1.required("CFpk",true);
//-->
</script>
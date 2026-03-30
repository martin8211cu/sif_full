<cfinclude template="../../Utiles/sifConcat.cfm">

<cfif isdefined("url.CPSUid") and len(trim(url.CPSUid))>
	<cfset form.CPSUid = url.CPSUid>
</cfif>
<cfif isdefined("form.CPSUid") and len(trim(form.CPSUid))>
	<cfquery name="rsCPCFUsuarios.rsFormCPSU" datasource="#Session.dsn#">
		select CPSUid, Ecodigo, CFid as CFpk, Usucodigo, CPSUconsultar, CPSUtraslados, CPSUreservas, CPSUformulacion, CPSUaprobacion, CPSUidOrigen, ts_rversion, 
				' ' as ts, '00' as Ulocalizacion, ' ' as Usulogin, ' ' as Usunombre
		from CPSeguridadUsuario
		where Ecodigo = #Session.Ecodigo#
		and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
		and CPSUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPSUid#">
	</cfquery>
	<cfinvoke 
		component="sif.Componentes.DButils"
		method="toTimeStamp"
		returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsCPCFUsuarios.rsFormCPSU.ts_rversion#"/>
	</cfinvoke>
	<cfset QuerySetCell(rsCPCFUsuarios.rsFormCPSU,'ts',ts)>
	<cfquery name="rsCPCFUsuarios.rsFormCPSUusuario" datasource="asp">
		select Usucodigo, Usulogin, Pnombre #_Cat# ' ' #_Cat# Papellido1 #_Cat# ' ' #_Cat# Papellido2 as Usunombre
		from Usuario a inner join DatosPersonales b on a.datos_personales = b.datos_personales
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCPCFUsuarios.rsFormCPSU.Usucodigo#">
	</cfquery>
	<cfset QuerySetCell(rsCPCFUsuarios.rsFormCPSU,'Ulocalizacion','00')>
	<cfset QuerySetCell(rsCPCFUsuarios.rsFormCPSU,'Usulogin',rsCPCFUsuarios.rsFormCPSUusuario.Usulogin)>
	<cfset QuerySetCell(rsCPCFUsuarios.rsFormCPSU,'Usunombre',rsCPCFUsuarios.rsFormCPSUusuario.Usunombre)>
</cfif>


<cfquery name="rsCF" datasource="#Session.dsn#">
	select CFuresponsable 
	  from CFuncional
	 where Ecodigo = #Session.Ecodigo#
	   and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
</cfquery>
<cfif rsCF.CFuresponsable NEQ "">
	<cfquery name="rsSQL" datasource="#Session.dsn#">
		select count(1) as cantidad 
		  from CPSeguridadUsuario
		 where Ecodigo = #Session.Ecodigo#
		   and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
		   and Usucodigo = #rsCF.CFuresponsable#
	</cfquery>
	<cfif rsSQL.cantidad EQ 0>
		<cfquery datasource="#Session.dsn#">
			insert into CPSeguridadUsuario 
					(Ecodigo, CFid, Usucodigo, CPSUconsultar, CPSUtraslados, CPSUreservas, CPSUformulacion, CPSUaprobacion)
			values(	#session.Ecodigo#,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">,
					#rsCF.CFuresponsable#, 1,1,1,1,1)
		</cfquery>
	</cfif>
</cfif>


<cfquery name="rsCPCFUsuarios.ListaUsuarios" datasource="#Session.dsn#">
	select 
    	CPSUid, 
        Ecodigo, 
        CFid as CFpk, 
        Usucodigo, 
        CPSUconsultar, 
        CPSUtraslados, 
        CPSUreservas, 
        CPSUformulacion, 
        CPSUaprobacion, 
        CPSUidOrigen, 
        ts_rversion, 
		' ' as ts, 
        ' ' as Ulocalizacion, 
        ' ' as Usulogin, 
        ' ' as Usunombre
	  from CPSeguridadUsuario
	 where Ecodigo = #Session.Ecodigo#
	   and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
</cfquery>
<cfloop query="rsCPCFUsuarios.ListaUsuarios">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts#CurrentRow#" arTimeStamp="#rsCPCFUsuarios.ListaUsuarios.ts_rversion#"/>
	<cfset QuerySetCell(rsCPCFUsuarios.ListaUsuarios,'ts',Evaluate('ts'&CurrentRow),rsCPCFUsuarios.ListaUsuarios.CurrentRow)>
	<cfquery name="rsCPCFUsuarios.ListaUsuarios_usuario" datasource="asp">
		select Usucodigo, Usulogin, Pnombre #_Cat# ' ' #_Cat# Papellido1 #_Cat# ' ' #_Cat# Papellido2 as Usunombre
		from Usuario a inner join DatosPersonales b on a.datos_personales = b.datos_personales
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">
	</cfquery>
	<cfset QuerySetCell(rsCPCFUsuarios.ListaUsuarios,'Ulocalizacion','00',CurrentRow)>
	<cfset QuerySetCell(rsCPCFUsuarios.ListaUsuarios,'Usulogin',rsCPCFUsuarios.ListaUsuarios_usuario.Usulogin,CurrentRow)>
	<cfset QuerySetCell(rsCPCFUsuarios.ListaUsuarios,'Usunombre',rsCPCFUsuarios.ListaUsuarios_usuario.Usunombre,CurrentRow)>
</cfloop>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="subtitulo">Lista de Usuarios Autorizados</td>
  </tr>
</table>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="titulolistas">&nbsp;</td>
    <td class="titulolistas">Usuario&nbsp;</td>
    <td class="titulolistas">Consultar&nbsp;</td>
    <td class="titulolistas">Trasladar&nbsp;</td>
    <td class="titulolistas">Provisionar&nbsp;</td>
    <td class="titulolistas">Formular&nbsp;</td>
    <td class="titulolistas" align="center">APROBAR<BR>TRASLADOS&nbsp;</td>
	<td class="titulolistas">&nbsp;</td>
  </tr>
  <cfoutput><form action="PSCentrosFuncionalesUsuarios-sql.cfm" method="post" name="formPSCFUsuarios">
  <input type="hidden" id="CFpk" name="CFpk" value="#form.CFpk#">
  <input type="hidden" id="CPSUid" name="CPSUid" value="<cfif isdefined("rsCPCFUsuarios.rsFormCPSU.CPSUid")>#rsCPCFUsuarios.rsFormCPSU.CPSUid#</cfif>">
  <input type="hidden" id="ts_rversion" name="ts_rversion" value="<cfif isdefined("rsCPCFUsuarios.rsFormCPSU.ts")>#rsCPCFUsuarios.rsFormCPSU.ts#</cfif>">
  <input type="hidden" id="CPSUdelete" name="CPSUdelete">
  <tr>
	<td>&nbsp;</td>
    <td>
		<cfif isdefined("rsCPCFUsuarios.rsFormCPSU.Usucodigo")>
			<cf_sifusuario form="formPSCFUsuarios" query="#rsCPCFUsuarios.rsFormCPSU#">
		<cfelse>
			<cf_sifusuario form="formPSCFUsuarios">
			<cfset LvarNuevo = true>
		</cfif>
		&nbsp;
	</td>
    <td><input name="CPSUconsultar" type="checkbox" <cfif isdefined("LvarNuevo") OR isdefined("rsCPCFUsuarios.rsFormCPSU.CPSUconsultar") and rsCPCFUsuarios.rsFormCPSU.CPSUconsultar>checked</cfif>>&nbsp;</td>
    <td><input name="CPSUtraslados" type="checkbox" <cfif isdefined("LvarNuevo") OR isdefined("rsCPCFUsuarios.rsFormCPSU.CPSUtraslados") and rsCPCFUsuarios.rsFormCPSU.CPSUtraslados>checked</cfif>>&nbsp;</td>
    <td><input name="CPSUreservas" type="checkbox" <cfif isdefined("LvarNuevo") OR isdefined("rsCPCFUsuarios.rsFormCPSU.CPSUreservas") and rsCPCFUsuarios.rsFormCPSU.CPSUreservas>checked</cfif>>&nbsp;</td>
    <td><input name="CPSUformulacion" type="checkbox" <cfif isdefined("LvarNuevo") OR isdefined("rsCPCFUsuarios.rsFormCPSU.CPSUformulacion") and rsCPCFUsuarios.rsFormCPSU.CPSUformulacion>checked</cfif>>&nbsp;</td>
    <td align="center">&nbsp;<input name="CPSUaprobacion" type="checkbox" <cfif isdefined("rsCPCFUsuarios.rsFormCPSU.CPSUaprobacion") and rsCPCFUsuarios.rsFormCPSU.CPSUaprobacion>checked</cfif>>&nbsp;</td>
	<td>
		<input name="<cfif isdefined("rsCPCFUsuarios.rsFormCPSU.CPSUid")>btnUpdUsuarios<cfelse>btnAddUsuarios</cfif>" type="submit" value="&nbsp;+&nbsp;"  title="Agregar/modificar el Usuario únicamente en este Centro Funcional">&nbsp;
	</td>
  </tr>
  </form></cfoutput>
  <cfif rsCPCFUsuarios.ListaUsuarios.recordcount>
	  <cfoutput query="rsCPCFUsuarios.ListaUsuarios"><tr onClick="if (document.nosubmit==true) {document.nosubmit=false; return;} document.formListaPSCFUsuarios.CPSUid.value=#CPSUid#; document.formListaPSCFUsuarios.submit();"
	  	class="<cfif CurrentRow Mod 2 EQ 0>listaNon<cfelse>listaPar</cfif>"
		onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif CurrentRow Mod 2 EQ 0>listaNon<cfelse>listaPar</cfif>';"
		style="cursor:pointer;">
		<td width="16px"><cfif isdefined("form.CPSUid") and CPSUid EQ form.CPSUid><img src="/cfmx/sif/imagenes/addressGo.gif"><cfelseif rsCF.CFuresponsable NEQ rsCPCFUsuarios.ListaUsuarios.Usucodigo><img src="/cfmx/sif/imagenes/Borrar01_S.gif" width="16" height="16" onClick="document.nosubmit=true; if (!confirm('¿Desea eliminar el registro?')) return false; document.formPSCFUsuarios.CPSUdelete.value=#CPSUid#; document.formPSCFUsuarios.Usucodigo.value='1'; document.formPSCFUsuarios.submit();"></cfif></td>
		<td nowrap>#Usunombre#</td>
		<td><cfif CPSUconsultar><img src="/cfmx/sif/imagenes/checked.gif" onClick="document.nosubmit=true;this.src='PSCFU-checkbox.cfm?CFpk=#form.CFpk#&CPSUid=#CPSUid#&ts_rversion=#ts#&Who=CPSUconsultar'"><cfelse><img src="/cfmx/sif/imagenes/unchecked.gif" onClick="document.nosubmit=true;this.src='PSCFU-checkbox.cfm?CFpk=#form.CFpk#&CPSUid=#CPSUid#&ts_rversion=#ts#&Who=CPSUconsultar'"></cfif></td>
		<td><cfif CPSUtraslados><img src="/cfmx/sif/imagenes/checked.gif" onClick="document.nosubmit=true;this.src='PSCFU-checkbox.cfm?CFpk=#form.CFpk#&CPSUid=#CPSUid#&ts_rversion=#ts#&Who=CPSUtraslados'"><cfelse><img src="/cfmx/sif/imagenes/unchecked.gif" onClick="document.nosubmit=true;this.src='PSCFU-checkbox.cfm?CFpk=#form.CFpk#&CPSUid=#CPSUid#&ts_rversion=#ts#&Who=CPSUtraslados'"></cfif></td>
		<td><cfif CPSUreservas><img src="/cfmx/sif/imagenes/checked.gif" onClick="document.nosubmit=true;this.src='PSCFU-checkbox.cfm?CFpk=#form.CFpk#&CPSUid=#CPSUid#&ts_rversion=#ts#&Who=CPSUreservas'"><cfelse><img src="/cfmx/sif/imagenes/unchecked.gif" onClick="document.nosubmit=true;this.src='PSCFU-checkbox.cfm?CFpk=#form.CFpk#&CPSUid=#CPSUid#&ts_rversion=#ts#&Who=CPSUreservas'"></cfif></td>
		<td><cfif CPSUformulacion><img src="/cfmx/sif/imagenes/checked.gif" onClick="document.nosubmit=true;this.src='PSCFU-checkbox.cfm?CFpk=#form.CFpk#&CPSUid=#CPSUid#&ts_rversion=#ts#&Who=CPSUformulacion'"><cfelse><img src="/cfmx/sif/imagenes/unchecked.gif" onClick="document.nosubmit=true;this.src='PSCFU-checkbox.cfm?CFpk=#form.CFpk#&CPSUid=#CPSUid#&ts_rversion=#ts#&Who=CPSUformulacion'"></cfif></td>
		<td align="center"><cfif CPSUaprobacion><img src="/cfmx/sif/imagenes/checked.gif" onClick="document.nosubmit=true;this.src='PSCFU-checkbox.cfm?CFpk=#form.CFpk#&CPSUid=#CPSUid#&ts_rversion=#ts#&Who=CPSUaprobacion'"><cfelse><img src="/cfmx/sif/imagenes/unchecked.gif" onClick="document.nosubmit=true;this.src='PSCFU-checkbox.cfm?CFpk=#form.CFpk#&CPSUid=#CPSUid#&ts_rversion=#ts#&Who=CPSUaprobacion'"></cfif></td>
		<td>&nbsp;</td>
    </tr></cfoutput>
  <cfelse>
	  <tr><td align="center" colspan="8"><strong>-- No se encontr&oacute; ning&uacute;n resultado --</strong></td></tr>
  </cfif>
  <form action="PSCentrosFuncionales.cfm" method="post" name="formListaPSCFUsuarios">
	  <cfoutput><input type="hidden" id="CFpk" name="CFpk" value="#form.CFpk#"></cfoutput>
	  <input type="hidden" id="CPSUid" name="CPSUid">
  </form>
</table>
</div>
<cf_qforms form="formPSCFUsuarios" objForm="objForm2"/>
<script language="javascript" type="text/javascript">
<!--//
	objForm2.Usucodigo.description = "Usuario";
	objForm2.required("Usucodigo",true);
//-->
</script>
<!--- Based on Mascaras, do the following
	1. Copy / Paste 
	2. Replace Mascara, CPSM
	4. Cambiar Queries, Agregar query de usuario
	5. Cambiar Tipo/Mascara por Usuario, implica form y validacion
--->

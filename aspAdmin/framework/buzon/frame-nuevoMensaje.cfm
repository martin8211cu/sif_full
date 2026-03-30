<!--- <cfif Session.RolActual EQ 4>
	<cfinclude template="consultas-admin.cfm">
<cfelseif Session.RolActual EQ 5>
	<cfinclude template="consultas-profesor.cfm">
<cfelseif Session.RolActual EQ 6>
	<cfinclude template="consultas-estudiante.cfm">
<cfelseif Session.RolActual EQ 7>
	<cfinclude template="consultas-encargado.cfm">
<cfelseif Session.RolActual EQ 12>
	<cfinclude template="consultas-director.cfm">
</cfif> 

<cfif isdefined("Session.RolActual") and Session.RolActual NEQ 0>
	<cfset mirol = Trim(ListGetAt(rolesDesc, ListFind(Replace(rolCod, ' ' , '', 'all'), Session.RolActual, ','), ','))>
</cfif>
--->

<cfquery name="usr" datasource="#session.DSN#">
	select Pnombre, Papellido1, Papellido2
	from Usuario
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"/>
		and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ulocalizacion#">
</cfquery>


<style type="text/css">
.rolStyle {
	padding: 3px;
	font-weight: bold;
	color: white;
	background-color: #6699CC;
}
</style>

<cfoutput>
<!--- 	<form name="rolForm" action="index.cfm" method="post" style="margin: 0" onSubmit="javascript: if (window.fnVerificarDatos) return fnVerificarDatos(this);">
		<input type="hidden" name="o" value="<cfif isdefined("Form.o")>#Form.o#</cfif>">
		<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="2" class="rolStyle">Actualmente usted tiene el rol de #mirol#</td>
		  </tr>
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>
		  <cfif isdefined("rolesUsr") and rolesUsr.recordCount GT 1>
		  <tr>
			<td width="10%" style="padding-right: 10px" nowrap><strong>Seleccionar otro rol</strong></td>
			<td nowrap>
				<select name="rol" onChange="javascript: this.form.submit();">
					<cfloop query="rolesUsr">
						<option value="#Trim(rolesUsr.rol)#"<cfif Trim(ListGetAt(roles, ListFind(Replace(rolCod, ' ' , '', 'all'), Session.RolActual, ','), ',')) EQ Trim(rolesUsr.rol)> selected</cfif>>#Trim(ListGetAt(rolesDesc, ListFind(Replace(roles, ' ' , '', 'all'), Trim(rolesUsr.rol), ','), ','))#</option>
					</cfloop>
				</select>
			</td>
		  </tr>
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>
		  </cfif>
		</table>
	</form> 
	<cfif isdefined("usr") and usr.recordCount GT 0>--->
	<form name="frmMail" action="sendMessage.cfm" method="post" style="margin: 0" onSubmit="return fnVerificarDatos(this);">
		<input type="hidden" name="o" value="<cfif isdefined("Form.o")>#Form.o#</cfif>">
		<input type="hidden" name="senderRol" value="<cfif isdefined("Session.RolActual") and Len(Trim(Session.RolActual)) NEQ 0>#Session.RolActual#</cfif>">
		<table width="98%" align="center" border="0" cellspacing="0" cellpadding="1">
		  <tr>
			<td width="10%"><b>De:</b></td>
			<td><input name="txtFrom" type="hidden" id="txtFrom" value="#Trim(usr.Pnombre)# #Trim(usr.Papellido1)# #Trim(usr.Papellido2)# <!--- (#mirol#) --->">
				<font color="##003399"><strong>#Trim(usr.Pnombre)# #Trim(usr.Papellido1)# #Trim(usr.Papellido2)# <!--- (#mirol#) --->
            </strong></font></td>
		  </tr>
		  <tr>
			<td valign="top"><b>Para:</b></td>
			<td>
				Especificacion de a quien va dirigido
<!--- 				<cfif Session.RolActual EQ 4>
					<cfinclude template="perfil-admin.cfm">
				<cfelseif Session.RolActual EQ 5>
					<cfinclude template="perfil-profesor.cfm">
				<cfelseif Session.RolActual EQ 6>
					<cfinclude template="perfil-estudiante.cfm">
				<cfelseif Session.RolActual EQ 7>
					<cfinclude template="perfil-encargado.cfm">
				<cfelseif Session.RolActual EQ 12>
					<cfinclude template="perfil-director.cfm">
				</cfif> --->
			</td>
		  </tr>
		  <tr>
			<td><b>Asunto:</b></td>
			<td><input name="txtAsunto" type="text" id="txtAsunto" size="80" maxlength="255" style="width: 100%"></td>
		  </tr>
		  <tr>
			<td valign="top"><b>Mensaje:</b></td>
		    <td><textarea name="txtMSG" cols="80" rows="10" id="txtMSG" style="width: 100%"></textarea></td>
	      </tr>
		  <tr>
			<td colspan="2">&nbsp;</td>
			</tr>
		  <tr align="center">
			<td colspan="2"><input name="btnEnviar" type="submit" id="btnEnviar" value="Enviar"></td>
		  </tr>
		  <tr align="center">
		    <td colspan="2">&nbsp;</td>
	      </tr>
		</table>
	</form>
<!--- 	<cfelse>
		<br>
		<table width="98%" cellpadding="0" cellspacing="0" align="center">
			<tr>
				<td align="center" class="rolStyle">
					POR EL MOMENTO ESTA OPCION NO ESTA HABILITADA PARA ESTE ROL
				</td>
			</tr>
		</table>
		<br>
	</cfif> --->
</cfoutput>

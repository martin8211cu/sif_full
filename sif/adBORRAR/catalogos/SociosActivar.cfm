<!---
	 Modificado por Gustavo Fonseca H.
	Fecha: 24-5-2005
	Motivo: Arreglar el tipo de dato para el CEcodigo, estaba como tipo integer, se dejó en numeric.
	Línea: 56 
--->
<cfparam name="url.msg" default="">
<cfparam name="url.tipousuario" default="T">
<cfquery datasource="#session.dsn#" name="SNegocios">
	select *
	from SNegocios
	where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
</cfquery>

<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec"/>
<cfset usuario_existente = sec.getUsuarioByRef(url.SNcodigo, Session.EcodigoSDC, 'SNegocios')>
<cfif usuario_existente.RecordCount>
	<cfquery name="roles_activos" datasource="asp">
		select {fn concat( {fn concat( rtrim(SScodigo), '.' )}, rtrim(SRcodigo) )} as rol
		from UsuarioRol ur
		where ur.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#usuario_existente.Usucodigo#">
		  and ur.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
	</cfquery>
</cfif>

<cfquery datasource="#session.dsn#" name="similares">
	select u.Usucodigo, u.Usulogin,
		e.Enombre,
		{fn concat( {fn concat( {fn concat( {fn concat(
		dp.Pnombre , ' ' )}, dp.Papellido1 )}, ' ' )}, dp.Papellido2 )} as Nombre
	from Usuario u
		join UsuarioReferencia ur
			on ur.Usucodigo = u.Usucodigo
		join DatosPersonales dp
			on dp.datos_personales = u.datos_personales
		join Empresa e
			on e.Ecodigo = ur.Ecodigo
	where u.CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and ur.STabla = 'SNegocios'
	  and dp.Pid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SNegocios.SNidentificacion#">
	  and ur.Ecodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
</cfquery>

<cfif similares.RecordCount is 0>
	<cfquery datasource="#session.dsn#" name="toditicos">
		select u.Usucodigo, u.Usulogin,
			e.Enombre,
			{fn concat( {fn concat( {fn concat( {fn concat(
		dp.Pnombre , ' ' )}, dp.Papellido1 )}, ' ' )}, dp.Papellido2 )} as Nombre, dp.Pid
		from Usuario u
			join UsuarioReferencia ur
				on ur.Usucodigo = u.Usucodigo
			join DatosPersonales dp
				on dp.datos_personales = u.datos_personales
			join Empresa e
				on e.Ecodigo = ur.Ecodigo
		where u.CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and ur.Ecodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		  and ur.STabla = 'SNegocios'
	</cfquery>
	<cfset similares=QueryNew('Usucodigo,Usulogin,Enombre,Nombre')>
	<cfset sn_cedula = UCase(SNegocios.SNidentificacion)>
	<cfset sn_cedula = Replace(sn_cedula, '-', '', 'all')>
	<cfset sn_cedula = Replace(sn_cedula, '0', '', 'all')>
	<cfset sn_cedula = Replace(sn_cedula, ' ', '', 'all')>
	<cfloop query="toditicos">
		<cfset us_cedula = UCase(toditicos.Pid)>
		<cfset us_cedula = Replace(us_cedula, '-', '', 'all')>
		<cfset us_cedula = Replace(us_cedula, '0', '', 'all')>
		<cfset us_cedula = Replace(us_cedula, ' ', '', 'all')>
		<cfif us_cedula is sn_cedula>
			<cfset QueryAddRow(similares)>
			<cfset QuerySetCell(similares,'Usucodigo', toditicos.Usucodigo)>
			<cfset QuerySetCell(similares,'Usulogin',  toditicos.Usulogin)>
			<cfset QuerySetCell(similares,'Enombre',   toditicos.Enombre)>
			<cfset QuerySetCell(similares,'Nombre',    toditicos.Nombre)>
		</cfif>
	</cfloop>
</cfif>


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_SIFAdministracionDelSistema"
Default="SIF - Administraci&oacute;n del Sistema"
XmlFile="/sif/generales.xml"
returnvariable="LB_SIFAdministracionDelSistema"/>
<cf_templateheader title="#LB_SIFAdministracionDelSistema#">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Activaci&oacute;n de Socios de Negocios'>
		
			<cfinclude template="/home/menu/pNavegacion.cfm">
			<cfoutput>
 	        <form name="form1" method="post" action="SociosActivar-sql.cfm">
	          <table width="648"  border="0" cellspacing="0" cellpadding="0" align="center">
                <tr>
                  <td width="4">&nbsp;</td>
                  <td colspan="6" class="subTitulo tituloListas">Datos del Socio por Activar </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td width="65">&nbsp;</td>
                  <td width="137" colspan="2" align="right" valign="top">&nbsp;</td>
                  <td width="39" valign="top">&nbsp;</td>
                  <td width="353" valign="top">&nbsp;</td>
                  <td width="50">&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td colspan="2" align="right" valign="top"><strong>N&uacute;mero de Socio</strong></td>
                  <td valign="top">&nbsp;</td>
                  <td valign="top">#SNegocios.SNnumero#</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td colspan="2" align="right" valign="top"><strong>Nombre</strong></td>
                  <td valign="top">&nbsp;</td>
                  <td valign="top">#SNegocios.SNnombre#</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td colspan="2" align="right" valign="top"><strong>C&eacute;dula o Identificaci&oacute;n</strong></td>
                  <td valign="top">&nbsp;</td>
                  <td valign="top">#SNegocios.SNidentificacion#</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td colspan="2" align="right" valign="top"><strong>Tipo de Socio </strong></td>
                  <td valign="top">&nbsp;</td>
                  <td valign="top"><cfif SNegocios.SNtiposocio is 'A'>
				  	Cliente y Proveedor
				  <cfelseif SNegocios.SNtiposocio is 'P'>
				  	Proveedor
				  <cfelseif SNegocios.SNtiposocio is 'C'>
				  	Cliente
				  <cfelse>Tipo #SNegocios.SNtiposocio#
				  </cfif></td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td colspan="2" align="right" valign="top"><strong>Correo electr&oacute;nico </strong></td>
                  <td valign="top">&nbsp;</td>
                  <td valign="top">#SNegocios.SNemail#<cfif Not Len(Trim(SNegocios.SNemail))>no tiene</cfif></td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td colspan="2">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td colspan="6" class="subTitulo tituloListas">Resultado de la verificaci&oacute;n</td>
                </tr>
				<cfif url.msg is 'existe'>
				<tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td colspan="4" style="color:red;font-weight:bold;">
				  Este nombre de usuario ya estaba reservado. Por favor seleccione otro.</td>
                  <td>&nbsp;</td>
                </tr></cfif>

				<cfif usuario_existente.RecordCount>
				
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td colspan="4">
				  	Se ha encontrado que este socio de negocios ya est&aacute; activo en el sistema.
					<ul>
					<li>El usuario o login es: #usuario_existente.Usulogin#.</li>
					
					<cfif ListFind('A,P', SNegocios.SNtiposocio)><br>
						<li><cfif ListFind(ValueList(roles_activos.rol),'SIF.PROVEEDOR')>
							El acceso como Proveedor ya est&aacute; activo.
						<cfelse>
							El acceso como Proveedor no est&aacute; activo.
						</cfif></li>
					</cfif>
					<cfif ListFind('A,C', SNegocios.SNtiposocio)><br>
						<li><cfif ListFind(ValueList(roles_activos.rol),'SIF.CLIENTE')>
							El acceso como Cliente ya est&aacute; activo.
						<cfelse>
							El acceso como Cliente no est&aacute; activo.
						</cfif></li>
					</cfif>
					</ul>
				  </td>
                  <td>&nbsp;</td>
                </tr>
				<cfelseif similares.RecordCount>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td colspan="4">Se encontraron los siguientes usuarios que podr&iacute;an corresponder a este mismo socio de negocios en otra empresa. Seleccione uno si corresponde a #SNegocios.SNnombre#. </td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td colspan="2" class="tituloListas">Empresa</td>
                  <td class="tituloListas">&nbsp;</td>
                  <td class="tituloListas">Nombre</td>
                  <td>&nbsp;</td>
                </tr>
				<cfloop query="similares">
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td valign="top" nowrap>
				  <input id="tipousuarioE_#similares.CurrentRow#" name="tipousuario" type="radio" value="#similares.Usucodigo#">
				  </td>
                  <td valign="top" nowrap><label for="tipousuarioE_#similares.CurrentRow#">#HTMLEditFormat(similares.Enombre)#</label> </td>
                  <td valign="top">&nbsp;</td>
                  <td valign="top"><label for="tipousuarioE_#similares.CurrentRow#"> #HTMLEditFormat(similares.Nombre)# </label></td>
                  <td>&nbsp;</td>
                </tr></cfloop>
				<cfelse>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td colspan="4">No se ha encontrado ning&uacute;n usuario para este socio de negocios. Puede crear un usuario nuevo seleccionando el bot&oacute;n de Activar. </td>
                  <td>&nbsp;</td>
                </tr></cfif>
				<cfif usuario_existente.RecordCount is 0>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td><input id="tipousuarioT" name="tipousuario" type="radio" value="T" <cfif url.tipousuario is 'T'>checked</cfif>>
				                      </td>
                  <td colspan="3"><label for="tipousuarioT">Enviar usuario temporal</label></td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td><input id="tipousuarioU" name="tipousuario" type="radio" value="U" <cfif url.tipousuario is 'U'>checked</cfif>>
				  	                </td>
                  <td colspan="3"><label for="tipousuarioU"> Especificar usuario   </label></td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td colspan="2" align="right"><strong>Usuario</strong></td>
                  <td>&nbsp;</td>
                  <td><input name="usuario" type="text" id="usuario" style="width:100px" onFocus="this.select()" onKeyPress="this.form.tipousuarioU.checked=true" size="20" maxlength="20"></td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td colspan="2" align="right"><strong>Contrase&ntilde;a</strong></td>
                  <td>&nbsp;</td>
                  <td><input name="passwd" type="password" id="passwd" style="width:100px" onFocus="this.select()" onKeyPress="this.form.tipousuarioU.checked=true" size="20" maxlength="20"></td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td colspan="2" align="right"><strong>Confirmar</strong></td>
                  <td>&nbsp;</td>
                  <td><input name="passwd2" type="password" id="passwd2" style="width:100px" onFocus="this.select()" onKeyPress="this.form.tipousuarioU.checked=true" size="20" maxlength="20"></td>
                  <td>&nbsp;</td>
                </tr></cfif>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td colspan="2">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td colspan="2">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td colspan="5" align="center">                  <input type="submit" name="Submit" value="Activar Usuario y Verificar Roles">
                  <input name="SNcodigo" type="hidden" id="SNcodigo" value="#HTMLEditFormat(url.SNcodigo)#"></td>
                  <td>&nbsp;</td>
                </tr>
              </table>
        </form></cfoutput>
		
		<script type="text/javascript">
		<!--
			function validar(f){
				if (f.tipousuarioU && f.tipousuarioU.checked){
					if (f.usuario.value == ''){
						alert('Especifique el nombre usuario para este socio de negocios');
						f.usuario.focus();
						return false;
					}
					if (f.passwd.value == ''){
						alert('Especifique la contraseña deseada para este socio de negocios');
						f.passwd.focus();
						return false;
					}
					if (f.passwd2.value != f.passwd.value){
						alert('La contraseña debe coincidir en ambos espacios');
						f.passwd.value = ''
						f.passwd2.value = ''
						f.passwd.focus();
						return false;
					}
				}
				return true;
			}
		//-->
		</script>
		
<cf_web_portlet_end>
<cf_templatefooter>
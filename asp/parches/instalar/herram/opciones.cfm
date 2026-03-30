<cfinvoke component="asp.parches.comp.instala" method="get_servidor" returnvariable="servidor" />
<cfquery datasource="asp" name="APServidor">
	select
		servidor, cliente, hostname, ipaddr, admin_email,
		notifica_instalacion, actualizado
	from APServidor
	where servidor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#servidor#">
</cfquery>


<cfset inetaddr = CreateObject("java", "java.net.InetAddress").localhost>
<cfset addrlist = CreateObject("java", "java.net.InetAddress").localhost.getAllByName(inetaddr.hostname)>

<cf_templateheader title="Opciones">
<cfinclude template="../mapa.cfm">
<cf_web_portlet_start titulo="Opciones" width="700">
<form action="opciones-control.cfm" method="post">
<cfoutput>
<table width="675" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td class="subTitulo">&nbsp;</td>
    <td colspan="3" class="subTitulo">Configuración de este servidor </td>
    </tr>
  
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td width="259">Hostname</td>
    <td width="259">#HTMLEditFormat(APServidor.hostname)#</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>Razón social del cliente</td>
    <td><input type="text" value="#HTMLEditFormat(APServidor.cliente)#" name="cliente" size="60" onfocus="this.select()" /></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>Dirección IP </td>
    <td>
	<select name="ipaddr">
	<cfset value_found = false>
	<cfloop from="1" to="#ArrayLen(addrlist)#" index="i">
		<option value="# HTMLEditFormat( addrlist[i].hostaddress )#" <cfif  addrlist[i].hostaddress EQ APServidor.ipaddr><cfset value_found=true>selected</cfif>>#HTMLEditFormat(addrlist[i].hostaddress)#</option>
	</cfloop>
	<cfif not value_found>
	<option value="#HTMLEditFormat(APServidor.ipaddr)#" selected>#HTMLEditFormat(APServidor.ipaddr)#</option>
	</cfif>
	</select>	</td>
  </tr>
 <tr>
    <td valign="top">&nbsp;</td>
    <td colspan="3" valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top" class="subTitulo">&nbsp;</td>
    <td colspan="3" valign="top" class="subTitulo">Opciones disponibles para la instalación de parches </td>
    </tr>
  <tr>
    <td width="9" valign="top">&nbsp;</td>
    <td width="23" valign="top"><input type="checkbox" id="notificar" name="notificar" value="1" <cfif APServidor.notifica_instalacion EQ 1>checked</cfif> /></td>
    <td colspan="2" valign="top"><label for="notificar">Deseo notificar por correo electrónico el resultado de la instalación de los parches en este servidor. </label></td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td colspan="2" valign="top"><label for="email">Destinatario de la notificación.</label> <br />Puede indicar varios separándolos por comas. </td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2"><input name="email" id="email" type="text" size="60" value="# HTMLEditFormat( APServidor.admin_email ) #" onfocus="this.select()" /></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="3">&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2">&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2" align="right"> <input type="submit" name="guardar" class="btnGuardar" value="Guardar" /></td>
  </tr>
</table>
</cfoutput>
</form>

<cf_web_portlet_end>
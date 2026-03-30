<cfquery name="rsMensaje" datasource="#Session.Edu.DSN#">
	select convert(varchar, a.Bcodigo) as Bcodigo, 
		   a.Borigen, a.Bdestino, a.Btitulo, a.Bmensaje,
		   convert(varchar, a.BUsucodigoOr) as BUsucodigoOr,
		   a.BUlocalizacionOr
	from Buzon a
	where a.Bcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bcodigo#">
	and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">
	and a.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
</cfquery>
<cfset dias = "Lunes, Martes, Miércoles, Jueves, Viernes, Sábado, Domingo">
<cfset meses = "Enero, Febrero, Marzo, Abril, Mayo, Junio, Julio, Agosto, Setiembre, Octubre, Noviembre, Diciembre">
<style type="text/css">
.MessageHeader {
	border-top: 1px solid #666666;
	border-bottom: 1px solid #666666;
	padding: 10px;
	font-weight: bold;
	color: white;
	background-color: #6699CC;
}
</style>

<cfoutput query="rsMensaje">
	<br>
	<form name="frmMail" method="post" action="sendMessage.cfm" style="margin: 0">
	<input type="hidden" name="o" value="<cfif isdefined("Form.o")>#Form.o#</cfif>">
	<input type="hidden" name="senderRol" value="<cfif isdefined("Session.RolActual") and Len(Trim(Session.RolActual)) NEQ 0>#Session.RolActual#</cfif>">
	<input type="hidden" name="Bcodigo" id="Bcodigo" value="#Form.Bcodigo#">
	<cfif isdefined("Form.PageNum")>
	<input type="hidden" name="PageNum" id="PageNum" value="#Form.PageNum#">
	</cfif>
	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="2" class="MessageHeader">
	  <tr>
		<td width="10%" align="right" style="padding-left: 10px; padding-right: 10px; font-weight: bold;">De:</td>
		<td class="subrayado" style="padding-right: 10px;">#Bdestino#<input type="hidden" name="txtFrom" value="#Bdestino#"></td>
	  </tr>
	  <tr>
		<td width="1%" align="right" style="padding-left: 10px; padding-right: 10px; font-weight: bold;">Para:</td>
		<td class="subrayado" style="padding-right: 10px;">#Borigen#<input type="hidden" name="txtTo" value="#Borigen#"></td>
	  </tr>
	  <tr>
	    <td align="right" style="padding-left: 10px; padding-right: 10px; font-weight: bold;">Asunto:</td>
	    <td class="subrayado" style="padding-right: 10px;">
			<input type="text" name="txtAsunto" value="Re: #Btitulo#" style="width: 100%">
		</td>
      </tr>
	</table>
	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="2" style="border: 1px solid ##CCCCCC;">
	  <tr>
	    <td>
			<textarea name="txtMSG" rows="20" style="width: 100%">



-----------------------------------------------------------
Mensaje Enviado por: #Borigen#
a: #Bdestino#
-----------------------------------------------------------
#Bmensaje#
-----------------------------------------------------------
-----------------------------------------------------------
</textarea>
		</td>
	  </tr>
	</table>
	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="2">
	  <tr>
	    <td>&nbsp;</td>
	  </tr>
	  <tr>
	    <td align="center"><input name="btnEnviar" type="submit" id="btnEnviar" value="Enviar"></td>
	  </tr>
	  <tr>
	    <td>&nbsp;</td>
	  </tr>
	</table>
	</form>
</cfoutput>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Detalle de Actividad</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<cfset login = "">
<cfset fecha = "">
<cfset obs = "">
<cfset usuario = "">
<cfset autom = "">

<cfif isdefined('url.tipo')>
	<cfif url.tipo EQ 1>
		<cfquery datasource="#session.dsn#" name="data">
			Select
				LGlogin
				, BLfecha
				, BLobs
				, BLusuario
				, BLautomatica
			from ISBbitacoraLogin
			where BLid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.llave#" null="#Len(url.llave) Is 0#">
		</cfquery>
		<cfif isdefined('data') and data.recordCount GT 0>
			<cfset login = data.LGlogin>
			<cfset fecha = LSDateFormat(data.BLfecha,"dd/mm/yyyy") & '   &nbsp;&nbsp;&nbsp;' & LSTimeFormat(data.BLfecha, 'hh:mm:ss')>
			<cfset obs = data.BLobs>
			<cfset usuario = data.BLusuario>
			<cfif data.BLautomatica>
				<cfset autom = 'SI'>
			<cfelse>
				<cfset autom = 'NO'>			
			</cfif>
		</cfif>
	<cfelseif url.tipo EQ 2>
		<cfquery datasource="#session.dsn#" name="data">
			Select
				TJlogin
				, BPfecha
				, BPobs
				, BPusuario
				, BPautomatica
			from ISBbitacoraPrepago
			where BPid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.llave#" null="#Len(url.llave) Is 0#">
		</cfquery>	
		<cfif isdefined('data') and data.recordCount GT 0>
			<cfset login = data.TJlogin>
			<cfset fecha = LSDateFormat(data.BPfecha,"dd/mm/yyyy") & '   &nbsp;&nbsp;&nbsp;' & LSTimeFormat(data.BPfecha, 'hh:mm:ss')>
			<cfset obs = data.BPobs>
			<cfset usuario = data.BPusuario>
			<cfif data.BPautomatica>
				<cfset autom = 'SI'>
			<cfelse>
				<cfset autom = 'NO'>			
			</cfif>
		</cfif>	
	<cfelseif url.tipo EQ 3>
		<cfquery datasource="#session.dsn#" name="data">
			Select
				MDref
				, BTfecha
				, BTobs
				, BTusuario
				, BTautomatica
			from ISBbitacoraMedio
			where BTid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.llave#" null="#Len(url.llave) Is 0#">
		</cfquery>	
		<cfif isdefined('data') and data.recordCount GT 0>
			<cfset login = "">
			<cfset fecha = LSDateFormat(data.BTfecha,"dd/mm/yyyy") & '   &nbsp;&nbsp;&nbsp;' & LSTimeFormat(data.BTfecha, 'hh:mm:ss')>
			<cfset obs = data.BTobs>
			<cfset usuario = data.BTusuario>
			<cfif data.BTautomatica>
				<cfset autom = 'SI'>
			<cfelse>
				<cfset autom = 'NO'>			
			</cfif>	
		</cfif>		
	</cfif>
</cfif>
	<cfoutput>
		<table width="100%"  border="0" cellspacing="2" cellpadding="0">
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>	
		  <tr bgcolor="##CCCCCC">
			<td colspan="2" align="center">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
					<td align="center"><strong>DETALLE DE ACTIVIDADES</strong></td>
				  </tr>
				  <tr>
					<td>&nbsp;</td>
				  </tr>
				</table>
			</td>
		  </tr>	 
		  <tr bgcolor="##F4F4F4">
			<td width="20%" align="right"><strong>Fecha:</strong></td>
			<td width="80%">&nbsp;&nbsp;#fecha#</td>
		  </tr>  
		<cfif isdefined('url.tipo') and url.tipo NEQ 3>
		  <tr bgcolor="##F4F4F4">
			<td align="right"><strong>Log&iacute;n:</strong></td>
			<td>&nbsp;&nbsp;#login#</td>
		  </tr>	  
		</cfif>
		  <tr bgcolor="##F4F4F4">
			<td align="right"><strong>Usuario:</strong></td>
			<td>&nbsp;&nbsp;#usuario#</td>
		  </tr>
		  <tr bgcolor="##F4F4F4">
			<td align="right"><strong>Autom&aacute;tica:</strong></td>
			<td>&nbsp;&nbsp;#autom#</td>
		  </tr>
		  <tr bgcolor="##F4F4F4">
			<td align="right"><strong>Observaciones:</strong></td>
			<td>&nbsp;&nbsp;#obs#</td>
		  </tr>	 
		  <tr>
			<td colspan="2">&nbsp;&nbsp;</td>
		  </tr>	
		  <tr>
			<td colspan="2" align="center"><input type="button" name="btnCerrar" onClick="javascript: cerrar();" value="Cerrar"></td>
		  </tr>		  	   
		</table>
	</cfoutput>
</body>
</html>

<script language="javascript" type="text/javascript">
	function cerrar(){
		window.close();
		return false;
	}
</script>
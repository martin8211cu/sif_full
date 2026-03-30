<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Lista de Clasificaciones Faltantes</title>
<script language="javascript" type="text/javascript">
	function imprimir() {
		var tablabotones = document.getElementById("tablabotones");
		var tablabotones2 = document.getElementById("tablabotones2");
        tablabotones.style.display = 'none';
		tablabotones2.style.display = 'none';
		window.print();
        tablabotones.style.display = '';
		tablabotones2.style.display = '';
	}
</script>
</head>

<body>
<cfparam name="url.SNid">
<cf_templatecss>
<cfquery name="rsSocios" datasource="#Session.DSN#" >
	select SNnumero, SNidentificacion, SNnombre, SNtiposocio as tipo
	from SNegocios
	where Ecodigo = #session.Ecodigo#
	  and SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.SNid#">
</cfquery>

<cfoutput>
<table id="tablabotones" width="100%" cellpadding="0" cellspacing="0" border="0" >
	<tr> 
		<td align="right" nowrap>
			<a href="javascript:imprimir();" tabindex="-1">
				<img src="/cfmx/sif/imagenes/impresora.gif"
				alt="Imprimir"
				name="imprimir"
				border="0" align="absmiddle">
			</a>
		</td>
	</tr>
</table>
<table align="center" width="95%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="tituloListas" align="center">Clasificaciones Faltantes</td>
	</tr>
	<tr>
		<td class="tituloListas" align="center">Nombre:&nbsp;#rsSocios.SNnombre#</td>
	</tr>
	<tr>
		<td class="tituloListas" align="center">Identificaci&oacute;n:&nbsp;#rsSocios.SNidentificacion#</td>
	</tr>
	<tr>
		<td class="tituloListas" align="center">N&uacute;mero:&nbsp;#rsSocios.SNnumero#</td>
	</tr>
</cfoutput>
	<tr>	
		<td>
<div id="divDocumentos" style="overflow:auto; height:270px; margin:0;">
	<cfquery name="rsConsultaCorp" datasource="asp">
		select 1
		from CuentaEmpresarial
		where Ecorporativa is not null
		  and CEcodigo = #Session.CEcodigo#
	</cfquery>
	<cfif isdefined('session.Ecodigo') and 
		  isdefined('session.Ecodigocorp') and
		  session.Ecodigo NEQ session.Ecodigocorp and
		  rsConsultaCorp.RecordCount GT 0>
		  <cfset filtro = " and b.Ecodigo=#session.Ecodigo#">
	<cfelse>
		  <cfset filtro = " and b.Ecodigo is null">								  
	</cfif>

	<cfif rsSocios.tipo eq 'C'>
		<cfquery name="rsSNClasificacionE1" datasource="#session.dsn#">
			select b.SNCEcodigo, b.SNCEdescripcion
			from SNClasificacionE b
			where b.CEcodigo=#session.CEcodigo#  #filtro#
			and b.PCCEobligatorio = 1
			and b.PCCEactivo = 1
		    and b.SNCtiposocio in ('A', 'C')
			and ((
				select count(1) 
				from SNClasificacionSN sn
					inner join SNClasificacionD a 
					on a.SNCDid = sn.SNCDid
					and a.SNCEid = b.SNCEid
				where SNid = #url.SNid#
				)) = 0
		</cfquery>
	<cfelseif rsSocios.tipo eq 'P'>
		<cfquery name="rsSNClasificacionE1" datasource="#session.dsn#">
			select b.SNCEcodigo, b.SNCEdescripcion
			from SNClasificacionE b
			where b.CEcodigo=#session.CEcodigo# #filtro#
			and b.PCCEobligatorio = 1
			and b.PCCEactivo = 1
		    and b.SNCtiposocio in ('A', 'P')
			and ((
				select count(1) 
				from SNClasificacionSN sn
					inner join SNClasificacionD a 
					on a.SNCDid = sn.SNCDid
					and a.SNCEid = b.SNCEid
				where SNid = #url.SNid#
				)) = 0
		</cfquery>
	<cfelse>
		<cfquery name="rsSNClasificacionE1" datasource="#session.dsn#">
			select b.SNCEcodigo, b.SNCEdescripcion
			from SNClasificacionE b
			where b.CEcodigo=#session.CEcodigo# #filtro#
			and b.PCCEobligatorio = 1
			and b.PCCEactivo = 1
			and ((
				select count(1) 
				from SNClasificacionSN sn
					inner join SNClasificacionD a 
					on a.SNCDid = sn.SNCDid
				where SNid = #url.SNid#
				 and a.SNCEid = b.SNCEid
				)) = 0
		</cfquery>
	</cfif>

	<cfif rsSNClasificacionE1.recordcount>
		<fieldset>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td class="tituloListas">Clasificaciones Requeridas</td>
		</tr>
		<cfoutput query="rsSNClasificacionE1">
			<cfset LvarListaNon = (CurrentRow MOD 2)>
			<cfset LvarClassName = IIf(LvarListaNon, DE('listaNon'), DE('listaPar'))>
			<tr class="#LvarClassName#" onmouseover="this.className='#LvarClassName#Sel';" onmouseout="this.className='#LvarClassName#';">
				<td>#trim(rsSNClasificacionE1.SNCEcodigo)# - #rsSNClasificacionE1.SNCEdescripcion#</td>
			</tr>	
		</cfoutput>
		</table>
		</fieldset>
	</cfif>

	<cfif rsSocios.tipo eq 'C'>
		<cfquery name="rsSNClasificacionE2" datasource="#session.dsn#">
			select b.SNCEcodigo, b.SNCEdescripcion
			from SNClasificacionE b
			where b.CEcodigo=#session.CEcodigo# #filtro#
			and b.SNCEalertar= 1
			and b.PCCEactivo = 1
		    and b.SNCtiposocio in ('A', 'C')
			and ((
				select count(1) 
				from SNClasificacionSN sn
					inner join SNClasificacionD a 
					on a.SNCDid = sn.SNCDid
					and a.SNCEid = b.SNCEid
				where SNid = #url.SNid#
				)) = 0
		</cfquery>
	<cfelseif rsSocios.tipo eq 'P'>
		<cfquery name="rsSNClasificacionE2" datasource="#session.dsn#">
			select b.SNCEcodigo, b.SNCEdescripcion
			from SNClasificacionE b
			where b.CEcodigo=#session.CEcodigo# #filtro#
			and b.SNCEalertar= 1
			and b.PCCEactivo = 1
		    and b.SNCtiposocio in ('A', 'P')
			and ((
				select count(1) 
				from SNClasificacionSN sn
					inner join SNClasificacionD a 
					on a.SNCDid = sn.SNCDid
					and a.SNCEid = b.SNCEid
				where SNid = #url.SNid#
				)) = 0
		</cfquery>

	<cfelse>
		<cfquery name="rsSNClasificacionE2" datasource="#session.dsn#">
			select b.SNCEcodigo, b.SNCEdescripcion
			from SNClasificacionE b
			where b.CEcodigo=#session.CEcodigo# #filtro#
			and b.SNCEalertar= 1
			and b.PCCEactivo = 1
			and ((
				select count(1) 
				from SNClasificacionSN sn
					inner join SNClasificacionD a 
					on a.SNCDid = sn.SNCDid
				where SNid = #url.SNid#
				and a.SNCEid = b.SNCEid
				)) = 0
		</cfquery>
	</cfif>		
	
	
	<cfif rsSNClasificacionE2.recordcount>
		<fieldset>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td class="tituloListas">Clasificaciones Con Alerta</td>
		</tr>
		<cfoutput query="rsSNClasificacionE2">
			<cfset LvarListaNon = (CurrentRow MOD 2)>
			<cfset LvarClassName = IIf(LvarListaNon, DE('listaNon'), DE('listaPar'))>
			<tr class="#LvarClassName#" onmouseover="this.className='#LvarClassName#Sel';" onmouseout="this.className='#LvarClassName#';">
				<td>#trim(rsSNClasificacionE2.SNCEcodigo)# - #rsSNClasificacionE2.SNCEdescripcion#</td>
			</tr>	
		</cfoutput>
		</table>
		</fieldset>
	</cfif>
</div>
</td>
</tr>
</table>
<cfif rsSNClasificacionE1.recordcount eq 0 and rsSNClasificacionE2.recordcount eq 0>
	<table align="center" width="95%" border="0" cellspacing="0" cellpadding="0">
		<tr class="listaNon" onmouseover="this.className='listaNonSel';" onmouseout="this.className='listaNon';">
			¡No se encontró ninguna clasificación que le haga falta!
		</tr>
	</table>
</cfif>
<table id="tablabotones2" width="100%" cellpadding="0" cellspacing="0" border="0" >
<tr>
<td>
<form name="form1" style="margin:0;">
	<cf_botones values="Cerrar" functions="window.close();">
</form>
</td>
</tr>
</table>

</body>
</html>
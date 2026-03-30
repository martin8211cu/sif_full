<!--- 
	Creado por: Ana Villavicencio
	Fecha: 27 de febrero del 2006
	Motivo: Tomar codigo en comun de los diferentes archivos de consultas y ponerlo en uno solo.
 --->

<cfinclude template="SociosModalidad.cfm">
<cfset modo="CAMBIO">

<cfparam name="LvarSNtipo" default="">

<cfif isdefined ("url.SNcodigo") and len(trim(url.SNcodigo)) and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>
<cfif isdefined ("url.SNnumero") and len(trim(url.SNnumero)) and not isdefined("form.SNnumero")>
	<cfset form.SNnumero = url.SNnumero>
</cfif>
<cfif isdefined ("url.Ocodigo_F") and len(trim(url.Ocodigo_F)) and not isdefined("form.Ocodigo_F")>
	<cfset form.Ocodigo_F = url.Ocodigo_F>
</cfif>
<cfquery name="rsSocios" datasource="#Session.DSN#" >
	select yo.SNplazoentrega,yo.SNplazocredito,rtrim(yo.LOCidioma) as LOCidioma,yo.Ecodigo, yo.SNcodigo, yo.SNidentificacion, yo.SNtiposocio, yo.SNnombre, yo.SNdireccion,
	 yo.CSNid, yo.GSNid, yo.ESNid, yo.DEidEjecutivo, yo.DEidVendedor, yo.DEidCobrador, yo.SNnombrePago,
	 yo.SNtelefono, yo.SNFax, yo.SNemail, yo.SNFecha, yo.SNtipo, yo.SNvencompras, yo.SNvenventas, yo.SNinactivo, coalesce (yo.ZCSNid,-1) as ZCSNid,
	 yo.Mcodigo, yo.SNmontoLimiteCC, yo.SNdiasVencimientoCC, yo.SNdiasMoraCC, yo.SNdocAsociadoCC,
	 coalesce(yo.SNactivoportal, 0) as SNactivoportal, yo.SNnumero, yo.ts_rversion, yo.Ppais, yo.SNcertificado, yo.SNcodigoext, yo.cuentac,
	 yo.id_direccion, yo.SNidPadre, padre.SNcodigo as SNcodigoPadre, yo.SNid, yo.SNidCorporativo, 
	 coalesce (yo.EcodigoInclusion, yo.Ecodigo) as EcodigoInclusion, einc.Edescripcion	 as EnombreInclusion,
	 yo.esIntercompany,yo.Intercompany
	from SNegocios yo
		left join SNegocios padre
			on yo.SNidPadre = padre.SNid
		left join Empresas einc
			on einc.Ecodigo = coalesce (yo.EcodigoInclusion, yo.Ecodigo)
	where yo.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and yo.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#">
	order by yo.SNnombre asc
</cfquery>

<cfquery name="rsEstadosS" datasource="#session.DSN#">
	select e.ESNid, e.ESNcodigo, e.ESNdescripcion, e.ESNfacturacion
	from EstadoSNegocios e
		inner join SNegocios s
			on s.ESNid = e.ESNid
			and s.Ecodigo  = e.Ecodigo
	where s.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#">
		and s.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsMasks" datasource="#Session.dsn#">
	select J.Pvalor Juridica, F.Pvalor Fisica
	from Parametros J, Parametros F
	where J.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and J.Pcodigo = 620
	  and F.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and F.Pcodigo = 630
</cfquery>

<cfquery name="rsIntercompany" datasource="#Session.dsn#">
	select Edescripcion,Ecodigo
	from Empresas
	<cfif isdefined("rsSocios") and rsSocios.Intercompany gt 0>
		where Ecodigo = #rsSocios.Intercompany#
	</cfif>
	order by Edescripcion
</cfquery>

<cfset tengo_hijos = false>
<cfif modo neq 'ALTA' or isdefined("form.SNcodigo") and Len(form.SNcodigo)>
	<cfset modo='CAMBIO'>
	
	<cfquery datasource="#session.dsn#" name="hijos">
		select count(1) as cantidad
		from SNegocios
		where SNidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.SNid#">
	</cfquery>
	<cfset tengo_hijos = hijos.cantidad GT 0>
</cfif> <!--- modo cambio --->

<cfquery name="rsIdioma" datasource="#session.DSN#">
		select rtrim(Icodigo) as LOCIdioma, Descripcion as LOCIdescripcion
	from Idiomas i
		inner join SNegocios s
			on s.LOCidioma = i.Icodigo
			and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#">
	order by 1, 2
</cfquery>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocios','/sif/generales.xml')>
<cfset LB_Ident = t.Translate('LB_Ident','Identificaci&oacute;n')>
<cfset LB_Mod = t.Translate('LB_Mod','Modalidad')>
<cfset LB_Corp = t.Translate('LB_Corp','Corporativa')>
<cfset LB_NumSoc = t.Translate('LB_NumSoc','N&uacute;mero de Socio')>
<cfset LB_Correo = t.Translate('LB_Correo','Correo')>


 <table align="center" cellpadding="2" cellspacing="3" border="0">
	<tr>
		<td align="left" valign="middle"><font size="-4"><strong><cfoutput>#LB_SocioNegocio#:&nbsp;</cfoutput></strong></font></td>
		<td align="left" valign="middle"><cfoutput><font size="-1"><strong>#rsSocios.SNnombre#</strong></font></cfoutput></td>
		<td align="left" valign="middle"><font size="-4"><strong><cfoutput>#LB_Ident#:&nbsp;</cfoutput></strong></font></td>
		<td align="left" valign="middle"><cfoutput>#rsSocios.SNidentificacion#</cfoutput></td>
		<td align="left" valign="middle">&nbsp;</td>
	  	<td rowspan="2" align="left" valign="middle"><cfif modalidad.modalidad></cfif><font size="-4"><strong><cfoutput>#LB_Mod# <br>
	  		#LB_Corp#:&nbsp;</cfoutput></strong></font></td> 
		<td align="left" valign="middle"><cfoutput>#HTMLEditFormat(modalidad.nombre)#</cfoutput></td>
	</tr>
	<tr>
		<td align="left" valign="middle"><font size="-4"><strong><cfoutput>#LB_NumSoc#:&nbsp;</cfoutput></strong></font></td>
		<td  align="left" valign="middle"><cfoutput>#rsSocios.SNnumero#</cfoutput></td>
		<td align="left" valign="middle"><font size="-4"><strong><cfoutput>#LB_Correo#:&nbsp;</cfoutput></strong></font></td>
		<td align="left" valign="middle"><cfoutput>#rsSocios.SNemail#</cfoutput></td>
		<td align="left" valign="middle">&nbsp;</td>
	  <td align="left" valign="middle">&nbsp;</td>
	</tr>
</table>
<cfset session.menues.Ecodigo="">
<cfset session.menues.SScodigo="">
<cfset session.menues.SMcodigo="">
<cfset session.menues.SPcodigo="">
<cfset session.menues.SMNcodigo = "-1">
<cfset session.menues.Empresa1=false>
<cfset session.menues.Sistema1=false>
<cfset session.menues.Modulo1=false>

<cf_translatedata name="get" tabla="Empresa" conexion="asp" col="e.Enombre" returnvariable="LvarEnombre">
<cfquery name="rsContents" datasource="asp" >
		select distinct
			e.Ecodigo,
			#LvarEnombre# as Enombre,
			e.Ereferencia,
			c.Ccache,
			e.ts_rversion, <!--- para manejar el cache de la imagen --->
			upper( e.Enombre ) as Enombre_upper
		from vUsuarioProcesos up
			inner join Empresa e
				on up.Ecodigo = e.Ecodigo
			inner join Caches c
				on c.Cid = e.Cid
		where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		  and e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		<cfif Len(session.sitio.Ecodigo) and session.sitio.Ecodigo neq 0>
		  and e.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.sitio.Ecodigo#">
		<cfelseif isdefined("session.EcodigoSDC") and session.EcodigoSDC neq 0>
			and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		</cfif>
		order by Enombre
</cfquery>

	<cfif rsContents.RecordCount gt 0>
		<cfset session.EcodigoSDC = rsContents.Ecodigo>
		<cfset session.Ecodigo = rsContents.Ereferencia>
		<cfset session.Enombre = rsContents.Enombre>
		<cfset session.DSN = rsContents.Ccache>
		<cfset session.DSNDefault = rsContents.Ccache>
		<cfquery name="rsCachesE" datasource="asp">
	  		SELECT  e.Ecodigo, e.CEcodigo, mc.SScodigo, s.SSdescripcion, cae.Cid, c.Ccache 
			FROM Empresa e
			inner join ( SELECT  DISTINCT CEcodigo, SScodigo FROM ModulosCuentaE) mc on e.CEcodigo = mc.CEcodigo
			inner join SSistemas s on mc.SScodigo = s.SScodigo
			left join CacheAppEmp cae on e.Ecodigo = cae.Ecodigo and mc.SScodigo = cae.SScodigo
			left join Caches c on c.Cid = cae.Cid
			where s.SScodigo not in ('sys') and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
  		</cfquery>
		<cfset session.querycahe = rsCachesE>
		<cfif session.Ecodigo EQ "">
			<cfset session.menues.Ecodigo="-1">
		<cfelse>
			<cfset session.menues.Ecodigo=session.Ecodigo>
		</cfif>
		<cfset session.menues.Empresa1=true>

		<cfoutput>
		<cflocation url="empresa.cfm?seleccionar_EcodigoSDC=#rsContents.Ecodigo#">
		</cfoutput>

	<cfelse>
		<cf_template template="#session.sitio.template#">
		<cf_templatearea name="title">
			Cambio de Empresa
		</cf_templatearea>
		<cf_templatearea name="left">
		<!---
			<cfinclude template="/sif/menu.cfm"> --->
		</cf_templatearea><cf_templatearea name="body">
		<!--- ver sif_login02.css <cfhtmlhead text='<link href="/cfmx/home/menu/menu.css" rel="stylesheet" type="text/css">'> --->

		<cfinclude template="navegacion.cfm">

		<table border="0" cellpadding="0" cellspacing="0" align="center" width="100%">
			<tr>
				<td colspan="3" align="center" style="font-size: 20px;background-color:#ccc;border:1px solid #999; padding:4px; border-bottom: 2px solid #333; border-right: 2px solid #333">&iexcl; 
					<cfif session.datos_personales.sexo is 'F'>Bienvenida,<cfelse>Bienvenido,</cfif>
					<cfoutput>#session.datos_personales.nombre#
					#session.datos_personales.apellido1#
					#session.datos_personales.apellido2#</cfoutput> ! 
				</td>
			</tr>
			
			<tr>
				<td style="font-size:14px ">&nbsp;</td>
				<td style="font-size:14px ">
					<p>Gracias por acceder el ambiente de operaci&oacute;n de <cfoutput>#session.CEnombre#</cfoutput>. Dentro de este entorno, usted tendr&aacute; acceso a una serie de servicios corporativos de acuerdo con el perfil que se le ha definido. </p>
					<p>En caso de cualquier inconveniente, favor cont&aacute;ctenos. </p>
				</td>
				
				<td style="font-size:14px ">&nbsp;</td>
			</tr>
	
			<tr>
				<td style="font-size:14px ">&nbsp;</td>
				<td style="font-size:14px ">&nbsp;</td>
				<td style="font-size:14px ">&nbsp;</td>
			</tr>
	
			<tr>
				<td width="70" style="font-size:14px "><p>&nbsp;</p></td>
				<td style="font-size:14px ">
					<table border="0" cellpadding="4" cellspacing="4" align="center">
						<tr>
							<td colspan="4" style="font-size:14px"></td></tr>
							<tr><td><strong>A&uacute;n no ha sido afiliado a ninguna empresa.</strong></td>
							<td width="70" style="font-size:16px ">&nbsp;</td>
						</tr>
						
						<tr><td colspan="3">&nbsp;</td></tr>
						<tr><td colspan="3"></td></tr>
						<tr><td colspan="3">&nbsp;</td></tr>
					</table>
				</td>	
			</tr>	
		</table>	
		<cfinclude template="footer.cfm">
		</cf_templatearea>
		</cf_template>
</cfif>
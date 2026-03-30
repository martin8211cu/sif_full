<cfparam name="modo" default="ALTA">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo1 		= t.Translate('LB_Titulo1','Tiendas Full')>
<cfset LB_Titulo2		= t.Translate('LB_Titulo2','Reporte de Avales')>
<cfset LB_Titulo3		= t.Translate('LB_Titulo3','Generado el')>

<cfset LB_SNIdentificacion		= t.Translate('LB_SNIdentificacion', 'SN Identificacion')>
<cfset LB_SNnombre				= t.Translate('LB_SNnombre', 'SN Nombre')>
<cfset LB_ctaD					= t.Translate('LB_ctaD', 'Distribuidor')>
<cfset LB_ctaTC					= t.Translate('LB_ctaTC', 'Tarjetahabiente')>
<cfset LB_ctaTM					= t.Translate('LB_ctaTM', 'Mayorista')>
<cfset LB_SNCidentificacion		= t.Translate('LB_SNCidentificacion', 'Aval Identificacion')>
<cfset LB_SNCnombre				= t.Translate('LB_SNCnombre', 'Aval Nombre')>
<cfset LB_SNCdireccion			= t.Translate('LB_SNCdireccion', 'Aval Direccion')>
<cfset LB_SNCtelefono			= t.Translate('LB_SNCtelefono', 'Aval Telefono')>
<cfset LB_SNCfax				= t.Translate('LB_SNCfax', 'Aval Fax')>
<cfset LB_SNCemail				= t.Translate('LB_SNCemail', 'Aval Email')>


<cfset prevPag="reporteAval.cfm">
<cfset targetAction="reporteAval_sql.cfm">
<cfinclude template="imprimirReporte.cfm" >

<cfquery name="q_DatosReporte" datasource="#Session.DSN#">
	select
		distinct(sn.SNid) 
		, sn.SNidentificacion
		, sn.SNnombre
		, case rtrim(ltrim(c1.tipo)) when 'D' then 'X' else '' end as ctaD
		, case rtrim(ltrim(c2.tipo)) when 'TC' then 'X' else '' end as ctaTC
		, case rtrim(ltrim(c3.tipo)) when 'TM' then 'X' else '' end as ctaTM
		, co.SNCidentificacion
		, co.SNCnombre
		, co.SNCdireccion
		, co.SNCtelefono
		, co.SNCfax
		, co.SNCemail
	from SNegocios sn
		left join CRCCuentas c1
			on c1.SNegociosSNid = sn.SNid
			and rtrim(ltrim(c1.tipo)) = 'D'
		left join CRCCuentas c2
			on c2.SNegociosSNid = sn.SNid
			and rtrim(ltrim(c2.tipo)) = 'TC'
		left join CRCCuentas c3
			on c3.SNegociosSNid = sn.SNid
			and rtrim(ltrim(c3.tipo)) = 'TM'
		inner join SNContactos co
			on co.SNcodigo = sn.SNcodigo
			and snAval=1
	where 
		sn.ecodigo = #session.ecodigo#
		<cfif !isDefined('url.p')> and 1=0 </cfif>
		and (sn.disT = 1 or sn.TarjH = 1 or sn.Mayor = 1)
		and sn.eliminado is null
		<cfif isdefined ("Form.TipoCTA") and Form.TipoCTA neq "">
			<cfset  filtro= Replace(Form.TipoCTA,',',"','",'all')>
			and (rtrim(ltrim(c1.tipo)) in ('#PreserveSingleQuotes(filtro)#')
				or rtrim(ltrim(c2.tipo)) in ('#PreserveSingleQuotes(filtro)#')
				or rtrim(ltrim(c3.tipo)) in ('#PreserveSingleQuotes(filtro)#')
			)
		</cfif>
		<cfif isdefined ("Form.SNID") and Form.SNID neq "">
			and sn.SNID= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNID#">
		</cfif>
</cfquery>
<cfset modo="ALTA">


<cfoutput>
<!--- Tabla para mostrar resultados del reporte generado --->
<div id="#printableArea#">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
			
				<table  width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="4">&nbsp;</td></tr>
					
					<tr>
						<td height="22" align="center" width="40%">
							<span class="style1" style="font-family: verdana; font-size: 200%">#LB_Titulo1#</span><br>
							<span style="font-family: verdana; font-size: 100%"><strong>#LB_Titulo2#</strong><br></span>
							<strong>#LB_Titulo3# #LSDateFormat(Now(),'dd/mm/yyyy')#</strong><br>
						</td>
					</tr>
					<tr height="22" align="center"></tr>
					<tr>
						<table width="100%" border="0">
							<tr>
								<td colspan="11" align="right">
									Filtros:
									[Contacto = Aval]
									<cfif isdefined('Form.Nombre') && Form.Nombre neq ''> [Cliente = #Form.Nombre#]</cfif>
									<cfif isdefined('Form.TipoCTA') && Form.TipoCTA neq ''> [Tipo de cuenta = (#Form.TipoCTA#)]</cfif>
								</td>
							</tr>
							<tr style="background-color: ##A9A9A9;">
								<td>#LB_SNIdentificacion#</td>
								<td>#LB_SNnombre#</td>
								<td>#LB_ctaD#</td>
								<td>#LB_ctaTC#</td>
								<td>#LB_ctaTM#</td>
								<td>#LB_SNCidentificacion#</td>
								<td>#LB_SNCnombre#</td>
								<td>#LB_SNCdireccion#</td>
								<td>#LB_SNCtelefono#</td>
								<td>#LB_SNCfax#</td>
								<td>#LB_SNCemail#</td>
							</tr>
							<cfif q_DatosReporte.RecordCount gt 0>
								<cfloop query="q_DatosReporte">
									<tr>
										<td>#q_DatosReporte.SNIdentificacion#</td>
										<td>#q_DatosReporte.SNnombre#</td>
										<td>#q_DatosReporte.ctaD#</td>
										<td>#q_DatosReporte.ctaTC#</td>
										<td>#q_DatosReporte.ctaTM#</td>
										<td>#q_DatosReporte.SNCidentificacion#</td>
										<td>#q_DatosReporte.SNCnombre#</td>
										<td>#q_DatosReporte.SNCdireccion#</td>
										<td>#q_DatosReporte.SNCtelefono#</td>
										<td>#q_DatosReporte.SNCfax#</td>
										<td>#q_DatosReporte.SNCemail#</td>
									</tr>
								</cfloop>
							<cfelse>
									<tr><td colspan="9">&nbsp;</td></tr>
									<tr><td colspan="9" align="center"><font color="red"><span style="text-align: center;">--- No se encontraron resultados ---</span></font></td></tr>
							</cfif>
						</table>
					</tr>
				</table>
			</td>	
		</tr>
	</table>
</div>
</cfoutput>


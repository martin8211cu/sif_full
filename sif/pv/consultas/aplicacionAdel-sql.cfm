<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cfset LvarVer_Parametros = false>
<cfif len(trim(url.CDCCODIGO)) neq 0>
	<cfset LvarVer_Parametros = true>
</cfif>
<cfif len(trim(url.CDCIDENTIFICACION)) neq 0>
	<cfset LvarVer_Parametros = true>
</cfif>
<cfif len(trim(url.FAM01COD)) neq 0>
	<cfset LvarVer_Parametros = true>
</cfif>
<cfif len(trim(url.FAM01CODD)) neq 0>
	<cfset LvarVer_Parametros = true>
</cfif>
<cfif len(trim(url.FAX14DOC)) neq 0>
	<cfset LvarVer_Parametros = true>
</cfif>
<cfif len(trim(url.FAX14FEC_FIN)) neq 0>
	<cfset LvarVer_Parametros = true>
</cfif>
<cfif len(trim(url.FAX14FEC_INI)) neq 0>
	<cfset LvarVer_Parametros = true>
</cfif>
<cfif len(trim(url.OCODIGO)) neq 0>
	<cfset LvarVer_Parametros = true>
</cfif>
<cfif len(trim(url.OCODIGO2)) neq 0>
	<cfset LvarVer_Parametros = true>
</cfif>
<cfif len(trim(url.OFICODIGO)) neq 0>
	<cfset LvarVer_Parametros = true>
</cfif>

<cfif not(LvarVer_Parametros)>
	<cf_templateheader title="#nav__SPdescripcion#">
			<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>"> 
				<cfoutput>#pNavegacion#</cfoutput>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
					<td align="center"><strong>Debe seleccionar al menos un filtro para emitir este reporte.</strong></td>
				  </tr>
				  <tr>
					<td>&nbsp;</td>
				  </tr>
				  </tr>
				  <tr>
					<td align="Center"><strong>Los Filtros más recomendables son:</strong></td>
				  </tr>
				  <tr>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
					<td align="left"><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Documento</strong></td>
				  </tr>
				  <tr>
					<td align="left"><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;Fecha</strong></td>
				  </tr>
				  <tr>
					<td align="left"><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Caja</strong></td>
				  </tr>
				  <tr>
					<td>&nbsp;</td>
				  </tr>

				  <tr>
					<td align="center">
						<input type="button" class="btnAnterior" value="Regresar" onclick="javascript: location.href = 'aplicacionAdel.cfm';"/>
					</td>
				  </tr>
				  <tr>
					<td>&nbsp;</td>
				  </tr>
				</table>
			<cf_web_portlet_end>
	<cf_templatefooter>
	<cfabort>
</cfif>

<cfif isdefined('url.FAX14FEC_ini') and len(trim(url.FAX14FEC_ini)) GT 0>
	<cfset LvarFechaIni = createdate(mid(url.FAX14FEC_ini,7,4), mid(url.FAX14FEC_ini,4,2), mid(url.FAX14FEC_ini,1,2))>
</cfif>

<cfif isdefined('url.FAX14FEC_fin') and len(trim(url.FAX14FEC_fin)) GT 0>
	<cfset LvarFechaFin = createdate(mid(url.FAX14FEC_fin,7,4), mid(url.FAX14FEC_fin,4,2), mid(url.FAX14FEC_fin,1,2))>
	<cfset LvarFechaFin = dateadd('d',1,LvarFechaFin)>
	<cfset LvarFechaFin = dateadd('s',-2,LvarFechaFin)>
</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="501">
	select 
		case 
			when (e.FAX01NTR is null and e.FAM01COD is null) then e.FAX16NDC
		else
				(( 
					select max(f.FAX11DOC)
					from FAX011 f
					where f.FAX01NTR = e.FAX01NTR
					  and f.FAM01COD = e.FAM01COD 
				))
		end as Documento
		, case 
			when e.FAM01COD is null then ''
		else
			(( select c2.FAM01CODD from FAM001 c2 where c2.FAM01COD = e.FAM01COD and c2.Ecodigo  = e.Ecodigo )) 
		end cajaDet
		, case 
			when e.FAM01COD is null then ''
			else
				(( select rtrim(d2.Oficodigo) from FAM001 c2 inner join Oficinas d2 on d2.Ocodigo = c2.Ocodigo and d2.Ecodigo=c2.Ecodigo where c2.FAM01COD = e.FAM01COD and c2.Ecodigo = e.Ecodigo))
		end oficinaDet
		, e.FAX16FEC
		, coalesce(e.FAX16MON,0) as FAX16MON
		, d1.Oficodigo as oficinaEnc
		, c1.FAM01CODD as cajaEnc
		, b.CDCnombre
		, b.CDCidentificacion
		, a.CDCcodigo
		, a.FAX14FEC
		, a.FAX14MON
		, a.FAX14DOC
		<!--- , e.FAX16OBS   --->
		, 	case when ltrim(rtrim(e.FAX16OBS)) is null 
			then 
				left((( select g.CCTdescripcion from CCTransacciones g where g.CCTcodigo = e.FAX16TIP and g.Ecodigo = e.Ecodigo)),50)
			else 
				left(e.FAX16OBS, 50)
			end observaciones
	from FAX014	a
		inner join ClientesDetallistasCorp b
		on b.CDCcodigo = a.CDCcodigo

		inner join FAM001 c1
					inner join Oficinas d1
						 on d1.Ocodigo = c1.Ocodigo
						and d1.Ecodigo = c1.Ecodigo

		 on c1.FAM01COD = a.FAM01COD
		and c1.Ecodigo  = a.Ecodigo

		left join FAX016 e
			 on e.CDCcodigo = a.CDCcodigo
			and e.FAX14CON  = a.FAX14CON
			and e.Ecodigo   = a.Ecodigo

	where a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.FAX14CLA  = '2'
	  and a.FAX14TDC  = 'AD'		

	<!--- FILTRO DE DOCUMENTO--->
	<cfif isdefined("url.FAX14DOC") and len(trim(url.FAX14DOC))>
		and a.FAX14DOC = '#url.FAX14DOC#'
	</cfif>					

	<!--- FILTRO DE Fecha inicial --->
	<cfif isdefined("url.FAX14FEC_ini") and len(trim(url.FAX14FEC_ini))>
		and a.FAX14FEC >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaIni#">
	</cfif>		

	<!--- FILTRO DE Fecha final --->
	<cfif isdefined("url.FAX14FEC_fin") and len(trim(url.FAX14FEC_fin))>
		and a.FAX14FEC <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaFin#">
	</cfif>	

	<!--- FILTRO DE CLIENTE --->
	<cfif isdefined("url.CDCcodigo") and len(trim(url.CDCcodigo))>
		and a.CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CDCcodigo#">
	</cfif>						

	<!--- FILTRO DE OFICINA --->	
	<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		and c1.Ocodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">
	</cfif>							

	<!--- FILTRO DE CAJA --->
	<cfif isdefined("url.FAM01CODD") and len(trim(url.FAM01CODD))>
		and c1.FAM01CODD = <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD#">
	</cfif>							

	
	order by a.FAX14DOC
</cfquery>


<cfif rsReporte.recordCount GT 500>

<cf_templateheader title="#nav__SPdescripcion#">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>"> 
			<cfoutput>#pNavegacion#</cfoutput>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
		      </tr>
			  <tr>
				<td align="center"><strong>La cantidad de registros generada sobrepasa el l&iacute;mite fijado para este reporte. Debe agregar más filtros a la consulta.</strong></td>
			  </tr>
			  <tr>
			    <td>&nbsp;</td>
		      </tr>
			  <tr>
			    <td align="center">
					<input type="button" class="btnAnterior" value="Regresar" onclick="javascript: location.href = 'aplicacionAdel.cfm';"/>
				</td>
		      </tr>
			  <tr>
			    <td>&nbsp;</td>
		      </tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>

<cfelseif rsReporte.recordCount NEQ 0>

 	<!--- DETERMINA EL TIPO DE FORMATO EN QUE SE RELAIZARA EL REPORTE --->
	<cfset formatos = "flashpaper">
	<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
		<cfset formatos = "pdf">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 3>
		<cfset formatos = "pdf">
	</cfif>

	<!--- INVOCA EL REPORTE --->
	<cfreport format="#formatos#" template= "aplicacionAdel.cfr" query="rsReporte">
		<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
		<cfreportparam name="Edescripcion" value="#session.Enombre#">
	</cfreport>

<cfelse>

<cf_templateheader title="#nav__SPdescripcion#">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>"> 
			<cfoutput>#pNavegacion#</cfoutput>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
		      </tr>
			  <tr>
				<td align="center"><strong>La consulta no gener&oacute; registros.</strong></td>
			  </tr>
			  <tr>
			    <td>&nbsp;</td>
		      </tr>
			  <tr>
			    <td align="center">
					<input type="button" class="btnAnterior" value="Regresar" onclick="javascript: location.href = 'aplicacionAdel.cfm';"/>
				</td>
		      </tr>
			  <tr>
			    <td>&nbsp;</td>
		      </tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>

</cfif>

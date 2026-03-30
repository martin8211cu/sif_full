<!--- Pasa parámetros del url al form--->
<cfif isdefined("url.fecDesde") and len(trim(url.fecDesde))>
	<cfset form.fecDesde = url.fecDesde>
</cfif>
<cfif isdefined("url.fecHasta") and len(trim(url.fecHasta))>
	<cfset form.fecHasta = url.fecHasta>
</cfif>
<cfif isdefined("url.Usucodigo") and len(trim(url.Usucodigo))>
	<cfset form.Usucodigo = url.Usucodigo>
</cfif>


<!--- parametros para la forma de imprimir --->
<cfset vparams = "">
<cfif isdefined("Form.fecDesde")>
	<cfset vparams = vparams & "&fecDesde=" & form.fecDesde>
</cfif>

<cfif isdefined("Form.fecHasta")>
	<cfset vparams = vparams & "&fecHasta=" & form.fecHasta>
</cfif>

<cfquery name="rsQuery" datasource="#session.dsn#">
	select CTRfecha as FECHA,
		   SNnombre as CLIENTE,
		   CTPdescripcion as PROYECTO, 
		   '0' as SISTEMA, <!--- SISTEMA NO ESTA--->
		   cta.CTAcodigo as ACTIVIDAD,
		   CTAdescripcion as DescripcionACTIVIDAD,
		   CTThoras as TIEMPO,
		   Usulogin as USUARIO
	from   Usuario u, 
		   CTReporteTiempos ctr, 
		   CTTiempos ctt, 
		   CTProyectos ctp, 
		   CTActividades cta,
		   SNegocios sne
	where  <cfif isdefined("Form.Usucodigo") and LEN(trim(Form.Usucodigo)) GT 0 >
			u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
		   and </cfif> ctr.Usucodigo = u.Usucodigo
		   and ctt.CTRcodigo = ctr.CTRcodigo
		   and ctt.CTPcodigo = ctp.CTPcodigo
		   and ctt.CTAcodigo = cta.CTAcodigo
		   and sne.SNcodigo = ctr.SNcodigo
		   and ctp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		   and cta.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		   and sne.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif isdefined("Form.CTRfechadesde") and len(trim(Form.CTRfechadesde)) gt 0>
		and CTRfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.CTRfechadesde#">
	</cfif>
	<cfif isdefined("Form.CTRfechahasta") and len(trim(Form.CTRfechahasta)) gt 0>
		and CTRfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.CTRfechahasta#">
	</cfif>		   
		   
</cfquery>

<cfquery name="rsEmpresa" datasource="#session.DSN#" >
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!--- Variables para le proceso de impresion y el corte de pagina --->

	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cfparam name="PageNum_rs" default="1">
	<cfset MaxRows_rs = 100000>		
	<cfset StartRow_rs    = Min( (PageNum_rs-1) * MaxRows_rs + 1, Max(rsQuery.RecordCount, 1) )>
	<cfset StartRow_lista = StartRow_rs + (1-PageNum_rs) >
	<cfif StartRow_lista lte 1>
		<cfset StartRow_lista = 1>
	</cfif>
	
	<cfset EndRow_rs=Min(StartRow_rs+MaxRows_rs-1,rsQuery.RecordCount)>
	<cfset TotalPages_rs=Ceiling(rsQuery.RecordCount/MaxRows_rs)>

<cfsavecontent variable="encabezado1">
		<tr> 
		  <td colspan="8" class="tituloAlterno" align="center"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td>
		</tr>
		<tr><td colspan="8">&nbsp;</td></tr>
		<tr> 
		  <td colspan="8" align="center"><b>Reportes Tiempos por Usuario</b></td>
		</tr>
		<tr> 
			<cfoutput>
				<td colspan="8" align="center">
					<b>Desde:&nbsp;</b>#LSDateFormat(Form.fecDesde, 'dd/mm/yyyy')# &nbsp; 
					<b>Hasta:&nbsp;</b>#LSDateFormat(fecHasta, 'dd/mm/yyyy')#
				</td>
		  </cfoutput>
		</tr>
		<tr><td>&nbsp;</td></tr>
</cfsavecontent>

<cfsavecontent variable="encabezado2">
	<tr class="encabReporte">
		<td align="center"><strong>Fecha</strong></td>
		<td align="center"><strong>Cliente</strong></td>
		<td align="center"><strong>Proyecto</strong></td> 
		<td align="center"><strong>Sistema</strong></td>
		<td align="center"><strong>Actividad</strong></td>
		<td align="center"><strong>Descripcion</strong></td>
		<td align="center"><strong>Tiempo</strong></td>
		<td align="center"><strong>Usuario</strong></td>
	</tr>
</cfsavecontent>

<!--- Estilos para el reporte --->
<style type="text/css">
	.encabReporte {
		background-color: #CCCCCC;
		font-weight: bold;
		color: #000000;
		padding-top: 10px;
		padding-bottom: 10px;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
}
</style>
<form style="margin:0; " name="form1" method="post">
	<link type="text/css" rel="stylesheet" href="/cfmx/sif/css/asp.css">
	<cfoutput>
		<cfif not isdefined("url.imprimir")>
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top">
						<cfinclude template="../../portlets/pNavegacion.cfm">
						<cf_rhimprime datos="/sif/ControlTiempos/consultas/formTiemposXUsr.cfm" paramsuri="#vparams#">
					</td>	
				</tr>
			</table>	
		</cfif>
	</cfoutput>
	<!--- Form del Reporte --->
		<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 10px" align="center">
			<cfif not isdefined("url.imprimir")>
				<cfoutput>
					<tr> 
						<td colspan="8" class="tituloAlterno" align="center">#session.Enombre#</td>
					</tr>
					<tr> 
						<td colspan="8">&nbsp;</td>
					</tr>
					<tr> 
						<td colspan="8" align="center"><b>Reporte de Tiempos por Usuario</b></td>
					</tr>
					<tr> 
						<td colspan="8" align="center">
							<b>Fecha del Reporte:&nbsp;</b> #LSDateFormat(fecDesde, 'dd-mm-yyyy')# &nbsp; 
							<b>Hasta:&nbsp;</b>#LSDateFormat(fecHasta, 'dd-mm-yyyy')#
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr class="encabReporte">
						<td align="center"><strong>Fecha</strong></td>
						<td align="center"><strong>Cliente</strong></td>
						<td align="center"><strong>Proyecto</strong></td> 
						<td align="center"><strong>Sistema</strong></td>
						<td align="center"><strong>Actividad</strong></td>
						<td align="center"><strong>Descripcion</strong></td>
						<td align="center"><strong>Tiempo</strong></td>
						<td align="center"><strong>Usuario</strong></td>
					</tr>
					<tr><td>&nbsp;</td></tr>
				</cfoutput>
			</cfif>
			<cfset rsResultado = QueryNew("")>
			<cfset arreglo     = ArrayNew(1)>
			<cfset index = 0 >
			<cfset Puesto = 0>
			<cfoutput query="rsQuery" startrow="#StartRow_lista#" maxrows="#MaxRows_rs#">
				<cfif isdefined("url.imprimir")>
					<cfif currentRow mod 35 EQ 1>
						<cfif currentRow NEQ 1>
							<tr class="pageEnd"><td colspan="7">&nbsp;</td></tr>
						</cfif>
						#encabezado1#
						#encabezado2#
					</cfif>	
				</cfif>
				<cfset index = index + 1 >
				<tr>
					<td nowrap align="center">#LSDateFormat(rsQuery.Fecha,"dd/mm/yyyy")#</td>
					<td nowrap>#rsQuery.cliente#</td>
					<td nowrap>#rsQuery.Proyecto#</td>
					<td nowrap align="center">#rsQuery.Sistema#</td>
					<td nowrap align="center">#rsQuery.Actividad#</td>
					<td nowrap>#rsQuery.DescripcionACTIVIDAD#</td>
					<td nowrap>#rsQuery.Tiempo#</td>
					<td nowrap>#rsQuery.Usuario#</td>
				</tr>	
			</cfoutput>
			<tr><td colspan="8">&nbsp;</td></tr>
			<tr><td colspan="8" class="topline">&nbsp;</td></tr>
			<tr><td colspan="8" class="topline">&nbsp;</td></tr>			
			<tr>
				<td colspan="8">
					<div align="center"><strong>------------------ Fin del Reporte ------------------</strong></div>
				</td>
			</tr>
		</table>

</form>
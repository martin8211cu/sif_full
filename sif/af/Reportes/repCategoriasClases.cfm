<!--- cuando viene descargar aquí mismo se hace la descarga, está abajo --->
<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfif isdefined("Url.btnGenerar") and not isdefined("Form.btnGenerar")>
	<cfparam name="Form.btnGenerar" default="#Url.btnGenerar#">
</cfif>
<cfif isdefined('url.ACcodigodesde') and not isdefined('form.ACcodigodesde')>
	<cfset form.ACcodigodesde = url.ACcodigodesde>
</cfif>
<cfif isdefined('url.ACcodigohasta') and not isdefined('form.ACcodigohasta')>
	<cfset form.ACcodigohasta = url.ACcodigohasta>
</cfif>
<cfif isdefined('url.Formato') and not isdefined('form.Formato')>
	<cfset form.Formato = url.Formato>
</cfif>

<cfif not isdefined('form.ACcodigodesde') or  (isdefined('url.ACcodigodesde') and len(trim(url.ACcodigodesde)) eq  0)>
	<cf_templateheader title="#nav__SPdescripcion#">
			<cfoutput>#pNavegacion#</cfoutput>
			<cf_web_portlet_start titulo="#nav__SPdescripcion#">
				<table width="100%" border="0">
					<tr>
						<td align="center">
							<cfset filtro = "">
							<cfset navegacion = "">	
							<cfif isdefined("Form.btnGenerar") and Len(Trim(Form.btnGenerar)) NEQ 0>
								<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "btnGenerar=" & Form.btnGenerar>
							</cfif>
							<cfinclude template="agtProceso_filtroCategoriasClases.cfm">
						</td>
					</tr>							
				</table>
			<cf_web_portlet_end>
		<cf_templatefooter>
<cfelse>
	<cfif form.Formato EQ "1">
	<table width="100%" border="0">
	  <tr>
		<td width="5%">&nbsp;</td>
		<td>&nbsp;</td>
		<td width="5%">&nbsp;</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td>
			<cfset param = "">
			<cfset filtro = "">
			<cfset navegacion = "">						
		
			<cfif isdefined('form.ACcodigodesde') and form.ACcodigodesde NEQ ''>
				<cfset param = param & "&ACcodigodesde=#form.ACcodigodesde#">
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ACcodigodesde=" & Form.ACcodigodesde>
			</cfif>
			<cfif isdefined('form.ACcodigohasta') and form.ACcodigohasta NEQ ''>
				<cfset param = param & "&ACcodigohasta=#form.ACcodigohasta#">
			</cfif>
			<cfinclude template="repCategoriasClases-form.cfm">
		</td>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>
	</table>
	</cfif>
</cfif>

<cfif isdefined('form.Formato')>
	<cfif form.Formato NEQ "1">
		<cfsavecontent variable="rsCategoriasClases">
			<cfoutput>
				select b.ACcodigodesc as Codigo_Categoria
				, b.ACdescripcion as Descripcion_Categoria
				, b.ACmascara as Mascara_Cuenta
				, case b.ACmetododep when 1 then 'Linea Recta' when 2 then 'Ambos' when 3 then 'Suma Digitos' end as Metodo_Depreciacion				, b.ACcatvutil as Indicado_Vida_Util
				, b.ACvutil as Vida_Util
				, b.cuentac as Complemento_Inversion
				, a.ACcodigodesc as Codigo_Clasificacion
				, a.ACdescripcion as Descripcion_Clasificacion
				, a.ACdepreciable as Depreciable
				, a.ACrevalua as Revaluable
				, case a.ACtipo when 'M' then 'Por Monto' when 'P' then 'Por Porcentaje' end as Tipo_Valor_Residual
				, a.ACvalorres as Valor_Residual
				, ctaSuperavit.Cformato as Superavit
				, ctaAdquisicion.Cformato as Adquisicion
				, ctaDepr_Acumulada.Cformato as Depr_Acumulada
				, ctaRevaluacion.Cformato as Revaluacion
				, ctaDepr_Acum_Revaluacion.Cformato as Depr_Acum_Revaluacion
				, a.ACgastodep as Compl_Depreciacion
				, a.ACgastorev as Compl_Revaluacion
				, a.cuentac as Compl_Inversion
				, a.ACgastoret as Compl_Gasto_Retiro
				, a.ACingresoret as Compl_Ingreso_Retiro
				from AClasificacion a
					inner join ACategoria b
						on b.ACcodigo = a.ACcodigo
						and b.Ecodigo = #session.Ecodigo#
					inner join CContables ctaSuperavit
						on ctaSuperavit.Ccuenta = a.ACcsuperavit
					inner join CContables ctaAdquisicion
						on ctaAdquisicion.Ccuenta = a.ACcadq
					inner join CContables ctaDepr_Acumulada
						on ctaDepr_Acumulada.Ccuenta = a.ACcdepacum
					inner join CContables ctaRevaluacion
						on ctaRevaluacion.Ccuenta = a.ACcrevaluacion
					inner join CContables ctaDepr_Acum_Revaluacion
						on ctaDepr_Acum_Revaluacion.Ccuenta = a.ACcdepacumrev
				where a.Ecodigo = #session.Ecodigo#
				<cfif form.ACcodigodesde GT 0>
					and a.ACcodigo >= #form.ACcodigodesde#
				</cfif>
				<cfif form.ACcodigohasta GT 0>
					and a.ACcodigo <= #form.ACcodigohasta#
				</cfif>
				order by a.ACcodigo
			</cfoutput>
		</cfsavecontent>
		
		<cftry>
			<cfflush interval="128">
			<cf_jdbcquery_open name="data" datasource="#session.DSN#">
				<cfoutput>#rsCategoriasClases#</cfoutput>
			</cf_jdbcquery_open>
			<cfif isdefined("form.Formato") and form.Formato eq "2">
				<cf_exportQueryToFile query="#data#" filename="CategoriasClases_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls" jdbc="true">
			<cfelseif isdefined("form.Formato") and form.Formato eq "3">
				<cf_exportQueryToFile query="#data#" separador="#chr(9)#" filename="CategoriasClases_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="true">
			</cfif>
			<cfcatch type="any">
				<cf_jdbcquery_close>
				<cfrethrow>
			</cfcatch>
		</cftry>
		<cf_jdbcquery_close>
	</cfif>
</cfif>



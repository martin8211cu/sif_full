<cfset parametros = ''>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfif isdefined("url.DEid1") and len(trim(url.DEid1))>
	<cfset form.DEid1 = url.DEid1>
	<cfset parametros = parametros & '&DEid1=form.DEid1'>	
</cfif>
<cfif isdefined("url.FechaInicial") and len(trim(url.FechaInicial))>
	<cfset form.FechaInicial = url.FechaInicial>
	<cfset parametros = parametros & '&FechaInicial=#LSDateFormat(form.FechaInicial,'dd/mm/yyyy')#'>
</cfif>
<cfif isdefined("url.FechaFinal") and len(trim(url.FechaFinal))>
	<cfset form.FechaFinal = url.FechaFinal>
	<cfset parametros = parametros & '&FechaFinal=#LSDateFormat(form.FechaFinal,'dd/mm/yyyy')#'>
</cfif>
<cfif isdefined("url.NoDocumento") and len(trim(url.NoDocumento))>
	<cfset form.NoDocumento = url.NoDocumento>
	<cfset parametros = parametros & '&NoDocumento=form.NoDocumento'>
</cfif>

<style type="text/css">
	.topline {
		background-color:#FAFAFA;
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>

<!--- VERIFICA QUE LAS FECHA INICIAL SEA MENOR QUE LA FECHA FINAL, Y SI NO LAS INVIERTE--->
<cfif isdefined("form.FechaInicial") and len(trim(form.FechaInicial)) and isdefined("form.FechaFinal") and len(trim(form.FechaFinal))>
	<cfset form.FechaInicial = LSParseDateTime(form.FechaInicial) >
	<cfset form.FechaFinal = LSParseDateTime(form.FechaFinal) >
	<cfif form.FechaInicial gt form.FechaFinal >
		<cfset tmp = form.FechaInicial >
		<cfset form.FechaInicial = form.FechaFinal >
		<cfset form.FechaFinal = tmp >
	</cfif>
</cfif>

<cfquery name="rsDatos" datasource="#session.DSN#">
	select  b.DEnombre#_Cat#' '#_Cat#b.DEapellido1#_Cat#' '#_Cat#b.DEapellido2 as Empleado
			,b.DEidentificacion as cedula
			,substring(a.NoDocumento,1,((charindex('-',a.NoDocumento)+charindex('-',(substring(a.NoDocumento,(charindex('-',a.NoDocumento)+1),len(a.NoDocumento)))))-1)) as Documento
			,a.fechaalta as fecharecibo
			,a.MontoTotalPagado as MtoDcto
			,a.MontoUtilizado as MtoUtilizado
			,coalesce(coalesce(a.MontoTotalPagado,0) - coalesce(a.MontoUtilizado,0),0) as MtoDisponible
			,c.TDcodigo#_Cat#'-'#_Cat#c.TDdescripcion as DeduccionRecibo
	from PagoPorCaja a, DatosEmpleado b, TDeduccion c
	where a.DEid = b.DEid
		and a.TDid = c.TDid
		<cfif isdefined("form.DEid1") and len(trim(form.DEid1))>
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid1#">
		</cfif>
		<cfif (isdefined("form.FechaInicial") and len(trim(form.FechaInicial))NEQ 0) and (isdefined("form.FechaFinal") and len(trim(form.FechaFinal))NEQ 0)>
			and <cf_dbfunction name="to_date00"	args="a.fechaalta"> between <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#form.FechaInicial#"/>
			and <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#form.FechaFinal#"/>
		<cfelse>			
			<cfif isdefined("form.FechaInicial") and len(trim(#form.FechaInicial#))NEQ 0>
				and <cf_dbfunction name="to_date00"	args="a.fechaalta"> >= <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#form.FechaInicial#"/>
			</cfif>
			
			<cfif isdefined("form.FechaFinal") and len(trim(#form.FechaFinal#))NEQ 0>
				and <cf_dbfunction name="to_date00"	args="a.fechaalta"> <= <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#form.FechaFinal#"/>
			</cfif> 
		</cfif>
		<cfif isdefined("form.NoDocumento") and len(trim(form.NoDocumento))>
			and substring(a.NoDocumento,1,((charindex('-',a.NoDocumento)+charindex('-',(substring(a.NoDocumento,(charindex('-',a.NoDocumento)+1),len(a.NoDocumento)))))-1)) = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#form.NoDocumento#">
		</cfif>
	order by 	b.DEnombre#_Cat#' '#_Cat#b.DEapellido1#_Cat#' '#_Cat#b.DEapellido2,b.DEidentificacion	
	
	
</cfquery>

<br />

<cfif not isdefined("url.IMPRIMIR")>
	<p align="center">
		<input type="button" name="btnRegresar" value="Regresar" onclick="javascript: location.href='PagosDeCaja-filtro.cfm'"/>
	</p>
</cfif>

<cf_rhimprime datos="/sif/ccrh/consultas/PagosDeCaja-form.cfm" paramsuri="#parametros#">

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="3" align="center"><font size="10"><strong><cfoutput>#session.enombre#</cfoutput></strong></font></td>
	</tr>
	<tr>
		<td colspan="3" align="center"><strong>Consulta de Documentos Provenientes de Cajas</strong></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td colspan="3" align="center">
			<table align="center" width="80%">
				<tr>
					<td class="tituloListas">Documento</td>
					<td class="tituloListas">Fecha</td>
					<td class="tituloListas">Deducción (Recibo)</td>
					<td class="tituloListas" align="right">Mto.Documento</td>
					<td class="tituloListas" align="right">Mto.Utilizado</td>
					<td class="tituloListas" align="right">Mto.Disponible</td>
				</tr>
				<cfoutput query="rsDatos" group="cedula">					
					<tr>
						<td class="topline" colspan="6">
							<strong>Empleado:&nbsp; #cedula# - #Empleado# </strong>
						</td>
					</tr>											
					<cfoutput>
						<tr>
							<td>#Documento#</td>
							<td>#LSDateformat(fecharecibo,'dd/mm/yyyy')#</td>
							<td>#DeduccionRecibo#</td>
							<td align="right">#LSNumberFormat(MtoDcto,',9.00')#</td>
							<td align="right">#LSNumberFormat(MtoUtilizado,',9.00')#</td>		
							<td align="right">#LSNumberFormat(MtoDisponible,',9.00')#</td>					
						</tr>	
					</cfoutput>
				</cfoutput>					
			</table>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>	
	<tr><td>&nbsp;</td></tr>	
	<cfif not isdefined("url.IMPRIMIR")>
		<tr>
			<td colspan="3" align="center"><input type="button" name="btnRegresar" value="Regresar" onclick="javascript: location.href='PagosDeCaja-filtro.cfm'"/></td>
		</tr>
	</cfif>
</table>
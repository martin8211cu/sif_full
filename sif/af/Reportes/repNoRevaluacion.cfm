<!--- cuando viene descargar aquí mismo se hace la descarga, está abajo --->
<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfif isdefined("Url.btnFiltrar") and not isdefined("Form.btnFiltrar")>
	<cfparam name="Form.btnFiltrar" default="#Url.btnFiltrar#">
</cfif>
<cfif isdefined('url.AGTPid') and not isdefined('form.AGTPid')>
	<cfset form.AGTPid = url.AGTPid>
</cfif>					
<cfif isdefined('url.FAplaca') and not isdefined('form.FAplaca')>
	<cfset form.FAplaca = url.FAplaca>
</cfif>
<cfif isdefined('url.ACcodigo') and not isdefined('form.ACcodigo')>
	<cfset form.ACcodigo = url.ACcodigo>
</cfif>
<cfif isdefined('url.ACid') and not isdefined('form.ACid')>
	<cfset form.ACid = url.ACid>
</cfif>															
<cfif isdefined('url.FCentroF') and not isdefined('form.FCentroF')>
	<cfset form.FCentroF = url.FCentroF>
</cfif>	

<cfif isdefined('form.btnGenerar')>
	<cfif form.FAGTPformato NEQ "1">
		<!---<cfif form.FAGTPperiodo GT 0 and form.FAGTPmes GT 0 and form.ACcodigo GT 0>--->
		<cfif form.FAGTPperiodo GT 0 and form.FAGTPmes GT 0>
			<cfsavecontent variable="rsNoRevaluacion">
			<cf_dbfunction name="date_part"	 args="YY, c.Afechainidep" returnVariable="fechaYY">
			<cf_dbfunction name="to_integer"  args="#fechaYY#" returnvariable="Añofecha">
			<cf_dbfunction name="date_part"	 args="mm, c.Afechainidep" returnVariable="fechaMM">
			<cf_dbfunction name="to_integer"  args="#fechaMM#" returnvariable="mesfecha">
				<cfoutput>
					select distinct
						c.Aplaca as Placa,
						c.Adescripcion as Descripcion,
						h.AFSvaladq as Adquisicion,
						h.AFSvalmej as Mejora,
						h.AFSvalrev as Revaluacion,
						h.AFSdepacumadq as Dep_Acum_Adq,
						h.AFSdepacummej as Dep_Acum_Mej,
						h.AFSdepacumrev as Dep_Acum_Rev,
						h.AFSsaldovutiladq as Saldo_VUtil,
						b.ACcodigodesc as Cod_Categoria,
						b.ACdescripcion as Categoria,
						a.ACcodigodesc as Cod_Clase,
						a.ACdescripcion as Clase,
						e.CFcodigo as Cod_Centro_Funcional,
						e.CFdescripcion as Centro_Funcional,
						ofi.Oficodigo as Oficina,
						ofi.Odescripcion as OficinaD
						from AClasificacion a
							inner join ACategoria b on b.ACcodigo = a.ACcodigo
								and b.Ecodigo = #session.Ecodigo#
								<cfif isdefined('form.ACcodigo') and len(trim(form.ACcodigo)) and form.ACcodigo GT 0>
								and b.ACcodigo = #form.ACcodigo#
								</cfif>
							inner join AFSaldos h on h.ACcodigo = b.ACcodigo
								and h.Ecodigo = #session.Ecodigo#
								<cfif isdefined('form.Oficodigo') and len(trim(form.Oficodigo)) and form.Oficodigo GT 0>
								and h.Ocodigo = ofi.Ocodigo
								</cfif>
							inner join Oficinas ofi
							<cfif isdefined('form.Oficodigo') and len(trim(form.Oficodigo)) and form.Oficodigo GT 0>
								on ofi.Oficodigo = '#form.Oficodigo#'
							<cfelse>
								on ofi.Ocodigo = h.Ocodigo
							</cfif>
								and ofi.Ecodigo = #session.Ecodigo#
							
									inner join Activos c on c.Aid = h.Aid
										and c.Ecodigo = #session.Ecodigo#
										<cfif isdefined('form.ACid') and len(trim(form.ACid)) and form.ACid GT 0>
										and c.ACid = #form.ACid#
										</cfif>
									inner join CFuncional e on e.CFid = h.CFid
										and e.Ecodigo = #session.Ecodigo#
						where a.Ecodigo = #session.Ecodigo#
						<cfif isdefined('form.ACcodigo') and len(trim(form.ACcodigo)) and form.ACcodigo GT 0>
						and a.ACcodigo = #form.ACcodigo#
						</cfif>
						and a.ACid = c.ACid
						and a.ACrevalua = 'S'
						and not exists (select 1 from AFSaldos f where c.Aid = f.Aid
						<cfif isdefined('form.FAGTPperiodo') and len(trim(form.FAGTPperiodo)) and form.FAGTPperiodo GT 0>
							and f.AFSperiodo = #form.FAGTPperiodo#
						</cfif>
						<cfif isdefined('form.FAGTPmes') and len(trim(form.FAGTPmes)) and form.FAGTPmes GT 0>
							and f.AFSmes = #form.FAGTPmes#
						</cfif>
						and AFSsaldovutiladq > 0)
						and not exists (select 1 from TransaccionesActivos g where c.Aid = g.Aid and g.IDtrans = 5)
						and #Añofecha# <= #form.FAGTPperiodo# and #mesfecha# <= #form.FAGTPmes#
						group by c.Aid, c.Aplaca, c.Adescripcion, h.AFSvaladq, h.AFSvalmej, h.AFSvalrev, h.AFSdepacumadq, h.AFSdepacummej, h.AFSdepacumrev, h.AFSsaldovutiladq, b.ACcodigodesc, b.ACdescripcion, a.ACcodigodesc, a.ACdescripcion, e.CFcodigo, e.CFdescripcion, ofi.Oficodigo, ofi.Odescripcion
						order by b.ACdescripcion, a.ACdescripcion, e.CFdescripcion, c.Adescripcion
				</cfoutput>
			</cfsavecontent>
			
			<cftry>
				<cfflush interval="16000">
				<cf_jdbcquery_open name="data" datasource="#session.DSN#">
					<cfoutput>#rsNoRevaluacion#</cfoutput>
				</cf_jdbcquery_open>
				<cfif isdefined("form.FAGTPformato") and form.FAGTPformato eq "2">
					<cf_exportQueryToFile query="#data#" filename="NoRevaluacion_#session.Usucodigo##LSDateFormat(Now(),'ddmmyyyy')##LSTimeFormat(Now(),'hh:mm:ss')#.xls" jdbc="true">
				<cfelseif isdefined("form.FAGTPformato") and form.FAGTPformato eq "3">
					<cf_exportQueryToFile query="#data#" separador="#chr(9)#" filename="NoRevaluacion_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="true">
				</cfif>
				<cfcatch type="any">
					<cf_jdbcquery_close>
					<cfrethrow>
				</cfcatch>
			</cftry>
			<cf_jdbcquery_close>
		<cfelse>
			<script>history.go(-1);</script>
		</cfif>
	<cfelse>
		<cfinclude template="repNoRevaluacion-lista.cfm">
	</cfif>

<cfelse>
	<cfif not isdefined('form.AGTPid') or (isdefined('url.AGTPid') and len(trim(url.AGTPid)) eq  0)>
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
								<cfinclude template="agtProceso_filtroGrupos_2.cfm">
							</td>
						</tr>							
					</table>
				<cf_web_portlet_end>
			<cf_templatefooter>
	<cfelse>
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

				<cfif isdefined('form.AGTPid') and form.AGTPid NEQ ''>
					<cfset param = param & "&AGTPid=#form.AGTPid#">
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "AGTPid=" & Form.AGTPid>
				</cfif>
				<cfif isdefined('form.FAplaca') and form.FAplaca NEQ ''>
					<cfset param = param & "&FAplaca=#form.FAplaca#">
				</cfif>
				<cfif isdefined('form.ACcodigo') and form.ACcodigo NEQ ''>
					<cfset param = param & "&ACcodigo=#form.ACcodigo#">
				</cfif>
				<cfif isdefined('form.ACid') and form.ACid NEQ ''>
					<cfset param = param & "&ACid=#form.ACid#">
				</cfif>
				<cfif isdefined('form.FCentroF') and form.FCentroF NEQ ''>
					<cfset param = param & "&FCentroF=#form.FCentroF#">
				</cfif>								

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


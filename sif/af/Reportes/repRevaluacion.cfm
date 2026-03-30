<!--- cuando viene descargar aquí mismo se hace la descarga, está abajo --->
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfif not isdefined('form.btnDescargar')>
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
	<cfif isdefined('url.FCategoria') and not isdefined('form.FCategoria')>
		<cfset form.FCategoria = url.FCategoria>
	</cfif>
	<cfif isdefined('url.FClase') and not isdefined('form.FClase')>
		<cfset form.FClase = url.FClase>
	</cfif>															
	<cfif isdefined('url.FCentroF') and not isdefined('form.FCentroF')>
		<cfset form.FCentroF = url.FCentroF>
	</cfif>	
	<cfif not isdefined('form.AGTPid') or  (isdefined('url.AGTPid') and len(trim(url.AGTPid)) eq  0)>
		<cf_templateheader title="#nav__SPdescripcion#">
				<cfinclude template="/sif/portlets/pNavegacion.cfm">
				<cfoutput>#pNavegacion#</cfoutput>
			<cf_web_portlet_start titulo="#nav__SPdescripcion#">
					<table width="100%" border="0">
						<tr>
							<td align="center">
								<cfset filtro = "">
								<cfset navegacion = "">	
								<cfif isdefined("Form.btnFiltrar") and Len(Trim(Form.btnFiltrar)) NEQ 0>
									<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "btnFiltrar=" & Form.btnFiltrar>
								</cfif>
								<cfinclude template="agtProceso_filtroGrupos.cfm">
								<cfif isdefined('form.btnFiltrar')>
										<cfinclude template="repRevaluacion-lista.cfm">
								</cfif>
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
				<cfif isdefined('form.FCategoria') and form.FCategoria NEQ ''>
					<cfset param = param & "&FCategoria=#form.FCategoria#">
				</cfif>
				<cfif isdefined('form.FClase') and form.FClase NEQ ''>
					<cfset param = param & "&FClase=#form.FClase#">
				</cfif>
				<cfif isdefined('form.FCentroF') and form.FCentroF NEQ ''>
					<cfset param = param & "&FCentroF=#form.FCentroF#">
				</cfif>								
				<cfinclude template="repRevaluacion-form.cfm">
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
<cfelse>
	<cfset AGTPid = form.chk>
	<cfparam name="AGTPid">

	<cfquery name="rsAGTProceso" datasource="#session.dsn#">
		select AGTPdescripcion, AGTPestadp, AGTPperiodo, AGTPmes
		from AGTProceso
		where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#AGTPid#">
	</cfquery>

	<!--- Valida si la consulta viene vacia --->
	<cfif rsAGTProceso.recordcount eq 0>
		<cf_errorCode	code = "50105" msg = "No se encontró la transacción de Revaluación, Proceso Cancelado!">
	</cfif>

	<cfset Estado = rsAGTProceso.AGTPestadp>
	
	<cfsavecontent variable="rsRevaluacion">
		<cfoutput>
			Select 	
					 rtrim(f.CFcodigo)    #_Cat# '-' #_Cat#  rtrim(f.CFdescripcion) as CentroF
					,rtrim(h.Deptocodigo) #_Cat# '-' #_Cat#  rtrim(h.Ddescripcion)  as Departamento
					,rtrim(g.Oficodigo)   #_Cat# '-' #_Cat#  rtrim(g.Odescripcion)  as Oficina
					,rtrim(d.ACcodigodesc)#_Cat# '-' #_Cat#  rtrim(d.ACdescripcion) as Categoria
					,rtrim(e.ACcodigodesc)#_Cat# '-' #_Cat#  rtrim(e.ACdescripcion) as Clase
					, c.Aplaca as Placa
					, c.Adescripcion as Activo 
					, c.Aserie as Serie 
					<!---Montos Originales antes de aplicar los indices--->
					, Coalesce(afs.AFSvutiladq,0) as SaldoVidaUtil_Ori
					, Coalesce(a.TAvaladq,0) 	  as Valor_Adquisicion_Ori
					, Coalesce(a.TAvalmej,0) 	  as Valor_Mejera_Ori
					, Coalesce(a.TAvalrev,0) 	  as Valor_Revaluacin_Ori
					, Coalesce(a.TAdepacumadq,0)  as Dep_Adquisicin_Ori
					, Coalesce(a.TAdepacummej,0)  as Dep_Mejora_Ori
					, Coalesce(a.TAdepacumrev,0)  as Dep_Revaluacin_Ori
					<!---Montos aplicado el Indice--->
					, a.TAmontolocadq as Rev_Adquisicion
					, a.TAmontolocmej as Rev_Mejoras
					, a.TAmontolocrev as Rev_Revaluacion
					, a.TAmontodepadq as Rev_Dep_Adquisicion
					, a.TAmontodepmej as Rev_Dep_Mejoras
					, a.TAmontodeprev as Rev_Dep_Revaluacion
					, a.TAsuperavit as SuperAvit					
					,<cf_dbfunction name="to_float" args="coalesce(a.AFIindice,0.00)" dec="8" datasource="#session.DSN#"> as Indice
					, a.TAmeses as Meses
					, a.TAperiodo as Periodo 
					, v.VSdesc as Mes
					<!--- Inclusion de Costo de Reevaluacion y Depreciacion de Reevaluacion --->
					, i.Cformato as Cuenta_Costo_Reeval
					, j.Cformato as Cuenta_Depreciacion_Reeval
					<!--- Inclusion de Costo de Reevaluacion y Depreciacion de Reevaluacion --->
					, a.TAfalta as FechaAlta 
			from <cfif Estado lt 4>ADTProceso<cfelse>TransaccionesActivos</cfif> a
				inner join VSidioma v 
					on  <cf_dbfunction name="to_number" args="v.VSvalor" datasource="#session.dsn#"> = a.TAmes 
					and v.VSgrupo=1
				inner join AFSaldos afs 
					on afs.Aid = a.Aid 
				   and afs.AFSmes = a.TAmes 
				   and afs.AFSperiodo = a.TAperiodo
				inner join Idiomas v2 
					on v2.Iid = v.Iid 
				   and v2.Icodigo = '#Session.Idioma#'
				inner join AGTProceso b 
					on b.AGTPid = a.AGTPid 
				   and b.IDtrans = a.IDtrans 
				   and b.Ecodigo = a.Ecodigo 
				inner join Activos c 
				    on c.Aid = a.Aid 
				   and c.Ecodigo = a.Ecodigo
				inner join ACategoria d 
				    on d.ACcodigo = c.ACcodigo 
				   and d.Ecodigo = c.Ecodigo
				inner join AClasificacion e 
				    on e.ACid = c.ACid 
				   and e.ACcodigo = c.ACcodigo 
				   and e.Ecodigo = c.Ecodigo
				inner join CContables i <!--- Inclusion de Costo de Reevaluacion y Depreciacion de Reevaluacion --->
				    on i.Ccuenta = e.ACcrevaluacion 
				   and e.Ecodigo = c.Ecodigo
				inner join CContables j 
				    on j.Ccuenta = e.ACcdepacumrev 
					and e.Ecodigo = c.Ecodigo
				left outer join CFuncional f <!--- Inclusion de Costo de Reevaluacion y Depreciacion de Reevaluacion --->
				    on f.CFid = a.CFid 
				   and f.Ecodigo = a.Ecodigo
				left outer join Oficinas g 
				    on g.Ocodigo = f.Ocodigo 
				   and g.Ecodigo = f.Ecodigo
				left outer join Departamentos h 
					on h.Dcodigo = f.Dcodigo
				   and h.Ecodigo = f.Ecodigo
			where a.Ecodigo = #session.Ecodigo#
				and a.AGTPid = #AGTPid#
				and a.IDtrans = 3
				<cfif isdefined('form.FAplaca') and len(trim(form.FAplaca))>
					and c.Aplaca = #form.FAplaca#
				</cfif>
				<cfif isdefined('form.FCategoria') and len(trim(form.FCategoria))>
					and c.ACcodigo = #form.FCategoria#
				</cfif>		
				<cfif isdefined('form.FClase') and len(trim(form.FClase))>
					and e.ACid = #form.FClase#
				</cfif>	
				<cfif isdefined('form.FCentroF') and len(trim(form.FCentroF))>
					and a.CFid = #form.FCentroF#
				</cfif>									
				
			order by CentroF, Categoria, Clase, Aplaca
		</cfoutput>
	</cfsavecontent>

	<cftry>
		<cfflush interval="16000">
		<cf_jdbcquery_open name="data" datasource="#session.DSN#">
			<cfoutput>#rsRevaluacion#</cfoutput>
		</cf_jdbcquery_open>
		<cf_exportQueryToFile query="#data#" filename="Revaluacion_#session.Usucodigo##LSDateFormat(Now(),'ddmmyyyy')##LSTimeFormat(Now(),'hh:mm:ss')#.xls" jdbc="true">
		<cfcatch type="any">
			<cf_jdbcquery_close>
			<cfrethrow>
		</cfcatch>
	</cftry>
	<cf_jdbcquery_close>
</cfif>
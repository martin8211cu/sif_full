<!--- cuando viene descargar aquí mismo se hace la descarga, está abajo --->
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfif not isdefined('form.btnDescargar')>
	<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cfsavecontent variable="pNavegacion">
		<cfinclude template="/home/menu/pNavegacion.cfm">
	</cfsavecontent>
	<cfif isdefined("Url.btnFiltrar") and not isdefined("Form.btnFiltrar")>
		<cfparam name="Form.btnFiltrar" default="#Url.btnFiltrar#">
	</cfif>
	<cfif isdefined("url.AGTPid") and not isdefined("form.AGTPid")>
		<cfset form.AGTPid = url.AGTPid>
	</cfif>					
	<cfif isdefined("url.FAplaca") and not isdefined("form.FAplaca")>
		<cfset form.FAplaca = url.FAplaca>
	</cfif>
	<cfif isdefined("url.FCategoria") and not isdefined("form.FCategoria")>
		<cfset form.FCategoria = url.FCategoria>
	</cfif>
	<cfif isdefined("url.FClase") and not isdefined("form.FClase")>
		<cfset form.FClase = url.FClase>
	</cfif>															
	<cfif isdefined("url.FCentroF") and not isdefined("form.FCentroF")>
		<cfset form.FCentroF = url.FCentroF>
	</cfif>
	<cfif not isdefined("form.AGTPid") or  (isdefined('url.AGTPid') and len(trim(url.AGTPid)) eq  0)>
		
		<cf_templateheader title="#nav__SPdescripcion#">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<cfoutput>#pNavegacion#</cfoutput>
			<cf_web_portlet_start titulo="#nav__SPdescripcion#">
					<!--- si se viene por aquí pinta lista de encabezados --->
					<!--- Pasa variables del url al form --->
					<!--- Prepara filtro de lista de encabezados --->
					
					<cfset filtro = "">
					<cfset navegacion = "">	
					<cfif isdefined("Form.btnFiltrar") and Len(Trim(Form.btnFiltrar)) NEQ 0>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "btnFiltrar=" & Form.btnFiltrar>
					</cfif>
					<cfinclude template="agtProceso_filtroGrupos.cfm">
					<cfif isdefined("Form.btnFiltrar") and Len(Trim(Form.btnFiltrar)) NEQ 0>
						<cfinclude template="repDepreciacion-lista.cfm">
					</cfif>
				</table> 
			<cf_web_portlet_end>
		<cf_templatefooter>
	<cfelse>
		<!--- si se viene por aquí pinta reporte --->
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
				<cfif isdefined("form.AGTPid") and Len(Trim(form.AGTPid))>
					<cfset param = param & "&AGTPid=#form.AGTPid#">
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "AGTPid=" & Form.AGTPid>
				</cfif>
				<cfif isdefined("form.FAplaca") and Len(Trim(form.FAplaca))>
					<cfset param = param & "&FAplaca=#form.FAplaca#">
				</cfif>
				<cfif isdefined("form.FCategoria") and Len(Trim(form.FCategoria))>
					<cfset param = param & "&FCategoria=#form.FCategoria#">
				</cfif>
				<cfif isdefined("form.FClase") and Len(Trim(form.FClase))>
					<cfset param = param & "&FClase=#form.FClase#">
				</cfif>
				<cfif isdefined("form.FCentroF") and Len(Trim(form.FCentroF))>
					<cfset param = param & "&FCentroF=#form.FCentroF#">
				</cfif>
				<cfinclude template="repDepreciacion-form.cfm">
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
	<cfquery name="rsAGTPestado" datasource="#session.dsn#">
		select AGTPestadp from AGTProceso where AGTPid = #AGTPid#
	</cfquery>
	
	<cfquery name="rsTADTProceso" datasource="#session.dsn#">
		select distinct p.CFid, 
						cf.CFcodigo, 
						coalesce(cf.CFcuentaaf, cf.CFcuentac) as FormatoCta, 
						c.ACcodigo, 
						c.ACid, 
						ACgastodep, 
						ACgastorev, 
						c.ACcodigodesc as Clase, 
						ct.ACcodigodesc as Categoria
		from ADTProceso p
			inner join AFSaldos s
					inner join Activos a
					 on a.Aid     = s.Aid
					and a.Ecodigo = s.Ecodigo
					inner join AClasificacion c
						 on c.ACcodigo = s.ACcodigo
						and c.ACid     = s.ACid
						and c.Ecodigo  = s.Ecodigo

						inner join ACategoria ct
						  on ct.Ecodigo  = c.Ecodigo
						 and ct.ACcodigo = c.ACcodigo

					inner join CFuncional cf
						 on cf.CFid = s.CFid

			 on s.Aid        = p.Aid
			and s.AFSperiodo = p.TAperiodo
			and s.AFSmes     = p.TAmes
			and s.Ecodigo    = p.Ecodigo
		where p.AGTPid = #AGTPid#
		  and p.Cta_Gasto is null
	</cfquery>

	<!--- Procesar los distintos codigos de categoria --->
	<cfquery name="rsADTProceso" dbtype="query">
		select distinct CFid, CFcodigo, FormatoCta, ACgastodep, ACgastorev
		from rsTADTProceso
	</cfquery>
	
	<cfloop query="rsADTProceso">
	
		<cfset lVarCFid = #rsADTProceso.CFid#>
		<cfset lVarACgastodep = #rsADTProceso.ACgastodep#>

		<cfinvoke component="sif.Componentes.AF_ContabilizarDepreciacion" method="AplicarMascara" returnvariable="lVarCuentaDep">
			<cfinvokeargument name="cuenta" value="#rsADTProceso.FormatoCta#"/>							
			<cfinvokeargument name="objgasto" value="#rsADTProceso.ACgastodep#"/>
		</cfinvoke>

		<cfif lVarCuentaDep eq ""><cfset lVarCuentaDep = ""></cfif>

		<cfquery datasource="#session.dsn#">
			Update ADTProceso
			set Cta_Gasto = '#lVarCuentaDep#'
			where ADTProceso.AGTPid = #AGTPid#
			  and ADTProceso.CFid = #lVarCFid#
			  and ADTProceso.Cta_Gasto is null
			  and exists(select 1 
						 from Activos a, AClasificacion c 
						 where a.Aid = ADTProceso.Aid
						   and c.ACcodigo = a.ACcodigo
						   and c.ACid     = a.ACid
						   and c.Ecodigo  = a.Ecodigo
						   and c.ACgastodep = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarACgastodep#">)
		</cfquery>
		
	</cfloop>
				
	<cfquery name="data" datasource="#session.dsn#">
		select 
			(select cf.CFcodigo 	  #_Cat# ' - ' #_Cat# cf.CFdescripcion from CFuncional cf where cf.CFid = ta.CFid) as CFuncional,	
			(select cat.ACcodigodesc  #_Cat# ' - ' #_Cat# cat.ACdescripcion from ACategoria cat where cat.Ecodigo = s.Ecodigo and cat.ACcodigo = s.ACcodigo) as Categoria,
			(select clas.ACcodigodesc #_Cat# ' - ' #_Cat# clas.ACdescripcion from AClasificacion clas where clas.Ecodigo = s.Ecodigo and clas.ACcodigo = s.ACcodigo and clas.ACid = s.ACid) as Clase,
			(select ofi.Oficodigo 	  #_Cat# ' - ' #_Cat# ofi.Odescripcion from CFuncional cf inner join Oficinas ofi on ofi.Ecodigo = cf.Ecodigo and ofi.Ocodigo = cf.Ocodigo where cf.CFid = ta.CFid) as Oficina,	
			(select dto.Deptocodigo   #_Cat#' - '  #_Cat# dto.Ddescripcion from CFuncional cf inner join Departamentos dto on dto.Ecodigo = cf.Ecodigo and dto.Dcodigo = cf.Dcodigo where cf.CFid = ta.CFid) as Departamento,
			ta.TAperiodo as Periodo, 
			ta.TAmes as Mes,
			act.Aplaca as Placa, 
			act.Adescripcion as Activo, 
			act.Aserie as Serie,
			ta.TAvaladq as Adquisicion, 
			ta.TAvalmej as Mejoras, 
			ta.TAvalrev as Revaluacion, 
			ta.TAdepacumadq as DepAcumAdquisicionAnterior, 
			ta.TAdepacummej as DepAcumMejorasAnterior, 
			ta.TAdepacumrev as DepAcumRevaluacionAnterior, 
			ta.TAvaladq + ta.TAvalmej + ta.TAvalrev -
			ta.TAdepacumadq - ta.TAdepacummej - ta.TAdepacumrev as ValorLibrosAnterior,
			ta.TAmontolocadq as DepreciacionAdquisicion, 
			ta.TAmontolocmej as DepreciacionMejoras, 
			ta.TAmontolocrev as DepreciacionRevaluacion, 
			ta.TAvaladq + ta.TAvalmej + ta.TAvalrev -
			ta.TAdepacumadq - ta.TAdepacummej - ta.TAdepacumrev -
			ta.TAmontolocadq - ta.TAmontolocmej - ta.TAmontolocrev as ValorLibrosDespues,
			ta.TAmeses as Meses,
			<cfif rsAGTPestado.AGTPestadp eq 4>
		
				coalesce((select cc.Cformato
				 from CContables cc
				 where cc.Ccuenta = ta.Ccuenta
				   and cc.Ecodigo = ta.Ecodigo),'') as Cta_Gasto,
								
			<cfelse>	
				ta.Cta_Gasto as Cta_Gasto,				
			</cfif>
			coalesce((select ccda.Cformato
			 from CContables ccda
			 where ccda.Ccuenta = cla.ACcdepacum
			   and ccda.Ecodigo = cla.Ecodigo),'') as Cta_DepAdquisicion,
								   
			coalesce((select ccdr.Cformato
			 from CContables ccdr
			 where ccdr.Ccuenta = cla.ACcdepacumrev
			   and ccdr.Ecodigo = cla.Ecodigo),'') as Cta_DepRevaluacion
							
		<cfif rsAGTPestado.AGTPestadp eq 4>
		from TransaccionesActivos ta
				inner join AFSaldos s
					inner join Activos act
					 on act.Aid     = s.Aid
					and act.Ecodigo = s.Ecodigo

					inner join AClasificacion cla
						inner join ACategoria ct
						  on ct.Ecodigo  = cla.Ecodigo
						 and ct.ACcodigo = cla.ACcodigo

					 on cla.ACcodigo = s.ACcodigo
					and cla.ACid     = s.ACid
					and cla.Ecodigo  = s.Ecodigo

					inner join CFuncional cf
						 on cf.CFid = s.CFid

			 on s.Aid        = ta.Aid
			and s.AFSperiodo = ta.TAperiodo
			and s.AFSmes     = ta.TAmes
			and s.Ecodigo    = ta.Ecodigo

		<cfelse>
		from ADTProceso ta
			inner join Activos act
					inner join Activos s
					on s.Aid = act.Aid

					inner join AClasificacion cla
					on cla.Ecodigo = act.Ecodigo
					and cla.ACid = act.ACid
					and cla.ACcodigo = act.ACcodigo
			on act.Aid = ta.Aid

			inner join CFuncional cf
				 on cf.CFid = ta.CFid
				and cf.Ecodigo = ta.Ecodigo
		 </cfif>
		where ta.AGTPid = #AGTPid#
		order by 1,2,3,8,9	
	</cfquery>
	<cfflush interval="1024">
	<cf_exportQueryToFile query="#data#" filename="Depreciacion_#session.Usucodigo##LSDateFormat(Now(),'ddmmyyyy')##LSTimeFormat(Now(),'hh:mm:ss')#.xls" jdbc="false">
</cfif>
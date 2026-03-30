<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PuestoRHSolicitado"
	Default="Puesto Solicitado"
	returnvariable="LB_PuestoRHSolicitado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CentroFuncional"
	Default="CentroFuncional"
	returnvariable="LB_CentroFuncional"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaDesde"
	Default="Fecha desde"
	returnvariable="LB_FechaDesde"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CantidadSolicitada"
	Default="Cantidad Solicitada"
	returnvariable="LB_CantidadSolicitada"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Todos"
	Default="Todos"
	returnvariable="LB_Todos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Consecutivo"
	Default="N°.Solicitud"
	returnvariable="LB_Consecutivo"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<!--- Validadcion de que el usuario actual sea el responsable del (los) centros funcionales --->
<cfquery name="empleado" datasource="#session.DSN#">
	select coalesce(llave, '0') as DEid 
	from UsuarioReferencia
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	  and STabla = 'DatosEmpleado'
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
</cfquery>
<cfset vDEid = IIF( len(empleado.DEid) is 0, DE(0), DE(empleado.DEid) ) >

<cfset continuar = false >
<cfquery name="mi_plaza" datasource="#session.DSN#">
	select RHPid 
	from LineaTiempo 
	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vDEid#">
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between LTdesde and LThasta
</cfquery>
<cfquery name="rsVal" datasource="#session.dsn#">
	select min(CFid) as CFid
		from CFautoriza
	where Ecodigo=#session.Ecodigo#
	and Usucodigo=#session.Usucodigo#
</cfquery>

<cfquery name="rsResponsableCF" datasource="#session.DSN#">
	select min(CFid) as CFid
	from CFuncional
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and CFuresponsable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
</cfquery>


<cfif len(trim(rsResponsableCF.CFid)) and rsResponsableCF.CFid gt 0 >
	<cfset continuar = true >
</cfif>	
<cfif len(trim(rsVal.CFid)) and rsVal.CFid gt 0 >
	<cfset continuar = true >
</cfif>	
	
		
<cfif len(trim(mi_plaza.RHPid)) gt 0>
	<cfquery name="validarme" datasource="#session.DSN#" >
		select coalesce(CFid, 0) as CFid 
		from CFuncional 
		where RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#mi_plaza.RHPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif len(trim(validarme.CFid)) and validarme.CFid gt 0 >
		<cfset continuar = true >
	</cfif>	

</cfif>

<cfif not continuar >
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_UstedNoHaSidoAsignadoComoResponsableDeCentroFuncional"
		Default="Usted no puede hacer solicitudes de Plazas, pues no ha sido asignado como responsable de Centro Funcional"
		returnvariable="MSG_UstedNoHaSidoAsignadoComoResponsableDeCentroFuncional"/>
	<!---<cfthrow message="#MSG_UstedNoHaSidoAsignadoComoResponsableDeCentroFuncional#.">--->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Regresar"
		Default="Regresar"
		xmlfile="/rh/generales.xml"
		returnvariable="BTN_Regresar"/>

	<table width="50%" align="center" cellpadding="5" cellspacing="1" >
		<cfoutput>
		<tr><td align="center">#MSG_UstedNoHaSidoAsignadoComoResponsableDeCentroFuncional#</td></tr>
		<tr><td align="center">
			<input type="button" name="btnRegresar" class="btnAnterior" value="#BTN_Regresar#" onclick="javascript:location.href='/cfmx/rh/autogestion/plantilla/menu.cfm'" />
		</td></tr>
		</cfoutput>
	</table>

<cfelse>
	<cfif isdefined ('validarme')>
	<cfset permitidos = valuelist(validarme.CFid)  >
	<cfelseif isdefined ('rsVal')>
	<cfset permitidos = valuelist(rsVal.CFid)  >
	</cfif>
	<cfif len(trim(permitidos)) is 0>
		<cfset permitidos = 0 >
	</cfif>
	
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td>
			<!--- LISTA DE CENTROS FUNCIONALES --->
			<cfquery name="rsCF" datasource="#session.dsn#">
				select -1 as value, '-- todos --' as description
				union
				Select cf.CFid as value,cf.CFdescripcion as description
				from CFuncional cf
				where cf.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and cf.CFid in (
								Select distinct sp.CFid
								from RHSolicitudPlaza sp
								where sp.Ecodigo=cf.Ecodigo
									and sp.RHSPestado = 0
							)
				order by description
			</cfquery>
		
		
			<!---  LISTA DE PUESTOS  --->
			<cfquery name="valPlan" datasource="#session.dsn#">
				select Pvalor from RHParametros where Pcodigo=540
			</cfquery>
			<cfif valPlan.Pvalor eq 1>
			
				<cfquery name="rsPuesto" datasource="#session.dsn#">
					select  -1 as value,'-- todos --' as description
					union
					select pp.RHMPPid as value,			
						   pp.RHMPPdescripcion as description
					from RHMaestroPuestoP pp
					where pp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
					and pp.RHMPPid in (Select sp.RHMPPid
										from RHSolicitudPlaza sp
										where sp.Ecodigo=pp.Ecodigo
										and sp.RHSPestado = 0
										)
						order by description
				</cfquery>
				
				<cfset tabla='RHSolicitudPlaza sp
					inner join CFuncional cf
						on cf.Ecodigo=sp.Ecodigo
							and cf.CFid=sp.CFid
							--and cf.CFid in (#permitidos#)
					left outer join RHMaestroPuestoP mp
						on mp.RHMPPid=sp.RHMPPid
							and mp.Ecodigo=sp.Ecodigo'>
				<cfset columnas=',RHMPPdescripcion as descrip'>
				<cfset filtro='mp.RHMPPid,sp.CFid,RHSPfdesde,'','''>
								
			<cfelse>
				<cfquery name="valTab" datasource="#session.dsn#">
					select count(1) as cantidad from ComponentesSalariales where CSsalariobase=1 and CSusatabla=1
					and Ecodigo=#session.Ecodigo#
				</cfquery>	
													
				<cfif valtab.cantidad eq 0>
				<!---Van los puestos de RH es decir no usa planilla ni tabla en componentes salariales--->		
					<cfquery name="rsPuesto" datasource="#session.dsn#">
						select  '-1' as value,'-- todos --' as description
						union
						Select mp.RHPcodigo as value,RHPdescpuesto as description
						from RHPuestos mp
						where mp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and mp.RHPcodigo in (
												Select sp.RHPcodigo
												from RHSolicitudPlaza sp
												where sp.Ecodigo=mp.Ecodigo
													and sp.RHSPestado = 0
											)
						order by description
					</cfquery>
					
					<cfset tabla='RHSolicitudPlaza sp
						inner join CFuncional cf
							on cf.Ecodigo=sp.Ecodigo
								and cf.CFid=sp.CFid
								--and cf.CFid in (#permitidos#)
						left outer join RHPuestos mp
							on mp.	RHPcodigo=sp.RHPcodigo
								and mp.Ecodigo=sp.Ecodigo'>
					<cfset columnas=',sp.RHPcodigo as value,RHPdescpuesto as descrip'>
					<cfset filtro='mp.RHMPPid,sp.CFid,RHSPfdesde,'','''>		
				<cfelse>
				<!---Van los puestos de planilla usa tabla en componentes salariales--->
					<cfquery name="rsPuesto" datasource="#session.dsn#">
						select  -1 as value,'-- todos --' as description
						union
						select pp.RHMPPid as value,			
							   pp.RHMPPdescripcion as description
						from RHMaestroPuestoP pp
						where pp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
						and pp.RHMPPid in (Select sp.RHMPPid
											from RHSolicitudPlaza sp
											where sp.Ecodigo=pp.Ecodigo
											and sp.RHSPestado = 0
											)
							order by description
					</cfquery>
					<cfset tabla='RHSolicitudPlaza sp
						inner join CFuncional cf
							on cf.Ecodigo=sp.Ecodigo
								and cf.CFid=sp.CFid
								--and cf.CFid in (#permitidos#)
						left outer join RHMaestroPuestoP mp
							on mp.RHMPPid=sp.RHMPPid
								and mp.Ecodigo=sp.Ecodigo'>
					<cfset columnas=',RHMPPdescripcion as descrip'>
					<cfset filtro='mp.RHMPPid,sp.CFid,RHSPfdesde,'','''>						
			</cfif>
			</cfif>
		
			<cfinvoke 
				component="rh.Componentes.pListas" 
				method="pListaRH"
				returnvariable="rsLista"
				columnas="
					'aut' as  modulo, 
					'' as colFan
					, RHSPid
					, sp.CFid
					, RHSPcantidad
					, RHSPfdesde
					, CFdescripcion
					, RHSPconsecutivo
					#columnas#"
				desplegar="descrip, CFdescripcion, RHSPfdesde, RHSPcantidad, colFan"
				etiquetas="#LB_PuestoRHSolicitado#, #LB_CentroFuncional#, #LB_FechaDesde#, #LB_CantidadSolicitada#, "
				tabla="#tabla#"
				filtro="sp.Ecodigo=#Session.Ecodigo# 
						and sp.BMUsucodigo=#session.Usucodigo# 
						and sp.RHSPestado = 0 order by RHSPfdesde desc"
				mostrar_filtro="true"
				filtrar_automatico="true"
				filtrar_por="#filtro#"
				rscfdescripcion="#rsCF#"
				rsdescrip="#rsPuesto#"						
				align="left,left,left,right,left"
				botones="Nuevo,Aplicar"
				debug="N"
				formatos="S,I,D,U,U"
				ira="solicitudPlazasAUT.cfm"
				showemptylistmsg="true"
				checkboxes="S"
				keys="RHSPid"
			/>		
		</td>
	  </tr>
	</table>
	<!--- Variables de la Traduccion --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_DeseaAplicarLosRegistrosSeleccionados"
		Default="Desea aplicar los registros seleccionados?"
		returnvariable="MSG_DeseaAplicarLosRegistrosSeleccionados"/>
	<script language="javascript1.2" type="text/javascript">
		function funcAplicar(){
			if ( confirm('<cfoutput>#MSG_DeseaAplicarLosRegistrosSeleccionados#</cfoutput>') )  {
				document.lista.MODULO.value = "aut";
				document.lista.action = 'solicitudPlazas-sql.cfm';
				return true
			}
			return false;
		}
	</script>
</cfif>
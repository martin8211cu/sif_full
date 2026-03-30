	<cfinvoke component="sif.Componentes.Translate" method="Translate"
		Default="todos"	Key="LB_Todos" XmlFile="/rh/generales.xml" returnvariable="LB_Todos"/>
	<cfinvoke component="sif.Componentes.Translate" method="Translate"
		Default="En Proceso"	Key="LB_En_Proceso" XmlFile="/rh/generales.xml" returnvariable="LB_En_Proceso"/>
	<cfinvoke component="sif.Componentes.Translate" method="Translate"
		Default="Rechazadas"	Key="LB_Rechazadas" XmlFile="/rh/generales.xml" returnvariable="LB_Rechazadas"/>
		
	<cfinvoke component="sif.Componentes.Translate" method="Translate"
		Default="Esta seguro que desea rechazar los registros seleccionados"	
		Key="LB_Esta_seguro_que_desea_rechazar_los_registros_seleccionados" 
		returnvariable="LB_Esta_seguro_que_desea_rechazar_los_registros_seleccionados">
	<cfinvoke component="sif.Componentes.Translate" method="Translate"
		Default="Desea aplicar los registros seleccionados"	
		Key="LB_Desea_aplicar_los_registros_seleccionados" 
		returnvariable="LB_Desea_aplicar_los_registros_seleccionados">
		
	<cfinvoke component="sif.Componentes.Translate" method="Translate"
		Default="NSol."	Key="LB_NSol" returnvariable="LB_NSol">
	<cfinvoke component="sif.Componentes.Translate" method="Translate"
		Default="Puesto"	Key="LB_Puesto" returnvariable="LB_Puesto">
	<cfinvoke component="sif.Componentes.Translate" method="Translate"
		Default="Centro Funcional"	Key="LB_Centro_Funcional" returnvariable="LB_Centro_Funcional">
	<cfinvoke component="sif.Componentes.Translate" method="Translate"
		Default="Solicitado por"	Key="LB_Solicitado_Por" returnvariable="LB_Solicitado_Por">
	<cfinvoke component="sif.Componentes.Translate" method="Translate"
		Default="Estado"	Key="LB_Estado" returnvariable="LB_Estado">
	<cfinvoke component="sif.Componentes.Translate" method="Translate"
		Default="Fecha desde"	Key="LB_Fecha_desde" returnvariable="LB_Fecha_desde">
	<cfinvoke component="sif.Componentes.Translate" method="Translate"
		Default="Cantidad Solicitada"	Key="LB_Cantidad_Solicitada" returnvariable="LB_Cantidad_Solicitada">
		
	<cfinvoke component="sif.Componentes.Translate" method="Translate"
		Default="Nuevo"	Key="BTN_NUEVO" returnvariable="BTN_NUEVO">
	<cfinvoke component="sif.Componentes.Translate" method="Translate"
		Default="Aplicar"	Key="BTN_Aplicar" returnvariable="BTN_Aplicar">
	<cfinvoke component="sif.Componentes.Translate" method="Translate"
		Default="Rechazar"	Key="BTN_Rechazar" returnvariable="BTN_Rechazar">
		
				
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td>
		<cf_translatedata name="get" tabla="CFuncional" col="CFdescripcion" returnvariable="LvarCFdescripcion">
		<cfquery name="rsCFuncional" datasource="#session.dsn#">
			select -1 as value, '-- #LB_Todos# --' as description from dual
			union
			Select cf.CFid as value,#LvarCFdescripcion# as description
			from CFuncional cf
			where cf.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and cf.CFid in (
							Select sp.CFid
							from RHSolicitudPlaza sp
							where sp.Ecodigo=cf.Ecodigo
								and sp.RHSPestado in (20)
						)
			order by description
		</cfquery>
		
		<cfquery name="rsEstado" datasource="#session.dsn#">
			select 20 as value, '-- #LB_En_Proceso# --' as description from dual
			union
			select 30 as value, '--#LB_Rechazadas#--' as description from dual
		</cfquery>
		<cf_translatedata name="get" tabla="RHMaestroPuestoP" col="RHMPPdescripcion" returnvariable="LvarRHMPPdescripcion">
		<cf_translatedata name="get" tabla="RHPuestos" 		  col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">

		<cfset varArray = listToArray("RHSPconsecutivo~coalesce(#LvarRHMPPdescripcion#,#LvarRHPdescpuesto#)~sp.CFid~(dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2)~RHSPestado~RHSPfdesde~''~''","~")>

<cfset LvarEstado='and RHSPestado in (20)'>
<cfif isdefined ('filtro_RHSPestado') and filtro_RHSPestado eq 10>
	<cfset LvarEstado='and RHSPestado in (20)'>
<cfelseif isdefined ('filtro_RHSPestado') and filtro_RHSPestado eq 30>
	<cfset LvarEstado='and RHSPestado in (30)'>
</cfif>
	<cf_translatedata name="get" tabla="RHMaestroPuestoP" col="RHMPPdescripcion" returnvariable="LvarRHMPPdescripcion">
	<cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
	<cf_translatedata name="get" tabla="CFuncional" col="CFdescripcion" returnvariable="LvarCFdescripcion">

		<cfinvoke 
			component="rh.Componentes.pListas" 
			method="pListaRH"
			returnvariable="rsLista"
			columnas="
				'' as colFan,
				'pp' as  modulo 
				, (dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2) as nombreSol		
				, RHSPid
				, sp.CFid
				, sp.RHSPcantidad
				, mp.RHMPPcodigo
				, coalesce(#LvarRHMPPdescripcion#,#LvarRHPdescpuesto#) as Puesto
				, sp.RHPcodigo
				, coalesce(#LvarRHPdescpuesto#,' -- ') as RHPdescpuesto
				, RHSPfdesde
				,sp.RHSPconsecutivo
				,#LvarCFdescripcion# as CFdescripcion
				,case RHSPestado
				when  20 then '#LB_En_proceso#'
				when  30 then '#LB_Rechazadas#'
				end as RHSPestado
				"
			desplegar="RHSPconsecutivo,Puesto, CFdescripcion, nombreSol,RHSPestado ,RHSPfdesde, RHSPcantidad,colFan"
			etiquetas="#LB_NSol#,#LB_Puesto#,#LB_Centro_Funcional#,#LB_Solicitado_Por#, #LB_Estado#,#LB_Fecha_desde#,#LB_Cantidad_Solicitada#, "
			tabla="RHSolicitudPlaza sp
					inner join CFuncional cf
						on cf.Ecodigo=sp.Ecodigo
							and cf.CFid=sp.CFid
							
					inner join Usuario u
						on u.Usucodigo=sp.BMUsucodigo
			
					left outer join DatosPersonales dp
						on dp.datos_personales=u.datos_personales								
							
					left outer join RHMaestroPuestoP mp
						on mp.RHMPPid=sp.RHMPPid
							and mp.Ecodigo=sp.Ecodigo
				
					left outer join RHPuestos p
						on p.RHPcodigo=sp.RHPcodigo
							and p.Ecodigo=sp.Ecodigo"
			filtro="sp.Ecodigo=#Session.Ecodigo# and sp.BMUsucodigo=#session.Usucodigo# #LvarEstado#
						order by RHSPfdesde desc,coalesce(RHMPPcodigo,sp.RHPcodigo),coalesce(RHMPPdescripcion,RHPdescpuesto)"			
			mostrar_filtro="true"
			Cortes="CFdescripcion"
			filtrar_automatico="true"
			filtrar_por_array="#varArray#"
			rscfdescripcion="#rsCFuncional#"
			rsRHSPestado="#rsEstado#"
			align="left,left,left,left,left,left,right,left"
			botones="#BTN_Aplicar#,#BTN_Rechazar#"
			formatos="I,S,I,S,S,D,U,U"
			ira="solicitudplaza.cfm"
			debug="N"
			ajustar="S"
			checkboxes="S"
			keys="RHSPid"
		/>			
	</td>
  </tr>
</table>
<script language="javascript1.2" type="text/javascript">
	function funcAplicar(){
		if ( confirm('<cfoutput>#LB_Desea_aplicar_los_registros_seleccionados#</cfoutput>?') )  {
			document.lista.MODULO.value = "rs";
			document.lista.action = 'solicitudPlazas-sql.cfm';
			return true
		}
		return false;
	}
	function funcRechazar(){
		if ( confirm('<cfoutput>#LB_Esta_seguro_que_desea_rechazar_los_registros_seleccionados#</cfoutput>?') )  {
			document.lista.MODULO.value = "rs";
			document.lista.action = 'solicitudPlazas-sql.cfm';
			return true
		}
		return false;
	}
</script>

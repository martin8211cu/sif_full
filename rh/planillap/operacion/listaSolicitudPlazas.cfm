<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td>
		<cfquery name="rsCFuncional" datasource="#session.dsn#">
			select -1 as value, '-- todos --' as description
			union
			Select cf.CFid as value,cf.CFdescripcion as description
			from CFuncional cf
			where cf.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and cf.CFid in (
							Select sp.CFid
							from RHSolicitudPlaza sp
							where sp.Ecodigo=cf.Ecodigo
								and sp.RHSPestado in (10)
						)
			order by description
		</cfquery>
		
		<cfquery name="rsEstado" datasource="#session.dsn#">
			select 10 as value, '-- En Proceso --' as description
			union
			select 30 as value, '--Rechazadas--' as description
		</cfquery>

		<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
		<cfset varArray = listToArray("RHSPconsecutivo~coalesce(RHMPPdescripcion,RHPdescpuesto)~sp.CFid~(dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2)~RHSPestado~RHSPfdesde~''~''","~")>

<cfset LvarEstado='and RHSPestado in (10)'>
<cfif isdefined ('filtro_RHSPestado') and filtro_RHSPestado eq 10>
	<cfset LvarEstado='and RHSPestado in (10)'>
<cfelseif isdefined ('filtro_RHSPestado') and filtro_RHSPestado eq 30>
	<cfset LvarEstado='and RHSPestado in (30)'>
</cfif>
		<cf_dbfunction name="concat" args="dp.Pnombre,' ',dp.Papellido1,' ',dp.Papellido2" returnvariable="Lvar_Nombre">
		<cfinvoke 
			component="rh.Componentes.pListas" 
			method="pListaRH"
			returnvariable="rsLista"
			columnas="
				'' as colFan,
				'pp' as  modulo 
				, #Lvar_Nombre# as nombreSol		
				, RHSPid
				, sp.CFid
				, sp.RHSPcantidad
				, mp.RHMPPcodigo
				, coalesce(RHMPPdescripcion,RHPdescpuesto) as Puesto
				, sp.RHPcodigo
				, coalesce(RHPdescpuesto,' -- ') as RHPdescpuesto
				, RHSPfdesde
				,sp.RHSPconsecutivo
				, CFdescripcion
				,case RHSPestado
				when  10 then 'En Proceso'
				when  30 then 'Rechazada'
				end as RHSPestado
				"
			desplegar="RHSPconsecutivo,Puesto, CFdescripcion, nombreSol,RHSPestado ,RHSPfdesde, RHSPcantidad,colFan"
			etiquetas="N°Sol.,Puesto, Centro Funcional, Solicitado Por, Estado,Fecha desde, Cantidad Solicitada, "
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
						order by RHSPconsecutivo,RHSPfdesde desc,coalesce(RHMPPcodigo,sp.RHPcodigo),coalesce(RHMPPdescripcion,RHPdescpuesto)"			
			mostrar_filtro="true"
			Cortes="CFdescripcion"
			filtrar_automatico="true"
			filtrar_por_array="#varArray#"
			rscfdescripcion="#rsCFuncional#"
			rsRHSPestado="#rsEstado#"
			align="left,left,left,left,left,left,right,left"
			botones="Nuevo,Aplicar,Rechazar"
			formatos="S,S,I,S,S,D,U,U"
			ira="solicitudPlazas.cfm"
			debug="N"
			checkboxes="S"
			keys="RHSPid"
		/>			
	</td>
  </tr>
</table>

<script language="javascript1.2" type="text/javascript">
	function funcAplicar(){
		if ( confirm('Desea aplicar los registros seleccionados?') )  {
			document.lista.MODULO.value = "pp";
			document.lista.action = 'solicitudPlazas-sql.cfm';
			return true
		}
		return false;
	}
	function funcRechazar(){
		if ( confirm('Esta seguro que desea rechazar los registros seleccionados?') )  {
			document.lista.MODULO.value = "pp";
			document.lista.action = 'solicitudPlazas-sql.cfm';
			return true
		}
		return false;
	}
</script>


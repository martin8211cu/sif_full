	<cfset rsFPCCconcepto = QueryNew("ID","VarChar")>
	<cfset QueryAddRow(rsFPCCconcepto, 10)>
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "1", 1)> <!---Otros--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "2", 2)> <!---Concepto Salarial--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "3", 3)> <!---Amortización de prestamos--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "4", 4)> <!---Financiamiento--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "5", 5)> <!---Patrimonio--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "6", 6)> <!---Ventas--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "F", 7)> <!---Activos--->
	<cfset ListFPCCconcepto = left(ValueList(rsFPCCconcepto.ID), LEN(ValueList(rsFPCCconcepto.ID))-3)> 
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "S", 8)> <!---Servicio--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "A", 9)> <!---Articulos de Inventario--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "P", 10)><!---Obras en Proceso--->
	<cfset ListFPCCconceptoALL = ValueList(rsFPCCconcepto.ID)> 

	<cfif NOT ISDEFINED('form.FPAEid') AND ISDEFINED('URL.FPAEid')>
        <CFSET form.FPAEid = url.FPAEid>
    </cfif>
    <cfif NOT ISDEFINED('form.FPAEid')>
    	<cfthrow message="No se especifico la Actividad empresarial del grupo de líneas de estimación.">
    <cfelse>
    	<cfquery name="rsCatFin" datasource="#session.dsn#">
            select act.PCEcatid, act.FPADNivel, FPADPosicion, FPADLogitud
                from  FPActividadD act
                	inner join PCECatalogo cat
                    	on cat.PCEcatid = act.PCEcatid
            where act.FPAEid  = #form.FPAEid#
              and act.PCEcatid is not null
              and act.FPADDepende = 'C'
              and act.FPADEquilibrio = 1
        </cfquery>
        <cfif rsCatFin.Recordcount EQ 0>
        	<cfthrow message="La actividad empresarial no tienen definido un catalogo valido como fuente de financiamiento.">
        <cfelseif rsCatFin.Recordcount GT 1>
        	<cfthrow message="La actividad empresarial tienen definido más un catalogo como fuente de financiamiento. No implementado.">
        </cfif>
    </cfif>

<cfif isdefined('Cambiar') and isdefined("form.chk")>
	<cfif not isdefined('form.PCDvalor')>
    	<cfthrow message="No se especifico el valor de la nueva Fuente de Financiamiento.">
    </cfif>
	<cfloop list="#form.chk#" index="item">
		<cftransaction>
		
				<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="GetDetalleEstimacion" returnvariable="DEstimacion">
					<cfinvokeargument name="FPEEid"				value="#ListGetAt(item,1,'|')#">
					<cfinvokeargument name="FPEPid" 	    	value="#ListGetAt(item,2,'|')#">
					<cfinvokeargument name="FPDElinea" 	     	value="#ListGetAt(item,3,'|')#">
				</cfinvoke>
			<cftry>
				<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="CambioDetalleEstimacion">
                        <cfinvokeargument name="Conexion"				value="#session.dsn#">
                        <cfinvokeargument name="Ecodigo"				value="#session.Ecodigo#">
                        <cfinvokeargument name="BMUsucodigo"			value="#session.Usucodigo#">
                    <cfif LEN(TRIM(DEstimacion.DPDEfechaIni))>
                       <cfinvokeargument name="DPDEfechaIni"			value="#DEstimacion.DPDEfechaIni#">
                    </cfif>
                   	<cfif LEN(TRIM(DEstimacion.DPDEfechaFin))>
                        <cfinvokeargument name="DPDEfechaFin"			value="#DEstimacion.DPDEfechaFin#">
                    </cfif>
                        <cfinvokeargument name="Dtipocambio"			value="#DEstimacion.Dtipocambio#">
                    <cfif LEN(TRIM(DEstimacion.Ucodigo))>
                        <cfinvokeargument name="Ucodigo"	value="#DEstimacion.Ucodigo#">
                     </cfif>
                        <cfinvokeargument name="FPEEid"					value="#DEstimacion.FPEEid#">
                        <cfinvokeargument name="FPEPid"					value="#DEstimacion.FPEPid#">
                        <cfinvokeargument name="FPDElinea"				value="#DEstimacion.FPDElinea#">
                        <cfinvokeargument name="DPDEdescripcion"		value="#DEstimacion.DPDEdescripcion#">
                        <cfinvokeargument name="DPDEjustificacion"		value="#DEstimacion.DPDEjustificacion#">
                        <cfinvokeargument name="DPDEcantidad"			value="#DEstimacion.DPDEcantidad#">
                        <cfinvokeargument name="Mcodigo"				value="#DEstimacion.Mcodigo#">
                        <cfinvokeargument name="DPDEcosto"				value="#DEstimacion.DPDEcosto#">
                        <cfinvokeargument name="FPAEid"					value="#DEstimacion.FPAEid#">
                        <cfinvokeargument name="CFComplemento"			value="#left(DEstimacion.CFComplemento,iif(rsCatFin.FPADPosicion GT 1, rsCatFin.FPADPosicion-1,rsCatFin.FPADPosicion))##form.PCDvalor##mid(DEstimacion.CFComplemento,rsCatFin.FPADPosicion+rsCatFin.FPADLogitud,len(DEstimacion.CFComplemento))#">
                        <cfinvokeargument name="DPDMontoTotalPeriodo"	value="#DEstimacion.DPDMontoTotalPeriodo#">
                        <cfinvokeargument name="DPDEcantidadPeriodo"	value="#DEstimacion.DPDEcantidadPeriodo#">
                        <cfinvokeargument name="OBOid"					value="#DEstimacion.OBOid#">
                        <cfinvokeargument name="DPDEcontratacion"		value="#DEstimacion.DPDEcontratacion#">
                        <cfinvokeargument name="DPDEmontoMinimo"		value="#DEstimacion.DPDEmontoMinimo#">
					<cfif DEstimacion.FPCCconcepto eq 'A'>
						<cfinvokeargument name="Aid" 	     		 	value="#DEstimacion.Aid#">
					<cfelseif ListFind('S,P',DEstimacion.FPCCconcepto)>
						<cfinvokeargument name="Cid" 	     			value="#DEstimacion.Cid#">
					<cfelseif ListFind(ListFPCCconcepto,DEstimacion.FPCCconcepto)>
						<cfinvokeargument name="FPCid" 	     			value="#DEstimacion.FPCid#">
					</cfif>
						<cfinvokeargument name="EQUILIBRIO" 	     	value="S">
				</cfinvoke>
				<cfcatch type="any">
				<cfthrow message="Se presentaron errores al modificar los datos." detail="#cfcatch.message#">
			</cfcatch>
			</cftry>
		</cftransaction>
	</cfloop>
	<script language="javascript1.2" type="text/javascript">
		window.opener.location.reload();
		window.close()
	</script>
</cfif>
<cf_navegacion name="CPPid">
<cf_navegacion name="PCDcatid">
<cf_navegacion name="CFid">
<cf_navegacion name="FPAEid">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfquery datasource="#session.dsn#" name="NivelEquilibrio">	
	select f.PCDvalor #_Cat#  ' - ' #_Cat# f.PCDdescripcion as descripcion
		from FPEEstimacion a
			inner join FPDEstimacion b
				on a.FPEEid = b.FPEEid
			inner join FPActividadD d
				on d.FPAEid = b.FPAEid
				and d.FPADEquilibrio = 1
			inner join PCECatalogo e
				on e.PCEcatid = d.PCEcatid
			inner join PCDCatalogo f
				on f.PCEcatid = e.PCEcatid
				and f.PCDvalor = <cf_dbfunction name="sPart" args="b.CFComplemento, d.FPADPosicion , d.FPADLogitud"> 
	where a.FPEEestado in (2, 3, 4)
	  and a.CPPid = #form.CPPid#
	  and f.PCDcatid = #form.PCDcatid#		
	group by f.PCDvalor, f.PCDdescripcion
</cfquery>
<cfquery datasource="#session.dsn#" name="CentroF">	
	select CFcodigo #_Cat# ' - ' #_Cat# CFdescripcion as descripcion from CFuncional where Ecodigo = #session.Ecodigo# and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
</cfquery>
<cfquery name="rsEstado" datasource="#session.DSN#">
	select 2 as estado from FPEEstimacion where CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#"> and FPEEestado != 7
</cfquery>
<cfif rsEstado.estado eq 2>
	<cfset editar=''>
<cfelse>
	<cfset editar=''>
</cfif>
<cf_dbfunction name="to_char"	args="h.FPAEid"       returnvariable="V_FPAEid">
<cf_dbfunction name="to_char"	args="b.FPEEid"       returnvariable="V_FPEEid">
<cf_dbfunction name="to_char"	args="b.FPEPid"       returnvariable="V_FPEPID">
<cf_dbfunction name="to_char"	args="b.FPDElinea"    returnvariable="V_FPDElinea">
<cf_dbfunction name="to_char"	args="tv.FPTVTipo"    returnvariable="V_FPTVTipo">
<cfquery datasource="#session.dsn#" name="Actividad">	
	select h.FPAECodigo #_Cat# ' - ' #_Cat# h.FPAEDescripcion as descripcion,'<img  src=''/cfmx/sif/imagenes/CxP02_T.gif'' width=''16'' height=''16'' title=''Click para editar'' alt=''Click para Editar'' onclick=''fnEditar(' #_Cat# #preservesinglequotes(V_FPEEid)# #_Cat# ',-1,"' #_Cat# #preservesinglequotes(V_FPTVTipo)# #_Cat# '",' #_Cat# #preservesinglequotes(V_FPEPID)# #_Cat# ',' #_Cat# #preservesinglequotes(V_FPDElinea)#  #_Cat# ');'' style=''cursor:pointer''/>&nbsp;' #_Cat# b.DPDEdescripcion as DPDEdescripcion, 
    <cf_dbfunction name="to_char" args="b.DPDEjustificacion" len="2000"> as DPDEjustificacion, 
    h.FPAECodigo #_Cat# ' ' #_Cat# b.CFComplemento as AC,
	b.FPEEid,
	b.FPEPid,
	b.FPDElinea,
	case c.FPCCconcepto  
		when 'S' then j.Cdescripcion
		when 'A' then k.Adescripcion
		when 'F' then m.FPCdescripcion
		when '2' then m.FPCdescripcion
		when '1' then m.FPCdescripcion
		else 'no tiene Objeto'
	end as gasto,
	case c.FPCCconcepto  
		when 'S' then 'Servicio'
		when 'A' then 'Inventario'
		when 'F' then 'Activo'
		when '2' then 'Concepto Salarial'
		when '1' then 'otros'
		else 'No tiene Objeto'
	end as gastoTipo,
	Coalesce(case c.FPCCtipo when 'I' then b.DPDMontoTotalPeriodo * b.Dtipocambio else 0 end,0) PeriodoIngresos,
	Coalesce(case c.FPCCtipo when 'G' then b.DPDMontoTotalPeriodo * b.Dtipocambio else 0 end,0) PeriodoEgresos,
	Coalesce(case c.FPCCtipo when 'I' then DPDEcosto * DPDEcantidad * b.Dtipocambio - b.DPDMontoTotalPeriodo * b.Dtipocambio else 0 end,0) FuturoIngresos,
	Coalesce(case c.FPCCtipo when 'G' then DPDEcosto * DPDEcantidad * b.Dtipocambio - b.DPDMontoTotalPeriodo * b.Dtipocambio else 0 end,0) FuturoEgresos,
    tv.FPTVTipo
	from FPEEstimacion a
		inner join FPDEstimacion b
			on a.FPEEid = b.FPEEid
		inner join FPEPlantilla c
			on c.FPEPid = b.FPEPid
		inner join FPActividadE h
			on h.FPAEid = b.FPAEid
		inner join FPActividadD d
			on d.FPAEid = h.FPAEid
			and d.FPADEquilibrio = 1
		inner join PCECatalogo e
			on e.PCEcatid = d.PCEcatid
		inner join PCDCatalogo f
			on f.PCEcatid = e.PCEcatid
			and f.PCDvalor = <cf_dbfunction name="sPart" args="b.CFComplemento, d.FPADPosicion , d.FPADLogitud"> 
		left outer join Conceptos j
			on j.Cid = b.Cid
		left outer join Articulos k
			on k.Aid = b.Aid
		left outer join FPConcepto m
			on m.FPCid = b.FPCid
		inner join TipoVariacionPres tv 
			on tv.FPTVid = a.FPTVid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and a.FPEEestado in (2, 3, 4)
	  and a.CPPid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
	  and f.PCDcatid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
	  and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
	  and b.FPAEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPAEid#">
	  <cfif isdefined('form.filtro_DPDEdescripcion') and len(trim(form.filtro_DPDEdescripcion))>
	  and lower(b.DPDEdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(form.filtro_DPDEdescripcion)#%">
	  </cfif>
	  <cfif isdefined('form.filtro_DPDEjustificacion') and len(trim(form.filtro_DPDEjustificacion))>
	  and lower(b.DPDEjustificacion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(form.filtro_DPDEjustificacion)#%">
	  </cfif>
	  <cfif isdefined('form.filtro_gasto') and len(trim(form.filtro_gasto))>
	  and (lower(j.Cdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(form.filtro_gasto)#%">
	  or lower(k.Adescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(form.filtro_gasto)#%">
	  or lower(m.FPCdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(form.filtro_gasto)#%">)
	  </cfif>
	  <cfif isdefined('form.filtro_AC') and len(trim(form.filtro_AC))>
	  and #preservesinglequotes(V_FPAEid)# #_Cat# ' ' #_Cat# b.CFComplemento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.filtro_AC#">
	  </cfif>
	   <cfif isdefined('form.filtro_gastoTipo') and len(trim(form.filtro_gastoTipo))>
	  and lower(c.FPCCconcepto) like <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(form.filtro_gastoTipo)#">
	  </cfif>
</cfquery>
<cfquery name="rsGastoTipo" datasource="#session.DSN#">
	select distinct c.FPCCconcepto as value, case c.FPCCconcepto  
			when 'S' then 'Servicio'
			when 'A' then 'Inventario'
			when 'F' then 'Activo'
			when '2' then 'Concepto Salarial'
			when '1' then 'otros'
		end as description, 1 as ord
	from FPEEstimacion a
		inner join FPDEstimacion b
			on a.FPEEid = b.FPEEid
		inner join FPEPlantilla c
			on c.FPEPid = b.FPEPid
		inner join FPActividadE h
			on h.FPAEid = b.FPAEid
		inner join FPActividadD d
			on d.FPAEid = h.FPAEid
			and d.FPADEquilibrio = 1
		inner join PCECatalogo e
			on e.PCEcatid = d.PCEcatid
		inner join PCDCatalogo f
			on f.PCEcatid = e.PCEcatid
			and f.PCDvalor = <cf_dbfunction name="sPart" args="b.CFComplemento, d.FPADPosicion , d.FPADLogitud"> 
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and a.FPEEestado in (2, 3, 4)
	  and a.CPPid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
	  and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
	  and b.FPAEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPAEid#">
	  and f.PCDcatid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
	union 
	select '' as value, '-- todos --' as description, 0 as ord from dual
	order by ord
</cfquery>
<cfquery name="rsActividad" datasource="#session.DSN#">
	select distinct #preservesinglequotes(V_FPAEid)#  #_Cat# ' ' #_Cat# b.CFComplemento as value, h.FPAECodigo #_Cat# ' ' #_Cat# b.CFComplemento as description, 1 as ord
	from FPEEstimacion a
		inner join FPDEstimacion b
			on a.FPEEid = b.FPEEid
		inner join FPEPlantilla c
			on c.FPEPid = b.FPEPid
		inner join FPActividadE h
			on h.FPAEid = b.FPAEid
		inner join FPActividadD d
			on d.FPAEid = h.FPAEid
			and d.FPADEquilibrio = 1
		inner join PCECatalogo e
			on e.PCEcatid = d.PCEcatid
		inner join PCDCatalogo f
			on f.PCEcatid = e.PCEcatid
			and f.PCDvalor = <cf_dbfunction name="sPart" args="b.CFComplemento, d.FPADPosicion , d.FPADLogitud"> 
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and a.FPEEestado in (2, 3, 4)
	  and a.CPPid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
	  and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
	  and b.FPAEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPAEid#">
	  and f.PCDcatid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
	union 
	select '' as value, '-- todos --' as description, 0 as ord from dual
	order by ord
</cfquery>
<cf_templatecss>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Equilibrio Financiero" name="equilibrio">	
	<table border="0" cellpadding="0" cellspacing="0" width="100%"
		
		<tr><td colspan="6">&nbsp;</td></tr>
		<tr><td colspan="6">
			<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr>
				<td>&nbsp;</td>
				<td>
					<strong>Nivel de Equilibrio:</strong>&nbsp;<cfoutput>#NivelEquilibrio.descripcion#</cfoutput>&nbsp;
				</td>
				<td>
					<strong>Centro Funcional:</strong>&nbsp;<cfoutput>#CentroF.descripcion#</cfoutput>
				</td>
				<td>
					<strong><strong>Actividad</strong>:</strong>&nbsp;<cfoutput>#Actividad.descripcion#</cfoutput>
				</td>
				<td>&nbsp;</td>
			</tr></table>
		</td></tr>
		<tr><td colspan="6">&nbsp;</td></tr>
		<form name="form1" id="form1" action="Equilibrio-popUp.cfm" method="post" onsubmit="return fnCambiar();">
			<cfoutput>
			<input type="hidden" name="CPPid" value="#form.CPPid#" />
			<input type="hidden" name="PCDcatid" value="#form.PCDcatid#" />
			<input type="hidden" name="CFid" value="#form.CFid#" />
			<input type="hidden" name="FPAEid" value="#form.FPAEid#" />
			</cfoutput>
			<tr>
				<td>&nbsp;</td>
				<td>
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" >
					<cfinvokeargument name="query" 				value="#Actividad#"/>
					<cfinvokeargument name="desplegar" 			value="DPDEdescripcion,DPDEjustificacion,AC,gasto,gastoTipo,PeriodoIngresos,PeriodoEgresos,FuturoIngresos,FuturoEgresos"/>
					<cfinvokeargument name="etiquetas" 			value="Descripción,Justificación,Act. Emp / Complemento,Objeto de Gasto,Concepto,Monto Ingresos Periódo(Local),Monto Egresos Periódo(Local),Monto Ingresos Futuro(Local),Monto Egresos Futuro(Local)"/>
					<cfinvokeargument name="formatos" 			value="S,S,S,S,S,UM,UM,UM,UM"/>
					<cfinvokeargument name="align" 				value="left,center,left,left,left,right,right,right,right"/>
					<cfinvokeargument name="checkboxes" 		value="N"/>
					<cfinvokeargument name="keys" 				value="FPEEid,FPEPid,FPDElinea"/>
					<cfinvokeargument name="ira" 				value=""/>
					<cfinvokeargument name="MaxRows" 			value="1000"/>
					<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
					<cfinvokeargument name="PageIndex" 			value="1"/>
					<cfif Actividad.FPTVTipo EQ -1>
						<cfinvokeargument name="checkboxes" 		value="S"/>
						<cfinvokeargument name="checkall" 			value="S"/>
					</cfif>
					<cfinvokeargument name="incluyeForm" 		value="false"/>
					<cfinvokeargument name="formname" 			value="form1"/>
					<cfinvokeargument name="cortes" 			value="gastoTipo"/>
					<cfinvokeargument name="mostrar_filtro" 	value="true"/>
					<cfinvokeargument name="filtrar_por" 		value="DPDEdescripcion"/>
					<cfinvokeargument name="totalgenerales" 	value="TotalIngresos,TotalEgresos"/>
					<cfinvokeargument name="rsgastoTipo" 		value="#rsGastoTipo#"/>
					<cfinvokeargument name="rsAC" 		value="#rsActividad#"/>
					
				</cfinvoke>
				</td>
				<td>&nbsp;</td>
			</tr>
           <cfif Actividad.FPTVTipo EQ -1>
			<tr><td colspan="6">&nbsp;</td></tr>
			<tr>
				<td>&nbsp;</td>
				<td align="center"><strong>Selecione la Fuente de Financiamiento a la cual desea Cambiar las filas selecionadas</strong></td>
				<td>&nbsp;</td>
			</tr>
			<tr><td colspan="6">&nbsp;</td></tr>
			<tr>
				<td>&nbsp;</td>
				<td align="center">
               	 <cf_conlis
						Campos="PCDcatid,PCDvalor,PCDdescripcion"
						tabindex="1"
						Desplegables="N,S,S"
						Modificables="N,S,N"
						form="form1"
						Size="0,15,35"
						Title="Fuentes de Financiamiento"
						Tabla="PCDCatalogo"
						Columnas="PCDcatid,PCDvalor,PCDdescripcion"
						Filtro="PCEcatid = #rsCatFin.PCEcatid# and (Ecodigo is null or Ecodigo = #session.Ecodigo#)order by PCDvalor"
						Desplegar="PCDvalor,PCDdescripcion"
						Etiquetas="valor,Descripción"
						filtrar_por="PCDvalor,PCDdescripcion"
						Formatos="S,S"
						Align="left,left"
						Asignar="PCDcatid,PCDvalor,PCDdescripcion"
						Asignarformatos="S,S,S"/>
                </td>
				<td>&nbsp;</td>
			</tr>
           
			<tr><td colspan="6">&nbsp;</td></tr>
			<tr>
				<td>&nbsp;</td>
				<td align="center"><input type="submit" value="Cambiar" name="Cambiar" class="btnGuardar" onclick="return fnValidarCampos();"/></td>
				<td>&nbsp;</td>
			</tr>
       </cfif>
		</form>
		<tr><td colspan="6">&nbsp;</td></tr>
	</table>
	<script language="javascript1.2" type="text/javascript">
	
		var validarCampos = true;
		function fnValidarCampos(){
			if(!validarCampos)
				return true;
			msjError = "";
			param = "";
			if (document.getElementById("PCDvalor").value == '')
				msjError = msjError+"- El campo de Fuente de Financiamiento es requerida.\n";
			if (!haySelecionados())
				msjError = msjError+"- Debe de selecionar al menos una fila.\n";	
			if (msjError != ""){
				alert("Se presentaron los siguientes errores:\n"+msjError);
				return false;
			}else
				return true;	
		}
		
		function haySelecionados(){
			f = document.form1;
			if(f.chk != null){
				if(f.chk.value){
					if (f.chk.checked) 
						return true;
				}else{
					for (var i=0; i<f.chk.length; i++){
						if (f.chk[i].checked)
							return true;
					}
				}
			} 
			return false;
		}
		
		function funcFiltrar1(){
			validarCampos = false;
			return true;
		}
		
		function fnCambiar(){
			if(!validarCampos)
				return true;
			if(confirm("Desea modificar las lineas selecionadas a la siguiente Actividad: "+document.getElementById("ActividadEmpresarial_Act").value+" "+document.getElementById("ActividadEmpresarial").value+", Desea continuar?"))
				return true;
			return false;
		}
		
		function fnEditar(FPEEid,tab,tipo,FPEPid,FPDElinea){
			window.opener.fnEditar(FPEEid,tab,tipo,FPEPid,FPDElinea);
			window.close();
		}
		//Asigna la dimension de la ventana.
		height = document.getElementById("cfportletequilibriotdcont").offsetHeight + 70;
		if( typeof( window.innerWidth ) == 'number' ){
			//Non-IE
			window.innerHeight = height;
		}else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
			//IE 6+ in 'standards compliant mode'
			document.documentElement.clientHeight = height;
		}else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ){
			//IE 4 compatible
			document.body.clientHeight = height;
		}
		
	</script>
<cf_web_portlet_end>	
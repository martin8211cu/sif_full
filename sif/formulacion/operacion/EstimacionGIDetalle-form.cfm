<!---<cfif EncabezadoEst.FPEEestado eq '2' and not isdefined('form.Equilibrio')>
	<cfthrow message="Operación inválida, debe de entrar desde el módulo de equilibrio financiero.">
</cfif>--->
<CF_onEnterKey enterActionDefault="tab">
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
<cfset ExigeUnidad = "F,A,S,P">
<cfset ExigeAuxiliar = "F,A,S,P">
<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="getParametroActividad" returnvariable="Activo"></cfinvoke>

<cfset filtro_All = "">
<cfif isdefined('btnFiltrar_ALL')>
	<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="CrearFiltro_All" returnvariable="filtro_All">
		<cfif isdefined('form.DPDEdescripcion_ALL') and len(trim(form.DPDEdescripcion_ALL))>
			<cfinvokeargument name="DPDEdescripcion" 	 	value="#form.DPDEdescripcion_ALL#">
		</cfif>
		<cfif isdefined('form.DPDEjustificacion_ALL') and len(trim(form.DPDEjustificacion_ALL))>
			<cfinvokeargument name="DPDEjustificacion" 	 	value="#form.DPDEjustificacion_ALL#">
		</cfif>
		<cfif isdefined('form.CFComplemento_ALLId') and len(trim(form.CFComplemento_ALLId)) and isdefined('form.CFComplemento_ALL') and len(trim(form.CFComplemento_ALL))>
			<cfinvokeargument name="FPAEid" 			value="#form.CFComplemento_ALLId#">
			<cfinvokeargument name="CFComplemento" 		value="#form.CFComplemento_ALL#">
		</cfif>
		<cfif isdefined('form.DPDEfechaIni_ALL') and len(trim(form.DPDEfechaIni_ALL)) and len(trim(form.FPCCExigeFecha_All)) and form.FPCCExigeFecha_AlL eq 1>
			<cfinvokeargument name="DPDEfechaIni" 		value="#form.DPDEfechaIni_ALL#">
		</cfif>
		<cfif isdefined('form.DPDEfechaFin_ALL') and len(trim(form.DPDEfechaFin_ALL)) and len(trim(form.FPCCExigeFecha_All)) and form.FPCCExigeFecha_All eq 1>
			<cfinvokeargument name="DPDEfechaFin" 		value="#form.DPDEfechaFin_ALL#">
		</cfif>
		<cfif isdefined('form.Ucodigo_ALL') and len(trim(form.Ucodigo_ALL))>
			<cfinvokeargument name="Ucodigo" 			value="#form.Ucodigo_ALL#">
		</cfif>
		<cfif isdefined('form.Aid_ALL') and len(trim(form.Aid_ALL))>
			<cfinvokeargument name="Aid" 			    value="#form.Aid_ALL#">
		</cfif>
		<cfif isdefined('form.Cid_ALL') and len(trim(form.Cid_ALL))>
			<cfinvokeargument name="Cid" 			    value="#form.Cid_ALL#">
		</cfif>
		<cfif isdefined('form.FPCid_ALL') and len(trim(form.FPCid_ALL))>
			<cfinvokeargument name="FPCid" 			    value="#form.FPCid_ALL#">
		</cfif>
		<cfif isdefined('form.OBPcodigo') and len(trim(form.OBPcodigo))>
			<cfinvokeargument name="OBPcodigo" 				value="#trim(form.OBPcodigo)#">
		</cfif>
		<cfif isdefined('form.OBOcodigo') and len(trim(form.OBOcodigo))>
			<cfinvokeargument name="OBOcodigo" 			value="#trim(form.OBOcodigo)#">
		</cfif>
		<cfinvokeargument name="FPCCconcepto" value="#PlantillasCF.FPCCconcepto#">	
	</cfinvoke>
</cfif>
<!--- Saca el path de las lineas de detalle de la estimacion--->
<cfquery name="LineasDEstimacion" datasource="#session.DSN#">
	select distinct b.FPCCid, b.FPCCpath
		from #prefijoHV#FPDEstimacion a
			inner join FPCatConcepto b
				on b.FPCCid = a.FPCCid
		<cfif (isdefined('form.OBOcodigo') and len(trim(form.OBOcodigo))) or (isdefined('form.OBPcodigo') and len(trim(form.OBPcodigo)))>
			inner join OBobra OB
				on OB.OBOid = a.OBOid
		</cfif>
		<cfif isdefined('form.OBPcodigo') and len(trim(form.OBPcodigo))>
			inner join OBproyecto OP
				on OP.OBPid = OB.OBPid
		</cfif>
	 where FPEEid = #form.FPEEid# and a.FPEPid = #PlantillasCF.FPEPid#
	 <cfif isdefined('btnFiltrar_ALL')>
		  #preservesinglequotes(filtro_All)#
	  </cfif>
	 order by b.FPCCpath
</cfquery>
<cfset lista = valuelist(LineasDEstimacion.FPCCpath)>
<cfset listaPath = "">
<cfloop query="LineasDEstimacion">
	<cfset path = "">
	<cfif not len(trim(LineasDEstimacion.FPCCpath))>
		<cfthrow message="El path de las clasificaciones no ha sido generado, debe de ir al catálago de Clasifiaciones de Conceptos y generarlo, Proceso Cancelado.">
	</cfif>
	<cfloop list="#LineasDEstimacion.FPCCpath#" index="i" delimiters="/">
		<cfset path &= i>
		<cfif not listfind(listaPath,path)>
			<cfset listaPath &= path & ",">
		</cfif>
		<cfset path &= "/">
	</cfloop>
</cfloop>

<cfquery name="Clasificaciones" datasource="#session.DSN#">
	select DP.FPCCid,CCP.FPCCdescripcion,CCP.FPCCcodigo,CCP.FPCCcomplementoP,CCP.FPCCpath
		from FPDPlantilla DP
			inner join FPCatConcepto CCP
				on CCP.FPCCid = DP.FPCCid
	 where DP.FPEPid = #PlantillasCF.FPEPid#
</cfquery>

<cfif Clasificaciones.recordCount EQ 0>
	<table border="0" align="center">
		<tr>
			<td align="center">
				<span class="msgError">La Plantillas no posee Clasificación de Conceptos de Gasto e Ingresos </span>
			</td>
		</tr>
	</table>
<cfelse>
	<!--- Obtiene unicamente los conceptos que pertenecen al path--->
	<cfif Clasificaciones.recordcount neq listlen(valuelist(Clasificaciones.FPCCpath))>
		<cfthrow message="El path de las clasificaciones no ha sido generado, debe de ir al catálago de Clasifiaciones de Conceptos y generarlo, Proceso Cancelado.">
	</cfif>
	<cfquery name="ConceptosDetalles" dbtype="query">
		select FPCCid, FPCCdescripcion, FPCCcodigo, FPCCcomplementoP, FPCCpath
			from Clasificaciones
		 where FPCCpath in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#listaPath#" list="yes">)
	</cfquery>
	
	<cfif PlantillasCF.PCGDxCantidad eq 1>
		<cfset controlaCantidad = true> 
	<cfelse>
		<cfset controlaCantidad = false> 
	</cfif>

	<cfif PlantillasCF.FPEPmultiperiodo eq 1>
		<cfset esMultiperido = true> 
	<cfelse>
		<cfset esMultiperido = false> 
	</cfif>
	<cfif len(trim(PlantillasCF.CFid)) and PlantillasCF.FPCCconcepto eq 'A'>
		<cfset esSuminitroConCF = true> 
	<cfelse>
		<cfset esSuminitroConCF = false> 
	</cfif>
	
	<cfoutput>
			<cfset valueMcodigo 	 = QueryNew("Mcodigo")>
			<cfset valueDPDEfechaIni = DateFormat(now(),'dd/mm/yyyy')>
			<cfset valueDPDEfechaFin = valueDPDEfechaIni>
			<cfset valueDtipocambio  = 1.0000>
			<cfset valueDPDEcantidad = 1>
			<cfset valueDPDEcosto    = 1.0000>
			<cfset valueFPCid 		 = "">
			<cfset valueOBOid 		 = "">
			<cfif controlaCantidad>
				<cfset valueDPDEcantidadPeriodo = valueDPDEcantidad>
			</cfif>	
			<cfset valueDPDMontoTotalPeriodo = valueDPDEcantidad * valueDPDEcosto>
			<cfset valuePPCGDautorizadoTotal = 0>
			<cfset valueTotalConsumidoBruto  = 0>
			<cfset valueTotalConsumidoNeto   = 0>
			<cfset valuePCGDreservado        = 0>
			<cfset valuePCGDcomprometido     = 0>
			<cfset valuePCGDejecutado        = 0>
			<cfset valuePCGDautorizadoAnteriores = 0>
			<cfset valueTotalConsumidoPeriodo    = 0>
			<cfset valuePCGDpendiente            = 0>
			<cfset valueDPDEmontoMinimo          = 0>
			<cfset valuePCGDautorizadoAnteriores = 0>
			<cfset valueDPDEmontoAjuste = 0>
			<cfset valueDPDECantidadAjuste = 0>
			<cfset valueMCPeriodoPlanC = 0>
		<cfif mododet NEQ 'CAMBIO' and esSuminitroConCF>
			<cfquery datasource="#session.dsn#" name="valueMcodigo">
				select coalesce(Mcodigo,-1) as Mcodigo
				from Empresas
				where Ecodigo = #session.Ecodigo#
			</cfquery>
		<cfelseif mododet EQ 'CAMBIO'>
			<cfset QueryAddRow(valueMcodigo, 1)>
			<cfset QuerySetCell(valueMcodigo, "Mcodigo", "#DetalleEst.Mcodigo#", 1)>
			<cfset valueDPDEfechaIni = DateFormat(DetalleEst.DPDEfechaIni,'dd/mm/yyyy')>
			<cfset valueDPDEfechaFin = DateFormat(DetalleEst.DPDEfechaFin,'dd/mm/yyyy')>
			<cfset valueDPDEcosto    = DetalleEst.DPDEcosto>
			<cfset valueDtipocambio  = DetalleEst.Dtipocambio>
		    <cfset valueDPDEcantidad = DetalleEst.DPDEcantidad>
			<cfif controlaCantidad>
				<cfset valueDPDEcantidadPeriodo = DetalleEst.DPDEcantidadPeriodo>
			</cfif>
			<cfset valueDPDMontoTotalPeriodo 	 = DetalleEst.DPDMontoTotalPeriodo>
			<cfset valueFPCid 				 	 = "#DetalleEst.FPCid#,#DetalleEst.FPCcodigo#,#replace(DetalleEst.FPCdescripcion,',','')#,#DetalleEst.FPCCExigeFecha#">
			<cfset valueOBOid 				 	 = "#DetalleEst.OBOid#,'','',#DetalleEst.OBOcodigo#,#DetalleEst.OBOdescripcion#">
			<cfif DetalleEst.Multiperiodo>
				<cfset valuePPCGDautorizadoTotal =  numberformat(DetalleEst.PCGDautorizadoTotal,'9.0000')>
			<cfelse>
				<cfset valuePPCGDautorizadoTotal =  numberformat(DetalleEst.PCGDautorizado,'9.0000')>
			</cfif>
			<cfset valueTotalConsumidoBruto 	 =  numberformat(DetalleEst.PCGDconsumidoBrutoTotal,'9.0000')>
			<cfset valueTotalConsumidoNeto 		 =  numberformat(DetalleEst.PCGDconsumidoNetoTotal,'9.0000')>
			<cfset valuePCGDreservado 		 	 =  numberformat(DetalleEst.PCGDreservado,',9.0000')>
			<cfset valuePCGDcomprometido 	 	 =  numberformat(DetalleEst.PCGDcomprometido,',9.0000')>
			<cfset valuePCGDejecutado 		 	 =  numberformat(DetalleEst.PCGDejecutado,',9.0000')>
			<cfset valuePCGDautorizadoAnteriores =  numberformat(DetalleEst.PCGDautorizadoAnteriores,'9.0000')>
			<cfset valueTotalConsumidoPeriodo 	 = iif(DetalleEst.PCGDconsumidoBruto neq '',DetalleEst.PCGDconsumidoBruto,0)>
			<cfset valuePCGDpendiente 			 = numberformat(DetalleEst.PCGDpendiente,',9.0000')>
			<cfset valueDPDEmontoMinimo          = DetalleEst.DPDEmontoMinimo>
			<cfset DetalleEst.PCGDautorizadoAnteriores = valuePCGDautorizadoAnteriores>
			<cfset valueDPDEmontoAjuste = iif(len(trim(DetalleEst.DPDEmontoAjuste)) eq 0,0,DetalleEst.DPDEmontoAjuste)>
			<cfif controlaCantidad>
				<cfset valueDPDECantidadAjuste = (DetalleEst.DPDMontoTotalPeriodo - valuePPCGDautorizadoTotal) / valueDPDEcosto + ((valueDPDEcosto * valueDPDEcantidad) - DetalleEst.DPDMontoTotalPeriodo) / valueDPDEcosto>
			</cfif>
			<cfset valueMCPeriodoPlanC = DetalleEst.MontoPeriodoPlanC / iif(controlaCantidad, valueDPDEcosto, 1)>
		<cfelseif isdefined('btnFiltrar_ALL')>
			<cfset QueryAddRow(valueMcodigo, 1)>
			<cfset QuerySetCell(valueMcodigo, "Mcodigo", "#form.Mcodigo_All#", 1)>
		</cfif>
		<cfset lvarMostrarCamposLigadosPCG = false>
		<cfif EncabezadoEst.FPTVTipo neq -1 and  ModoDet EQ 'CAMBIO' and DetalleEst.LigadoPCG>
			<cfset lvarMostrarCamposLigadosPCG = true>
		</cfif>
		<table border="0" width="100%">
			<cfset lvarMostrarLink = "false">
			<cfif (EncabezadoEst.FPEEestado eq 0 and fechaValida and not request.RolAdmin) or (request.RolAdmin and (EncabezadoEst.FPEEestado eq 2 or (EncabezadoEst.FPEEestado eq 0 and EncabezadoEst.FPTVTipo eq 4)))>
			<tr><td><cfset PrintSetInput(PlantillasCF.FPCCconcepto)></td></tr>
			<cfset lvarMostrarLink = "true">
			</cfif>
			<cfloop query="ConceptosDetalles">
				<cfif not len(trim(ConceptosDetalles.FPCCpath))>
					<cfthrow message="El path de las clasificaciones no ha sido generado, debe de ir al catálago de Clasifiaciones de Conceptos y generarlo, Proceso Cancelado.">
				</cfif>
				<tr>
					<td>
						<strong>#ConceptosDetalles.FPCCcodigo#-#ConceptosDetalles.FPCCdescripcion#<cfif len(trim(ConceptosDetalles.FPCCcomplementoP))>(#ConceptosDetalles.FPCCcomplementoP#)</cfif></strong>
					</td>
				</tr>
				<cfset GetHijos(#ConceptosDetalles.FPCCid#,'&nbsp;&nbsp;',filtro_All,listaPath)>
			</cfloop>
			<cfif ConceptosDetalles.recordcount eq 0>
				<tr>
					<td align="center">
						<strong>No existen lineas de detalle asociadas a esta plantilla.</strong>
					</td>
				</tr>
			</cfif>
		</table>
	
	</cfoutput>
</cfif>
<!---===============================================--->
<cffunction name="GetHijos" access="private">
	<cfargument name='idPadre'		type='numeric' 	required='true'>
	<cfargument name='nivel'		type='string' 	required='true'>
	<cfargument name='filtro_All'	type='string' 	required='no' default="">
	<cfargument name='listaPath'	type='string' 	required='no' default="">

	<cfset Arguments.Hijo=PCG_ConceptoGastoIngreso.fnGetHijos(Arguments.idPadre,Arguments.listaPath)>
	<cfloop query="Arguments.Hijo">
		<cfif not len(trim(Arguments.Hijo.FPCCpath))>
			<cfthrow message="El path de las clasificaciones no ha sido generado, debe de ir al catálago de Clasifiaciones de Conceptos y generarlo, Proceso Cancelado.">
		</cfif>
		<cfif Arguments.Hijo.hijos NEQ 0>
			<tr>
				<td> 	
					<cfoutput>#Arguments.nivel#<img src="../../imagenes/derecha.gif" />#Arguments.Hijo.FPCCdescripcion#</cfoutput>
				</td>
			</tr>
			<cfset GetHijos(Arguments.Hijo.FPCCid,Arguments.nivel&'&nbsp;&nbsp;',Arguments.filtro_All,Arguments.listaPath)>
		<cfelse>
			<cfif not (FPCCTablaC EQ '' and ListFind(ExigeAuxiliar,FPCCconcepto))>
			<tr><td>
				<fieldset><legend><cfoutput>#Arguments.Hijo.FPCCcodigo#-#Arguments.Hijo.FPCCdescripcion#<cfif len(trim(Arguments.Hijo.FPCCcomplementoP))>(#Arguments.Hijo.FPCCcomplementoP#)</cfif></cfoutput></legend>
				<cfset PrintSet(form.FPEEid,PlantillasCF.FPEPid,Arguments.Hijo.FPCCid,form.FPDElinea,Arguments.Hijo.FPCCconcepto,Arguments.Hijo.FPCCExigeFecha,Arguments.Hijo.FPCCTablaC,Arguments.filtro_All)>
				</fieldset>
			</td></tr>
			</cfif>
		</cfif>
	</cfloop>
	<cfif Arguments.Hijo.recordcount eq 0>
		 <cfquery datasource="#session.dsn#" name="rsSQL">
			select 	FPCCid, FPCCconcepto, FPCCExigeFecha, FPCCTablaC
			from FPCatConcepto
			where FPCCid = #Arguments.idPadre#
			order by FPCCcodigo, FPCCdescripcion
		</cfquery>
		<cfif not (rsSQL.FPCCTablaC EQ '' and ListFind(ExigeAuxiliar,rsSQL.FPCCconcepto))>
			<tr><td>
				<fieldset><legend><cfoutput>#Arguments.Hijo.FPCCcodigo#-#Arguments.Hijo.FPCCdescripcion#<cfif len(trim(Arguments.Hijo.FPCCcomplementoP))>(#Arguments.Hijo.FPCCcomplementoP#)</cfif></cfoutput></legend>
				<cfset PrintSet(form.FPEEid,PlantillasCF.FPEPid, Arguments.idPadre,form.FPDElinea,rsSQL.FPCCconcepto,rsSQL.FPCCExigeFecha,rsSQL.FPCCTablaC,Arguments.filtro_All)>
				</fieldset>
			</td></tr>
			
		</cfif>
	</cfif>
</cffunction>

<!---===============================================--->
<cffunction name="PrintSet" access="private">
	<cfargument name='FPEEid'			type='numeric' 	required='true'>
	<cfargument name='FPEPid'			type='numeric' 	required='true'>
	<cfargument name='FPCCid'			type='numeric' 	required='true'>
	<cfargument name='FPDElinea'		type='numeric' 	required='true'>
	<cfargument name='FPCCconcepto'		type='string' 	required='true'>
	<cfargument name='FPCCExigeFecha'	type='numeric' 	required='true' default="0">
	<cfargument name='FPCCTablaC'		type='string' 	required='true'>
	<cfargument name='filtro_All'		type='string' 	required='no' default="">
	
	<cfset ext 			 	 = "_"&Arguments.FPEEid&"_"&Arguments.FPCCid>
	<cfset changeline		 = false>
		
	<cfif ModoDet EQ 'CAMBIO' AND Arguments.FPEEid EQ DetalleEst.FPEEid AND Arguments.FPEPid EQ DetalleEst.FPEPid AND Arguments.FPCCid EQ DetalleEst.FPCCid>	
		<cfset changeline = true>	
	</cfif>
	 <!---Inicio(Unicamente para asumir que siempre va a ver uno antes y poner la coma)--->
		<cfset columnDisplay = "ini">
		<cfset columnLabel   = "&nbsp;">
		<cfset columnFormat  = "S">
		<cfset align		 ="center">
	<!---Descripcion y Justificación--->
		<cf_dbfunction name="sPart" args="a.DPDEdescripcion,1,15"  returnvariable="DPDEdescripcion">
		<cf_dbfunction name="sPart" args="a.DPDEjustificacion,1,15"  returnvariable="DPDEjustificacion">
		<cf_dbfunction name="sPart" args="a.DPDEjustificacion,1,300" returnvariable="DPDEjustificacionLong">
		<cf_dbfunction name="length"  args="a.DPDEdescripcion"    	    returnvariable="DPDEdescripcionL">
		<cf_dbfunction name="length"  args="a.DPDEjustificacion"  	    returnvariable="DPDEjustificacionL">
		<cf_dbfunction name="length"  args="(select distinct a.FPDEid from DOrdenCM oc where oc.PCGDid = a.PCGDid)"  	  		  returnvariable="LvarLen">
		<cf_dbfunction name="to_char"	args="a.FPDEid"	isNumber="true"		  returnvariable="lvarFPDEidToChar">
		<cfset btnDesc = '''<input name="Descripcion" title="Descripción" 	type="image" src="../../imagenes/iindex.gif" value="''#_Cat#a.DPDEdescripcion#_Cat#''" alt="Descripción"   width="16" height="16" border="0" onclick="Displaydes(this);">'''>
		<cfset btnJust = '''<input name="Justificacion" title="Justificación" type="image" src="../../imagenes/iindex.gif" value="''#_Cat##DPDEjustificacionLong##_Cat#''" alt="Justificación" width="16" height="16" border="0" onclick="Displaydes(this);">'''>
		<cfset btnOrden = '''<input name="Orden" title="Ver Ordenes de Compra" type="image" src="../../imagenes/find.small.png" value="OCs" alt="Ver Ordenes de Compra" width="16" height="16" border="0" onclick="fnVerOCs(''''form_#Arguments.FPEEid#_#Arguments.FPEPid#_#Arguments.FPCCid#'''',''#_Cat##lvarFPDEidToChar##_Cat#'');">'''>
		<cfset columns 	= "'' as ini, a.FPCCid,a.FPEPid,a.FPEEid,a.FPDElinea,
				case when #DPDEdescripcionL# > 15 then #PreserveSingleQuotes(btnDesc)# else '' end #_Cat# #DPDEdescripcion# #_Cat# case when #DPDEdescripcionL# > 15 then '...' else '' end as DPDEdescripcion,
				case when #DPDEjustificacionL# > 15 then #PreserveSingleQuotes(btnJust)#  else '' end #_Cat# #DPDEjustificacion# #_Cat# case when #DPDEjustificacionL# > 15 then '...' else '' end as DPDEjustificacion,'&nbsp;' as espacio,
				case when #LvarLen# > 0 then #PreserveSingleQuotes(btnOrden)# else '' end as OCs">
		<cfif not esSuminitroConCF>
			<cfset columnDisplay &= ",OCs,DPDEdescripcion,DPDEjustificacion">
			<cfset columnLabel   &= ",&nbsp;,Descripción, Justificación">
			<cfset columnFormat  &= ",S,S,S">
			<cfset align		 &= ",left,left,left">
		</cfif>
		<cfif PlantillasCF.PCGDxPlanCompras eq '1'>
			<cfset columns		 &=",DPDEcontratacion">
			<cfset columnDisplay &= ",DPDEcontratacion,espacio">
			<cfset columnLabel   &= ",N° Contratación,&nbsp;">
			<cfset columnFormat  &= ",S,S">
			<cfset align		 &=",right,left">
		</cfif>
		<cfset table		 =" #prefijoHV#FPDEstimacion a inner join Monedas b on a.Mcodigo = b.Mcodigo">
	<!---Proyecto/Obra--->	
	<cfif ListFind('P', Arguments.FPCCconcepto)>
		<cfset columns 		&= ",'('#_Cat#rtrim(OP.OBPcodigo)#_Cat#')'#_Cat# OP.OBPdescripcion #_Cat#'/'#_Cat# '('#_Cat#rtrim(OB.OBOcodigo)#_Cat#')'#_Cat# OB.OBOdescripcion as ProyObra">
		<cfset columnDisplay&= ",ProyObra">
		<cfset columnLabel  &= ",Proyecto/Obra">
		<cfset columnFormat &= ",S">
		<cfset align		 &=",left">
		<cfset table		&=" left outer join OBobra OB inner join OBproyecto OP on OP.OBPid = OB.OBPid on OB.OBOid = a.OBOid">
	</cfif>
	<!---Articulo--->
	<cfif ListFind('A', Arguments.FPCCconcepto)>
		<cfset columns 		&= ",c.Adescripcion">
		<cfset columnDisplay&= ",Adescripcion">
		<cfset columnLabel  &= ",Articulo">
		<cfset columnFormat &= ",S">
		<cfset align		 &=",left">
		<cfset table		&=" left outer join Articulos c on c.Aid = a.Aid">
	</cfif>
	<!---Servicio--->
	<cfif ListFind('S,P', Arguments.FPCCconcepto)>
		<cfset columns 		&= ",d.Cdescripcion">
		<cfset columnDisplay&= ",Cdescripcion">
		<cfset columnLabel  &= ",Concepto">
		<cfset columnFormat &= ",S">
		<cfset align		 &=",left">
		<cfset table		&=" left outer join Conceptos d on d.Cid = a.Cid">
	</cfif>
	<!---Actividad--->
	    <cfset columns 		 &= ",f.FPAECodigo #_Cat# ' ' #_Cat# a.CFComplemento as Actividad">
		<cfset columnDisplay &= ",Actividad">
		<cfset columnLabel   &= ",Actividad">
		<cfset columnFormat  &= ",S">
		<cfset align		 &=",left">
		<cfset table		 &=" inner join FPActividadE f on f.FPAEid = a.FPAEid">
		
	<cfif ListFind(ListFPCCconcepto, Arguments.FPCCconcepto)>
		<cf_dbfunction name="sPart" 	args="e.FPCdescripcion,1,30" 	returnvariable="Spart_Desc">
		<cf_dbfunction name="length"	args="e.FPCdescripcion" 		returnvariable="Len_Desc">
		<cfset columns 		&= ",#Spart_Desc#  #_Cat# case when #Len_Desc# > 30 then '...' else '' end  as FPCdescripcion">
		<cfset columnDisplay&= ",FPCdescripcion">

		<cfset columnLabel  &= ",Concepto Ingreso y Egreso ">
		<cfset columnFormat &= ",S">
		<cfset align		&=",left">
		<cfset table		&=" left outer join FPConcepto e on e.FPCid = a.FPCid">
	</cfif>
	<cfif Arguments.FPCCExigeFecha NEQ 0 >
		<cfset columns 		&= ",a.DPDEfechaIni,a.DPDEfechaFin">
		<cfset columnDisplay&= ",DPDEfechaIni,DPDEfechaFin">
		<cfset columnLabel  &= ",Fecha Inicial,Fecha Final">
		<cfset columnFormat &= ",D,D">
		<cfset align		&=",center,center">
	</cfif>
		<cfset columns      &=",b.Mnombre,a.Dtipocambio">
		<cfset columnDisplay&=",Mnombre,espacio,Dtipocambio">
		<cfset columnLabel  &=",Moneda,&nbsp;,Tipo Cambio">
		<cfset columnFormat &=",S,S,N">
		<cfset align		&=",center,center,right">
	<cfif ListFind(ExigeUnidad, Arguments.FPCCconcepto)>
		<cfset columns      &=",u.Udescripcion">
		<cfset columnDisplay&=",espacio,,Udescripcion">
		<cfset columnLabel  &=",&nbsp;,Unidad">
		<cfset columnFormat &=",S,S">
		<cfset align		&=",center,left">
		<cfset table		&=" left outer join Unidades u on u.Ucodigo = a.Ucodigo and u.Ecodigo = a.Ecodigo">
	</cfif> 
	<cfif ListFind('S,P', Arguments.FPCCconcepto)>
		<cfset columns      &=",a.DPDEmontoMinimo">
		<cfset columnDisplay&=",espacio,DPDEmontoMinimo">
		<cfset columnLabel  &=",&nbsp;,Monto Mínimo">
		<cfset columnFormat &=",S,UM">
		<cfset align		&=",center,right">
	</cfif>
	<cfif controlaCantidad and esMultiperido>
		<cfset columns      &=",a.DPDEcantidad,a.DPDEcosto,a.DPDEcantidadPeriodo,a.DPDEcantidad-a.DPDEcantidadPeriodo as cantidadFutura">
		<cfset columnDisplay&=",espacio,DPDEcantidad,espacio,DPDEcosto,espacio,DPDEcantidadPeriodo,espacio,cantidadFutura">
		<cfset columnLabel  &=",&nbsp;,Cantidad,&nbsp;,Monto Unitario,&nbsp;,Cantidad Periódo,&nbsp;,Cantidad Futura">
		<cfset columnFormat &=",S,I,S,UM,S,I,S,I">
		<cfset align		&=",center,center,center,right,center,center,center,center">
	<cfelseif controlaCantidad and not esMultiperido>
		<cfset columns      &=",a.DPDEcantidadPeriodo,a.DPDEcosto">
		<cfset columnDisplay&=",espacio,DPDEcantidadPeriodo,espacio,DPDEcosto">
		<cfset columnLabel  &=",&nbsp;,Cantidad Periódo,&nbsp;,Monto Unitario">
		<cfset columnFormat &=",S,I,S,UM">
		<cfset align		&=",center,center,center,right">
	</cfif>
	<cfif EncabezadoEst.FPTVTipo neq -1>
		<cfset columns      &=",a.DPDEmontoAjuste">
		<cfset columnDisplay&=",espacio,DPDEmontoAjuste">
		<cfset columnLabel  &=",&nbsp;,Monto Ajuste">
		<cfset columnFormat &=",S,UM">
		<cfset align		&=",center,right">
	</cfif>
	<cf_dbfunction name="length" args="rtrim(a.DPDEObservaciones)" returnvariable="lenNotas">
	<cfset columns      &=",a.DPDMontoTotalPeriodo">
	<cfset columnDisplay&=",espacio,DPDMontoTotalPeriodo">
	<cfset columnLabel  &=",&nbsp;,Monto Periódo">
	<cfset columnFormat &=",S,UM">
	<cfset align		&=",center,right">
	<cfif esMultiperido>
		<cfset columns      &=",a.DPDEcantidad*a.DPDEcosto-a.DPDMontoTotalPeriodo as MontoFuturo">
		<cfset columnDisplay&=",espacio,MontoFuturo">
		<cfset columnLabel  &=",&nbsp;,Monto Futuro">
		<cfset columnFormat &=",S,UM">
		<cfset align		&=",center,right">
	</cfif>
	<cfset columns      &=",a.DPDEcantidad*a.DPDEcosto as montoOri,a.DPDEcantidad*a.DPDEcosto*a.Dtipocambio as montoLocal,case when (#lenNotas# > 0 or '#request.RolAdmin#' = 'true')  then '#preservesinglequotes(ButonNotes)#' else '' end as ButonNotes,case when a.PCGDid is null then '#preservesinglequotes(ButonAction)#' else '' end as ButonAction">
	<cfset columnDisplay&=",espacio,montoOri,espacio,montoLocal,ButonNotes,ButonAction">
	<cfset columnLabel  &=",&nbsp;,Monto Total,&nbsp;,Monto Local">
	<cfset columnFormat &=",S,UM,S,UM,US,US">
	<cfset align		&=",center,right,center,right,center,center">
	<cfoutput>
		<form action="EstimacionGI-sql.cfm" id="form_#Arguments.FPEEid#_#Arguments.FPEPid#_#Arguments.FPCCid#" method="post" name="form_#Arguments.FPEEid#_#Arguments.FPEPid#_#Arguments.FPCCid#">
			<input name="tab"		 		  id="tab" 	 	  		   value="#url.tab#" 		  		   type="hidden" />
			<input name="FPCCconcepto" 		  id="FPCCconcepto" 	   value="#PlantillasCF.FPCCconcepto#" type="hidden"/>
			<input name="FPEEid_key" 		  id="FPEEid_key"   	   value="#Arguments.FPEEid#" 		   type="hidden"/>
			<input name="FPEPid_key" 		  id="FPEPid_key"   	   value="#Arguments.FPEPid#" 		   type="hidden"/>
			<input name="FPCCid_key" 		  id="FPCCid_key"   	   value="#Arguments.FPCCid#" 		   type="hidden"/>
			<input name="FPDElinea_key" 	  id="FPDElinea_key"   	   value="#Arguments.FPDElinea#" 	   type="hidden"/>	
			<input name="FPCCExigeFecha#ext#" id="FPCCExigeFecha#ext#" value="#FPCCExigeFecha#" 		   type="hidden"/>
			<input name="monedalocal"		  id="monedalocal"		   value="#rsMonedaLocal.Mcodigo#"	   type="hidden"/>
			<input name="HV"		  		  id="HV"		   		   value="#form.HV#"	   			   type="hidden"/>
			<cfif isdefined('form.Equilibrio')>
				<input name="Equilibrio"			type="hidden" 	id="Equilibrio"			value="true">
			</cfif>
			<cfif (FPCCTablaC EQ '' and ListFind(ExigeAuxiliar, Arguments.FPCCconcepto))>
					<table>
						<tr>
							<td align="center">
								<cfif ListFind('A', Arguments.FPCCconcepto)>
									No esta Configurada la Clasificación de Articulos
								<cfelseif ListFind('S,P', Arguments.FPCCconcepto)>
									No esta Configurada la Clasificación de Servicio
								<cfelseif ListFind('F', Arguments.FPCCconcepto)>
									No esta Configurada la Categoria/Clse del Articulo
								</cfif>
							</td>
						</tr>
					</table>
			<cfelse>
				<table border="0" align="center" width="100%">
			<tr><td>
				<cfinvoke component="sif.Componentes.pListas"
				method			="pLista"
				returnvariable	="Lvar_Lista"
				tabla			="#table#"
				columnas		="#columns#"
				desplegar		="#columnDisplay#"
				etiquetas		="#columnLabel#"
				formatos		="#columnFormat#"
				filtro			="a.Ecodigo = #session.Ecodigo# and a.FPEEid = #Arguments.FPEEid# and a.FPCCid =#Arguments.FPCCid# and a.FPEPid = #Arguments.FPEPid# #Arguments.filtro_All# #filtroHV#"
				incluyeform		="false"
				align			="#align#"
				keys			="FPEEid,FPEPID,FPDElinea"
				maxrows			="150"
				showlink		="#lvarMostrarLink#"
				ira				="#CurrentPage#"
				formName		="form_#Arguments.FPEEid#_#Arguments.FPEPid#_#Arguments.FPCCid#"
				showEmptyListMsg="true"
				CurrentPage 	="#CurrentPage#"
				EmptyListMsg	="No existen lineas de detalle asociadas a esta plantilla."
				lineaRoja="DPDMontoTotalPeriodo lt 0">
			</td></tr>
			</table>
			</cfif>
		</form>
	</cfoutput>
</cffunction>
<!---============================Pinta la Captura Generica para todas las Clasificaciones=============================--->
<cffunction name="PrintSetInput" access="private">
	<cfargument name='FPCCconcepto'	 type='string' 	required='true'>
	
	<cfset ext 			= '_All'>
	<cfset valueAid 	= QueryNew("Aid_ALL,Acodigo_ALL,Adescripcion_ALL")>
	<cfset valueUcodigo = QueryNew("Ucodigo_ALL,UcodigoD_ALL,Udescripcion_ALL")>
	<cfset valueCid 	= QueryNew("Cid_ALL,Ccodigo_ALL,Cdescripcion_ALL")>
	
	<cfquery datasource="#session.dsn#" name="rsClasificaciones">
		select Pla.FPCCid , Cat.FPCCcodigo
			from FPDPlantilla Pla
				inner join FPCatConcepto Cat
					on Cat.FPCCid = Pla.FPCCid
			where Pla.FPEPid = #PlantillasCF.FPEPid#
	</cfquery>
			<cfset lista = "">
	<cfloop query="rsClasificaciones">
			<cfset lista &= PCG_ConceptoGastoIngreso.fnListaClasificaciones(rsClasificaciones.FPCCcodigo)>
		<cfif rsClasificaciones.currentRow NEQ rsClasificaciones.recordcount>
			<cfset lista &= ','>
		</cfif>
	</cfloop>
	<cfset filtro 	= ''>
	<cfif len(trim(lista))>
		<cfset filtro = ' and a.FPCCid in(#lista#)'>
	</cfif>
	
	<cfif mododet EQ 'CAMBIO'>
		<cfset QueryAddRow(valueUcodigo, 1)>
		<cfset QueryAddRow(valueAid, 1)>
		<cfset QueryAddRow(valueCid, 1)>
		<cfset QuerySetCell(valueUcodigo, "Ucodigo_ALL", 		"#DetalleEst.Ucodigo#", 1)>
		<cfset QuerySetCell(valueUcodigo, "UcodigoD_ALL", 		"#DetalleEst.Ucodigo#", 1)>
		<cfset QuerySetCell(valueUcodigo, "Udescripcion_ALL", 	"#DetalleEst.Udescripcion#", 1)>
		<cfset QuerySetCell(valueAid, 	  "Aid_ALL", 			"#DetalleEst.Aid#", 1)>
		<cfset QuerySetCell(valueAid, 	  "Acodigo_ALL", 		"#DetalleEst.Acodigo#", 1)>
		<cfset QuerySetCell(valueAid, 	  "Adescripcion_ALL", 	"#DetalleEst.Adescripcion#", 1)>
		<cfset QuerySetCell(valueCid, 	  "Cid_ALL", 			"#DetalleEst.Cid#", 1)>
		<cfset QuerySetCell(valueCid, 	  "Ccodigo_ALL", 		"#DetalleEst.Ccodigo#", 1)>
		<cfset QuerySetCell(valueCid, 	  "Cdescripcion_ALL", 	"#DetalleEst.Cdescripcion#", 1)>
	</cfif>
	<cfoutput>
	<form action="EstimacionGI-sql.cfm" id="form_general" method="post" name="form_general" onsubmit="return fnValidarMonto(this) && hacerSumbmit;">
		<input name="tab"		 		  	type="hidden"	id="tab" 	 				value="#url.tab#"/>
		<input name="FPEEid_ALL" 	   		type="hidden" 	id="FPEEid_ALL"				value="#form.FPEEid#"/>
		<input name="FPEPid_ALL" 	   		type="hidden" 	id="FPEPid_ALL" 			value="#PlantillasCF.FPEPid#"/>
		<input name="FPDElinea_ALL"    		type="hidden" 	id="FPDElinea_ALL"			value="#form.FPDElinea#"/>
		<input name="FPCCconcepto_ALL" 		type="hidden" 	id="FPCCconcepto_ALL" 		value="#PlantillasCF.FPCCconcepto#"/>
		<input name="tab_ALL"	 	   		type="hidden" 	id="tab_ALL" 	 	  		value="#url.tab#"/>
		<input name="PCGDxCantidad"			type="hidden" 	id="PCGDxCantidad" 	 	  	value="#PlantillasCF.PCGDxCantidad#"/>
		<input name="Activo"		  	 	type="hidden"  	id="Activo"		   	   		value="#Activo#"/>
		<input name="TotalConsumidoPeriodo"	type="hidden"  	id="TotalConsumidoPeriodo"	value="#valueTotalConsumidoPeriodo#"/>
		<input name="CurrentPage" 			type="hidden" 	id="CurrentPage"			value="#CurrentPage#"/>
		<input name="MCPeriodoPlanC"		type="hidden"  	id="MCPeriodoPlanC"			value="#valueMCPeriodoPlanC#"/>
		<cfset tieneOrden = false>
		<cfif ModoDet EQ 'CAMBIO'>
			<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#DetalleEst.ts_rversion#" returnvariable="ts"></cfinvoke>
			<input name="ts_rversion"			type="hidden" 	id="ts_rversion"			value="#ts#">
			<cfquery name="rsOrdenCM" datasource="#session.DSN#">
				select distinct b.EOidorden
				from FPDEstimacion a
					inner join DOrdenCM b
						on b.PCGDid = a.PCGDid and b.Ecodigo = a.Ecodigo
					inner join EOrdenCM c
						on c.EOidorden = b.EOidorden
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				 and a.FPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DetalleEst.FPDEid#">
			</cfquery>
			<cfif rsOrdenCM.recordcount gt 0>
				<cfset tieneOrden = true>
			</cfif>
			<cfif EncabezadoEst.FPTVTipo neq -1 and len(trim(DetalleEst.PCGDid)) eq 0>
				<input name="VariacionNueva" type="hidden" id="VariacionNueva" value="true">
			</cfif>
		<cfelseif isdefined('esVariacion')>
			<input name="VariacionNueva" type="hidden" id="VariacionNueva" value="false">
		</cfif>
		<cfif isdefined('form.Equilibrio')>
			<input name="Equilibrio"			type="hidden" 	id="Equilibrio"			value="true">
		</cfif>
		<table border="0" width="100%">
			<cfif (EncabezadoEst.FPTVTipo eq '2' or EncabezadoEst.FPTVTipo eq '3') and PlantillasCF.FPCCtipo eq 'I'>
			<tr><td align="center"><strong>En la variación <cfif isdefined('rsVariacion')>"#rsVariacion.FPTVDescripcion#"</cfif> no se puede editar las plantillas de ingresos.</strong>
			</tr><td>
			<cfelse>
			<tr>
				<cfif tieneOrden>
					<td align="center">&nbsp;</td>
				</cfif>
				<cfif not esSuminitroConCF>
				<td align="center">Descripción</td>
				<td align="center">Justificación</td>
				</cfif>
			<cfif PlantillasCF.PCGDxPlanCompras eq '1'>
				<td align="center">N° Contratación</td>
			</cfif>
			<cfif ListFind('P', Arguments.FPCCconcepto)>	
				<td align="center">Obra en Construcción</td>
			</cfif>	
			<cfif ListFind('A', Arguments.FPCCconcepto)>
				<td align="center">Articulo</td>
			</cfif>
			<cfif ListFind('S,P', Arguments.FPCCconcepto)>
				<td align="center">Concepto de servicios</td>
			</cfif>
			<cfif ListFind(ListFPCCconcepto, Arguments.FPCCconcepto)>
				<td align="center" nowrap>Concepto Ingresos y Egresos</td>
			</cfif>
				<cfif Activo>
				<td align="center">Complemento Actividad</td>
				</cfif>
				<td align="center" id="Eti_DPDEfechaIni_ALL">Fecha Inicial</td>
				<td align="center" id="Eti_DPDEfechaFin_ALL">Fecha Final</td>
				<td align="center">Moneda</td>
				<td align="center">Tipo de Cambio</td>
			<cfif ListFind(ExigeUnidad, Arguments.FPCCconcepto)>
				<td align="center">Unidad</td>
			</cfif>
			<cfif ListFind('P,S', Arguments.FPCCconcepto)>	
				<td align="center">Monto Mínimo</td>
			</cfif>
			<cfif controlaCantidad>
				<td align="center">Cantidad <cfif not esMultiperido> Periódo</cfif></td>
				<cfif lvarMostrarCamposLigadosPCG>
				<td align="center">Cantidad Ajuste</td>
				</cfif>
			</cfif>
				<td align="center">Monto <cfif controlaCantidad>Unitario<cfelse>Total</cfif></td>
			<cfif lvarMostrarCamposLigadosPCG>
				<td align="center">Monto Ajuste</td>
			</cfif>
			<cfif controlaCantidad and esMultiperido>
				<td align="center">Cantidad Periódo</td>
				<td align="center">Cantidad Futura</td>
			</cfif>
				<td align="center">Monto Periódo</td>
			<cfif esMultiperido>
				<td align="center">Monto Futuro</td>
			</cfif>
			<cfif len(trim(EncabezadoEst.FPTVTipo)) and  ModoDet EQ 'CAMBIO' and DetalleEst.LigadoPCG>
				<td align="center">Autorizado Total</td>
				<td align="center">Consumido Total</td>
				<td align="center">Diferencia</td>
			</cfif>
			<cfif len(trim(EncabezadoEst.FPTVTipo)) and  ModoDet EQ 'CAMBIO' and esMultiperido and DetalleEst.LigadoPCG>
				<td align="center">Autorizados Anteriores</td>
			</cfif>
				<td align="center"></td>
			</tr>
			<tr>
				<cfif tieneOrden>
					<td align="center">
					<input name="Orden" title="Ver Ordenes de Compra" type="image" src="../../imagenes/find.small.png" value="OCs" alt="Ver Ordenes de Compra" width="16" height="16" border="0" onclick="return fnVerOCs('form_general',#DetalleEst.FPDEid#);">
					</td>
				</cfif>
				<cfif esSuminitroConCF>
					<input name="DPDEdescripcion_ALL"   onclick="openPopUp('D',<cfif ModoDet EQ 'CAMBIO' and DetalleEst.LigadoPCG>false<cfelse>true</cfif>)" id="DPDEdescripcion_ALL"   type="hidden" <cfif ModoDet EQ 'CAMBIO'>value="#DetalleEst.DPDEdescripcion#"<cfelseif isdefined('btnFiltrar_ALL')>value="#form.DPDEdescripcion_ALL#"</cfif><cfif ModoDet EQ 'CAMBIO' and DetalleEst.LigadoPCG>style="border:solid 1px ##CCCCCC; background:inherit;"</cfif> readonly/>
					<input name="DPDEjustificacion_ALL" onclick="openPopUp('J',<cfif ModoDet EQ 'CAMBIO' and DetalleEst.LigadoPCG>false<cfelse>true</cfif>)" id="DPDEjustificacion_ALL" type="hidden" <cfif ModoDet EQ 'CAMBIO'>value="#DetalleEst.DPDEjustificacion#"<cfelseif isdefined('btnFiltrar_ALL')>value="#form.DPDEjustificacion_ALL#"</cfif> <cfif ModoDet EQ 'CAMBIO' and DetalleEst.LigadoPCG>style="border:solid 1px ##CCCCCC; background:inherit;"</cfif> readonly/>
				<cfelse>
					<td><input name="DPDEdescripcion_ALL"   onclick="openPopUp('D',<cfif ModoDet EQ 'CAMBIO' and DetalleEst.LigadoPCG>false<cfelse>true</cfif>)" id="DPDEdescripcion_ALL"   type="text" <cfif ModoDet EQ 'CAMBIO'>value="#DetalleEst.DPDEdescripcion#"<cfelseif isdefined('btnFiltrar_ALL')>value="#form.DPDEdescripcion_ALL#"</cfif><cfif ModoDet EQ 'CAMBIO' and DetalleEst.LigadoPCG>style="border:solid 1px ##CCCCCC; background:inherit;"</cfif> readonly/></td>
					<td><input name="DPDEjustificacion_ALL" onclick="openPopUp('J',<cfif ModoDet EQ 'CAMBIO' and DetalleEst.LigadoPCG>false<cfelse>true</cfif>)" id="DPDEjustificacion_ALL" type="text" <cfif ModoDet EQ 'CAMBIO'>value="#DetalleEst.DPDEjustificacion#"<cfelseif isdefined('btnFiltrar_ALL')>value="#form.DPDEjustificacion_ALL#"</cfif> <cfif ModoDet EQ 'CAMBIO' and DetalleEst.LigadoPCG>style="border:solid 1px ##CCCCCC; background:inherit;"</cfif> readonly/></td>
				</cfif>
				<cfif PlantillasCF.PCGDxPlanCompras eq '1'>
					<td><input name="DPDEcontratacion_ALL"	id="DPDEcontratacion_ALL" type="text" size="30" <cfif ModoDet EQ 'CAMBIO'>value="#DetalleEst.DPDEcontratacion#"<cfelseif isdefined('btnFiltrar_ALL')>value="#form.DPDEcontratacion_ALL#"</cfif> <cfif ModoDet EQ 'CAMBIO' and DetalleEst.LigadoPCG>style="border:solid 1px ##CCCCCC; background:inherit;" readonly</cfif>/></td>
				</cfif>
				<cfif ListFind('P', Arguments.FPCCconcepto)>	
				<td>
					<cfif ModoDet EQ 'CAMBIO'>
						<cf_OBProyObra formName="form_general" etiqueta="" OBOid="#DetalleEst.OBOid#">
					<cfelseif isdefined('btnFiltrar_ALL')>
						<cf_OBProyObra formName="form_general" etiqueta="" OBPcodigo="#trim(form.OBPcodigo)#" OBOcodigo="#trim(form.OBOcodigo)#" esFiltro="true">
					<cfelse>
						<cf_OBProyObra formName="form_general" etiqueta="" OBOid="-1">
					</cfif>
				</td>
				</cfif>	
				<cfif ListFind('A', Arguments.FPCCconcepto)>
					<td align="center">
					<cfif isdefined('btnFiltrar_ALL') and len(trim(form.Aid_ALL))>
						<cfquery datasource="#session.dsn#" name="valueAid">
							select 	Aid as Aid_ALL, Acodigo as Acodigo_ALL, Adescripcion  as Adescripcion_ALL
							from Articulos
							where Ecodigo = #session.Ecodigo# and Aid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid_ALL#">
						</cfquery>
					</cfif>
					<cfif ModoDet EQ 'CAMBIO' and DetalleEst.LigadoPCG>
						<cf_sifarticulosPCG query="#valueAid#" size="15" id="Aid_ALL" verclasificacion="false" name="Acodigo_ALL" desc="Adescripcion_ALL" form ="form_general" style="border:solid 1px ##CCCCCC; background:inherit;" readonly="true" FPEPid="#PlantillasCF.FPEPid#" CPPid="#EncabezadoEst.CPPid#">
					<cfelse>
						<cf_sifarticulosPCG query="#valueAid#" size="15" id="Aid_ALL" verclasificacion="false" name="Acodigo_ALL" desc="Adescripcion_ALL" form ="form_general" FuncJSalCerrar="funcionArticulo()" FPEPid="#PlantillasCF.FPEPid#" CPPid="#EncabezadoEst.CPPid#">
				 	</cfif>
					</td>
			  </cfif>
				 <cfif ListFind('S,P', Arguments.FPCCconcepto)>
				 	<cfif isdefined('btnFiltrar_ALL') and len(trim(form.Cid_ALL))>
						<cfquery datasource="#session.dsn#" name="valueCid">
							select 	Cid as Cid_ALL, Ccodigo as Ccodigo_ALL, Cdescripcion  as Cdescripcion_ALL
							from Conceptos
							where Ecodigo = #session.Ecodigo# and Cid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid_ALL#">
						</cfquery>
					</cfif>
					<td align="center">
					<cfif ModoDet EQ 'CAMBIO' and DetalleEst.LigadoPCG>
						<cf_sifconceptosPCG query="#valueCid#" size="15" id="Cid_ALL" verclasificacion="false" name="Ccodigo_ALL" desc="Cdescripcion_ALL" form ="form_general" style="border:solid 1px ##CCCCCC; background:inherit;" readonly="true" FPEPid="#PlantillasCF.FPEPid#">
					<cfelse>
						<cf_sifconceptosPCG query="#valueCid#" size="15" id="Cid_ALL" verclasificacion="false" name="Ccodigo_ALL" desc="Cdescripcion_ALL" form ="form_general" FuncJSalCerrar="funcionServicio()" FPEPid="#PlantillasCF.FPEPid#">
					</cfif>
					</td>
				</cfif>
				<cfif ListFind('A,S,P', Arguments.FPCCconcepto)>
					<iframe name="iframeEstimacion" id="iframeEstimacion" marginheight="0" marginwidth="10" frameborder="0" height="200" width="500" scrolling="auto" style="display:none"></iframe>
					<input name="FPCCExigeFecha_ALL" id="FPCCExigeFecha_ALL" type="hidden" value="<cfif ModoDet EQ 'CAMBIO'>#DetalleEst.FPCCExigeFecha#<cfelse>0</cfif>"/>
				<cfelseif  ListFind(ListFPCCconcepto, Arguments.FPCCconcepto)>
					<cfif isdefined('btnFiltrar_ALL') and len(trim(form.FPCid_All)) and len(trim(form.FPCdescripcion_All)) and len(trim(form.FPCdescripcion_All)) and len(trim(form.FPCCExigeFecha_All))>
						<cfset valueFPCid = "#form.FPCid_All#,#form.FPCcodigo_All#,#replace(form.FPCdescripcion_All,',','')#,#form.FPCCExigeFecha_All#">
					</cfif>
					<td align="center">
						<cfif ModoDet EQ 'CAMBIO' and DetalleEst.LigadoPCG>
							<cfset readonly=true>
						<cfelse>
							<cfset readonly=false>
						</cfif>
						<cf_conlis
						Campos="FPCid_ALL, FPCcodigo_ALL, FPCdescripcion_ALL,FPCCExigeFecha_ALL"
						values="#valueFPCid#"
						Desplegables="N,S,S,N"
						Modificables="N,S,N,N"
						Size="0,10,30,0"
						Title="Lista de Conceptos"
						Tabla="FPConcepto a inner join FPCatConcepto b on b.FPCCid =  a.FPCCid"
						Columnas="FPCid as FPCid_ALL, 
								  FPCcodigo as FPCcodigo_ALL, 
								  FPCdescripcion as FPCdescripcion_ALL,
								  FPCCExigeFecha as FPCCExigeFecha_ALL"
						Filtro="a.Ecodigo = #Session.Ecodigo# #filtro#
						order by FPCcodigo, FPCdescripcion"
						Desplegar="FPCcodigo_ALL, FPCdescripcion_ALL"
						Etiquetas="Código,Descripción"
						filtrar_por="FPCcodigo, FPCdescripcion"
						Formatos="S,S"
						Align="left,left"
						Asignar="FPCid_ALL, FPCcodigo_ALL, FPCdescripcion_ALL,FPCCExigeFecha_ALL"
						Asignarformatos="I,S,S,I"
						form="form_general"
						funcion="fnExigeFechas"
						readonly="#readonly#"/>
					</td>
				</cfif>
				<cfif ModoDet EQ 'CAMBIO' and DetalleEst.LigadoPCG>
					<cfset style="border:solid 1px ##CCCCCC; background:inherit;">
					<cfset readonly=true>
				<cfelse>
					<cfset style="">
					<cfset readonly=false>
				</cfif>
				<cfif Activo>
				<td align="center" nowrap>
					<cfif ModoDet EQ 'CAMBIO'>
						<cfif ModoDet EQ 'CAMBIO' and DetalleEst.LigadoPCG>
							<cfset readonly=true>
							<cfset style="border:solid 1px ##CCCCCC; background:inherit;">
						<cfelse>
							<cfset readonly=false>
							<cfset style="">
						</cfif>
						 <cfset readonly = readonly or PlantillasCF.FPEPnomodifica eq 1>
						<cf_ActividadEmpresa MostrarTipo="#PlantillasCF.FPCCtipo#" etiqueta="" name="CFComplemento_ALL" formname="form_general" idActividad="#DetalleEst.FPAEid#" valores="#DetalleEst.CFComplemento#" readonly="#readonly#" style="#style#">
					<cfelseif isdefined('btnFiltrar_ALL')>
						<cfif not len(trim(form.CFComplemento_ALLId))>
							<cfset form.CFComplemento_ALLId = -1>
						</cfif>
						<cf_ActividadEmpresa MostrarTipo="#PlantillasCF.FPCCtipo#" etiqueta="" name="CFComplemento_ALL" formname="form_general" idActividad="#form.CFComplemento_ALLId#" valores="#form.CFComplemento_ALL#" readonly="#PlantillasCF.FPEPnomodifica eq 1#">
					<cfelse>
						<cfif len(trim(PlantillasCF.FPAEid)) and len(trim(PlantillasCF.CFComplemento))>
							<cf_ActividadEmpresa MostrarTipo="#PlantillasCF.FPCCtipo#" etiqueta="" name="CFComplemento_ALL" formname="form_general" idActividad="#PlantillasCF.FPAEid#" valores="#PlantillasCF.CFComplemento#" readonly="#PlantillasCF.FPEPnomodifica eq 1#">
						<cfelse>
							<cf_ActividadEmpresa MostrarTipo="#PlantillasCF.FPCCtipo#" etiqueta="" name="CFComplemento_ALL" formname="form_general" readonly="#PlantillasCF.FPEPnomodifica eq 1#">
						</cfif>
					</cfif>
				</td>
				</cfif>
					<td id="Cnt_DPDEfechaIni_ALL"><cf_sifcalendario name="DPDEfechaIni_ALL" form ="form_general" value="#valueDPDEfechaIni#" style="#style#" readonly="#readonly#"></td>
					<td id="Cnt_DPDEfechaFin_ALL"><cf_sifcalendario name="DPDEfechaFin_ALL" form ="form_general" value="#valueDPDEfechaFin#" style="#style#" readonly="#readonly#"></td>
					<td>
				<cfif ModoDet EQ 'CAMBIO' and DetalleEst.LigadoPCG>
					<input name="Mcodigo_ALL" id="Mcodigo_ALL" type="hidden" value="#valueMcodigo.Mcodigo#" />
					<cf_sifmonedas frame="frame2"  Mcodigo="S_Mcodigo_ALL" form ="form_general" query="#valueMcodigo#" habilita="N">
				<cfelse>
					<cfif esSuminitroConCF>
						<input name="Mcodigo_ALL" id="Mcodigo_ALL" type="hidden" value="#valueMcodigo.Mcodigo#" />
						<cf_sifmonedas frame="frame2"  Mcodigo="S_Mcodigo_ALL" form ="form_general" value="#valueMcodigo.Mcodigo#" habilita="N">
					<cfelse>
						<cf_sifmonedas frame="frame2"  Mcodigo="Mcodigo_ALL" form ="form_general" onchange="sugerirTC('_ALL');" Todas="S" value="#valueMcodigo.Mcodigo#">
					</cfif>
				</cfif>
					</td>
					<td>
				<cfif ModoDet EQ 'CAMBIO' and DetalleEst.LigadoPCG>
					<cf_monto name="Dtipocambio_ALL"  decimales="4" size="11" form ="form_general" value="#valueDtipocambio#" readonly="true"  style="border:solid 1px ##CCCCCC; background:inherit;">
				<cfelse>
					<cfif valueMcodigo.Mcodigo eq rsMonedaLocal.Mcodigo>
						<cfset readonly=false>
					</cfif>
					<cf_monto name="Dtipocambio_ALL"  decimales="4" size="11" form ="form_general" value="#valueDtipocambio#">
				</cfif>
					</td>
				<cfif controlaCantidad>
					<cfset funcion="fnObtenerFuturo(this,this.form,this.form.DPDEcantidad_ALL,this.form.DPDEcantidadPeriodo_ALL,this.form.DPDEcantidadPeriodoFuturo_ALL,this.form.DPDEcosto_ALL.value,true)">
				<cfelse>
					<cfset funcion="fnObtenerFuturo(this,this.form,this.form.DPDEcantidad_ALL,this.form.DPDMontoTotalPeriodo_ALL,this.form.DPDMontoTotalPeriodoFuturo_ALL,this.form.DPDEcosto_ALL.value,false)">
				</cfif>
				<cfif ListFind(ExigeUnidad, Arguments.FPCCconcepto)>
					<td align="center">
						<cfif Arguments.FPCCconcepto EQ 'A'>
							<cfset Filtro=" and Utipo in (0,2)">
						<cfelse>
							<cfset Filtro=" and Utipo in (1,2)">
						</cfif>
						<cfif isdefined('btnFiltrar_ALL') and len(trim(form.Ucodigo_ALL))>
							<cfquery datasource="#session.dsn#" name="valueUcodigo">
								select Ucodigo as Ucodigo_ALL, Ucodigo as UcodigoD_ALL, Udescripcion as Udescripcion_ALL
								from Unidades
								where Ecodigo = #session.Ecodigo# and Ucodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ucodigo_ALL#">
							</cfquery>
						</cfif>
						<cfif listfind('A,S,P', Arguments.FPCCconcepto)>
							<cfset readonly="true">
						<cfelse>
							<cfset readonly="false">
						</cfif>
						<cfif ModoDet EQ 'CAMBIO' and DetalleEst.LigadoPCG>
							<cf_sifunidades filtroextra="#Filtro#" id="Ucodigo_ALL" form="form_general" size="15" name="UcodigoD_ALL" desc="Udescripcion_ALL" query="#valueUcodigo#" readonly="true"  style="border:solid 1px ##CCCCCC; background:inherit;">
						<cfelse>
							<cf_sifunidades filtroextra="#Filtro#" id="Ucodigo_ALL" form="form_general" size="15" name="UcodigoD_ALL" desc="Udescripcion_ALL" query="#valueUcodigo#" readonly="#readonly#">
						</cfif>
					</td>
				</cfif>
				<cfif ListFind('P,S', Arguments.FPCCconcepto)>
					<cfset readonly = iif(ModoDet EQ 'CAMBIO' and DetalleEst.LigadoPCG,true,false)>
					<td><cf_monto name="DPDEmontoMinimo_ALL" decimales="2" size="22" form ="form_general" value="#valueDPDEmontoMinimo#" onChange="#funcion#" ></td>
				</cfif>
				<cfif controlaCantidad>
					<td><cf_monto name="DPDEcantidad_ALL" decimales="0" size="9" form ="form_general" value="#valueDPDEcantidad#" onChange="#funcion#"></td>
					<cfif lvarMostrarCamposLigadosPCG>
					<td><cf_inputNumber  name="DPDEcantidadAjuste_ALL" form="form_general" decimales="0" enteros="9" value="#valueDPDECantidadAjuste#" onChange="#funcion#" negativos="true" comas="false"></td>
					</cfif>
				<cfelse>
					<input name="DPDEcantidad_ALL" id="DPDEcantidad_ALL" type="hidden" value="1" />
				</cfif>
				<td>
				<cfif (ModoDet EQ 'CAMBIO' and DetalleEst.LigadoPCG and controlaCantidad) or ListFind('A', Arguments.FPCCconcepto)>
					<cfset readonly=true>
					<cfset style="border:solid 1px ##CCCCCC; background:inherit;">
				<cfelse>
					<cfset readonly=false>
					<cfset style="">
				</cfif>
				<cfif controlaCantidad>
					<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
					<cfset LvarOBJ_PrecioU.inputNumber("DPDEcosto_ALL",valueDPDEcosto,"",readonly,"",style,"",funcion)>
				<cfelse>
					<cf_monto name="DPDEcosto_ALL" form="form_general" decimales="4" size="22" value="#numberformat(valueDPDEcosto,'9.0000')#" onChange="#funcion#" readonly="#readonly#" style="#style#">
				</cfif>
				</td>
				<cfif lvarMostrarCamposLigadosPCG>
					<td align="center"><cf_monto name="DPDEmontoAjuste_ALL" form="form_general" decimales="4" size="22" value="#valueDPDEmontoAjuste#" onChange="#funcion#" negativos="true" readonly="#controlaCantidad#"></td>
				<cfelse>
					<input name="DPDEmontoAjuste_ALL" id="DPDEmontoAjuste_ALL" type="hidden" value="#valueDPDMontoTotalPeriodo#">
				</cfif>
				<cfset soloLectura="true">
				<cfif controlaCantidad>
					<cfif esMultiperido>
						<td align="center"><cf_monto name="DPDEcantidadPeriodo_ALL" decimales="0" size="9" form ="form_general" value="#valueDPDEcantidadPeriodo#" onChange="#funcion#"></td>
						<td align="center"><cf_monto name="DPDEcantidadPeriodoFuturo_ALL" decimales="0" size="9" form ="form_general" readonly="true" value="#valueDPDEcantidad-valueDPDEcantidadPeriodo#"></td>
					<cfelse>
						<input name="DPDEcantidadPeriodo_ALL" id="DPDEcantidadPeriodo_ALL" type="hidden" value="#valueDPDEcantidadPeriodo#" />
						<input name="DPDEcantidadPeriodoFuturo_ALL" id="DPDEcantidadPeriodoFuturo_ALL" type="hidden" value="#valueDPDEcantidad-valueDPDEcantidadPeriodo#" />
					</cfif>
				<cfelseif esMultiperido>
					<cfset soloLectura="false">
				</cfif>
				<td align="center"><cf_monto name="DPDMontoTotalPeriodo_ALL" decimales="4" size="22" form ="form_general" readonly="#soloLectura#" value="#valueDPDMontoTotalPeriodo#" onChange="#funcion#"></td>
				<cfif esMultiperido>
					<td align="center"><cf_monto name="DPDMontoTotalPeriodoFuturo_ALL" decimales="4" size="22" form ="form_general" readonly="true" value="#valueDPDEcantidad*valueDPDEcosto-valueDPDMontoTotalPeriodo#"></td>
				<cfelse>
					<input name="DPDMontoTotalPeriodoFuturo_ALL" id="DPDMontoTotalPeriodoFuturo_ALL" type="hidden" value="#valueDPDEcantidad*valueDPDEcosto-valueDPDMontoTotalPeriodo#" />
				</cfif>
				<cfif len(trim(EncabezadoEst.FPTVTipo)) and  ModoDet EQ 'CAMBIO' and DetalleEst.LigadoPCG>
					<cfparam name="Request.jsPopupDiv" default="false">
					<cfif Request.jsPopupDiv EQ false>
						<cfset Request.jsPopupDiv = true>
						<script type="text/javascript" src="/cfmx/sif/js/popupDiv.js"></script>
					</cfif>
					<style>
						.totales {
							position: absolute;
							visibility: hidden;
							width: 270px;
							height: 85px;
							background-color: ##ccc;
							border: 1px solid ##000;
							padding: 10px;
							text-align:left;
						}
					</style>
				<td align="center"><cf_monto name="DPDMontoAutorizadoTotal_ALL" decimales="4" size="22" form ="form_general" readonly="true" value="#valuePPCGDautorizadoTotal#"></td>
				<td align="center"><div id="totalCosuimido" class="totales" style="overflow:auto;" onmouseout="setVisible('totalCosuimido');"><strong>Reservado:</strong>&nbsp;#valuePCGDreservado#<br /><strong>Comprometido:</strong>&nbsp;#valuePCGDcomprometido#<br /><strong>Ejecutado:</strong>&nbsp;#valuePCGDejecutado#<br /><strong>Autorizado Periódos Ant.:</strong>&nbsp;#numberformat(valuePCGDautorizadoAnteriores,'9.0000')#<br /><strong>Pendientes:</strong>&nbsp;#valuePCGDpendiente#<br /><strong>Total:</strong>&nbsp;#numberformat(valueTotalConsumidoNeto,',9.0000')#</div>
				<input id="DPDMontoCosumidoTotal_ALL" name="DPDMontoCosumidoTotal_ALL" value="#numberformat(valueTotalConsumidoNeto,',9.0000')#" onmouseover="setVisible('totalCosuimido');" style="border:solid 1px ##CCCCCC; background:inherit; text-align:right" readonly/></td>
				<td align="center"><cf_monto name="DPDMontoDiferienciaTotal_ALL" decimales="4" size="22" form ="form_general" readonly="true" value="#numberformat(valuePPCGDautorizadoTotal-valueTotalConsumidoNeto,',9.0000')#"></td>
				</cfif>
				<cfif EncabezadoEst.FPTVTipo neq '-1' and  ModoDet EQ 'CAMBIO' and esMultiperido and DetalleEst.LigadoPCG>
				<td align="center"><cf_monto name="PCGDautorizadoAnteriores_ALL" decimales="4" size="22" form ="form_general" readonly="true" value="#valuePCGDautorizadoAnteriores#"></td>
				</cfif>
				<td>&nbsp;</td>
			  </tr>
				<tr>
				<td colspan="5">
					<cfif ModoDet NEQ 'CAMBIO'>
						<input name="btnAgregar_ALL" value="Agregar" class="btnGuardar" type="submit" onclick="return agregar('form_general');" />
					<cfelse>
						<input name="btnModificar_ALL" value="Modificar" class="btnGuardar" type="submit" onclick="return agregar('form_general');"/>
					</cfif>
					<input name="btnNuevo_ALL" 		value="Nuevo" 	class="btnNuevo" 	type="submit" onclick="return deshabilitar();"/>
					<cfif ModoDet NEQ 'CAMBIO'>
						<input name="btnFiltrar_ALL" 	value="Filtrar" class="btnFiltrar" 	type="submit" onclick="return fnFiltrar()" title="Filtro x: Desc, Just, Act, F. Ini, F. Fin Art, Mon, Uni."/>
					</cfif>
					<cfif ListFind('A', Arguments.FPCCconcepto)>
						<input name="btnDescargar_Inventario_ALL" value="Descargar Listado de Inventario" class="btnGuardar" type="button" onclick="return fnDescargar_Inventario()"/>
					</cfif>
				</td>	
			</tr>
		</cfif>
		</table>
	</form>
</cfoutput>
</cffunction>
<cfif Clasificaciones.recordCount GT 0>
   <script language="javascript1.2" type="text/javascript">
   		
	var validarCampos = true;
	var hacerSumbmit = false;
	<cfif ModoDet NEQ 'CAMBIO'>
		function fnFiltrar(){
			hacerSumbmit = true;
			validarCampos = false;
			var inp 	= document.createElement('input');
			inp.type	= "hidden";
			inp.name	= "FPEEid";
			inp.id		= "FPEEid";
			inp.value	= document.form_general.FPEEid_ALL.value;
			document.form_general.appendChild(inp);
			var inp 	= document.createElement('input');
			inp.type	= "hidden";
			inp.name	= "FPEPid";
			inp.id		= "FPEPid";
			inp.value	= document.form_general.FPEPid_ALL.value;
			document.form_general.appendChild(inp);
			document.form_general.action="<cfoutput>#CurrentPage#</cfoutput>";
		}
	</cfif>
	function deshabilitar(){
		validarCampos = false;
		hacerSumbmit = true;
		return true;
	}
	
	function agregar(formname){
		msjError = "";
		param = "";
		ext = '_ALL'
		listVal = "<cfoutput>#ListFPCCconcepto#</cfoutput>";
		if (document.getElementById("DPDEdescripcion_ALL").value == '')
			msjError = msjError+"- El campo Descripción es requerido.\n";
		if (document.getElementById("DPDEjustificacion_ALL").value == '')
			msjError = msjError+"- El campo Justificación es requerido.\n";
		if (document.getElementById("CFComplemento_ALLId").value == '')
			msjError = msjError+"- El campo Actividad es requerido.\n";
		if (listVal.indexOf(document.getElementById("FPCCconcepto_ALL").value) != -1 && document.getElementById("FPCid_ALL").value == '')
			msjError = msjError+"- El campo Concepto Ingresos y Egresos es requerido.\n";
		if (document.getElementById("Dtipocambio_ALL").value == '')
			msjError = msjError+"- El campo Tipo Cambio es requerido.\n";	
		if (parseInt(document.getElementById("Dtipocambio_ALL").value) == '0')
			msjError = msjError+"- El campo Tipo Cambio debe ser mayor a 0.\n";
		if (document.getElementById("DPDEcantidad_ALL").value == '')
			msjError = msjError+"- El campo cantidad es requerido.\n";
		if (parseInt(document.getElementById("DPDEcantidad_ALL").value) == '0')
			msjError = msjError+"- El campo cantidad debe de ser mayor a 0.\n";
		if (document.getElementById("DPDEcosto_ALL").value == '')
			msjError = msjError+"- El campo Precio Unitario es requerido.\n";
<!----  if (parseInt(document.getElementById("DPDEcosto_ALL").value) == '0'){
			msjError = msjError+"- El campo monto unitario debe de ser mayor a 0.\n";
			document.getElementById("DPDEcosto_ALL").value = 1;} ---->
		if (document.getElementById('FPCCExigeFecha_ALL') && document.getElementById('FPCCExigeFecha_ALL').value == 1 && document.getElementById("DPDEfechaIni_ALL").value == '')
			msjError = msjError+"- El campo fecha inicial es requerido.\n";	
		if (document.getElementById('FPCCExigeFecha_ALL') && document.getElementById('FPCCExigeFecha_ALL').value == 1 && document.getElementById("DPDEfechaFin_ALL").value == '')
			msjError = msjError+"- El campo fecha fin es requerido.\n";
		if(document.getElementById('FPCCExigeFecha_ALL') && document.getElementById('FPCCExigeFecha_ALL').value == 1 && ! validarFechas(ext))	
			msjError = msjError+"- El campo fecha inicial es debe de ser menor o igual a fecha final.\n";
		if ((document.getElementById("FPCCconcepto_ALL").value == 'S' || document.getElementById("FPCCconcepto_ALL").value == 'P') && document.getElementById("Cid_ALL").value == '')
			msjError = msjError+"- El campo Concepto de Servicio es requerido.\n";	
		if (document.getElementById("FPCCconcepto_ALL").value == 'A' && document.getElementById("Aid_ALL").value == '')
			msjError = msjError+"- El campo Articulo es requerido.\n";	
		if ((document.getElementById("FPCCconcepto_ALL").value == 'A' || document.getElementById("FPCCconcepto_ALL").value == 'S' || document.getElementById("FPCCconcepto_ALL").value == 'P' || document.getElementById("FPCCconcepto_ALL").value == 'F') && document.getElementById("Ucodigo_ALL").value == '')
			msjError = msjError+"- El campo Unidad es requerido.\n";
		if (document.getElementById("CFComplemento_ALL").value == '')
			msjError = msjError+"- El campo Complemento Actividad es requerido.\n";
		if (document.getElementById("Mcodigo_ALL").value == '-1')
			msjError = msjError+"- El campo Moneda es requerido.\n";	
		if (document.getElementById("FPCCconcepto_ALL").value == 'P' && document.getElementById("OBOid").value=='' )
			msjError = msjError+"- El campo Obra en Contrucción es requerido.\n";
		if (!document.getElementById("Activo").value)
			msjError = msjError+document.getElementById("Activo").value+"- Parametro 'Activar Transaccionabilidad de Actividad Empresarial' en Parámetros Generales esta desactivado, debe de activarlo para continuar.\n";
		if (msjError != ""){
			alert("Se presentaron los siguientes errores:\n"+msjError);
			hacerSumbmit = false;
			return false;
		}else{
			document.getElementById('Dtipocambio_ALL').disabled = false;
			document.getElementById(formname).action = "EstimacionGI-sql.cfm"+param;
			hacerSumbmit = true;
			return true;	
		}
	}
	
	function DisplayNote(FPEEid,FPEPid,FPDElinea){
		var PARAM  = "EstimacionGINota-popUp.cfm?FPEEid="+FPEEid+"&FPEPid="+FPEPid+"&FPDElinea="+FPDElinea+'&RolAdmin='+<cfoutput>#request.RolAdmin#</cfoutput>;
		if(popup_win){
			if(!popup_win.closed)
				popup_win.close();
		}
		popup_win = window.open(PARAM,'','left=250,top=250,scrollbars=no,resizable=no,width=440,height=300')
		return false;
	}
	
	function fnVerOCs(f,FPDEid){
		document.forms[f].nosubmit = true;
		param  = "EstimacionGIOCs-popUp.cfm?FPDEid="+FPDEid;
		if(popup_win){
			if(!popup_win.closed)
				popup_win.close();
		}
		popup_win = window.open(param,'Ordenes de Compra','left=250,top=250,scrollbars=no,resizable=no,width=440,height=300')
		return false;
	}
	
	function changeFormActionforDetalles(FPEEid,FPEPid,FPDElinea,FPCCid) {
		e = document.getElementById('form_'+FPEEid+'_'+FPEPid+'_'+FPCCid);
		e.nosubmit = "false";
		if (confirm('¿Desea Eliminar la linea de detalle?')){
			param    = "?btnEliminar=true&FPEEid="+FPEEid+"&FPEPid="+FPEPid+"&FPDElinea="+FPDElinea+"&CurrentPage=<cfoutput>#CurrentPage#</cfoutput>";
			e.action = "EstimacionGI-sql.cfm"+param;
			document.getElementById('form_'+FPEEid+'_'+FPEPid+'_'+FPCCid).submit();
			return true;
		}
		else
			return false;
	}
	function validarFechas(ext){
		fIni = document.getElementById('DPDEfechaIni'+ext).value;
		fFin = document.getElementById('DPDEfechaFin'+ext).value;
		return fnValidarEntrefechas(fIni,fFin);
	}
	
	function fnValidarEntrefechas(fIni,fFin){
		f1 = fIni.substr(6,4)+fIni.substr(3,2)+fIni.substr(0,2);
		f2 = fFin.substr(6,4)+fFin.substr(3,2)+fFin.substr(0,2);
		if(f1 <= f2){
			return true;
		}
		return false;
	}
	
	function fnCambioFecha(form){
		if(fnValidarEntrefechas(form.fechaIni.value,form.fecha.value))
			msg = 'Está seguro que desea modificar la fecha límite de la Transacción';
		else
			msg = 'La fecha selecionada es menor a la actual, está seguro que desea modificar la fecha límite de la Transacción';
		return (confirm(msg)?true:false);
	}
	
	function fnExigeFechas(){
		if(document.getElementById('FPCCExigeFecha_ALL') && document.getElementById('FPCCExigeFecha_ALL').value == '1'){
			document.getElementById('Cnt_DPDEfechaIni_ALL').style.display = '';
			document.getElementById('Eti_DPDEfechaIni_ALL').style.display = '';
			document.getElementById('Cnt_DPDEfechaFin_ALL').style.display = '';
			document.getElementById('Eti_DPDEfechaFin_ALL').style.display = '';
		}else if (document.getElementById('FPCCExigeFecha_ALL') && (document.getElementById('FPCCExigeFecha_ALL').value == '0' || document.getElementById('FPCCExigeFecha_ALL').value == '')){
			document.getElementById('Cnt_DPDEfechaIni_ALL').style.display = 'none';
			document.getElementById('Eti_DPDEfechaIni_ALL').style.display = 'none';
			document.getElementById('Cnt_DPDEfechaFin_ALL').style.display = 'none';
			document.getElementById('Eti_DPDEfechaFin_ALL').style.display = 'none';
		}
	}
	
	function sugerirTC(ext) {		
		m = document.getElementById('Mcodigo'+ext);
		tc = document.getElementById('Dtipocambio'+ext);
		if(! m || ! tc)
			return;
		tc.disabled = false;
		if(m.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>")  {
			tc.value = "1.00";
			tc.disabled = true;	
		}else{
			<cfwddx action="cfml2js" input="#TCsug#" topLevelVariable="rsTCsug"> 
			//Verificar si existe en el recordset
			var nRows = rsTCsug.getRowCount();
			if(nRows > 0){
				for(row = 0; row < nRows; ++row){
					if (rsTCsug.getField(row, "Mcodigo") == m.value){
						tc.value = rsTCsug.getField(row, "TCcompra");
						break;
					}else
						tc.value = "0.00";					
				}
			}else
				tc.value = "0.00";
		}
	}
	
	function traerExigeFecha(tipo){
		if(tipo == "A")
			id = document.form_general.Aid_ALL.value;
		else if(tipo == "S")
			id = document.form_general.Cid_ALL.value;
		document.getElementById('iframeEstimacion').src="/cfmx/sif/formulacion/operacion/iframeEstimacion.cfm?form=form_general&name=FPCCExigeFecha_ALL&tipo="+tipo+"&id="+id+"&funcion=fnExigeFechas()";
	}
	
	function funcionServicio(){
		traerExigeFecha('S');
		id = document.form_general.Cid_ALL.value;
		document.getElementById('iframeEstimacion').src="/cfmx/sif/formulacion/operacion/iframeEstimacion.cfm?form=form_general&UnidadName=UcodigoD_ALL&tipo=S&id="+id;
	}
	
	function funcionArticulo(){
		traerExigeFecha('A');
		texto = document.form_general.Acodigo_ALL.value+"-"+document.form_general.Adescripcion_ALL.value;
		document.form_general.DPDEdescripcion_ALL.value = texto;
		document.form_general.DPDEjustificacion_ALL.value = texto;
		<cfif controlaCantidad>
			<cfset funcionArt="fnObtenerFuturo(window.parent.document.form_general.Acodigo_ALL,window.parent.document.form_general,window.parent.document.form_general.DPDEcantidad_ALL,window.parent.document.form_general.DPDEcantidadPeriodo_ALL,window.parent.document.form_general.DPDEcantidadPeriodoFuturo_ALL,window.parent.document.form_general.DPDEcosto_ALL.value,true)">
		<cfelse>
			<cfset funcionArt="fnObtenerFuturo(window.parent.document.form_general.Acodigo_ALL,window.parent.document.form_general,window.parent.document.form_general.DPDEcantidad_ALL,window.parent.document.form_general.DPDMontoTotalPeriodo_ALL,window.parent.document.form_general.DPDMontoTotalPeriodoFuturo_ALL,window.parent.document.form_general.DPDEcosto_ALL.value,false)">
		</cfif>
		id = document.form_general.Aid_ALL.value;
		document.getElementById('iframeEstimacion').src="/cfmx/sif/formulacion/operacion/iframeEstimacion.cfm?form=form_general&name=DPDEcosto_ALL&UnidadName=UcodigoD_ALL&tipo=M&CPPid=<cfoutput>#EncabezadoEst.CPPid#</cfoutput>&id="+id+"&funcion=<cfoutput>#funcionArt#</cfoutput>";
	}
	<!---
		input - cantidad o monto // this
		form  - form
		inp1  - cantidad
		inp2  - cantidad o monto periodo
		inp3  - cantidad o monto futuro
		mu    - costo unitario
		controlaCantidad - controla cantidad
	--->
	function fnObtenerFuturo(input,form,inp1,inp2,inp3,mu,controlaCantidad){
		valorAutorizado = parseFloat(<cfoutput>#valuePPCGDautorizadoTotal#</cfoutput>);
		valorMontoFuturo =  parseFloat(inp3.value.toString().replace(/,/g,''));
		mu = parseFloat(mu.toString().replace(/,/g,''));
		valorMCPPC = parseFloat(form.MCPeriodoPlanC.value); // Monto o Cantidad del Periodo segun Plan de compras
		f = parseFloat(inp3.value.toString().replace(/,/g,'')); // Monto o Cantidad futura segun estimacion
		<cfif EncabezadoEst.FPTVTipo NEQ -1>
		if(input.name == "DPDEmontoAjuste_ALL" || input.name == "DPDEcantidadAjuste_ALL"){
			ValorMCT = (controlaCantidad ? parseFloat(<cfif esMultiperido>inp2.value<cfelse>inp1.value</cfif>) : mu); // Monto o Cantidad segun Estimacion
			valorInput = parseFloat(input.value.toString().replace(/,/g,''));
			valorMontoAjuste = valorInput * (input.name == "DPDEcantidadAjuste_ALL" ? mu : 1);
			valorMM = (form.DPDEmontoMinimo_ALL ? parseFloat(form.DPDEmontoMinimo_ALL.value.toString().replace(/,/g,'')) : 0);
			if((valorMCPPC * (controlaCantidad ? mu : 1)) + valorMontoAjuste - valorMM < 0){
				valorMontoAjuste = valorInput = 0;
				input.value = fm(redondear(valorInput,4),(controlaCantidad ? 0 : 4));
			}
			<cfif not esMultiperido>
			if(input.name == "DPDEcantidadAjuste_ALL"){
				form.DPDEmontoAjuste_ALL.value = fm(valorMontoAjuste,4);
				inp1.value = fm(redondear((valorMCPPC + valorInput),0),0);
				fnObtenerFuturo(form.DPDEcantidad_ALL,form,inp1,inp2,inp3,mu,controlaCantidad);
				return;
			}else{
				inp2.value = fm(redondear(valorMCPPC + valorMontoAjuste,4),4);
				form.DPDEcosto_ALL.value = fm(redondear(valorMCPPC + valorMontoAjuste,4),4);
				mu = redondear(valorMCPPC + valorMontoAjuste,4);
				fnObtenerFuturo(form.DPDEcosto_ALL,form,inp1,inp2,inp3,mu,controlaCantidad);
				return;
			}
			<cfelse>
			if(input.name == "DPDEcantidadAjuste_ALL"){
				form.DPDEmontoAjuste_ALL.value = fm(valorMontoAjuste,4);
				inp1.value = fm(redondear(valorAutorizado / mu + valorInput,0),0);
				inp2.value = fm(redondear((valorMCPPC + valorInput),0),0);
				inp3.value = fm(0,0);
				fnObtenerFuturo(form.DPDEcantidadPeriodo_ALL,form,inp1,inp2,inp3,mu,controlaCantidad);
				return;
			}else{
				form.DPDEcosto_ALL.value = fm(redondear(valorAutorizado + valorMontoAjuste,4),4);
				inp2.value = fm(redondear(valorMCPPC + valorMontoAjuste,4),4);
				inp3.value = fm(0,4);
				fnObtenerFuturo(form.DPDMontoTotalPeriodo_ALL,form,inp1,inp2,inp3,valorAutorizado + valorMontoAjuste,controlaCantidad);
				return;
			}
				
			</cfif>
		}
		</cfif>
		t = parseFloat(inp1.value.toString().replace(/,/g,'')); // Cantidad total
		p = parseFloat(inp2.value.toString().replace(/,/g,''));
		tc = parseFloat(form.Dtipocambio_ALL.value.toString().replace(/,/g,''));
		msg = "";
		if(input.name == "DPDEcantidad_ALL"){
			<cfif EncabezadoEst.FPTVTipo neq "-1">
				if(t <cfif not controlaCantidad> * mu</cfif > - f >= 0)
					inp2.value = fm(redondear(t <cfif not controlaCantidad> * mu</cfif > - f,0),0);
				else
					inp2.value = 0;
				inp3.value = fm(redondear(t <cfif not controlaCantidad> * mu</cfif > - p,0),0);
			<cfelse>
			inp2.value = fm(redondear(input.value <cfif not controlaCantidad> * mu</cfif>,0),0);
			</cfif>
		}
		<cfif EncabezadoEst.FPTVTipo NEQ -1>
		if(mu * tc * t < parseFloat(<cfoutput>#valueTotalConsumidoBruto#</cfoutput>)){
			msg += " - El Monto Total no puede ser menor al monto Consumido Total, se procedió a establecer el monto mínimo.\n";
			inp2.value = Math.ceil(<cfoutput>#valueTotalConsumidoBruto#</cfoutput><cfif controlaCantidad>/ (mu * tc)</cfif>);
			inp1.value = inp2.value;
		}
		if(<cfif controlaCantidad>mu * tc *</cfif> p < parseFloat(<cfoutput>#valueTotalConsumidoPeriodo#</cfoutput>)){
			msg +=" - El Monto Total del Periódo no puede ser menor al monto Consumido Total del periódo, se procedió a establecer el monto minimo.\n";
			inp2.value = Math.ceil(<cfoutput>#valueTotalConsumidoPeriodo#</cfoutput><cfif controlaCantidad>/(mu * tc)</cfif>);
			inp1.value = inp2.value;
		}
		</cfif>
		if(input.name == "DPDEcosto_ALL" && !controlaCantidad){
			inp2.value = fm(redondear(mu,4),4);
		}
		if(controlaCantidad)
			valor = parseFloat(inp1.value.toString().replace(/,/g,'')) - parseFloat(inp2.value.toString().replace(/,/g,''));
		else
			valor = mu * parseFloat(inp1.value.toString().replace(/,/g,'')) - parseFloat(inp2.value.toString().replace(/,/g,''));
		if(valor < 0 ){
			<cfif controlaCantidad>
			msg +=" - La cantidad del periódo no puede ser mayor a la cantidad solicitada, se procedió a igualar las cantidades.\n";
			inp2.value = parseFloat(inp1.value.toString().replace(/,/g,''));
			form.DPDMontoTotalPeriodoFuturo_ALL.value = fm(redondear(0,4),4);
			<cfelse>
			msg +=" - El monto del periódo no puede ser mayor al monto solicitada, se procedió a igualar los montos.\n";
			inp2.value = fm(mu * parseFloat(inp1.value.toString().replace(/,/g,'')),4);
			</cfif>
			if(msg)
				alert("Se presentaron los siguientes errores:\n"+msg);
			fnObtenerFuturo(input,form,inp1,inp2,inp3,mu,controlaCantidad);
		}else{
			<cfif controlaCantidad>
			inp3.value = fm(redondear(valor,0),0);
			<cfelse>
			inp3.value = fm(redondear(valor,4),4);
			</cfif>
		}
		if(controlaCantidad){
			form.DPDMontoTotalPeriodo_ALL.value = fm(redondear(parseFloat(inp2.value.toString().replace(/,/g,'')) * mu,4),4);
			form.DPDMontoTotalPeriodoFuturo_ALL.value = fm(redondear(parseFloat(inp3.value.toString().replace(/,/g,'')) * mu,4),4);
		}
		
		if(input.name == "DPDEmontoMinimo_ALL"){
			vmm = parseFloat(input.value.toString().replace(/,/g,''));
			if(vmm > <cfif controlaCantidad>mu * </cfif> p){
				msg += " - El Monto mínimo no puede ser mayor al monto del periódo.\n";
				input.value = fm(0,4);
			}
		}else if(form.DPDEmontoMinimo_ALL){
			vmm = parseFloat(form.DPDEmontoMinimo_ALL.value.toString().replace(/,/g,''));

			if(input.name == "DPDEcosto_ALL" && !controlaCantidad &&  parseFloat(input.value.toString().replace(/,/g,'')) < vmm){
				input.value = form.DPDEmontoMinimo_ALL.value;
				inp2.value  = form.DPDEmontoMinimo_ALL.value;
				msg += " - El Monto del total no puede ser menor al monto mínimo.\n";
				if(msg)
					alert("Se presentaron los siguientes errores:\n"+msg);
				fnObtenerFuturo(input,form,inp1,inp2,inp3,input.value,controlaCantidad);
			}else{
				if(<cfif controlaCantidad>mu * </cfif> (input.name == "DPDEcantidad_ALL" ? t : p) < vmm){
					msg += " - El Monto del periódo no puede ser menor al monto mínimo.\n";
					if(msg)
						alert("Se presentaron los siguientes errores:\n"+msg);
					<cfif not controlaCantidad>
						input.value = form.DPDEmontoMinimo_ALL.value;
					<cfelse>
						form.DPDEcantidad_ALL.value = fm(redondear(vmm / mu,0),0);
						inp2.value = form.DPDEcantidad_ALL.value;
					</cfif>
					fnObtenerFuturo(input,form,inp1,inp2,inp3,mu,controlaCantidad);
				}
			}		
		}
		<cfif EncabezadoEst.FPTVTipo neq "-1">
			vMCP = parseFloat(inp2.value.toString().replace(/,/g,''));
			if(form.DPDEcantidadAjuste_ALL && controlaCantidad){
				form.DPDEcantidadAjuste_ALL.value = fm(redondear(vMCP - valorMCPPC,0),0);
			}
			form.DPDEmontoAjuste_ALL.value = fm(redondear((vMCP - valorMCPPC) * (controlaCantidad ? mu : 1),4),4);
		</cfif>
		if(msg)
			alert("Se presentaron los siguientes errores:\n"+msg);
	}
	
	var popup_win = false;
	
	function openPopUp(input,habilitar){
	
		if(popup_win){
			if(!popup_win.closed)
				popup_win.close();
		}
		if(input == 'D'){
			name = "DPDEdescripcion_ALL";
			titulo = "Descripción";
		}else{
		 	name = "DPDEjustificacion_ALL";
			titulo = "Justificación";
		}
		var PARAM  = "DesJustPopup.cfm?titulo="+titulo+"&name="+name+"&form=form_general";
		if(!habilitar)
			PARAM  += "&sololectura=true";
		popup_win = open(PARAM,'DesJustPopup','left=150,top=150,scrollbars=yes,resizable=yes,width=700,height=250');
		return false;
	}
	
	<cfif valueMcodigo.Mcodigo eq rsMonedaLocal.Mcodigo or not mododet EQ 'CAMBIO'>
		if(document.getElementById('Dtipocambio_ALL'))
			document.getElementById('Dtipocambio_ALL').disabled = true;
	</cfif>
	<cfif fechaValida>
	fnExigeFechas();
	</cfif>
	function Displaydes(desjust)
	{
		if(popup_win){
			if(!popup_win.closed)
				popup_win.close();
		}
		document.forms[desjust.form.name].nosubmit = true;
		param = 'DesJustPopup.cfm?sololectura=true&value='+desjust.value+'&titulo='+desjust.title; 
		popup_win = window.open(param,'_blank', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=220,left=250, top=165,screenX=250,screenY=200');
		return false;
	}
	
	function fnDescargar_Inventario()
	{
		window.location = "ReporteInventario.cfm?LvarGenera=true&CPPid=<cfoutput>#EncabezadoEst.CPPid#</cfoutput>";
		return false;
	}
 </script>
</cfif>

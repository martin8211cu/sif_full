<cfsetting requesttimeout="36000" enablecfoutputonly="yes">
<cfparam name="form.CPPid" 		 default="#session.CPPid#">
<cfparam name="LvarLineasPagina" default="39">
<cfparam name="LvarContL" 		 default="8">
<cfparam name="viewGO" 			 default="false">
<cfparam name="numGO" 			 default="0">
<cfparam name="classtr" 		 default="listaNon">
<cfparam name="classtrA" 		 default="listaNon">
<cfparam name="justAnterior" 	 default="">
<cfparam name="LvarPAg" 	 	 default="0">
<cfparam name="tamañoLetra" 	 default="7px">
<cfparam name="caracterXlinea"   default="240">

<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cf_templatecss>
<cfif isdefined('TypeGO')>
	<cfset viewGO = true>
    <cfset numGO  = 1>
</cfif>

<cftry>
	<cfif not isdefined("session.rptRnd")>
		<cfset session.rptRnd = int(rand()*10000)>
    </cfif>
	<cfif isdefined("form.btnCancelar")>
		<cfset session.rptDocsPRES_Cancel = true>
		<cflocation url="rptDocsAED.cfm">
		<cfabort>	
	</cfif>
   	<cfif isdefined("btnDownload")>
		<cfset LvarNoCortes = "1">
	</cfif>
	<cflock timeout="1" name="rptDocsPRES_#session.rptRnd#" throwontimeout="yes">
		<cfset structDelete(session, "rptDocsPRES_Cancel")>
		<cfset rsPeriodo  = getPeriodo()>
		<cfset rsDocAE    = getEncabezado()>
        <cfset rsDocDAE   = getDetalles()>

<cf_htmlReportsHeaders title="Reportes de Documentos de Presupuesto" filename="rptDocs.xls" irA="rptDocsAED.cfm">
	<cfoutput>
		<cfset sbGeneraEstilos()>
        <cfset Encabezado()>
        <cfset Creatabla()>
        <cfset titulos()>
        <cfloop query="rsDocDAE" >
			
            <cfset newDoc(rsDocDAE.CPDEnumeroDocumento)>
                
                    <cfset subTotales(rsDocDAE.Aumento,rsDocDAE.Disminucion)>
                    <cfset PrintJustificacion(rsDocDAE.CPDEjustificacion)>
                    <cfset printEstado(rsDocDAE.Estado)>
					<cfset sbCortePagina(false,1)>
                <tr class="#classtr#">
                    <cfset PrintDocCF(rsDocDAE.CFcodigo,rsDocDAE.CFdescripcion,rsDocDAE.CPDEnumeroDocumento)>
                    <td align="left" style="font-size:#tamañoLetra#" nowrap="nowrap">#rsDocDAE.CPformato#</td>
                    <td align="left" style="font-size:#tamañoLetra#" nowrap="nowrap">#rsDocDAE.CPdescripcion#</td>
                    <cfif viewGO><td align="center" style="font-size:#tamañoLetra#">#rsDocDAE.GOficina#</td></cfif>
                    <td align="right" style="font-size:#tamañoLetra#">#LSNumberFormat(rsDocDAE.Aumento,',9.00')#</td>
                    <td align="right" style="font-size:#tamañoLetra#">#LSNumberFormat(rsDocDAE.Disminucion,',9.00')#</td>
                </tr> 
                    <cfset Totales(rsDocDAE.Recordcount EQ rsDocDAE.CurrentRow)>
			</cfloop>
            	<tr>
                	<td colspan="#8+numGO#" align="center">---------------------------------Ultima Línea---------------------------------</td>
                </tr>
				<cfset Cierratabla()>
			</body>
		</html>
		</cfoutput>
	</cflock>
<cfcatch type="lock">
	<cfoutput>
	<script language="javascript">
		alert('Ya existe un reporte en ejecución, debe esperar a que termine su procesamiento');
		location.href = "rptDocsAED.cfm";
	</script>
	</cfoutput>
</cfcatch>
</cftry>

<!---=========Funcion para Pinta el numero de Documento==========--->
<cffunction name="newDoc" output="true" returntype="boolean">
	<cfargument name="DocActual" type="numeric" required="yes">
    <cfparam name="DocAnterior" default="-1">
    <cfif DocAnterior EQ -1>
    	<cfset primerDoc = true>
    <cfelse>
    	<cfset primerDoc = false>
    </cfif>
    <cfif DocAnterior EQ Arguments.DocActual>
        <cfset NuevoDOC = False>
    <cfelse>
    	<cfset NuevoDOC = true>
        <cfif classtr EQ 'listaNon'>
        	<cfset classtr  = 'listaPar'>
            <cfset classtrA = 'listaNon'>
		<cfelse>
        	<cfset classtr  = 'listaNon'>
            <cfset classtrA = 'listaPar'>
        </cfif>
    </cfif>
    <cfset DocAnterior  = Arguments.DocActual>
    <cfreturn NuevoDOC>
</cffunction>
<!---=========Funcion para  Pintar el Centro Funcional==========--->
<cffunction name="PrintDocCF" output="true">
	<cfargument name="CFActual" 	 type="numeric" required="yes">
    <cfargument name="CFdescripcion" type="string"  required="yes">
    <cfargument name="DocActual" 	 type="numeric" required="yes">
    
    <cfparam name="CFAnterior" default="-1">
    <cfif NuevoDOC>
    	<td align="left" class="Datos">#Arguments.DocActual#</td> 
    <cfelse>
    	<td align="left"   class="Datos">&nbsp;</td>
    </cfif>
    <cfif NOT NuevoDOC and CFAnterior EQ Arguments.CFActual>
        <td align="left"   class="Datos">&nbsp;</td>
        <td align="left"   class="Datos">&nbsp;</td>
    <cfelse>
   		<td align="left" style="font-size:#tamañoLetra#">#Arguments.CFActual#</td>
        <td align="left" style="font-size:#tamañoLetra#">#Arguments.CFdescripcion#</td>
    </cfif>
    <cfset CFAnterior  = Arguments.CFActual>
</cffunction>
<!---=======Funcion para  Pinta sub Totales=================--->
<cffunction name="subTotales" output="true">
	<cfargument name="Aumento" 	    type="numeric" required="yes">
    <cfargument name="Disminucion"  type="numeric" required="yes">

    <cfparam name="TotalA" 		default="0">
    <cfparam name="TotalD" 		default="0">
	<cfparam name="SubTotalA" 	default="0">
    <cfparam name="SubTotalD" 	default="0">
    
     <cfif NuevoDOC and NOT primerDoc>
     	<cfset sbCortePagina(true,1)>
     	<tr class="#classtrA#">
            <td align="right"  class="Header" colspan="#5+numGO#"><div align="right"><strong>SubTotal:&nbsp;</strong></div></td>
            <td align="right"  class="Header" colspan="1"><div align="right">#LSNumberFormat(SubTotalA,',9.00')#</div></td>
            <td align="right"  class="Header" colspan="1"><div align="right">#LSNumberFormat(SubTotalD,',9.00')#</div></td>
        </tr>
        <cfset TotalA = TotalA + SubTotalA>
        <cfset TotalD = TotalD + SubTotalD>
        <cfset SubTotalA = 0>
        <cfset SubTotalD = 0>
    </cfif>	
    <cfset SubTotalA = SubTotalA + Arguments.Aumento>
    <cfset SubTotalD = SubTotalD + Arguments.Disminucion>
</cffunction>
<!---=======Funcion para  Pinta Totales=================--->
<cffunction name="Totales" output="true">
	 <cfargument name="print" 	type="boolean" required="yes">
   <cfif Arguments.print>
   		<cfset sbCortePagina(true,1)>
    	<tr>
        	 <td align="right"  class="Header" colspan="#5+numGO#"><div align="right"><strong>TOTAL:&nbsp;</strong></div></td>
             <td align="right"  class="Header" colspan="1"><div align="right">#LSNumberFormat(TotalA,',9.00')#</div></td>
             <td align="right"  class="Header" colspan="1"><div align="right">#LSNumberFormat(TotalD,',9.00')#</div></td>
        </tr>
    </cfif>
</cffunction>
<!---=======Funcion para  Pinta el estado=================--->
<cffunction name="printEstado" output="true">
	 <cfargument name="EstadoActual" 	type="string" required="yes">
     <cfparam name="EstadoAnterior" default="-1">
     <cfif EstadoAnterior NEQ EstadoActual>
    	 <cfset sbCortePagina(false,1)>
     	<tr>
             <td align="center"  class="ColEstado" colspan="#7+numGO#"><div align="center">#ucase(Arguments.EstadoActual)#</div></td>
        </tr>
     </cfif>
     <cfset EstadoAnterior  = EstadoActual>
</cffunction>
<!---=======Funcion para  Pinta la Justificacion=================--->
<cffunction name="printJustificacion" output="true">
	 <cfargument name="justActual" 	type="string" required="yes">
      <cfif NuevoDOC and NOT primerDoc and LEN(TRIM(justAnterior))>
      	<cfset sbCortePagina(true,LEN(TRIM(justAnterior))/caracterXlinea)>
        <tr>
        	<td align="left"  class="classtrA" valign="top" colspan="#7+numGO#" style="font-size:#tamañoLetra#">#justAnterior#</td>
        </tr>
     </cfif>
     <cfset justAnterior = Arguments.justActual>
</cffunction>
<!---=======Funcion para  Pinta la Encabezado=================--->
<cffunction name="Encabezado" output="true">
	<table border="0" align="center">
		<tr>
			<td class="Header1" colspan="#7+numGO#" align="center"><strong>#ucase(session.Enombre)#</strong></td>
		</tr>
		<tr>
			<td  class="Header1" colspan="#7+numGO#" align="center"><strong>Reportes de Documentos de Aprobación Externa </strong></td>
		</tr>
		<cfset NoExisteDoc()>
		<tr>
			<td class="Header" colspan="#7+numGO#" align="center"><strong>#ucase(rsPeriodo.CPPDESCRIPCION)#</strong></td>
		</tr>	
        <tr>
			<td class="Header" colspan="#7+numGO#" align="center"><strong>#rsDocAE.CPDAEcodigo#-#rsDocAE.CPDAEdescripcion#</strong></td>
		</tr>
        <tr>
			<td class="Header" colspan="#7+numGO#" align="center"><strong>#rsDocAE.CPTAEcodigo#-#rsDocAE.CPTAEdescripcion#</strong></td>
		</tr>
        <tr>
			<td class="Header" colspan="#7+numGO#" align="center"><strong>#rsDocAE.estado#</strong></td>
		</tr>
	</table>
</cffunction>
<!---=============Funcion Crea Inicio de la tabla=============--->
<cffunction name="Creatabla" output="true">
	<table border="0" align="center">
</cffunction>
<!---=============Funcion Crea cierre de la tabla=============--->
<cffunction name="Cierratabla" output="true">
	</table>
</cffunction>
<!---=============Funcion verifica que el Documento Exista============--->
<cffunction name="NoExisteDoc" output="true">
	<cfif rsDocAE.recordCount EQ 0>
     	<tr>
			<td class="Header" colspan="#7+numGO#" align="center"><strong>-------El Numero de Documento No Existe-------</strong></td>
		</tr>	
     	<cfabort>
    </cfif>
</cffunction>
<!---=======Funcion para  Pinta los titulos de los row=================--->
<cffunction name="titulos" output="true">
	<tr>
		<td align="center" class="ColHeader" colspan="1">N°Doc</td>
		<td align="center" class="ColHeader" colspan="2" >Centro Funcional</td>
		<td align="center" class="ColHeader" colspan="2">Cuenta Presupuesto</td>
		<cfif viewGO><td align="center" class="ColHeader">Grupo Oficinas</td></cfif>
		<td align="center" class="ColHeader">Aumentos</td>
		<td align="center" class="ColHeader">Disminuciones</td>
	</tr>
</cffunction>
<!---=============Funcion Periodo Presupuestal===================--->
<cffunction name="getPeriodo" output="no" returntype="query">
		<cfquery name="rsPeriodo" datasource="#Session.DSN#">
			select CPPid, 
				   CPPtipoPeriodo, 
				   CPPfechaDesde, 
				   CPPfechaHasta, 
				   CPPfechaUltmodif, 
				   CPPestado,
				   'Presupuesto ' #_Cat#
						case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
							#_Cat# ' de ' #_Cat# 
							case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
							#_Cat# ' a ' #_Cat# 
							case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
					as CPPdescripcion
			from CPresupuestoPeriodo p
			where p.Ecodigo = #Session.Ecodigo#
			  and p.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
		</cfquery>
		<cfreturn rsPeriodo>
</cffunction>
<!---=====================Encabezado del Documento=====================--->
<cffunction name="getEncabezado" output="no" returntype="query">
        <cfquery name="rsDocAE" datasource="#Session.DSN#">
             select AE.CPDAEid, AE.Ecodigo, AE.CPDAEcodigo, AE.CPDAEdescripcion, AE.CPTAEid,
                        case AE.CPDAEestado
                                    when 0 then  'Documento Inactivo: El documento no se puede utilizar'
                                    when 1 then  'Documento Abierto: Se pueden asignar traslados'
                                    when 2 then  'Documento En Pausa: No permite nuevos traslados'
                                    when 3 then  'Documento Cerrado: No permite aprobar traslados'
                                    when 10 then 'Documento Aplicado Parcialmente'
                                    when 11 then 'Documento Aplicado'
                                    when 12 then 'Documento Rechazado'
                        end as estado,
                        AE.CPDAEmontoCF,
                        AE.BMUsucodigo,
                        TAE.CPTAEcodigo,
                        TAE.CPTAEdescripcion
            from CPDocumentoAE AE
            	inner join CPtipoAutExterna TAE
                	on AE.CPTAEid = TAE.CPTAEid
            where AE.Ecodigo	 = #session.Ecodigo#
              and AE.CPDAEcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPDAEcodigo#">
       </cfquery>
       <cfif rsDocAE.RecordCount EQ 0>
	  	 <cfset LvarCPDAEid = -1>
       <cfelse>
       	 <cfset LvarCPDAEid = rsDocAE.CPDAEid >
       </cfif>
		<cfreturn rsDocAE>
</cffunction>
<!---======Listado de Documentos de Autorizacion Externa==========--->
<cffunction name="getDetalles" output="no" returntype="query">
	
    <cfquery name="rsCFidIni" datasource="#Session.DSN#">
    	select CFcodigo from CFuncional where CFid = #form.CFidIni#
    </cfquery>
     <cfquery name="rsCFidFin" datasource="#Session.DSN#">
    	select CFcodigo from CFuncional where CFid = #form.CFidFin#
    </cfquery>
    <cfquery name="rsListaDoc" datasource="#Session.DSN#">
			select a.CPDEestadoDAE,
            	   a.CPDEnumeroDocumento, 
            	    rtrim(cp.CPformato) CPformato,
				   rtrim(cp.CPdescripcion) CPdescripcion,
                   a.CPDEjustificacion,
                   case 
                     when d.CPDDtipo = -1 then (select CFcodigo from CFuncional cf where cf.CFid = a.CFidOrigen)
                     when d.CPDDtipo =  1 then (select CFcodigo from CFuncional cf where cf.CFid = a.CFidDestino)
                   end as CFcodigo,
                   case
                     when d.CPDDtipo = -1 then (select rtrim(CFdescripcion) from CFuncional cf where cf.CFid = a.CFidOrigen)
                     when d.CPDDtipo =  1 then (select rtrim(CFdescripcion) from CFuncional cf where cf.CFid = a.CFidDestino)
                   end as CFdescripcion,
                    
                   case when d.CPDDtipo = -1 then d.CPDDmonto else 0 end as Disminucion,
                   case when d.CPDDtipo =  1 then d.CPDDmonto else 0 end as Aumento,
                   case
                        when (CPDEenAprobacion = 0 AND CPDErechazado = 0 AND CPDEaplicado = 0) then 'Documentos en PREPARACIÓN'
                        when CPDEaplicado = 1    then 'Documentos APLICADOS'
                        when CPDErechazado = 1   then 'Documentos RECHAZADOS'
                        when CPDEestadoDAE = 0   then 'Documentos en APROBACIÓN'
                        when CPDEestadoDAE = 9   then 'Documentos Aprobados sin confirmar'
                        when CPDEestadoDAE = 10  then 'Documentos Aprobados'
                        when CPDEestadoDAE = 11  then 'Documentos Aprobados con NRP'
                        when CPDEestadoDAE = 12  then 'Documentos APLICADOS'
                   end as Estado, 
                   (select count(1) from CPDocumentoD where CPDEid = a.CPDEid) rowspan
                   <cfif viewGO>
                       ,(select min(go.GOnombre)
                            from AnexoGOficina go
                                inner join AnexoGOTipo bt
                                    on bt.GOTid = go.GOTid
                                inner join AnexoGOficinaDet ct
                                    on ct.GOid = go.GOid
                        where bt.Ecodigo   = #session.Ecodigo#
                          and bt.GOTid 	   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GOTid#">
                          and ct.Ocodigo   = cf.Ocodigo
                       ) as GOficina
                  </cfif>
              
            from CPDocumentoE a
              inner join CPDocumentoD d
              	inner join CPresupuesto cp
                	on cp.CPcuenta = d.CPcuenta
              on d.CPDEid = a.CPDEid
              	inner join CFuncional cf
                	on cf.CFid = a.CFidOrigen
            where a.Ecodigo = #Session.Ecodigo#
   			  and a.CPDEtipoDocumento = 'E'
   			  and a.CPDAEid = #LvarCPDAEid#
   			  and (CPDEenAprobacion = 1 OR CPDEaplicado = 1)
              and cf.CFcodigo between '#rsCFidIni.CFcodigo#' and '#rsCFidFin.CFcodigo#'
   			order by a.CPDEestadoDAE desc, a.CPDEnumeroDocumento,CFcodigo
		</cfquery>
		<cfreturn rsListaDoc>
</cffunction>

<cffunction name="sbGeneraEstilos" output="true">
	<style type="text/css">
	<!--
		H1.Corte_Pagina
		{
		PAGE-BREAK-AFTER: always
		}
		
		.ColHeader 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		11px;
			font-weight: 	bold;
			padding-left: 	0px;
			border:		1px solid ##CCCCCC;
			background-color:##CCCCCC
		}
		.ColEstado 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		9px;
			font-weight: 	bold;
			padding-left: 	0px;
			border:		1px solid ##CCCCCC;
			background-color:##D5D2D5
		}
	
		.Header 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		9px;
			font-weight: 	bold;
			padding-left: 	0px;
			text-align:	center;
		}
	
		.Header1 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		10px;
			font-weight: 	bold;
			padding-left: 	0px;
		}
	
		.Corte1 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		14px;
			font-weight: 	bold;
			padding-left: 	0px;
		}
	
		.Corte2 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		7px;
			font-weight: 	bold;
			padding-left: 	10px;
		}
	
		.Corte3 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		10px;
			font-weight: 	bold;
			padding-left: 	20px;
		}
	
		.Corte4 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		10px;
			font-weight: 	none;
			padding-left: 	30px;
		}
	
		.Datos1
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		8px;
			font-weight: 	none;
			
		}
		
		.Datos
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		10px;
			font-weight: 	none;
			white-space:nowrap;
		}
	
		body
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		11px;
		}
	-->
	</style>
</cffunction>
<!---===============Funcion que controla los Saltos de Pagina===============--->
<cffunction name="sbCortePagina" output="true">
	 <cfargument name="SoloSuma" 	type="boolean" required="yes" default="false">
     <cfargument name="cantLineas" 	type="numeric" required="yes" default="1">
	<cfif isdefined("LvarNoCortes")>
		<cfreturn>
	</cfif>
    <cfset LvarContL = LvarContL + Arguments.cantLineas>  
	<cfif NOT Arguments.SoloSuma and LvarContL GTE LvarLineasPagina>
		<tr><td><H1 class=Corte_Pagina></H1></td></tr>
		<cfset Cierratabla()>
		<cfset LvarPAg   = LvarPAg + 1>
		<cfset LvarContL = 8> 
		<cfset Encabezado()>
		<cfset Creatabla()>
		<cfset titulos()>
	</cfif>
</cffunction>
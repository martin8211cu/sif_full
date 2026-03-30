

<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_Reporte_de_NotasPorPregunta"
    Default="Reporte de Notas del Evaluador por Pregunta "
    returnvariable="LB_Reporte_de_NotasPorPregunta"/> 


<!---- Funcion que me devuelve el resultado del cuestionario---->
<cffunction name="FuncObtieneResultado" returntype="string" output="true" access="private">			
	<cfargument name='cuestionario'	type='numeric' 	required='yes'>	
	<cfargument name='evaluado'			type='numeric' 	required='yes'>	
	<cfargument name='evaluador'			type='numeric' 	required='yes'>
	<cfargument name='idPregunta'			type='numeric' 	required='yes'>
	<cfargument name='Conocimiento' type='boolean' 	required='yes' default="FALSE">
	<!----Seleccion de la opcion seleccionada cuando es option button----->
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select a.DEid, a.DEideval ,a.PCUid,a.PCUreferencia,
				b.PCid,b.PPid,
				d.PPparte, d.PPtipo, d.PPvalor, d.PPpregunta,d.PPnumero,
				c.PCUid,c.PRid, c.PRUvalor, c.PRUvalorresp,
				
				(select coalesce(max(PRvalor),1) 				
							from PortalRespuesta z
							where z.PCid = b.PCid
								and z.PPid = b.PPid
								and z.PRvalor is not null
						 ) as mayor,
						  (select sum(PRvalor)							
							from PortalRespuesta x
							where x.PCid = b.PCid
								and x.PPid = b.PPid
								and x.PRvalor is not null
							group by x.PPid
							) as resptotal,
							
							(select SUM(w.PRUvalor)/count(w.PRUvalor)
								from 
								PortalPregunta v
								inner join PortalRespuestaU w
								on w.PPid = v.PPid
								where v.PCid = b.PCid
								and v.PPvalor != 0
								and w.PRUvalor > -1
								and v.PPparte=d.PPparte
								and w.PCUid = a.PCUid) as NotaXparte
				
						, coalesce( c.PRUvalor,0 ) as NOTAPREGUNTAA
							
		
		from PortalCuestionarioU a
			inner join PortalPreguntaU b
				on a.PCUid = b.PCUid	
			inner join PortalPregunta d
				on b.PCid = d.PCid
				and b.PPid = d.PPid
			inner join PortalRespuestaU c
				on b.PCUid = c.PCUid
				and b.PCid = c.PCid
				and b.PPid = c.PPid
		Where PCUreferencia = #Arguments.cuestionario#
		and a.DEid = #Arguments.evaluado#
		and a.DEideval = #Arguments.evaluador#
		and d.PPid = #arguments.idPregunta#
		and coalesce(c.PRUvalor,0) >= 0
		and a.PCUid  = (select max(z.PCUid) 
						from PortalCuestionarioU z
						where z.DEid = #Arguments.evaluado#
						and z.DEideval  = #Arguments.evaluador#
						and z.PCUreferencia = #Arguments.cuestionario#)

	</cfquery>


	<cfset vnCuestionario = 0.00>	<!---Sumatoria de todos los promedios de las preguntas--->	
	<cfset vnPCuestionario = 0><!---Suma de los promedios de las preguntas segun las respuestas del que lleno el cuestionario(promedio del cuestionario=NOTA)--->

	<cfif rsDatos.RecordCount NEQ 0>						
		<cfoutput query="rsDatos" group="PPid">	
			<cfset vnTempNota = 0><!---Variable con la sumatoria del porcentaje de las resp. de las preguntas--->
			<cfset vnPregunta = 0><!---Variable con el promedio por pregunta---->			
			<cfset vnPromedioR = 0><!---Variable con el promedio de las Todas las respuestas--->
			<!---Si la pregunta pertenece a una parte que solo una respuesta---->				
			<!---///////////////////////OPCION MULTIPLE////////////////////////////////////////////
				Cuando es opcion multiple obtener la suma de todos los pesos de todas las respuestas(rsDatos.resptotal),
				luego sumar los pesos de las respuestas seleccionadas en el cuestionario=checkeadas(Output agrupado por PRid).  
				Finalmente se promedia por regla de tres.
			////////////////////////////////////////////////////////////////////////////---->	
			<cfoutput group="PRid">
				<cfif rsDatos.PPtipo EQ 'M'>
					<cfset vnTempNota = vnTempNota + rsDatos.PRUvalor>
				<cfelse>
					<cfset vnTempNota = rsDatos.PRUvalor>
				</cfif>					
			</cfoutput>
			<cfif rsDatos.PPtipo EQ 'M'><!---Se promedian las notas cuando es multiple seleccion---->
				<cfif rsDatos.resptotal NEQ 0>
					<cfset vnPregunta = (vnTempNota*100)/rsDatos.resptotal><!----Promedio sobre el peso de la pregunta---->
					<cfset vnPromedioR = vnPregunta ><!---Promedio sobre el peso de la respuesta--->
				<cfelse>
					<cfset vnPromedioR = 0>
				</cfif>
			<!---///////////////////////SELECCION UNICA///////////////////////////////////////////
				Cuando es un option buton(seleccion unica) se promedia el valor de la respuesta seleccionada
				segun el puntaje mayor (EJ: Si las posibles respuestas son--> opt1:20,opt2:30,opt3:15 y se seleccionaron la 1 y 2
				se obtiene cuanto es 20 de 30(que es el mayor) y cuanto es 30 de 30 por regla de tres) y suma los promedios
			////////////////////////////////////////////////////////////////////////////---->					
			<cfelseif rsdatos.PPtipo EQ 'U'>					
				<cfif rsDatos.mayor NEQ 0>
					<cfset vnPregunta = rsDatos.PRUvalor*100/rsDatos.mayor><!---Promedio sobre el peso mayor--->
					<cfset vnPromedioR = (rsDatos.PPvalor*vnPregunta)/100><!---Promedio sobre el peso de la respuesta--->
				<cfelse>
					<cfset vnPromedioR = 0>
				</cfif>	
			<!---//////////////////////////CUALQUIER OTRO CASO/////////////////////////////////////
				En cualquier otro tipo de pregunta se la asigna el valor total de la pregunta(=cualquier respuesta esta bien!!)
			////////////////////////////////////////////////////////////////////////////---->
			<cfelseif rsdatos.PPtipo EQ 'V' or rsdatos.PPtipo EQ 'D' or rsdatos.PPtipo EQ 'O'>
				<cfset vnPromedioR = rsDatos.PPvalor>
			</cfif>	
			<cfset vnCuestionario = vnCuestionario+vnPromedioR>		
					
		</cfoutput>	
	
		<!---////////////////////////////////NOTA FINAL/////////////////////////////////////
			Obtener la suma de todos los pesos de las preguntas del cuestionario
			para promediarlo con la suma de todos las respuestas (vnCuestionario) 
		////////////////////////////////////////////////////////////////////////////---->
		<cfquery name="rsPromedioP" dbtype="query">
			select sum(PPvalor) as PPvalor
			from rsDatos
		</cfquery>

		
		<cfif isdefined("vnPCuestionario") and rsPromedioP.PPvalor gt 0>
			<cfset vnPCuestionario = (((vnCuestionario*100)/rsPromedioP.PPvalor))>
		<cfelse>
			<cfset vnPCuestionario = 0>
		</cfif>
	<cfelse>		
		<cfset vnPCuestionario = -1>
	</cfif>

	<cfreturn  vnPCuestionario ><!---Retorno el resultado---->
</cffunction>

<!--- Informacion general de la evaluacion  --->

 <cfquery datasource="#session.dsn#"  name="Rs_Eval">
    select RHEEdescripcion,RHEEfhasta , RHEEfecha 
	from  RHEEvaluacionDes 
    where RHEEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#"> 
</cfquery>
<!--- obteniendo lista de centros funcionales--->
<cfset listaCentros=-1>

<cfif isdefined("form.CFid") and len(trim(form.CFid))>
	<cfset listaCentros=form.CFid>
</cfif>

<cfif isdefined("form.chkIncluirDependencias") and isdefined("form.CFid") and len(trim(form.CFid))>
	<cfquery datasource="#session.dsn#" name="rsCFid">
		select CFpath
		from CFuncional
		where CFid = #listaCentros#
	</cfquery>
	<cfquery datasource="#session.dsn#" name="rsCFid">
		select CFid, CFpath 
		from CFuncional
		where CFpath like '%#rsCFid.CFpath#%'
	</cfquery>
	<cfset listaCentros = valueList(rsCFid.CFid,',')>
</cfif>

<cf_dbfunction name="op_concat" returnvariable="concat">
<cfquery datasource="#session.DSN#" name="datos" >
	select a.DEid,a.RHEEid ,
       coalesce(c.RHPcodigoext, c.RHPcodigo)#concat#' - '#concat#c.RHPdescpuesto as puesto,
		<cfif form.RHOrden eq 'N'>
        	{fn concat({fn concat({fn concat({fn concat(b.DEnombre , ' ' )}, b.DEapellido1 )}, ' ' )}, b.DEapellido2 )} 
		<cfelse>
			{fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )}, ' ' )}, b.DEnombre )}
		</cfif> as nombre,
         b.DEidentificacion, 
		(RHLEnotaauto)/100   as RHLEnotaauto,
		(RHLEnotajefe)/100   as RHLEnotajefe,
		(RHLEpromotros)/100   as RHLEpromotros,
		(RHLEpromJCS)/100   as RHLEpromJCS,
		(
            select min(de.DLfvigencia)
            from DLaboralesEmpleado de
            inner join RHTipoAccion ta 
               on de.RHTid = ta.RHTid
              and de.Ecodigo =  ta.Ecodigo
              and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
              and ta.RHTcomportam = 1
            where de.DEid = a.DEid	) as Ingreso ,
		(select 
			 case when rp.CFid is null then 'Actualmente no se encuentra nombrado(a)' else {fn concat(CFcodigo,{fn concat(' ',CFdescripcion)})} end 
				from  DatosEmpleado datemp 
				left outer join LineaTiempo  lt
					on datemp.DEid = lt.DEid
					and  <cfqueryparam value="#Rs_Eval.RHEEfhasta#" cfsqltype="cf_sql_date">  between LTdesde  and  LThasta 
						left outer join RHPlazas rp
					on lt.RHPid  = rp.RHPid  
					and rp.Ecodigo =  datemp.Ecodigo
				left outer join RHPuestos p
					on rp.RHPpuesto  = p.RHPcodigo
					 and p.Ecodigo =  datemp.Ecodigo
				left outer join CFuncional cf
					on  rp.CFid = cf.CFid            	
				where datemp.DEid  = a.DEid 
			)	as centrofuncional,
		(select 
			 case when rp.CFid is null then -1 else cf.CFid end 
				from  DatosEmpleado datemp 
				inner join LineaTiempo  lt
					on datemp.DEid = lt.DEid
					and  <cfqueryparam value="#Rs_Eval.RHEEfhasta#" cfsqltype="cf_sql_date">  between LTdesde  and  LThasta 
						left outer join RHPlazas rp
					on lt.RHPid  = rp.RHPid  
					and rp.Ecodigo =  datemp.Ecodigo
				inner join RHPuestos p
					on rp.RHPpuesto  = p.RHPcodigo
					 and p.Ecodigo =  datemp.Ecodigo
				inner join CFuncional cf
					on  rp.CFid = cf.CFid            	
				where datemp.DEid  = a.DEid 
			)	as CFid
    from RHListaEvalDes  a
    inner join DatosEmpleado b
        on a.DEid = b.DEid 
        and a.Ecodigo = b.Ecodigo
    inner join RHPuestos c
        on a.RHPcodigo = c.RHPcodigo 
        and a.Ecodigo = c.Ecodigo
    where a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
    and a.Ecodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    <cfif isdefined("form.DEid") and len(trim(form.DEid))>
		and a.DEid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfif>
	<cfif listaCentros neq -1>
	and a.DEid in	(	
						select datemp.DEid
						from  DatosEmpleado datemp 
						inner join LineaTiempo  lt
							on datemp.DEid = lt.DEid
							and  <cfqueryparam value="#Rs_Eval.RHEEfhasta#" cfsqltype="cf_sql_date">  between LTdesde  and  LThasta 
						inner join RHPlazas rp
							on lt.RHPid  = rp.RHPid  
							and rp.Ecodigo =  datemp.Ecodigo
						where rp.CFid  in (#listaCentros#)
					)
	</cfif>
</cfquery>

<!--- Informacion general del evaluado --->

<cfset LvarFileName = "Evaluacion-del-Desempeno#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<cf_htmlReportsHeaders 
	title="#LB_Reporte_de_NotasPorPregunta#" 
	filename="#LvarFileName#"
	download="false"
	irA="NotasPorPregunta.cfm" 
	>
  
<style type="text/css">

	
	.RLTtopline {
		border-bottom-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	
	.LTtopline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	.LRTtopline {
		border-bottom-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}
	
	.RTtopline {
		border-bottom-width: none;
		border-bottom-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	
	.Completoline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	
	.topline {
			border-top-width: 1px;
			border-top-style: solid;
			border-top-color: #000000;
			border-right-style: none;
			border-bottom-style: none;
			border-left-style: none;
		}
	
	.bottonline {
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-bottom-color: #000000;
			border-right-style: none;
			border-top-style: none;
			border-left-style: none;
		}
		
	.subtotal {
		border: 1px solid #000000;
		background-color: #CCCCCC;			
	}	
	
	.total {
		background-color:#999999;
	}
	
	.RLline {
		border-top-width: none;
		border-bottom-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
	}
	
	.LTbottomline {
		border-top-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000			
	}		
		
</style>


<cfif not isdefined("Exportar")>

</cfif>

<cfif isdefined("Exportar")>
	<cfset archivo = "ReporteNotasEvaludorPorPregunta_#hour(now())##minute(now())##second(now())#">
	<cfset txtfile = GetTempFile(getTempDirectory(), 'ReporteEvaluacion')>
	<cfsavecontent variable="REPORTE">
	<cfset imprimirDatos()>
	</cfsavecontent>

	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#REPORTE#" charset="windows-1252">
			<cfheader name="Content-Disposition" value="attachment;filename=#archivo#.xls">
			<cfcontent file="#txtfile#" type="application/vnd.ms-excel" deletefile="yes">
<cfelse>
	<cfflush interval="512">
	<cfsetting requesttimeout="36000">
	<cfset imprimirDatos()>
</cfif>


<cffunction name="imprimirDatos">
<cfoutput>  
	<cfloop query="datos">
	
		<!---- busca el empleado que lo evaluó ----->
			<cfquery datasource="#session.dsn#" name="detalle">
			select a.RHEEid,a.DEideval,b.DEidentificacion,b.DEnombre#concat#' '#concat#b.DEapellido1#concat#' '#concat#b.DEapellido2 as nombre,
			rhp.RHPcodigo#concat#' - '#concat#rhp.RHPdescpuesto as puesto
			from RHEvaluadoresDes a
				inner join DatosEmpleado b
					on a.DEideval = b.DEid
				inner join RHEEvaluacionDes e
					on e.RHEEid=a.RHEEid	
				inner join LineaTiempo lt
					on e.RHEEfdesde between lt.LTdesde and lt.LThasta	
					and a.DEid = lt.DEid
				inner join RHPuestos rhp
					on lt.RHPcodigo = rhp.RHPcodigo
					and rhp.Ecodigo = lt.Ecodigo	
			where a.RHEEid = #datos.RHEEid#
			and a.DEid = #datos.DEid#
			and a.DEideval <> #datos.DEid#
			</cfquery>

				
						
				<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td bgcolor="##CCCCCC" class="RLTtopline" colspan="4" align="center">
							<font  style="font-size:13px; font-family:'Arial'">#session.enombre#</font> 
						</td>
					</tr>
					<tr>
						<td bgcolor="##CCCCCC" class="RLTtopline" colspan="4" align="center">
							<font  style="font-size:13px; font-family:'Arial'">#LB_Reporte_de_NotasPorPregunta#</font> 
						</td>
					</tr>
				   	<tr>
						<td  class="topline" colspan="4" align="center">
							<font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
						</td>
					</tr>
					<tr>
					<tr>
						<td bgcolor="##CCCCCC" class="LTtopline"  colspan="1" align="left">
							<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_JefeEvaluador">Evaluado</cf_translate></font> 
						</td>
						<td  class="LTtopline" colspan="1" align="left">
							<font  style="font-size:13px; font-family:'Arial'">#datos.nombre#</font>
						</td>
						<td bgcolor="##CCCCCC" class="LTtopline" colspan="1" align="left">
							<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Puesto">Puesto</cf_translate></font>
						</td>
						<td  class="LTtopline" colspan="1" align="left">
						  <font  style="font-size:13px; font-family:'Arial'">#datos.puesto#</font>
						</td>
					</tr>
					<tr>	
						<td bgcolor="##CCCCCC" class="LTtopline"  colspan="1" align="left">
							<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_FechaEvaluacion">Fecha Evaluaci&oacute;n</cf_translate></font> 
						</td>
						<td  class="LTtopline"  colspan="1" align="left">
						  <font  style="font-size:13px; font-family:'Arial'">#dateformat(Rs_Eval.RHEEfecha)#</font>
						</td>
						<td bgcolor="##CCCCCC" class="LTtopline"  colspan="1" align="left">
							<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_NombreJefeInmediato">Nombre Jefe Inmediato</cf_translate></font> 
						</td>
						<td  class="LTtopline" colspan="1" align="left">
							<cfset DEid=-1>
							<cfif len(trim(datos.CFid)) gt 0 and datos.CFid neq -1>
								<cfinvoke component="rh.Componentes.RH_Funciones" 
										method="DeterminaDEidResponsableCF" 
										CFid="#datos.CFid#"
										fecha="#Rs_Eval.RHEEfecha#" returnvariable="vDEid">
							<cfelse>
									<cfset vDEid = -1>
							</cfif>			
										
							<cfif  vDEid neq -1>
								<cfquery datasource="#session.dsn#" name="rsJefe">
								select DEnombre#concat#' '#concat#DEapellido1#concat#' '#concat#DEapellido2 as nombre  from DatosEmpleado where DEid=#vDEid#
								</cfquery>
								<cfset jefeInmediado = rsJefe.nombre>
							<cfelse>
								<cfset jefeInmediado = 'No existe definido un Jefe Inmediato'>
							</cfif>
							<font  style="font-size:13px; font-family:'Arial'">#jefeInmediado#</font>
						</td>
					</tr>
					<tr>	
						<td bgcolor="##CCCCCC" class="LTtopline"  colspan="1" align="left">
							<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate></font> 
						</td>
						<td  class="LTtopline"  colspan="1" align="left">
						  <font  style="font-size:13px; font-family:'Arial'">#datos.centrofuncional#</font>
						</td>
						<td bgcolor="##CCCCCC" class="LTtopline"  colspan="1" align="left">
							<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Evaluacion">Evaluaci&oacute;n</cf_translate></font> 
						</td>
						<td  class="LTtopline"  colspan="1" align="left">
							<font  style="font-size:13px; font-family:'Arial'">#Rs_Eval.RHEEdescripcion#</font> 
						</td>
					</tr>
					<!---tabla con las preguntas , valores y evaluaciones--->
					<cfif detalle.recordcount gt 0>
					<tr>	
						<td bgcolor="##CCCCCC"class="LTtopline"  colspan="#detalle.recordcount+3#" align="center">
							<font  style="font-size:13px; font-family:'Arial'"><b><cf_translate  key="LB_ResultadoEvaluacion">RESULTADO EVALUACI&Oacute;N</cf_translate></b></font> 
						</td>
					</tr>	
					<tr>	
						<td bgcolor="##CCCCCC"class="LTtopline"  colspan="3" align="center">
							<font  style="font-size:13px; font-family:'Arial'"><b>Pregunta</b></font> 
						</td>
						<cfloop query="detalle">
							<td bgcolor="##CCCCCC"class="LTtopline"  align="center">
								<font  style="font-size:13px; font-family:'Arial'">#detalle.nombre#</font> 
							</td>
								<cfset Evaluate( "TotalDinamico_#detalle.DEideval# = 0" ) />
						</cfloop>
					</tr>
					
					<!---- PINTADO DE LAS PREGUNTAS CON SU VALOR POR RESPUESTA--->
					 
					<cfset parteActual=0>
						<cfquery name="PreguntaActual" datasource="#session.DSN#">
							select distinct pp.PPparte, pp.PPnumero,b.PPid
							from PortalCuestionarioU a
								inner join PortalPreguntaU b
									on a.PCUid = b.PCUid	
								inner join PortalPregunta pp
									on b.PCid = pp.PCid
									and b.PPid = pp.PPid
							Where a.PCUreferencia = #datos.RHEEid#
							and a.DEid = #datos.DEid#
							order by pp.PPparte, pp.PPnumero
						</cfquery>
						<cfif PreguntaActual.recordcount gt 0>
							<cfloop query="PreguntaActual"><!--- recorre cada pregunta--->
							
							<cfif PreguntaActual.PPparte neq parteActual>
								<tr><td  class="LTtopline" colspan="#3+detalle.recordcount#" align="left">Parte N. #PreguntaActual.PPparte#</td></tr>
								<cfset parteActual=PreguntaActual.PPparte>
							</cfif>
								<tr>
								<cfquery name="PreguntaText" datasource="#session.DSN#">
									select PPnumero, PPpregunta
									from PortalPregunta
									Where PPid = #PreguntaActual.PPid#
								</cfquery>
								<td  class="LTtopline" colspan="3" align="left">
								
									<cfset preguntaClear = replace(trim(PreguntaText.PPpregunta),"</p>","","ALL")>
									<cfset preguntaClear = replace(preguntaClear,"<p>","","ALL")>
									<font  style="font-size:13px; font-family:'Arial'"><i>#PreguntaText.PPnumero# - #preguntaClear#</i></font> 
								</td>
								<cfset cantEvaluadores=0>
								<cfloop query="detalle">						
									<cfset vnResultado = FuncObtieneResultado(datos.RHEEid,datos.DEid,detalle.DEideval,PreguntaActual.PPid)>
									<cfif vnResultado neq -1>
										<cfset Evaluate( "TotalDinamico_#detalle.DEideval# = TotalDinamico_#detalle.DEideval# + vnResultado" ) />
										<cfset cantEvaluadores=cantEvaluadores+1>
									</cfif>
									<td  class="LTtopline" align="center">
										<cfif vnResultado neq -1>
											#LSNumberFormat(vnResultado, ",_.__")#
										<cfelse>
											NR 
										</cfif>	
									</td>
								</cfloop>
								</tr> 	
							</cfloop>
						<cfelse>
							<tr><td  class="LTtopline" colspan="#3+detalle.recordcount#" align="left">No se hay preguntas contestadas</td></tr>
						</cfif>	 
					 <!--- FIN DE PINTADO DE PREGUNTAS--->
					<tr>
						<td  class="" colspan="3" align="right">&nbsp;</td>
						<cfset TotalCalificacion=0>
						<cfloop query="detalle">
							<td  class="subtotal" colspan="1" align="center">
							<cfset resultado=0>
	
							<cfif PreguntaActual.recordcount gt 0>
								<cfset Evaluate('resultado = TotalDinamico_#detalle.DEideval# / PreguntaActual.recordcount')/>	
							<cfelse>
								<cfset Evaluate('resultado = TotalDinamico_#detalle.DEideval# ')/>	
							</cfif>
							
							<cfset TotalCalificacion=TotalCalificacion+resultado>
								<font  style="font-size:14px; font-family:'Arial'"><b>#LSNumberFormat(resultado, ",_.__")#</b></font>
							</td>
						</cfloop>
					</tr>
					<!--- nota final del empleado---->
					<tr>
						<td  class="" colspan="3" align="right">
							<font  style="font-size:14px; font-family:'Arial'"><b>CALIFICACI&Oacute;N DEL DESEMPE&Ntilde;O:&nbsp;&nbsp;</b></font>
						</td>
						<td  class="total" colspan="#detalle.recordcount#" align="center">
							<cftry>
								<font  style="font-size:14px; font-family:'Arial';" color="000000"><b>#LSNumberFormat(TotalCalificacion/cantEvaluadores, ",_.__")#</b></font>
							<cfcatch type="any">
								<font  style="font-size:14px; font-family:'Arial';" color="000000"><b>NR</b></font>
							</cfcatch>
							</cftry>
						</td>
					</tr>

					<cfelse>
					<tr>	<td  class="LTtopline" colspan="4" align="center"><b>No se realiz&oacute; evaluaci&oacute;n a este Funcionario</b></td></tr>
					</cfif>
					
					<!--- FIN tabla con las preguntas , valores y evaluaciones--->
					<!--- detalle final--->
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
					
					<tr>
						<td colspan="#detalle.recordcount+3#">
							<table width="100%" border="0" cellspacing="0" cellpadding="1"> 
									<tr bgcolor="999999" align="center"> 
									<td><b><font color="000000">Plan de mejora o comentarios:</font></b></td> 
									</tr> 
									<tr bgcolor="999999"> 
									<td> 
									<table width="100%" border="0" cellspacing="0" cellpadding="4"> 
									<tr bgcolor="FFFFFF"><td>&nbsp;</td></tr> 
									<tr bgcolor="FFFFFF"><td>&nbsp;</td></tr> 
									<tr bgcolor="FFFFFF"><td>&nbsp;</td></tr> 
									</table> 
									</td> 
									</tr> 
							</table> 
						</td>
					</tr>
					
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td colspan="#detalle.recordcount+3#">Firma del Evaluado: ____________________</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td colspan="#detalle.recordcount+3#">Firma de la Jefatura: ____________________</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td colspan="#detalle.recordcount+3#">Fecha: ____________________</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>

				</table>			
				 							
	</cfloop> 
</cfoutput>
</cffunction>


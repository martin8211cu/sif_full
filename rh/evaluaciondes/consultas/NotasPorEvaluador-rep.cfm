
<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_Reporte_de_Notas_Por_Evaluador"
    Default="Reporte de Notas Por Evaluador "
    returnvariable="LB_Reporte_de_Notas_Por_Evaluador"/> 


<!---- Funcion que me devuelve el resultado del cuestionario---->
<cffunction name="FuncObtieneResultado" returntype="string" output="true" access="private">			
	<cfargument name='cuestionario'	type='numeric' 	required='yes'>	
	<cfargument name='evaluado'			type='numeric' 	required='yes'>	
	<cfargument name='evaluador'			type='numeric' 	required='yes'>
	<cfargument name='Conocimiento' type='boolean' 	required='yes' default="FALSE">
	<!----Seleccion de la opcion seleccionada cuando es option button----->
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select a.DEid, a.DEideval ,a.PCUid,a.PCUreferencia,
				b.PCid,b.PPid,
				d.PPparte, d.PPtipo, d.PPvalor,
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

		
		<cfif isdefined("vnPCuestionario")>
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
    select RHEEdescripcion,RHEEfhasta   from  RHEEvaluacionDes 
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
       coalesce(c.RHPcodigoext, c.RHPcodigo) as RHPcodigo,
        c.RHPdescpuesto,
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
					and  <cfqueryparam value="#Rs_Eval.RHEEfhasta#" cfsqltype="cf_sql_timestamp">  between LTdesde  and  LThasta 
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
			 case when cfPadre.CFid is null then 'Actualmente no se encuentra nombrado(a)' else {fn concat(cfPadre.CFcodigo,{fn concat(' ',cfPadre.CFdescripcion)})} end 
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
				left join CFuncional cfPadre
					on cfPadre.CFid = cf.CFidresp	          	
				where datemp.DEid  = a.DEid 
			)	as centrofuncionalPadre
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
	order by <cfif form.RHOrden eq 'N'>
        	b.DEnombre, b.DEapellido1, b.DEapellido2 
		<cfelse>
			b.DEapellido1, b.DEapellido2, b.DEnombre
		</cfif> 
</cfquery>


<!--- Informacion general del evaluado --->

<cfset LvarFileName = "NotasPorEvaluador_#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<cf_htmlReportsHeaders 
	title="#LB_Reporte_de_Notas_Por_Evaluador#" 
	filename="#LvarFileName#"
	download="false" 
	irA="NotasPorEvaluador.cfm" 
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
		border-bottom-width: none;
		border-bottom-width: none;
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
		
	.RLTbottomline {
		border-top-width: none;
		border-left-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000			
	}	
	
	.RLTbottomline2 {
		border-top-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000			
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



<cfsavecontent variable="REPORTE">
<cfoutput>
	<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td bgcolor="##CCCCCC" class="RLTtopline" colspan="6" align="center">
				<font  style="font-size:13px; font-family:'Arial'">#session.enombre#</font> 
			</td>
		</tr>
        <tr>
			<td bgcolor="##CCCCCC" class="RLTtopline" colspan="6" align="center">
				<font  style="font-size:13px; font-family:'Arial'">#LB_Reporte_de_Notas_Por_Evaluador#</font> 
			</td>
		</tr>
        <tr>
			<td bgcolor="##CCCCCC" class="RLTtopline" colspan="6" align="center">
				<font  style="font-size:13px; font-family:'Arial'">#Rs_Eval.RHEEdescripcion#</font> 
			</td>
		</tr>
       <tr >
			<td  class="topline" colspan="6" align="center">
            	<font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
			</td>
		</tr>
		<tr>
        	<td colspan="6" align="center">
          		<table align="center"   width="100% "cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td bgcolor="##CCCCCC" class="LTtopline"  colspan="1" align="left">
                            <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_JefeEvaluador">Evaluado</cf_translate></font> 
                        </td>
                        <td bgcolor="##CCCCCC" class="LTtopline" colspan="1" align="left">
                            <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Puesto">Puesto</cf_translate></font>
                        </td>
						<td bgcolor="##CCCCCC" class="LTtopline"  colspan="1" align="left">
                            <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_CentroFuncional_Padre">Centro Funcional Padre</cf_translate></font> 
                        </td>
						<td bgcolor="##CCCCCC" class="LTtopline"  colspan="1" align="left">
                            <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate></font> 
                        </td>
						<td bgcolor="##CCCCCC" class="LTtopline"  colspan="1" align="left">
                            <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Cedula">C&eacute;dula</cf_translate></font> 
                        </td>
                        <td bgcolor="##CCCCCC"class="LTtopline"  colspan="1" align="left">
                            <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_nombre">Evaluador</cf_translate></font> 
                        </td>
						<td bgcolor="##CCCCCC"class="LTtopline"  colspan="1" align="center">
                            <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Puesto">Puesto</cf_translate></font> 
                        </td>

                        <td bgcolor="##CCCCCC" class="LTtopline" colspan="1" align="center">
                            <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Evaluacion">Evaluaci&oacute;n</cf_translate></font>
                        </td>
                        <td bgcolor="##CCCCCC" class="LTtopline" colspan="1" align="center">
                            <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Ponderacion">Ponderaci&oacute;n</cf_translate></font>
                        </td>

                    </tr>  
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
					
						<cfset corte=true>
						<cfset colspanTam=detalle.recordcount>
						<cfset sumaDetalle =0>
						<cfset Ponderado =0>
						<cfset cantRespuestas =0>
						<cfsavecontent variable="htmlDetalle">
							<cfloop query="detalle">
							<tr>
								<td class="LTtopline"  colspan="1" align="left">
									<font  style="font-size:11px; font-family:'Arial'">#datos.nombre#</font>
								</td>
								<td  class="LTtopline" colspan="1" align="left">
								  <font  style="font-size:11px; font-family:'Arial'">#datos.RHPcodigo# - #datos.RHPdescpuesto#</font>
								</td>
								<td  class="LTtopline"  colspan="1" align="left">
								  <font  style="font-size:11px; font-family:'Arial'">#datos.centrofuncionalPadre#</font>
								</td>
								<td  class="LTtopline"  colspan="1" align="left">
								  <font  style="font-size:11px; font-family:'Arial'">#datos.centrofuncional#</font>
								</td>
								<td  class="LTtopline"  colspan="1" align="left">
								  <font  style="font-size:11px; font-family:'Arial'">#datos.DEidentificacion#</font>
								</td>
								<td class="LTtopline"  colspan="1" align="left">
									<font  style="font-size:11px; font-family:'Arial'">#detalle.nombre#</font>
								</td>
								<td class="LTtopline"  colspan="1" align="left">
									<font  style="font-size:11px; font-family:'Arial'">#detalle.puesto#</font>
								</td>
								<td  class="LTtopline" colspan="1" align="right">
								  <cfset vnResultado = FuncObtieneResultado(datos.RHEEid,datos.DEid,detalle.DEideval)>
									<cfif vnResultado neq -1>
								  		<font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(vnResultado, ",_.__")#</font>
										<cfset sumaDetalle =sumaDetalle+vnResultado>
										<cfset cantRespuestas = cantRespuestas+1>
									<cfelse>
										<font  style="font-size:11px; font-family:'Arial'">NR</font>
									</cfif>	
								</td>
								<cfset Ponderado =-1>
								<cfif cantRespuestas gt 0>
									<cfset Ponderado =LSNumberFormat(sumaDetalle / cantRespuestas, ",_.__")>
								</cfif>
								<cfif corte>
								<td class="LTtopline" colspan="1" align="right" rowspan="#colspanTam#">
									  <font  style="font-size:11px; font-family:'Arial'">codeReplaceDetalle</font>
								</td>
								</cfif>
								<cfset corte=false>
								<!----- fin busqueda del empleado --->
							</tr>   			 
							</cfloop>   
						</cfsavecontent>  
						<cfif ponderado eq -1><cfset ponderado="NR"></cfif>
						<cfset htmlDetalle =  replace(htmlDetalle,"codeReplaceDetalle",ponderado,"all")>
						#htmlDetalle#         
                    </cfloop> 
                    <tr>
                        <td  class="topline" colspan="11" align="center">
                            <font  style="font-size:11px; font-family:'Arial'">&nbsp;</font>
                        </td>
                    </tr> 
                                 
                </table>
            </td>
        </tr>    
	</table>
</cfoutput>
</cfsavecontent>

<cfif isdefined("Exportar")>
	<cfset archivo = "ReporteNotasPorEvaluador_#hour(now())##minute(now())##second(now())#">
	<cfset txtfile = GetTempFile(getTempDirectory(), 'ReporteEvaluacion')>
	<cfoutput>#REPORTE#</cfoutput>

	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#REPORTE#" charset="windows-1252">
			<cfheader name="Content-Disposition" value="attachment;filename=#archivo#.xls">
			<cfcontent file="#txtfile#" type="application/vnd.ms-excel" deletefile="yes">
<cfelse>
	<cfflush interval="512">
	<cfsetting requesttimeout="36000">
	<cfoutput>#REPORTE#</cfoutput>
</cfif>
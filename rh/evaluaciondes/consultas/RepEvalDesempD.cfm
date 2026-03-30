<!--- <cfdump var="#form#"> 
--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Reporte_Evaluacion_Del_Desempeno_de_Jefaturas_Detallado"
	Default="Reporte Evaluaci&oacute;n Del Desempe&ntilde;o de Jefaturas Detallado"
	returnvariable="LB_Reporte_Evaluacion_Del_Desempeno_de_Jefaturas_Detallado"/>
    
    
<cf_dbtemp name="HR" returnvariable="HojaRealimentacion" datasource="#session.dsn#">
	<cf_dbtempcol name="RHHid" 			type="numeric" 		mandatory="yes">	<!--- Habilidad  --->
	<cf_dbtempcol name="PCid" 			type="numeric" 		mandatory="yes">	<!--- cuestionario asociado a la habilidad  --->
	<cf_dbtempcol name="PPid" 			type="numeric" 		mandatory="no">		<!--- preguntas asociado al cuestionario    --->
	<cf_dbtempcol name="Peso" 			type="money" 		mandatory="no">		<!--- peso de la habilidad  --->
	<cf_dbtempcol name="PesoPregunta" 	type="float" 		mandatory="no">		<!--- Peso de la Pregunta --->
	<cf_dbtempcol name="PesoObtenido"   type="float" 		mandatory="no">		<!--- Peso obtenido de la pregunta  --->
	<cf_dbtempcol name="NotaPreguntaJ" 	type="float" 		mandatory="no">		<!--- nota jefe pregunta   --->
	<cf_dbtempcol name="NotaHabilidadJ" type="float" 		mandatory="no">		<!--- nota jefe habilidad  --->
	<cf_dbtempcol name="RHHdescripcion" type="varchar(255)" mandatory="no">		<!--- descripcion Habilidad  --->
	<cf_dbtempcol name="Pregunta" 		type="varchar(255)" mandatory="no">		<!--- pregunta   --->
	<cf_dbtempcol name="PPtipo" 		type="char" 		mandatory="no">		<!--- tipo de pregunta   --->
	<cf_dbtempcol name="cantidad" 		type="integer" 		mandatory="no">		<!--- cantidad de preguntas   --->
    <cf_dbtempcol name="cantProd" 		type="integer" 		mandatory="no">		<!--- cantidad de preguntas   --->
</cf_dbtemp> 

   
<cfquery datasource="#session.dsn#"  name="Rs_Empleados">
    select DEid from RHListaEvalDes 
    where RHEEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
    and Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
    <cfif isdefined("form.DEid") and len(trim(form.DEid))>
        and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
    </cfif>
</cfquery>

<!--- Informacion general de la evaluacion  --->

 <cfquery datasource="#session.dsn#"  name="Rs_Eval">
	select RHEEdescripcion,RHEEfdesde,RHEEfhasta   from  RHEEvaluacionDes 
	where RHEEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#"> 
</cfquery>

<!--- Funcion para trae la respuesta a una pregunta  --->
<cffunction name="traerValorPregunta">
	<cfargument name="PCUid" required="yes" type="numeric">
	<cfargument name="PCid" required="yes" type="numeric">
	<cfargument name="PPid" required="yes" type="numeric">
	<cfargument name="Usucodigo" required="yes" type="numeric">
	<cfargument name="Usucodigoeval" required="yes" type="numeric">
	
	<cfquery name="respuesta" datasource="#session.DSN#">
		select PCUtexto
		from PortalPreguntaU ppu
		
		inner join PortalCuestionarioU pcu
		on ppu.PCUid=pcu.PCUid
		and pcu.PCUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCUid#">
		and pcu.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">
		and pcu.Usucodigoeval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigoeval#">
		
		where ppu.PCUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCUid#">
		  and ppu.PCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCid#">
		  and ppu.PPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PPid#">	
	</cfquery>
	<cfreturn respuesta.PCUtexto >
</cffunction>

<cffunction name="traerValorRespuesta">			
    <cfargument name='PPCUreferencia'	type='numeric' 	required='yes'>	<!---RHEEid(PCUreferencia/Cod.de la evaluacion)---->
	<cfargument name='PDEid'			type='numeric' 	required='yes'>	<!---DEid(Cod. del evaluante)---->
	<cfargument name='PPCid'			type='numeric' 	required='yes'>	<!---PCid(Cod. del cuestionario)---->
	<cfargument name='PDEideval'		type='numeric' 	required='yes'>	<!---DEideval(Cod.del evaluador)---->
    <cfargument name="PPid" 			type="numeric"  required="yes" >
    <cfargument name="PCUid" 			type="numeric"  required="yes">
	<!----Seleccion de la opcion seleccionada cuando es option button----->
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select  b.PCid,											--id del cuestionario
				b.PPid,											--id de la pregunta
				c.PRid,											--id seleccionado en las respuestas
				coalesce(c.PRUvalor,0.00) as PRUvalor,			--valor respuesta
				coalesce(d.PPvalor,0.00) as PPvalor				--valor pregunta
				,d.PPtipo										--tipo pregunta
				,(select coalesce(max(PRvalor),1) 				--Valor mayor de las respuestas Osea el que significa el 100%
					from PortalRespuesta z
					where z.PCid = b.PCid
						and z.PPid = b.PPid
						and z.PRvalor is not null
				 ) as mayor,

				  (select sum(PRvalor)							--Suma de todos los pesos de todas las posibles respuestas
					from PortalRespuesta x
					where x.PCid = b.PCid
						and x.PPid = b.PPid
						and x.PRvalor is not null
					group by x.PPid
					) as resptotal
		
		from PortalCuestionarioU a 
		
			inner join PortalPreguntaU b
				on a.PCUid = b.PCUid	
                and b.PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PPid#">
		
				inner join PortalPregunta d
					on b.PCid = d.PCid
					and b.PPid = d.PPid
					and d.PPvalor != 0
					and d.PPtipo != 'E'
		
			left outer join PortalRespuestaU c
				on b.PCUid = c.PCUid
				and b.PCid = c.PCid
				and b.PPid = c.PPid
				
		where a.PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PPCUreferencia#">
			and a.DEid     =  	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PDEid#">
			and a.DEideval =   	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PDEideval#">
			and b.PCid     = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PPCid#">
            and a.PCUid    = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCUid#">
			and coalesce(c.PRUvalor,0) >= 0
            and a.PCUid  = (select max(z.PCUid) from PortalCuestionarioU z
                        where a.DEid = z.DEid 
                        and a.DEideval  = z.DEideval 
                        and a.PCUreferencia = z.PCUreferencia  )            
	</cfquery>
	<cfset vnCuestionario = 0>	<!---Sumatoria de todos los promedios de las preguntas--->	
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
					<cfset vnPromedioR = vnPregunta><!---Promedio sobre el peso de la respuesta--->
				<cfelse>
					<cfset vnPromedioR = 0>
				</cfif>
					
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
				<!---<cfset vnPregunta = vnTempNota>--->
				<cfset vnPromedioR = rsDatos.PPvalor>
			</cfif>	
			<!----///////////////Variable donde se van sumando los promedios de  cada pregunta/////////////----->	
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
		<cfif isdefined("vnPCuestionario") and len(trim(vnPCuestionario))>
			<cfset vnPCuestionario = ((vnCuestionario*100)/rsPromedioP.PPvalor)>
		<cfelse>
			<cfset vnPCuestionario = 0>
		</cfif>
	<cfelse>		
		<cfset vnPCuestionario = -1>
	</cfif>
	<cfreturn vnPCuestionario><!---Retorno el resultado---->
</cffunction>
<!--- determina si el evaluado es jefe  --->
<cfset LvarFileName = "Hoja-Realimentacion#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<cf_htmlReportsHeaders 
title="#LB_Reporte_Evaluacion_Del_Desempeno_de_Jefaturas_Detallado#" 
filename="#LvarFileName#"
irA="Hoja-realimentacion-filtro.cfm" 
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

<cfoutput>
    <table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
        <tr>
            <td bgcolor="##CCCCCC" class="RLTtopline" colspan="6" align="center">
                <font  style="font-size:13px; font-family:'Arial'">#session.enombre#</font> 
            </td>
        </tr>
        <tr>
            <td bgcolor="##CCCCCC" class="RLTtopline" colspan="6" align="center">
                <font  style="font-size:13px; font-family:'Arial'">#LB_Reporte_Evaluacion_Del_Desempeno_de_Jefaturas_Detallado#</font> 
            </td>
        </tr>
        <tr>
            <td bgcolor="##CCCCCC" class="RLTtopline" colspan="6" align="center">
                <font  style="font-size:13px; font-family:'Arial'">#Rs_Eval.RHEEdescripcion#&nbsp;<cf_translate  key="LB_del">Del</cf_translate>&nbsp;#LSDateFormat(Rs_Eval.RHEEfdesde,'dd/mm/yyyy')#&nbsp;<cf_translate  key="LB_Hasta">Hasta</cf_translate>&nbsp;#LSDateFormat(Rs_Eval.RHEEfhasta,'dd/mm/yyyy')#  </font> 
            </td>
        </tr>
       <tr >
            <td  class="topline" colspan="6" align="center">
                <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
            </td>
        </tr>
    </table> 
</cfoutput>   
     
<cfset PCUid_A 			 = -1>	
<cfset PCUid_J 			 = -1>	
<cfset VAR_DEid 		 = -1>	
<cfloop query="Rs_Empleados">
   
   <cfset VAR_DEid 		 = Rs_Empleados.DEid>	

    <cfinvoke component="rh.Componentes.RH_Funciones" 
    method="DeterminaJefe"
    DEid = "#VAR_DEid#"
    fecha = "#Now()#"
    returnvariable="esjefe">
    <cfset JefeVal = false>
    <cfif isdefined("esjefe.CFID") and len(trim(esjefe.CFID))>
        <cfset JefeVal = true>
    </cfif>
	
    <!--- Informacion general del evaluador   --->
	
    <cfquery datasource="#session.dsn#"  name="Rs_Jefe">
        select a.DEideval, {fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )}  as jefe 
        from RHEvaluadoresDes a
        inner join  DatosEmpleado de 
            on a.DEideval = de.DEid
            and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        where a.DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">
        and a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
         and a.RHEDtipo in ('J','E') 
    </cfquery>
    
    <!--- extrae los Usucodigo del empleado y del jefe   --->
    <cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
    
    <cfif Rs_Jefe.recordCount GT 0>
        <cfset rsevaluador 		 = sec.getUsuarioByRef(Rs_Jefe.DEideval, session.EcodigoSDC, 'DatosEmpleado')>
        <cfset LvarUsucodigoeval = rsevaluador.Usucodigo >
    </cfif>
    
    <cfset rsevaluado 		 = sec.getUsuarioByRef(VAR_DEid, session.EcodigoSDC, 'DatosEmpleado')>
    <cfset Usucodigo         = rsevaluado.Usucodigo>
    <cfset PCUid_A 			 = -1>	
    <cfset PCUid_J 			 = -1>	
    <!--- Respuestas del Empleado  --->
    <cfquery name="fechaultimaA" datasource="#session.DSN#">
        select max(PCUfecha) as fecha
        from PortalCuestionarioU a
        where a.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">	
          and a.Usucodigoeval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">	
          and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">	
          and a.DEideval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">	
          and a.PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
    </cfquery>
    
    <cfif len(trim(fechaultimaA.fecha))>
        <cfquery name="dataPCUid" datasource="#session.DSN#">
            select PCUid
            from PortalCuestionarioU a
            where a.PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
              and a.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">	
              and a.Usucodigoeval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">	
              and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">	
              and a.DEideval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">	
              and a.PCUfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechaultimaA.fecha#">
        </cfquery>
        <cfif len(trim(dataPCUid.PCUid))>
            <cfset PCUid_A = dataPCUid.PCUid >
        </cfif>
    </cfif>
    
    
    <!--- Respuestas del Jefe  --->
    <cfif Rs_Jefe.recordCount GT 0>
        <cfquery name="fechaultimaJ" datasource="#session.DSN#">
            select max(PCUfecha) as fecha
            from PortalCuestionarioU a
            where a.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">	
              and a.Usucodigoeval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarUsucodigoeval#">	
              and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">	
              and a.DEideval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Rs_Jefe.DEideval#">	
              and a.PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
        </cfquery>
        <cfif len(trim(fechaultimaJ.fecha))>
            <cfquery name="dataPCUid" datasource="#session.DSN#">
                select PCUid
                from PortalCuestionarioU a
                where a.PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
                  and a.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">	
                  and a.Usucodigoeval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarUsucodigoeval#">	
                  and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">	
                  and a.DEideval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Rs_Jefe.DEideval#">	
                  and a.PCUfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechaultimaJ.fecha#">
            </cfquery>
            <cfif len(trim(dataPCUid.PCUid))>
                <cfset PCUid_J = dataPCUid.PCUid >
            </cfif>
        </cfif>
    </cfif>

	<cfquery datasource="#session.dsn#"  name="Rs_Empleado">
        select
		<cfif form.RHOrden eq 'N'>
        	{fn concat({fn concat({fn concat({fn concat(a.DEnombre , ' ' )}, a.DEapellido1 )}, ' ' )}, a.DEapellido2 )} 
		<cfelse>
			{fn concat({fn concat({fn concat({fn concat(a.DEapellido1 , ' ' )}, a.DEapellido2 )}, ' ' )}, a.DEnombre )}
		</cfif>  as empleado,
        (
            select min(de.DLfvigencia)
            from DLaboralesEmpleado de
            inner join RHTipoAccion ta 
               on de.RHTid = ta.RHTid
              and de.Ecodigo =  ta.Ecodigo
              and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
              and ta.RHTcomportam = 1
            where de.DEid = a.DEid	) as Ingreso        
        
        from  DatosEmpleado a 
        where a.DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">
        and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
    </cfquery>    
	
    <!--- carga de la preguntas de la evaluacion --->
    
    <cfquery datasource="#session.dsn#"  name="Rs_insert">
        INSERT 	INTO #HojaRealimentacion# (RHHid, PCid,PPid,Pregunta,RHHdescripcion,PPtipo,Peso,PesoPregunta,PesoObtenido,NotaPreguntaJ,NotaHabilidadJ) 
            select a.RHHid, a.PCid,pp.PPid,  <cf_dbfunction name="to_char" args="pp.PPpregunta"> as PPpregunta,h.RHHdescripcion,PPtipo,
            <cfif JefeVal> RHHpesoJefe <cfelse>RHHpeso</cfif>,pp.PPvalor,0,0,0
            from RHNotasEvalDes a
            inner join RHListaEvalDes x
                on a.RHEEid = x.RHEEid
                and a.DEid = x.DEid
            inner join RHHabilidadesPuesto b
                on a.RHHid=b.RHHid
                and b.RHPcodigo = x.RHPcodigo
                and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and b.PCid is not null
            inner join RHHabilidades h
                on a.RHHid	= h.RHHid
            <!--- inner join PortalCuestionario c
                on b.PCid=c.PCid --->
            inner join PortalPregunta pp
                on a.PCid=pp.PCid
                and pp.PPtipo not in ('E','D')		
    
            where a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
             and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">
    </cfquery>

    <cfquery datasource="#session.dsn#"  name="Rs_insert">
        update #HojaRealimentacion# set cantidad  = (select count(x.PCid) from  #HojaRealimentacion# x  where  x.PCid = #HojaRealimentacion#.PCid and  x.RHHid = #HojaRealimentacion#.RHHid)
    </cfquery>
    <cfquery datasource="#session.dsn#"  name="Rs_insert">
        update #HojaRealimentacion# set cantProd  = (select count(x.PCid) from  #HojaRealimentacion# x  where  x.PCid = #HojaRealimentacion#.PCid  and  x.RHHid = #HojaRealimentacion#.RHHid and x.PPtipo not in ('D','V'))
    </cfquery>
    
    <cfquery datasource="#session.dsn#"  name="Rs_Datos">
        select * from #HojaRealimentacion#
        where PPtipo not in ('D','V')
        order by Peso,RHHdescripcion,Pregunta
    </cfquery>
       
	  
    
    <cfloop query="Rs_Datos">
        <cfif Rs_Jefe.recordCount GT 0>
            <cfif isdefined('PCUid_J') and len(trim(PCUid_J))>
                <!--- <cfset contestadaJ = traerValorRespuesta(PCUid_J, Rs_Datos.PCid, Rs_Datos.PPid,Usucodigo, LvarUsucodigoeval,'PRvalor') > --->
                <cfset contestadaJ = traerValorRespuesta(form.RHEEid,VAR_DEid,Rs_Datos.PCid,Rs_Jefe.DEideval,Rs_Datos.PPid,PCUid_J) >
    
            </cfif>
        </cfif>
        <cfquery datasource="#session.dsn#"  name="Rs_insert">
            update #HojaRealimentacion# set 
                NotaPreguntaJ = <cfif isdefined('contestadaJ') and len(trim(contestadaJ))>#contestadaJ#  <cfelse>null</cfif>
            where  PCid =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Rs_Datos.PCid#">
            and  PPid 	= 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Rs_Datos.PPid#">
        </cfquery>
    </cfloop>
    

    <cfif len(trim(Rs_Jefe.DEideval))>
         <cfquery datasource="#session.dsn#"  name="Rs_insert">
            update #HojaRealimentacion# set NotaHabilidadJ  = 
            coalesce(((select  <cf_dbfunction name="to_float" args="RHNEDnotajefe">         
                from  RHNotasEvalDes x  
                where x.RHEEid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
                and x.DEid 		  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">
                and x.RHHid       =  #HojaRealimentacion#.RHHid 
             )* 1.0000),0)
        </cfquery>
    </cfif>
	
	<cfquery datasource="#session.dsn#"  name="Rs_insert">
		update #HojaRealimentacion# set PesoObtenido  = (Peso * NotaHabilidadJ) /100 
	</cfquery>
    
    <cfquery datasource="#session.dsn#"  name="Rs_Datos">
        select * from #HojaRealimentacion#
        order by Peso,RHHdescripcion,Pregunta
    </cfquery>

	 

	<!--- <cfdump var="#Rs_Datos#"> --->
    
    <cfquery datasource="#session.dsn#"  name="nota">
        select RHLEnotajefe  as Nota_desempeno from RHListaEvalDes 
        where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">
        and RHEEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
    </cfquery>
    
    <cfoutput>
        <table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
            <tr >
                <td bgcolor="##CCCCCC" class="RLTtopline" colspan="6" align="left">
                    <font  style="font-size:13px; font-family:'Arial'">#Rs_Empleado.empleado#&nbsp;&nbsp;&nbsp;<cf_translate  key="LB_Fecha_de_Nombramiento">Fecha de Nombramiento</cf_translate>#LSDateFormat(Rs_Empleado.Ingreso,'dd/mm/yyyy')#</font></td>
            </tr>
            <tr >
                <td width="28%" bgcolor="##CCCCCC" class="LTtopline" rowspan="1" colspan="1" align="left">
                    <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Habilidad">Habilidad</cf_translate></font>			</td>
                <td width="8%" bgcolor="##CCCCCC" class="LTtopline" rowspan="1" colspan="1" align="left">
                    <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Nota_Habilidad">Nota Habilidad</cf_translate></font>	</td>    
                <td width="8%" bgcolor="##CCCCCC" class="LTtopline" colspan="1" align="center">
                    <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Peso">Peso</cf_translate></font>			</td>
                <td  width="8%" bgcolor="##CCCCCC" class="RLTtopline" colspan="1" align="center">
                    <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Peso_Obtenido">Peso Obtenido</cf_translate></font>			</td>
                <td width="40%" bgcolor="##CCCCCC"class="LTtopline" rowspan="1" colspan="1" align="left">
                    <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Conductas">Conductas</cf_translate></font>			</td>
                <td width="8%" bgcolor="##CCCCCC" class="RLTtopline" colspan="1" align="center">
                    <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Nota_Obtenida">Nota Obtenida</cf_translate></font>			</td>
            </tr>
            <cfset CORTE = "">
			<cfset NotaGeneral = 0> 
			<cfset NotaH = 0> 
			<cfset NotaP = 0> 
			
						
            <cfloop query="Rs_Datos">
                <cfset NotaH = (Rs_Datos.NotaHabilidadJ * form.RHEid)/100> 
				<cfset NotaP = (Rs_Datos.NotaPreguntaJ * form.RHEid)/100> 
				
				<cfif trim(Rs_Datos.RHHid) neq trim(CORTE)>
                    <cfset CORTE = #trim(Rs_Datos.RHHid)#>
					<cfset NotaGeneral = NotaGeneral + Rs_Datos.PesoObtenido> 
                    <tr>
                        <td  class="LTtopline"  rowspan="#Rs_Datos.cantidad#" align="justify">
                            <font  style="font-size:11px; font-family:'Arial'">#Rs_Datos.RHHdescripcion#</font>					
                        </td>
                        <td  class="LTtopline"  rowspan="#Rs_Datos.cantidad#" align="center">
                            <font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(NotaH,'____.__')#</font>					
                        </td>
                        <td  class="LTtopline" rowspan="#Rs_Datos.cantidad#" align="center" valign="middle">
                            <cfif len(trim(Rs_Datos.Peso))>
                                <font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(Rs_Datos.Peso,'____.__')#</font> 
                            <cfelse>
                                <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
                            </cfif>					</td>
                        <td class="LTtopline"  rowspan="#Rs_Datos.cantidad#" align="center" valign="middle">
                            <cfif len(trim(Rs_Datos.PesoObtenido))>
                                <font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(Rs_Datos.PesoObtenido,'____.__')#</font> 
                            <cfelse>
                                <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
                            </cfif>					
                        </td>
                        
						<td class="LTtopline" colspan="1" align="justify">
                            <font  style="font-size:11px; font-family:'Arial'">#Rs_Datos.Pregunta#</font>					
                        </td>
                        <td class="RLTtopline"  colspan="1" align="center" valign="middle">
                            <cfif len(trim(Rs_Datos.NotaPreguntaJ))>
                                <font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(Rs_Datos.NotaPreguntaJ,'____.__')# </font>
                            <cfelse>
                                <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
                            </cfif>					
                        </td>
                    </tr>
                <cfelse>
                    <tr>
                        <td  class="LTtopline" colspan="1" align="justify">
                            <font  style="font-size:11px; font-family:'Arial'">#Rs_Datos.Pregunta#</font>					
                        </td>
                        <td class="RLTtopline"  colspan="1" align="center" valign="middle">
                            <cfif len(trim(Rs_Datos.NotaPreguntaJ))>
                                <font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(NotaP,'____.__')#</font> 
                            <cfelse>
                                <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
                            </cfif>					
                        </td>
                        
                    </tr>
                </cfif>	
				<cfset NotaH = 0> 
				<cfset NotaP = 0>
            </cfloop>
			<tr>
                <td class="LTtopline"  colspan="3" align="center">
                     <font  style="font-size:11px; font-family:'Arial'">&nbsp;</font>
				 </td>
				 <td class="LTtopline"  colspan="1" align="center">
                     <font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(NotaGeneral,'____.__')#</font>
				 </td>
				 <td class="RLTtopline"  colspan="3" align="center">
                     <font  style="font-size:11px; font-family:'Arial'">&nbsp;</font>
				 </td>
            </tr>
            <tr>
                <td class="topline"  colspan="6" align="center">
                     <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;			</td>
            </tr>
        </table>
    </cfoutput>
    <cfquery datasource="#session.dsn#"  name="Rs_insert">
        delete from #HojaRealimentacion# 
    </cfquery>

</cfloop>	
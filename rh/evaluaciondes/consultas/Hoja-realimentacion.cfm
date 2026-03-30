<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!---<cfoutput>#session.usucodigo#</cfoutput>

<cf_dump var="#form#"> 
 VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_reporte_de_realimentacionEvaluacionDesempenno" default="Reporte de realimentaci&oacute;n Evaluaci&oacute;n del Desempe&ntilde;o" returnvariable="LB_reporte_de_realimentacionEvaluacionDesempenno" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_NA" default="NA" returnvariable="LB_NA" component="sif.Componentes.Translate" method="Translate"/>    
<cfinvoke key="LB_Nulo" default="Nulo" returnvariable="LB_Nulo" component="sif.Componentes.Translate" method="Translate"/>    
<cfinvoke key="LB_Basico" default="B&aacute;sico" returnvariable="LB_Basico" component="sif.Componentes.Translate" method="Translate"/>    
<cfinvoke key="LB_Intermedio" default="Intermedio" returnvariable="LB_Intermedio" component="sif.Componentes.Translate" method="Translate"/>    
<cfinvoke key="LB_Avanzado" default="Avanzado" returnvariable="LB_Avanzado" component="sif.Componentes.Translate" method="Translate"/>  
<cfinvoke key="LB_Actualizacion_Refrescamiento" default="Actualizaci&oacute;n / Refrescamiento" returnvariable="LB_Actualizacion_Refrescamiento" component="sif.Componentes.Translate" method="Translate"/>
  
<!--- FIN VARIABLES DE TRADUCCION --->

<cf_dbtemp name="HojaRealimentacion" returnvariable="HojaRealimentacion" datasource="#session.dsn#">
	<cf_dbtempcol name="RHHid" 			type="numeric" 		mandatory="yes">	<!--- Habilidad  --->
	<cf_dbtempcol name="PCid" 			type="numeric" 		mandatory="yes">	<!--- cuestionario asociado a la habilidad  --->
	<cf_dbtempcol name="PPid" 			type="numeric" 		mandatory="no">		<!--- preguntas asociado al cuestionario    --->
	<cf_dbtempcol name="Peso" 			type="money" 		mandatory="no">		<!--- peso de la habilidad  --->
	<cf_dbtempcol name="NotaPreguntaA" 	type="float" 		mandatory="no">		<!--- nota autoevaluacion pregunta  --->
	<cf_dbtempcol name="NotaHabilidadA" type="float" 		mandatory="no">		<!--- nota autoevaluacion habilidad  --->
	<cf_dbtempcol name="NotaPreguntaJ" 	type="float" 		mandatory="no">		<!--- nota jefe pregunta   --->
	<cf_dbtempcol name="NotaHabilidadJ" type="float" 		mandatory="no">		<!--- nota jefe habilidad  --->
	<cf_dbtempcol name="NotaPreguntaO" 	type="float" 		mandatory="no">		<!--- nota jefe pregunta   --->
	<cf_dbtempcol name="NotaHabilidadO" type="float" 		mandatory="no">		<!--- nota jefe habilidad  --->
	<cf_dbtempcol name="RHHdescripcion" type="varchar(255)" mandatory="no">		<!--- descripcion Habilidad  --->
	<cf_dbtempcol name="Pregunta" 		type="varchar(255)" mandatory="no">		<!--- pregunta   --->
	<cf_dbtempcol name="PPtipo" 		type="char" 		mandatory="no">		<!--- tipo de pregunta   --->
	<cf_dbtempcol name="cantidad" 		type="integer" 		mandatory="no">		<!--- cantidad de preguntas   --->
    <cf_dbtempcol name="cantProd" 		type="integer" 		mandatory="no">		<!--- cantidad de preguntas   --->
</cf_dbtemp> 

   
<cfquery datasource="#session.dsn#"  name="Rs_Empleados">
    select a.DEid 
	from RHListaEvalDes a
    where a.RHEEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
	    and a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
		<cfif isdefined("form.DEid") and len(trim(form.DEid))>
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfif>
		<cfif isdefined("form.DEideval") and len(trim(form.DEideval))>
			and exists(	select 1
						from RHEvaluadoresDes x
						where a.RHEEid = x.RHEEid
							and x.DEid = a.DEid
							and x.DEideval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEideval#">
							and x.RHEDtipo in ('J','E')
						)		
		</cfif>
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
			<!--- and b.PCid     = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PPCid#"> --->
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
			<!---///////////////////////SELECCION UNICA///////////////////////////////////////////
				Cuando es un option buton(seleccion unica) se promedia el valor de la respuesta seleccionada
				segun el puntaje mayor (EJ: Si las posibles respuestas son > opt1:20,opt2:30,opt3:15 y se seleccionaron la 1 y 2
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
	<!---
	<cfdump var="#vnPromedioR#">
	<cfdump var="#vnPCuestionario#"> 
	<cf_dump var="#rsDatos#"> 
	 	
	--->
	<cfreturn vnPCuestionario><!---Retorno el resultado---->
</cffunction>
<!--- determina si el evaluado es jefe  --->
<cfset LvarFileName = "Hoja-Realimentacion#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<cf_htmlReportsHeaders 
title="#LB_reporte_de_realimentacionEvaluacionDesempenno#" 
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

<cfset PCUid_A 			 = -1>	
<cfset PCUid_J 			 = -1>	
<cfset VAR_DEid 		 = -1>	

	
<cfloop query="Rs_Empleados">
   
   <cfset VAR_DEid 		 = Rs_Empleados.DEid>	

    <cfinvoke component="rh.Componentes.RH_Funciones" method="DeterminaJefe" deid = "#VAR_DEid#" fecha = "#Now()#" returnvariable="esjefe">
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
          and a.PCUestado= 10
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
              and a.PCUestado= 10
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
              and a.PCUestado= 10
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
                  and a.PCUestado= 10
            </cfquery>
            <cfif len(trim(dataPCUid.PCUid))>
                <cfset PCUid_J = dataPCUid.PCUid >
            </cfif>
        </cfif>
    </cfif>
    
    <!--- Informacion general de la evaluacion  --->
    
     <cfquery datasource="#session.dsn#"  name="Rs_Eval">
        select RHEEdescripcion,RHEEfhasta   from  RHEEvaluacionDes 
        where RHEEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#"> 
    </cfquery>
	
	  
    
    <!--- Informacion general del evaluado --->
    
    
     <cfquery datasource="#session.dsn#"  name="Rs_Empleado">
			select {fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as empleado,
            case when rp.RHPpuesto is null then 'Actualmente no se encuentra nombrado (a)' else  p.RHPdescpuesto end   as puesto,
            case when rp.CFid is null then 'Actualmente no se encuentra nombrado (a)' else {fn concat(CFcodigo,{fn concat(' ',CFdescripcion)})}end as centrofuncional
        from  DatosEmpleado de 
        left outer join LineaTiempo  lt
            on de.DEid = lt.DEid
            and  <cfqueryparam value="#Rs_Eval.RHEEfhasta#" cfsqltype="cf_sql_timestamp">  between LTdesde  and  LThasta 
				left outer join RHPlazas rp
            on lt.RHPid  = rp.RHPid  
            and rp.Ecodigo =  de.Ecodigo
        left outer join RHPuestos p
            on rp.RHPpuesto  = p.RHPcodigo
             and p.Ecodigo =  de.Ecodigo
            
        left outer join CFuncional cf
            on  rp.CFid = cf.CFid            	
        where de.DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">
			order by LTdesde
    </cfquery>

 
    <!--- carga de la preguntas de la evaluacion --->
    
    <cfquery datasource="#session.dsn#"  name="Rs_insert">
        INSERT 	INTO #HojaRealimentacion# (RHHid, PCid,PPid,Pregunta,RHHdescripcion,PPtipo,Peso) 
            select a.RHHid, a.PCid,pp.PPid,  <cf_dbfunction name="to_char" args="pp.PPpregunta"> as PPpregunta,h.RHHdescripcion,PPtipo,
            <cfif JefeVal> RHHpesoJefe <cfelse>RHHpeso</cfif>
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

            inner join PortalPregunta pp
                on a.PCid=pp.PCid
                and pp.PPtipo not in ('E')		
    
            where a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
             and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">
    </cfquery>

    <cfquery datasource="#session.dsn#"  name="Rs_insert">
        update #HojaRealimentacion# set cantidad  = (select count(x.PCid) from  #HojaRealimentacion# x  where  x.PCid = #HojaRealimentacion#.PCid and  x.RHHid = #HojaRealimentacion#.RHHid)
    </cfquery>
    <cfquery datasource="#session.dsn#"  name="Rs_insert">
        update #HojaRealimentacion# set cantProd  = (select count(x.PCid) from  #HojaRealimentacion# x  where  x.PCid = #HojaRealimentacion#.PCid and  x.RHHid = #HojaRealimentacion#.RHHid  and x.PPtipo not in ('D','V'))
    </cfquery>
    
    <cfquery datasource="#session.dsn#"  name="Rs_Datos">
        select * from #HojaRealimentacion#
        where PPtipo not in ('D','V')
        order by Peso,RHHdescripcion,Pregunta
    </cfquery>
    
   
    
    <cfloop query="Rs_Datos">
        <cfset contestadaA = "">
        <cfset contestadaJ = "">
        
        <cfif Rs_Jefe.recordCount GT 0>
            <cfif isdefined('PCUid_J') and len(trim(PCUid_J))>
                <!--- <cfset contestadaJ = traerValorRespuesta(PCUid_J, Rs_Datos.PCid, Rs_Datos.PPid,Usucodigo, LvarUsucodigoeval,'PRvalor') > --->
                <cfset contestadaJ = traerValorRespuesta(form.RHEEid,VAR_DEid,Rs_Datos.PCid,Rs_Jefe.DEideval,Rs_Datos.PPid,PCUid_J) >
    
            </cfif>
        </cfif>
        <cfif isdefined('PCUid_A') and len(trim(PCUid_A))>
            <!--- <cfset contestadaA = traerValorRespuesta(PCUid_A, Rs_Datos.PCid, Rs_Datos.PPid,Usucodigo, Usucodigo,'PRvalor') > --->
            <cfset contestadaA = traerValorRespuesta(form.RHEEid,VAR_DEid,Rs_Datos.PCid,VAR_DEid,Rs_Datos.PPid,PCUid_A) >

        </cfif>
		<!--- evaluadores --->
		<cfquery name="rsTodos" datasource="#session.DSN#">
			select DEideval				 
			from RHEvaluadoresDes a
			where a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">
				and a.RHEDtipo in ('C','S','J')
				and a.RHEEid in (	select PCUreferencia 
					from PortalCuestionarioU pcu
					where pcu.PCUestado=10
					and pcu.PCUreferencia = a.RHEEid
					and pcu.DEid = a.DEid
			)	
		</cfquery>
		
		<cfset contestadaO= 0>
			<cfset Lvar_PPCid = Rs_Datos.PCid>
			<cfset  Lvar_PPid = Rs_Datos.PPid>
		<cfif isdefined('rsTodos') and rsTodos.RecordCount>
			<cfloop query="rsTodos">
				<cfset Lvar_Evaluador = rsTodos.DEideval>
		    <cfset rsevaluador 		 = sec.getUsuarioByRef(Lvar_Evaluador, session.EcodigoSDC, 'DatosEmpleado')>
		    	
				<cfquery name="fechaultimaO" datasource="#session.DSN#">
					select max(PCUfecha) as fecha
					from PortalCuestionarioU a
					where a.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">	
					  and a.Usucodigoeval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsevaluador.Usucodigo#">	
					  and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">	
					  and a.DEideval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Evaluador#">	
					  and a.PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
					  and a.PCUestado= 10
				</cfquery>
			 <cfquery name="dataPCUidO" datasource="#session.DSN#">
					select PCUid
					from PortalCuestionarioU a
					where a.PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
					  and a.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">	
					  and a.Usucodigoeval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsevaluador.Usucodigo#">	
					  and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">	
					  and a.DEideval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Evaluador#">	
					  and a.PCUfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechaultimaO.fecha#">
					  and a.PCUestado= 10
				</cfquery>
				<cfset CuestionarioU = dataPCUidO.PCUid>
				
        <cfset contestadaO = contestadaO + traerValorRespuesta(form.RHEEid,VAR_DEid,Lvar_PPCid,Lvar_Evaluador,Lvar_PPid,CuestionarioU) >
       
			</cfloop>
 		   

			<cfset contestadaO= contestadaO/rsTodos.RecordCount>
		</cfif>
        <cfquery datasource="#session.dsn#"  name="Rs_insert">
            update #HojaRealimentacion# set 
                NotaPreguntaA = <cfif isdefined('contestadaA') and len(trim(contestadaA))>#contestadaA#<cfelse>null</cfif>,
                NotaPreguntaJ = <cfif isdefined('contestadaJ') and len(trim(contestadaJ))>#contestadaJ#<cfelse>null</cfif>,
								NotaPreguntaO = <cfif isdefined('contestadaO') and len(trim(contestadaO))>#contestadaO#<cfelse>null</cfif>
            where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Rs_Datos.PCid#">
            and  PPid 	= 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Rs_Datos.PPid#">
        </cfquery>
    </cfloop>
     
   
     <cfquery datasource="#session.dsn#"  name="Rs_insert">
        update #HojaRealimentacion# set NotaHabilidadA  = 
        ((select  <cf_dbfunction name="to_float" args="RHNEDnotaauto">         
            from  RHNotasEvalDes x    
            where x.RHEEid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
            and x.DEid 		  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">
            and x.RHHid       =  #HojaRealimentacion#.RHHid 
         )* 1.0000)
    </cfquery>
    <cfif len(trim(Rs_Jefe.DEideval))>
         <cfquery datasource="#session.dsn#"  name="Rs_insert">
            update #HojaRealimentacion# set NotaHabilidadJ  = 
            ((select  <cf_dbfunction name="to_float" args="RHNEDnotajefe">         
                from  RHNotasEvalDes x  
                where x.RHEEid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
                and x.DEid 		  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">
                and x.RHHid       =  #HojaRealimentacion#.RHHid 
             )* 1.0000)
        </cfquery>
    </cfif>
    <cfquery datasource="#session.dsn#"  name="Rs_insert">
        update #HojaRealimentacion# set NotaHabilidadO  = 
        ((select  <cf_dbfunction name="to_float" args="RHNEDpromJCS">         
            from  RHNotasEvalDes x    
            where x.RHEEid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
            and x.DEid 		  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">
            and x.RHHid       =  #HojaRealimentacion#.RHHid 
         )* 1.0000)
    </cfquery>

	
	
    
	<cfquery datasource="#session.dsn#"  name="Rs_insert">
		update #HojaRealimentacion# 
		set NotaPreguntaA 	= (NotaPreguntaA *<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHEid#">)/100,
		NotaHabilidadA 		= (NotaHabilidadA *<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHEid#">)/100,
		NotaPreguntaJ 		= (NotaPreguntaJ *<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHEid#">)/100,
		NotaHabilidadJ 		= (NotaHabilidadJ *<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHEid#">)/100,
		NotaPreguntaO 		= (NotaPreguntaO *<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHEid#">)/100,
		NotaHabilidadO 		= (NotaHabilidadO *<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHEid#">)/100
	</cfquery>
	
	
     <cfquery datasource="#session.dsn#"  name="Rs_Datos">
        select * from #HojaRealimentacion#
        order by Peso,RHHdescripcion,Pregunta
    </cfquery> 
	
    <cfquery datasource="#session.dsn#"  name="nota">
        select (RHLEnotajefe *<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHEid#">)/100   as Nota_desempeno from RHListaEvalDes 
        where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">
        and RHEEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
    </cfquery>
    
    
    <!--- CONOCIMIENTOS --->
	 <cfquery datasource="#session.DSN#" name="rsParteC" >
        select 
                    {fn concat(rtrim(d.RHCcodigo),{fn concat(' - ',d.RHCdescripcion)})}as RHCdescripcion, 
                    h.RHNcodigo, 
                    (c.RHCnotamin*100) as notamin, 
                    c.RHCid,
                    a.RHNEDpeso as RHCpeso, 
                    case a.RHNEDnotaauto 
						when -1 then '#LB_NA#'
						when 0 then '#LB_Nulo#'
						when 33 then '#LB_Basico#'
						when 66 then '#LB_Intermedio#'
						when 100 then '#LB_Actualizacion_Refrescamiento#'
						when 99  then '#LB_Avanzado#' end as autoevaluacion,
					 case a.RHNEDnotajefe 
						when -1 then '#LB_NA#'
						when 0 then '#LB_Nulo#'
						when 33 then '#LB_Basico#'
						when 66 then '#LB_Intermedio#'
						when 100 then '#LB_Actualizacion_Refrescamiento#'
						when 99 then '#LB_Avanzado#' end as notajefe  ,
						a.RHNEDnotajefe, a.RHNEDnotaauto  
        from RHNotasEvalDes a
        
        inner join RHListaEvalDes b
        on b.RHEEid=a.RHEEid
        and b.DEid=a.DEid
        and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        
        inner join RHConocimientosPuesto c
        on c.RHPcodigo=b.RHPcodigo
        and c.Ecodigo=b.Ecodigo
        and c.RHCid=a.RHCid
        
        inner join RHConocimientos d
        on d.Ecodigo=c.Ecodigo
        and d.RHCid=c.RHCid
        
        left outer join RHNiveles h
        on h.RHNid=c.RHNid
        and h.Ecodigo=c.Ecodigo
        
        where a.RHEEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
          and a.RHCid is not null
          and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">
        order by coalesce((a.RHNEDnotajefe+a.RHNEDpromotros)/2,0) desc 
    </cfquery>
    <!---  <cf_dump var="#rs_datos#"> --->
   
    <cfoutput>
        <table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
			<tr><td bgcolor="##CCCCCC" class="RLTtopline" colspan="<cfif isdefined('form.chk360')>7<cfelse>6</cfif>" align="center">
                    <font  style="font-size:13px; font-family:'Arial'">#LB_reporte_de_realimentacionEvaluacionDesempenno#</font>			</td>
            </tr>
            <tr>
                <td class="LTtopline" align="left" width="25%">
                    
                    <font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Nombre_Persona">Nombre Persona:</cf_translate></font>			</td>
                <td class="topline" align="left" width="25%">
                    <font  style="font-size:11px; font-family:'Arial'">#Rs_Empleado.empleado#</font>			</td>
                <td class="LTtopline" colspan="2" align="left" width="25%">
                    <font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Puesto">Puesto:</cf_translate></font>			</td>
                <td  class="RTtopline" colspan="<cfif isdefined('form.chk360')>4<cfelse>2</cfif>" align="left" width="25%">
                    <font  style="font-size:11px; font-family:'Arial'">#Rs_Empleado.puesto#</font>			</td>
            </tr>	
            <tr>
                <td class="LTtopline" align="left" width="25%">
                    <font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Fecha_Evaluacion">Fecha Evaluaci&oacute;n:</cf_translate></font>			</td>
                <td class="topline"  align="left" width="25%">
                    <font  style="font-size:11px; font-family:'Arial'">#LSDateFormat(Rs_Eval.RHEEfhasta,'dd/mm/yyyy')#</font>			</td>
                <td class="LTtopline" colspan="2" align="left" width="25%">
                    <font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Nombre_de_jefe_inmediato">Nombre de jefe inmediato:</cf_translate></font>			</td>
                <td  class="RTtopline" colspan="<cfif isdefined('form.chk360')>4<cfelse>2</cfif>" align="left" width="25%">
                    <font  style="font-size:11px; font-family:'Arial'"><cfif Rs_Jefe.recordCount GT 0>#Rs_Jefe.jefe#<cfelse><cf_translate  key="LB_No_fue_evaluado_por_un_jefe">**No fue evaluado por un jefe**</cf_translate></cfif></font>			</td>
            </tr>
            <tr>
                <td class="LTtopline" align="left" width="25%">
                    <font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Area">&Aacute;rea:</cf_translate></font>			</td>
                <td  class="topline" align="left" width="25%">
                  <font  style="font-size:11px; font-family:'Arial'">#Rs_Empleado.centrofuncional#</font>			</td>
                <td class="LTtopline" colspan="2" align="left" width="25%">
                    <font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Evaluacion">Evaluaci&oacute;n:</cf_translate></font>			</td>
                <td  class="RTtopline"  colspan="<cfif isdefined('form.chk360')>4<cfelse>2</cfif>" align="left" width="25%">
                    <font  style="font-size:11px; font-family:'Arial'">#Rs_Eval.RHEEdescripcion#</font>			</td>
            </tr>	
            <tr >
                <td bgcolor="##CCCCCC" class="Completoline" colspan="<cfif isdefined('form.chk360')>8<cfelse>6</cfif>" align="center">
                    <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Resultado_de_Evaluacion">Resultado de Evaluaci&oacute;n de Habilidades</cf_translate></font>			</td>
            </tr>
            <tr >
                <td  colspan="<cfif isdefined('form.chk360')>8<cfelse>6</cfif>" align="center">
                    <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;			</td>
            </tr>
            <tr >
                <td bgcolor="##CCCCCC" class="LTtopline" rowspan="2" colspan="1" align="left">
                    <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Habilidad">Habilidad</cf_translate></font>			</td>
                <td bgcolor="##CCCCCC"class="LTtopline" rowspan="2" colspan="1" align="left">
                    <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Conductas">Conductas</cf_translate></font>			</td>
                <td bgcolor="##CCCCCC" class="LTtopline" colspan="2" align="center">
                    <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Autoevaluacion">Autoevaluaci&oacute;n</cf_translate></font>			</td>
                <td bgcolor="##CCCCCC" class="<cfif isdefined('form.chk360')>LTtopline<cfelse>RLTtopline</cfif>" colspan="2" align="center">
                    <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Evaluacion_efe">Evaluaci&oacute;n Jefe</cf_translate></font>			</td>
				<cfif isdefined('form.chk360')>
                <td bgcolor="##CCCCCC" class="RLTtopline" colspan="2" align="center">
                    <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Evaluacion_otros">Evaluaci&oacute;n J-C-S</cf_translate></font>			</td>
				</cfif>
            </tr>
            <tr >
                <td bgcolor="##CCCCCC" class="LTtopline" colspan="1" align="center">
                     <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Nota_Conducta">Nota Conducta</cf_translate></font>			</td>
                <td bgcolor="##CCCCCC" class="LTtopline" colspan="1" align="center">
                    <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Nota_Habilidad">Nota Habilidad</cf_translate></font>			</td>
                <td  bgcolor="##CCCCCC" class="LTtopline" colspan="1" align="center">
                    <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Nota_Conducta">Nota Conducta</cf_translate></font>			</td>
                <td bgcolor="##CCCCCC" class="<cfif isdefined('form.chk360')>LTtopline<cfelse>RLTtopline</cfif>" colspan="1" align="center">
                         <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Nota_Habilidad">Nota Habilidad</cf_translate></font>			</td>
				<cfif isdefined('form.chk360')>
                <td  bgcolor="##CCCCCC" class="LTtopline" colspan="1" align="center">
                    <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Nota_Conducta">Nota Conducta</cf_translate></font>			</td>
                <td bgcolor="##CCCCCC" class="RLTtopline" colspan="1" align="center">
                         <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Nota_Habilidad">Nota Habilidad</cf_translate></font>			</td>
				</cfif>
            </tr>
            <cfset CORTE = "">
            <cfloop query="Rs_Datos">
                <cfif trim(Rs_Datos.RHHid) neq trim(CORTE)>
                    <cfset CORTE = #trim(Rs_Datos.RHHid)#>
                    <tr>
                        <td  class="LTtopline"  rowspan="#Rs_Datos.cantidad#" align="justify">
                            <font  style="font-size:11px; font-family:'Arial'">#Rs_Datos.RHHdescripcion#</font>					</td>
                        <td class="LTtopline" colspan="1" align="justify">
                            <font  style="font-size:11px; font-family:'Arial'">#Rs_Datos.Pregunta#</font>					</td>
                        <td class="LTtopline"  colspan="1" align="center" valign="middle">
                            <cfif len(trim(Rs_Datos.NotaPreguntaA)) and Rs_Datos.NotaPreguntaA gte 0>
                                <font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(Rs_Datos.NotaPreguntaA,'____.__')# </font>
                            <cfelse>
                                <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
                            </cfif>					</td>
                        <td  class="LTtopline" rowspan="#Rs_Datos.cantidad#" align="center" valign="middle">
                            <cfif len(trim(Rs_Datos.NotaHabilidadA)) and Rs_Datos.NotaHabilidadA gte 0>
                                <font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(Rs_Datos.NotaHabilidadA,'____.__')#</font> 
                            <cfelse>
                                <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
                            </cfif>					</td>
                        <td class="LTtopline"  colspan="1" align="center" valign="middle">
                            <cfif len(trim(Rs_Datos.NotaPreguntaJ)) and Rs_Datos.NotaPreguntaJ gte 0>
                                <font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(Rs_Datos.NotaPreguntaJ,'____.__')#</font> 
                            <cfelse>
                                <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
                            </cfif>					</td>
                        <td class="<cfif isdefined('form.chk360')>LTtopline<cfelse>RLTtopline</cfif>"  rowspan="#Rs_Datos.cantidad#" align="center" valign="middle">
                            <cfif len(trim(Rs_Datos.NotaHabilidadJ))  and Rs_Datos.NotaHabilidadJ gte 0>
                                <font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(Rs_Datos.NotaHabilidadJ,'____.__')#</font> 
                            <cfelse>
                                <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
                            </cfif>					</td>
						<cfif isdefined('form.chk360')>
                        <td class="LTtopline"  colspan="1" align="center" valign="middle">
                            <cfif len(trim(Rs_Datos.NotaPreguntaO)) and Rs_Datos.NotaPreguntaO gte 0>
                              <font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(Rs_Datos.NotaPreguntaO,'____.__')#</font>
                              <cfelse>
                                <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
                            </cfif>					</td>
                        <td class="RLTtopline"  rowspan="#Rs_Datos.cantidad#" align="center" valign="middle">
                            <cfif len(trim(Rs_Datos.NotaHabilidadO))  and Rs_Datos.NotaHabilidadO gte 0>
                                <font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(Rs_Datos.NotaHabilidadO,'____.__')#</font> 
                            <cfelse>
                                <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
                            </cfif>					</td>
						</cfif>
                    </tr>
                <cfelse>
                    <tr>
                        <td  class="LTtopline" colspan="1" align="justify">
                            <font  style="font-size:11px; font-family:'Arial'">#Rs_Datos.Pregunta#</font>					</td>
                        <td class="LTtopline"  colspan="1" align="center" valign="middle">
                            <cfif len(trim(Rs_Datos.NotaPreguntaA))  and Rs_Datos.NotaPreguntaA gte 0>
                                <font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(Rs_Datos.NotaPreguntaA,'____.__')#</font> 
                            <cfelse>
                                <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
                            </cfif>					</td>
                        <td class="LTtopline"  colspan="1" align="center" valign="middle">
                            <cfif len(trim(Rs_Datos.NotaPreguntaJ)) and Rs_Datos.NotaPreguntaJ gte 0>
                                <font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(Rs_Datos.NotaPreguntaJ,'____.__')#</font> 
                            <cfelse>
                                <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
                            </cfif>					</td>
						<cfif isdefined('form.chk360')>
                        <td class="LTtopline"  colspan="1" align="center" valign="middle">
                            <cfif len(trim(Rs_Datos.NotaPreguntaO)) and Rs_Datos.NotaPreguntaO gte 0>
                                <font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(Rs_Datos.NotaPreguntaO,'____.__')#</font> 
                            <cfelse>
                                <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
                            </cfif>					
							</td>
						</cfif>
                    </tr>
                </cfif>	
            </cfloop>
    
            <tr>
                <td class="topline"  colspan="<cfif isdefined('form.chk360')>8<cfelse>6</cfif>" align="center">
                     <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;			</td>
            </tr>
    
            <tr>
                <td  colspan="<cfif isdefined('form.chk360')>8<cfelse>6</cfif>" align="center"> <div style="page-break-after:always"></div> </td>
            </tr>
            
    		<!--- CONOCIMIENTOS --->
			<cfif isdefined('rsParteC') and rsParteC.RecordCount>
				<tr><td colspan="6" align="center"><font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;</td></tr>
				<tr>
					<td colspan="6" align="center">
						<table align="center"   width="100% "cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td bgcolor="##CCCCCC" class="LTtopline"  colspan="1" align="left" width="40%">
									<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Habilidad">Conocimiento</cf_translate></font>								</td>
								<td bgcolor="##CCCCCC" class="LTtopline" colspan="1" align="center" width="10%">
									<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Autoevaluacion">Autoevaluaci&oacute;n</cf_translate></font>								</td>
								<td bgcolor="##CCCCCC" class="LTtopline" colspan="1" align="center" width="10%">
									<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Jefe">Jefe</cf_translate></font>								</td>
								<td bgcolor="##CCCCCC" class="LTtopline" colspan="1" align="center" width="20%">
									<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_RequiereCapacitacion">Requiere Capacitaci&oacute;n</cf_translate></font>								</td>
								<td bgcolor="##CCCCCC" class="RLTtopline" colspan="1" align="center" width="20%">
									<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Prioridad">Prioridad (1,2,3)</cf_translate></font>								</td>
							</tr>  
							<cfloop query="rsParteC">
								<tr>
									<td  class="LTtopline"  colspan="1" align="left">
									  <font  style="font-size:11px; font-family:'Arial'">#rsParteC.RHcdescripcion#</font>									</td>
									<td class="LTtopline" colspan="1" align="center">
									 &nbsp;&nbsp; <font  style="font-size:11px; font-family:'Arial'">#rsParteC.autoevaluacion#</font>									</td>
									 <td class="LTtopline" colspan="1" align="center">
									 &nbsp;&nbsp; <font  style="font-size:11px; font-family:'Arial'">#rsParteC.notajefe#</font>									</td>
									<td class="LTtopline" colspan="1">&nbsp;</td>
									<td class="RLTtopline" colspan="1">&nbsp;</td>
								</tr>                      
							</cfloop> 
							<tr><td  class="topline" colspan="9">&nbsp;</td></tr> 
						</table>					</td>
				</tr>   
				<tr>
				<td colspan="6" align="center">
					<table align="center"   width="100% "cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td bgcolor="##CCCCCC" class="LTtopline"  colspan="1" align="center" width="80%">
								<font  style="font-size:13px; font-family:'Arial'">
									<cf_translate  key="LB_Indique_otros_conocmientos_que_la_persona_debe_reforzar">Indique otros conocmientos que la persona debe reforzar									</cf_translate>
								</font>							</td>
							<td bgcolor="##CCCCCC" class="LTtopline" colspan="1" align="center" width="10%">
								<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_RequiereCapacitacion">Requiere Capacitaci&oacute;n</cf_translate></font>							</td>
							<td bgcolor="##CCCCCC" class="RLTtopline" colspan="1" align="center" width="10%">
								<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Prioridad">Prioridad (1,2,3)</cf_translate></font>							</td>
						</tr>  
						<cfloop from="1" to ="5" index="i">
							<tr>
								<td class="LTtopline" colspan="1">&nbsp;</td>
								<td class="LTtopline" colspan="1">&nbsp;</td>
								<td class="RLTtopline" colspan="1">&nbsp;</td>
							</tr>                      
						</cfloop>
						<tr><td  class="topline" colspan="9">&nbsp;</td></tr> 
					</table>				</td>
			</tr>      
			</cfif>
            
            <tr >
                <td bgcolor="##CCCCCC" class="Completoline" colspan="6" align="center">
                    <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Identificacion_de_fortalezas_y_oportunidades_de_mejora">Identificaci&oacute;n de fortalezas y oportunidades de mejora</cf_translate></font>			</td>
            </tr>
                
            <cfquery datasource="#session.dsn#"  name="Rs_special">
                select  b.PCid
                from RHParametros a
                inner join RHHabilidades b
                    on a.Ecodigo = b.Ecodigo
                    and b.RHHid =  <cf_dbfunction name="to_number" args="Pvalor">
                inner join  	 PortalCuestionario c
                    on b.PCid = c.PCid
                where Pcodigo = 830
                and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 	
            </cfquery>
            <cfif Rs_special.recordCount GT 0>
                <tr>
                    <td class="topline"  colspan="6" align="center">
                     <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;				</td>
                </tr>
                
                <tr>
                    <td  colspan="6" align="left">
                    <cfquery datasource="#session.dsn#"  name="Rs_FyO">
                            select c.PCid,pp.PPid, <cf_dbfunction name="to_char" args="pp.PPpregunta"> as PPpregunta
                            from  PortalCuestionario c
                            inner join PortalPregunta pp
                                on c.PCid=pp.PCid
                                and pp.PPtipo not in ('E')	                    
                             where c.PCid = #Rs_special.PCid# 
                    </cfquery>
                   
                        <table width="100%" align="left" cellpadding="0" cellspacing="0" border="0">
                             <cfloop query="Rs_FyO">
                             
                            <cfif Rs_Jefe.recordCount GT 0>
                                <cfif isdefined('PCUid_J') and len(trim(PCUid_J))>
                                    <cfset contestadaJ = traerValorPregunta(PCUid_J, Rs_FyO.PCid, Rs_FyO.PPid, Usucodigo, LvarUsucodigoeval ) >
                                </cfif>
                            </cfif>
                            <cfif isdefined('PCUid_A') and len(trim(PCUid_A))>
                                <cfset contestadaA = traerValorPregunta(PCUid_A, Rs_FyO.PCid, Rs_FyO.PPid, Usucodigo, Usucodigo ) >
                            </cfif>
                             
                             <tr>
                                <td class="RLTtopline" colspan="8">
                                     <font  style="font-size:11px; font-family:'Arial'"><b>#Rs_FyO.PPpregunta#</b></font>                            </td>
                             </tr>
                             <tr>
                                <td class="LTtopline" bgcolor="##CCCCCC" colspan="4">
                                     <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Autoevaluacion">Autoevaluaci&oacute;n</cf_translate></font>                            </td>
                                <td class="RLTtopline" bgcolor="##CCCCCC" colspan="4">
                                     <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Evaluacion_jefe">Evaluaci&oacute;n jefe</cf_translate></font>                            </td>
                             </tr>
                             <tr>
                                <td class="LTtopline" colspan="4"  align="justify">
                                    <font  style="font-size:11px; font-family:'Arial'"><cfif isdefined('contestadaA') and len(trim(contestadaA))>#contestadaA#<cfelse>&nbsp;</cfif></font>                            </td>
                                <td class="RLTtopline" colspan="4" align="justify">
                                    <font  style="font-size:11px; font-family:'Arial'"><cfif isdefined('contestadaJ') and len(trim(contestadaJ))>#contestadaJ#<cfelse>&nbsp;</cfif></font>                            </td>
                             </tr>
                             </cfloop>
                        </table>                </td>
                </tr>
                <tr>
                    <td class="topline"  colspan="6" align="center">
                     <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;				</td>
                </tr>
            </cfif>
            
            <tr>
                <td  colspan="6" align="center"> <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;			</td>
            </tr>
    
            <tr >
                <td bgcolor="##CCCCCC" class="Completoline" colspan="6" align="center">
                    <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Indique_otros_logros_obtenidos">Indique otros logros obtenidos</cf_translate></font>			</td>
            </tr>	
            
            <tr>
                <td  class="Completoline" colspan="6" align="center">
                    &nbsp;<br>
                    &nbsp;<br>
                    &nbsp;<br>
                    &nbsp;<br>
                    &nbsp;<br>			</td>
            </tr>	
            <tr >
                <td bgcolor="##CCCCCC" class="Completoline" colspan="6" align="center">
                    <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Cumplio_plan_de_mejoramiento_del_ano_anterior">Cumpli&oacute; plan de mejoramiento del a&ntilde;o anterior</cf_translate></font>			</td>
            </tr>	
            
            <tr>
                <td  colspan="3" class="LTbottomline" align="center">
                        <font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_SI">SI</cf_translate></font>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_NO">NO</cf_translate></font>			</td>
                
                <td class="RLTbottomline2" colspan="3" align="left">
                        &nbsp;<font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Porcentaje_de_Cumplimiento ">Porcentaje de Cumplimiento </cf_translate></font>			</td>
            </tr>
            <tr>
                <td  colspan="6" align="center">&nbsp;			</td>
            </tr>        
            
            <tr>
                <td  colspan="6" align="center"> <div style="page-break-after:always"></div> </td>
            </tr>
                    
            <tr>
                <td  colspan="6" align="center">&nbsp;			</td>
            </tr>
            
            <tr >
                <td  bgcolor="##CCCCCC" class="Completoline" colspan="6" align="center">
                    <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Retos_y_plan_de_mejoramiento_propuesto_para_el_siguiente_periodo">Retos y  plan de mejoramiento propuesto para el siguiente periodo</cf_translate></font>			</td>
            </tr>
            
            <tr>
                <td  colspan="6" align="center">&nbsp;			</td>
            </tr>
            
            
            <tr>
                <td  colspan="6" align="center">
                    <table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td  class="LTtopline" colspan="3" align="center" valign="middle" rowspan="7">
                                <b><font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Plan_de_mejoramiento_personal">Plan de mejoramiento personal</cf_translate></font></b>                        </td>
                            <td class="LRTtopline"  colspan="5"   align="left">
                               &nbsp;&nbsp;<b><font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Seguimiento">Seguimiento</cf_translate></font></b><br>                        </td>
                        </tr>
                        <tr>
                            <td  class="RLline" colspan="5"   align="left" nowrap="nowrap">
                                &nbsp;&nbsp;<font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Instruccion1">Indique el estado de la acci&oacute;n en la fecha del seguimiento</cf_translate>,&nbsp;</font><br>                        </td>
                        </tr>
                        <tr>
                            <td  class="RLline" colspan="5"   align="left">
                                &nbsp;&nbsp;<font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Instruccion2">utilizando la siguiente escala</cf_translate>:&nbsp;</font><br>                        </td>
                        </tr>
                        <tr>
                            <td  class="RLline" colspan="5"   align="left">
                                &nbsp;&nbsp;<font  style="font-size:11px; font-family:'Arial'"><b>A</b>&nbsp;<cf_translate  key="LB_OpcionA">Acci&oacute;n casi finalizada entre un 76% y 100%</cf_translate></font><br>                        </td>
                        </tr>
                        <tr>
                            <td  class="RLline" colspan="5"   align="left">
                                &nbsp;&nbsp;<font  style="font-size:11px; font-family:'Arial'"><b>B</b>&nbsp;<cf_translate  key="LB_OpcionB">Acci&oacute;n avanzada entre un 51% y 75%</cf_translate></font><br>                        </td>
                        </tr>
                         <tr>
                            <td  class="RLline" colspan="5"   align="left">
                                &nbsp;&nbsp;<font  style="font-size:11px; font-family:'Arial'"><b>C</b>&nbsp;<cf_translate  key="LB_OpcionC">Acci&oacute;n parcial entre un 26% y 50%</cf_translate></font><br>                        </td>
                        </tr>
                        <tr>
                            <td  class="RLline" colspan="5"   align="left">
                                &nbsp;&nbsp;<font  style="font-size:11px; font-family:'Arial'"><b>D</b>&nbsp;<cf_translate  key="LB_OpcionD">Acci&oacute;n iniciada entre un 0% y 25%</cf_translate></font><br>                        </td>
                        </tr>
                        <!--- ******************************************************************************************** --->
                        <tr>
                            <td   class="LTtopline" align="center" width="35%">
                                <b><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Reto">Reto</cf_translate></font></b>                        </td>
                             <td   class="LTtopline" align="center" width="35%">
                                <b><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_como_lograrlo_accion">C&oacute;mo lograrlo (Acci&oacute;n)</cf_translate></font></b>                        </td>
                            <td   class="LTtopline" align="center" width="5%">
                                <b><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Fecha_implementacion">Fecha impl.</cf_translate></font></b>                        </td>
                            <td   class="LTtopline" align="center" width="3%">
                                <b><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Fecha">__/__</cf_translate></font></b>                        </td>
                            <td   class="LTtopline" align="center" width="3%">
                                <b><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Fecha">__/__</cf_translate></font></b>                        </td>
                            <td  class="LTtopline"  align="center" width="3%">
                                <b><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Fecha">__/__</cf_translate></font></b>                        </td>
                            <td   class="LTtopline" align="center" width="15%">
                              <b><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_observacion">Observaci&oacute;n</cf_translate></font></b>                        </td>
                            <td   class="LRTtopline" align="center" width="3%">
                                <b><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_ResultadoFinal">Resultado Final</cf_translate></font></b>                        </td>
                        </tr>
                        <!--- ******************************************************************************************** --->
                        <tr>
                            <td  class="LTtopline" align="center">
                                &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>
                                &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>
                                &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>
                                &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>
                                &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>
                                &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>                        </td>
                            <td  class="LTtopline" align="center">
                                &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>
                                &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>                        </td>
                            <td  class="LTtopline" align="center">
                                &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>
                                &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>                        </td>
                            <td  class="LTtopline" align="center">
                                &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>
                                &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>                        </td>
                            <td  class="LTtopline" align="center">
                                &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>
                                &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>                        </td>
                            <td  class="LTtopline" align="center">
                                &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>
                                &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>                        </td>
                            <td  class="LTtopline" align="center">
                                &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>
                                &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>                        </td>
                            <td  class="LRTtopline" align="center">
                                &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>
                                &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>                        </td>
                        </tr>
                    </table>			</td>
            </tr>
            
            <tr >
                <td bgcolor="##CCCCCC" class="Completoline" colspan="6" align="center">
                    
                    <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Otros_comentarios">Otros comentarios</cf_translate></font>			</td>
            </tr>	
            
            <tr>
                <td  class="Completoline" colspan="6" align="center">
                    &nbsp;<br>
                    &nbsp;<br>
                    &nbsp;<br>
                    &nbsp;<br>
                    &nbsp;<br>			</td>
            </tr>
            <tr>
                <td  colspan="4" class="LTbottomline" align="left">
                    <font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Clasificacion_de_desempeno">Clasificaci&oacute;n de desempe&ntilde;o</cf_translate></font> * :&nbsp;&nbsp;<b><font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(nota.Nota_desempeno,'____.__')#</font></b></td>
    
                <td colspan="2" class="RLTbottomline" align="left">
                    <font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Duracion_de_la_sesion:">Duraci&oacute;n de la sesi&oacute;n:</cf_translate><br>
                    _____________________<br>
                    ( <cf_translate  key="LB_minimo_30_minutos">m&iacute;nimo 30 minutos</cf_translate>)</font>			</td>
            </tr>
            <!--- <tr >
                <td  colspan="6" align="left">
                    <font  style="font-size:11px; font-family:'Arial'">* <cf_translate  key="LB_Esta_nota_puede_variar_como_producto_de_acontecimientos_relevantes_registrados">Esta nota puede variar como producto de acontecimientos relevantes registrados</cf_translate></font>			</td>
            </tr> --->
            <tr>
                <td  colspan="6" align="center">&nbsp;			</td>
            </tr>
            <tr >
                <td  colspan="6" align="center" valign="bottom">
                    <font  style="font-size:11px; font-family:'Arial'">
                    <cf_translate  key="LB_Firma_Evaluado">Firma Evaluado</cf_translate>:___________________&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_translate  key="LB_Firma_Jefatura">Firma Jefatura</cf_translate>:___________________&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_translate  key="LB_Fecha">Fecha</cf_translate>:___________________                </font>			</td>
            </tr>
            <tr>
                <td  colspan="6" align="center">&nbsp;			</td>
            </tr>	
            <tr >
                <td  colspan="6" align="justify" valign="bottom">
                    <font  style="font-size:11px; font-family:'Arial Narrow'">
                        Una vez lleno, la jefatura debe sacar dos copias de este formulario que serán para su archivo personal y para entregar a la persona evaluada.  
                        El original se env&iacute;a a Desarrollo Humano para incluirlo en el expediente personal.                </font>			</td>
            </tr>	
			<cfif Rs_Empleados.recordCount GT 1 and Rs_Empleados.recordCount neq Rs_Empleados.currentRow>
                <tr>
                    <td  colspan="6" align="center">&nbsp;<br/>&nbsp;<br/>                    </td>
                </tr>   
                
                <tr>
                    <td  colspan="6" align="center"> <div style="page-break-after:always"></div> </td>
                </tr>   
            </cfif>             		
        </table>
    </cfoutput>
    <cfquery datasource="#session.dsn#"  name="Rs_insert">
        delete from #HojaRealimentacion# 
    </cfquery>

</cfloop>	
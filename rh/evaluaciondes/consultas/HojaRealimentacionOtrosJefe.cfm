<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_reporte_de_diagnosticoPracticasLiderazgo" Default="Diagn&oacute;stico de pr&aacute;cticas de liderazgo" returnvariable="LB_reporte_de_diagnosticoPracticasLiderazgo" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_NA" Default="NA" returnvariable="LB_NA" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Nulo" Default="Nulo"returnvariable="LB_Nulo" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Basico" Default="B&aacute;sico" returnvariable="LB_Basico" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Intermedio" Default="Intermedio"returnvariable="LB_Intermedio" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Avanzado" Default="Avanzado" returnvariable="LB_Avanzado" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Actualizacion_Refrescamiento" Default="Actualizaci&oacute;n / Refrescamiento" returnvariable="LB_Actualizacion_Refrescamiento" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<!--- Funcion para buscar las dependencias de un centro funcional --->
<cffunction name="getCentrosFuncionalesDependientes" returntype="query">
	<cfargument name="cfid" required="yes" type="numeric">
	<cfset nivel = 1>
	<cfquery name="rs1" datasource="#session.dsn#">
		select CFid, #nivel# as nivel, null as CFidresp
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.cfid#">
	</cfquery>
	<cfquery name="rs2" datasource="#session.dsn#">
		select CFid, CFidresp
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfloop condition="1 eq 1">
		<cfquery name="rs3" dbtype="query">
			select rs2.CFid, #nivel# + 1 as nivel, rs2.CFidresp
			from rs1, rs2
			where rs1.nivel = #nivel#
			  and rs2.CFidresp = rs1.cfid
		</cfquery>
		<cfif rs3.RecordCount gt 0>
			<cfset nivel = nivel + 1>
			<cfquery name="rs0" dbtype="query">
				select CFid, nivel, CFidresp from rs1
				union
				select CFid, nivel, CFidresp from rs3
			</cfquery>
			<cfquery name="rs1" dbtype="query">
				select * from rs0
			</cfquery>
		<cfelse>
			<cfbreak>
		</cfif>
	</cfloop>
	<cfreturn rs1>
</cffunction>
 <!---Centros funcionales a conciderar--->
 <cfif isdefined("form.CFid") and len(trim(form.CFid)) and isdefined("form.dependencias")>
	<cfset cf = getCentrosFuncionalesDependientes(form.CFid) >
	<cfset vsCFuncionales = ValueList(cf.CFid)>
</cfif>

<!---Empleados en el centro funcional--->
<cfquery name="rsInfoEmpleados" datasource="#session.DSN#">
	select distinct a.DEid
	from RHRegistroEvaluadoresE  a
	inner join RHEmpleadoRegistroE b
		on a.REid = b.REid
		and a.DEid = b.DEid
		and (b.EREnojefe = 0 or b.EREnoempleado = 0)
	inner join RHRegistroEvaluacion c
		on a.REid = c.REid
	inner join DatosEmpleado DEE
		on   a.DEid =  DEE.DEid
		and a.Ecodigo = DEE.Ecodigo	
	<cfif isdefined("url.tipo") and url.tipo eq '2'>
		left outer join DatosEmpleado DEJ
			on   a.REEevaluadorj =  DEJ.DEid
			and a.Ecodigo = DEJ.Ecodigo	
	</cfif>	
	inner join LineaTiempo lt
		on lt.Ecodigo = a.Ecodigo
		and lt.DEid = a.DEid
		and c.REdesde between LTdesde and LThasta
	inner join RHPlazas pl
		on  lt .RHPid = pl.RHPid
		and   lt.Ecodigo = pl.Ecodigo
	inner join  CFuncional cf
		on   cf.CFid  = pl.CFid 
		and  cf.Ecodigo = pl.Ecodigo
		<cfif isdefined("form.CFid") and len(trim(form.CFid)) and not(isdefined("form.dependencias"))>
			and cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		<cfelseif isdefined("vsCFuncionales") and len(trim(vsCFuncionales))>
			and cf.CFid in (#vsCFuncionales#)
		</cfif>		
	inner join  Departamentos Dep

		on   cf.Dcodigo  = Dep.Dcodigo
		and  cf.Ecodigo = Dep.Ecodigo
	where  a.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!---Empleados que realizaron el cuestionario para calificar a su jefe, filtra por centro funcional en caso de haber dependencias--->
<cfquery datasource="#session.dsn#"  name="Rs_Empleados">
    select distinct x.DEid
	from RHEvaluadoresDes x
		inner join RHListaEvalDes a
		on a.RHEEid = x.RHEEid
		and a.DEid = x.DEid
		and a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	where x.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
		<cfif isdefined("form.DEid") and len(trim(form.DEid))>
		and x.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfif>
		<cfif isdefined("form.dependencias") and isdefined('rsInfoEmpleados.DEid') and len(trim(valueList(rsInfoEmpleados.DEid)))>
			and x.DEid in( <cfqueryparam list="yes" cfsqltype="cf_sql_numeric" value="#valueList(rsInfoEmpleados.DEid)#">)
		</cfif>
</cfquery>
<!---<cf_dump var="#form#">--->
			
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
	<cfargument name='PDEideval'		type='numeric' 	required='no' default="">	<!---DEideval(Cod.del evaluador)---->
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
	title="#LB_reporte_de_diagnosticoPracticasLiderazgo#" 
	filename="#LvarFileName#"
	irA="HojaRealimentacionOtrosJefe-filtro.cfm" 
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

<cfset PCUid_O 			 = -1>	
<cfset PCUid_O 			 = -1>	
<cfset VAR_DEid 		 = -1>	


<cf_dbtemp name="Evaluaciones_Jefes" returnvariable="Evaluaciones_Jefes" datasource="#session.dsn#">
	<cf_dbtempcol name="Usulogin" 		type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="PCUreferencia" 	type="numeric" 		mandatory="yes">
	<cf_dbtempcol name="PPnumero" 		type="numeric" 		mandatory="no">
	<cf_dbtempcol name="DEid" 			type="numeric" 		mandatory="no">
	<cf_dbtempcol name="DEideval" 		type="numeric" 		mandatory="no">
	<cf_dbtempcol name="PCUid" 			type="numeric" 		mandatory="no">
	<cf_dbtempcol name="PPid" 			type="numeric" 		mandatory="no">
	<cf_dbtempcol name="PPparte" 		type="varchar(255)" mandatory="no">
	<cf_dbtempcol name="Parte" 			type="varchar(255)" mandatory="no">
	<cf_dbtempcol name="RHHdescripcion" type="varchar(255)" mandatory="no">
	<cf_dbtempcol name="Pregunta" 		type="varchar(255)" mandatory="no">
	<cf_dbtempcol name="CANTIDAD" 		type="numeric" mandatory="no">
	<cf_dbtempcol name="NotaPreguntaO" 	type="float" mandatory="no">
	<cf_dbtempcol name="NotaHabilidadO" type="float" mandatory="no">
	<cf_dbtempcol name="NotaPreguntaA" 	type="float" mandatory="no">
	<cf_dbtempcol name="NotaHabilidadA" type="float" mandatory="no">
	<cf_dbtempcol name="Notafinal" type="float" mandatory="no">
</cf_dbtemp> 

<cfloop query="Rs_Empleados">
   
   <cfset VAR_DEid = Rs_Empleados.DEid>
   
    <cfinvoke component="rh.Componentes.RH_Funciones" method="DeterminaJefe" deid = "#VAR_DEid#" fecha = "#Now()#" returnvariable="esjefe">
    <cfset JefeVal = false>
    <cfif isdefined("esjefe.CFID")and len(trim(esjefe.CFID))>
        <cfset JefeVal = true>
    </cfif>
	
    <cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	
	<!--- Extrae los Usucodigo del evaluado --->
    <cfset rsevaluado = sec.getUsuarioByRef(VAR_DEid, session.EcodigoSDC, 'DatosEmpleado')>
    <cfset Usucodigo  = rsevaluado.Usucodigo>
    <cfset PCUid_O 		= -1>	
    
	<!--- Fecha en que se respondio la ultima Evaluacion de Otro Empleado  --->
    <cfquery name="fechaultimaA" datasource="#session.DSN#">
        select max(PCUfecha) as fecha
        from PortalCuestionarioU a
        where  a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">	
     		and a.PCUreferencia  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
			 	and a.PCUestado= 10 
    </cfquery>
   
    <!---Toma el id de Cuestionario que se respondio de ultimo--->
    <cfif len(trim(fechaultimaA.fecha))>
        <cfquery name="dataPCUid" datasource="#session.DSN#">
            select PCUid
            from PortalCuestionarioU a
            where 
			  a.PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
			    and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">	
              and a.PCUfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechaultimaA.fecha#">
              and a.PCUestado= 10 
			  Order by PCUid DESC
        </cfquery>

        <cfif len(trim(dataPCUid.PCUid))>
            <cfset PCUid_O = dataPCUid.PCUid >
        </cfif>
    </cfif>
    
    <!--- Informacion general de la evaluacion  de otros --->
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
	
	<!--- Query trae todas las respuestas y preguntas de la auto evaluacion y evalucion--->
    <cfquery datasource="#session.dsn#"  name="Rs_Todo">
       select a.Usulogin,a.PCUreferencia,d.PPnumero,a.DEid,a.DEideval,a.PCUid,
	   b.PPid , x.PPparte,<cf_dbfunction name="to_char" args="x.PCPdescripcion">as Parte,'' as RHHdescripcion ,
	   <cf_dbfunction name="to_char" args="d.PPpregunta">as Pregunta, coalesce( c.PRUvalor,0 ) as NotaPreguntaA, 
	   PCPmaxpreguntas as CANTIDAD, coalesce( c.PRUvalor,0 ) as NotaPreguntaO, 
	   (select SUM(w.PPvalor) from PortalPregunta w
			where w.PCid = b.PCid
			and w.PPvalor != 0
			and w.PPparte=d.PPparte)as NotaHabilidadAValor
			, 0 as NotaHabilidadA
			,
			coalesce((select SUM(w.PRUvalor)/count(1) from 
				PortalPregunta v
				inner join PortalRespuestaU w
				on w.PCUid = a.PCUid
				and w.PPid = v.PPid
				where v.PCid = b.PCid
			and v.PPvalor != 0
			and w.PRUvalor > -1
			and v.PPparte=d.PPparte),0) as NotaHabilidadO
			
		from PortalCuestionarioU a
		inner join PortalPreguntaU b
			on a.PCUid = b.PCUid
			and b.Ecodigo =a.Ecodigo
		inner join PortalPregunta d
			on b.PCid = d.PCid
				and b.PPid = d.PPid
			and d.PPvalor != 0
				and d.PPtipo != 'E'
		inner join  PortalCuestionarioParte x
			on x.PCid = d.PCid
			and x.PPparte = d.PPparte
			and b.Ecodigo =a.Ecodigo
		LEFT OUTER JOIN PortalRespuestaU c
			on c.PCUid = a.PCUid
			and c.PPid = b.PPid
			and c.Ecodigo =a.Ecodigo

		where a.PCUreferencia in (<cfqueryparam list="yes" cfsqltype="cf_sql_numeric" value="#form.RHEEid#">)
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VAR_DEid#">
		and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.PCUestado= 10
		--and coalesce(c.PRUvalor,0) >= 0
		order by d.PPnumero   
	</cfquery>
		
	<!--- carga la autoevaluacion del jefe --->
	<cfquery dbtype="query" name="Rs_Datos_Evaluado">
		select * from Rs_Todo where DEid = DEideval
		and PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
	</cfquery>
	
	<!--- carga la autoevaluacion de los evaluadores --->
	<cfquery dbtype="query" name="Rs_Datos">
		select * from Rs_Todo where 
		PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
		and PCUid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#PCUid_O#">
	</cfquery>
	<!---calculos de promedio de los cuestionarios de evaluadores--->
	<cfloop query="Rs_Datos">
		
		<cfquery dbtype="query" name="Rs_CantidadP"> <!---cantidad de respuesta para la misma pregunta--->
			select count(1) as total  from Rs_Todo where
			PPnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Rs_Datos.PPnumero#"> 
			and PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
			and NotaPreguntaO > -1
		</cfquery>
		
		<cfquery dbtype="query" name="Rs_nota">	<!---suma de las notas de respuestas para la misma pregunta--->
			select sum(NotaPreguntaO) as suma  from Rs_Todo where
			PPnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Rs_Datos.PPnumero#">
			and PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
			and NotaPreguntaO > -1
		</cfquery>
		
		<cfif Rs_nota.recordCount GT 0>
			<cfset Rs_Datos.NotaPreguntaO = Rs_nota.suma / Rs_CantidadP.total>
		<cfelse>
			<cfset Rs_Datos.NotaPreguntaO = -1>
		</cfif>
		
		<cfquery dbtype="query" name="Rs_CantidadH"> <!---cantidad de respuesta para la misma pregunta--->
			select count(1) as total  from Rs_Todo where
			PPnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Rs_Datos.PPnumero#"> 
			and PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
			and NotaPreguntaO > -1
		</cfquery>
		<!---and #Rs_Datos.NotaPreguntaO# > -1--->
		
		<cfquery dbtype="query" name="Rs_habilidad">	<!---suma de las respuestas para la misma pregunta--->
			select sum(NotaHabilidadO) as suma  from Rs_Todo where
			PPnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Rs_Datos.PPnumero#">
			and PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">	
			and NotaPreguntaO > -1
		</cfquery>

		<cfif Rs_habilidad.recordCount GT 0 and  isdefined('Rs_CantidadH.total')and len(trim(Rs_CantidadH.total))>
			<cfset Rs_Datos.NotaHabilidadO = Rs_habilidad.suma / Rs_CantidadH.total>
		<cfelse>
			<cfset Rs_Datos.NotaHabilidadO = -1>
		</cfif>
		<cfset Rs_Datos.NotaPreguntaA =  0>
	</cfloop>

    <cfoutput>
		<cfset CORTE = -1>
		<cfset NotaTotalAuto = 0>
		<cfset NotaTotalOtro = 0>
		<cfset Partes = 0>
		<cfloop query="Rs_Datos">
		   <cfif Rs_Datos.PPparte NEQ CORTE>
				<cfset CORTE = Rs_Datos.PPparte>
				<cfset Partes = Partes + 1>
				<cfif len(trim(Rs_Datos.NotaHabilidadA)) and Rs_Datos.NotaHabilidadA gte 0>
					<cfset Rs_Datos.NotaHabilidadA = ((NotaHabilidadAValor * (Rs_Datos.NotaHabilidadA/100) ) * 100 )/NotaHabilidadAValor>
					<cfset NotaTotalAuto = NotaTotalAuto + Rs_Datos.NotaHabilidadA>
				</cfif>
		   
				<cfif len(trim(Rs_Datos.NotaHabilidadO))  and Rs_Datos.NotaHabilidadO gte 0>
					<cfset Rs_Datos.NotaHabilidadO = ((NotaHabilidadAValor * (Rs_Datos.NotaHabilidadO/100) ) * 100 )/NotaHabilidadAValor>
					<cfset NotaTotalOtro = NotaTotalOtro + Rs_Datos.NotaHabilidadO>
				</cfif>			 
			</cfif>
			<!---Agrega en la tabla temporal los datos --->
			<cfquery  datasource="#session.dsn#"  name="Rs_insert">
				INSERT 	INTO #Evaluaciones_Jefes# (Usulogin,PCUreferencia,PPnumero,DEid,DEideval,PCUid,PPid,PPparte,Parte,RHHdescripcion ,Pregunta,CANTIDAD,NotaPreguntaA,NotaHabilidadA,NotaPreguntaO,NotaHabilidadO) 
				values('#Rs_Datos.Usulogin#',#Rs_Datos.PCUreferencia#,#Rs_Datos.PPnumero#,#Rs_Datos.DEid#,#Rs_Datos.DEideval#,#Rs_Datos.PCUid#,#Rs_Datos.PPid#,'#Rs_Datos.PPparte#','#Rs_Datos.Parte#','#Rs_Datos.RHHdescripcion#','#trim(Rs_Datos.Pregunta)#',#IIF(len(trim(Rs_Datos.CANTIDAD)),Rs_Datos.CANTIDAD,'0')#,#Rs_Datos.NotaHabilidadA#,#Rs_Datos.NotaPreguntaA#,#Rs_Datos.NotaPreguntaO#,#Rs_Datos.NotaHabilidadO#)
			</cfquery>
		</cfloop>
    </cfoutput>
</cfloop>


<!---Notas finals--->
<cf_dbtemp name="Promedios_Jefes" returnvariable="Promedios_Jefes" datasource="#session.dsn#">
	<cf_dbtempcol name="Usulogin" 		type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="PCUreferencia" 	type="numeric" 		mandatory="yes">
	<cf_dbtempcol name="PPnumero" 		type="numeric" 		mandatory="no">
	<cf_dbtempcol name="DEid" 			type="numeric" 		mandatory="no">
	<cf_dbtempcol name="DEideval" 		type="numeric" 		mandatory="no">
	<cf_dbtempcol name="PCUid" 			type="numeric" 		mandatory="no">
	<cf_dbtempcol name="PPid" 			type="numeric" 		mandatory="no">
	<cf_dbtempcol name="PPparte" 		type="varchar(255)" mandatory="no">
	<cf_dbtempcol name="Parte" 			type="varchar(255)" mandatory="no">
	<cf_dbtempcol name="RHHdescripcion" type="varchar(255)" mandatory="no">
	<cf_dbtempcol name="Pregunta" 		type="varchar(255)" mandatory="no">
	<cf_dbtempcol name="CANTIDAD" 		type="numeric" mandatory="no">
	<cf_dbtempcol name="NotaPreguntaO" 	type="float" mandatory="no">
	<cf_dbtempcol name="NotaHabilidadO" type="float" mandatory="no">
	<cf_dbtempcol name="NotaPreguntaA" 	type="float" mandatory="no">
	<cf_dbtempcol name="NotaHabilidadA" type="float" mandatory="no">
	<cf_dbtempcol name="Notafinal" type="float" mandatory="no">
</cf_dbtemp> 

<!---cantidad de jefes evaluados--->
<cfquery datasource="#session.dsn#"  name="Rs_Jefes">
	select distinct a.DEid from #Evaluaciones_Jefes# a
</cfquery>
<cfset total_jefes =  Rs_Jefes.recordCount>

<!---distintas preguntas--->
<cfquery datasource="#session.dsn#"  name="Rs_Preguntas">
	select distinct(v.PPid) from #Evaluaciones_Jefes# v
	order by  v.PPid
</cfquery>
<cfset total_preg =  Rs_Preguntas.recordCount>

<cfloop query="Rs_Preguntas">
	<cfquery datasource="#session.dsn#"  name="Rs_DatosXPreg">
		select PCUreferencia,PPnumero,PCUid,PPid,PPparte,Parte,CANTIDAD,NotaHabilidadO,NotaPreguntaO,Usulogin,RHHdescripcion,Pregunta
		from #Evaluaciones_Jefes# x
		where x.PPid = #Rs_Preguntas.PPid#
	</cfquery>
	<cfquery datasource="#session.dsn#"  name="promedio">
		select sum(NotaHabilidadO)/#total_jefes# as promNotaHabilidadO,
			 SUM(NotaPreguntaO)/#total_jefes# as promNotaPreguntaO
		from #Evaluaciones_Jefes# x
		where x.PPid = #Rs_Preguntas.PPid#
		group by PPid
	</cfquery>
	<cfif Rs_DatosXPreg.RecordCount GT 0>
		<!---obtiene el promedio--->
		 <cfquery  datasource="#session.dsn#"  name="Rs_insert">
			INSERT 	INTO #Promedios_Jefes# (Usulogin,PCUreferencia,PPnumero,DEid,DEideval,PCUid,PPid,PPparte,Parte,RHHdescripcion ,Pregunta,CANTIDAD,NotaPreguntaA,NotaHabilidadA,NotaPreguntaO,NotaHabilidadO) 
			values('#Rs_DatosXPreg.Usulogin#',#Rs_DatosXPreg.PCUreferencia#,#Rs_DatosXPreg.PPnumero#,0,0,#Rs_DatosXPreg.PCUid#,#Rs_DatosXPreg.PPid#,'#Rs_DatosXPreg.PPparte#','#Rs_DatosXPreg.Parte#','#Rs_DatosXPreg.RHHdescripcion#','#trim(Rs_DatosXPreg.Pregunta)#',#IIF(len(trim(Rs_DatosXPreg.CANTIDAD)),Rs_DatosXPreg.CANTIDAD,'0')#,0,0,#promedio.promNotaPreguntaO#,#promedio.promNotaHabilidadO#)
		 </cfquery>
	</cfif>
</cfloop>
<cfquery  datasource="#session.dsn#"  name="Rs_report">
	select * from #Promedios_Jefes#
</cfquery>

<cfoutput>
<table width="100%" align="center" cellpadding="0" cellspacing="0" border="1">
	<tr><td bgcolor="##CCCCCC" class="RLTtopline" colspan="6" align="center"><font  style="font-size:13px; font-family:'Arial'">#LB_reporte_de_diagnosticoPracticasLiderazgo#</font></td></tr>
	<tr>
			<td class="LTtopline" colspan="2" align="left" width="25%">
			<font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Evaluacion">Evaluaci&oacute;n:</cf_translate></font>			</td>
			<td  class="RTtopline"  colspan="4" align="left" width="25%">
			<font  style="font-size:11px; font-family:'Arial'">#Rs_Eval.RHEEdescripcion#</font>			</td>
	</tr>	
	<tr>
		<td class="LTtopline" align="left" width="25%" colspan="2">
			<font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Fecha_Evaluacion">Fecha Evaluaci&oacute;n:</cf_translate></font>			</td>
		<td class="topline"  align="left" width="75%"  colspan="4" >
			<font  style="font-size:11px; font-family:'Arial'">#LSDateFormat(Rs_Eval.RHEEfhasta,'dd/mm/yyyy')#</font>			</td>
	</tr>
	<tr>
		<td class="LTtopline" align="left" width="25%"  colspan="2">
			<font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_Area">&Aacute;rea:</cf_translate></font>			</td>
		<td  class="topline" align="left" width="75%"  colspan="4">
		  <font  style="font-size:11px; font-family:'Arial'">#Rs_Empleado.centrofuncional#</font>			</td>
	</tr>
	<tr >
	<td bgcolor="##CCCCCC" class="Completoline" colspan="6" align="center">
		<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Resultado_Consolidados_Evaluacion">Resultados Consolidados Evaluaci&oacute;n</cf_translate></font>			</td>
</tr>

<tr><td colspan="6">
	<table cellpadding="0" cellspacing="0" border="0" width="100%">
	<tr>
		<td  colspan="4" align="center">
			<font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="##CCCCCC" class="LTtopline" rowspan="2" <cfif isdefined('esResumido')>colspan="1"</cfif>  align="left">
			<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Variables">Variables</cf_translate></font>			</td>
		<cfif not isdefined('esResumido')><td bgcolor="##CCCCCC"class="LTtopline" rowspan="2" <cfif isdefined('esResumido')>colspan="3"</cfif>  align="left">
		<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Preguntas">Preguntas</cf_translate></font>			</td></cfif>
		<td bgcolor="##CCCCCC" class="RLTtopline" colspan="2" align="center" width="25%"></td>
	</tr>
	<tr>
		
		<cfif not isdefined('esResumido')> <td  bgcolor="##CCCCCC" class="LTtopline" colspan="1" align="center">
			<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_prom_nota_preguntas">Promedios de notas por pregunta</cf_translate></font>			</td>
		</cfif>
		
		<td <cfif isdefined('esResumido')>colspan="2"</cfif> bgcolor="##CCCCCC" class="RLTtopline"  align="center">
				 <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_prom_nota_variable">Promedios de notas por variable</cf_translate></font>			</td>
	</tr>
	
<cfloop query="Rs_report">
   <cfif Rs_report.PPparte NEQ CORTE>
		<cfset CORTE = Rs_report.PPparte>
		<cfset Partes = Partes + 1>
		<tr>
			<td  class="LTtopline"  <cfif isdefined('esResumido')>colspan="1"<cfelse> rowspan="#Rs_report.cantidad#" </cfif>  align="justify">
			   <font  style="font-size:11px; font-family:'Arial'">#Rs_report.Parte#</font>					</td>
			<cfif not isdefined('esResumido')><td class="LTtopline" <cfif isdefined('esResumido')>colspan="3"</cfif>  align="justify">
				<font  style="font-size:11px; font-family:'Arial'">#Rs_report.Pregunta#</font>					</td></cfif>
			 
			 <cfif not isdefined('esResumido')>
			 <td class="LTtopline"  colspan="1" align="center" valign="middle">
				<cfif len(trim(Rs_report.NotaPreguntaO)) and Rs_report.NotaPreguntaO gte 0>
					<font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(Rs_report.NotaPreguntaO,'____.__')#</font> 
				<cfelse>
					<font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
				</cfif>					</td>
			</cfif>	
		   
		   <td   <cfif isdefined('esResumido')>colspan="2"<cfelse> rowspan="#Rs_report.cantidad#" </cfif> class="RLTtopline"   align="center" valign="middle">
				<cfif len(trim(Rs_report.NotaHabilidadO))  and Rs_report.NotaHabilidadO gte 0>
					<cfset NotaTotalOtro = NotaTotalOtro + Rs_report.NotaHabilidadO>
					<font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(Rs_report.NotaHabilidadO,'____.__')#</font> 
				<cfelse>
					<font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
				</cfif>	
				
			  </td>
		</tr>
	<cfelseif not isdefined('esResumido')>
	   <tr>
			
			<td class="LTtopline" <cfif isdefined('esResumido')>colspan="1"</cfif>  align="justify">
				<font  style="font-size:11px; font-family:'Arial'">#Rs_report.Pregunta#</font>					</td>
			<td class="LTtopline"  <cfif isdefined('esResumido')>colspan="3"</cfif>  align="center" valign="middle">
			<cfif len(trim(Rs_report.NotaPreguntaO)) and Rs_report.NotaPreguntaO gte 0>
				<font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(Rs_report.NotaPreguntaO,'____.__')#</font> 
			<cfelse>
				<font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
			</cfif></td>

		</tr>
	</cfif>
	
</cfloop>
	<cfif Rs_report.recordCount GT 0>
	 <tr>
		<cfif not isdefined('esResumido')>
		<td  class="LTtopline" <cfif isdefined('esResumido')>colspan="1"</cfif>  align="justify">&nbsp;</td>
		</cfif>
		<td  class="LTtopline" align="Center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_x">Nota Final</cf_translate></font></td>
		<cfif not isdefined('esResumido')><td  class="LTtopline" colspan="1" align="justify">&nbsp;</td></cfif>
		<td  class="RLTtopline" <cfif isdefined('esResumido')>colspan="2"</cfif>  align="Center">&nbsp;<font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat((NotaTotalOtro/Partes),'____.__')#</font> </td>
		
	</tr>
	<cfelse>
		<tr>
		<td  class="LTtopline" <cfif isdefined('esResumido')>colspan="1"</cfif>  align="justify">&nbsp;</td>
		<td  class="LTtopline" <cfif isdefined('esResumido')>colspan="3"</cfif>  align="Center"><font  style="font-size:11px; font-family:'Arial'"><cf_translate  key="LB_x">Nota Final</cf_translate></font></td>
		<cfif not isdefined('esResumido')><td  class="LTtopline" colspan="1" align="justify">&nbsp;</td></cfif>
		<td  class="RLTtopline" <cfif isdefined('esResumido')>colspan="2"</cfif> align="Center">&nbsp;</td>
		</tr>
	</cfif>
	
</table>
</td></tr>

<tr>
	<td class="topline"  colspan="6" align="center"><font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;</td>
</tr>

<cfif Rs_Empleados.recordCount GT 1 and Rs_Empleados.recordCount neq Rs_Empleados.currentRow>
	<tr>
		<td  colspan="6" align="center">&nbsp;<br/>&nbsp;<br/>
		</td>
	</tr>   
	
	<tr>
		<td  colspan="6" align="center"> <div style="page-break-after:always"></div> </td>
	</tr>   
</cfif>             		
</table>
</cfoutput>

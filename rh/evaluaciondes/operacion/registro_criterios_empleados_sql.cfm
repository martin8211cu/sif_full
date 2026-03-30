<!--- AGREGA LISTA DE EMPLEADOS, LISTA DE ITEMS A EVALUAR, Y LISTA DE EVALUADORES  A UNA RELACION DE EVALUACION
	Notas:
		1. Como los items a evaluar están asociadas a conocimientos y habilidades y los conocimientos y habilidades están asociados 
			a cada puesto se agreagan los registro por Puesto, es decir, se recorre  una lista con los puestos a evaluar y se agregan
			todoos los Empleados de ese puesto y los items a evaluar para cada empleado, y los evaluadores para cada empleado, los 
			evaluadores que se agregan son el mismo empleado y el jefe.
 --->
<!--- Query para saber si se usa Cuestionario específico (Si es especifico no se llena la  tabla RHNotasEvalDes
o Cuestionario por habilidades si se llena la tabla RHNotasEvalDes ---->



<cfquery name="rsPCid" datasource="#session.DSN#">
	select PCid ,Aplica, AplicaPara
	from RHEEvaluacionDes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
</cfquery>

<cfset DEBUG=FALSE>
<cfsetting requesttimeout="36000">
<cfparam name="FORM.RHEEID" type="numeric">
<cfparam name="FORM.CFIDLIST" type="string" default="">
<cfparam name="FORM.ODIDLIST" type="string" default="">
<cfparam name="FORM.EMPLEADOIDLIST" type="string" default="">
<cfparam name="FORM.PUESTOIDLIST" type="string" default="">
<cfparam name="FORM.CursoidList" type="string" default="">
<cfparam name="FORM.OPT" type="numeric" default="0"><!--- 0 = Centro Funcional, 1 = Oficina / Departamento--->
<cfparam name="FORM.PARAMS" type="string" default="">
<cfparam name="FORM.fechaini" type="string" default="">
<cfparam name="FORM.fechafin" type="string" default="">
<cfparam name="FORM.FECHA" type="string" default="#LSDateFormat(Now(),'dd/mm/yyyy')#">
<cfif isdefined("FORM.DEID") and len(trim(FORM.DEID)) eq 0><cfset FORM.DEID = 0></cfif>
<cfparam name="FORM.DEID" type="numeric" default="0">
<cfparam name="FORM.DEIDLIST" type="string" default="">

<cffunction name="getCentrosFuncionalesDependientes" returntype="query">
	<cfargument name="cfid" required="yes" type="numeric">
	<cfset nivel = 1>
	<cfquery name="rs1" datasource="#session.dsn#">
		select CFid, #nivel# as nivel, -1 as CFidresp
		from CFuncional
		where CFid = #arguments.cfid#
	</cfquery>
	<cfquery name="rs2" datasource="#session.dsn#">
		select CFid, CFidresp
		from CFuncional
		where Ecodigo = #session.Ecodigo#
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

<cffunction name="convertListItemsToString" returntype="string">
	<cfargument name="list" type="string">
	<cfset arr = ListToArray(list)>
	<cfset arrstr = ArrayNew(1)>
	<cfloop from="1" to="#ArrayLen(arr)#" index="i">
		<cfset arrstr[i] = "'" & arr[i] & "'">
	</cfloop>
	<cfreturn ArrayToList(arrstr)>
</cffunction>

<cffunction name="processpuesto" returntype="string">
	<cfargument name="list" type="string">
	<cfreturn convertListItemsToString(list)>
</cffunction>

<cffunction name="processod" returntype="string">
	<cfargument name="list" type="string">
	<cfreturn convertListItemsToString(list)>
</cffunction>

<cffunction name="processcf" returntype="string">
	<cfargument name="list" type="string">
	<cfset arr = ListToArray(list)>
	<cfset arrstr = ArrayNew(1)>
	<cfloop from="1" to="#ArrayLen(arr)#" index="i">
		<cfset cf = ListToArray(arr[i],'|')>
		<cfif cf[2] eq 1>
			<cfset cfs = getCentrosFuncionalesDependientes(cf[1])>
			<cfloop query="cfs">
				<cfset ArrayAppend(arrstr,cfid)>
			</cfloop>
		<cfelse>
			<cfset ArrayAppend(arrstr,cf[1])>
		</cfif>
	</cfloop>
	<cfreturn ArrayToList(arrstr)>
</cffunction>

<cffunction name="getListaJefes" returntype="string">
	<cfargument name="cfidlist" required="no" type="string" default="-1">
	<cfargument name="odidlist" required="no" type="string" default="-1">
	<cfargument name="empleadoidlist" required="no" type="string" default="-1">
	<cfargument name="puestoidlist" required="no" type="string" default="-1">
	<cfargument name="cursoidlist" required="no" type="string" default="-1">
    
    <cfset arguments.cfidlist= replace(arguments.cfidlist, '|',',',"all")>
    <cfset arguments.odidlist= replace(arguments.odidlist, '|',',',"all")>
    <cfset arguments.empleadoidlist= replace(arguments.empleadoidlist, '|',',',"all")>
    <cfset arguments.puestoidlist= replace(arguments.puestoidlist, '|',',',"all")>
    <cfset arguments.cursoidlist= replace(arguments.cursoidlist, '|',',',"all")>        
		
	<cfquery datasource="#session.dsn#" name="rsLista">
		select a.DEid
		from DatosEmpleado a 
			inner join UsuarioReferencia b
				on b.STabla = 'DatosEmpleado' 
				and a.DEid = coalesce(<cf_dbfunction name="to_number" args="b.llave">,-1)
			inner join CFuncional cf
				on b.Usucodigo = cf.CFuresponsable
		<cfif len(arguments.cfidlist) or len(arguments.odidlist) or len(arguments.puestoidlist)>
            inner join LineaTiempo lt
            	inner join RHPlazas pz
                		inner join CFuncional cf2
                        	on cf2.CFid=pz.CFid
                            <cfif len(arguments.cfidlist)>
	                            and cf2.CFid in ( #arguments.cfidlist#)
                            </cfif>
                            <cfif len(arguments.odidlist)>
                            	and cf2.Ocodigo in ( #arguments.odidlist#)
                             </cfif>
                	on lt.RHPid=pz.RHPid
                    <cfif len(arguments.puestoidlist)>
                    	inner join RHPuestos rhp
                        	on pz.RHPpuesto=rhp.RHPcodigo
                            and pz.Ecodigo=rhp.Ecodigo
                            and rhp.Ecodigo in ( #arguments.puestoidlist#)
                    </cfif>
            	on a.DEid=lt.DEid
                and <cf_dbfunction name="today"> between lt.LTdesde and lt.LThasta
		</cfif>
		where a.Ecodigo = #session.Ecodigo#
		<cfif len(arguments.empleadoidlist)>
        	and a.DEid in (#arguments.empleadoidlist#)
        </cfif>
		union
		select a.DEid
		from DatosEmpleado a 
			inner join LineaTiempo lt
				on a.DEid = lt.DEid
			inner join CFuncional cf
				on lt.RHPid = cf.RHPid
        <cfif len(arguments.puestoidlist)>                
			inner join  RHPlazas pz
            	on lt.RHPid=pz.RHPid
            inner join RHPuestos rhp
                on pz.RHPpuesto=rhp.RHPcodigo
                and pz.Ecodigo=rhp.Ecodigo
                and rhp.Ecodigo in (#arguments.puestoidlist#)
         </cfif>
		where a.Ecodigo = #session.Ecodigo#
		and <cf_dbfunction name="today"> between lt.LTdesde and lt.LThasta        
		 <cfif len(arguments.cfidlist) >
            and cf.CFid in ( #arguments.cfidlist#)
        </cfif>
        <cfif len(arguments.odidlist)>
            and cf.Ocodigo in ( #arguments.odidlist#)
         </cfif>        
		<cfif len(arguments.empleadoidlist)>
        	and a.DEid in (#arguments.empleadoidlist#)
        </cfif>
		<cfif len(arguments.empleadoidlist)>        
			union
			select a.DEid
			from DatosEmpleado a 
        	where a.DEid in (#arguments.empleadoidlist#)
        </cfif>
	</cfquery>
	<cfreturn valuelist(rsLista.DEid,",")>
</cffunction>

<cffunction name="getListaEmpleados" returntype="query">
	<cfargument name="fechaini" required="no" type="string" default="#FORM.fechaini#">
	<cfargument name="fechafin" required="no" type="string" default="#FORM.fechafin#">
	<cfargument name="opt" required="no" type="numeric" default="#FORM.OPT#">
	<cfargument name="cfidlist" required="no" type="string" default="#FORM.CFIDLIST#">
	<cfargument name="odidlist" required="no" type="string" default="#FORM.ODIDLIST#">
	<cfargument name="empleadoidlist" required="no" type="string" default="#FORM.EMPLEADOIDLIST#">
	<cfargument name="puestoidlist" required="no" type="string" default="#FORM.PUESTOIDLIST#">
	<cfargument name="cursoidlist" required="no" type="string" default="#FORM.CursoidList#">
	<cfargument name="deid" required="no" type="numeric" default="#FORM.DEID#">
	<cfargument name="deidlist" required="no" type="string" default="#FORM.DEIDLIST#">
	<cfparam name="FORM.FECHA" type="string" default="#LSDateFormat(Now(),'dd/mm/yyyy')#">
	<cfparam name="FORM.radfecha" type="string" default="">
	<cfparam name="FORM.AMBITOTIEMPOSITUACION" type="string" default="">
	 
	<cfif isdefined ('form.fechaini') and len(trim(form.fechaini)) gt 0 and form.radfecha eq 0>
		<cfset FORM.FECHA=#form.fechaini#>
	<cfelseif isdefined ('form.fechafin') and len(trim(form.fechafin)) gt 0 and form.radfecha neq 0>
		<cfset FORM.FECHA=#form.fechafin#>
	</cfif>
 
    <cf_dbtemp datasource="#session.dsn#" name="EvalBuscaJefes" returnvariable="temp">
    	<cf_dbtempcol name="DEid" 		type="numeric">
    	<cf_dbtempcol name="CFid" 		type="numeric">
    	<cf_dbtempcol name="DEidJefe" 	type="numeric">
    	<cf_dbtempcol name="LTid" 		type="numeric">
    </cf_dbtemp>
            
    <cf_dbfunction name="op_concat" returnvariable="concat">
    <cf_dbfunction name="to_char" args="c.Ocodigo" returnvariable="toChar_Ocodigo">
    <cf_dbfunction name="to_char" args="c.Dcodigo" returnvariable="toChar_Dcodigo">
	<cfquery datasource="#session.dsn#">
    	insert into #temp# (DEid,CFid,LTid)
		select 
			a.DEid,
		  	b.CFid,
		  	a.LTid
		from LineaTiempo a
            inner join  RHPlazas b
                on a.RHPid = b.RHPid
           	inner join  CFuncional c
				on b.CFid = c.CFid
		where 
			<cfif form.radfecha neq 2 and form.ambitoTiempoSituacion neq 1> <!---- no se busca empleados activos si el criterio es situacion y el modo CESE---->
                <cf_dbfunction name="today"> between a.LTdesde and a.LThasta and
            </cfif>	
		
		 exists (select 1
					<cfif isdefined ('form.fechaini') and len(trim(form.fechaini)) gt 0 and form.radfecha eq 0><!----Empleados incluidos antes de--->
						from LineaTiempo lt
						where lt.Ecodigo = a.Ecodigo
							and lt.DEid = a.DEid
							and  <cf_dbfunction name="to_date" args="'#LSDateFormat(FORM.fechaini,'dd-mm-yyyy')#'"> >= lt.LTdesde 
					<cfelseif isdefined ('form.fechafin') and len(trim(form.fechafin)) gt 0 and form.radfecha eq 1><!----Empleados incluidos  Después de----->
						from LineaTiempo lt
						where lt.Ecodigo = a.Ecodigo
							and lt.DEid = a.DEid
							and  <cf_dbfunction name="to_date" args="'#LSDateFormat(FORM.fechafin,'dd-mm-yyyy')#'"> <= lt.LTdesde  
					<cfelseif form.radfecha eq 2><!---- fcastro 12/11/12 nuevo filtro de empleados----->
						<cfif form.ambitoTiempoSituacion eq 0><!--- antiguedad---->
						from LineaTiempo lt
						inner join EVacacionesEmpleado eve
							on eve.DEid=lt.DEid
						where lt.Ecodigo = a.Ecodigo
							and lt.DEid = a.DEid
							and eve.EVfantig between <cfqueryparam cfsqltype="cf_sql_date" value="#getFechasEvaluacionJefe().desde#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#getFechasEvaluacionJefe().hasta#">
						<cfelseif form.ambitoTiempoSituacion eq 1><!--- Cese---->
						from LineaTiempo lt
							inner join DLaboralesEmpleado dl
								on lt.DEid=dl.DEid	
							inner join RHTipoAccion rh
								on dl.RHTid = rh.RHTid	
						where lt.Ecodigo = a.Ecodigo
							and rh.RHTcomportam = 2 <!---- es tipo cese---->
							and lt.DEid = a.DEid
							and dl.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#getFechasEvaluacionJefe().desde#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#getFechasEvaluacionJefe().hasta#">
							and a.LThasta = (select max(xx.LThasta) from LineaTiempo xx where xx.DEid=a.DEid)
						<cfelseif form.ambitoTiempoSituacion eq 2><!--- Cambio de Puesto (Asc/Desc)---->
						from LineaTiempo lt
						where lt.Ecodigo = a.Ecodigo
							and lt.DEid = a.DEid
							and  <!----se cumple que la plaza en la fecha desde es diferente a la plaza en la fecha hasta--->
								(
									(select x.RHPid 
									from LineaTiempo x
									where x.DEid=lt.DEid
									and <cfqueryparam cfsqltype="cf_sql_date" value="#getFechasEvaluacionJefe().desde#"> between x.LTdesde and x.LThasta)
									<> <!---- que sea diferente---->
									(select x.RHPid 
									from LineaTiempo x
									where x.DEid=lt.DEid
									and <cfqueryparam cfsqltype="cf_sql_date" value="#getFechasEvaluacionJefe().hasta#"> between x.LTdesde and x.LThasta)
								 )	
								 and <cf_dbfunction name="today"> between a.LTdesde and a.LThasta   <!--- si es cambio de puesto se trae el ultimo puesto--->
						</cfif>
					</cfif>
				)	
                                      
		<cfif rsPCid.AplicaPara eq 1><!---- en el caso que tipo sea aplica solo a jefes---->
			and a.DEid in (#getListaJefes(processcf(arguments.cfidlist), arguments.odidlist, arguments.empleadoidlist,arguments.puestoidlist,arguments.cursoidlist)#)
		</cfif>			
		and a.Ecodigo = #session.Ecodigo#
		<cfif arguments.deid gt 0>
			and a.DEid = #arguments.deid#
		</cfif>
		<cfif len(trim(arguments.empleadoidlist)) gt 0>
			and a.DEid in (#arguments.empleadoidlist#)
		</cfif>	
		<cfif len(trim(arguments.empleadoidlist)) gt 0>		  
			<cfif rsPCid.AplicaPara eq 1><!----fcastro  en el caso que tipo sea aplica solo a jefes---->
					or (a.DEid in (#arguments.empleadoidlist#) and <cf_dbfunction name="today"> between a.LTdesde and a.LThasta)
			<cfelse><!--- procedimiento normal---->  	
					and a.DEid in (#arguments.empleadoidlist#)		
			</cfif>	
		</cfif>	
		<cfif len(trim(arguments.puestoidlist)) gt 0>
			and a.RHPcodigo in (#processpuesto(arguments.puestoidlist)#)
		</cfif>
		<cfif len(trim(arguments.cursoidlist)) gt 0>
			and a.DEid in (
							select x.DEid 
							from RHEmpleadoCurso x 
							where x.RHCid in (#arguments.cursoidlist#)
								and x.RHECestado=50
						)			
		</cfif>
		<cfif arguments.opt eq 0>
			<cfif len(trim(arguments.cfidlist)) gt 0>
				and c.CFid in (#processcf(arguments.cfidlist)#)
			</cfif>
		<cfelse>
			<cfif len(trim(arguments.odidlist)) gt 0>
				and c.Ocodigo#concat#'|'#concat#c.Dcodigo in (#processod(arguments.odidlist)#)
			</cfif>
		</cfif>
	</cfquery>
	
	<!----- busca el jefe de la tabla anterior---->
	<cfset utiles=createObject("component", "rh.Componentes.RH_IncidenciasProceso")>
	<cfquery datasource="#session.dsn#" name="rsDatos">
		select distinct DEid, CFid 
		from #temp#
	</cfquery>

	<cfloop query="rsDatos"><!--- actualiza los empleados segun los reponsables del centro de costo---->
		<!--- <cfset EmpleadoResponsable = utiles.getEmpleadoResponsable(utiles.getRecursivoCFidPadre(rsDatos.CFid,rsDatos.DEid))> --->

		<cfset EmpleadoResponsable = utiles.getEmpleadoResponsable(rsDatos.CFid,rsDatos.DEid)>
		<cfquery datasource="#session.dsn#">
			Update #temp#
			set DEidJefe = #EmpleadoResponsable#
			where CFid = #rsDatos.CFid#
			and DEid = #rsDatos.DEid#
		</cfquery>
	</cfloop>

	<cfquery name="rs" datasource="#session.dsn#">
	    select x.DEid as IDEmpleado, x.DEidJefe as Jefe, x.LTid, lt.RHPcodigo
		from #temp# x
			inner join LineaTiempo lt
				on x.LTid=lt.LTid
	</cfquery>
 
	<cfreturn rs>
</cffunction>

<cffunction name="getFechasEvaluacionJefe" returntype="struct">
	<cfset fechas =StructNew()>
	<cfset fechaPart ='d'>
		<cfswitch expression="#form.ambitoTiempoTipoTiempo#"> 
			<cfcase value="1"> <!--- meses---->
				<cfset fechaPart ='m'>
			</cfcase>
			<cfcase value="2"> <!--- años---->
				<cfset fechaPart ='yyyy'>
			</cfcase>				
		</cfswitch>
		<cfset fechas.hasta=dateadd(fechaPart,-1*form.ambitoTiempoDesde,LSdateformat(form.AmbitoTiempoFechaReferencia))>
		<cfset fechas.desde=dateadd(fechaPart,-1*form.ambitoTiempoHasta,LSdateformat(form.AmbitoTiempoFechaReferencia))>
		
	<cfreturn fechas>
</cffunction>	

<cffunction name="getCentrosJefe" returntype="query">
	<cfargument type="numeric" required="yes" name="DEid">
	<cfquery datasource="#session.dsn#" name="rsCentros">
		select cf.CFid,cf.CFpath,cf.CFnivel,cf.CFidresp 
		from CFuncional cf
			inner join UsuarioReferencia b
				on b.STabla = 'DatosEmpleado' 
				and b.Usucodigo = cf.CFuresponsable
		where cf.Ecodigo = #session.Ecodigo#
		and coalesce(<cf_dbfunction name="to_number" args="b.llave">,-1) = #arguments.DEid#
		union
		select cf.CFid,cf.CFpath,cf.CFnivel,cf.CFidresp 
		from CFuncional cf 
			inner join LineaTiempo lt
				on lt.RHPid = cf.RHPid								
		where cf.Ecodigo = #session.Ecodigo#
		and lt.DEid = #arguments.DEid#
		and <cf_dbfunction name="today"> between lt.LTdesde and lt.LThasta
	</cfquery>
	<cfif rsCentros.recordcount eq  0><!---- en el caso que no se encuentre el centro donde el empleado es jefe se devuelve el centro donde colabora---->
		<cfquery datasource="#session.dsn#" name="rsCentros">
			select cf.CFid,cf.CFpath,cf.CFnivel,cf.CFidresp 
			from CFuncional cf 
				inner join RHPlazas rhp
					on cf.CFid = rhp.CFid
				inner join LineaTiempo lt
					on lt.RHPid = rhp.RHPid									
			where lt.Ecodigo = #session.Ecodigo#
			and lt.DEid = #arguments.DEid#
			and <cf_dbfunction name="today"> between lt.LTdesde and lt.LThasta
		</cfquery>
	</cfif>
	<cfreturn rsCentros>
</cffunction>

<cffunction name="agregarAutovaluacion" returntype="boolean">
	<cfargument name="RHEEID" type="numeric" required="yes">
	<cfargument name="IDEmpleado" type="numeric" required="yes">

	<cfquery name="VALIDA_RHEvaluadoresDes" datasource="#Session.DSN#">
		select 1 from RHEvaluadoresDes 
		where RHEEid = #arguments.RHEEID# 
		and DEid = #arguments.IDEmpleado# 
		and DEideval = #arguments.IDEmpleado#
	</cfquery>
	<cfif VALIDA_RHEvaluadoresDes.recordCount EQ 0>
		<cfquery datasource="#Session.DSN#">
			insert into RHEvaluadoresDes 
			(RHEEid, DEid, DEideval, RHEDtipo)
			values (#arguments.RHEEID#, #arguments.IDEmpleado#, #arguments.IDEmpleado#, 'A')<!--- tipo autoevaluacion----->
		</cfquery>
	</cfif>
		
	<cfreturn true>
</cffunction>	


<cffunction name="agregarColaboradores" returntype="boolean">
	<cfargument name="RHEEID" type="numeric" required="yes">
	<cfargument name="IDEmpleado" type="numeric" required="yes">
	
	<cfquery datasource="#Session.DSN#"><!----se borran los colaboradores para ingresar los nuevos---->
		delete from RHEvaluadoresDes 
		where RHEEid = #arguments.RHEEID# 
		and DEid = #arguments.IDEmpleado# 
		and RHEDtipo = 'S' <!--- se borran lo colaboradores para ingresarlos nuevamente---->
	</cfquery>



	<cfquery datasource="#Session.DSN#">
		insert into RHEvaluadoresDes (RHEEid, DEid, DEideval, RHEDtipo)
		select #arguments.RHEEID#, #arguments.IDEmpleado#,DEid,'S'
		from DatosEmpleado
		where Ecodigo = #session.Ecodigo#
		and DEid <> #arguments.IDEmpleado#
		and DEid in (#getSubordinados(arguments.IDEmpleado,3)#)<!---- el 3 indica la cantidad de niveles---->
	</cfquery>
    
	<cfreturn true>
</cffunction>	

<cffunction name="getSubordinados" returntype="string">
	<cfargument name="DEid" type="numeric" required="yes">
	<cfargument name="Niveles" type="numeric" required="yes">

	<cfset listaColaboradores=-1>
	<cfset listaCFid=-1>
	
	<!--- se obtienen los centros funcionales donde el empleado es jefe---->
	<cfset rsCentros =getCentrosJefe(arguments.DEid)>

	<cfif rsCentros.recordcount gt 0><!---- busca los colaboradores directos donde el empleado es jefe---->
		<cfquery datasource="#session.dsn#" name="colaboradoresDirectos">
			select lt.DEid
			from LineaTiempo lt
				inner join RHPlazas rhp
					on lt.RHPid=rhp.RHPid
			where <cf_dbfunction name="today"> between lt.LTdesde and lt.LThasta
			and rhp.CFid in (#valuelist(rsCentros.CFid,',')#)
			and lt.DEid <> #arguments.DEid#
		</cfquery>
	</cfif>
	
	<cfif isdefined("colaboradoresDirectos") and colaboradoresDirectos.recordcount gt 0>
		<cfset listaColaboradores = ListAppend(listaColaboradores, valuelist(colaboradoresDirectos.DEid,","),",")>
	</cfif>
	
	<!---- se buscaran los jefes hasta la cantidad de niveles por argumento, en el caso que no exista jefe se agregan sus colaboradores---->
	<cfloop query="rsCentros">
		<cfset listaColaboradores = getRecursivoSubordinados(listaColaboradores,rsCentros.CFid,arguments.DEid,3)><!---- el 3 indica la cantidad de niveles---->
	</cfloop><!--- fin de recorrido de centros por jefe---->
	<cfreturn listaColaboradores>
</cffunction>

<!----fcastro 13/11/12 funcion recursiva de colaboradores----->
<cffunction access="public" name="getRecursivoSubordinados" returntype="any">
	<cfargument name="listaColaboradores" type="any" required="yes">
	<cfargument name="CFid" required="yes" type="numeric">
	<cfargument name="DEid" required="yes" type="numeric">
	<cfargument name="Niveles" type="numeric" required="yes">
	<cfargument name="nivelActual" type="numeric" required="no" default="0">

                                   
    
		<cfif arguments.Niveles eq arguments.nivelActual>
			<cfreturn listaColaboradores>
		</cfif>	
		
		<cfquery name="rsCF" datasource="#Session.DSN#">
			select CFid, RHPid, CFuresponsable, CFcodigo, CFdescripcion
			from CFuncional
			where Ecodigo = #session.Ecodigo#
			and CFidresp = #arguments.CFid#
		</cfquery>
		
		<cfset arguments.rsCFSub = rsCF><!--- se crea esta variable en arguments dado que coldfusion reescribe el cfquery en el recursivo dentro de un cfloop---->
		
		<cfif arguments.rsCFSub.recordcount eq 0><!--- se devuelve la lista si no existen CF subordinados---->
			<cfreturn listaColaboradores>
		</cfif>

		<cfloop query="arguments.rsCFSub">
			<cfset ExisteJefe = false>
			<cfif len(trim(arguments.rsCFSub.RHPid)) gt 0><!---- en el caso que exista un jefe en la plaza---->
				<cfquery name="agregar" datasource="#Session.DSN#">
					select lt.DEid
					from LineaTiempo lt
						inner join RHPlazas rhp
							on lt.RHPid=rhp.RHPid
					where <cf_dbfunction name="today"> between lt.LTdesde and lt.LThasta
					and rhp.RHPid = #arguments.rsCFSub.RHPid#
					and lt.DEid <> #arguments.DEid#
				</cfquery>
                <cfif len(trim(agregar.DEid)) >
					<cfset ExisteJefe = true>
                 </cfif>
			<cfelseif len(trim(arguments.rsCFSub.CFuresponsable)) gt 0><!---- en el caso que sea por usuario responsable---->
				<cfquery name="agregar" datasource="#Session.DSN#">
					select <cf_dbfunction name="to_number" args="b.llave"> as DEid
					from UsuarioReferencia b
					where b.STabla = 'DatosEmpleado' 
					and b.Usucodigo = #arguments.rsCFSub.CFuresponsable#
					and <cf_dbfunction name="to_number" args="b.llave"> <> #arguments.DEid#
				</cfquery>
                <cfif len(trim(agregar.DEid)) >
					<cfset ExisteJefe = true>
                 </cfif>
			<cfelse><!---- en el caso que no exista ni un responsable ni un jefe por plaza se agregan los empleados---->
				<cfquery name="agregar" datasource="#Session.DSN#">
					select lt.DEid
					from LineaTiempo lt
						inner join RHPlazas rhp
							on lt.RHPid=rhp.RHPid
						inner join CFuncional cf
							on rhp.CFid=cf.CFid
					where lt.Ecodigo=#session.Ecodigo#
					and <cf_dbfunction name="today"> between lt.LTdesde and lt.LThasta
					and cf.CFid = #arguments.rsCFSub.CFid#
					and lt.DEid <> #arguments.DEid#
				</cfquery>
				<cfset ExisteJefe = false>
			</cfif>		
            
			
			<cfif agregar.recordcount gt 0>
				<cfset listaColaboradores = ListAppend(listaColaboradores, valuelist(agregar.DEid,","),",")>
			</cfif>
			
			<cfif not ExisteJefe><!---- si no encontro un jefe agregó los empleados y sigue buscando ----->
				<cfset listaColaboradores = getRecursivoSubordinados(listaColaboradores,arguments.rsCFSub.CFid,arguments.DEid,arguments.Niveles,arguments.nivelActual+1)>	
			</cfif>
		</cfloop>	
		
		<cfreturn listaColaboradores>
</cffunction>	

<cffunction name="agregarJefesSuperiores" returntype="string">
	<cfargument name="RHEEID" type="numeric" required="yes">
	<cfargument name="IDEmpleado" type="numeric" required="yes">

	<cfset listaJefes=-1>
	
	<!--- se obtienen los centros funcionales donde el empleado es jefe---->
	<cfset rsCentros =getCentrosJefe(arguments.IDEmpleado)>

	<cfloop query="rsCentros">
		<cfif len(trim(rsCentros.CFidresp)) gt 0>
				<cfset listaJefes = ListAppend(listaJefes, getRecursivoJefeSuperior(CFidresp,arguments.IDEmpleado,3),",")><!---- el 3 indica la cantidad de niveles---->
		</cfif>
	</cfloop>	

	<cfquery datasource="#Session.DSN#"><!----se borran los colaboradores para ingresar los nuevos---->
		delete from RHEvaluadoresDes 
		where RHEEid = #arguments.RHEEID# 
		and DEid = #arguments.IDEmpleado# 
		and RHEDtipo = 'J' <!--- se borran lo colaboradores para ingresarlos nuevamente---->
	</cfquery>
	
	<cfquery  datasource="#Session.DSN#">
		insert into RHEvaluadoresDes (RHEEid, DEid, DEideval, RHEDtipo)
		select #arguments.RHEEID#, #arguments.IDEmpleado#,DEid,'J'
		from DatosEmpleado
		where Ecodigo = #session.Ecodigo#
		and DEid <> #arguments.IDEmpleado#
		and DEid in (#listaJefes#)
	</cfquery>
		
	<cfreturn true>
</cffunction>

<!----fcastro 13/11/12 funcion recursiva del jefe superior----->
<cffunction access="public" name="getRecursivoJefeSuperior" returntype="numeric">
	<cfargument name="CFid" required="yes" type="numeric">
	<cfargument name="DEid" required="yes" type="numeric">
	<cfargument name="Niveles" type="numeric" required="yes">
	<cfargument name="nivelActual" type="numeric" required="no" default="0">
	
		<cfif arguments.Niveles eq arguments.nivelActual>
			<cfreturn -1>
		</cfif>	
		
		<cfquery datasource="#session.dsn#" name="rsCF">
			select cf.CFid
			from CFuncional cf 
			where cf.Ecodigo = #session.Ecodigo#
			and (cf.RHPid is not null or cf.CFuresponsable is not null)
			and cf.CFid = #arguments.CFid#
		</cfquery>	

		<!--- si el centro funcional tiene un responsable y no es mismo usuario, se convierte en un jefe valido--->
		<cfif rsCF.recordcount gt 0 and (getEmpleadoResponsable(rsCF.CFid) neq arguments.DEid)>
			<cfreturn getEmpleadoResponsable(rsCF.CFid)>
		<cfelse>
			<cfquery datasource="#session.dsn#" name="rsCF">
				select CFidresp
				from CFuncional 
				where  CFid = #arguments.CFid#
			</cfquery>
			<cfif len(trim(rsCF.CFidresp)) gt 0>
				<cfreturn getRecursivoJefeSuperior(rsCF.CFidresp,arguments.DEid,arguments.Niveles,arguments.nivelActual+1)>
			<cfelse>
				<cfreturn -1>
			</cfif>
		</cfif>
</cffunction>	
<!---- FIN DE FUNCION RECURSIVA--------->

<!--- fcastro, Este metodo averigua el Empleado que es jefe o usuario responsable de un centro funcional--->
<cffunction access="public" name="getEmpleadoResponsable" returntype="string">
	<cfargument name="CFid" required="no" type="numeric" default="0">
	
			<cfquery datasource="#session.dsn#" name="rsJefe">
			<!---- CFids donde el usuario tiene una plaza como jefe de centro funcional--->
			select lt.DEid
			  from CFuncional cf 
				inner join RHPlazas rhp
				  on coalesce(cf.RHPid,-1) = rhp.RHPid 
				  and cf.Ecodigo=#session.Ecodigo#
				inner join LineaTiempo lt
					on rhp.RHPid=lt.RHPid	
					and <cf_dbfunction name="today"> between lt.LTdesde and lt.LThasta
			where cf.CFid = #arguments.CFid#		
		<!----CFids donde el usuario es usuario responsable--->
			Union
			select coalesce(<cf_dbfunction name="to_number" args="ue.llave">,-1) as DEid
			  from CFuncional cf
			  inner join UsuarioReferencia ue 
					on ue.STabla = 'DatosEmpleado' 
					and ue.Usucodigo = cf.CFuresponsable
			where cf.Ecodigo=#session.Ecodigo#	
			  and cf.CFid = #arguments.CFid#
			 </cfquery> 
		<cfif rsJefe.recordcount gt 0> 
			<cfreturn rsJefe.DEid>
		<cfelse>
			<cfreturn -1>	
		</cfif>
	
</cffunction>

<!--- fcastro, Este metodo averigua el Empleado que es jefe o usuario responsable de un centro funcional--->
<cffunction access="public" name="RegenerarEmpleados" returntype="query">
	<cfargument name="RHEEID" required="yes" type="numeric">
	<cfargument name="ListaDEid" required="yes" type="string">


    <cf_dbtemp datasource="#session.dsn#" name="EvalBuscaJefes" returnvariable="temp">
    	<cf_dbtempcol name="DEid" 		type="numeric">
    	<cf_dbtempcol name="CFid" 		type="numeric">
    	<cf_dbtempcol name="DEidJefe" 	type="numeric">
    	<cf_dbtempcol name="LTid" 		type="numeric">
    </cf_dbtemp>
            
	<cfquery datasource="#session.dsn#">
    	insert into #temp# (DEid, CFid,LTid)
 		select  a.DEid,b.CFid,a.LTid
		from RHListaEvalDes a
			inner join LineaTiempo lt
				on a.LTid=lt.LTid
			inner join RHPlazas b
				on lt.RHPid=b.RHPid	
		where a.RHEEid =  #arguments.RHEEID#
			<cfif len(trim(arguments.ListaDEid))>
				and a.DEid in (#arguments.ListaDEid#)		
			</cfif>
	</cfquery>	

	<!----- busca el jefe de la tabla anterior---->
	<cfset utiles=createObject("component", "rh.Componentes.RH_IncidenciasProceso")>
	<cfquery datasource="#session.dsn#" name="rsDatos">
		select distinct DEid, CFid
		from #temp#
	</cfquery>

	<cfloop query="rsDatos"><!--- actualiza los empleados segun los reponsables del centro de costo---->

		<!--- <cfset EmpleadoResponsable = utiles.getEmpleadoResponsable(utiles.getRecursivoCFidPadre(rsDatos.CFid,rsDatos.DEid))> --->
		<cfset EmpleadoResponsable = utiles.getEmpleadoResponsable(rsDatos.CFid,rsDatos.DEid)>
		<cfquery datasource="#session.dsn#">
			Update #temp#
			set DEidJefe = #EmpleadoResponsable#
			where CFid = #rsDatos.CFid#
			and DEid = #rsDatos.DEid#
		</cfquery>
	</cfloop>

	<cfquery name="rs" datasource="#session.dsn#">
	    select x.DEid as IDEmpleado, x.DEidJefe as Jefe, x.LTid, lt.RHPcodigo
		from #temp# x
			inner join LineaTiempo lt
				on x.LTid=lt.LTid
	</cfquery>

	<!--- se borran los evaluadores para que el proceso los vuelva a regenerar---->
	<cfquery datasource="#session.dsn#" name="ListaEvaluadores">
		delete from RHEvaluadoresDes
		where RHEEid =  #arguments.RHEEID#
			<cfif len(trim(arguments.ListaDEid))>
				and DEid in (#arguments.ListaDEid#)
			</cfif>
	</cfquery>
	<cfreturn rs>	
</cffunction>	

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_Las_siguientes_habilidades_asociadas_al_puesto" default="Las siguientes habilidades asociadas al puesto " returnvariable="LB_Las_siguientes_habilidades_asociadas_al_puesto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_no_tienen_peso_definido" default="no tienen peso definido" returnvariable="LB_no_tienen_peso_definido" component="sif.Componentes.Translate" method="Translate"/>

<cftransaction>

<cfif isdefined("form.btnGenerarEmpls")>
	<cfset RSEMPL = RegenerarEmpleados(form.RHEEid,FORM.EMPLEADOIDLIST)>
<cfelse>
	<cfset RSEMPL = getListaEmpleados()>
</cfif>
					                                
 
<cfloop query="RSEMPL">
		<!--- JUSTIFICACION DEL "IF NOT EXISTS"
			Si el empleado ya fue agregado en esta lista, ya fueron agregados los demás datos también, en un momento determinado,
			con ciertos criterios determinados, y estos podrían haber cambiado hasta este momento, pero si genero varias veces, 
			se espera que la razón sea agregar mas empleados a la evaluación y regenerar los datos porque cambiaron los criterios.
			Si se determina que es común regenerar los criterios durante el proceso de agregar empleados a la evaluación se debe 
			desarrollar un comportamiento que permita esta acción.
			Resumen: Actualmente en este proceso se pregunta si existe la persona en la tabla RHListaEvalDes, si existe no se inserta
			ningún registro ni en esta tabla ni en las demás tablas involucradas (RHEvaluadoresDes, RHNotasEvalDes), esto implica que
			si se cambiaron los items de evaluacion estos no se van a actualizar para los empleados agregados previamente. Solo los 
			empleados que se están agregando nuevos reflejarán los nuevos items.
		--->
		<!---inserta los empleados--->
	
		<cfquery name="VALIDA_RHListaEvalDes" datasource="#Session.DSN#">
			select 1 from RHListaEvalDes 
			where RHEEid = #form.RHEEid# 
			and DEid = #RSEMPL.IDEmpleado#
		</cfquery>

		<cfif VALIDA_RHListaEvalDes.recordCount EQ 0>
			<cfquery datasource="#Session.DSN#">
				insert into RHListaEvalDes 
				(RHEEid, DEid, RHPcodigo, Ecodigo, promglobal, RHLEnotajefe, RHLEnotaauto, RHLEpromotros,LTid)
				values (#form.RHEEid#, #RSEMPL.IDEmpleado#, '#RSEMPL.RHPcodigo#', #SESSION.ECODIGO#, null, null, null, null,#RSEMPL.LTid#)
			</cfquery>
		</cfif>

		<cfif rsPCid.AplicaPara eq 1><!--- fcastro 13/11/12 nuevo procedimiento que aplica solo para las evaluacion de tipo jefe ---->
			<!---- 
				0 = Ambos
				1 = Jefe
				2 = Colaboradores
			--->	
			
			<!--- si la combinacion es Jefe o Ambos se agrega la autoevaluacion--->
			<cfif rsPCid.Aplica eq 1 or rsPCid.Aplica eq 0>
				<cfset autoevaluar = agregarAutovaluacion(form.RHEEid,RSEMPL.IDEmpleado)>
			</cfif>
			<!--- si la combinacion es Colaboradores o Ambos se agregan los colaboradores--->
			<cfif rsPCid.Aplica eq 2 or rsPCid.Aplica eq 0>
				<cfset colaboradores = agregarColaboradores(form.RHEEid,RSEMPL.IDEmpleado)>
			</cfif>
			
			<!---  fcastro 15/11/12 modificacion al desarrollo coopelesca, no se debe asignar el jefe del jefe
			mientras sea una evaluacion de jefe se asignará al jefe del empleado
			<cfset asignarJefe = agregarJefesSuperiores(form.RHEEid,RSEMPL.IDEmpleado)>
			---->
		<cfelse><!--- procedimiento normal---->
			<cfif rsPCid.Aplica eq 2 or rsPCid.Aplica eq 0>
				<!---autogestion--->
				<cfquery name="VALIDA_RHEvaluadoresDes" datasource="#Session.DSN#">
					select 1 from RHEvaluadoresDes 
					where RHEEid = #form.RHEEid# 
					and DEid = #RSEMPL.IDEmpleado# 
					and DEideval = #RSEMPL.IDEmpleado#
				</cfquery>
				
				<cfif VALIDA_RHEvaluadoresDes.recordCount EQ 0>
					<cfquery name="ABC_RHEvaluadoresDes" datasource="#Session.DSN#">
						insert into RHEvaluadoresDes 
						(RHEEid, DEid, DEideval, RHEDtipo)
						values (#form.RHEEid#, #RSEMPL.IDEmpleado#, #RSEMPL.IDEmpleado#, 'A')
					</cfquery>
				</cfif>
			</cfif>
	   		
			<!---inserta los jefes--->
			<cfif rsPCid.Aplica eq 1 or rsPCid.Aplica eq 0>
				<!---Estos jefes que toma en cuenta son los que se le asignan a una plaza responsable--->
				<cfif LEN(TRIM(RSEMPL.JEFE))>
					<cfquery name="VALIDA_RHEvaluadoresDes" datasource="#Session.DSN#">
						select 1 from RHEvaluadoresDes 
						where RHEEid = #form.RHEEid# 
						and DEid = #RSEMPL.IDEmpleado# 
						and DEideval = #RSEMPL.JEFE#
					</cfquery>

					<cfif !VALIDA_RHEvaluadoresDes.recordCount>
						<cfquery datasource="#Session.DSN#">
							insert into RHEvaluadoresDes 
							(RHEEid, DEid, DEideval, RHEDtipo)
							values (#form.RHEEid#, #RSEMPL.IDEmpleado#, #RSEMPL.JEFE#, 'J')
						</cfquery>
					</cfif>
				</cfif>
			</cfif>
		</cfif><!--- fin de if en linea 624---->	
		<cfif isdefined("rsPCid.PCid") and rsPCid.PCid LTE 0><!--- 0 POR CONOCIMIENTOS, -1 POR HABILIDADES, -2 POR HABILIDADES Y CONOCIMIENTOS --->
			<cfquery name="VALIDA_RHNotasEvalDes" datasource="#Session.DSN#">
				select 1 from RHNotasEvalDes 
				where RHEEid = #FORM.RHEEID# 
				and DEid = #RSEMPL.IDEmpleado#
			</cfquery>
			<cfif VALIDA_RHNotasEvalDes.recordCount EQ 0>
				<cfinvoke component="rh.Componentes.RH_Funciones" method="DeterminaJefe" deid = "#RSEMPL.IDEmpleado#" fecha = "#Now()#" returnvariable="esjefe">
				<cfset JefeVal = false>
				<cfif isdefined("esjefe.CFID") and len(trim(esjefe.CFID))>
					<cfset JefeVal = true>
				</cfif>
				<cfif rsPCid.PCid LT 0><!--- VERIFICA PARA LAS EVALUACIONES DE HABILIDADES SI ESTAS TIENEN ASIGNADO UN PESO --->
					<cfquery name="VALIDA_RHNotasEvalDesPeso" datasource="#Session.DSN#">
						select RHHcodigo
						from RHHabilidades a, RHHabilidadesPuesto b
						where a.RHHid = b.RHHid
						and a.Ecodigo = b.Ecodigo
						and b.RHPcodigo = '#RSEMPL.RHPcodigo#'
						and b.Ecodigo = #SESSION.ECODIGO#
						and b.PCid is not null
						and( b.RHHpesoJefe is null or b.RHHpeso is null)
					</cfquery>
					
					<cfif VALIDA_RHNotasEvalDesPeso.recordCount GT 0>
						<cfset habilidades = "">
						
						<cfloop query="VALIDA_RHNotasEvalDesPeso">
							<cfset habilidades = habilidades & VALIDA_RHNotasEvalDesPeso.RHHcodigo & ' '>
						</cfloop>
						
						<cfquery name="rsPesoVALIDA" datasource="#session.DSN#">
							SELECT  {fn concat(a.RHPcodigo,{fn concat('-',a.RHPdescpuesto)})} as puesto
							from RHPuestos a
							where a.RHPcodigo = '#RSEMPL.RHPcodigo#'
							and a.Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						</cfquery>
					
						<cfset msg = LB_Las_siguientes_habilidades_asociadas_al_puesto  & ' '&rsPesoVALIDA.puesto & ','& LB_no_tienen_peso_definido & ' ('& habilidades& ')'  >
						<cf_throw message="#msg#" errorcode="8035">
						<cfabort>
					</cfif> 
				</cfif>	
				
				<cfif rsPCid.PCid LT 0><!--- INSERTA REGISTROS PARA LAS EVALUACIONES DE LAS HABILIDADES --->
					<!---<cfif rsPCid.Aplica eq 2 or rsPCid.Aplica eq 0>--->
						<cfquery name="ABC_RHNotasEvalDesH" datasource="#Session.DSN#">
							insert into RHNotasEvalDes 
							(RHEEid, DEid, RHHid, RHNEDnotajefe, RHNEDnotaauto, RHNEDpromotros, RHNEDpromedio, RHNEDpeso,PCid)
							select distinct #form.RHEEid#, #RSEMPL.IDEmpleado#, a.RHHid, null, null, null, null,b.RHHpeso,coalesce(b.PCid,a.PCid)
							from RHHabilidades a, RHHabilidadesPuesto b
							where a.RHHid = b.RHHid
							and a.Ecodigo = b.Ecodigo
							and b.RHPcodigo = '#RSEMPL.RHPcodigo#'
							and b.Ecodigo = #SESSION.ECODIGO#
						</cfquery>	
					<!---</cfif>--->
				</cfif>
				<cfif rsPCid.PCid NEQ -1><!--- INSERTA REGISTRO PARA LAS EVALUACIONES DE LOS CONOCIMIENTOS --->
					<!---<cfif rsPCid.Aplica eq 2 or rsPCid.Aplica eq 0>--->
						<cfquery name="ABC_RHNotasEvalDesH" datasource="#Session.DSN#">
							insert into RHNotasEvalDes 
							(RHEEid, DEid, RHCid, RHNEDnotajefe, RHNEDnotaauto, RHNEDpromotros, RHNEDpromedio, RHNEDpeso,PCid)
							select distinct #form.RHEEid#, #RSEMPL.IDEmpleado#, a.RHCid, null, null, null, null,b.RHCpeso,coalesce(b.PCid,a.PCid)
							from RHConocimientos a, RHConocimientosPuesto b
							where a.RHCid = b.RHCid
							and a.Ecodigo = b.Ecodigo
							and b.RHPcodigo = '#RSEMPL.RHPcodigo#'
							and b.Ecodigo = #SESSION.ECODIGO#
						</cfquery>
					<!---</cfif>--->
				</cfif>
			</cfif>
			<cfquery name="ABC_RHNotasEvalDes" datasource="#Session.DSN#">
				update RHEEvaluacionDes 
				set RHEEestado = 1 
				where RHEEid = #FORM.RHEEID# 
				and RHEEestado = 0
			</cfquery>
		</cfif>
</cfloop> 

<cfif DEBUG>
	<cfdump var="#RSEMPL#">
	<cfquery name="rsRHEEvaluacionDes" datasource="#Session.DSN#">
		select * from RHEEvaluacionDes where RHEEid = #form.RHEEid#
	</cfquery>
	<cfdump var="#rsRHEEvaluacionDes#">
	<cfquery name="rsRHListaEvalDes" datasource="#Session.DSN#">
		select * from RHListaEvalDes where RHEEid = #form.RHEEid# <cfif FORM.DEID gt 0> and DEid = #FORM.DEID#</cfif> <cfif len(trim(FORM.EMPLEADOIDLIST)) gt 0> and DEid in (#FORM.EMPLEADOIDLIST#)</cfif>
	</cfquery>
	<cfdump var="#rsRHListaEvalDes#">
	<cfquery name="rsRHEvaluadoresDes" datasource="#Session.DSN#">
		select * from RHEvaluadoresDes where RHEEid = #form.RHEEid#  <cfif FORM.DEID gt 0> and DEid = #FORM.DEID#</cfif> <cfif len(trim(FORM.EMPLEADOIDLIST)) gt 0> and DEid in (#FORM.EMPLEADOIDLIST#)</cfif> order by RHEDtipo
	</cfquery>
	<cfdump var="#rsRHEvaluadoresDes#">
	<cfquery name="rsRHNotasEvalDes" datasource="#Session.DSN#">
		select * from RHNotasEvalDes where RHEEid = #form.RHEEid# <cfif FORM.DEID gt 0> and DEid = #FORM.DEID#</cfif> <cfif len(trim(FORM.EMPLEADOIDLIST)) gt 0> and DEid in (#FORM.EMPLEADOIDLIST#)</cfif>
	</cfquery>
	<cfdump var="#rsRHNotasEvalDes#">
	<cftransaction action = "rollback"/>
	<cfabort>
</cfif>

</cftransaction>

<cfif isdefined("FORM.BTNGENERAREMPL") and FORM.BTNGENERAREMPL eq 1>
	<!--- ES INCLUIDO DESDE EL ARCHIVO REGISTRO_CRITERIOS_EMPLEADOS_LISTA_SQL, EL CONTINUA LA EJECUCION--->
<cfelse>
	<cflocation url="registro_evaluacion.cfm?RHEEid=#form.RHEEid#&SEL=3">
</cfif>

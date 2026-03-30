<cfquery name="rs" datasource="#session.DSN#" >
	select 	'#session.Enombre#' as empresa,
			{fn concat(rtrim(cf.CFcodigo),{fn concat(' - ',cf.CFdescripcion)})} as CFcodigo,
			{fn concat(rtrim(c.RHCcodigo),{fn concat(' - ',c.RHCnombre)})}as RHCcodigo,
			c.RHCfdesde,
			c.RHCfhasta, 
			de.DEidentificacion, 
			 {fn concat({fn concat({fn concat({fn concat(de.DEapellido1, ' ' )}, de.DEapellido2 )}, ' ' )}, de.DEnombre )} as DEnombre
	from RHEmpleadoCurso a
	
	inner join LineaTiempo lt
	on lt.Ecodigo=a.Ecodigo
	and lt.DEid=a.DEid
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">  between LTdesde and LThasta
	
	inner join DatosEmpleado de
	on de.DEid=a.DEid
	and de.Ecodigo=a.Ecodigo
	
	inner join RHPlazas p
	on p.Ecodigo=lt.Ecodigo
	and p.RHPid=lt.RHPid
	and p.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
	
	inner join CFuncional cf
	on cf.Ecodigo=p.Ecodigo
	and cf.CFid=p.CFid
	
	inner join RHCursos c
	on c.Ecodigo=a.Ecodigo
	and c.RHCid=a.RHCid
	
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.RHCid is not null
	
	order by cf.CFcodigo, c.RHCcodigo, de.DEapellido1,de.DEapellido2,de.DEnombre
</cfquery>




<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CentroFuncional"
	Default="Centro Funcional"
	returnvariable="LB_CentroFuncional"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Concurso"
	Default="Concurso"
	returnvariable="LB_Concurso"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConcusosxCentroFuncional"
	Default="Concursos por Centro Funcional"
	returnvariable="LB_ConcusosxCentroFuncional"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_identificacion"
	Default="Identificación"
	returnvariable="LB_identificacion"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleado"
	Default="Empleado"
	returnvariable="LB_Empleado"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_fechainicio"
	Default="Fecha Inicio"
	returnvariable="LB_fechainicio"/>    
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_fechafin"
	Default="Fecha Fin"
	returnvariable="LB_fechafin"/>        


<cfset LvarFileName = "Lst_ConcursoxCF#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls"> 


<cfset params = structKeyList(url) />
<cfset miURL=''>
<cfloop index="ix" list="#params#">
    <cfset miURL = miURL & '&' & ix & '=' & url[ix]>
</cfloop>
 

<cfoutput>
<cf_htmlReportsHeaders title="#LB_ConcusosxCentroFuncional#" filename="#LvarFileName#"
param="#miURL#"
irA="cursos-cf-filtro.cfm" 
>
<cf_templatecss/>
 
<cf_EncReporte 
Titulo="#LB_ConcusosxCentroFuncional#"
filtro1="#LB_CentroFuncional#:#url.CFcodigo# - #url.CFdescripcion#"
>
</cfoutput>
</style>
 
    <table class="reporte">
	     <tbody>
        	
			<cfoutput query="rs" group="RHCcodigo">
                <thead>
                    <tr>
                        <th align="left">#LB_Concurso#:</th>
                        <td nowrap="nowrap">#RHCcodigo#</td>
                    </tr>
                    <tr>
                        <th>#LB_identificacion#</th>
                        <th align="left">#LB_Empleado#</th>
                        <th>#LB_fechainicio#</th>
                        <th>#LB_fechafin#</th>
                    </tr>
                </thead>
                <cfoutput>
                     <tr>
                        <td nowrap="nowrap"align="center">#DEidentificacion#</td>
                        <td nowrap="nowrap">#DEnombre#</td>
                        <td nowrap="nowrap" align="center"><cf_locale name="date" value="#RHCfdesde#"/></td>
                        <td nowrap="nowrap" align="center"><cf_locale name="date" value="#RHCfhasta#"/></td>
                    </tr>
                </cfoutput>
            </cfoutput>
           
            <tr>&nbsp;</tr>
        </tbody>
         <thead>
            <tr align="center">
                <th align="center"> **** Fin de Reporte ****</th>
            </tr>
		</thead>    
    </table> 
	<cfif rs.recordcount EQ 0 >
	    <tr>
			<td colspan="4" style=" font-family:Helvetica; font-size:8; padding:8px;" align="center">-- No se encontraron registros --</td>
		</tr>
    </cfif>

 

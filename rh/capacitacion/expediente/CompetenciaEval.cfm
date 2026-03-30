<cfquery name="rsCompetencias" datasource="#session.dsn#">
		select tipo,idcompetencia from RHCompetenciasEmpleado   
		where RHCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCEid#">
		and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfquery name="rsEvaluaciones" datasource="#session.dsn#">
	select  A.DEid,B.RHEEdescripcion, C.RHNEDpromedio     
	from  RHListaEvalDes A, 
	RHEEvaluacionDes B,
	RHNotasEvalDes C
	where  A.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
	and A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and A.Ecodigo = B.Ecodigo
	and A.RHEEid = B.RHEEid
	and A.DEid = C.DEid
	and A.RHEEid = C.RHEEid
	and B.RHEEestado = 3
    <cfif rsCompetencias.tipo EQ "H">
		and C.RHHid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCompetencias.idcompetencia#">
	<cfelse>
		and C.RHCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCompetencias.idcompetencia#">
	</cfif>
</cfquery>
<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
	<tr>
		<td colspan="2">
			<cfinvoke
					component="rh.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet"> 
				<cfinvokeargument name="query" value="#rsEvaluaciones#"/> 
				<cfinvokeargument name="etiquetas" value="Descripción,Promedio"/> 
				<cfinvokeargument name="desplegar" value="RHEEdescripcion,RHNEDpromedio"/> 
				<cfinvokeargument name="formatos" value="S,M"/> 
				<cfinvokeargument name="align" value="left,right"/> 
				<cfinvokeargument name="ajustar" value="N"/> 
				<cfinvokeargument name="checkboxes" value="N"/> 
				<cfinvokeargument name="irA" value="#CurrentPage#"/>
				<cfinvokeargument name="EmptyListMsg" value="El empleado no tiene evaluaciones para esta competencia"/>						
				<cfinvokeargument name="showEmptyListMsg" value="true"/>						
				<cfinvokeargument name="maxrows" value="10"/>
				<cfinvokeargument name="showlink" value="false"/>
			</cfinvoke>
		</td>
	</tr>
</table>

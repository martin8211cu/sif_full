<cfset filtro = ''>
<cfif isdefined("url.DEidentificacion") and Len(Trim(url.FDEidentificacion)) NEQ 0>
	<cfset filtro = filtro & " and upper(b.DEidentificacion) like '%" & #UCase(Form.FDEidentificacion)# & "%'">
</cfif>
<cfif isdefined("url.FDEnombre") and Len(Trim(url.FDEnombre)) NEQ 0>
	<cfset filtro = filtro & " and upper(b.DEapellido1 + ' ' + b.DEapellido2 + ', ' + b.DEnombre) like '%" & #UCase(url.FDEnombre)# & "%'">
</cfif>
<cfif isdefined("url.fRHPcodigo") and Len(Trim(url.fRHPcodigo)) NEQ 0>
 	<cfset filtro = filtro & " and upper(a.RHPcodigo) like '%" & #UCase(url.fRHPcodigo)# & "%'">
</cfif>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Autoevaluacion"
	Default="Autoevaluación"
	returnvariable="LB_Autoevaluacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Jefe"
	Default="Jefe"
	returnvariable="LB_Jefe"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Companero"
	Default="Compañero"
	returnvariable="LB_Companero"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Subordinado"
	Default="Colaborador"
	returnvariable="LB_Subordinado"/>


<cfquery name="rsDatos" datasource="#session.DSN#">
	select 	a.RHEEid, 
			b.DEid,
			{fn concat(b.DEidentificacion,{fn concat(' ',{fn concat(b.DEapellido1,{fn concat(' ',{fn concat(b.DEapellido2,{fn concat(', ',b.DEnombre)})})})})})} as DEidentificacionNombre,
			b.DEidentificacion, 
			{fn concat(b.DEapellido1,{fn concat(' ',{fn concat(b.DEapellido2,{fn concat(', ',b.DEnombre)})})})} as NombreCompleto, 
			c.RHPdescpuesto, 
			e.DEid as DEideval, 
			e.DEidentificacion as DEidentificacioneval, 
			{fn concat(e.DEapellido1,{fn concat(' ',{fn concat(e.DEapellido2,{fn concat(', ',e.DEnombre)})})})}  as NombreCompletoEval,
			d.RHEDtipo, 
			RHEDtipodesc = case RHEDtipo 	when 'A' then '#LB_Autoevaluacion#' 
											when 'J' then '#LB_Jefe#' 
											when 'C' then '#LB_Companero#' when 'S'  then '#LB_Subordinado#' 
			end			
	
	from 	RHListaEvalDes a, 
			DatosEmpleado b, 
			RHPuestos c, 
			RHEvaluadoresDes d, 
			DatosEmpleado e
	
	where 		a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and a.RHEEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEEid#">
				#preservesinglequotes(filtro)#	
				and a.DEid = b.DEid 
				and a.Ecodigo = c.Ecodigo 
				and a.RHPcodigo = c.RHPcodigo 
				and a.DEid = d.DEid 
				and a.RHEEid = d.RHEEid 
				and d.DEideval = e.DEid
				
	order by 	c.RHPdescpuesto, b.DEidentificacion, b.DEapellido1, 
				b.DEapellido2, b.DEnombre, e.DEidentificacion, 
				e.DEapellido1, e.DEapellido2, e.DEnombre
</cfquery>

<table width="98%" cellpadding="2" cellspacing="">
	<tr><td><strong><cfoutput>#session.Enombre#</cfoutput></strong></td></tr>
	<tr><td><strong><cf_translate key="LB_RelacionesDeEvaluacion">Relaciones de Evaluación</cf_translate><strong></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td class="subtitulo" align="center"><cf_translate key="LB_ListaDeEvaluadores">Lista de Evaluadores</cf_translate></td></tr>
	<tr>
		<td>
			<!--- VARIABLES DE TRADUCCION --->
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Identificacion"
				Default="Identificación"
				returnvariable="LB_Identificacion"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_NombreCompleto"
				Default="Nombre Completo"
				returnvariable="LB_NombreCompleto"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Tipo"
				Default="Tipo"
				returnvariable="LB_Tipo"/>			
			<cfinvoke 
				component="rh.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsDatos#"/>
				<cfinvokeargument name="cortes" value="RHPdescpuesto, DEidentificacionNombre"/>
				<cfinvokeargument name="desplegar" value="DEidentificacioneval, NombreCompletoEval, RHEDtipodesc"/>
				<cfinvokeargument name="etiquetas" value="#LB_Identificacion#, #LB_NombreCompleto#, #LB_Tipo#"/>
				<cfinvokeargument name="formatos" value="S,S,S"/>
				<cfinvokeargument name="align" value="left, left, left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value=""/>				
				<cfinvokeargument name="keys" value="DEid, DEideval"/>				
				<cfinvokeargument name="MaxRows" value="0"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<!----<cfinvokeargument name="funcion" value="doConlis"/>
				<cfinvokeargument name="fparams" value="EOidorden"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/> ---->
		</cfinvoke>
		</td>
	</tr>
</table>

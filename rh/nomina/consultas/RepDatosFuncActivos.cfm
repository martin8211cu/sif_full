<!--- VARIABLES DE TRADUCCION --->

<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_ReporteDatosFunc" Default="Reporte de datos de los funcionarios activos" returnvariable="LB_ReporteDatosFunc" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Todos" Default="--- Todos ---" returnvariable="LB_Todos" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke key="LB_ListaDePuestos" default="Lista de Puestos" returnvariable="LB_ListaDePuestos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_ListaDeSedes" default="Lista de Sedes" returnvariable="LB_ListaDeSedes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Codigo" default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripcion" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>	


<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<!--- CONSULTA DE DEPARTAMENTOS --->
<cfset rsDepartamentos = queryNew("value,description","Integer,Varchar")>
<cfset queryAddRow(rsDepartamentos,1)>
<cfset querySetCell(rsDepartamentos,"value",-1,rsDepartamentos.recordcount)>
<cfset querySetCell(rsDepartamentos,"description",LB_Todos,rsDepartamentos.recordcount)>
<cfquery name="rsDeptos" datasource="#session.DSN#">
	select Dcodigo as v, Ddescripcion as d
	from Departamentos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    order by Dcodigo
</cfquery>
<cfloop query="rsDeptos">
	<cfset queryAddRow(rsDepartamentos,1)>
	<cfset querySetCell(rsDepartamentos,"value",v,rsDepartamentos.recordcount)>
	<cfset querySetCell(rsDepartamentos,"description",d,rsDepartamentos.recordcount)>
</cfloop>

<cfquery name="rsCargas" datasource="#session.DSN#">	
	select DClinea ,  DCdescripcion                
	from ECargas encab, DCargas det
	
	where encab.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and encab.ECid = det.ECid
	
</cfquery>


<cfquery name="rsIncidentes" datasource="#Session.DSN#">
	select CIid, CIcodigo, CIdescripcion
	from CIncidentes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">		
</cfquery>


	<cfinclude template="/rh/Utiles/params.cfm"><strong></strong>
     <cf_web_portlet_start titulo="#LB_ReporteDatosFunc#">         
		<form name="filtro" method="post" action="RepDatosFuncActivos-form.cfm">
			<table border="0" cellpadding="1" cellspacing="1" align="center">                          
				<tr> 					
					<td align="left">
					<cf_translate key="LB_Departamento">Departamento</cf_translate>:&nbsp;</td>
					<td id="tdDep"  >
						<select name="cmb_Dep" tabindex="1" >
							<option value="-1" selected="selected">Todos </option>	
							<cfoutput query="rsDepartamentos">
								<option value="#rsDepartamentos.value#">#rsDepartamentos.description#</option>
							</cfoutput>		
						</select>
					</td>
				</tr>	
			<tr>																				  
				<td align="left">
				<cf_translate key="LB_Deduccion">Deducci&oacute;n</cf_translate>:&nbsp;</td>				
			     <td id="tdDeducc" >	<cf_rhtipodeduccion form="filtro" name="rhdeducc" size= "20" tabindex="1"></td>					
			</tr>			
			<tr>
					<td align="left">
					<cf_translate key="LB_ComponentesSal">Componente Salarial</cf_translate>:&nbsp;</td>	
						
					<td>
					<cf_conlis title="#LB_ListaDeSedes#"
						campos = "CSid,CScodigo,CSdescripcion " 
						desplegables = "N,S,S" 
						modificables = "S,N" 
						size = "0,10,30"
						asignar="CSid,CScodigo,CSdescripcion"
						asignarformatos="N,S,S"
						tabla="ComponentesSalariales"																	
						columnas="CSid,CScodigo,CSdescripcion"
						filtro="Ecodigo =#session.Ecodigo#"
						desplegar="CScodigo,CSdescripcion"
						etiquetas="#LB_Codigo#,#LB_Descripcion#"
						formatos="S,S"
						align="left,left"
						showEmptyListMsg="true"
						debug="false"
						form="filtro"
						width="800"
						height="500"
						left="70"
						top="20"
						filtrar_por="CScodigo,CSdescripcion">			
				</td>	
					
			</tr>										 								
			<tr>
				<td align="left"> 
				<cf_translate key="LB_Puestos">Puesto</cf_translate>:&nbsp;</td>
				<td>
					<cf_conlis title="#LB_ListaDePuestos#"
						campos = "RHPcodigo,RHPdescpuesto" 
						desplegables = "S,S" 
						modificables = "S,N" 
						size = "10,30"
						asignar="RHPcodigo,RHPdescpuesto"
						asignarformatos="S,S"
						tabla="RHPuestos"																	
						columnas="RHPcodigo,RHPdescpuesto"
						filtro="Ecodigo =#session.Ecodigo#"
						desplegar="RHPcodigo,RHPdescpuesto"
						etiquetas="#LB_Codigo#,#LB_Descripcion#"
						formatos="S,S"
						align="left,left"
						showEmptyListMsg="true"
						debug="false"
						form="filtro"
						width="800"
						height="500"
						left="70"
						top="20"
						filtrar_por="RHPcodigo,RHPdescpuesto">			
				</td>
		</tr>
			<tr>
				<td align="left"> 
				<cf_translate key="LB_CatPuestos">Categor&iacute;a de Puesto</cf_translate>:&nbsp;              </td>
				<td colspan="3"><cf_rhcategorias  form="filtro"></td>	
			</tr>
						
			<tr>
				<td align="left">
				<cf_translate key="LB_Sexo">Sexo</cf_translate>:&nbsp;</td>
				<td id="tdSexo" >
					<select name="cmb_Sexo" id="select2">
						<option value="-1" selected="selected">Todos </option>	
						<option value="M" ><cf_translate key="LB_Masculino">Masculino</cf_translate></option>
						<option value="F" ><cf_translate key="LB_Femenino">Femenino</cf_translate></option>
                  </select>				
				 </td>
			</tr>
			
			<tr><td align="left">
			<cf_translate key="LB_Sede">Sede</cf_translate>:&nbsp;</td>
				<td>
					<cf_conlis title="#LB_ListaDeSedes#"
						campos = "Ocodigo,Oficodigo,Odescripcion " 
						desplegables = "N,S,S" 
						modificables = "S,N" 
						size = "0,10,30"
						asignar="Ocodigo,Oficodigo,Odescripcion"
						asignarformatos="N,S,S"
						tabla="Oficinas"																	
						columnas="Ocodigo,Oficodigo,Odescripcion"
						filtro="Ecodigo =#session.Ecodigo#"
						desplegar="Oficodigo,Odescripcion"
						etiquetas="#LB_Codigo#,#LB_Descripcion#"
						formatos="S,S"
						align="left,left"
						showEmptyListMsg="true"
						debug="false"
						form="filtro"
						width="800"
						height="500"
						left="70"
						top="20"
						filtrar_por="Oficodigo,Odescripcion">			
				</td>
			</tr>
			<tr> <td>
			<cf_translate key="LB_Prestacion">Prestaci&oacute;n</cf_translate>:&nbsp;</td>
				<td id="tdPrest" > 
					<select name="cmb_Prest" >
							<option value="-1" selected="selected">Todos </option>	
						<cfoutput query="rsCargas">
							<option value="#DClinea#">#DCdescripcion#</option>
						</cfoutput>
					</select> 				
				</td>			
			</tr>
			
			<tr><td>
			<cf_translate key="LB_Percepcion">Percepci&oacute;n </cf_translate>:&nbsp;</td>
			<td id="tdPercep" > 
				<select name="cmb_Persep">
						<option value="-1" selected="selected">Todos </option>					
					<cfoutput query="rsIncidentes">
						<option value="#CIid#">#CIdescripcion#</option>
					</cfoutput>
				</select>
			
			</td>
			</tr>
				
				<tr><td nowrap align="center" colspan="2"><cf_botones values="Generar"></td></tr>
			</table>
		</form>          
        <cf_web_portlet_end>
  
		<cf_templatefooter>
		<cf_qforms form="filtro">
		</cf_qforms>

<script language="javascript1.2" type="text/javascript">
	<!---function mostrarDep(obj){
		
		var tdDep =document.getElementById("tdDep");	
		if(obj.checked== true){
			tdDep.style.display = '';			
		}	
		else	{
			tdDep.style.display = 'none';	
		}		 
	} --->	
</script>
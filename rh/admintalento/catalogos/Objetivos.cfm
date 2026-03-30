<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_CatalogoDeObjetivo"
			Default="Cat&aacute;logo de Objetivos"
			returnvariable="LB_CatalogoDeObjetivo"/>
					
	  <cf_web_portlet_start titulo="#LB_CatalogoDeObjetivo#">
			<cfif isdefined("url.RHOSid") and len(Trim(url.RHOSid))>
				<cfset Form.RHOSid = url.RHOSid>
			</cfif>
			<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
			<cfinclude template="/rh/portlets/pNavegacion.cfm">			
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="top" width="40%">
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_Codigo"
							Default="C&oacute;digo"
							XmlFile="/rh/generales.xml"
							returnvariable="LB_Codigo"/>
							
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_Codigo2"
							Default="Código"
							returnvariable="LB_Codigo2"/>	

						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_Objetivo"
							Default="Objetivo"
							returnvariable="LB_Objetivo"/>
							
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_Porcentaje"
							Default="Porcentaje"
							returnvariable="LB_Porcentaje"/>
								
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_Peso"
							Default="Peso"
							returnvariable="LB_Peso"/>	
							
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_Tipo"
							Default="Tipo"
							returnvariable="LB_Tipo"/>							
							
					<cfset filtro = "a.Ecodigo = #Session.Ecodigo# and a.RHTOid = b.RHTOid and a.Ecodigo = b.Ecodigo order by RHTOcodigo" >
					<cf_dbfunction name="to_char" args="a.RHOStexto" returnvariable="x">
					<cf_dbfunction name="string_part" args="#x#|1|45" returnvariable="vRRHOStexto" delimiters="|">
					<cf_dbfunction name="string_part" args="b.RHTOdescripcion,1,45" returnvariable="vRHTOdescripcion">
					
					<cfinvoke 
					 component="rh.Componentes.pListas"
					 method="pListaRH"
					 returnvariable="pListaRet">
					 
						<cfinvokeargument name="tabla" value="RHObjetivosSeguimiento a ,RHTipoObjetivo b"/>
						<cfinvokeargument name="columnas" value="a.RHOSid, a.RHOScodigo,{fn concat(b.RHTOcodigo,{fn concat('-',{fn concat(#vRHTOdescripcion#,'')})})} as RHTOcodigo,{fn concat(#vRRHOStexto#,'...')} as RHOStexto,RHOSporcentaje,RHOSpeso"/>
						<cfinvokeargument name="desplegar" value="RHOScodigo,RHOStexto,RHOSporcentaje,RHOSpeso"/>
						<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Objetivo#,#LB_Porcentaje#,#LB_Peso#"/>
						<cfinvokeargument name="formatos" value="V,V,M,M"/>
						<cfinvokeargument name="filtro" value="#filtro#"/>
						<cfinvokeargument name="align" value="left,left,right,right"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="Cortes" value="RHTOcodigo"/>
						
						<cfinvokeargument name="checkboxes" value="N"/>				
						<cfinvokeargument name="irA" value="Objetivos.cfm"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="keys" value="RHOSid"/>
					</cfinvoke>
					</td>
					<td width="60%" valign="top" align="left"><cfinclude template="formObjetivos.cfm"></td>
				</tr>
			</table>
	  <cf_web_portlet_end>
<cf_templatefooter>      

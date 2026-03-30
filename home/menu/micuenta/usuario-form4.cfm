<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Inactivo"
	Default="Inactivo"
	returnvariable="LB_Inactivo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Temporal"
	Default="Temporal"
	returnvariable="LB_Temporal"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Activo"
	Default="Activo"
	returnvariable="LB_Activo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Sistema"
	Default="Sistema"
	returnvariable="LB_Sistema"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Modulo"
	Default="Módulo"
	returnvariable="LB_Modulo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Servicio"
	Default="Servicio"
	returnvariable="LB_Servicio"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ServiciosDisponiblesEnMiPerfil"
	Default="Servicios disponibles en mi perfil"
	returnvariable="LB_ServiciosDisponiblesEnMiPerfil"/>
	
	
	
	
<!--- Consultas --->

<cfquery name="rsData" datasource="asp">
	select a.id_direccion,
		   a.datos_personales,
		   a.Ufhasta,
		   a.Uestado,
		   a.LOCIdioma,
		   a.Usulogin,
		   (case when a.Uestado = 0 then '#LB_Inactivo#' 
		   		 when a.Uestado = 1 and a.Utemporal = 1 then '#LB_Temporal#' 
		   		 when a.Uestado = 1 and a.Utemporal = 0 then '#LB_Activo#' else '' end) as estado
	from Usuario a
	where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
</cfquery>

<cfquery name="rsPais" datasource="asp">
	select Ppais, Pnombre 
	from Pais
</cfquery>

<!--- leer skins del archivo css --->
<cfsetting enablecfoutputonly="yes">
	<cffile action="read" file="#  ExpandPath('/sif/css/web_portlet.css') #" variable="web_portlet_css">
	<cfset web_portlet_array = ListToArray(web_portlet_css, chr(10) & chr(13))>
	<cfset skin_array = ArrayNew(1)>
	<cfloop from="1" to="#ArrayLen(web_portlet_array)#" index="i">
		<cfset skin_line = Trim(web_portlet_array[i])>
		<cfif Left(skin_line, 2) EQ "/*" and Right(skin_line,2) EQ "*/">
			<cfset skin_line = Trim(Mid(skin_line, 3, Len(skin_line) - 4))>
			<cfif ListLen(skin_line,":") EQ 3 AND ListGetAt(skin_line,1,":") EQ "name">
				<cfset ArrayAppend(skin_array, ListGetAt(skin_line, 3, ":") & "," & ListGetAt(skin_line, 2, ":"))>
			</cfif>
		</cfif>
	</cfloop>
	<cfset ArraySort(skin_array,"textnocase")>
<cfsetting enablecfoutputonly="no">

<cfquery name="rsLista" datasource="asp">
	select distinct 
	 	s.SSorden as SSorden, 
    	p.SPorden as SPorden, 
    	s.SSdescripcion as nombre_sistema, 
    	p.SPdescripcion as nombre_servicio, 
    	rtrim(s.SScodigo) as sistema, 
    	rtrim (p.SPcodigo) as servicio, 
    	m.SMcodigo as modulocod, 
    	m.SMdescripcion as Modulodes 
	from SSistemas s, SProcesos p, vUsuarioProcesos sr, SModulos m
	where sr.Usucodigo = #session.Usucodigo#
	  and m.SScodigo = sr.SScodigo 
	  and m.SMcodigo = sr.SMcodigo 
	  and sr.SScodigo = p.SScodigo 
	  and sr.SMcodigo = p.SMcodigo 
	  and sr.SPcodigo = p.SPcodigo 
	  and sr.SScodigo = s.SScodigo  
	  
	  <cfif isdefined("form.FILTRO_NOMBRE_SISTEMA") and len(trim(form.FILTRO_NOMBRE_SISTEMA))>
	  	and upper(ltrim(rtrim(s.SSdescripcion)))  like '%#Ucase(trim(form.FILTRO_NOMBRE_SISTEMA))#%'
	  </cfif>

	  <cfif isdefined("form.FILTRO_MODULODES") and len(trim(form.FILTRO_MODULODES))>
	  	and upper(ltrim(rtrim(m.SMdescripcion)))  like '%#Ucase(trim(form.FILTRO_MODULODES))#%'
	  </cfif>

	  <cfif isdefined("form.FILTRO_NOMBRE_SERVICIO") and len(trim(form.FILTRO_NOMBRE_SERVICIO))>
		and upper(ltrim(rtrim(p.SPdescripcion)))  like '%#Ucase(trim(form.FILTRO_NOMBRE_SERVICIO))#%'
	  </cfif>
	
	union  
	  
	select distinct 
		s.SSorden as SSorden, 
		p.SPorden as SPorden, 
		s.SSdescripcion as nombre_sistema, 
		p.SPdescripcion as nombre_servicio, 
		rtrim(s.SScodigo) as sistema, 
		rtrim (p.SPcodigo) as servicio, 
		m.SMcodigo as modulocod, 
		m.SMdescripcion as Modulodes 
	from UsuarioRol ur, SProcesosRol pr, SSistemas s, SProcesos p, SModulos m
	where ur.Usucodigo = #session.Usucodigo#
	
	  and pr.SScodigo = ur.SScodigo
	  and pr.SRcodigo = ur.SRcodigo
	
	  and s.SScodigo  = pr.SScodigo
	
	  and p.SScodigo  = pr.SScodigo
	  and p.SMcodigo  = pr.SMcodigo
	  and p.SPcodigo  = pr.SPcodigo
	
	  and m.SScodigo = p.SScodigo 
	  and m.SMcodigo = p.SMcodigo 

		
	  <cfif isdefined("form.FILTRO_NOMBRE_SISTEMA") and len(trim(form.FILTRO_NOMBRE_SISTEMA))>
	  	and upper(ltrim(rtrim(s.SSdescripcion)))  like '%#Ucase(trim(form.FILTRO_NOMBRE_SISTEMA))#%'
	  </cfif>

	  <cfif isdefined("form.FILTRO_MODULODES") and len(trim(form.FILTRO_MODULODES))>
	  	and upper(ltrim(rtrim(m.SMdescripcion)))  like '%#Ucase(trim(form.FILTRO_MODULODES))#%'
	  </cfif>

	  <cfif isdefined("form.FILTRO_NOMBRE_SERVICIO") and len(trim(form.FILTRO_NOMBRE_SERVICIO))>
		and upper(ltrim(rtrim(p.SPdescripcion)))  like '%#Ucase(trim(form.FILTRO_NOMBRE_SERVICIO))#%'
	  </cfif>
	  
	order by SSorden, nombre_sistema, sistema, servicio, modulocod, nombre_servicio
</cfquery>


  <table width="100%" border="0" align="left" cellpadding="0" cellspacing="4">
			  <tr><td colspan="2" align="center" class="tituloListas" ><cfoutput>#LB_ServiciosDisponiblesEnMiPerfil#</cfoutput></td></tr>
			<cfset navegacion = "">
			<cfset navegacion = navegacion & "tab=4">
			
  			  <tr>
				  <td colspan="2">
					  <!--- Para meterlo con el nuevo query nuevo --->
					  <cfinvoke component='rh.Componentes.pListas'	
						method='pListaQuery' 
						returnvariable='pListaRet'>
							<cfinvokeargument name='query' value='#rsLista#'>
							<cfinvokeargument name="desplegar" value="nombre_sistema, modulodes, nombre_servicio"/>
							<cfinvokeargument name="etiquetas" value="#LB_Sistema#, #LB_Modulo#, #LB_Servicio#"/>
							<cfinvokeargument name="formatos" value="V, V, V"/>
							<cfinvokeargument name="align" value="left, left, left"/>
							<cfinvokeargument name="ajustar" value="N, N, N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="Conexion" value="asp"/>
							<cfinvokeargument name="showLink" value="false"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="Mostrar_Filtro" value="true"/>
							<cfinvokeargument name="MaxRows" value="100"/>
					</cfinvoke>
				 </td>
			  </tr>
			  <tr align="center">
			    <td colspan="2">&nbsp;</td>
    </tr>
  </table>
<script language="javascript">
function funcFiltrar () {
	document.lista.action='index.cfm?tab=4';
	return true;
}

</script>
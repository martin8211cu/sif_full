<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>

	<cf_web_portlet_start titulo="#nav__SPdescripcion#">
		<cfinclude template="ISBmotivoBloqueo-params.cfm">
			
		<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO HABILITADO--->
		<cfquery datasource="#session.dsn#" name="rsHabilitado">
			select '' as value, '-- todos --' as description, '0' as ord
			union
			select '0' as value, 'Inactivo Temporal' as description, '1' as ord
			union
			select '1' as value, 'Activo' as description, '2' as ord
			union		
			select '3' as value, 'En Creaci&oacute;n' as description, '3' as ord
			order by 3,2
		</cfquery>	
		<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO MBconCompromiso--->
		<cfquery datasource="#session.dsn#" name="rsMBconCompromiso">
			select '' as value, '-- todos --' as description, '0' as ord
			union
			select '1' as value, 'Con Compromiso' as description, '1' as ord
			union
			select '0' as value, 'Sin Compromiso' as description, '2' as ord
			order by 3,2
		</cfquery>			
		<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO MBconCompromiso--->
		<cfquery datasource="#session.dsn#" name="rsMBautogestion">
			select '' as value, '-- todos --' as description, '0' as ord
			union
			select '1' as value, 'Con Autogesti&oacute;n' as description, '1' as ord
			union
			select '0' as value, 'Sin Autogesti&oacute;n' as description, '2' as ord
			order by 3,2
		</cfquery>		
		<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO MBdesbloqueable--->
		<cfquery datasource="#session.dsn#" name="rsMBdesbloqueable">
			select '' as value, '-- todos --' as description, '0' as ord
			union
			select '1' as value, 'Desbloqueable' as description, '1' as ord
			union
			select '0' as value, 'No Desbloqueable' as description, '2' as ord
			order by 3,2
		</cfquery>	
		<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO MBbloqueable--->
		<cfquery datasource="#session.dsn#" name="rsMBbloqueable">
			select '' as value, '-- todos --' as description, '0' as ord
			union
			select '1' as value, 'Bloqueable' as description, '1' as ord
			union
			select '0' as value, 'No Bloqueable' as description, '2' as ord
			order by 3,2
		</cfquery>						
		
		<cfset check1 = "<img src=''/cfmx/saci/images/w-check.gif'' border=''0'' title=''Con Compromiso''>">
		<cfset check2 = "<img src=''/cfmx/saci/images/w-check.gif'' border=''0'' title=''Autogesti&oacute;n''>">		
		<cfset check3 = "<img src=''/cfmx/saci/images/w-check.gif'' border=''0'' title=''Desbloqueable''>">				
		<cfset check4 = "<img src=''/cfmx/saci/images/w-check.gif'' border=''0'' title=''Bloqueable''>">						
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			tabla="ISBmotivoBloqueo"
			columnas="MBmotivo
					, MBdescripcion
					, case Habilitado
						when 0 then 'Inactivo Temporal'
						when 1 then 'Activo'
						when 3 then 'En Creaci&oacute;n'
					  end HabilitadoDesc
					, Habilitado
					, case MBconCompromiso	
						when 0 then ''
						when 1 then '#check1#'
					end 	MBconCompromisoImg
					, case MBautogestion
						when 0 then ''
						when 1 then '#check2#'
					end 	MBautogestionImg
					, case MBdesbloqueable
						when 0 then ''
						when 1 then '#check3#'
					end 	MBdesbloqueableImg					
					, case MBbloqueable
						when 0 then ''
						when 1 then '#check4#'
					end 	MBbloqueableImg								
					, MBconCompromiso
					, MBsinCompromiso
					, MBautogestion
					, '#pagina#' as PageNum"
			filtro="Ecodigo = #session.Ecodigo# 
					and Habilitado <> 2
					order by MBmotivo,MBdescripcion"
			desplegar="MBdescripcion,HabilitadoDesc,MBconCompromisoImg,MBautogestionImg,MBdesbloqueableImg,MBbloqueableImg"
			etiquetas="Descripci&oacute;n,Estado,Con Compromiso,Autogesti&oacute;n,Desbloqueable,Bloqueable"
			formatos="S,S,U,U,U,U"
			align="left,left,center,center,center,center"
			ira="ISBmotivoBloqueo-edit.cfm"
			form_method="post"
			rsHabilitadoDesc = "#rsHabilitado#"
			rsMBconCompromisoImg = "#rsMBconCompromiso#"			
			rsMBautogestionImg = "#rsMBautogestion#"						
			rsMBdesbloqueableImg = "#rsMBdesbloqueable#"									
			rsMBbloqueableImg = "#rsMBbloqueable#"
			keys="MBmotivo"
			maxRows="20"
			mostrar_filtro="yes"
			filtrar_automatico="yes"
			filtrar_por="MBdescripcion,Habilitado,MBconCompromiso,MBautogestion,MBdesbloqueable,MBbloqueable"
			botones="Nuevo"
		/>
				
	<cf_web_portlet_end>
<cf_templatefooter>



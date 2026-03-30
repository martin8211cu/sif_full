<cfset modoVal = 'ALTA'>
<cfif isdefined("url.ANid") and len(trim(url.ANid))>
	<cfset form.ANid = url.ANid>
</cfif>
<cfif isdefined("url.AGid2") and len(trim(url.AGid2))>
	<cfset form.AGid = url.AGid2>
</cfif>

<cfif isdefined("url.Filtro_ANfecha2") and len(trim(url.Filtro_ANfecha2))>
	<cfset form.Filtro_ANfecha2 = url.Filtro_ANfecha2>
</cfif>
<cfif isdefined("url.Filtro_ANautomatica2") and len(trim(url.Filtro_ANautomatica2))>
	<cfset form.Filtro_ANautomatica2 = url.Filtro_ANautomatica2>
</cfif>
<cfif isdefined("url.Filtro_ANobservacion2") and len(trim(url.Filtro_ANobservacion2))>
	<cfset form.Filtro_ANobservacion2 = url.Filtro_ANobservacion2>
</cfif>

<cfif isdefined("form.ANid") and len(trim(form.ANid))>
	<cfset modoVal = 'CAMBIO'>
</cfif>

<cfparam name="form.Filtro_ANfecha2" default="">
<cfparam name="form.Filtro_ANautomatica2" default="">
<cfparam name="form.Filtro_ANobservacion2" default="">

<cfoutput>	
	<table width="100%" border="0" cellspacing="0" cellpadding="2">	
		<tr>
			<td>
				<cfinclude template="agente-valoracion-form.cfm">
		  	</td>
		</tr>
		<tr><td><hr></td></tr>				
		<tr><td align="center">
			<cfset campos_extra = ", 7 as tab" >
			<cfif isdefined("form.paso")>
				<cfset campos_extra = campos_extra & ", #form.paso# as paso" >
			</cfif>
 			<cfif isdefined("form.AGid")>
				<cfset campos_extra = campos_extra & ", #form.AGid# as ag" >
			</cfif>
			<cfif isdefined("form.CTid")>
				<cfset campos_extra = campos_extra & ",#form.CTid# as cue" >
			</cfif>	
			<cfif isdefined("form.PageNum_listaroot")>
				<cfset campos_extra = campos_extra & ", #form.PageNum_listaroot# as PageNum_listaroot" >
			</cfif>			
			<cfif isdefined("form.Filtro_Ppersoneria")>
				<cfset campos_extra = campos_extra & ", '#form.Filtro_Ppersoneria#' as Filtro_Ppersoneria" >
				<cfset campos_extra = campos_extra & ", '#form.Filtro_Ppersoneria#' as hFiltro_Ppersoneria" >
			</cfif>
			<cfif isdefined("form.Filtro_Pid")>
				<cfset campos_extra = campos_extra & ", '#form.Filtro_Pid#' as Filtro_Pid" >
				<cfset campos_extra = campos_extra & ", '#form.Filtro_Pid#' as hFiltro_Pid" >
			</cfif>		
			<cfif isdefined("form.Filtro_nom_razon")>
				<cfset campos_extra = campos_extra & ", '#form.Filtro_nom_razon#' as Filtro_nom_razon" >
				<cfset campos_extra = campos_extra & ", '#form.Filtro_nom_razon#' as hFiltro_nom_razon" >
			</cfif>		
			<cfif isdefined("form.Filtro_Habilitado")>
				<cfset campos_extra = campos_extra & ", '#form.Filtro_Habilitado#' as Filtro_Habilitado" >
				<cfset campos_extra = campos_extra & ", '#form.Filtro_Habilitado#' as hFiltro_Habilitado" >
			</cfif>
			<cfif isdefined("form.tipo")>
				<cfset campos_extra = campos_extra & ", '#form.tipo#' as tipo" >
			</cfif>						

			
			<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO ANAUTOMATICA--->		
			<cfquery name="rsAutomatica" datasource="#session.DSN#">
					select -1 as value
						, '--Todas--' as description
				union 		
					select 0 as value
						, 'Manual' as description
				union 		
					select 1 as value
						, 'Automática' as description
				order by value
			</cfquery>
			
			<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO ANVALORACION
			<cfquery datasource="#session.dsn#" name="rsANvaloracion">
				select '' as value, '-- todos --' as description, '0' as ord
				union
				select 1 as value, 'Positiva' as description, '1' as ord
				union
				select -1 as value, 'Negativa' as description, '2' as ord
				order by 3,2
			</cfquery>--->					
			<!--- <cfparam name="form.filtro_fechasMayores" default="1"> --->
			<cfset imgVerde = "<img src=''/cfmx/saci/images/verde.png'' border=''0'' title=''Positivas''>">
			<cfset imgRojo = "<img src=''/cfmx/saci/images/rojo.png'' border=''0'' title=''Negativas''>">			
		
			<cfinvoke component="sif.Componentes.pListas" method="pLista"
				tabla="ISBagenteValoracion"
				columnas="	ANid
							, AGid
							, case ANvaloracion
								when 1 then 'Positiva'
								when -1 then 'Negativa'
							end ANvaloracion
							, case ANvaloracion
								when 1 then '#imgVerde#'
								when -1 then '#imgRojo#'
							end ANvaloracionImg							
							, case ANautomatica
								when 1 then 'Automatica'
								when 0 then 'Manual'
							end ANautomaticaDesc
							, ANautomatica
							, ANobservacion
							, ANfecha
							, ANpuntaje
							#preservesinglequotes(campos_extra)#"
				filtro=" AGid=#form.AGid#
						order by ANvaloracion"
				desplegar="ANfecha,ANautomaticaDesc,ANobservacion,ANpuntaje,ANvaloracionImg"
				rsANautomaticaDesc="#rsAutomatica#"	
				etiquetas="Fecha,Tipo,Observaci&oacute;n,Puntaje,Valoraci&oacute;n"
				formatos="D,S,S,I,U"
				align="left,left,left,left,left"
				ira="agente.cfm"
				form_method="get"
				showLink="true"
				keys="ANid"
				Cortes="ANvaloracion"
				PageIndex="2"
				debug="N"
				maxRows="20"
				mostrar_filtro="yes"
				filtrar_por="ANfecha,ANautomatica,ANobservacion,ANpuntaje,ANvaloracion"
				filtrar_automatico="yes"
			/>		
		</td></tr>				
	</table>				

	<script type="text/javascript">
	<!--	
		function funcFiltrar2(){
			document.lista.TAB.value = 7;
			<cfif isdefined("form.paso")>
				document.lista.PASO.value="<cfoutput>#form.paso#</cfoutput>";
			</cfif>
			<cfif isdefined("form.AGid")>
				document.lista.AG.value="<cfoutput>#form.AGid#</cfoutput>";
			</cfif>			
			<cfif isdefined("form.CTid")>
				document.lista.CUE.value="<cfoutput>#form.CTid#</cfoutput>";
			</cfif>
			<cfif isdefined("form.PageNum_listaroot")>
				document.lista.PAGENUM_LISTAROOT.value="<cfoutput>#form.PageNum_listaroot#</cfoutput>";
			</cfif>
			<cfif isdefined("form.Filtro_Ppersoneria")>
				document.lista.FILTRO_PPERSONERIA.value="<cfoutput>#form.Filtro_Ppersoneria#</cfoutput>";
				document.lista.HFILTRO_PPERSONERIA.value="<cfoutput>#form.Filtro_Ppersoneria#</cfoutput>";					
			</cfif>
			<cfif isdefined("form.Filtro_Pid")>
				document.lista.FILTRO_PID.value="<cfoutput>#form.Filtro_Pid#</cfoutput>";
				document.lista.HFILTRO_PID.value="<cfoutput>#form.Filtro_Pid#</cfoutput>";
			</cfif>			
			<cfif isdefined("form.Filtro_nom_razon")>
				document.lista.FILTRO_NOM_RAZON.value="<cfoutput>#form.Filtro_nom_razon#</cfoutput>";
				document.lista.HFILTRO_NOM_RAZON.value="<cfoutput>#form.Filtro_nom_razon#</cfoutput>";
			</cfif>			
			<cfif isdefined("form.Filtro_Habilitado")>
				document.lista.FILTRO_HABILITADO.value="<cfoutput>#form.Filtro_Habilitado#</cfoutput>";
				document.lista.HFILTRO_HABILITADO.value="<cfoutput>#form.Filtro_Habilitado#</cfoutput>";
			</cfif>
			<cfif isdefined("form.tipo")>
				document.lista.TIPO.value = "<cfoutput>#form.tipo#</cfoutput>";
			</cfif>						

						
			document.lista.submit();					
			return true;
		}
	//-->
	</script>		
</cfoutput>
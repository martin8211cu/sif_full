<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DetalleDeLasAreasDeEvaluacion"
	Default="Detalle de las Areas de Evaluaci&oacute;n"
	returnvariable="LB_DetalleDeLasAreasDeEvaluacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha"
	Default="Fecha"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Fecha"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NotaMinima"
	Default="Nota Mínima"
	returnvariable="LB_NotaMinima"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Observaciones"
	Default="Observaciones"
	returnvariable="LB_Observaciones"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Filtrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Limpiar"
	Default="Limpiar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Limpiar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
    	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>


<cf_templatecss>
<link href="../css/rh.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>
<cfif isDefined("Url.RHEAid") and not isDefined("form.RHEAid")>
	<cfset form.RHEAid = Url.RHEAid>
</cfif>
<cfif isDefined("Url.usucodigo") and not isDefined("form.usucodigo")>
	<cfset form.usucodigo = Url.usucodigo>
</cfif>



<cfif isDefined("session.Ecodigo") and isDefined("Form.RHEAid") and len(trim(#Form.RHEAid#)) NEQ 0>
	<cf_translatedata name="get" tabla="RHEAreasEvaluacion" col="RHEAdescripcion" returnvariable="LvarRHEAdescripcionA">
	<cf_dbfunction name="spart" args="#LvarRHEAdescripcionA#°1°55" delimiters="°" returnvariable="LvarRHEAdescripcion">
	<cfquery name="rsRHEAreasEvaluacion" datasource="#Session.DSN#" >
		Select distinct substring(RHEAdescripcion,1,55) as RHEAdescripcion, RHEAcodigo, Usucodigo 
        from RHEAreasEvaluacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHEAid#">		  
		order by RHEAdescripcion asc
	</cfquery>
</cfif>
<cfif isDefined("session.Ecodigo") and isDefined("Form.RHDAlinea") and len(trim(#Form.RHDAlinea#)) NEQ 0>
	<cf_translatedata name="get" tabla="RHDAreasEvaluacion" col="RHDAdescripcion" returnvariable="LvarRHDAdescripcionA">
	<cf_dbfunction name="spart" args="#LvarRHDAdescripcionA#°1°55" delimiters="°" returnvariable="LvarRHDAdescripcion">

	<cfquery name="rsRHDAreasEvaluacion" datasource="#Session.DSN#" >
		Select substring(RHDAdescripcion,1,55) as RHDAdescripcion , RHDAnotamin, RHDAobs, RHDAfecha
		<cfif isDefined("request.usetranslatedata") and request.usetranslatedata>
			, RHDAobs_#session.idioma# as RHDAobs2
		</cfif>
        from RHDAreasEvaluacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHEAid#">		
		and RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHDAlinea#">
		order by RHDAdescripcion asc
	</cfquery>
</cfif>

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_DetalleDeLasAreasDeEvaluacion#'>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr bgcolor="#CCCCCC"><td colspan="2" align="center"><cfoutput><strong>#rsRHEAreasEvaluacion.RHEAcodigo#-#rsRHEAreasEvaluacion.RHEAdescripcion#</cfoutput></strong></td></tr>
			<tr>
				<td valign="top">
				  <cfinclude template="/rh/portlets/pNavegacion.cfm">				
				<cfoutput>
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr><td colspan="2" align="center"><table align="center" width="95%"><tr><td align="center">
					  <cfinclude template="/rh/portlets/pEmpleado.cfm"></td>
				  </tr></table></td></tr>	


		<tr>
		  <td>
		    <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
			    <tr>
				    <td valign="top" width="50%">
						<script language="JavaScript" src="/cfmx/rh/js/utilesMonto.js"></script>
					    <form style="margin:0" name="filtro" method="post">
						  <table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro">
							  <tr>
								  <td><strong>#LB_Descripcion#</strong></td>
								  <td align="center" nowrap><div align="center"><strong>#LB_NotaMinima#</strong></div></td>
							  </tr>
  
							<tr>
							    <td><input name="fRHDAdescripcion" type="text" size="60" maxlength="60" onFocus="this.select();" value="<cfif isdefined("form.fRHDAdescripcion")><cfoutput>#form.fRHDAdescripcion#</cfoutput></cfif>"></td>
							    <td align="center">
								   <input name="fRHDAnotamin" style="text-align:right" type="text" size="10" maxlength="5" onFocus="this.select();"  value="<cfif isdefined("form.fRHDAnotamin")><cfoutput>#form.fRHDAnotamin#</cfoutput></cfif>" onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}};">
							    </td>
						      </tr>
							  <tr>
								  <td colspan="2" align="center">
									  <input name="btnFiltrar" type="submit" value="#BTN_Filtrar#">
									  <input name="btnLimpiar" type="button" value="#BTN_Limpiar#" onClick="javascript:limpiar();">
									  <input name="RHDAcodigo" type="hidden"  value="<cfif isdefined("form.RHDAcodigo")>#form.RHDAcodigo#</cfif>">
									  <input name="RHEAid" type="hidden" value="#form.RHEAid#">
									  <input name="o" type="hidden" value="7">
									  <input name="sel" type="hidden" value="1">			
								  </td>
							  </tr>
						  </table>
					  		<input type="hidden"   id="usucodigo" name="usucodigo" value="<cfif isdefined("form.usucodigo") and len(trim(form.usucodigo)) NEQ 0>#form.usucodigo#<cfelseif isdefined("rsRHEAreasEvaluacion")>#rsRHEAreasEvaluacion.Usucodigo#</cfif>">
					    </form>
						</cfoutput>  
						<cfset filtro = "Ecodigo=#session.Ecodigo#" >
						<cfset navegacion = "">
						<cf_translatedata name="get" tabla="RHDAreasEvaluacion" col="RHDAdescripcion" returnvariable="LvarRHDAdescripcionA">
					   
						<cfif isdefined("form.fRHDAdescripcion") and len(trim(form.fRHDAdescripcion)) gt 0>
						    <cfset filtro = filtro & " and  upper(#LvarRHDAdescripcionA#) like '%" & Ucase(trim(form.fRHDAdescripcion)) & "%'">
							<cfset navegacion = navegacion & "&fRHDAdescripcion=#form.fRHDAdescripcion#">
					    </cfif>
						<cfif isdefined("form.fRHDAnotamin") and len(trim(form.fRHDAnotamin)) gt 0>
						    <cfset filtro = filtro & " and  RHDAnotamin <= " & form.fRHDAnotamin >
							<cfset navegacion = navegacion & "&fRHDAnotamin=#form.fRHDAnotamin#">
					    </cfif>
												  
						<cfset filtro = filtro & "and RHEAid = #form.RHEAid# order by RHDAdescripcion ">
						  
						<cfinvoke 
							component="rh.Componentes.pListas"
							method="pListaRH"
							returnvariable="pListaDed">
							    <cfinvokeargument name="tabla" value="RHDAreasEvaluacion"/>
							    <cfinvokeargument name="columnas" value="RHDAlinea , RHEAid, substring(#LvarRHDAdescripcionA#,1,35) as RHDAdescripcion,  RHDAnotamin, 7 as o, 1 as sel"/>
							    <cfinvokeargument name="desplegar" value="RHDAdescripcion, RHDAnotamin"/>
							    <cfinvokeargument name="etiquetas" value="#LB_Descripcion#, #LB_NotaMinima#"/>
							    <cfinvokeargument name="formatos" value=" V, M "/>
							    <cfinvokeargument name="filtro" value="#filtro#"/>
							    <cfinvokeargument name="align" value="left,right"/>
							    <cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="debug" value="N"/>
							    <cfinvokeargument name="irA" value="AreasEvaluacionDetalle.cfm"/>			
 							    <cfinvokeargument name="navegacion" value="#navegacion#"/>
							    <cfinvokeargument name="keys" value="RHDAlinea"/>
								<cfinvokeargument name="showEmptyListMsg" value= "1"/>
							    
					    </cfinvoke>		
				    </td>
						  
					<cfset action = "AreasEvaluacionDetalle-SQL.cfm"> 
				    <td width="1%">&nbsp;</td>
				  <td width="50%" valign="top">
					<input type="hidden"   id="RHEAid" name="RHEAid" value="<cfif isdefined("form.RHEAid")><cfoutput>#form.RHEAid#</cfoutput></cfif>">
					<input type="hidden"   id="RHDAlinea" name="RHDAlinea" value="<cfif isdefined("form.RHDAlinea")><cfoutput>#form.RHDAlinea#</cfoutput></cfif>">
					
                    <cfinclude template="AreasEvaluacionDetalle-form.cfm">
</td>
			    </tr>																									  
		    </table>
		  </td>																									  
	  </tr>  		
                    </table>
				</td>	
			</tr>
		</table>	
		<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form="filtro">
<SCRIPT LANGUAGE="JavaScript">
<!--
	function limpiar(){
	document.filtro.fRHDAdescripcion.value= '';
	document.filtro.fRHDAnotamin.value = '';
	}


//-->
</SCRIPT>
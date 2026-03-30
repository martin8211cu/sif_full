<!--- Verifica que todos los campos que tienen que llegar por el form existan --->
<cfif 	isdefined("form.IDgd") and form.IDgd neq ""
	and isdefined("form.IDdistribucion") and form.IDdistribucion neq ""
	and isdefined("form.Periodo") and form.Periodo neq ""
	and isdefined("form.Mes") and form.Mes neq "">
	
	<cfset LvarSimular="N">
	<cfset LvarExcel="N">	
	<cfif isdefined("form.Simular") and form.Simular eq "S">
		<cfset LvarSimular="S">	
	</cfif>	
	<cfif isdefined("form.chkSimular") and form.chkSimular eq 1
  	  and isdefined("form.Simular") and form.Simular eq "S">
		<cfset LvarExcel="S">
	</cfif>

	<cfinvoke 
		 component="sif.Componentes.CG_DistribucionConductores"
		 method="CG_Distribucion"
		 returnvariable="LvarMSG">
	
		<cfinvokeargument name="Idgrp"		    value="#form.IDgd#"/>
		<cfinvokeargument name="IDdistribucion" value="#form.IDdistribucion#"/>
		<cfinvokeargument name="CGCperiodo"     value="#form.Periodo#"/>
		<cfinvokeargument name="CGCmes"         value="#form.Mes#"/>
		<cfinvokeargument name="Ecodigo"        value="#Session.Ecodigo#"/>
		<cfinvokeargument name="Simular" 		value="#LvarSimular#"/>	
		<cfinvokeargument name="BajarExc" 		value="#LvarExcel#"/>	
	</cfinvoke>

	<cfif LvarSimular eq "N">
	
		<cfoutput>#LvarMSG#</cfoutput>
		<cf_template template="#session.sitio.template#">
			<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
		
			<cf_templatearea name="title">
				Distribucion de Cuentas
			</cf_templatearea>
			
			<cf_templatearea name="body">
		
		<cf_templatecss>
		<link href="../../css/rh.css" rel="stylesheet" type="text/css">
		
			<cf_web_portlet skin="#Session.Preferences.Skin#" titulo="Distribuciones">
			
			
				<center>
				<br>
				<cfoutput>
				<cfif isdefined("LvarMSG") and LvarMSG neq "">
				
					<cfif not isdefined("NomGrupo")>

						<cfset NomGrupo = "">
						<cfquery name="rsGrp" datasource="#session.dsn#">
							Select DCdescripcion 
							from DCGDistribucion 
							where IDgd = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDgd#">
						</cfquery>						
						<cfset NomGrupo = rsGrp.DCdescripcion>
						
					</cfif>
				
					El Proceso de Distribución para el grupo: <strong>#NomGrupo#</strong> del Periodo: <strong>#form.periodo#</strong>, Mes: <strong>#form.mes#</strong> se ha realizado exitosamente.
					<br>El asiento correspondiente a la distribucion es: <strong>#LvarMSG#</strong>
				
				<cfelse>
		
					No fue posible realizar el proceso de Distribución del Periodo: <strong>#form.periodo#</strong>, 
					Mes: <strong>#form.mes#</strong>, ya que el asiento contable presentó errores a la hora de generarse.
							
				</cfif>
				</cfoutput>		
				<br><br>
				<form action="/cfmx/sif/dc/catalogos/formgrupos.cfm" method="post" name="sql">
					<cfif isdefined("showMessage")>
						<input name="showMessage" type="hidden" value="true">
					</cfif>
					<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">
					<input type="submit" name="btncerrar" value="Regresar">
				</form>
				</center>
			
			</cf_web_portlet>
		
		</cf_templatearea>
		</cf_template>
	
	
	</cfif>


<cfelse>
	<cf_errorCode	code = "50366" msg = "Imposible generar el proceso de distribución por conductores, ya que los parámetro necesario no fueron suplidos">
</cfif>


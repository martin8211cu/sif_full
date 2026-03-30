<cfparam name="form.PAcodigo" default="">
<cfif form.PAcodigo EQ "" OR isdefined("form.btnLista") and form.btnLista NEQ "">
  <cfset NoTabs=true>
<cfelse>
  <cfset NoTabs=false>
  <cfquery name="qryPaquete" datasource="#session.DSN#">
    select PAcod, PAdescripcion
	  from Paquete
	 where PAcodigo = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#form.PAcodigo#">
  </cfquery>
  <br>
  <cfoutput> <strong><font size="2" style=""> Paquete: #qryPaquete.PAcod#: #qryPaquete.PAdescripcion# </font> </strong> </cfoutput> 
  <br>
  <br>
</cfif>
<cfinvoke 
 component="aspAdmin.Componentes.pTabs"
 method="fnTabsInclude">
	<cfinvokeargument name="pTabID" value="TabIDpaquete"/>
	<cfinvokeargument name="pTabs" value=#
		  "|Paquete,paquete_list.cfm,Trabajar con los datos del paquete"
		& "|Modulos,paqueteModulos_list.cfm,Definir los módulos del paquete"
		& "|Tarifas,paqueteTarifas.cfm,Definir las tarifas del paquete"
	#/> 
	<cfinvokeargument name="pDatos" value="PAcodigo=#form.PAcodigo#"/>
	<cfinvokeargument name="pNoTabs" value="#NoTabs#"/>
	<cfinvokeargument name="pWidth" value="100%"/>
</cfinvoke>

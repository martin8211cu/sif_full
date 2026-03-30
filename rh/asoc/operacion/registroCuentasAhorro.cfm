<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nav__SPdescripcion" Default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cfinclude template="registroCuentasAhorro-translate.cfm">
<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
		<cfif isdefined("url.ACAAid") and len(trim(url.ACAAid)) GT 0>
			<cfset form.ACAAid = url.ACAAid>
		</cfif>
		<cfif 	(isdefined("form.ACAAid") and len(trim(form.ACAAid)) GT 0)>
        	<cf_tabs width="100%">
            <cf_tab text="<cfoutput>#LB_Registro_de_Cuenta_de_Aportes#</cfoutput>" id="1">
            	<cfinclude template="registroCuentasAhorro-formcambio.cfm">
                <cfinclude template="registroCuentasAhorro-listaSaldos.cfm">
            </cf_tab>
            </cf_tabs>
        <cfelseif (isdefined("form.btnNuevo")) or 
				(isdefined("form.Nuevo")) or 
				(isdefined("form.Paso"))>
            <cfparam name="Form.Paso" default="1">
			<cf_tabs width="100%">
            <cf_tab text="<cfoutput>#LB_Registro_de_Cuenta_de_Aportes#</cfoutput>" id="1">
            	<cfinclude template="registroCuentasAhorro-formPaso#Form.Paso#.cfm">
            </cf_tab>
            </cf_tabs>
		<cfelseif isdefined('form.btnImportar')>
			<cfinclude template="registroCuentasAhorro-Importar.cfm">
        <cfelse>
            <cfinclude template="registroCuentasAhorro-listaCuentas.cfm">
        </cfif>
	<cf_web_portlet_end>
<cf_templatefooter>
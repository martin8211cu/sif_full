<cfif isdefined('url.importa') and url.importa EQ 'true'>
	<cf_templateheader title=" Importaci&oacute;n de Centros Funcionales">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importaci&oacute;n De Centros Funcionales">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td align="center" valign="top" width="55%">
						<cf_sifFormatoArchivoImpr EIcodigo = 'CFIMPORTADOR'>
					</td>
					<td align="center" style="padding-left: 15px " valign="top">
						<cf_sifimportar EIcodigo="CFIMPORTADOR" mode="in">
						</cf_sifimportar>
						<cf_botones exclude="Alta,Limpiar" regresar="CFuncional-lista.cfm" tabindex="1">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>
	<cfabort>
</cfif>
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_ModuloIndicadores"
Default="Modulo Indicadores"
XmlFile="/rh/generales.xml"
returnvariable="LB_ModuloIndicadores"/>
<cf_templateheader title="#LB_ModuloIndicadores#">
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
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

<!--- 	JGR [04/01/2006]
		Variable para saber si esta en la empresa corporativa 
--->
<cfset es_corporativo = false >
<cfset vEcodigoCorp = 0 >
<cfquery name="rsCorporativa" datasource="asp">
	select coalesce(e.Ereferencia, 0) as Ecorporativa
	from CuentaEmpresarial c
		join Empresa e
		on e.Ecodigo = c.Ecorporativa
	where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>
<cfif rsCorporativa.recordcount gt 0 and len(trim(rsCorporativa.Ecorporativa))>
	<cfset vEcodigoCorp = rsCorporativa.Ecorporativa >
</cfif>

<cfif vEcodigoCorp eq session.Ecodigo >
	<cfset es_corporativo = true >
</cfif>

<cfinclude template="../Utiles/params.cfm">

<cfquery name="validaPresupuesto" datasource="#session.DSN#">
	select Pvalor 
	from RHParametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and Pcodigo=540
</cfquery>

<!--- ================================================================ --->
<!--- JGR [04/02/2006]
	  Necesito saber si la empresa ya tiene un CF raiz, ya no se puede
	  preguntar si el CFidresp es nulo, pues podria no serlo. Entonces
	  se cambio el query para preguntar por el nivel y el path. 
	  Se SUPONE que el nivel de la raiz es 0 y que su path es RAIZ,
	  entonces el query pregunta por estos campos.
--->
<!--- Query viejo
<cfquery name="rsCFraiz" datasource="#Session.DSN#">
	select CFid 
	from CFuncional 
	where Ecodigo=#session.Ecodigo# 
	  and CFidresp is null
</cfquery>
--->
<cfquery name="rsCFraiz" datasource="#Session.DSN#">
	select CFid 
	from CFuncional 
	where Ecodigo=#session.Ecodigo# 
		and CFnivel = 0
		and CFpath = 'RAIZ'
</cfquery>
<!--- ================================================================ --->

<cfif rsCFraiz.recordCount NEQ 1>
	<cftransaction>
	<cfquery name="rsDpto" datasource="#Session.DSN#">
			select min(Dcodigo) as id from Departamentos where Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfquery name="rsOfic" datasource="#Session.DSN#">
			select min(Ocodigo) as id from Oficinas where Ecodigo=#session.Ecodigo#
	</cfquery>

	<cfquery datasource="#Session.DSN#">
		insert into CFuncional (
			Ecodigo,
			CFcodigo,
			Dcodigo,
			Ocodigo,
			CFdescripcion,
			CFpath,
			CFnivel,
			CFcorporativo )
		values (
			#session.Ecodigo#,
			'RAIZ',
			#rsDpto.id#,
			#rsOfic.id#,
			'Centro Funcional Raiz',
			'RAIZ',
			0,
			<cfif es_corporativo >1<cfelse>0</cfif> )
	</cfquery>
	<cfquery name="rsCFraiz" datasource="#Session.DSN#">
		select CFid from CFuncional where Ecodigo=#session.Ecodigo# and CFcodigo='RAIZ'
	</cfquery>
	<cfif rsCFraiz.recordCount NEQ 0>
		<cfquery datasource="#Session.DSN#">
			update CFuncional
			   set CFpath = {fn concat( 'RAIZ/'  , CFpath)},
				   CFnivel = CFnivel + 1,
				   CFidresp = coalesce(CFidresp,#rsCFraiz.CFid#)
			 where Ecodigo=#session.Ecodigo#
			   and CFcodigo <> 'RAIZ'
		</cfquery>
	</cfif>
	</cftransaction>
</cfif>

<!--- Puede darse el caso donde cambien la empresa corporativa.
	  Esto puede ocasionar que el CF Raiz de la nueva empresa
	  corporativa no este marcado como corporativo y la idea de estos 
	  cambios es que la raiz del CF corporativo sea SIEMPRE corporativo.
	  Por eso se hace este proceso:
		1. Se pone como corporativo el CF raiz de la empresda corporativa.
		2. Se ponen como no corporativos todos los CF's que no son de la empresa corporativa
 --->
<cfif isdefined("vEcodigoCorp") and len(trim(vEcodigoCorp)) >
	<!--- 1. Se pone como corporativo el CF raiz de la empresda corporativa --->
	<cfquery datasource="#session.DSN#">
		update CFuncional
		set CFcorporativo = 1
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vEcodigoCorp#">
	      and CFcodigo = 'RAIZ'
	</cfquery>

	<!--- 2. Se ponen como no corporativos todos los CF's que no son de la empresa corporativa --->
	<cfquery datasource="#session.DSN#">
		update CFuncional
		set CFcorporativo = 0
		where Ecodigo != <cfqueryparam cfsqltype="cf_sql_integer" value="#vEcodigoCorp#">
		  and CFcorporativo = 1
	</cfquery>
</cfif>

	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
	<cfset RequeCf = true>
	<table width="100%" cellpadding="2" cellspacing="0">
      <tr>
        <td valign="top"><script language="JavaScript1.2" type="text/javascript">
					function limpiar(){
						document.filtro.fRHPcodigo.value = "";
						document.filtro.fRHPdescripcion.value   = "";
					}
				</script>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_CentrosFuncionales"
				Default="Centros Funcionales"
				returnvariable="LB_CentrosFuncionales"/>

            <cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_CentrosFuncionales#">
              <!--- variables para el portlet de navegación --->
              <cfset regresar = "/cfmx/rh/indexEstructura.cfm">
              <cfset navBarItems = ArrayNew(1)>
              <cfset navBarLinks = ArrayNew(1)>
              <cfset navBarStatusText = ArrayNew(1)>
              <cfset navBarItems[1] = "Estructura Organizacional">
              <cfset navBarLinks[1] = "/cfmx/rh/indexEstructura.cfm">
              <cfset navBarStatusText[1] = "/cfmx/rh/indexEstructura.cfm">
              <cfinclude template="/mig/portlets/pNavegacion.cfm">
              
			 	<!--- ******************************************************************** --->
			  

			  
			  
			  <cfif not isdefined("form.tab") and isdefined("url.tab") and not isdefined("form.tab")>
                <cfset form.tab = url.tab >
              </cfif>
			  <cfif not ( isdefined("form.tab") and ListContains('1,2,3', form.tab) )>
                <cfset form.tab = 1 >
              </cfif>
              <cfif  isdefined("url.CFpk") and len(trim(url.CFpk))NEQ 0>
                <cfset form.CFpk = url.CFpk>
              </cfif>
			  
              <cfif not isdefined("form.nuevo") and not isdefined("form.BTNNUEVO")>
					<cfif  isdefined("form.CFpk") and len(trim(form.CFpk))NEQ 0>
						<cfset modo = "Cambio">
					 </cfif>
			  <cfelse>
                	<cfset modo = "Alta">     
			  </cfif>
			  
			  <!--- <cfif  isdefined("form.CFpk") and len(trim(form.CFpk))NEQ 0>
                <cfset modo = "Cambio">
               <cfelse>
                <cfset modo = "Alta">
              </cfif> --->
			
			  
			<cf_tabs width="99%">
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_DatosGenerales"
				Default="Datos Generales"
				returnvariable="LB_DatosGenerales"/>
				
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Cuentas"
				Default="Cuentas"
				returnvariable="LB_Cuentas"/>
				
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_PlazasPorCentroFuncional"
				Default="Plazas por Centro Funcional"
				returnvariable="LB_PlazasPorCentroFuncional"/>				
								
				<cf_tab text="#LB_DatosGenerales#" selected="#form.tab eq 1#">


					<cf_web_portlet_start border="true" titulo="#LB_DatosGenerales#" >
						<cfinclude template="CFuncional-tab1.cfm">
					<cf_web_portlet_end>
				</cf_tab>
				
				<!---<cfif modo NEQ "Alta">
					
					<cf_tab text="#LB_Cuentas#" selected="#form.tab eq 2#">

						<cf_web_portlet_start border="true" titulo="#LB_Cuentas#">
							<cfinclude template="CFuncional-tab2.cfm">
						<cf_web_portlet_end>
					</cf_tab>
					
					<cfif not (validaPresupuesto.recordcount gt 0 and trim(validaPresupuesto.Pvalor) eq 1) >
						<cf_tab text="#LB_PlazasPorCentroFuncional#" selected="#form.tab eq 3#">
							
							<cf_web_portlet_start border="true" titulo="#LB_PlazasPorCentroFuncional#">
								  <cfinclude template="CFuncional-tab3.cfm">
							<cf_web_portlet_end>
						</cf_tab>
					</cfif>
				
				</cfif>--->
			</cf_tabs>
			
              <!--- ******************************************************************** --->
			  
            <cf_web_portlet_end>
        </td>
      </tr>
    </table>
	
<cf_templatefooter>

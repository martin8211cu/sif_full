<cfparam name="modo" 	 	  	 		 default="ALTA">
<cfparam name="modoDet" 	 	    	 default="ALTA">
<cfparam name="Param" 			    	 default="">
<cfparam name="MostrarValoreLista" 	 default="FALSE">

<cfparam name="ETE.TEVECodigo" 	 	default="">
<cfparam name="ETE.TEVEDescripcion"	default="">
<cfparam name="ETE.TEVEdefault" 	 	default="">
<cfparam name="ETE.TEVENotifica"		default="">

<cfparam name="TE.TEVcodigo" 	 		default="">
<cfparam name="TE.TEVDescripcion" 	default="">



<cfif (isdefined('form.TEVid') and len(trim(form.TEVid)) GT 0) or (isdefined('url.TEVid') and len(trim(url.TEVid)))>
	<cfset modo = "CAMBIO">
	<cfif not isdefined('form.TEVid') or len(trim(form.TEVid)) EQ 0>
		<cfset form.TEVid = url.TEVid>
	</cfif>
</cfif>

<cf_templateheader title="Tipos de Eventos">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Tipos de Eventos">
					<cfif (isdefined('form.TEVid') and len(trim(form.TEVid))) OR (isdefined('form.btnNuevo')) OR (isdefined('url.Nuevo'))or (isdefined('form.Nuevo')or isdefined('url.TEVid')) 
					or (isdefined('form.TidEV') and len(trim(form.TidEV))) and (isdefined('form.CodigoTEVE') and len(trim(form.CodigoTEVE)))>
						
						<cfif isdefined ('url.CodigoTEVE')>
							<cfset CodigoTEVE = #url.CodigoTEVE#>
						</cfif>
						<cfinclude  template="TiposEventos-form.cfm">
					<cfelse>
						<cfinclude  template="TiposEventos-lista.cfm">
					</cfif>
		<cf_web_portlet_end>
<cf_templatefooter>



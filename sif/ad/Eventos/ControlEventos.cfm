<cfset modo = 'ALTA'>
<cfset modificable = 'true'>
<cfset readOnly = 'false'>
<cfset rsEvento = QueryNew('CEVDescripcion,FechaEvento,HoraEvento,TEVid')>
<cfparam name="url.tab" default="1">

<cfif not isdefined('URl.CEVid') and isdefined('form.CEVid')>
	<cfset URL.CEVid = FORM.CEVid>
</cfif>

<cfif isdefined('URl.CEVid') and len(trim(CEVid))>
	<cfset modo = 'CAMBIO'>
	<cfset modificable = 'false'>
	<cfset readOnly = 'true'>
</cfif>

<cfinvoke component="sif.Componentes.ControlEventos" method="GET_EVENTO" returnvariable="rsEvento">
	<cfif modo EQ 'CAMBIO'>
		<cfinvokeargument name="CEVid" value="#URl.CEVid#">
	</cfif>
</cfinvoke>

<!---Configuracion para Activos Fijos--->
<cfif TipoEvento EQ 'AF'>
	<cfset labelKey = 'Activo Fijo'>
	<cfset PaginaInicial = '/cfmx/sif/af/operacion/ControlEventos_AF.cfm'>	
	<cfset CurrentPage   = 'ControlEventos_AF.cfm'>
	<cfif Modo EQ 'CAMBIO'>
		<cfquery name="rsActivo" datasource="#session.dsn#">
			select Aid CEVidTabla, Aplaca, Adescripcion from Activos where Aid = #rsEvento.CEVidTabla#
		</cfquery>
	<cfelse>
		<cfset rsActivo = QueryNew('Aid')>
	</cfif>

	<cfsavecontent variable="inputKey">
		<cf_sifactivo name="CEVidTabla" placa="Aplaca" desc="Adescripcion" tabindex="1" form= "form1" funcion ="TraerTiposEventos" fparams="CEVidTabla" modificable = "#modificable#" query="#rsActivo#">
	</cfsavecontent>
	
<!---Aqui van otras Configuraciones--->											
<cfelse>
	ERROR Tipo de Evento no Implementado<cfabort>
</cfif>
<cf_templateheader title="Control de Eventos">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Control de Eventos">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"> 
				<tr>
					<cfif modo EQ 'ALTA' and not isdefined('URL.Nuevo')>
						<td valign="top">
							<cfinclude  template="ControlEventos-lista.cfm">
						</td>
					<cfelse>
						<td align="center">
							<cfinclude  template="ControlEventos-form.cfm">
					    </td>
					</cfif>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>
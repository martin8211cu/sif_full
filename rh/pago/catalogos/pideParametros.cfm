<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		<cf_translate key="LB_RecursosHumanos" XmlFile="/rh/generales.xml">Recursos Humanos</cf_translate>
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

<cfquery name="dataImportador" datasource="sifcontrol">
	select b.EIcodigo, a.DInombre, a.DIdescripcion, a.DItipo
	from DImportador a 
	
	inner join EImportador b
	on a.EIid=b.EIid
	and a.EIid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#">
	
	where a.DInumero < 0
</cfquery>

<cfquery name="data" datasource="sifcontrol">
	select EIdescripcion 
	from EImportador 
	where EIid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#">
</cfquery>

<cfoutput>

<cfset continuar = true >

<script language="JavaScript">
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}
</script>

<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ExportacionDeInformacionDePlanillaParametrosRequeridos"
	Default="Exportaci&oacute;n de Informaci&oacute;n de Planilla: Par&aacute;metros Requeridos"
	returnvariable="LB_ExportacionDeInformacionDePlanillaParametrosRequeridos"/>
	
<cf_web_portlet_start border="true" titulo="#LB_ExportacionDeInformacionDePlanillaParametrosRequeridos#" skin="#Session.Preferences.Skin#">
<cfinclude template="/rh/portlets/pNavegacion.cfm">
<table width="100%" cellpadding="4" cellspacing="0">
	<tr>
		<td width="50%" valign="top">
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_ExportaciónParametrosRequerido"
				Default="Exportación: Par&aacute;metros Requerido"
				returnvariable="LB_ExportaciónParametrosRequerido"/>
			<cf_web_portlet_start border="true" titulo="LB_ExportaciónParametrosRequerido" skin="info1">
				<table width="100%">
					<tr>
						<td>
							<p>
								<cf_translate key="EstaPantallaCapturaLosDatosAdicionalesYRequeridosPorLaExportacion">
								Esta pantalla captura los datos adicionales y requeridos por la exportaci&oacute;n.  
								Cuando haya digitado los datos presione la opción <strong>Continuar</strong> 
								para seguir con el proceso de exportación.
								</cf_translate>
							</p>
						</td>
					</tr>
				</table>
			<cf_web_portlet_end>
		</td>

		<td>
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr><td colspan="2" align="center">#data.EIdescripcion#</td></tr>
				<form name="form1" method="post" action="Exportar.cfm">
                	<input type="hidden" name="vEstado" id="vEstado" value="#form.estado#">
					<cfloop collection ="#form#" item = "i">
						<input type="hidden" name="#i#" value="#form[i]#">
					</cfloop>
					<cfloop query="dataImportador">
						<cfif not isdefined("form.#trim(dataImportador.DInombre)#") and FindNocase('ECODIGO',dataImportador.DInombre,0) eq 0 >
							<cfset continuar = false >
							<tr>
								<td width="45%" align="right" style="text-transform:capitalize;"><strong>#dataImportador.DIdescripcion#:&nbsp;</strong></td>
								<td>
									<input type="text" name="#dataImportador.DInombre#" size="10" maxlength="10" value="" 
										alt="#dataImportador.DIdescripcion#" <cfif trim(dataImportador.DItipo) neq 'varchar' and trim(dataImportador.DItipo) neq 'datetime' >
										style="text-align: right;" 
										onBlur="javascript:fm(this,0); "  
										onFocus="javascript:this.value=qf(this); this.select();"  
										onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"</cfif> >
									<input name="parametros" type="hidden" value="#trim(dataImportador.DInombre)#" >
								</td>
							</tr>
						</cfif>
					</cfloop>
					<cfif not continuar >
						<tr>
							<td colspan="2" align="center">
								<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="BTN_Continuar"
									Default="Continuar"
									XmlFile="/rh/generales.xml"
									returnvariable="BTN_Continuar"/>

								<input type="submit" name="Continuar" value="#BTN_Continuar# >>" onClick="return validar();">
							</td>
						</tr>
					</cfif>	
					
				</form>
			</table>
		</td>		
	</tr>
</table>

<cf_web_portlet_end>

<cfif continuar >
	<script type="text/javascript" language="javascript1.2">
		document.form1.submit();
	</script>
<cfelse>
	<script language="JavaScript">
		function validar(){
			var error = false;
			var mensaje = 'Se presentaron los siguientes errores:\n'
			if ( document.form1.parametros.value ){
				var name = document.form1.parametros.value;
				if ( trim(document.form1[name].value) == '' ){
					error = true;
					mensaje += ' - El campo ' + document.form1[name].alt + ' es requerido.\n';
				}
			}
			else{
				for ( var i=0; i<document.form1.parametros.length; i++ ){
					var name = document.form1.parametros[i].value;
					if ( trim(document.form1[name].value) == '' ){
						error = true;
						mensaje += ' - El campo ' + document.form1[name].alt + ' es requerido.\n';
					}
				}
			}
			
			if ( error ){
				alert(mensaje);
				return false;
			}
			else{
				return true;
			}
			
		}
	</script>
</cfif>	

</cfoutput>

	</cf_templatearea>
</cf_template>
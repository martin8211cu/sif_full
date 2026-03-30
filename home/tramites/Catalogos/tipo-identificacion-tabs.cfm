<cfparam name="url.tab" default="1">
<cfif NOT ListContains('1,2,3,4', url.tab )>
  <cfset url.tab = 1 >
</cfif>
<cfparam name="url.id_tipoident" default="">

f
<cf_template>
  <cf_templatearea name="title"> Tramites Personales </cf_templatearea>
  <cf_templatearea name="body">
    <cf_templatecss>
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Tipos de Identificaci&oacute;n'>
      <table width="100%" border="0" cellspacing="1" cellpadding="0">
        <tr>
          <td valign="top"><cfinclude template="../../../sif/portlets/pNavegacion.cfm">
          </td>
        </tr>
        <tr>
          <td valign="top"><cfif len(url.id_tipoident)>
              <cfquery datasource="#session.tramites.dsn#" name="hdr">
				  select codigo_tipoident, nombre_tipoident, id_tipo, id_vista_ventanilla
				  from TPTipoIdent
				  where id_tipoident = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tipoident#">
              </cfquery>
              <cfoutput>
                <table width="100%" cellpadding="5" cellspacing="0" bgcolor="##CCCCCC" border="0" style="border:1px solid black">
                  <tr>
                    <td align="center" valign="middle"><font size="3" color="##003399"> <strong>Tipo de Identificaci&oacute;n:&nbsp;#trim(hdr.codigo_tipoident)# - #hdr.nombre_tipoident#</strong></font></td>
                  </tr>
                </table>
              </cfoutput>
            </cfif>
          </td>
        </tr>
        <tr>
          <td valign="top"><cf_tabs width="100%">
              <cf_tab text="Datos Generales" id="1" selected="#url.tab eq 1#">
                <cfif url.tab eq 1>
                  <cfinclude template="tipo-identificacion-form.cfm">
                </cfif>
              </cf_tab>
              <cfif len(url.id_tipoident)>
                <cf_tab text="Información del Expediente" id="2" selected="#url.tab eq 2#">
                  <cfif url.tab eq 2>
                    <cfinclude template="tipo-identificacion-dato.cfm">
                  </cfif>
                </cf_tab>
                <cf_tab text="Registro en ventanilla" id="4" selected="#url.tab eq 4#">
                  <cfif url.tab eq 4>
				  <cfoutput>
                    <iframe width="950" height="1000" src="vista/vistaDetalle_form2.cfm?id_vista=#URLEncodedFormat(hdr.id_vista_ventanilla)#&amp;es_requisito=1" frameborder="0"> </iframe>
					</cfoutput>
                  </cfif>
                </cf_tab>
                <cf_tab text="Seguridad" id="3" selected="#url.tab eq 3#">
                  <cfif url.tab eq 3>
                    <cfset items = "">
                    <cfset items = ListAppend(items, "GEN-Datos Generales")>
                    <cfset items = ListAppend(items, "VYC-Validación y Cumplimiento")>
                    <cfset items = ListAppend(items, "TXT-Información adicional")>
                    <cfset items = ListAppend(items, "DOC-Documentación adjunta")>
                    <cfset items = ListAppend(items, "PAG-Pagos")>
                    <!--- C de Cédula, porque la T y la I estan ocupados por tipo institucion e institución --->
                    <cf_permisos tipo_objeto="C" id_objeto="#url.id_tipoident#"
										items="#items#">
                  </cfif>
                </cf_tab>
              </cfif>
            </cf_tabs>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
      </table>
      <script language="javascript" type="text/javascript">
<!--
function limpiar(){
	document.filtro.fcodigo_tipoident.value = ' ';
	document.filtro.fnombre_tipoident.value = ' ';
}
function tab_set_current(n){
	location.href='tipo-identificacion-tabs.cfm?id_tipoident=<cfoutput>#JSStringFormat(URLEncodedFormat(url.id_tipoident))#</cfoutput>&tab='+escape(n);
}
//-->
</script>
    <cf_web_portlet_end>
  </cf_templatearea>
</cf_template>

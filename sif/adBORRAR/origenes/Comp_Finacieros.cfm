
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_SIFAdministracionDelSistema"
Default="SIF - Administraci&oacute;n del Sistema"
XmlFile="/sif/generales.xml"
returnvariable="LB_SIFAdministracionDelSistema"/>
<cf_templateheader title="#LB_SIFAdministracionDelSistema#">
	
<style type="text/css">
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	
	.iframe {
		border-bottom-style: nome;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
	}
</style>
	
		<table width="100%" cellpadding="0" cellspacing="0"><tr><td>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Registro de Complementos Finacieros">
			<cfinclude template="../../portlets/pNavegacionAD.cfm">
			
			<cfquery name="RSTablas" datasource="#Session.DSN#">
				select distinct OPtabla  as  Tabla from OrigenNivelProv
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> 
				union
				select distinct OPtablaMayor as Tabla from OrigenDocumentos
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				order by Tabla 
			</cfquery>

<!--- QUITAR --->
<!---
<cfquery name="RSTablas" datasource="#Session.DSN#">
	select OPtabla as tabla  from sif_control..OrigenTablaProv
</cfquery>
--->

			<cfoutput>
			<table width="99%" align="center"  border="0" cellspacing="1" cellpadding="0">
			<tr>
			<td  valign="top" width="50%">
				<cf_web_portlet_start border="true" titulo="Indique el complemento financiero" skin="info1">
				<form name="form2"  action="Comp_Finacieros.cfm" method="post" onSubmit="javascript:return validar(this);">
			      <table width="100%"  border="0" cellspacing="0" cellpadding="2">
                    <tr>
                      <td width="30%" align="right" >C&aacute;talogo:&nbsp;</td>
                      <td width="70%" ><select name="OPtabla_F" onChange="javascript:asignar(this.value);" >
                          <option value="">- seleccionar -</option>
						  <cfloop query="RSTablas">
                            <option <cfif isdefined("Form.OPtabla_F") and trim(Form.OPtabla_F) eq trim(RSTablas.Tabla)>selected</cfif> value="#RSTablas.Tabla#">#RSTablas.Tabla#</option>
                          </cfloop>
                        </select>
                      </td>
                    </tr>

					<!--- 
                    <tr>
                      <td  align="right" >N&uacute;mero C&oacute;digo:&nbsp;</td>
                      <td><input type="text" name="ODchar_F" size="30" maxlength="30" value="<cfif isdefined("Form.ODchar_F")>#Form.ODchar_F#</cfif>"></td>
                    </tr>
					--->	
                    <tr>
                      <td align="right" valign="middle" >N&uacute;mero C&oacute;digo:&nbsp;</td>
                      <!---<td><iframe name="fr" id="fr" src="" width="100%" height="30" frameborder="0" scrolling="yes"></iframe></td>--->
					   <td>
						<cfif isdefined("form.OPtabla_F") and len(trim(form.OPtabla_F))>
							<cfquery name="data" datasource="sifcontrol">
								select rutatag
								from OrigenTablaProv
								where OPtabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OPtabla_F#">
							</cfquery>
								<cfif compareNocase('rhcfuncional', data.rutatag) eq 0>
									<cf_rhcfuncional form="form2" id="ODchar_F" >
								<cfelseif compareNocase('sifalmacen', data.rutatag) eq 0>
										<cf_sifalmacen form="form2" Aid="ODchar_F">
								<cfelseif compareNocase('sifarticulos', data.rutatag) eq 0>
										<cf_sifarticulos form="form2" id="ODchar_F">
								<cfelseif compareNocase('sifmonedas', data.rutatag) eq 0>
										<cf_sifmonedas form="form2" Mcodigo="ODchar_F">
								<cfelseif compareNocase('sifsociosnegocios2', data.rutatag) eq 0>
									<cf_sifsociosnegocios2 form="form2" SNcodigo="ODchar_F">
								<cfelseif compareNocase('sifactivo', data.rutatag) eq 0>
									<cf_sifactivo form="form2" name="ODchar_F" >
								<cfelseif compareNocase('sifoficinas', data.rutatag) eq 0>
									<cf_sifoficinas form="form2" Ocodigo="ODchar_F">
								<cfelseif compareNocase('sifconceptos', data.rutatag) eq 0>
									<cf_sifconceptos form="form2" id="ODchar_F" >
								<cfelseif compareNocase('siftransaccionescc', data.rutatag) eq 0>
									<cf_siftransaccionescc form="form2" CCTcodigo="ODchar_F">
								<cfelseif compareNocase('siftransaccionescp', data.rutatag) eq 0>
									<cf_siftransaccionescp form="form2" CPTcodigo="ODchar_F">
								<cfelseif compareNocase('sifbancos', data.rutatag) eq 0>
									<cf_sifbancos form="form2" Bid="ODchar_F">
								<cfelseif compareNocase('siftransaccionesmb', data.rutatag) eq 0>
									<cf_siftransaccionesmb form="form2" BTid="ODchar_F">
								<cfelse>
									<input type="text" name="ODchar_F" size="30" maxlength="30" value="<cfif isdefined("Form.ODchar_F")>#Form.ODchar_F#</cfif>">
								</cfif>
						</cfif>    
						</td>	                
					</tr>

                    <tr>
                      <td   align="center" colspan="2"><input type="submit" name="Procesar" value="Buscar"></td>
                    </tr>
                  </table>
				</form>
				<cf_web_portlet_end>
			</td> </tr><tr>
			<td  valign="top" width="50%">
					<cf_web_portlet_start border="true" titulo="Informaci&oacute;n del complemento financiero" skin="#Session.Preferences.Skin#">
			<cfif isdefined("Form.ODchar_F") and isdefined("Form.OPtabla_F") and len(trim(Form.ODchar_F))>
					<cfinclude template="MantComp_Finacieros.cfm">
			<cfelse>
						<table width="99%" cellpadding="0" cellspacing="0">
							<tr><td>&nbsp;</td></tr>
							<tr><td align="center"><strong>Debe indicar el Complemento Financiero</strong></td></tr>
							<tr><td>&nbsp;</td></tr>
						</table>
			</cfif>
				<cf_web_portlet_end>
				</td>
			</tr>				
			</table>			

			</cfoutput>
			<script type="text/javascript" language="javascript1.2">
				function asignar(value){
					if (value != ''){
						<cfif isdefined("form.OPtabla_F") and len(trim(form.OPtabla_F))>document.form2.ODchar_F.value='';</cfif>
						document.form2.action='';
						document.form2.submit();
					}
				}

				function validar(f){
					var error = false;
					var mensaje = 'Se presentaron los siguientes errores:\n';
					if( document.form2.OPtabla_F.value == '' ){
						mensaje += ' - El campo Catálogo es requerido.\n';
						error = true;
					}
					
					<cfif isdefined("form.OPtabla_F") and len(trim(form.OPtabla_F))>
						if( document.form2.ODchar_F.value == '' ){
							mensaje += ' - El campo Número Catálogo es requerido.';
							error = true;
						}
					</cfif>
					
					if (error){
						alert(mensaje);
						return false;
					}


					return true;
					
				}

			</script>
			
			<br>
		<cf_web_portlet_end>
		</td></tr>
		</table>
<cf_templatefooter>
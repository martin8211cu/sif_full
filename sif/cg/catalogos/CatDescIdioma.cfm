<!----  Realizado por: E. Raúl Bravo Gómez
        fecha: 19/08/2013
		Motivo: Creación del Descripción de Cuentas por idioma
		Modificado por:
--->		

<!---   ********************* Paso de URL a form  ************************************************ --->
<cfif isDefined("Form.PCDcatid") and len(trim(Form.PCDcatid)) neq 0
	and isDefined("Form.Iid") and len(trim(Form.Iid)) neq 0 >
	<cfset MODOI = "CAMBIO">
<cfelse>
	<cfset MODOI = "ALTA">
</cfif>


<cfif isDefined("Form.btnNuevoI")>
	<cfset MODOI = "ALTA">
</cfif>

<cfif isdefined('url.PCDcatid') and not isdefined('form.PCDcatid')>
	<cfparam name="form.PCDcatid" default="#url.PCDcatid#">
</cfif>
<cfif isdefined('url.PCEcatid') and not isdefined('form.PCEcatid')>
	<cfparam name="form.PCEcatid" default="#url.PCEcatid#">
</cfif>
<cfif isdefined('url.PCDdescripcion') and not isdefined('form.PCDdescripcion')>
	<cfparam name="form.PCDdescripcion" default="#url.PCDdescripcion#">
</cfif>
<cfif isdefined('url.PCDdescripcionI') and not isdefined('form.PCDdescripcionI')>
	<cfparam name="form.PCDdescripcion" default="#url.PCDdescripcion#">
</cfif>
<cfif isdefined('url.Iid') and not isdefined('form.Iid')>
	<cfparam name="form.Iid" default="#url.Iid#">
</cfif>
<cfif isdefined('url.PCEcodigo') and not isdefined('form.PCEcodigo')>
	<cfparam name="form.PCEcodigo" default="#url.PCEcodigo#">
</cfif>
<cfif isdefined('url.PCEdescripcion') and not isdefined('form.PCEdescripcion')>
	<cfparam name="form.PCEdescripcion" default="#url.PCEdescripcion#">
</cfif>
<cfif isdefined('url.PCDvalor') and not isdefined('form.PCDvalor')>
	<cfparam name="form.PCDvalor" default="#url.PCDvalor#">
</cfif>

<cfquery name="rsIdiomas" datasource="#Session.DSN#">
	select Iid, Descripcion as LOCIdescripcion
	from Idiomas
	order by 1, 2
</cfquery>

<cfquery name="rsEmpresa" datasource="#Session.DSN#">
	select coalesce(Iid,0) as Cve_Idioma
	from Empresa
	where Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
</cfquery>
<cfset Empresa_Iid = #rsEmpresa.Cve_Idioma#>

<!--- ******************** Asigna a la variable navegacion los filtros  ************************--->
<cfset navegacion = "">
<cfif isdefined("form.PCDcatid") and len(trim(form.PCDcatid)) >
	<cfset navegacion = navegacion & "&PCDcatid=#form.PCDcatid#">
</cfif>
<cfif isdefined("form.PCEcatid") and len(trim(form.PCEcatid)) >
	<cfset navegacion = navegacion & "&PCEcatid=#form.PCEcatid#">
</cfif>
<cfif isdefined("form.Iid") and len(trim(form.Iid)) >
	<cfset navegacion = navegacion & "&Iid=#form.Iid#">
</cfif>
<cfif isdefined("form.PCEcodigo") and len(trim(form.PCEcodigo)) >
	<cfset navegacion = navegacion & "&PCEcodigo=#form.PCEcodigo#">
</cfif>
<cfif isdefined("form.PCEdescripcion") and len(trim(form.PCEdescripcion)) >
	<cfset navegacion = navegacion & "&PCEdescripcion=#form.PCEdescripcion#">
</cfif>
<cfif isdefined("form.PCDvalor") and len(trim(form.PCDvalor)) >
	<cfset navegacion = navegacion & "&PCDvalor=#form.PCDvalor#">
</cfif>
<cfif isdefined("form.PCDdescripcionI") and len(trim(form.PCDdescripcionI)) >
	<cfset navegacion = navegacion & "&PCDdescripcionI=#form.PCDdescripcionI#">
</cfif>

<cfquery name="rsLista" datasource="#Session.DSN#">
    select c.PCEcatid,c.PCDcatid,i.Iid,i.Descripcion as LOCIdescripcion, c.PCDdescripcionI,c.ts_rversion,
    case i.Iid
    when #Empresa_Iid# then 'Si'
    else 'No'
    end as Def,
    e.PCEcodigo, d.PCDvalor, d.PCDdescripcion
    from PCDCatalogoIdioma c
    inner join Idiomas i
    on c.Iid=i.Iid
    inner join PCDCatalogo d
    on c.PCEcatid=d.PCEcatid and c.PCDcatid=d.PCDcatid
    inner join PCECatalogo e
    on c.PCEcatid=e.PCEcatid
	where c.PCEcatid=<cfqueryparam value="#form.PCEcatid#" cfsqltype="cf_sql_integer">
    and   c.PCDcatid=<cfqueryparam value="#form.PCDcatid#" cfsqltype="cf_sql_integer">
    <cfif isdefined("form.LOCIdioma") and len(trim(form.LOCIdioma))>
    	and c.Iid = <cfqueryparam value="#form.LOCIdioma#" cfsqltype="cf_sql_numeric">
    </cfif>
    <cfif isdefined("form.Ft_Desc") and len(trim(form.Ft_Desc))>
    	and Upper(c.PCDdescripcionI) like Upper('%#form.Ft_Desc#%')
    </cfif>
</cfquery>

<cfif MODOI eq 'CAMBIO'>
    <cfquery name="rsCarDescIdioma" datasource="#Session.DSN#">
        select c.Iid, c.PCDdescripcionI, ts_rversion
        from PCDCatalogoIdioma c
        where c.PCEcatid=<cfqueryparam value="#form.PCEcatid#" cfsqltype="cf_sql_integer">
        and   c.PCDcatid=<cfqueryparam value="#form.PCDcatid#" cfsqltype="cf_sql_integer">
        and   c.Iid=<cfqueryparam value="#form.Iid#" cfsqltype="cf_sql_numeric">
    </cfquery>
</cfif>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset Tit_DescXIdioma 	= t.Translate('Tit_DescXIdioma','Descripción por Idioma')>
<cfset Tit_PlanCta 		= t.Translate('Tit_PlanCta','Plan de Cuentas')>
<cfset Tit_ListaDesc 	= t.Translate('Tit_ListaDesc','Lista de Descripciones')>
<cfset Lbl_Idioma 		= t.Translate('Lbl_Idioma','Idioma')>
<cfset MSG_Descripcion 	= t.Translate('MSG_Descripcion','Descripcion','/sif/generales.xml')>
<cfset LB_Filtrar 		= t.Translate('LB_Filtrar','Filtrar','/sif/generales.xml')>
<cfset Lbl_Default 		= t.Translate('Lbl_Default','Default')>
<cfset Lbl_Catalogo		= t.Translate('Lbl_Catalogo','Catálogo')>
<cfset Lbl_Valor 		= t.Translate('Lbl_Valor','Valor')>
<cfset BTN_Agregar 		= t.Translate('BTN_Agregar','Agregar','/sif/generales.xml')>
<cfset LB_btnNuevo 		= t.Translate('LB_btnNuevo','Nuevo','/sif/generales.xml')>
<cfset LB_Filtrar 		= t.Translate('LB_Filtrar','Filtrar','/sif/generales.xml')>
<cfset BTN_Eliminar 	= t.Translate('BTN_Eliminar','Eliminar','/sif/generales.xml')>
<cfset BTN_Modificar 	= t.Translate('BTN_Modificar','Modificar','/sif/generales.xml')>
<cfset Msg_ElimTrad 	= t.Translate('Msg_ElimTrad','¿Desea eliminar la traducción?')>
<cfset Btn_IrLista 		= t.Translate('Btn_IrLista','Ir a Lista')>
<cfset Lbl_Ninguno 		= t.Translate('Lbl_Ninguno','Ninguno')>

<style type="text/css">
	<!--
	.style21 {font-size: 14px; font-family: "Times New Roman", Times, serif; }
	.style27 {font-size: 12px; font-family: "Times New Roman", Times, serif; }
	-->
</style>
	<cf_templateheader title="#Tit_PlanCta# - #Tit_DescXIdioma#">
	<cf_templatecss>
    		<cfoutput>
			<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#Tit_DescXIdioma#">
            </cfoutput>
				<cfinclude template="../../portlets/pNavegacion.cfm">
					<!---  ***************** Se encarga de pintar el encabezado  ***************** --->
					<cfoutput>
                    	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                          <tr>
                            <td><div align="center" class="tituloAlterno">#Lbl_Catalogo# #form.PCEcodigo#  #Lbl_Valor# #form.PCDvalor#  #form.PCDdescripcion#</div></td>
                          </tr>
						</table>
		  				<form style="margin:0;" name="formCaptura" method="post" action="CatDescIdioma-sql.cfm">
                        <input type="hidden" name="PCEcatid" value="#form.PCEcatid#">
                        <input type="hidden" name="PCDcatid" value="#form.PCDcatid#">
                        <input type="hidden" name="PCEcodigo" value="#form.PCEcodigo#">
                        <input type="hidden" name="PCDvalor" value="#form.PCDvalor#">
                        <input type="hidden" name="PCDdescripcion" value="#form.PCDdescripcion#">
                        
                    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                        	<tr>
                                <td>
                                    <strong>
                                        <span class="style21">#Lbl_Idioma#</span>
                                    </strong>
                                </td>
                                <td>
                                    <strong>
                                        <span class="style21">#MSG_Descripcion#</span>
                                    </strong>
                                </td>
                        	</tr>
                                <td align="left" nowrap>
                                  <cfif MODOI neq "ALTA">
                                  	<input type="hidden" name="Idioma" value="#rsCarDescIdioma.Iid#">
                                  </cfif>	
                                  <select name="Idioma" <cfif MODOI neq "ALTA"> disabled="disabled" </cfif> >
                                    <cfloop query="rsIdiomas">
                                      <option value="#rsIdiomas.Iid#" <cfif MODOI neq "ALTA" and rsCarDescIdioma.Iid eq rsIdiomas.Iid> selected</cfif>>#rsIdiomas.LOCIdescripcion#</option>
                                    </cfloop>
                                  </select>
                                  
                                </td>
                                <td>
                                	<input type="text" name="Descrip" value="<cfif MODOI neq 'ALTA'>#rsCarDescIdioma.PCDdescripcionI#</cfif>" size="80" maxlength="80">
                                </td>
                            <tr>
                            </tr>
                            <tr>
                            	<td align="center" colspan="4">
								<cfif MODOI neq "ALTA">
									<input type="submit" name="Cambio" 	class="btnGuardar" value="#BTN_Modificar#" tabindex="5" onClick="javascript: this.form.botonSel.value = this.name;">                                    
                                    <input type="submit" name="Baja"   	class="btnEliminarI" value="#BTN_Eliminar#"  tabindex="5" onClick="javascript: this.form.botonSel.value = this.name; if (!confirm('#Msg_ElimTrad#')){return false;}else{deshabilitarValidacion(this); return true;}">
                                    <input type="submit" name="btnNuevoI"  	class="btnNuevoI"    value="#LB_btnNuevo#" 	  tabindex="5" onClick="javascript: this.form.botonSel.value = this.name; deshabilitarValidacion(this); return true;">
                                <cfelse>
                                    <input type="submit" name="Alta" 	class="btnGuardarI" value="#BTN_Agregar#" tabindex="5" onClick="javascript: this.form.botonSel.value = this.name;">
                                </cfif>
								<input type="submit" name="btnLista" class="btnAnteriorI"	value="#Btn_IrLista#" tabindex="5" onClick="javascript: goLista();">
                                </td>
                            </tr>
						</table>
                        <cfif MODOI eq "CAMBIO">
							<cfset ts = "">
                            <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsCarDescIdioma.ts_rversion#" returnvariable="ts">
                            </cfinvoke>
                            <input type="hidden" name="ts_rversion" value="#ts#" tabindex="-1">
                        </cfif>
                        </form>
						<form method="post" name="filtros" action="#GetFileFromPath(GetTemplatePath())#" class="AreaFiltro" style="margin:0;">
							<input type="hidden" name="PCEcatid" value="#form.PCEcatid#">
							<input type="hidden" name="PCDcatid" value="#form.PCDcatid#">
							<input type="hidden" name="PCEcodigo" value="#form.PCEcodigo#">
							<input type="hidden" name="PCDvalor" value="#form.PCDvalor#">
                        	<input type="hidden" name="PCDdescripcion" value="#form.PCDdescripcion#">
							<cfif isdefined("form.Iid")>
								<input type="hidden" name="Iid" value="#form.Iid#">
							</cfif>
							<cfif isdefined("form.PCDdescripcionI")>
								<input type="hidden" name="PCDdescripcionI" value="#form.PCDdescripcionI#">
							</cfif>
							<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                                <tr>
                                    <td colspan="4"><div align="center" class="style21"><strong>#Tit_ListaDesc#</strong></div></td>
                                </tr>
								<tr>
									<td>
										<strong>
											<span class="style21">#Lbl_Idioma#</span>
										</strong>
                                    </td>
                                    <td>
										<strong>
											<span class="style21">#MSG_Descripcion#</span>
										</strong>
									</td>
								</tr>
								<tr>
                                    <td align="left" nowrap>
                                      <select name="LOCIdioma">
    									<option value="" selected> #Lbl_Ninguno# </option>
                                        <cfloop query="rsIdiomas">
                                          <option value="#rsIdiomas.Iid#" <cfif isdefined("form.Iid") and form.Iid eq rsIdiomas.Iid> selected</cfif>>#rsIdiomas.LOCIdescripcion#</option>
                                        </cfloop>
                                      </select>
                                    </td>
									<td align="left" nowrap>
                                        <input type="text" name="Ft_Desc" value="<cfif isdefined("form.PCDdescripcionI")>#form.PCDdescripcionI#</cfif>" size="80" maxlength="80">									
                                    </td>
                                    <td width="20%" align="center" nowrap>
                                      <input name="btnFiltrar" type="submit" id="btnFiltrar" class="btnFiltrar" value="#LB_Filtrar#" tabindex="3">			
                                    </td>
								</tr>
							</table>
						</form>
					</cfoutput>
					<!--- ******************** Se encarga de pintar la lista  ******************** --->
					
					<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="LOCIdescripcion, PCDdescripcionI, Def"/>
						<cfinvokeargument name="etiquetas" value="#Lbl_Idioma#, #MSG_Descripcion#, #Lbl_Default#"/>
						<cfinvokeargument name="formatos" value="S,S,S"/>
						<cfinvokeargument name="align" value="left, left, left"/>
						<cfinvokeargument name="ajustar" value="S"/>
						<cfinvokeargument name="irA" value="CatDescIdioma.cfm"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="keys" value="LOCIdescripcion, PCDdescripcionI"/>
						<cfinvokeargument name="formname" value="form1"/>
<!---						<cfinvokeargument name="botones" value="Regresar, Asignar"/>
						<cfinvokeargument name="checkedcol" value="Ocodigo_pcdo"/>
--->					<cfinvokeargument name="navegacion" value="#navegacion#"/> 
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="maxRows" value="25"/> 
					</cfinvoke>
				<cf_web_portlet_end>
	<cf_templatefooter>	 
    
<script language="JavaScript1.2" type="text/javascript">
	function goLista() {
		document.formCaptura.action = 'Catalogos.cfm';
		document.formCaptura.submit();
	}
</script>

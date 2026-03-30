<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif isDefined("session.Ecodigo") and isDefined("Form.Ocodigo") and len(trim(#Form.Ocodigo#)) NEQ 0>
	<cfquery name="rsOficinas" datasource="#Session.DSN#" >
        select 
            Ocodigo, Odescripcion, Oficodigo, LPid, ts_rversion,id_zona,id_direccion,telefono,responsable,pais, 
            Onumpatronal, rtrim(ltrim(Oadscrita)) as Oadscrita, Onumpatinactivo, ZEid
        from Oficinas
        where Ecodigo = #session.Ecodigo#
          and Ocodigo = #Form.Ocodigo#
        order by Odescripcion asc
	</cfquery>
</cfif>

<cfquery name="rsZE" datasource="#session.dsn#">
	select a.ZEid, a.ZEcodigo, a.ZEdescripcion
	from ZonasEconomicas a
	where a.CEcodigo = #session.CEcodigo#
</cfquery>

<cfquery name="rsListaPrecios" datasource="#session.DSN#">
	select LPid, LPdescripcion 
	from EListaPrecios
	where Ecodigo = #session.Ecodigo#
</cfquery>

<cfquery name="rsZonaVenta" datasource="#session.DSN#">
	select codigo_zona,id_zona,nombre_zona
	from ZonaVenta
	where Ecodigo = #session.Ecodigo#
</cfquery>

<cfquery name="rsPaises" datasource="asp">
	select Ppais,Pnombre
	from Pais
</cfquery>



<cfoutput>
<form action="SQLOficinas.cfm" method="post" name="form">

<table width="67%" height="75%" align="center" cellpadding="1" cellspacing="0">
  <tr valign="baseline" bgcolor="##FFFFFF">
    <td>&nbsp;</td>
    <td align="right" nowrap><cf_translate key="LB_Codigo" XmlFile="/sif/generales.xml">C&oacute;digo</cf_translate>:</td>
    <td>&nbsp;</td>
    <td>
		<input name="Oficodigo" type="text"  size="10" maxlength="10" tabindex="1"
		value="<cfif #modo# NEQ "ALTA">#HTMLEditFormat(rsOficinas.Oficodigo)#</cfif>">
  	</td>
    <td>&nbsp;</td>
    <cfif modo EQ 'CAMBIO'>
      <input type="hidden" name="xOficodigo" value="#rsOficinas.Oficodigo#" >
    </cfif>
  </tr>
  <tr valign="baseline" bgcolor="##FFFFFF">
    <td>&nbsp;</td>
    <td align="right" nowrap><cf_translate key="LB_Descripcion" XmlFile="/sif/generales.xml">Descripci&oacute;n</cf_translate>:</td>
    <td></td>
    <td>
	  <input name="Odescripcion" type="text"  ize="40" maxlength="60" tabindex="1"
	  	value="<cfif #modo# NEQ "ALTA">#HTMLEditFormat(rsOficinas.Odescripcion)#</cfif>" s  alt="La Descripción">
      <input type="hidden" name="Ocodigo" value="<cfif #modo# NEQ "ALTA">#rsOficinas.Ocodigo#</cfif>">
      <input type="text" name="txt" readonly class="cajasinbordeb" size="1"></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td align="right" nowrap><cf_translate key="LB_Telefono" XmlFile="/sif/generales.xml">T&eacute;lefono</cf_translate>:</td>
    <td>&nbsp;</td>
    <td>
      <input name="telefono" type="text" tabindex="1"
	  	value="<cfif #modo# NEQ "ALTA">#HTMLEditFormat(rsOficinas.telefono)#</cfif>" size="30" maxlength="30" alt="El Teléfono">
    </td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td align="right" nowrap><cf_translate key="LB_Responsable">Responsable</cf_translate>:</td>
    <td>&nbsp;</td>
    <td>
      <input name="responsable" type="text"  tabindex="1"
	  value="<cfif #modo# NEQ "ALTA">#HTMLEditFormat(rsOficinas.responsable)#</cfif>" size="30" maxlength="30"  alt="El Responsable">
    </td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td>&nbsp;</td>
    <td align="right" nowrap><cf_translate key="LB_NumeroPatronal">N&uacute;mero Patronal</cf_translate>:</td>
    <td>&nbsp;</td>
    <td>
      <input name="Onumpatronal" type="text" tabindex="1"
	  	value="<cfif modo neq "ALTA">#HTMLEditFormat(rsOficinas.Onumpatronal)#</cfif>" size="30" maxlength="40"  alt="El N&uacute;mero Patronal">
    </td>
    <td>&nbsp;</td>
  </tr>


  <tr>
    <td>&nbsp;</td>
    <td align="right" nowrap><cf_translate key="LB_ZonaDeVenta">Zona de Venta</cf_translate>:</td>
    <td>&nbsp;</td>
    <td> 
      <select name="LZonaVenta" tabindex="1">
	  	<cfif modo NEQ "ALTA">
        <option value="">-- <cf_translate key="CMB_NoEspecificado" XmlFile="/sif/generales.xml">No Especificado</cf_translate> --</option>
		<cfelse>
		<option value="">-- <cf_translate key="CMB_SeleccioneUno" XmlFile="/sif/generales.xml">Seleccione Uno</cf_translate> --</option>
		</cfif>
        <cfloop query="rsZonaVenta">
          <option value="#rsZonaVenta.id_zona#" <cfif modo NEQ "ALTA" and rsZonaVenta.id_zona eq rsOficinas.id_zona>selected</cfif> >#rsZonaVenta.codigo_zona# - #rsZonaVenta.nombre_zona#</option>
        </cfloop>
      </select>
    </td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td align="right" nowrap><cf_translate key="LB_Pais" XmlFile="/sif/generales.xml">Pa&iacute;s</cf_translate>:</td>
    <td>&nbsp;</td>
    <td>
      <select name="fpais" id="fpais" tabindex="1">
	  	<cfif modo NEQ "ALTA">
        <option value="">-- <cf_translate key="CMB_NoEspecificado" XmlFile="/sif/generales.xml">No Especificado</cf_translate> --</option>
		<cfelse>
		<option value="">-- <cf_translate key="CmB_SeleccioneUno" XmlFile="/sif/generales.xml">Seleccione Uno</cf_translate> --</option>
		</cfif>
        <cfloop query="rsPaises">
          <option value="#rsPaises.Ppais#" <cfif modo NEQ 'ALTA' and (trim(rsPaises.Ppais) EQ trim(rsOficinas.pais))>selected</cfif>>#HTMLEditFormat(rsPaises.Pnombre)#</option>
        </cfloop>
      </select>
    </td>
    <td>&nbsp;</td>
  </tr>
  <tr valign="baseline" bgcolor="##FFFFFF">
    <td>&nbsp;</td>
    <td align="right" nowrap><cf_translate key="LB_ListaPrecios">Lista Precios</cf_translate>:</td>
    <td>&nbsp;</td>
    <td>
      <select name="LPid" tabindex="1">
        <option value="">-- <cf_translate key="CMB_UsarPredeterminadaDelSistema">Usar Predeterminada del Sistema</cf_translate> --</option>
        <cfloop query="rsListaPrecios">
          <option value="#rsListaPrecios.LPid#" <cfif modo NEQ "ALTA" and rsListaPrecios.LPid eq rsOficinas.LPid>selected</cfif> >#rsListaPrecios.LPid# - #rsListaPrecios.LPdescripcion#</option>
        </cfloop>
      </select>
    </td>
  </tr>
 <tr>
 	<td>&nbsp;</td>
	<td align="right" nowrap><cf_translate key="LB_SucursalDeLaCCSSAAdscrita">Sucursal de la CCSS Adscrita</cf_translate>: </td>
	<td>&nbsp;</td>
	<td>
      <input name="Oadscrita" type="text" tabindex="1" size="30" maxlength="10"  alt="Sucursal de la CCSS adscrita para la Oficina"
	  	onFocus="javascript: this.select();" value="<cfif modo neq "ALTA">#HTMLEditFormat(rsOficinas.Oadscrita)#</cfif>" >
    </td>
	<td>&nbsp;</td>
 </tr>
  <tr>
 	<td>&nbsp;</td>
	<td align="right" nowrap><cf_translate key="LB_NummeroPatronalActivo">N&uacute;mero Patronal Activo</cf_translate>:</td>
	<td>&nbsp;</td>
	<td>
       <select name="Onumpatinactivo" tabindex="1">
        <option value="0" <cfif isdefined("rsOficinas") and rsOficinas.Onumpatinactivo EQ 0>selected</cfif>>-- <cf_translate key="CMB_Activa">Activa</cf_translate> --</option>
		<option value="1" <cfif isdefined("rsOficinas") and rsOficinas.Onumpatinactivo EQ 1>selected</cfif>>-- <cf_translate key="CMLB_Inactiva">Inactiva</cf_translate> --</option>
        <option value="2" <cfif isdefined("rsOficinas") and rsOficinas.Onumpatinactivo EQ 2>selected</cfif>>-- <cf_translate key="CMLB_Cerrada">Cerrada</cf_translate> --</option>
      </select>
    </td>
	<td>&nbsp;</td>
 </tr>
 <tr>
 	<td>&nbsp;</td>
	<td align="right" nowrap><cf_translate key="LB_ZonaEconomica">Zona Econ&oacute;mica</cf_translate>:</td>
	<td>&nbsp;</td>
	<td>
		<select name="ZEid" tabindex="1">
			<cfloop query="rsZE">
				<option value="">-- <cf_translate key="CMB_NoAsignada">No Asignada</cf_translate> --</option>
				<option value="#rsZE.ZEid#" <cfif modo NEQ "ALTA" and rsZE.ZEid eq rsOficinas.ZEid>selected</cfif>>
					#rsZE.ZEcodigo# - #rsZE.ZEdescripcion#
				</option>
			</cfloop>
		</select>
	</td>
	<td>&nbsp;</td>
 </tr>
  <tr>
    <td colspan="5">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td  nowrap colspan="3" align="center"><strong><cf_translate key="LB_Direccion" XmlFile="/sif/generales.xml">Direcci&oacute;n</cf_translate></strong></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="3">
      <input type="hidden" name="id_direccion" value="<cfif #modo# NEQ "ALTA">#HTMLEditFormat(rsOficinas.id_direccion)#</cfif>">
      <cfif #modo# NEQ "ALTA">
        <cf_direccion action="input" key="#rsOficinas.id_direccion#" title="" tabindex="1">
        <cfelse>
        <cf_direccion action="input"  title="" tabindex="1">
      </cfif>
    </td>
    <td>&nbsp;</td>
  </tr>
<!--- *************************************************** --->
<!---<cfif modo NEQ 'ALTA'>
	<tr>
	  <td colspan="5" align="center" class="tituloListas"><cf_translate key="LB_ComplementosContables" XmlFile="/sif/generales.xml">Complementos Contables</cf_translate></td>
	</tr>
	<tr><td colspan="5" align="center">
	<cf_sifcomplementofinanciero action='display' tabindex="1"
			tabla="Oficinas"
			form = "form"
			llave="#form.Ocodigo#" />		
	</td></tr>
</cfif>--->	
<!--- *************************************************** --->  
  <tr valign="baseline">
    <td colspan="5" align="center" nowrap>&nbsp;</td>
  </tr>
  <tr valign="baseline">
    <td colspan="5" align="center" nowrap>
		<cfset tabindex="1">
      <cfinclude template="../portlets/pBotones.cfm">
<!---      <input name="importar" value="Importar" type="button" onclick="funcImportar();">
--->    </td>
  </tr>
  <cfif modo neq "ALTA">
    <cfset ts = "">
    <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsOficinas.ts_rversion#" returnvariable="ts">
    </cfinvoke>
    <input type="hidden" name="ts_rversion" value="#ts#">
  </cfif>
  <input type="hidden" name="desde" value="<cfif isdefined("form.desde")>#form.desde#</cfif>" >
</table>
  </form>
</cfoutput>
<cfinvoke component="mig.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	XmlFile="/sif/generales.xml"
	returnvariable="MSG_Descripcion"/>
<cfinvoke component="mig.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	XmlFile="/sif/generales.xml"
	returnvariable="MSG_Codigo"/>

<cf_qforms form="form">
	<cf_qformsRequiredField name="Oficodigo" description="#MSG_Codigo#">
	<cf_qformsRequiredField name="Odescripcion" description="#MSG_Descripcion#">
</cf_qforms>



<script type="text/javascript" language="javascript">
	function funcImportar(){
		document.form.action = "/cfmx/sif/importar/ImportarOficinas.cfm<cfif isdefined("LvarSucursal")>?LvarSucursal=1<cfelse>?Modulo=MIG</cfif>";
		document.form.submit();
		}
</script>
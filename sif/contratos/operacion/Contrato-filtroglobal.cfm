<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Proveedor" Default= "Proveedor" XmlFile="Contrato-filtroglobal.xml" returnvariable="LB_Proveedor"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NumContrato" Default= "N&uacute;mero Contrato" XmlFile="Contrato-filtroglobal.xml" returnvariable="LB_NumContrato"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_desde" Default= "desde" XmlFile="Contrato-filtroglobal.xml" returnvariable="LB_desde"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_hasta" Default= "hasta" XmlFile="Contrato-filtroglobal.xml" returnvariable="LB_hasta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default= "Descripci&oacute;n" XmlFile="Contrato-filtroglobal.xml" returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default= "Fecha" XmlFile="Contrato-filtroglobal.xml" returnvariable="LB_Fecha"/>

<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<cfif isdefined("url.fCTCnumContrato") and len(url.fCTCnumContrato) and not isdefined("form.fCTCnumContrato")><cfset form.fCTCnumContrato = url.fCTCnumContrato></cfif>
<cfif isdefined("url.fCTCnumContrato2") and len(url.fCTCnumContrato2) and not isdefined("form.fCTCnumContrato2")><cfset form.fCTCnumContrato2 = url.fCTCnumContrato2></cfif>
<cfif isdefined("url.fDescripciones") and len(url.fDescripciones) and not isdefined("form.fDescripciones")><cfset form.fDescripciones = url.fDescripciones></cfif>
<cfif isdefined("url.fFecha") and len(url.fFecha) and not isdefined("form.fFecha")><cfset form.fFecha = url.fFecha></cfif>
<cfif isdefined("url.SNcodigoF") and len(url.SNcodigoF) and not isdefined("form.SNcodigoF")><cfset form.SNcodigoF = url.SNcodigoF></cfif>
<cfoutput>
	<form style="margin: 0" action="#GetFileFromPath(GetTemplatePath())#" name="fsolicitud" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
	  <tr> 
		<td class="fileLabel" nowrap width="8%" align="right"><label >#LB_NumContrato#:</label></td>
		<td nowrap width="31%">
			#LB_desde# <input type="text" name="fCTCnumContrato" size="10" maxlength="20" value="<cfif isdefined('form.fCTCnumContrato')>#form.fCTCnumContrato#</cfif>"text-align: right;"  onFocus="javascript:this.value=qf(this); this.select();" >
			#LB_hasta# <input type="text" name="fCTCnumContrato2" size="10" maxlength="20" value="<cfif isdefined('form.fCTCnumContrato2')>#form.fCTCnumContrato2#</cfif>"  text-align: right;"  onFocus="javascript:this.value=qf(this); this.select();" >		</td>
		<td class="fileLabel" nowrap width="9%" align="right">#LB_Descripcion#:</td>
		<td nowrap width="25%"><input type="text" name="fDescripciones" size="40" maxlength="100" value="<cfif isdefined('form.fDescripciones')>#form.fDescripciones#</cfif>" >		</td>
		<td width="27%" rowspan="2" align="center" valign="middle"><input type="submit" class="btnFiltrar" name="btnFiltro" value="Filtrar" /></td>
	  </tr>
      
	  <tr>
		<td class="fileLabel" align="right" nowrap>#LB_Proveedor#:</td>
		<td nowrap>
			<cfset valSNcodF = ''>
			<cfif isdefined('form.SNcodigoF') and Len(Trim(form.SNcodigoF))>
			  <cfset valSNcodF = form.SNcodigoF>
			</cfif>
			<cf_sifsociosnegocios2 form="fsolicitud" idquery="#valSNcodF#" sntiposocio="P" sncodigo="SNcodigoF" snnumero="SNnumeroF" frame="frame1">		</td>
		<td class="fileLabel" align="right" nowrap>#LB_Fecha#:</td>
		<td nowrap>
			<cfif isdefined('form.fFecha') and Len(Trim(form.fFecha))>
				<cf_sifcalendario conexion="#session.DSN#" form="fsolicitud" name="fFecha" value="#form.fFecha#">
			<cfelse>
				<cf_sifcalendario conexion="#session.DSN#" form="fsolicitud" name="fFecha" value="">
			</cfif>		</td>
	  </tr>
	</table>
	</form>
</cfoutput>

<!--- =============================================================== --->
<!--- Autor:  Rodrigo Rivera                                          --->
<!--- Nombre: Arrendamiento                                           --->
<!--- Fecha:  03/05/2014                                              --->
<!--- Última Modificación: 04/05/2014                                 --->
<!--- =============================================================== --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 	= t.Translate('LB_TituloH','SIF - Bancos')>
<cfset TIT_Rep		= t.Translate('TIT_Rep','Reporte de Arrendamiento')>
<cfset LB_DatosRep 	= t.Translate('LB_DatosRep','Datos del Reporte')>
<cfset LB_Socio		= t.Translate('LB_Socio','Socio de Negocios')>
<cfset LB_Hasta		= t.Translate('LB_Hasta','Hasta','/sif/generales.xml')>
<cfset LB_Formato 	= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>
<cfset Arrendamiento = t.Translate('Arrendamiento','Nombre del Arrendamiento')>


<cf_templateheader title="#LB_TituloH#">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_Rep#'>
  <cfinclude template="../../cg/consultas/Funciones.cfm">
  <script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
  <cfset periodo="#get_val(50).Pvalor#">
  <cfset mes="#get_val(60).Pvalor#">
  
<cfquery datasource="#Session.DSN#" name="rsOficinas">
    select Ocodigo, Odescripcion
    from Oficinas 
    where Ecodigo = #Session.Ecodigo#
    order by Ocodigo 
</cfquery>
<cfquery name="rsArrendamientos" datasource="#Session.DSN#">
  SELECT    b.IDArrend AS IDArrend, a.ArrendNombre AS ArrendNombre, a.SNcodigo AS SNcodigo
  FROM      CatalogoArrend a INNER JOIN EncArrendamiento b
  			ON a.IDCatArrend = b.IDCatArrend
  WHERE     a.Ecodigo = #Session.Ecodigo#
</cfquery>


<form name="form1" method="get" action="ReporteArrendamiento-SQL.cfm">

<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><legend><cfoutput>#LB_DatosRep#</cfoutput></legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
                	<cfoutput>
					<td>&nbsp;</td>
					<td align="left"><strong>#LB_Socio#:&nbsp;</strong></td>
					<td align="left"><strong>#LB_Formato#&nbsp;</strong></td>
                    </cfoutput>
				</tr>
				<tr>
				  <td>&nbsp;</td>
				  <td align="left" nowrap="nowrap">
                	<cfoutput>
				    	<cf_sifsociosnegocios2 tabindex="1" size="55">
                	</cfoutput>
                  </td>
                  <td align="left"><div align="left">
					  <select name="Formato" id="Formato" tabindex="1">
					    <option value="flashpaper">FLASHPAPER</option>
					    <option value="pdf">PDF</option>
                        <option value="Excel">Microsoft Excel</option>
				      </select>
				  </div></td>
				  <td align="left" nowrap="nowrap">
                  </td>
                  </tr>
                  <tr>
					<td>&nbsp;</td>
                  </tr>
                  <tr>
				  <td>&nbsp;</td>
				  <td align="left" nowrap="nowrap"><strong><cfoutput>#Arrendamiento#:</cfoutput></strong></td><tr></tr><td>&nbsp;</td>
						<td align="left">
        					<select type="text" name="NombreArrend" id="NombreArrend" tabindex="1" onfocus='opciones(this);'>
        						<option value="">Seleccionar Arrendamiento</option>
      						</select>
                        </td>
						<td nowrap align="left">&nbsp;</td>
			    </tr>
				<tr>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
			    </tr>			
				<tr>
					<td colspan="6">
					<cf_botones values="Generar" names="Generar"></td>
				</tr>
			</table>
			</fieldset>
		</td>	
	</tr>
</table>
</form>

<cf_qforms form="form1" objForm="objForm">


<cf_web_portlet_end>
<cf_templatefooter>

<script type="text/javascript" src="/cfmx/CFIDE/scripts/wddx.js"></script>
<script type="text/javascript">
  objForm.SNcodigo.required = true;
  objForm.SNcodigo.description = "Socio de Negocios";
  
  objForm.NombreArrend.required = true;
  objForm.NombreArrend.description = "Nombre Arrendamiento";  

<cfoutput>
  <cfwddx action="cfml2js" input="#rsArrendamientos#" topLevelVariable="rsjArrendamientos"> 
</cfoutput>
function opciones(t){
	  var sn = document.form1.SNcodigo.value;
  <cfwddx action="cfml2js" input="#rsArrendamientos#" topLevelVariable="rsjArrendamientos"> 
  var nRows = rsjArrendamientos.getRowCount();
  if (nRows > 0) {
    t.options.length = 1;
    for (row = 0; row < nRows; ++row) {
      if (rsjArrendamientos.getField(row, "SNcodigo") == sn){
        var opt = document.createElement("OPTION");
        opt.value = rsjArrendamientos.getField(row, "IDArrend");
        opt.text = rsjArrendamientos.getField(row, "ArrendNombre");
        t.options.add(opt);
      }
    }
  }
}


</script>

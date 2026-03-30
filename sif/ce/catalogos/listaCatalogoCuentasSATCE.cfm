<!---cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent--->

<cfquery name="rs" datasource="#session.dsn#">
	select CAgrupador, Descripcion
	from CEAgrupadorCuentasSAT where CAgrupador = #form.CAgrupador#
</cfquery>
<cfset LvarAction   = 'CatalogoCuentasSATCE.cfm'>
<cfset LvarRegresar = 'AgrupadorCuentasSATCE.cfm'>
<cfset LvarImportar = 'MapeoCuentasCEImportacion.cfm'>
<cfinvoke key="LB_Titulo" default="Cuentas para Mapeo" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate"
xmlfile="listaCatalogoCuentasSATCE.xml"/>
<cfinvoke key="LB_Cuenta" default="Cuenta" returnvariable="LB_Cuenta" component="sif.Componentes.Translate" method="Translate"
xmlfile="listaCatalogoCuentasSATCE.xml"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate"
xmlfile="listaCatalogoCuentasSATCE.xml"/>
<cfinvoke key="LB_Tipo" default="Tipo" returnvariable="LB_Tipo" component="sif.Componentes.Translate" method="Translate"
xmlfile="listaCatalogoCuentasSATCE.xml"/>

<cf_templateheader title="#LB_Titulo#">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Titulo#: #rs.CAgrupador# - #rs.Descripcion#">
<cfinclude template="../../portlets/pNavegacionCG.cfm">
<cfset navegacion='&form.CAgrupador=#form.CAgrupador#'>
<cfset IRA = 'CatalogoCuentasSATCE.cfm'>
<cfoutput>

	<form name="form1" method="post" action="#LvarAction#">
		<input name="CAgrupador" type="hidden" value="#form.CAgrupador#">

		<table border="0" cellpadding="0" cellspacing="0" style="width:100%">
			<tr>
				<td>
					<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet"
						tabla				= "CECuentasSAT"
						columnas  			= "CCuentaSAT, NombreCuenta, Clasificacion"
						desplegar			= "CCuentaSAT, NombreCuenta, Clasificacion"
						etiquetas			= "#LB_Cuenta#, #LB_Nombre#, #LB_Tipo#"
						formatos			= "S,S,S"
						filtro				= "CAgrupador=#form.CAgrupador# and  (Ecodigo=#Session.Ecodigo# or Ecodigo is null) order by
                                                CASE
                                                   WHEN ISNUMERIC(CCuentaSAT) = 1 THEN CAST(CCuentaSAT AS FLOAT)
                                                   WHEN ISNUMERIC(LEFT(CCuentaSAT,1)) = 0 THEN ASCII(LEFT(LOWER(CCuentaSAT),1))
                                                   ELSE 2147483647
                                                END"
						align 				= "Left, Left, Left"
						ajustar				= "N"
						checkboxes			= "N"
						incluyeform			= "false"
						formname			= "form1"
					    navegacion			= "#navegacion#"
						mostrar_filtro		= "true"
						filtrar_automatico	= "true"
						showLink			= "true"
						showemptylistmsg	= "true"
						keys				= "CCuentaSAT"
						MaxRows				= "15"
						irA					= "CatalogoCuentasSATCE.cfm"
						botones				= "Nuevo,Regresar,Importar_Mapeo"
						/>
				</td>
			</tr>
		</table>
	</form>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>
<script language="javascript" type="text/javascript">
	function funcRegresar(){
		document.form1.action='<cfoutput>#LvarRegresar#</cfoutput>';
		document.form1.submit();
		return true;
	}
	function funcImportar_Mapeo(){
        document.form1.action='<cfoutput>#LvarImportar#</cfoutput>';
		document.form1.submit();
	    return false;
	}
</script>

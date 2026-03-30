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
<cfset LvarImportar2 = 'SincronizaMapeo.cfm'>
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
<cfinclude template="../../../portlets/pNavegacionCG.cfm">
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
						botones				= "Regresar,Importar_Mapeo,Sincronizar_Mapeo"
						/>
				</td>
			</tr>
			<cfquery name="rs" datasource="#session.dsn#">
				SELECT distinct top 1 Cformato
				FROM CContables a
				inner join CtasMayor cm
					on a.Cmayor = cm.Cmayor
					and a.Ecodigo = cm.Ecodigo
				INNER JOIN PCDCatalogoCuenta b
					on a.Ccuenta = b.Ccuentaniv
					and b.PCDCniv <= (
										select isnull(Pvalor,2) Pvalor
										from Parametros
										where Ecodigo = #Session.Ecodigo# and Pcodigo = 200080
						) -1
				left join CCInactivas cci
					on a.Ccuenta = cci.Ccuenta
					and getdate() BETWEEN CCIdesde and CCIhasta
				Where a.Ecodigo in (SELECT  Ecodigo
					   FROM AnexoGEmpresaDet
					   where GEid = (
						SELECT  GEid
						FROM AnexoGEmpresaDet
						where Ecodigo = #Session.Ecodigo#))
					AND not EXists (select Cformato from CContables b where Ecodigo = #Session.Ecodigo# and a.Cformato = b.Cformato)
					and cci.CCIid is null
			</cfquery>

			<cfif rs.recordCount GT 0>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td valign="bottom">
						<table border="0" cellpadding="0" cellspacing="0" style="width:100%">
							<tr>
								<td width="25px">
									<img src="/cfmx/sif/imagenes/warning.png" border="0" align="absmiddle">
								</td>
								<td >
									<font color="red"><b>&nbsp;Alerta: Existen cuentas en el grupo de Empresas que no se han creado en la Empresa de Eliminaci&oacute;n</b></font>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</cfif>
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
	function funcSincronizar_Mapeo(){

		var r = confirm("Esta operaci\u00F3n sincronizar\u00E1 el Mapeo en todas las empresas del grupo, de acuerdo a la Empresa de Eliminaci\u00F3n, \u00BFDesea continuar?");
		if (r == true) {
		    document.form1.action='<cfoutput>#LvarImportar2#</cfoutput>';
			document.form1.submit();
		    return true;
		} else {
		    return false;
		}

	}
</script>

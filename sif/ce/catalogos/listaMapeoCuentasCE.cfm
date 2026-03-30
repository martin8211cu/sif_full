<cfinvoke key="LB_Cuenta" default="Cuenta" returnvariable="LB_Cuenta" component="sif.Componentes.Translate" method="Translate"
xmlfile="listaMapeoCuentasCE.xml"/>
<cfinvoke key="LB_Descripcion" default="Descripción" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"
xmlfile="listaMapeoCuentasCE.xml"/>
<cfinvoke key="LB_Agrupador" default="Agrupador SAT" returnvariable="LB_Agrupador" component="sif.Componentes.Translate" method="Translate"
xmlfile="listaMapeoCuentasCE.xml"/>
<cfinvoke key="LB_Clasificacion" default="Tipo SAT" returnvariable="LB_Clasificacion" component="sif.Componentes.Translate" method="Translate"
xmlfile="listaMapeoCuentasCE.xml"/>

<cfset navegacion='form.CAgrupador=#form.CAgrupador#&form.CCuentaSAT=#form.CCuentaSAT#'>
<cfset IRA = 'CatalogoCuentasSATCE.cfm'>
<cfif #nivel.Pvalor# neq '-1'>
	<cfset LvarFiltro = 'and (select PCDCniv from PCDCatalogoCuenta where Ccuentaniv = cc.Ccuenta GROUP BY PCDCniv ) <= #nivel.Pvalor - 1#'>
<cfelse>
	<cfset LvarFiltro = "and cc.Cmovimiento = 'S'">
</cfif>

<cfoutput>
	<form name="form3" id="form3" method="post" action="CatalogoCuentasSATCE.cfm">
		<input name="CAgrupador" type="hidden" value="#form.CAgrupador#">
		<cf_navegacion name="Modo" default="" session>
        <br>
        <br>
		<table border="0" cellpadding="0" cellspacing="0" style="width:100%">
			<tr>
				<td>
					<br>
                    <br>
					<cfset form.PAGENUM=1>

					<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet2"
						tabla				= "CContables cc
						                       INNER JOIN CEMapeoSAT ce
						                       	ON cc.Ccuenta=ce.Ccuenta
						                       	and cc.Ecodigo = ce.Ecodigo
						                       	and ce.CAgrupador='#trim(form.CAgrupador)#'
						                       	and ce.CCuentaSAT='#form.CCuentaSAT#'
						                       	and ce.Ecodigo = cc.Ecodigo
						                       	and cc.Ecodigo = #Session.Ecodigo#
						                       #LvarFiltro#
						                       INNER JOIN CECuentasSAT cec ON ce.CCuentaSAT=cec.CCuentaSAT and ce.CAgrupador=cec.CAgrupador"
						columnas  			= "cc.Cmayor, cc.Cformato, cc.Cdescripcion, cec.NombreCuenta, cec.Clasificacion, ce.Ccuenta"
						desplegar			= "Cformato, Cdescripcion, NombreCuenta, Clasificacion"
						etiquetas			= "#LB_Cuenta#, #LB_Descripcion#, #LB_Agrupador#, #LB_Clasificacion#"
						formatos			= "S,S,S,S"
						filtro				= "1 = 1 ORDER BY cc.Cformato"
						align 				= "Left, Left, Left, Left, Left"
						ajustar				= "N"
						checkboxes			= "N"
						incluyeform			= "false"
						formname			= "form3"
						navegacion			= "#navegacion#"
						mostrar_filtro		= "true"
						filtrar_automatico	= "true"
						showLink			= "true"
						showemptylistmsg	= "true"
						keys				= "Cformato"
						MaxRows				= "15"
						irA					= "#IRA#"
						/>
				</td>
			</tr>
		</table>
		<input name="modom" type="hidden" value="CAMBIO">
		<input name="CCuentaSAT" type="hidden" value="#form.CCuentaSAT#">

	</form>
</cfoutput>

<script language="javascript" type="text/javascript">
	function funcRegresar(){
		document.form1.action='<cfoutput>#LvarRegresar#</cfoutput>';
		document.form1.submit();
		return true;
	}

	function funcFiltrar(){

		document.form3.modo.value='CAMBIO';
		document.form3.modom.value='ALTA';

		return true;
	}
</script>

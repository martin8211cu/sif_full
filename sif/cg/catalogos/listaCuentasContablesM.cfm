
<cfinvoke key="LB_Cuenta" default="Cuenta" returnvariable="LB_Cuenta" component="sif.Componentes.Translate" method="Translate" 
xmlfile="listaCuentasContablesM.xml"/>
<cfinvoke key="LB_Descripcion" default="Descripcion" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" 
xmlfile="listaCuentasContablesM.xml"/>        

<cfif isdefined("LvarInfo")>
	<cfset LvarAction = 'SQLCatalogoCuentasMINFO.cfm'>
<cfelse>
	<cfset LvarAction = 'SQLCatalogoCuentasM.cfm'>
</cfif>

<cfset navegacion=''>
<form name="detalle" method="post" action="<cfoutput>#LvarAction#</cfoutput>">
	<cfoutput>
		<input name="CGICMid" type="hidden" value="<cfif isdefined("Form.CGICMid")>#Form.CGICMid#</cfif>">
		<input name="CGICCid" type="hidden" value="<cfif isdefined("Form.CGICCid")>#Form.CGICCid#</cfif>">
	</cfoutput>
	<table border="0" style="width:100%">
		<tr>
			<td></td>
		</tr>
		<tr>
			<td style="width:10%"><cf_translate key=LB_Cuenta>Cuenta</cf_translate>:</td>
			<td style="width:1%">
				<cf_sifMapeoCuentas tabindex="1" size="55" form="detalle" frame="frame1" CGICMid= "#Form.CGICMid#" CGICCid="#form.CGICCid#">
			</td>
			<td align="left">	
				<input name="BtnAgregarCuenta" value="+" type="submit">
			</td>
		</tr>
	</table>
		<cf_navegacion name="CGICMid" default="" session>
		<cf_navegacion name="CGICCid" default="" session>
		<cf_navegacion name="Modo" default="" session>
		
		<cfinvoke 
		  component="sif.Componentes.pListas"
		  method="pLista"
		  returnvariable="pListaRet"
			columnas  			= "c.Cformato, c.Cdescripcion, mc.Ccuenta, mc.CGICMid as CGICMidLista, '' as truco"
			tabla				= "CGIC_Catalogo me
									inner join CGIC_Cuentas mc
										inner join CContables c
											inner join Empresas e
											on e.Ecodigo = c.Ecodigo
										on c.Ccuenta = mc.Ccuenta
									on mc.CGICCid = me.CGICCid"
			filtro				= "me.CGICCid = #form.CGICCid#
									  and e.Ecodigo = #session.Ecodigo#
									  and c.Cmayor <> c.Cformato
									order by c.Cformato"
			desplegar			= "Cformato, Cdescripcion, truco"
			etiquetas			= "#LB_Cuenta#, #LB_Descripcion#, "
			formatos			= "S,S,U"
			align 				= "Left, Left, Left"
			ajustar				= "S"
			checkboxes			= "S"
			incluyeform			= "true"
			formname			= "detalle"
			botones				= "Eliminar"
			navegacion			= "#navegacion#"
			mostrar_filtro		= "true"
			filtrar_automatico	= "true"

			showLink			= "true"
			showemptylistmsg	= "true"
			keys				= "Ccuenta"
			MaxRows				= "15"
			irA					= "#LvarAction#"
			/>
		
</form>
<script language="javascript" type="text/javascript">
	function funcFiltrar(){
		document.detalle.action='<cfoutput>#LvarAction#</cfoutput>';
		document.detalle.modo.value='CAMBIO';
		document.detalle.submit();
		return false;
	}
</script>
<!--- 
Creado por Jose Gutierrez 
	07/03/2018
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 		= t.Translate('LB_TituloH','Catalogo de Cuentas')>
<cfset LB_DatosReporte 	= t.Translate('LB_DatosReporte','Filtros del Reporte')>
<cfset LB_TipoCta 		= t.Translate('LB_TipoCta','Tipos de Cuenta')>
<cfset LB_Estatus 		= t.Translate('LB_Estatus','Estado')>
<cfset LB_FechaCreacion 		= t.Translate('LB_FechaCreacion','Fecha de Creacion')>
<cfset LB_Categoria 		= t.Translate('LB_Categoria','Categoria de Distribuidor')>
<cfset LB_Resumen 		= t.Translate('LB_Resumen', 'Solo Resumen')>

<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>


<cf_templateheader title="#LB_TituloH#">

<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_TituloH#'>


 

<cfinclude template="../../../sif/Utiles/sifConcat.cfm">
<form name="form1" action="reporteCuentas_sql.cfm?p=0" method="post">
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td align="center">
			<fieldset>
				<b>#LB_DatosReporte#</b>
			</fieldset>
			<table  width="50%" cellpadding="2" cellspacing="0" border="0" >
				<tr> <td >&nbsp;</td> </tr>
				<tr align="center">
					<td><strong>#LB_TipoCta#:&nbsp;</strong></td>
					<td align="left">
						<input type="checkbox" name="tipoCTA" value="D" onclick="showCategoria();"> Distribuidor <br>
						<input type="checkbox" name="tipoCTA" value="TC"> Tarjetahabiente <br>
						<input type="checkbox" name="tipoCTA" value="TM"> Mayorista <br>
					</td>
				</tr>
				<tr> <td >&nbsp;</td> </tr>
				<tr align="center">
					<td><strong>#LB_Estatus#:&nbsp;</strong></td>
					<td align="left">
						<cfquery name="q_EstatusCuenta" datasource="#session.dsn#">
							select id,Descripcion from CRCEstatusCuentas where Ecodigo = #session.ecodigo#
						</cfquery>
						<select name="estadoCuenta">
							<option value="-1">Todos</option>
							<cfloop query="q_EstatusCuenta">
								<option value="#q_EstatusCuenta.id#|#q_EstatusCuenta.descripcion#">#q_EstatusCuenta.descripcion#</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<tr> <td >&nbsp;</td> </tr>
				<tr align="center">
					<td><strong>#LB_FechaCreacion#:&nbsp;</strong></td>
					<td align="left">
						<b>Inicio: </b>
						<cfset fechaCreacion = LSDateFormat(Now(),'dd/mm/yyyy')>
						<cf_sifcalendario form="form1" value="" name="fechaCreacionIni" tabindex="1">
						<b>Fin: </b>
						<cfset fechaCreacion = LSDateFormat(Now(),'dd/mm/yyyy')>
						<cf_sifcalendario form="form1" value="" name="fechaCreacionFin" tabindex="1">
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left">
						<input type="checkbox" name="resumen">
						<strong>#LB_Resumen#</strong>
					</td>
				</tr>
				<tr id ="filtroCategoria1" style="display:none;"> <td>&nbsp;</td> </tr>
				<tr id ="filtroCategoria2" style="display:none;" align="center">
					<td><strong>#LB_Categoria#:&nbsp;</strong></td>
					<td align="left">
						<cfquery name="q_CategoriaCuenta" datasource="#session.dsn#">
							select id,Titulo from CRCCategoriaDist where Ecodigo = #session.ecodigo#
						</cfquery>
						<select name="categoriaCuenta">
							<option value="-1">Todos</option>
							<cfloop query="q_CategoriaCuenta">
								<option value="#q_CategoriaCuenta.id#|#q_CategoriaCuenta.Titulo#">#q_CategoriaCuenta.Titulo#</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<tr> <td >&nbsp;</td> </tr>
				<tr align="center">
					<td>
					<cf_botones values="Generar" names="Generar"  tabindex="1">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

</form>
<cf_web_portlet_end>			

<cf_templatefooter>

 </cfoutput>

<script>
	function showCategoria(){
		var f2 = document.getElementById('filtroCategoria2').style;
		var f1 = document.getElementById('filtroCategoria1').style;
		if(f2.display=='none'){
			f2.display="";
			f1.display="";
		}else{
			f2.display="none";
			f1.display="none";
		}
	}
</script>


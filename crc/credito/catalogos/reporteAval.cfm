<!--- 
Creado por Jose Gutierrez 
	07/03/2018
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 		= t.Translate('LB_TituloH','Reporte Avales')>
<cfset LB_DatosReporte 	= t.Translate('LB_DatosReporte','Filtros del Reporte')>
<cfset LB_SNegocio 		= t.Translate('LB_SNegocio','Socio de Negocio')>
<cfset LB_TipoCta 		= t.Translate('LB_TipoCta','Tipos de Cuenta')>

<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>


<cf_templateheader title="#LB_TituloH#">

<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_TituloH#'>

<form name="form1" action="reporteAval_sql.cfm?p=0" method="post">
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td align="center">
			<fieldset>
				<b>#LB_DatosReporte#</b>
			</fieldset>
			<table  width="50%" cellpadding="2" cellspacing="0" border="0">
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr align="left">
					<td colspan="2">
					<strong>#LB_SNegocio#:&nbsp;</strong>
					<cfset tipoSN = "D">
					<cf_conlis
						title="#LB_SNegocio#"
						Campos="SNid,numCuenta,Nombre"
						Desplegables="N,S,S"
						Modificables="S,S,S"
						Size="0,15,30"
						tabindex="1"
						Tabla="SNegocios sn inner join CRCCuentas cc on cc.SNegociosSNid = sn.SNid"
						Columnas="
								cc.id as idCuenta
							, sn.SNnombre as Nombre
							, cc.Numero numCuenta
							, sn.SNidentificacion
							, sn.SNid
							, cc.tipo"
						form="form1"
						Filtro="sn.Ecodigo = #Session.Ecodigo#"
						Desplegar="numCuenta,tipo,SNidentificacion, Nombre"
						Etiquetas="Numero de Cuenta,Tipo de Cuenta, Identificacion del Socio, Nombre del Socio"
						filtrar_por="cc.Numero,cc.tipo,sn.SNidentificacion,sn.SNnombre"
						Formatos="S,S,S,S"
						Align="left,left,left,left"
						Asignar="idCuenta,SNid,Nombre,numCuenta"
						Asignarformatos="S,S,S"/>
					</td>
				</tr>
				<tr align="center">
					<td><strong>#LB_TipoCta#:&nbsp;</strong></td>
					<td align="left">
						<input type="checkbox" name="tipoCTA" value="D"> Distribuidor <br>
						<input type="checkbox" name="tipoCTA" value="TC"> Tarjetahabiente <br>
						<input type="checkbox" name="tipoCTA" value="TM"> Mayorista <br>
					</td>
				</tr>
				<tr>
					<td >&nbsp;</td>
				</tr>
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




<cfparam name="GELid" default="">
<table width="100%" cellpadding="5" cellspacing="3" >
<tr  ><td width="30%" valign="top">	
<table width="30%" cellpadding="5" cellspacing="3" >
<tr  ><td width="30%" valign="top">

	<cfquery datasource="#session.dsn#" name="listaDep">
				select GELDid,GELDreferencia,GELDtotalOri,GELid from 
				GEliquidacionDeps where GELid=#form.GELid#
	</cfquery>
	
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
			query="#listaDep#"
			desplegar="GELDreferencia,GELDtotalOri"
			etiquetas="Referencia, Monto "
			formatos="S,M"
			align="left,left"
			form_method="post"	
			ira="LiquidacionAnticipos#LvarSAporEmpleadoSQL#.cfm"
			showEmptyListMsg="yes"
			keys="GELDid"
			incluyeForm="yes"
			maxRows="0"
			formName="formDepo"
			PageIndex="1"
		/>

</td>
<td valign="top" width="70%">
<cfinclude template="Tab3_Depositos_form.cfm">
 &nbsp;</td>
 </tr>
</table>


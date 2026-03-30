<cfparam name="ID_liquidacion" default="">
<table width="85%" cellpadding="5" cellspacing="3" >
<tr  ><td width="50%" valign="top">	
<table width="85%" cellpadding="5" cellspacing="3" >
<tr  ><td width="50%" valign="top">

	<cfquery datasource="#session.dsn#" name="listaDep">
				select TESDepo_id,TESDepo_referencia,TESDepo_monto,ID_liquidacion from 
				GASTOE_Deposito where ID_liquidacion=#session.Liquidacion.ID_liquidacion#
	</cfquery>
	
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
			query="#listaDep#"
			desplegar="TESDepo_referencia,TESDepo_monto"
			etiquetas="Referencia, Monto "
			formatos="S,M"
			align="left,left"
			form_method="post"	
			ira="LiquidacionAnticipos.cfm"
			showEmptyListMsg="yes"
			keys="TESDepo_id"
			incluyeForm="yes"
			maxRows="0"
			formName="formDepo"
			PageIndex="1"
		/>

</td>
<td valign="top" width="50%">
<cfinclude template="Tag3_Depositos_form.cfm">
 &nbsp;</td>
 </tr>
</table>


<!---<table width="85%" cellpadding="5" cellspacing="3" >
<tr  ><td width="100%" valign="top">	--->
<table width="100%" cellpadding="5" cellspacing="3" >
<tr  ><td width="30%" valign="top">

	<cfquery datasource="#session.dsn#" name="listaDet">
		select  	c.CFcuenta,c.TESSAMonto,a.TESSAid,c.TESSAid, c.TESSAid,c.TESSAMutilizado,  a.ID_liquidacion  from 
		GASTOE_Ant_xliquidar a,
		GASTOE_SoliAntiD c
		where a.ID_liquidacion=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_Liquidacion#">
		 and c.TESSAid=a.TESSAid
</cfquery>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
			query="#listaDet#"
			desplegar="CFcuenta"
			etiquetas="Cuenta "
			formatos="S"
			align="left"
			ira="LiquidacionAnticipos.cfm"
			form_method="post"	
			showEmptyListMsg="yes"
			keys="TESSAid"
			incluyeForm="yes"
			maxRows="0"
			formName="lista_anticipos"
			PageIndex="1"
		/>

</td>
<td valign="top" width="70%">
<cfinclude template="DetLiquiTag1_form.cfm">
 &nbsp;</td>
 </tr>
</table><!---</td></tr></table>--->
            	
		          

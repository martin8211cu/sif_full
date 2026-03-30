<cfif form.GELid NEQ "">

	<cfquery datasource="#session.dsn#" name="listaDet">
		select 
		a.GELid,
		a.GELDid,
		a.Ecodigo,
		a.BMUsucodigo,
    	a.GELDid,
		a.GELDreferencia,
		a.GELDtotalOri,
		a.GELDfecha,
		a.Mcodigo,
		a.GELDtipoCambio,
		a.GELDtotal,
		a.Mcodigo,
		b.CBdescripcion ,
		b.CBcodigo,
		
				(select Mo.Miso4217
					from Monedas Mo
					where DL.Mcodigo=Mo.Mcodigo
		)as MonedaDetalle,  
		(select Mo.Miso4217
					from Monedas Mo
					where a.Mcodigo=Mo.Mcodigo					
			)as MonedaEncabezado
			
			from GEliquidacionDeps a,CuentasBancos b,GEliquidacion DL
			where  a.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			and DL.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			and a.CBid= b.CBid
            and b.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		 		
            
			
			
				<!---		from GEliquidacionDeps a,CuentasBancos b,GEliquidacionGasto DL
			where a.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
				and a.CBid= b.CBid	
				and DL.GELid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			and a.GELDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELDid#">
			and b.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		 	
--->				
	
	 </cfquery>
	</cfif>
	<cfquery datasource="#session.dsn#" name="listaDet2">
		select a.GELDid,a.GELDfecha,b.CBcodigo,a.GELDreferencia,a.GELDtotalOri,	a.Mcodigo,a.GELDtotal,a.GELid,a.CBid,b.CBdescripcion  
		from GEliquidacionDeps a,CuentasBancos b
		where GELid=#form.GELid#
		and a.CBid= b.CBid	
        and b.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		 	
	</cfquery>	

<!---LISTA--->

<table width="100%" border="0" align="left" >
	<tr>
		<td width="100%" valign="top">
			<cfset titulo = 'Lista de Anticipos Asociados'>
			<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
			
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
					query="#listaDet#"
					desplegar="GELDreferencia,GELDfecha,CBcodigo,GELDtotalOri,MonedaDetalle,GELDtotal,MonedaEncabezado"
					etiquetas="Dep&oacute;sito, Fecha, Cuenta, Monto,MonedaD, Monto Total de la Liquidaci&oacute;n, MonedaE"
					formatos="S,D,S,M,S,M,S"
					align="left,left,left,left,left,center,left"
 				    form_method="post"	
					showEmptyListMsg="yes"
					keys="GELDid,GELid"
					incluyeForm="yes"
					formName="formDepo"
					PageIndex="3"
					MaxRows="0"
					showLink="no"
				
				/>
				<cf_web_portlet_end>
		</td>
	</tr>
</table>
	
 

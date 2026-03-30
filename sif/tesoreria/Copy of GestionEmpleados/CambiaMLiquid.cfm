<!--- Me premite calcular los factores de comberción y los montos en la moneda del Encabezado de la Liquidación...
	Hace los calculo para que se pueda ingresar el factor de conversión y calcule el monto en moneda del Emcabezado de la Liquidación. 
	--->
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>
<cfif #url.Mcodigo# neq 'undefined'>
<!---Query que busca la moneda local--->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
			select 
				Mcodigo 
			from 
				Empresas
			where 
				Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
</cfquery>

<!---Query que busca la del encabezado--->
<cfif isdefined('url.ID_l')>
	<cfquery name="MonedaEncabezado" datasource="#session.dsn#">
		select 
			Mcodigo,
			GELtipoCambio 
		from 
			GEliquidacion 
		where 
			GELid=#url.ID_l#
	</cfquery>
</cfif>

<!---Query que busca la moneda del detalle--->

<cfif isdefined('url.Mcodigo') and len(trim(url.Mcodigo))>
	<cfquery name="rsMoneda" datasource="#session.DSN#">
		select
			Mcodigo, 
			Mnombre
		from 
			Monedas
		where
			Mcodigo=#url.Mcodigo# 
		and 
			Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
<cfset McodigoDet='#url.Mcodigo#'>
</cfif>
<!---Query que busca el tipo de Cambio--->

<cfif isdefined('url.Fecha')>
	<cfquery name="TCsug" datasource="#session.dsn#">
		select
			tc.Mcodigo, 
			tc.TCcompra, 
			tc.TCventa as TCventa
		from 
			Htipocambio tc
		where 
			tc.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			and tc.Mcodigo=#url.Mcodigo#
			and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(url.Fecha)#">
			and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(url.Fecha)#">
	</cfquery>
</cfif>
<!----OBTENEMOS LA RETENCION SI EXISTE------->
	<cfif isdefined('url.Rcodigo') and isdefined ('url.Monto') and #url.Rcodigo# neq -1 >
		<!---	<cfoutput>
		<script language="javascript1.2">
		alert("entro");
		</script>
		</cfoutput>--->
		<cfset monto= #url.Monto# >
		<cfquery name="rsRetenciones" datasource="#Session.DSN#">
				select Rporcentaje 
				from Retenciones 
				where Ecodigo = #Session.Ecodigo#
				and Rcodigo = '#url.Rcodigo#'
				order by Rdescripcion
		</cfquery>

		<cfset porcentaje = #rsRetenciones.Rporcentaje# >
		<cfset monto = #replace(monto,',','','ALL')#>
		<cfset montoRetencion = ((porcentaje)/100* monto)> <!---Calculo del % de retencion-	--->
		<!---<cfoutput>
		<script language="javascript1.2">
		alert("#montoRetencion#");
		</script>
		</cfoutput>--->
	<cfelse>
		<cfset porcentaje = 0 >
		<cfset monto = 0>
		<cfset montoRetencion = 0>
	</cfif>


<cfoutput>
<script language="javascript1.2" type="text/javascript">
	 window.parent.document.formDet.TotalRetenc.value ="#montoRetencion#";
<!---Caso 1 (Mlocal=MLiquidacion=Mdetalle)--->
	if (#rsMonedaLocal.Mcodigo# == #MonedaEncabezado.Mcodigo# && #MonedaEncabezado.Mcodigo# ==#McodigoDet# ) {	
			<cfif isdefined ('url.tipo')>
				window.parent.document.formDet.GELGtipoCambio.value = "#url.tipo#";
				window.parent.document.formDet.GELGtipoCambio.disabled = false;
			<cfelse>
				window.parent.document.formDet.GELGtipoCambio.value = <cfif isdefined("TCSug") and len(trim(TCSug.TCventa))>#TCSug.TCventa#<cfelse>1</cfif>;
				window.parent.document.formDet.GELGtipoCambio.disabled = true;
			</cfif>
				window.parent.document.formDet.factor.value='1';
				window.parent.document.formDet.factor.disabled=true;
					<cfif isdefined ('url.Monto')>
						window.parent.document.formDet.MontoAnti.value="#url.Monto#"
						window.parent.document.formDet.MontoAnti.disabled=true;
					<cfelse>
						window.parent.document.formDet.MontoAnti.value=window.parent.document.formDet.GELGtotalOri.value;
						window.parent.document.formDet.MontoAnti.disabled=true;
						
					</cfif>		
				   window.parent.document.formDet.MontoRetencionAnti.value=window.parent.document.formDet.TotalRetenc.value;
				   window.parent.document.formDet.MontoRetencionAnti.disabled=true;
					
						
	}
<!---Caso 2 (Mlocal=MLiquidacion!=Mdetalle)--->
		if(#rsMonedaLocal.Mcodigo# == #MonedaEncabezado.Mcodigo# && #MonedaEncabezado.Mcodigo#!=#McodigoDet#){
			<cfif isdefined ('url.tipo')>
				window.parent.document.formDet.GELGtipoCambio.value = "#url.tipo#";
				window.parent.document.formDet.GELGtipoCambio.disabled = false;
				var TCdoc="#url.tipo#";
			<cfelse>
				window.parent.document.formDet.GELGtipoCambio.value = <cfif isdefined("TCSug") and len(trim(TCSug.TCventa))>#TCSug.TCventa#<cfelse>1</cfif>;
				window.parent.document.formDet.GELGtipoCambio.disabled = false;
				var TCdoc=<cfif isdefined("TCSug") and len(trim(TCSug.TCventa))>#TCSug.TCventa#<cfelse>1</cfif>;
			</cfif>								
			var TCliq=#MonedaEncabezado.GELtipoCambio#;	
			var FC= TCdoc/TCliq;
				window.parent.document.formDet.factor.value=fm(FC,4);
				window.parent.document.formDet.factor.disabled=true;
			<cfif isdefined ('url.Monto')>
				window.parent.document.formDet.GELGtotalOri.value = "#url.Monto#";
				window.parent.document.formDet.GELGtotalOri.disabled = false;
				var MontoDoc="#url.Monto#";
			<cfelse>
				window.parent.document.formDet.GELGtotalOri.value =window.parent.document.formDet.GELGtotalOri.value;
				window.parent.document.formDet.GELGtotalOri.disabled = false;
				var MontoDoc=window.parent.document.formDet.GELGtotalOri.value;
			</cfif>		
			FC = FC + "";
			var MTotal= parseFloat(qf(MontoDoc))*parseFloat(qf(FC));
			window.parent.document.formDet.MontoAnti.value=MTotal;
			window.parent.document.formDet.MontoAnti.disabled=true;
			var MRetencion = window.parent.document.formDet.TotalRetenc.value;
			var MTotalRetencion = parseFloat(qf(MRetencion))*parseFloat(qf(FC));
		    window.parent.document.formDet.MontoRetencionAnti.value=MTotalRetencion;
			window.parent.document.formDet.MontoRetencionAnti.disabled=true;

		}
<!---Caso 3 (MLiquidacion!=Mdetalle==Mlocal)--->
		if( #MonedaEncabezado.Mcodigo# !=  #McodigoDet# && #McodigoDet# == #rsMonedaLocal.Mcodigo#){
			<cfif isdefined ('url.tipo')>
				window.parent.document.formDet.GELGtipoCambio.value = "#url.tipo#";
				window.parent.document.formDet.GELGtipoCambio.disabled = true;
				var TCdoc="#url.tipo#";
			<cfelse>
				window.parent.document.formDet.GELGtipoCambio.value = <cfif isdefined("TCSug") and len(trim(TCSug.TCventa))>#TCSug.TCventa#<cfelse>1</cfif>;
				window.parent.document.formDet.GELGtipoCambio.disabled = true;
				var TCdoc=<cfif isdefined("TCSug") and len(trim(TCSug.TCventa))>#TCSug.TCventa#<cfelse>1</cfif>;
			</cfif>			
			var TCliq=#MonedaEncabezado.GELtipoCambio#;
			if (TCliq == 0) {
			TCliq=1;
			}
			var FC= TCdoc/TCliq;
			window.parent.document.formDet.factor.value=fm(FC,4);
			window.parent.document.formDet.factor.disabled=true;
				<cfif isdefined ('url.Monto')>
				window.parent.document.formDet.GELGtotalOri.value = "#url.Monto#";
				window.parent.document.formDet.GELGtotalOri.disabled = false;
				var MontoDoc="#url.Monto#";
			<cfelse>
				window.parent.document.formDet.GELGtotalOri.value =window.parent.document.formDet.GELGtotalOri.value;
				window.parent.document.formDet.GELGtotalOri.disabled = false;
				var MontoDoc=window.parent.document.formDet.GELGtotalOri.value;
			</cfif>		
			FC = FC + "";
			var MTotal= parseFloat(qf(MontoDoc))*parseFloat(qf(FC));
			window.parent.document.formDet.MontoAnti.value=MTotal;
			window.parent.document.formDet.MontoAnti.disabled=true;
			var MRetencion = window.parent.document.formDet.TotalRetenc.value;			
			var MTotalRetencion = parseFloat(qf(MRetencion))*parseFloat(qf(FC));
			window.parent.document.formDet.MontoRetencionAnti.value=MTotalRetencion;
			window.parent.document.formDet.MontoRetencionAnti.disabled=true;
		}
		
<!---Caso 4 (MLiquidacion==Mdetalle)--->
		if( #MonedaEncabezado.Mcodigo# ==  #McodigoDet# ){
			<cfif isdefined ('url.tipo')>
				window.parent.document.formDet.GELGtipoCambio.value = "#url.tipo#";
				window.parent.document.formDet.GELGtipoCambio.disabled = true;
				var TCdoc="#url.tipo#";
			<cfelse>
				window.parent.document.formDet.GELGtipoCambio.value = <cfif isdefined("TCSug") and len(trim(TCSug.TCventa))>#TCSug.TCventa#<cfelse>1</cfif>;
				window.parent.document.formDet.GELGtipoCambio.disabled = true;
				var TCdoc=<cfif isdefined("TCSug") and len(trim(TCSug.TCventa))>#TCSug.TCventa#<cfelse>1</cfif>;
			</cfif>				
			var TCliq=#MonedaEncabezado.GELtipoCambio#;
			if (TCliq == 0) {
			TCliq=1;}
			var FC= TCdoc/TCliq;
			window.parent.document.formDet.factor.value=fm(FC,4);
			window.parent.document.formDet.factor.disabled=true;
			
			<cfif isdefined ('url.Monto')>
				window.parent.document.formDet.GELGtotalOri.value = "#url.Monto#";
				window.parent.document.formDet.GELGtotalOri.disabled = false;
				var MontoDoc="#url.Monto#";
			<cfelse>
				window.parent.document.formDet.GELGtotalOri.value =window.parent.document.formDet.GELGtotalOri.value;
				window.parent.document.formDet.GELGtotalOri.disabled = false;
				var MontoDoc=window.parent.document.formDet.GELGtotalOri.value;
			</cfif>		
			FC = FC + "";
			var MontoDoc=window.parent.document.formDet.GELGtotalOri.value;
			var MTotal= parseFloat(qf(MontoDoc))*parseFloat(qf(FC));
			window.parent.document.formDet.MontoAnti.value=MTotal;
			window.parent.document.formDet.MontoAnti.disabled=true;
			var MRetencion = window.parent.document.formDet.TotalRetenc.value;			
			var MTotalRetencion = parseFloat(qf(MRetencion))*parseFloat(qf(FC));
			window.parent.document.formDet.MontoRetencionAnti.value=MTotalRetencion;
			window.parent.document.formDet.MontoRetencionAnti.disabled=true;
			
		}
<!---Caso 5 (MLiquidacion!=Mdetalle)--->
		if( #MonedaEncabezado.Mcodigo# !=  #McodigoDet# && #McodigoDet# != #rsMonedaLocal.Mcodigo#){
		<cfif isdefined('url.factor')>
			var FC= "#url.factor#";
			var TCliq=#MonedaEncabezado.GELtipoCambio#;
			var TCdoc= FC* TCliq;
			window.parent.document.formDet.GELGtipoCambio.value=TCdoc;
			FC = FC + "";
			var MontoDoc=window.parent.document.formDet.GELGtotalOri.value;
			var MTotal= parseFloat(qf(MontoDoc))*parseFloat(qf(FC));
			window.parent.document.formDet.MontoAnti.value=MTotal;
			window.parent.document.formDet.MontoAnti.disabled=true;		
			window.parent.document.formDet.factor.value="#url.factor#";
			window.parent.document.formDet.factor.disabled=false;
			var MRetencion = window.parent.document.formDet.TotalRetenc.value;			
			var MTotalRetencion = parseFloat(qf(MRetencion))*parseFloat(qf(FC));
			window.parent.document.formDet.MontoRetencionAnti.value=MTotalRetencion;
			window.parent.document.formDet.MontoRetencionAnti.disabled=true;

		<cfelse>
		<cfif isdefined ('url.tipo')>
				window.parent.document.formDet.GELGtipoCambio.value = "#url.tipo#";
				window.parent.document.formDet.GELGtipoCambio.disabled = false;
				var TCdoc="#url.tipo#";
			<cfelse>
				window.parent.document.formDet.GELGtipoCambio.value = <cfif isdefined("TCSug") and len(trim(TCSug.TCventa))>#TCSug.TCventa#<cfelse>1</cfif>;
				window.parent.document.formDet.GELGtipoCambio.disabled = false;
				var TCdoc=<cfif isdefined("TCSug") and len(trim(TCSug.TCventa))>#TCSug.TCventa#<cfelse>1</cfif>;
			</cfif>			
			var TCliq=#MonedaEncabezado.GELtipoCambio#;
			if (TCliq == 0) {
			TCliq=1;
			}
			var FC= TCdoc/TCliq;
			window.parent.document.formDet.factor.value=fm(FC,4);
			window.parent.document.formDet.factor.disabled=false;
				<cfif isdefined ('url.Monto')>
				window.parent.document.formDet.GELGtotalOri.value = "#url.Monto#";
				window.parent.document.formDet.GELGtotalOri.disabled = false;
				var MontoDoc="#url.Monto#";
			<cfelse>
				window.parent.document.formDet.GELGtotalOri.value =window.parent.document.formDet.GELGtotalOri.value;
				window.parent.document.formDet.GELGtotalOri.disabled = false;
				var MontoDoc=window.parent.document.formDet.GELGtotalOri.value;
			</cfif>		
			MontoDoc=MontoDoc+"";
			FC = FC + "";
			var MTotal= parseFloat(qf(MontoDoc))*parseFloat(qf(FC));
			window.parent.document.formDet.MontoAnti.value=MTotal;
			window.parent.document.formDet.MontoAnti.disabled=true;
			var MRetencion = window.parent.document.formDet.TotalRetenc.value;			
			var MTotalRetencion = parseFloat(qf(MRetencion))*parseFloat(qf(FC));
			window.parent.document.formDet.MontoRetencionAnti.value=MTotalRetencion;
			window.parent.document.formDet.MontoRetencionAnti.disabled=true;

			</cfif>
		}

</script>
</cfoutput>
</cfif>	


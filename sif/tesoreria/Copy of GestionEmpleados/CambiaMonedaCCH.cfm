<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>

<!---Query que busca la moneda local--->
<cfif #url.Mcodigo# neq 'undefined'>
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
			select 
				<cf_dbfunction name="to_char" args="Mcodigo"> as Mcodigo 
			from 
				Empresas
			where 
				Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
</cfquery>

	
<!---Query que busca moneda de la caja chica--->
<cfif isdefined('url.id_caja')>
	<cfquery name="MonedaCCH" datasource="#session.dsn#">
		select 
			Mcodigo		
		from 
			CCHica
		where 
			CCHid=#url.id_caja#
	</cfquery>
</cfif>

<!---<cfdump var="#TCsug#">--->



<!---Query que busca la moneda del deposito(la trae del combo bancos)--->
<cfif isdefined('url.Mcodigo') and len(trim(url.Mcodigo))>
	<cfquery name="rsMoneda" datasource="#session.DSN#">
		select
			Mcodigo, 
			Mnombre,
			Miso4217
		from 
			Monedas
		where 
			Mcodigo=#url.Mcodigo#
			and 
			Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
<cfset McodigoOri='#url.Mcodigo#'>
</cfif>

<!---Query que busca el tipo de Cambio de la moneda de la caja--->
<cfquery name="TCsugC" datasource="#session.dsn#">
		select tc.Mcodigo, tc.TCcompra, tc.TCventa
		from Htipocambio tc
		where tc.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
		  and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
		  and Mcodigo=#MonedaCCH.Mcodigo#
</cfquery>
<cfif TCsugC.recordcount eq 0>
	<cfset TCcch=1>
<cfelse>
	<cfset TCcch=#TCsugC.TCventa#>
</cfif>
<!---Query que busca el tipo de Cambio de la moneda del deposito--->
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

<cfoutput>
<script language="javascript1.2" type="text/javascript">
<!---Caso 1 (Mlocal=MLiquidacion=Mdetalle)--->
	if (#rsMonedaLocal.Mcodigo# == #MonedaCCH.Mcodigo# && #MonedaCCH.Mcodigo# ==#McodigoOri# ) {	
		//alert('caso 1:todas iguales');
			<cfif isdefined ('url.tipo')>
				window.parent.document.formDep.tipoCambio.value = "#url.tipo#";
				window.parent.document.formDep.tipoCambio.disabled = false;
			<cfelse>
				window.parent.document.formDep.tipoCambio.value = <cfif isdefined("TCSug") and len(trim(TCSug.TCventa))>#TCSug.TCventa#<cfelse>1</cfif>;
				window.parent.document.formDep.tipoCambio.disabled = true;
			</cfif>
				window.parent.document.formDep.factor.value='1';
				window.parent.document.formDep.factor.disabled=true;
					<cfif isdefined ('url.Monto')>
						window.parent.document.formDep.totalD.value=fm("#url.Monto#",4)
						window.parent.document.formDep.totalD.disabled=true;
					<cfelse>
						window.parent.document.formDep.totalD.value=fm(window.parent.document.formDep.montodep.value,4);
						window.parent.document.formDep.totalD.disabled=true;
						window.parent.document.formDep.LvarMo.value="#rsMoneda.Miso4217#"
					</cfif>			
	}
	
<!---Caso 2 (Mlocal=MLiquidacion!=Mdetalle)--->
		if(#rsMonedaLocal.Mcodigo# == #MonedaCCH.Mcodigo# && #MonedaCCH.Mcodigo#!=#McodigoOri#){
//	alert('caso 2: local=liquidacion!=detalle');
			<cfif isdefined ('url.tipo')>
				window.parent.document.formDep.tipoCambio.value = "#url.tipo#";
				window.parent.document.formDep.tipoCambio.disabled = false;
				var TCdoc="#url.tipo#";
			<cfelse>
				window.parent.document.formDep.tipoCambio.value = <cfif isdefined("TCSug") and len(trim(TCSug.TCventa))>#TCSug.TCventa#<cfelse>1</cfif>;
				window.parent.document.formDep.tipoCambio.disabled = false;
				var TCdoc=<cfif isdefined("TCSug") and len(trim(TCSug.TCventa))>#TCSug.TCventa#<cfelse>1</cfif>;
			</cfif>								
			var TCliq=#TCcch#;	
			var FC= TCdoc/TCliq;
				window.parent.document.formDep.factor.value=fm(FC,4);
				window.parent.document.formDep.factor.disabled=true;
			<cfif isdefined ('url.Monto')>
				window.parent.document.formDep.montodep.value = "#url.Monto#";
				window.parent.document.formDep.montodep.disabled = false;
				var MontoDoc="#url.Monto#";
			<cfelse>
				window.parent.document.formDep.montodep.value =window.parent.document.formDep.montodep.value;
				window.parent.document.formDep.montodep.disabled = false;
				var MontoDoc=window.parent.document.formDep.montodep.value;
			</cfif>		
			FC = FC + "";
			var MTotal= parseFloat(qf(MontoDoc))*parseFloat(qf(FC));
			window.parent.document.formDep.totalD.value=fm(MTotal,4);
			window.parent.document.formDep.totalD.disabled=true;
			window.parent.document.formDep.LvarMo.value="#rsMoneda.Miso4217#"
		}

<!---Caso 3 (MLiquidacion!=Mdetalle==Mlocal)--->
		if( #MonedaCCH.Mcodigo# !=  #McodigoOri# && #McodigoOri# == #rsMonedaLocal.Mcodigo#){
			//alert('caso 3: liquidacion!=detalle=local');
			<cfif isdefined ('url.tipo')>
				window.parent.document.formDep.tipoCambio.value = "#url.tipo#";
				window.parent.document.formDep.tipoCambio.disabled = true;
				var TCdoc="#url.tipo#";
			<cfelse>
				window.parent.document.formDep.tipoCambio.value = <cfif isdefined("TCSug") and len(trim(TCSug.TCventa))>#TCSug.TCventa#<cfelse>1</cfif>;
				window.parent.document.formDep.tipoCambio.disabled = true;
				var TCdoc=<cfif isdefined("TCSug") and len(trim(TCSug.TCventa))>#TCSug.TCventa#<cfelse>1</cfif>;
			</cfif>			
			var TCliq=#TCcch#;
			if (TCliq == 0) {
			//alert('igual a 0 como numero');
			TCliq=1;
			}
			var FC= TCdoc/TCliq;
			window.parent.document.formDep.factor.value=fm(FC,4);
			window.parent.document.formDep.factor.disabled=true;
				<cfif isdefined ('url.Monto')>
				window.parent.document.formDep.montodep.value = "#url.Monto#";
				window.parent.document.formDep.montodep.disabled = false;
				var MontoDoc="#url.Monto#";
			<cfelse>
				window.parent.document.formDep.montodep.value =window.parent.document.formDep.montodep.value;
				window.parent.document.formDep.montodep.disabled = false;
				var MontoDoc=window.parent.document.formDep.montodep.value;
			</cfif>		
			FC = FC + "";
			var MTotal= parseFloat(qf(MontoDoc))*parseFloat(qf(FC));
			window.parent.document.formDep.totalD.value=fm(MTotal,4);
			window.parent.document.formDep.totalD.disabled=true;
			window.parent.document.formDep.LvarMo.value="#rsMoneda.Miso4217#"

		}
		
<!---Caso 4 (MLiquidacion==Mdetalle)--->
		if( #MonedaCCH.Mcodigo# ==  #McodigoOri# ){
			//alert('caso 4: liquidacion=detalle');
			<cfif isdefined ('url.tipo')>
				window.parent.document.formDep.tipoCambio.value = "#url.tipo#";
				window.parent.document.formDep.tipoCambio.disabled = true;
				var TCdoc="#url.tipo#";
			<cfelse>
				window.parent.document.formDep.tipoCambio.value = <cfif isdefined("TCSug") and len(trim(TCSug.TCventa))>#TCSug.TCventa#<cfelse>1</cfif>;
				window.parent.document.formDep.tipoCambio.disabled = true;
				var TCdoc=<cfif isdefined("TCSug") and len(trim(TCSug.TCventa))>#TCSug.TCventa#<cfelse>1</cfif>;
			</cfif>				
			var TCliq=#TCcch#;
			if (TCliq == 0) {
			TCliq=1;}
			var FC= TCdoc/TCliq;
			window.parent.document.formDep.factor.value=fm(FC,4);
			window.parent.document.formDep.factor.disabled=true;
			
			<cfif isdefined ('url.Monto')>
				window.parent.document.formDep.montodep.value = "#url.Monto#";
				window.parent.document.formDep.montodep.disabled = false;
				var MontoDoc="#url.Monto#";
			<cfelse>
				window.parent.document.formDep.montodep.value =window.parent.document.formDep.montodep.value;
				window.parent.document.formDep.montodep.disabled = false;
				var MontoDoc=window.parent.document.formDep.montodep.value;
			</cfif>		
			FC = FC + "";
			var MontoDoc=window.parent.document.formDep.montodep.value;
			var MTotal= parseFloat(qf(MontoDoc))*parseFloat(qf(FC));
			window.parent.document.formDep.totalD.value=fm(MTotal,4);
			window.parent.document.formDep.totalD.disabled=true;
			window.parent.document.formDep.LvarMo.value="#rsMoneda.Miso4217#"

		}
<!---Caso 5 (MLiquidacion!=Mdetalle)--->
		if( #MonedaCCH.Mcodigo# !=  #McodigoOri# && #McodigoOri# != #rsMonedaLocal.Mcodigo#){
	//alert('caso 5: liquidacion!=detalle');
		<cfif isdefined('url.factor')>
			var FC= "#url.factor#";
			var TCliq=#TCcch#;
			var TCdoc= FC* TCliq;
			window.parent.document.formDep.tipoCambio.value=TCdoc;
			FC = FC + "";
			var MontoDoc=window.parent.document.formDep.montodep.value;
			var MTotal= parseFloat(qf(MontoDoc))*parseFloat(qf(FC));
			window.parent.document.formDep.totalD.value=fm(MTotal,4);
			window.parent.document.formDep.totalD.disabled=true;		
			window.parent.document.formDep.factor.value="#url.factor#";
			window.parent.document.formDep.factor.disabled=false;
		<cfelse>
		<cfif isdefined ('url.tipo')>
				window.parent.document.formDep.tipoCambio.value = "#url.tipo#";
				window.parent.document.formDep.tipoCambio.disabled = false;
				var TCdoc="#url.tipo#";
			<cfelse>
				window.parent.document.formDep.tipoCambio.value = <cfif isdefined("TCSug") and len(trim(TCSug.TCventa))>#TCSug.TCventa#<cfelse>1</cfif>;
				window.parent.document.formDep.tipoCambio.disabled = false;
				var TCdoc=<cfif isdefined("TCSug") and len(trim(TCSug.TCventa))>#TCSug.TCventa#<cfelse>1</cfif>;
			</cfif>			
			var TCliq=#TCcch#;
			if (TCliq == 0) {
			//alert('igual a 0 como numero');
			TCliq=1;
			}
			var FC= TCdoc/TCliq;
			window.parent.document.formDep.factor.value=fm(FC,4);
			window.parent.document.formDep.factor.disabled=false;
				<cfif isdefined ('url.Monto')>
				window.parent.document.formDep.montodep.value = "#url.Monto#";
				window.parent.document.formDep.montodep.disabled = false;
				var MontoDoc="#url.Monto#";
			<cfelse>
				window.parent.document.formDep.montodep.value =window.parent.document.formDep.montodep.value;
				window.parent.document.formDep.montodep.disabled = false;
				var MontoDoc=window.parent.document.formDep.montodep.value;
			</cfif>		
			MontoDoc=MontoDoc+"";
			FC = FC + "";
			var MTotal= parseFloat(qf(MontoDoc))*parseFloat(qf(FC));
			window.parent.document.formDep.totalD.value=fm(MTotal,4);
			window.parent.document.formDep.totalD.disabled=true;
			window.parent.document.formDep.LvarMo.value="#rsMoneda.Miso4217#"

			</cfif>
		}

</script>
</cfoutput>
</cfif>	


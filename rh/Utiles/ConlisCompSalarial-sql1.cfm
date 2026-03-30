<cfif isdefined("Form.CSid") and Len(Trim(Form.CSid))>
	<cfset pDLffin = createDate(6100,01,01)>
	<cfquery name="rsAccion" datasource="#Session.DSN#">
		select DEid,RHJid,DLfvigencia, coalesce(DLffin, <cfqueryparam cfsqltype="cf_sql_date" value="#pDLffin#"> ) as DLffin, 
        	coalesce(RHCPlinea, 0) as RHCPlinea,RHAporcsal,RHPcodigoAlt,coalesce(RHCPlineaP,0) as RHCPlineaP
		from RHAcciones
		where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
	</cfquery>
    <cfset Lvar_CatAlt = rsAccion.RHCPlinea>
	<!--- VERIFICAR SI TIENE UN PUESTO ALTERNO QUE CAMBIA LA CATEGORIA --->
    <cfset Lvar_RHTTid = 0>
    <cfset Lvar_RHMPPid = 0>
    <cfset Lvar_RHCid = 0>
    <cfquery name="rsCatPuestoAlt" datasource="#session.DSN#">
        select RHCPlinea
        from RHPuestos a
        inner join RHMaestroPuestoP b
            on b.RHMPPid = a.RHMPPid
            and b.Ecodigo = a.Ecodigo
        inner join RHCategoriasPuesto c
            on c.RHMPPid = b.RHMPPid
            and c.Ecodigo = b.Ecodigo
        where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsAccion.RHPcodigoAlt#">
          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    </cfquery>
    <cfif isdefined('rsCatPuestoAlt') and rsCatPuestoAlt.RecordCount>
        <cfset Lvar_CatAlt = rsCatPuestoAlt.RHCPlinea>
    </cfif>
    
    <cfif usaEstructuraSalarial EQ 1 >
        <cfinvoke 
         component="rh.Componentes.RH_EstructuraSalarial"
         method="calculaComponente"
         returnvariable="calculaComponenteRet">
            <cfinvokeargument name="CSid" value="#Form.CSid#"/>
            <cfinvokeargument name="fecha" value="#rsAccion.DLfvigencia#"/>
            <cfinvokeargument name="fechah" value="#rsAccion.DLffin#"/>
            <cfinvokeargument name="RHCPlinea" value="#Lvar_CatAlt#"/>
            <cfinvokeargument name="RHCPlineaP" value="#rsAccion.RHCPlineaP#"/>
            <cfinvokeargument name="BaseMontoCalculo" value="0.00"/>
            <cfinvokeargument name="negociado" value="#LvarNegociado EQ 1#"/>
            <cfinvokeargument name="Ecodigo" value="#LvarEmpresa#"/>
            <cfinvokeargument name="Unidades" value="1.00"/>
            <cfinvokeargument name="MontoBase" value="0.00"/>
            <cfinvokeargument name="Monto" value="0.00"/>
            <cfinvokeargument name="TablaComponentes" value="RHDAcciones"/>
            <cfinvokeargument name="CampoLlaveTC" value="RHAlinea"/>
            <cfinvokeargument name="ValorLlaveTC" value="#Form.id#"/>
            <cfinvokeargument name="CampoMontoTC" value="RHDAmontores"/>
            <cfinvokeargument name="validarNegociado" value="false"/>
            <cfinvokeargument name="DEid" value="#rsAccion.DEid#"/>
            <cfinvokeargument name="PorcSalario" value="#rsAccion.RHAporcsal#"/>
        </cfinvoke>
        
        <cfset unidades = calculaComponenteRet.Unidades>
        <cfset montobase = calculaComponenteRet.MontoBase>
        <cfset monto = calculaComponenteRet.Monto>
        <cfset Metodo = calculaComponenteRet.Metodo>
	<cfelse>
		<!---Se llama a la calculadora --->
		<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>
		<cfquery name="rsConceptos" datasource="#session.dsn#">
			select 			a.DLfvigencia, 
						   a.DLffin, 
						   a.DEid, 
						   a.Ecodigo,			
						   a.RHTid, 
						   a.RHAlinea, 
						   coalesce(a.RHJid, 0) as RHJid						   
			from 
				RHAcciones a
				where RHAlinea=#form.id#
		</cfquery>
		<cfquery name="rsConceptosI" datasource="#session.dsn#">			  
			select c.CIid, c.CIcantidad, c.CIrango, c.CItipo, c.CIcalculo, c.CIdia, c.CImes
				,CIsprango, coalesce(CIspcantidad,0) as CIspcantidad, coalesce(CImescompleto,0) as CImescompleto 
				from ComponentesSalariales d
				  inner join CIncidentes i
					inner join CIncidentesD c
					on c.CIid=i.CIid
				  on d.CIid=i.CIid
			  where d.CSid=#form.CSid#
		</cfquery>
		<cfif len(trim(rsConceptos.DLfvigencia)) gt 0>
			<cfset FVigencia = LSDateFormat(rsConceptos.DLfvigencia, 'DD/MM/YYYY')>
		<cfelse>
			<cfset FVigencia = LSDateFormat(#now()#, 'DD/MM/YYYY')>
		</cfif>
		<cfif len(trim(rsConceptos.DLffin)) gt 0>
			<cfset FFin = LSDateFormat(rsConceptos.DLffin, 'DD/MM/YYYY')>
		<cfelse>
			<cfset FFin = '01/01/6100'>
		</cfif>
        <cfif rsConceptosI.RecordCount NEQ 0> 
			<cfloop query="rsConceptos">						
					<cfset current_formulas = rsConceptosI.CIcalculo>
					<cfset presets_text = RH_Calculadora.get_presets(CreateDate(ListGetAt(FVigencia,3,'/'), ListGetAt(FVigencia,2,'/'), ListGetAt(FVigencia,1,'/')),
												   CreateDate(ListGetAt(FFin,3,'/'), ListGetAt(FFin,2,'/'), ListGetAt(FFin,1,'/')),
												   rsConceptosI.CIcantidad,
												   rsConceptosI.CIrango,
												   rsConceptosI.CItipo,
												   rsConceptos.DEid,
												   rsConceptos.RHJid,
												   rsConceptos.Ecodigo,
												   rsConceptos.RHTid,
												   rsConceptos.RHAlinea,
												   rsConceptosI.CIdia,
												   rsConceptosI.CImes,
												   "", <!--- Tcodigo solo se requiere si no va RHAlinea--->
												   FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo más pesado--->
												   'false',
												   '',
												   FindNoCase('DiasRealesCalculoNomina', current_formulas) <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
												   , 0
												   , '' 
												   ,rsConceptosI.CIsprango
												   ,rsConceptosI.CIspcantidad
												   ,rsConceptosI.CImescompleto)>												   	
					<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
                    <cfset calc_error = RH_Calculadora.getCalc_error()>
					<cfif Not IsDefined("values")>
						<cfif isdefined("presets_text")>
							<cf_throw message="#presets_text# & '----' & #current_formulas# & '-----' & #calc_error#">
						<cfelse>
							<cf_throw message="#calc_error#" >
						</cfif>
					</cfif>
					
					<br>Importe><cfdump var="#values.get('importe').toString()#"></br>
					<br>Resultado<cfdump var="#values.get('resultado').toString()#"></br>
					<br>Cantidad<cfdump var="#values.get('cantidad').toString()#"></br>				 
				</cfloop>	
		<cfset unidades = #values.get('cantidad').toString()#>
        <cfset montobase = #values.get('resultado').toString()#>
        <cfset monto = #values.get('resultado').toString()#>
        <cfset Metodo = 'M'>
        <cfelse>
        	<cfset unidades 	= 0>
			<cfset montobase 	= 0>
            <cfset monto 		= 0>
            <cfset Metodo 		= 'M'>
        </cfif>
	</cfif>
	<cftransaction>
		<cfquery name="insertComponente" datasource="#Session.DSN#">
			insert into RHDAcciones (RHAlinea, CSid, RHDAunidad, RHDAmontobase, RHDAmontores,RHDAmetodoC, Usucodigo, Ulocalizacion)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CSid#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#unidades#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#montobase#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#monto#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#metodo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
			)
		</cfquery>
	
		<!--- Recalcular todos los componentes --->
		<cfquery name="rsComp" datasource="#Session.DSN#">
			select a.RHDAlinea, a.CSid, a.RHDAunidad, a.RHDAmontobase, a.RHDAmontores,a.RHDAmetodoC
			from RHDAcciones a
				inner join ComponentesSalariales b
					on b.CSid = a.CSid
			where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
			order by b.CSorden, b.CScodigo, b.CSdescripcion
		</cfquery>
		
	</cftransaction>

	<script language="JavaScript" type="text/javascript">
		if (window.opener.document.form1) {
			if (window.opener.document.form1.reloadPage) window.opener.document.form1.reloadPage.value = "1";
			window.opener.document.form1.submit();
			window.close();
		}
	</script>
</cfif>

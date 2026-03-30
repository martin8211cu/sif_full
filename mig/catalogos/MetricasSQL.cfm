
<cfparam name="pagenum" default="1">
<cfif isdefined('form.pagenum1') and len(trim(form.pagenum1))>
	<cfset pagenum = form.pagenum1>
</cfif> 
<cfif isdefined('url.pagenum1') and len(trim(url.pagenum1))>
	<cfset pagenum = url.pagenum1>
</cfif> 

<cfif isdefined ('form.Calcular')>
	<cfinvoke component="mig.Componentes.Procesos" method="Calcular" returnvariable="resultt">
		<cfinvokeargument name="MIGMid" 			value="#form.MIGMid#"/>
		<cfinvokeargument name="CEcodigo" 		value="#session.CEcodigo#"/>
	</cfinvoke>
	<cflocation url="Metricas.cfm?MIGMid=#MIGMid#&modo=#modo#&tab=1&pagenum1=#pagenum#">
</cfif>

<!---<cf_dump var ="#form#">--->
<cfif isdefined ('form.Formular')>
	<cflocation url="Metricas-formular.cfm?modo=#form.modo#&MIGMid=#form.MIGMid#&esMetric=M&tab=1&pagenum1=#pagenum#">
</cfif>
<cfif isdefined ('form.Regresar')>
	<cflocation url="Metricas.cfm?pagenum1=#pagenum#">
</cfif>

<cfif isdefined ('form.Lista')>
	<cflocation url="Metricas.cfm?pagenum1=#pagenum#">
</cfif>
<cfif isdefined ('form.Importar')>
	<cflocation url="MetricasImportador.cfm?tab=1&pagenum1=#pagenum#">
</cfif>

<cfif isdefined ('form.Borrar_Calculados')><!--- Borra los datos calculados de una metrica en especifico--->
	<cfinvoke component="mig.Componentes.Metricas" method="BajaCalculados" returnvariable="rs">
		<cfinvokeargument name="MIGMid" 		value="#form.MIGMid#"/>
	</cfinvoke>
	<cflocation url="Metricas.cfm?modo=#form.modo#&MIGMid=#form.MIGMid#&esMetric=M&tab=1&pagenum1=#pagenum#">
</cfif>


<cfif isdefined('form.BajaFiltrosMetricas') and form.BajaFiltrosMetricas EQ true>

	<cfinvoke component="mig.Componentes.Metricas" method="BajaFiltrosVariables" returnvariable="rs">
		<cfinvokeargument name="MIGMid" 		value="#form.MIGMidHijo#"/>
		<cfinvokeargument name="MIGMidderivada" 	value="#form.MIGMidPadre#"/>
		<cfinvokeargument name="MIGMdetalleid" 	value="#form.MIGMdetalleid#"/>
	</cfinvoke>
	
	<cfset modo="Cambio">
	<cflocation url="Metricas.cfm?MIGMid=#MIGMid#&modo=#modo#&tab=#form.tab#&pagenum1=#pagenum#">
</cfif>

<cfif isdefined ('form.valsInMet') and len(form.valsInMet) and isdefined('form.MIGMidderivada') and len(form.MIGMidderivada) >
	<cfinvoke component="mig.Componentes.Metricas" method="BajaFiltrosVariables" returnvariable="rs">
		<cfinvokeargument name="MIGMid" 			value="#form.MIGMidderivada#"/>
		<cfinvokeargument name="MIGMidderivada" 	value="#form.MIGMid#"/>
	</cfinvoke>	
	
	<cfif len(trim(form.valsInMet)) and isdefined('form.MIGMidderivada') and len(form.MIGMidderivada)>
		<cfloop list="#form.valsInMet#" index="val">
			<cfinvoke component="mig.Componentes.Metricas" method="AltaFiltrosVariables" returnvariable="MIGFMid">
				<cfinvokeargument name="MIGMid" 		value="#form.MIGMidderivada#"/>
				<cfinvokeargument name="Tipo" 			value="#form.rfiltro#"/>
				<cfinvokeargument name="valor" 			value="#val#"/>
				<cfinvokeargument name="CEcodigo" 		value="#session.CEcodigo#"/>
				<cfinvokeargument name="MIGMidderivada"value="#form.MIGMid#"/>
			</cfinvoke>
		</cfloop>
	</cfif>
	<cfset modo="Cambio">
	<cflocation url="Metricas.cfm?MIGMid=#MIGMid#&modo=#modo#&tab=#form.tab#&pagenum1=#pagenum#">
</cfif>
 
<cfif isdefined ('form.valsIn')>
	
	<cfinvoke component="mig.Componentes.Metricas" method="UpdateType" returnvariable="rs">
		<cfinvokeargument name="MIGMid" 			value="#form.MIGMid#"/>
		<cfinvokeargument name="MIGMTIPODETALLE" 			value="#form.rfiltro#"/>
	</cfinvoke>	
	
	<cfinvoke component="mig.Componentes.Metricas" method="BajaFiltros" returnvariable="rs">
		<cfinvokeargument name="MIGMid" 			value="#form.MIGMid#"/>
	</cfinvoke>	
	
	<cfif len(trim(form.valsIn))>
		<cfloop list="#form.valsIn#" index="val">
			<cfinvoke component="mig.Componentes.Metricas" method="AltaFiltros" returnvariable="MIGFMid">
				<cfinvokeargument name="MIGMid" 			value="#form.MIGMid#"/>
				<cfinvokeargument name="Tipo" 			value="#form.rfiltro#"/>
				<cfinvokeargument name="valor" 			value="#val#"/>
				<cfinvokeargument name="CEcodigo" 		value="#session.CEcodigo#"/>
			</cfinvoke>
		</cfloop>
	</cfif>
	
	<cfset modo="Cambio">
	<cfquery datasource="#session.dsn#" name="rsDonde">
		select count(1)as esIndicador from MIGMetricas where Ecodigo = #session.Ecodigo# and MIGMid=#MIGMid# and MIGMesmetrica = 'I'
	</cfquery>
	<cfif rsDonde.esIndicador gt 0>
		<cflocation url="Indicadores.cfm?MIGMid=#MIGMid#&modo=#modo#&tab=#form.tab#&pagenum1=#pagenum#">
	<cfelse>	
		<cflocation url="Metricas.cfm?MIGMid=#MIGMid#&modo=#modo#&tab=#form.tab#&pagenum1=#pagenum#">
	</cfif>
	
</cfif>

<cfif isdefined ('form.ALTA')>
	<cfquery name="rsValida" datasource="#session.dsn#">
		select upper(rtrim(a.MIGMcodigo)) as MIGMcodigo,a.Ecodigo,b.Edescripcion
		from MIGMetricas a
			inner join Empresas b
			on b.Ecodigo = a.Ecodigo 
		where upper(a.MIGMcodigo)=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(trim(form.MIGMcodigo))#">
	</cfquery>
	<cfif rsValida.recordCount eq 0>
		<cfset LvarCodigoM=form.MIGMcodigo>
		<cfset LvarCod=mid(LvarCodigoM,1,1)>
		<cfif LvarCod GTE 0 and LvarCod LTE 9 or LvarCod EQ '-' or LvarCod EQ '+' or LvarCod EQ '/' or LvarCod EQ '*'>
			<cfthrow type="toUser" message="El formato del código esta incorrecto. El código solo puede recibir valores alfanuméricos.">
		<cfelse>	
				<cfparam name="form.Dactiva" default="1">
				<cftransaction>
					<cfinvoke component="mig.Componentes.Metricas" method="Alta" returnvariable="MIGMid">
						<cfinvokeargument name="MIGMcodigo" 			value="#form.MIGMcodigo#"/>
						<cfinvokeargument name="MIGMnombre" 			value="#form.MIGMnombre#"/>
						<cfinvokeargument name="MIGReid" 				value="#form.MIGReid#"/>
						<cfinvokeargument name="Dactiva" 				value="#form.Dactiva#"/>
					<cfif form.Ucodigo NEQ "">
						<cfinvokeargument name="Ucodigo" 				value="#form.Ucodigo#"/>
					<cfelse>
						<cfinvokeargument name="Ucodigo" 				value="-1"/>
					</cfif>
					<cfif form.MIGMdescripcion NEQ "">
						<cfinvokeargument name="MIGMdescripcion" 		value="#form.MIGMdescripcion#"/>
					<cfelse>
						<cfinvokeargument name="MIGMdescripcion" 		value=""/>
					</cfif>
					<cfif form.MIGMnpresentacion NEQ "">
						<cfinvokeargument name="MIGMnpresentacion" 		value="#form.MIGMnpresentacion#"/>
					<cfelse>
						<cfinvokeargument name="MIGMnpresentacion" 		value=""/>
					</cfif>
					<cfif form.MIGMsequencia NEQ "" >
						<cfinvokeargument name="MIGMsequencia" 			value="#form.MIGMsequencia#"/>
					<cfelse>
						<cfinvokeargument name="MIGMsequencia" 			value="0"/>
					</cfif>
						<cfinvokeargument name="Dactiva" 				value="1"/>
						<cfinvokeargument name="CodFuente" 				value="1"/>		
					<cfinvokeargument name="MIGMperiodicidad" 		value="#form.periocidad#"/>
					
					<cfif isdefined("form.idTramite") and len(trim(form.idTramite))>
						<cfinvokeargument name="idTramite" 				value="#form.idTramite#"/>
					</cfif>

					</cfinvoke>	
				</cftransaction>
				<cfset modo="Cambio">
				<cflocation url="Metricas.cfm?MIGMid=#MIGMid#&modo=#modo#&tab=1&pagenum1=#pagenum#">
			</cfif>
		<cfelse>
			<cfthrow type="toUser" message="El Código #rsValida.MIGMcodigo# ya existe en Sistema para la empresa #rsValida.Edescripcion# ">
		</cfif>
</cfif>

<cfif IsDefined("form.Boton")and form.Boton eq 'GUARDAFORMULA'> 
	
		<cfquery name="ActualizaFormula" datasource="#session.dsn#">
			update MIGMetricas
			set MIGMcalculo=Ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.formulas#">)
			where MIGMid=#form.MIGMid#	
			and Ecodigo=#session.Ecodigo#
			and CEcodigo=#session.CEcodigo#		
		</cfquery>		
		
		<cfif isdefined ('form.esMetric') and form.esMetric eq 'M'>	
			 <cfset modo="Cambio">			
			<cflocation url="Metricas.cfm?MIGMid=#MIGMid#&modo=#modo#&tab=1&pagenum1=#pagenum#">
		<cfelse>
			 <cfset modo="Cambio">
			<cflocation url="Indicadores.cfm?MIGMid=#MIGMid#&modo=#modo#&tab=1&pagenum1=#pagenum#">
		</cfif>				
</cfif>


<cfif isdefined ('form.CAMBIO')>

	<cftransaction>
		<cfinvoke component="mig.Componentes.Metricas" method="Cambio" >
			<cfinvokeargument name="MIGMnombre" 			value="#form.MIGMnombre#"/>
			<cfinvokeargument name="MIGMid" 				value="#form.MIGMid#"/>
			<cfinvokeargument name="MIGReid" 				value="#form.MIGReid#"/>
			<cfinvokeargument name="Dactiva" 				value="#form.Dactiva#"/>
		<cfif form.Ucodigo NEQ "">
			<cfinvokeargument name="Ucodigo" 				value="#form.Ucodigo#"/>
		<cfelse>
			<cfinvokeargument name="Ucodigo" 				value="-1"/>
		</cfif>
		<cfif form.MIGMdescripcion NEQ "">
			<cfinvokeargument name="MIGMdescripcion" 		value="#form.MIGMdescripcion#"/>
		<cfelse>
			<cfinvokeargument name="MIGMdescripcion" 		value=""/>
		</cfif>
		<cfif form.MIGMnpresentacion NEQ "">
			<cfinvokeargument name="MIGMnpresentacion" 		value="#form.MIGMnpresentacion#"/>
		<cfelse>
			<cfinvokeargument name="MIGMnpresentacion" 		value=""/>
		</cfif>
		<cfif form.MIGMsequencia NEQ "" >
			<cfinvokeargument name="MIGMsequencia" 			value="#form.MIGMsequencia#"/>
		<cfelse>
			<cfinvokeargument name="MIGMsequencia" 			value="0"/>
		</cfif>	
		<cfif isdefined('form.periocidad')>	
		    <cfinvokeargument name="MIGMperiodicidad" 		value="#form.periocidad#"/>	
		</cfif>
		<cfif isdefined("form.idTramite") and len(trim(form.idTramite))>
		      <cfinvokeargument name="idTramite" 					value="#form.idTramite#"/>
		</cfif>
		
		</cfinvoke>	
	</cftransaction>
	<cfset modo="Cambio">
	<cflocation url="Metricas.cfm?MIGMid=#form.MIGMid#&modo=#modo#&pagenum1=#pagenum#">
</cfif>
<cfif isdefined ('form.BAJA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Metricas" method="Baja" >
			<cfinvokeargument name="MIGMid" 		value="#form.MIGMid#"/>
		</cfinvoke>	
	</cftransaction>
	<cflocation url="Metricas.cfm?tab=1">
</cfif>

<cfif isdefined ('form.Nuevo')>
	<cflocation url="Metricas.cfm?Nuevo=true&tab=1">
</cfif>





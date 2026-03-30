
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
	<cflocation url="Metricas.cfm?MIGMid=#MIGMid#&modo=#modo#&tab=#form.tab#">
</cfif>

<cfif isdefined ('form.Formular')>
	<cflocation url="Indicadores-formular.cfm?modo=#form.modo#&MIGMid=#form.MIGMid#&esMetric=I&pagenum1=#pagenum#">
</cfif>

<cfif isdefined ('form.Lista')>
	<cflocation url="Indicadores.cfm?pagenum1=#pagenum#">
</cfif>

<cfif isdefined ('form.Borrar_Calculados')><!--- Borra los datos calculados de un indicador en especifico--->
	<cfinvoke component="mig.Componentes.Metricas" method="BajaCalculados" returnvariable="rs">
		<cfinvokeargument name="MIGMid" 		value="#form.MIGMid#"/>
	</cfinvoke>
	<cflocation url="Indicadores.cfm?modo=#form.modo#&MIGMid=#form.MIGMid#&esMetric=M&tab=1&pagenum1=#pagenum#">
</cfif>


<cfif isdefined('form.BajaFiltrosIndicadores') and form.BajaFiltrosIndicadores EQ true>

	<cfinvoke component="mig.Componentes.Indicadores" method="BajaFiltros" returnvariable="rs">
		<cfinvokeargument name="MIGMid" 			value="#form.MIGMidHijo#"/>
		<cfinvokeargument name="MIGMIDIndicador" 	value="#form.MIGMidPadre#"/>
		<cfinvokeargument name="MIGMdetalleid" 		value="#form.MIGMdetalleid#"/>
	</cfinvoke>

	<cfset modo="Cambio">
	<cflocation url="Indicadores.cfm?MIGMid=#MIGMid#&modo=#modo#&tab=#form.tab#&pagenum1=#pagenum#">
</cfif>

<cfif isdefined ('form.valsInInd') and len(form.valsInInd) and isdefined('form.MIGMIDIndicador') and len(form.MIGMIDIndicador) >
	<cfinvoke component="mig.Componentes.Indicadores" method="BajaFiltros" returnvariable="rs">
		<cfinvokeargument name="MIGMid" 			value="#form.MIGMIDIndicador#"/>
		<cfinvokeargument name="MIGMIDIndicador" 	value="#form.MIGMid#"/>
	</cfinvoke>

	<cfif len(trim(form.valsInInd)) and isdefined('form.MIGMIDIndicador') and len(form.MIGMIDIndicador)>
		<cfloop list="#form.valsInInd#" index="val">
			<cfinvoke component="mig.Componentes.Indicadores" method="AltaFiltros" returnvariable="MIGFMid">
				<cfinvokeargument name="MIGMid" 		value="#form.MIGMIDIndicador#"/>
				<cfinvokeargument name="Tipo" 			value="#form.rfiltro#"/>
				<cfinvokeargument name="valor" 			value="#val#"/>
				<cfinvokeargument name="CEcodigo" 		value="#session.CEcodigo#"/>
				<cfinvokeargument name="MIGMIDIndicador"value="#form.MIGMid#"/>
			</cfinvoke>
		</cfloop>
	</cfif>
	<cfset modo="Cambio">
	<cflocation url="Indicadores.cfm?MIGMid=#MIGMid#&modo=#modo#&tab=#form.tab#&pagenum1=#pagenum#">
</cfif>

<cfif isdefined ('form.CambioAccionesIndicador') and form.CambioAccionesIndicador>

	<cfinvoke component="mig.Componentes.Indicadores" method="AltaDetalle" returnvariable="MIGIDETid">
		<cfinvokeargument name="MIGIDETid" 		value="#form.MIGIDETid#"/>
		<cfinvokeargument name="MIGMid" 		value="#form.MIGMID#"/>
		<cfinvokeargument name="MIGESTid" 		value="#form.MIGESTid#"/>
		<cfinvokeargument name="MIGOEid" 		value="#form.MIGOEid#"/>
		<cfinvokeargument name="MIGFCid" 		value="#form.MIGFCid#"/>
		<cfinvokeargument name="CEcodigo" 		value="#session.CEcodigo#"/>
		<cfinvokeargument name="CodFuente" 		value="1"/>
	</cfinvoke>

	<cflocation url="Indicadores.cfm?MIGMid=#MIGMid#&modo=#modo#&tab=#form.tab#&pagenum1=#pagenum#">
</cfif>

<cfif isdefined ('form.AddAccion')>

	<!---<cfinvoke component="mig.Componentes.Indicadores" method="AltaDetalleAccion" returnvariable="MIGIDETid">
		<cfinvokeargument name="MIGIDETid" 		value="#form.MIGIDETid#"/>
		<cfinvokeargument name="MIGMid" 		value="#form.MIGMID#"/>
		<cfinvokeargument name="MIGESTid" 		value="#form.MIGESTid#"/>
		<cfinvokeargument name="MIGOEid" 		value="#form.MIGOEid#"/>
		<cfinvokeargument name="MIGFCid" 		value="#form.MIGFCid#"/>
		<cfinvokeargument name="CEcodigo" 		value="#session.CEcodigo#"/>
		<cfinvokeargument name="CodFuente" 		value="1"/>
	</cfinvoke>--->

	<cflocation url="Indicadores.cfm?MIGMid=#MIGMid#&modo=#modo#&tab=#form.tab#&pagenum1=#pagenum#">
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
		<cfset LvarCodigoM="">
		<cfset LvarCodigoM=form.MIGMcodigo>
		<cfset LvarCod=mid(LvarCodigoM,1,1)>
		<cfif LvarCod GTE 0 and LvarCod LTE 9>
			<cfthrow type="toUser" message="El formato del código está incorrecto. El código solo puede recibir valores alfanuméricos.">
		<cfelse>
			<cftransaction>
				<cfinvoke component="mig.Componentes.Indicadores" method="Alta" returnvariable="MIGMid">
					<cfinvokeargument name="MIGMcodigo" 				value="#form.MIGMcodigo#"/>
					<cfinvokeargument name="MIGMnombre" 				value="#form.MIGMnombre#"/>
					<cfinvokeargument name="MIGRecodigo" 					value="#form.IDresp#"/>
					<cfinvokeargument name="MIGReidduenno" 				value="#form.IDdue#"/>
					<cfinvokeargument name="MIGPerid" 					value="#form.MIGPerid#"/>
					<cfinvokeargument name="Ucodigo" 					value="#form.Ucodigo#"/>
				<cfif isdefined ('form.MIGMnpresentacion') and ltrim(form.MIGMnpresentacion) NEQ "">
					<cfinvokeargument name="MIGMnpresentacion" 		value="#form.MIGMnpresentacion#"/>
				<cfelse>
					<cfinvokeargument name="MIGMnpresentacion" 		value=""/>
				</cfif>
				<cfif isdefined ('form.MIGMdescripcion') and ltrim(form.MIGMdescripcion) NEQ "">
					<cfinvokeargument name="MIGMdescripcion" 			value="#form.MIGMdescripcion#"/>
				<cfelse>
					<cfinvokeargument name="MIGMdescripcion" 			value="#form.MIGMdescripcion#"/>
				</cfif>
				<cfif isdefined ('form.MIGMsequencia') and ltrim(form.MIGMsequencia) NEQ "">
					<cfinvokeargument name="MIGMsequencia" 			value="#form.MIGMsequencia#"/>
				<cfelse>
					<cfinvokeargument name="MIGMsequencia" 			value="0"/>
				</cfif>
				<cfif isdefined ('form.MIGMperiodicidad') and ltrim(form.MIGMperiodicidad) NEQ "">
					<cfinvokeargument name="MIGMperiodicidad" 		value="#form.MIGMperiodicidad#"/>
				<cfelse>
					<cfinvokeargument name="MIGMperiodicidad" 		value="M"/>
				</cfif>
				<cfif isdefined ('form.MIGMtoleranciainferior') and ltrim(form.MIGMtoleranciainferior) NEQ "">
					<cfinvokeargument name="MIGMtoleranciainferior"	value="#form.MIGMtoleranciainferior#"/>
				<cfelse>
					<cfinvokeargument name="MIGMtoleranciainferior"	value="0"/>
				</cfif>
				<cfif isdefined ('form.MIGMtipotolerancia') and ltrim(form.MIGMtipotolerancia) NEQ "">
					<cfinvokeargument name="MIGMtipotolerancia"		value="#form.MIGMtipotolerancia#"/>
				<cfelse>
					<cfinvokeargument name="MIGMtipotolerancia"		value="P"/>
				</cfif>
				<cfif isdefined ('form.MIGMtoleranciasuperior') and ltrim(form.MIGMtoleranciasuperior) NEQ "">
					<cfinvokeargument name="MIGMtoleranciasuperior"	value="#form.MIGMtoleranciasuperior#"/>
				<cfelse>
					<cfinvokeargument name="MIGMtoleranciasuperior"	value="0"/>
				</cfif>
					<cfinvokeargument name="MIGReidFija"				value="#form.IDFM#"/>
				<cfif isdefined ('form.MIGMtendenciapositiva') and ltrim(form.MIGMtendenciapositiva) NEQ "">
					<cfinvokeargument name="MIGMtendenciapositiva"	value="#form.MIGMtendenciapositiva#"/>
				<cfelse>
					<cfinvokeargument name="MIGMtendenciapositiva"	value="+"/>
				</cfif>
				<cfif isdefined ('form.Dactiva') and ltrim(form.Dactiva) NEQ "">
					<cfinvokeargument name="Dactiva" 					value="#form.Dactiva#"/>
				<cfelse>
					<cfinvokeargument name="Dactiva" 					value="1"/>
				</cfif>
					<cfinvokeargument name="CodFuente" 					value="1"/>
				<cfif isdefined ('form.MIGMescorporativo') and ltrim(form.MIGMescorporativo) NEQ "">
					<cfinvokeargument name="MIGMescorporativo" 					value="#form.MIGMescorporativo#"/>
				<cfelse>
					<cfinvokeargument name="MIGMescorporativo" 					value="0"/>
				</cfif>
				<cfif isdefined("form.idTramite") and len(trim(form.idTramite))>
					<cfinvokeargument name="idTramite" 					value="#form.idTramite#"/>
				</cfif>
				</cfinvoke>
			</cftransaction>
		<cfset modo='CAMBIO'>
		<cflocation url="Indicadores.cfm?MIGMid=#MIGMid#&modo=#modo#&tab=#form.tab#&pagenum1=#pagenum#">
		</cfif>
	<cfelse>
		<cfthrow type="toUser" message="El Código #rsValida.MIGMcodigo# ya existe en sistema para la empresa #rsValida.Edescripcion# ">
	</cfif>

</cfif>

<cfif isdefined ('form.CAMBIO')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Indicadores" method="Cambio">
			<cfinvokeargument name="MIGMid" 					value="#form.MIGMid#"/>
			<cfinvokeargument name="MIGMnombre" 				value="#form.MIGMnombre#"/>
			<cfinvokeargument name="MIGRecodigo" 					value="#form.IDresp#"/>
			<cfinvokeargument name="MIGReidduenno" 				value="#form.IDdue#"/>
			<cfinvokeargument name="MIGPerid" 					value="#form.MIGPerid#"/>
			<cfinvokeargument name="Ucodigo" 					value="#form.Ucodigo#"/>
		<cfif isdefined ('form.MIGMnpresentacion') and ltrim(form.MIGMnpresentacion) NEQ "">
			<cfinvokeargument name="MIGMnpresentacion" 		value="#form.MIGMnpresentacion#"/>
		<cfelse>
			<cfinvokeargument name="MIGMnpresentacion" 		value=""/>
		</cfif>
		<cfif isdefined ('form.MIGMdescripcion') and ltrim(form.MIGMdescripcion) NEQ "">
			<cfinvokeargument name="MIGMdescripcion" 			value="#form.MIGMdescripcion#"/>
		<cfelse>
			<cfinvokeargument name="MIGMdescripcion" 			value="#form.MIGMdescripcion#"/>
		</cfif>
		<cfif isdefined ('form.MIGMsequencia') and ltrim(form.MIGMsequencia) NEQ "">
			<cfinvokeargument name="MIGMsequencia" 			value="#form.MIGMsequencia#"/>
		<cfelse>
			<cfinvokeargument name="MIGMsequencia" 			value="0"/>
		</cfif>
		<cfif isdefined ('form.MIGMperiodicidad') and ltrim(form.MIGMperiodicidad) NEQ "">
			<cfinvokeargument name="MIGMperiodicidad" 		value="#form.MIGMperiodicidad#"/>
		<cfelse>
			<cfinvokeargument name="MIGMperiodicidad" 		value="M"/>
		</cfif>
		<cfif isdefined ('form.MIGMtoleranciainferior') and ltrim(form.MIGMtoleranciainferior) NEQ "">
			<cfinvokeargument name="MIGMtoleranciainferior"	value="#form.MIGMtoleranciainferior#"/>
		<cfelse>
			<cfinvokeargument name="MIGMtoleranciainferior"	value="0"/>
		</cfif>
		<cfif isdefined ('form.MIGMtipotolerancia') and ltrim(form.MIGMtipotolerancia) NEQ "">
			<cfinvokeargument name="MIGMtipotolerancia"		value="#form.MIGMtipotolerancia#"/>
		<cfelse>
			<cfinvokeargument name="MIGMtipotolerancia"		value="P"/>
		</cfif>
		<cfif isdefined ('form.MIGMtoleranciasuperior') and ltrim(form.MIGMtoleranciasuperior) NEQ "">
			<cfinvokeargument name="MIGMtoleranciasuperior"	value="#form.MIGMtoleranciasuperior#"/>
		<cfelse>
			<cfinvokeargument name="MIGMtoleranciasuperior"	value="0"/>
		</cfif>
			<cfinvokeargument name="MIGReidFija"				value="#form.IDFM#"/>
		<cfif isdefined ('form.MIGMtendenciapositiva') and ltrim(form.MIGMtendenciapositiva) NEQ "">
			<cfinvokeargument name="MIGMtendenciapositiva"	value="#form.MIGMtendenciapositiva#"/>
		<cfelse>
			<cfinvokeargument name="MIGMtendenciapositiva"	value="+"/>
		</cfif>
		<cfif isdefined ('form.Dactiva') and ltrim(form.Dactiva) NEQ "">
			<cfinvokeargument name="Dactiva" 					value="#form.Dactiva#"/>
		<cfelse>
			<cfinvokeargument name="Dactiva" 					value="1"/>
		</cfif>

		<cfinvokeargument name="CodFuente" 					value="1"/>

		<cfif isdefined ('form.MIGMescorporativo') and ltrim(form.MIGMescorporativo) NEQ "">
			<cfinvokeargument name="MIGMescorporativo" 					value="#form.MIGMescorporativo#"/>
		<cfelse>
			<cfinvokeargument name="MIGMescorporativo" 					value="0"/>
		</cfif>
			
		
		<cfif isdefined("form.idTramite") and len(trim(form.idTramite))>
			<cfinvokeargument name="idTramite" 					value="#form.idTramite#"/>

		</cfif>

		
		</cfinvoke>
	</cftransaction>
<cfset modo='CAMBIO'>
<cflocation url="Indicadores.cfm?MIGMid=#form.MIGMid#&modo=#modo#&pagenum1=#pagenum#">
</cfif>
<cfif isdefined ('form.BAJA')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Indicadores" method="Baja" >
			<cfinvokeargument name="MIGMid" 		value="#form.MIGMid#"/>
		</cfinvoke>
	</cftransaction>
<cflocation url="Indicadores.cfm">
</cfif>
<cfif isdefined ('form.Nuevo')>
	<cflocation url="Indicadores.cfm?Nuevo=Nuevo&tab=#form.tab#">
</cfif>


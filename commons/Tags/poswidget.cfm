<cfif ThisTag.ExecutionMode is 'start'>
	<cfparam name="Attributes.sistema" 			default="">
	<cfparam name="Attributes.modulo" 			default="">
    <cfparam name="Attributes.posicion"  		default="-"> <!--- posicion del widget --->
    <cfparam name="Attributes.mostrar"  		default="V"> <!--- H <horizontal>, V <Vertical> --->
    <cfparam name="Attributes.tipo"          	default="C"> <!--- C <widgets de contenidos>,I <indicadores> --->
    <cfparam name="Attributes.extraClass"       default="col-md-12"> <!--- clases extras para la el div contenedor --->
    <cfparam name="Attributes.widgetSize"       default="3"> <!--- tamaño para cada widget valores entre 1 y 12 --->
</cfif>

<cfif ThisTag.ExecutionMode is 'end'>
	<cfif #Session.Ecodigo# NEQ 0>
		<cfquery name="rsWidgets" datasource="asp">
			SELECT  WidID, WidCodigo WidCodigoO,
					case
						when WidParentId is null then WidCodigo
						else (select WidCodigo FROM Widget where WidID = a.WidParentId)
					end as WidCodigo,
					WidTitulo,WidSize,WidMostrarTitulo,WidMostrarOpciones
			FROM Widget a
			where WidActivo = 1
				and (rtrim(ltrim(SScodigo)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.sistema#" > or SScodigo is null)
				and (rtrim(ltrim(SMcodigo)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.modulo#" > or SMcodigo is null)
				and rtrim(ltrim(WidPosicion)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.posicion#" >
				and rtrim(ltrim(WidTipo)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.tipo#" >
		</cfquery>

		<cfset request.widgetCount =  rsWidgets.recordCount>
		<cfif rsWidgets.recordCount GT 0>
			<div class="col <cfoutput>#Attributes.extraClass#</cfoutput>">
				<cfif Attributes.tipo EQ "I">
					<div class="col col-md-12 dash-unit half-unit small-unit">
						<div class="cont">
							<cfoutput query="rsWidgets">
								<cfset request.WidCodigo = rsWidgets.WidCodigoO>
								<cftry>
									<cfinclude template="../../commons/widgets/#rsWidgets.WidCodigo#/widget.cfm">
								<cfcatch type="any">
									<cf_infobox color="red" icon="exclamation" value="Error" content="#rsWidgets.WidTitulo#"/>
								</cfcatch>
								</cftry>
							</cfoutput>
						</div>
					</div>
				<cfelse>
					<cfoutput query="rsWidgets">
						<div class="col col-md-<cfif Attributes.mostrar NEQ 'V'><cfif Attributes.widgetSize Gt 0 and Attributes.widgetSize LT 13>#Attributes.widgetSize#<cfelse>3</cfif><cfelse>12</cfif>">
							<cfset request.WidCodigo = rsWidgets.WidCodigoO>
							<cftry>
								<cf_widget codewidget="#rsWidgets.WidCodigo#" showTitulo="#rsWidgets.WidMostrarTitulo#" titulo="#rsWidgets.WidTitulo#" size="#rsWidgets.WidSize#" />
							<cfcatch type="any">
								<cf_infobox color="red" icon="exclamation" value="Error" content="#rsWidgets.WidTitulo#"/>
							</cfcatch>
							</cftry>
						</div>
					</cfoutput>
				</cfif>
			</div>
		</cfif>
	</cfif>

</cfif>
<cfset objParam = CreateObject("component", "commons.Widgets.Componentes.Parametros")>

<cfif isDefined("form.fieldnames")>

	<cfloop collection="#form#" item="vField">
		<cfif vField is not "fieldNames">
			<cfset vValue = form[vField]>
			<cfset vValue = replace(vValue,"'",'"','all')>
			<cfset vValue = trim(PreserveSingleQuotes(vValue))>
			<cfset arrayField = ListToArray(vField,'_')>


			<cfquery name="rsExParam" datasource="asp">
				select Pvalor from WidgetParametros
				where WidID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.WidId#">
					and Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arrayField[2])#">
					<!--- and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(Arguments.Ecodigo)#"> --->
			</cfquery>

			<cfif lcase(arrayField[1]) EQ 'param'>
				<cfif rsExParam.recordCount EQ 0>

					<cfquery datasource="asp" result="result">
						INSERT INTO WidgetParametros
					           (WidID,Pcodigo,Pvalor,Pdescripcion)
					     VALUES
					           (#url.WidId#
					           ,'#trim(arrayField[2])#'
					           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#vValue#">
					           ,'Iframe')
					</cfquery>

				<cfelse>
					<cfquery datasource="asp">
						update WidgetParametros
							set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vValue#">
						where WidID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.WidId#">
							and Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arrayField[2])#">
					</cfquery>
				</cfif>
			</cfif>

		</cfif>
	</cfloop>
<cfelse>
	<cfquery name="rsWidget" datasource="asp">
		select WidID, WidCodigo, WidParentId from Widget
		where WidID = #url.WidId#
	</cfquery>

	<cfoutput>
		<cfset lvarCode=objParam.ObtenerValor("#rsWidget.WidCodigo#","001")>
		<cfset lvarHeight= objParam.ObtenerValor("#rsWidget.WidCodigo#","002")>
		<cfset lvarWidth= objParam.ObtenerValor("#rsWidget.WidCodigo#","003")>
		<div class="well">
			<form class="bs-example form-horizontal" id="formparam">
				<div class="form-group">
					<div align="center">
						<label for="param_001">Ruta: </label>

						<input id="param_001" name="param_001" placeholder="/cfmx/commons/widgets/publico/MenuCP-iframe.cfm" size="64" value="#lvarCode#"></input>
					</div>

					<div class="form-group">
					  	<div class="row">
					    	<div class="col-md-12 ">
					    		<label for="param_002">Height(px): </label>
								<input class="param_002" name="param_002" value="#lvarHeight#" size="10" placeholder="Height">
								</input>

								<label for="param_003">Width(px): </label>
								<input class="param_003" name="param_003" value="#lvarWidth#" size="10" placeholder="Width">
								</input>
					    	</div>
					    </div>
					</div>
				</div>
				<div class="form-group">
					<div >
						<input name="Cambio" class="btnGuardar" value="Modificar" onclick="fnGuardar()" tabindex="0" type="button">
					</div>
				</div>

			</form>
		</div>

		<cfset varConfigFIle=objParam.GetURLConfig("#url.WidId#")>
		<script type="text/javascript">

			function fnGuardar(){
				var dataString = $("##formparam").serialize();

				$.ajax({
		            type: "POST",
		            url: "#varConfigFIle#?WidId=#url.WidId#",
		            data: dataString,
		            success: function(data) {

		            }
		        });
			}

		</script>
	</cfoutput>
</cfif>


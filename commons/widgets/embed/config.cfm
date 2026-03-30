<cfset objParam = CreateObject("component", "commons.Widgets.Componentes.Parametros")>

<cfif isDefined("form.fieldnames")>
	<cfloop collection="#form#" item="vField">
		<cfif vField is not "fieldNames">
			<cfset vValue = form[vField]>
			<cfset vValue = replace(vValue,"'",'"','all')>
			<cfset vValue = trim(PreserveSingleQuotes(vValue))>
			<cfset vValue = replace(vValue,'<InvalidTag','<script','all')>
			<cfset arrayField = ListToArray(vField,'_')>

			<cfquery name="rsExParam" datasource="asp">
				select Pvalor from WidgetParametros
				where WidID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.WidId#">
					and Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arrayField[2])#">
					<!--- and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(Arguments.Ecodigo)#"> --->
			</cfquery>

			<cfif lcase(arrayField[1]) EQ 'param'>
				<cfif rsExParam.recordCount EQ 0>

					<cfquery datasource="asp">
						INSERT INTO WidgetParametros
					           (WidID,Pcodigo,Pvalor,Pdescripcion)
					     VALUES
					           (#url.WidId#
					           ,'001'
					           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#vValue#">
					           ,'Codigo embebido')
					</cfquery>
				<cfelse>
					<cfquery datasource="asp">
						update WidgetParametros
							set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vValue#">
						where WidID = #url.WidId#
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

		<div class="well">
			<form class="bs-example form-horizontal" id="formparam">
				<div class="form-group">
					<div align="left">
						<label for="param_001">C&oacute;digo: </label>
						<textarea id="param_001" name="param_001" placeholder="C&oacute;digo" cols="60" rows="10"><cfoutput>#lvarCode#</cfoutput></textarea>
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


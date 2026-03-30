<cfset objParam = CreateObject("component", "commons.Widgets.Componentes.Parametros")>

<cfif isDefined("form.fieldnames")>
	<cfloop collection="#form#" item="vField">
		<cfif vField is not "fieldNames">
			<cfset #vValue# = #form[vField]#>
			<cfset arrayField = ListToArray(vField,'_')>

			<cfif lcase(arrayField[1]) EQ 'param'>
				<cfquery datasource="asp">
					update WidgetParametros
						set Pvalor = '#trim(vValue)#'
					where WidID = #url.WidId#
						and Pcodigo = '#trim(arrayField[2])#'
				</cfquery>
			</cfif>

		</cfif>
	</cfloop>
<cfelse>
	<cfquery name="rsWidget" datasource="asp">
		select WidID, WidCodigo, WidParentId from Widget
		where WidID = #url.WidId#
	</cfquery>

	<cfoutput>
		<cfset lvarRSSurl=objParam.ObtenerValor("#rsWidget.WidCodigo#","001")>
		<cfset lvarHeight=objParam.ObtenerValor("#rsWidget.WidCodigo#","002")>


		<div class="well">
			<form class="bs-example form-horizontal" id="formparam">
				<div class="form-group">
					<div align="left">
						<label for="param_001">RSS: </label>
						<input id="param_001" name="param_001" placeholder="RSS url" type="text" maxlength="100" size="50" value="#lvarRSSurl#">
					</div>
				</div>
				<div class="form-group">
					<div align="left">
						<label for="inputHeight">Altura: </label>
						<input id="param_002" name="param_002" placeholder="Altura" type="number" min="50" max="300" maxlength="3" value="#lvarHeight#">
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


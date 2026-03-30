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
		<cfset lvarValor=objParam.ObtenerValor("#rsWidget.WidCodigo#","002")>
		<cfset lvarMcodigo=objParam.ObtenerValor("#rsWidget.WidCodigo#","001")>
		<cfset lvarColor=objParam.ObtenerValor("#rsWidget.WidCodigo#","003")>
		<cfset lvarIcono=objParam.ObtenerValor("#rsWidget.WidCodigo#","004")>

		<div class="well">
			<form class="bs-example form-horizontal" id="formparam">
				<div class="form-group">
					<div align="left">
						<label for="param_001">Codigo de la moneda: </label>
						<input id="param_001" name="param_001" placeholder="Moneda" type="text" maxlength="5" value="#lvarMcodigo#">
						<label for="param_002">Campo de valor: </label>
						<select id="param_002" name="param_002">
							<option value="TCcompra"<cfif lvarValor eq "TCcompra"> selected </cfif>>Compra </option>
							<option value="TCventa"<cfif lvarValor eq "TCventa"> selected </cfif>>Venta</option>
						</select>
					</div>
				</div>
				<div class="form-group">
					<div align="left">
						<label for="param_003">Color: </label>
						<input id="param_003" name="param_003" placeholder="Color" type="text"  maxlength="30" value="#lvarColor#">
						<label for="param_004">Icono: </label>
						<input id="param_004" name="param_004" placeholder="Icono" type="text" maxlength="30" value="#lvarIcono#">
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


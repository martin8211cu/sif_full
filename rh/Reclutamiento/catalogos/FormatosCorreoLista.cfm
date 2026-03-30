
<style type="text/css">
	.well { padding: 25px 10px 15px 10px; margin-top: 10px; margin-bottom: 15px;  }
	.form-group { margin-left: 5px; }
</style>


<!--- Etiquetas de traduccion --->
<cfset LB_Codigo = t.translate('LB_Codigo','Código','/rh/generales.xml')>
<cfset LB_Descripcion = t.translate('LB_Descripcion','Descripción','/rh/generales.xml')>
<cfset LB_Filtrar = t.translate('LB_Filtrar','Filtrar','/rh/generales.xml')>
<cfset LB_Nuevo = t.translate('LB_Nuevo','Nuevo','/rh/generales.xml')>

<div class="well"> 
	<cfoutput>
		<div class="form-group row">
			<!--- Lista de formatos de correos --->
			<div class="col-sm-12">
				<cf_translatedata name="get" tabla="EFormato" col="a.EFdescripcion" returnvariable="LvarEFdescripcion">
				<cfinvoke component="rh.Componentes.pListas" method="pListaRH" returnvariable="pListaRet"
					columnas="a.EFid, a.EFcodigo, #LvarEFdescripcion# as EFdescripcion"
					tabla="EFormato a
							inner join TFormatos b
								on b.TFid = a.TFid"
					filtro="a.Ecodigo = #Session.Ecodigo# and b.TFUso = 2 
							order by a.EFcodigo"
					desplegar="EFcodigo, EFdescripcion"
					etiquetas="#LB_Codigo#, #LB_Descripcion#"
					formatos="S,S"
					filtrar_por="EFcodigo, EFdescripcion"
					mostrar_filtro="true"
					filtrar_automatico="true"
					TranslateDataCols="EFdescripcion"
					align="left, left"
					ira="FormatosCorreo-form.cfm"
					showEmptyListMsg="true"
				/>	
			</div>
		</div>		

		<!--- Boton de accion --->
		<div class="form-group row"> 
	        <div class="col-sm-12 col-sm-offset-4">
				<input type="button" name="btnNuevo" value="#LB_Nuevo#" onClick="fnNuevo()">
	        </div>
        </div>	
	</cfoutput>	
</div>


<script type="text/javascript">
	function fnNuevo(){
		location.href = 'FormatosCorreo-form.cfm';
	}
</script>
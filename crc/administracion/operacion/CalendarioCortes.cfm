
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo = t.Translate('LB_Titulo','Calendario de cortes distribuidor.','/sif/generales.xml')>

<cfset navegacion = "1=1">
<cfif isDefined('url.TCortes')><cfset form.TCortes = url.TCortes></cfif>
<cfif isdefined('form.TCortes')>
	<cfset navegacion = "&TCortes=#form.TCortes#">
	<cfquery name="rsCortes"  datasource="#session.dsn#">
		select
			convert(VARCHAR(10), FechaInicio, 103) as FecIni,
			convert(VARCHAR(10), FechaFin, 103) as FecFin,
			* from CRCCortes
		where Tipo = '#form.TCortes#'
			and Ecodigo = #session.Ecodigo#
		order by FechaFin desc
	</cfquery>
</cfif>

<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>

		<div class="row">
			<form name="form2" id="form2" style="margin:0;" method="post" action="CalendarioCortes.cfm">
			<div class="col-md-4  col-xs-offset-4">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="2">
							<select name="TCortes" id="TCortes" onchange="funcCortesSelect();">
							 <option value="">Selecionar</option>
							  <option value="D"
							  	<cfif isdefined('form.TCortes') and  form.TCortes EQ 'D'>
							  		selected
							  	</cfif>
							  >Cortes Vales</option>
							  <option value="TC"
							  	<cfif isdefined('form.TCortes') and  form.TCortes EQ 'TC'>
							  		selected
							  	</cfif>
							  >Cortes Tarjeta Credito</option>
							  <option value="TM"
							  	<cfif isdefined('form.TCortes') and  form.TCortes EQ 'TM'>
							  		selected
							  	</cfif>
							  >Cortes Tarjeta Mayorista</option>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="2">

						</td>
						<td colspan="2">

						</td>
					</tr>
				</table>
			</div>
			</form>
		</div>

		<div class="col-md-12">
			<cfif isdefined('rsCortes')>
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
					<cfinvokeargument name="query" 		value="#rsCortes#"/>
					<cfinvokeargument name="campos" 	value="Codigo,FecIni,FecFin,Cerrado"/>
					<cfinvokeargument name="desplegar" 	value="Codigo,FecIni,FecFin,Cerrado"/>
					<cfinvokeargument name="etiquetas" 	value="Codigo,FechaInicio,FechaFin,Cerrado"/>
					<cfinvokeargument name="formatos" 	value="S,S,S,S,S,S"/>
					<cfinvokeargument name="align" 		value="left,left,left,left,left,left"/>
					<cfinvokeargument name="ajustar" 	value="N,N,N,S,S,S"/>
					<cfinvokeargument name="irA" 		value="CalendarioCortes-sql.cfm"/>
					<cfinvokeargument name="showlink" 		value="false"/>
					<cfinvokeargument name="mostrar_filtro" 	value="false"/>
					<cfinvokeargument name="filtrar_automatico" value="false"/>
	              	<cfinvokeargument name="maxRows"	 		value="20"/>
	              	<cfinvokeargument name="width" 				value="100%"/>
	              	<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
				</cfinvoke>
			</cfif>
		</div>
		<script>
			function funcCortes(){
				var lvarTCortes = document.getElementById("TCortes").value;
				if(lvarTCortes != ''){
					document.getElementById("form2").submit();
				}else{
					alert('Seleccione un tipo de corte.');
				}
			}
			function funcCortesSelect(){

				document.getElementById("form2").submit();

			}
		</script>
	<cf_web_portlet_end>
<cf_templatefooter>



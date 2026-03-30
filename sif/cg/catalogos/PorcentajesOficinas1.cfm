<!---
-Archivos nuevos. MCZ
Funcionamiento de Archivos relacionados
Cuando se entra en la pantalla la primera opcion que aparece es ListaPeridos.cfm 
este archivo al igual que todos los demas se devuelven a este (PorcentajesOficina.cfm)
Luego de escoger un periodo y un mes se pasa a la Lista de Clasificacion (ListaEncabezado.cfm)
Despues de que se escoje el encabezado se va a la lista de los detalles de la clasificacion que se 
escogio(ListaDetalles.cfm)
Esta ultima tiene dos botones que son CopiarValores y Regresar
El copiar valores abre un pop_up que corresponde al archivo CopiaPorcentajes1.cfm
y este a su vez llama al SQLPorcentajesOficinas.cfm (al igual que todos los botones de regresar)
Si no se copian los valores se puede escoger un detalle de clasificacion, al dar clic sobre este me 
llevara al formPorcentajesOficinas.cfm, en este formulario se me despliegan todas las oficinas que maneja una empresa
con un cuadro de texto donde se puede modificar el porcentaje de oficina
En esta pantalla me aparecen dos opciones -Copiar Valores e -Importar
El copiar valores me abre un pop_up que corresponde a CopiaPorcentaje.cfm
y el Importador me lleva al Importa_porcentaje_oficinas.cfm que maneja su propio sql que seria
Importa_porcentaje_oficonas_sql.cfm.
Dentro del formPorcentajesOficinas.cfm puedo dar clic al codigo de oficina para q me despliegue un minireporte
el cual contiene informacion de los porcentajes de esa oficina en todos los periodos y meses(Reporte_porcentaje_oficinas.cfm)
Archivos para % de oficina (todos nuevos)
-PorcentajesOficina.cfm
-ListaEncabezado.cfm
-ListaDetalles.cfm
-CopiaPorcentajes1.cfm
-SQLPorcentajesOficinas.cfm
-formPorcentajesOficinas.cfm
-CopiaPorcentaje.cfm
-Importa_porcentaje_oficinas.cfm
-Importa_porcentaje_oficonas_sql.cfm
-Reporte_porcentaje_oficinas.cfm
--->
<cf_templateheader title="Definir porcentajes por oficina">
	<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>
	
	<cfif isdefined ('url.PCCEclaid') and not isdefined('form.PCCEclaid')>
		<cfset form.PCCEclaid=#url.PCCEclaid#>
	</cfif>
	<cfif isdefined ('url.PCCDclaid') and not isdefined('form.PCCDclaid')>
		<cfset form.PCCDclaid=#url.PCCDclaid#>
	</cfif>
	<cfset titulo = ''>
	
		
		<cfif (isdefined('form.Speriodo')  and  isdefined ('form.Smes') or isdefined('url.speriodo')  and  isdefined ('url.smes') ) >
			<cfset titulo = 'Lista de Clasificación'>
				<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
					<cfinclude template="ListaEncabezado.cfm">			
		
		<cfelse>
			<cfset titulo = 'Lista de Periodos'>
				<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
					<cfinclude template="ListaPeriodos.cfm">
		</cfif>
				<cf_web_portlet_end>
<cf_templatefooter>

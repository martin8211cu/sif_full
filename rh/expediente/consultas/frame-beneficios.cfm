<cfquery name="rsBeneficios" datasource="#Session.DSN#">
	select a.BElinea, a.DEid, a.Bid, a.Mcodigo, a.BEfdesde, a.BEfhasta, a.BEmonto, a.BEporcemp,
		   (a.BEmonto * a.BEporcemp / 100.0) as MontoEmp, a.SNcodigo, a.BEactivo,
		   a.fechainactiva, a.fechaalta, a.BMUsucodigo,
		   rtrim(b.Bcodigo) as Bcodigo, b.Bdescripcion,
		   c.Miso4217, c.Mnombre,
		   d.SNnumero, d.SNnombre as Socio
	from RHBeneficiosEmpleado a

		inner join RHBeneficios b
			on a.Bid = b.Bid
		
		inner join Monedas c
			on a.Ecodigo = c.Ecodigo
			and a.Mcodigo = c.Mcodigo

		left outer join SNegocios d
			on a.Ecodigo = d.Ecodigo
			and a.SNcodigo = d.SNcodigo

	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">
	and a.BEactivo = 1
	order by a.BEfdesde desc, b.Bcodigo
</cfquery>

	<!--- Expediente --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Codigo"
		Default="Código"
		Idioma="#session.Idioma#"
		returnvariable="vCodigo"/>

	<!--- Datos Personales --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Descripcion"
		Default="Descripción"
		Idioma="#session.Idioma#"
		returnvariable="vDesc"/>

	<!--- Datos Familiares --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="FEcDesdeExp"
		Default="Desde"
		Idioma="#session.Idioma#"
		returnvariable="vDesde"/>

	<!--- Datos Laborales --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="HastaExp"
		Default="Hasta"
		Idioma="#session.Idioma#"
		returnvariable="vHasta"/>

	<!--- Monto --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Monto"
		Default="Monto"
		Idioma="#session.Idioma#"
		returnvariable="vMonto"/>

	<!--- Monto --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Moneda"
		Default="Moneda"
		Idioma="#session.Idioma#"
		returnvariable="vMoneda"/>

	<!--- Monto Empleado --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MontoEmpleado"
		Default="Monto Empleado"
		Idioma="#session.Idioma#"
		returnvariable="vMontoEmp"/>

	<!--- Pct Empleado --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="PctEmpleado"
		Default="% Empleado"
		Idioma="#session.Idioma#"
		returnvariable="vPctEmpleado"/>

	<!--- Socio --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Socio"
		Default="Socio"
		Idioma="#session.Idioma#"
		returnvariable="vSocio"/>



<cfif rsBeneficios.recordCount GT 0>
	<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
	 returnvariable="LvarResult">
		<cfinvokeargument name="query" value="#rsBeneficios#"/>
		<cfinvokeargument name="desplegar" value="Bcodigo, Bdescripcion, BEfdesde, BEfhasta, BEmonto, Mnombre, MontoEmp, BEporcemp, Socio"/>
		<cfinvokeargument name="etiquetas" value="#vCodigo#, #vDesc#, #vDesde#, #vHasta#, #vMonto#, #vMoneda#, #vMontoEmp#, #vPctEmpleado# , #vSocio#"/>
		<cfinvokeargument name="formatos" value="S, S, D, D, M, V, S, M, S"/>
		<cfinvokeargument name="align" value="left, left, center, center, right, right, center, center, left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="checkboxes" value="N"/>
		<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
		<cfinvokeargument name="keys" value="BElinea, DEid"/>
		<cfinvokeargument name="maxRows" value="0"/>
		<cfinvokeargument name="showLink" value="false"/>
		<cfinvokeargument name="PageIndex" value="89"/>
	</cfinvoke> 
<cfelse>
		<cf_translate key="MSG_ElEmpleadoNoTieneBeneficiosAsociadosActualmente">El empleado no tiene beneficios asociados actualmente</cf_translate>
</cfif>
<cfif tabChoice eq 12>
	<table align="center">
		<tr>
			<td>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Imprimir"
				Default="Imprimir"
				XmlFile="/rh/generales.xml"
				returnvariable="BTN_Imprimir"/>
				
				<input name="imp" type="button" id="imprimir" value="<cfoutput>#BTN_Imprimir#</cfoutput>" onClick="javascript: imprimirReporte('<cfoutput>#rsEmpleado.DEid#</cfoutput>')">
			</td>
		</tr>
	</table>
</cfif>


<script language="javascript" type="text/javascript">
	function imprimirReporte(emp) {
		var width = 700;
		var height = 500;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		var nuevo = window.open('expediente-beneficiosI.cfm?DEid='+emp,'Beneficios','menu=no,scrollbars=no,top='+top+',left='+left+',width='+width+',height='+height);
		nuevo.focus();
	}
</script>
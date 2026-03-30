<cfinvoke Key="LB_nombre_proceso" Default="Calculo del Salario Base de Cotizacion (SDI) por aniversario" returnvariable="LB_nombre_proceso" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Nombre" Default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Monto" Default="Monto" returnvariable="LB_Monto" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_FechaAplicacion" Default="Fecha de aplicaci&oacute;n" returnvariable="LB_FechaAplicacion" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Usuario" Default="Usuario" returnvariable="LB_Usuario" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>

<cfquery datasource="#session.dsn#" name="rsLista">
	select
		concat(de.DEidentificacion,' - ', de.DEnombre,' ',de.DEapellido1,' ',de.DEapellido2) as Nombre,
		a.RHHmonto,
		<cf_dbfunction name="date_format"	args="a.RHHfecha,dd/mm/yyyy" > as FecAplicacion,
		b.Usulogin
	FROM RHHistoricoSDI a
		inner join Usuario b
			on b.Usucodigo = a.BMUsucodigo
		inner join DatosEmpleado de
			on de.DEid = a.DEid
		and a.RHHfuente = 3<!--- aniversario --->
		order by a.RHHfecha desc
</cfquery>
<cfset today = now()>
<cfset myDay = DayOfWeek(now())>

<cf_templateheader title="#LB_nombre_proceso#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" titulo="<cfoutput>#LB_nombre_proceso#</cfoutput>" skin="#Session.Preferences.Skin#">
		<form name="form1" action="CalculoSDIAniversario-sql.cfm" method="post" <!--- onsubmit="javascript:return validar();" --->>
			<table align="center" width="100%">
				<tr>
					<td>
						<cfinvoke component="rh.Componentes.pListas" method="pListaQuery" returnvariable="pListaEmpl">
	                        <cfinvokeargument name="query" value="#rsLista#"/>
	                        <cfinvokeargument name="useAJAX" value="yes">
	                        <cfinvokeargument name="desplegar" value="Nombre,RHHmonto,FecAplicacion,Usulogin"/>
	                        <cfinvokeargument name="etiquetas" value="#LB_Nombre#,#LB_Monto#,#LB_FechaAplicacion#,#LB_Usuario#"/>
	                        <cfinvokeargument name="align" value="left,left,left,left"/>
	                        <cfinvokeargument name="formatos" value="S,M,D,S"/>
	                        <cfinvokeargument name="ajustar" value="N"/>
	                        <cfinvokeargument name="showlink" value="false">
	                        <cfinvokeargument name="keys" value="Nombre,RHHmonto,FecAplicacion,Usulogin"/>
						</cfinvoke>
					</td>
				</tr>
				<tr>
					<td align="center">
						<input id="btnCalcular" name="btnCalcular" value="Calcular" type="submit">
					</td>
				</tr>
			</table>
		</form>
		<script type="text/javascript" language="javascript">
			function validar()
			{
			<cfoutput>
				<cfif myDay neq 3 and myDay neq 2>
					alert('El calculo solo se puede realizar los dias Lunes');
					return false;
				</cfif>
				<cfif myDay eq 3><!--- Martes --->
					<cfset lunes = LSDateFormat(DateAdd("d",-1,today),'YYYY-MM-dd')>
					<!--- Buscamos si este lunes es dia feriado oficial --->
					<cfquery name="rsEsFeriado" datasource="#session.dsn#">
						select *
						from
							RHFeriados
						where RHFregional = 0
						and RHFfecha = '#lunes#'
						and Ecodigo = #session.Ecodigo#
					</cfquery>
					<cfif rsESFeriado.RecordCount eq 0>
						alert('El calculo solo se puede realizar los dias Lunes');
						return false;
					</cfif>
					return true;
				</cfif>
			</cfoutput>
			}
		</script>
	<cf_web_portlet_end>
<cf_templatefooter>
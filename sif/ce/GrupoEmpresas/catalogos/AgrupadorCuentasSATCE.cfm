<cfinvoke key="LB_Titulo" default="Agrupador de cuentas del SAT" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate"
xmlfile="AgrupadorCuentasSATCE.xml"/>
<cfinvoke key="LB_Clave" default="Clave" returnvariable="LB_Clave" component="sif.Componentes.Translate" method="Translate"
xmlfile="AgrupadorCuentasSATCE.xml"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate"
xmlfile="AgrupadorCuentasSATCE.xml"/>
<cfinvoke key="LB_Nombre" default="Versi&oacute;n" returnvariable="LB_Version" component="sif.Componentes.Translate" method="Translate"
xmlfile="AgrupadorCuentasSATCE.xml"/>


<cfquery name="rsNivel" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200080 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>

<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">
	<cfquery name="rs" datasource="#Session.DSN#">
		select Pvalor,Pdescripcion
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>


<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
		<cfinclude template="../../../portlets/pNavegacionCG.cfm">
		<cfset filtro = "">
		<cfset navegacion = "">

		<cfset IRA = 'AgrupadorCuentasSATCE.cfm'>
		<cfset varEmpElimina =  ObtenerDato(1310)>
		<cfif varEmpElimina.Pvalor EQ '' or varEmpElimina.Pvalor NEQ Session.Ecodigo>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
			      <br/>
			      <tr>
				      <td align="center">Este proceso solo se puede usar en una Empresa que este configurada como Empresa de Eliminaci&oacute;n.</td>
				  </tr>
				  <tr>
					  <td align="center"><a href="../../../../otrassol/consolidacion/Catalogos/ParametrosCtaEliminacion.cfm" style="color:#456ABA"> Parámetro de Eliminaci&oacute;n</a></td>
				  </tr>
			</table>
			<br>
		<cfelse>
			<cfif #rsNivel.RecordCount# neq 0>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td valign="top">
							<cfinclude template="formAgrupadorCuentasSATCE.cfm">
						</td>
					</tr>
					<tr>
						<td><hr></td>
					</tr>
				  	<tr>
						<td valign="top" width="50%">
		                    <cfset form.PAGENUM=1>
							<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet"
								tabla				= "CEAgrupadorCuentasSAT ace
														left join CEMapeoGE mge
															on ace.CAgrupador = mge.Id_Agrupador
														left join AnexoGEmpresa age
															on mge.GEid = age.GEid"
								columnas  			= "CAgrupador, Descripcion, Version, age.GEnombre"
								desplegar			= "CAgrupador, Descripcion, Version, GEnombre"
								etiquetas			= "#LB_Clave#, #LB_Nombre#, #LB_Version#, Grupo de Empresa"
								formatos			= "S,S,S,S"
								filtro				= "(ace.Ecodigo is null  or ace.Ecodigo = #Session.Ecodigo#)"
								align 				= "Left, Left, Left,Left"
								ajustar				= "N"
								checkboxes			= "N"
								incluyeform			= "true"
								formname			= "filtro"
								navegacion			= "#navegacion#"
								mostrar_filtro		= "true"
								filtrar_automatico	= "true"
								showLink			= "true"
								showemptylistmsg	= "true"
								keys				= "CAgrupador"
								MaxRows				= "15"
								irA					= "#IRA#"
								/>
						  </td>
			 	      </tr>
			      </table>
			<cfelse>
			      <table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
				      <br/>
				      <tr>
					      <td align="center">Para poder usar este módulo debes de configura el parámetros 'Nivel'</td>
					  </tr>
					  <tr>
						  <td align="center"><a href="../../../ce/catalogos/ParametrosCE.cfm" style="color:#456ABA"> Configurar parámetro</a></td>
					  </tr>
				  </table>
			</cfif>
		</cfif>


	<cf_web_portlet_end>
<cf_templatefooter>
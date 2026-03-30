<cfquery name="rsNivel" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200080 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<cfinvoke key="LB_Titulo" default="Agrupador de cuentas del SAT" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate"
xmlfile="AgrupadorCuentasSATCE.xml"/>
<cfinvoke key="LB_Clave" default="Clave" returnvariable="LB_Clave" component="sif.Componentes.Translate" method="Translate"
xmlfile="AgrupadorCuentasSATCE.xml"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate"
xmlfile="AgrupadorCuentasSATCE.xml"/>
<cfinvoke key="LB_Nombre" default="Versi&oacute;n" returnvariable="LB_Version" component="sif.Componentes.Translate" method="Translate"
xmlfile="AgrupadorCuentasSATCE.xml"/>
<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
		<cfinclude template="../../portlets/pNavegacionCG.cfm">
		<cfset filtro = "">
		<cfset navegacion = "">

		<cfset IRA = 'AgrupadorCuentasSATCE.cfm'>

		<cfif #rsNivel.RecordCount# neq 0>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td valign="top" width="50%">
                    <cfset form.PAGENUM=1>
					<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet"
						tabla				= "CEAgrupadorCuentasSAT"
						columnas  			= "CAgrupador, Descripcion, Version"
						desplegar			= "CAgrupador, Descripcion, Version"
						etiquetas			= "#LB_Clave#, #LB_Nombre#, #LB_Version#"
						formatos			= "S,S,S"
						filtro				= "(Ecodigo is null  or Ecodigo = #Session.Ecodigo#)"
						align 				= "Left, Left, Left"
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
				  <td valign="top">
					 <cfinclude template="formAgrupadorCuentasSATCE.cfm">
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
					  <td align="center"><a href="ParametrosCE.cfm" style="color:#456ABA"> Configurar parámetro</a></td>
				  </tr>
			  </table>
			   <br/>

		</cfif>



	<cf_web_portlet_end>
<cf_templatefooter>
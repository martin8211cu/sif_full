<cfset IDtrans = 3>
<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetProRev" returnvariable="ParamProRev" Conexion="#session.dsn#" Ecodigo="#session.Ecodigo#"/>
	<cfsavecontent variable="descripProcess">
			<br />
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Configuración de Revaluación">
				<ul> 
				  <li><strong>Toma de Saldos</strong></li>
					<ul>
							<li>Se tomaran los saldos del periodo Anterior</li>
						<cfif ParamProRev EQ 1>
							<li>En caso de ser un Activo producto de una segregación, se tomaran los montos del Traslado.</li>
						</cfif>
					</ul>
				<li><strong>Se tomara en cuenta del Periodo Actual</strong></li>
					<ul>
						<cfif ParamProRev NEQ 1>
						 	<li>Ningún movimiento del periodo Actual</li>
						 <cfelse>
							<li>Segregaciones o traslados parciales</li>
							<li>Retiros Parciales</li>
							<li>Reevaluaciones</li>
						</cfif>
					</ul>
					<li><strong>Cambio de Configuración</strong></li>
						<ul>
						<li>Ver parámetro "Considerar traslados, retiros y Revaluaciónes del último periodo en la Revaluación" en administración del sistema - Parámetros Adicionales.</li>
					</ul>
				</ul>
			<cf_web_portlet_end>
	</cfsavecontent>
<cfinclude template="agtProceso_genera.cfm">
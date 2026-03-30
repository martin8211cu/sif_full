<cfquery name="rsParametros" datasource="#Session.DSN#">
	select Pvalor
	from Parametros
	where Pcodigo = 1
      and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Cat&aacute;logos">
  <ul>
	<!---►►Cuentas Contables◄◄--->
	<cfif acceso_uri("/sif/cg/catalogos/CuentasMayor.cfm")>
        <li> 
            <a href="/cfmx/sif/cg/catalogos/CuentasMayor.cfm">Cat&aacute;logo Contable</a>
        </li>
    </cfif>
	<!---►►Tipos de Operacion Bancos◄◄--->
	<cfif acceso_uri("/sif/mb/catalogos/TiposTransaccion.cfm?desde=AD")>
        <li> 
            <a href="/cfmx/sif/mb/catalogos/TiposTransaccion.cfm?desde=AD">Tipos de Operaci&oacute;n Bancos</a>
        </li>
	</cfif>
	<!---►►Tipos de Transaccion Cuentas por Pagar◄◄--->
	<cfif acceso_uri("/sif/cp/catalogos/TipoTransacciones.cfm")>
        <li> 
            <a href="/cfmx/sif/cp/catalogos/TipoTransacciones.cfm">Transacciones Cuentas por Pagar</a>
        </li>
    </cfif>
	<!---►►Tipos de Transaccion Cuentas por Cobrar◄◄--->
	<cfif acceso_uri("/sif/cc/catalogos/TipoTransacciones.cfm")>
        <li> 
            <a href="/cfmx/sif/cc/catalogos/TipoTransacciones.cfm">Transacciones Cuentas por Cobrar</a>
        </li>
    </cfif>
	<!---►►Origenes de Datos◄◄--->
	<cfif acceso_uri("/sif/ad/catalogos/Origenes.cfm")>
        <li> 
            <a href="/cfmx/sif/ad/catalogos/Origenes.cfm">Or&iacute;genes de M&oacute;dulos Externos</a>
        </li>
    </cfif>
	<!---►►Conceptos Contables◄◄--->
    <cfif acceso_uri("/sif/cg/catalogos/ConceptoContable.cfm")>
        <li> 
            <a href="/cfmx/sif/cg/catalogos/ConceptoContableE.cfm">Conceptos Contables</a>
        </li>
    </cfif>
	<!---►►Conceptos Contables por Origen◄◄--->
	<cfif acceso_uri("/sif/cg/catalogos/ConceptoContable.cfm")>
        <li> 
            <a href="/cfmx/sif/cg/catalogos/ConceptoContable.cfm">Conceptos Contables por Origen</a>
        </li>
    </cfif>
	<!---►►Socios de Negocios◄◄--->
    <cfif acceso_uri("/sif/ad/catalogos/listaSocios.cfm")>
        <li> 
            <a href="/cfmx/sif/ad/catalogos/listaSocios.cfm"><cfoutput>#Request.Translate('Socios','Socios de Negocios')#</cfoutput></a>
        </li>
    </cfif>
	<!---►►Dirección del Socio de Negocios◄◄--->
	<cfif acceso_uri("/sif/ad/catalogos/listaSocios_Direcciones.cfm")>
        <li> 
            <a href="/cfmx/sif/ad/catalogos/listaSocios_Direcciones.cfm"><cfoutput>#Request.Translate('Socios_Direccion','Dirección del Socio de Negocios')#</cfoutput></a>
        </li>
	</cfif>
	<!---►►Clasificacion de Socios de Negocios◄◄--->
	<cfif acceso_uri("/sif/ad/catalogos/SNClasificaciones.cfm")>
        <li> 
            <a href="catalogos/SNClasificaciones.cfm">
                    Clasificación de Socios de Negocio
                </a>
            
        </li>
    </cfif>
	<!---►►Mascara de Socios de Negocios◄◄--->
	<cfif acceso_uri("/sif/ad/catalogos/SNMascara.cfm")>
        <li> 
            <a href="catalogos/SNMascara.cfm">
                    Mascaras del Socio de Negocio
                </a>
            
        </li>
    </cfif>
	<!---►►Clasificacion de Socios de Negocios◄◄--->
	<cfif acceso_uri("/sif/ad/catalogos/ClasificacionSocioNeg.cfm")>
        <li> 
            <a href="catalogos/ClasificacionSocioNeg.cfm">Clasificación de Artículos y Servicios para Socios de Negocio</a>
        </li>
    </cfif>
	<!---►►Impuestos◄◄--->
	<cfif acceso_uri("/sif/ad/catalogos/Impuestos.cfm")>
        <li> 
            <a href="/cfmx/sif/ad/catalogos/Impuestos.cfm"><cfoutput>#Request.Translate('Impuestos','Impuestos')#</cfoutput></a>
        </li>
	</cfif>
	<!---►►Retenciones◄◄--->
	<cfif acceso_uri("/sif/ad/catalogos/Retenciones.cfm")>
        <li> 
            <a href="/cfmx/sif/ad/catalogos/Retenciones.cfm">Retenciones</a>
        </li>
	</cfif>	
	<!---►►Clasificacion de Conceptos◄◄--->
	<cfif acceso_uri("/sif/ad/catalogos/CConceptos.cfm")>
        <li> 
            <a href="../ad/catalogos/CConceptos.cfm">Clasificaci&oacute;n de Conceptos de Servicio</a>
        </li>
    </cfif>
	<!---►►Matenimiento Catalogo Conceptos De Pagos a Terceros◄◄--->
	<cfif acceso_uri("/sif/tesoreria/reportes/ConceptoPagosTerceros.cfm")>
        <li> 
            <a href="/cfmx/sif/tesoreria/reportes/ConceptoPagosTerceros.cfm">Conceptos de Cobros Y Pagos Terceros</a>
        </li>
    </cfif>
	<!---►►Conceptos de Facturacion◄◄--->
	<cfif acceso_uri("/sif/ad/catalogos/Conceptos.cfm")>
        <li> 
            <a href="../ad/catalogos/Conceptos.cfm">Conceptos de Servicio</a>
        </li>
    </cfif>
	<!---►►Tipos de Eventos◄◄--->
	<cfif acceso_uri("/sif/ad/catalogos/TiposEventos.cfm")>
        <li> 
            <a href="/cfmx/sif/ad/catalogos/TiposEventos.cfm">Tipos de Eventos</a>
        </li>
    </cfif>
	<!---►►Datos Variables◄◄--->
	<cfif acceso_uri("/sif/ad/catalogos/DatosVariables.cfm")>
        <li> 
            <a href="/cfmx/sif/ad/catalogos/DatosVariables.cfm">Datos Variables</a>
        </li>
    </cfif>
	<!---►►Configuración de Datos Variables y Eventos◄◄--->
    <cfif acceso_uri("/sif/ad/catalogos/DatosVariablesConfig.cfm")>
        <li> 
            <a href="/cfmx/sif/ad/catalogos/DatosVariablesConfig.cfm">Configuración de Datos Variables y Eventos</a>
        </li>
    </cfif>
    <!---►►Actividad Empresarial◄◄--->
    <cfif acceso_uri("/sif/formulacion/catalogos/ActividadesEmpresa.cfm")>
        <li> 
            <a href="/cfmx/sif/formulacion/catalogos/ActividadesEmpresa.cfm">Actividad Empresarial</a>
        </li>
    </cfif>
</ul>
<cf_web_portlet_end>
<br />
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Consultas">
	<ul>
		<!---►►Cuentas Contables◄◄--->
		<cfif acceso_uri("/sif/ad/consultas/usuariosPermisos-filtro.cfm")>
			<li> 
				<a href="/cfmx/sif/ad/consultas/usuariosPermisos-filtro.cfm">Permisos por usuario</a>
			</li>
		</cfif>
		<!---►►Usuarios por permiso◄◄--->
		<cfif acceso_uri("/sif/ad/consultas/permisosUsuario-filtro.cfm")>
            <li> 
                <a href="/cfmx/sif/ad/consultas/permisosUsuario-filtro.cfm">Usuarios por permiso</a>
            </li>
		</cfif>
		<!---►►Socios por Clasificación◄◄--->
		<cfif acceso_uri("/sif/ad/consultas/SociosXClasificacion_form.cfm")>
            <li> 
                <a href="/cfmx/sif/ad/consultas/SociosXClasificacion_form.cfm">Socios por Clasificación</a>
            </li>
        </cfif>
        <!---►►Reporte Centro Funcional◄◄--->
        <cfif acceso_uri("/sif/ad/consultas/CFReporte.cfm")>
            <li> 
                <a href="/cfmx/sif/ad/consultas/CFReporte.cfm">Reporte Centro Funcional</a>
            </li>
       </cfif>
       <!---►►Consulta Socios X Clasificación◄◄--->
       <cfif acceso_uri("/sif/ad/consultas/CSociosXclasificacion.cfm")>
         <li>
			<a href="/cfmx/sif/ad/consultas/CSociosXclasificacion.cfm">Consulta Socios X Clasificación</a>
        </li>
      </cfif>
      <!---►►Consulta de Costos e Ingresos Automáticos◄◄--->
      <cfif acceso_uri("/sif/ad/consultas/costosIngresos-filtro.cfm")>
       <li>
			<a href="/cfmx/sif/ad/consultas/costosIngresos-filtro.cfm">Consulta de Costos e Ingresos Automáticos</a>
        </li>
     </cfif>
	</ul>
<cf_web_portlet_end>